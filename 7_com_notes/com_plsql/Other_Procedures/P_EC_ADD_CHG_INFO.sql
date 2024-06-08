-- 轉切換調查
-- insert t_ec_chg_info;



CREATE OR REPLACE PROCEDURE p_ec_add_chg_info(
    vareid IN VARCHAR2, --ec_id
    title IN VARCHAR2, --pdm title
    pdm_models IN VARCHAR2 -- pdm適用車系
 --OutResult     OUT VARCHAR2
) AS
    chgunit            VARCHAR2(1);
    chgunit2           VARCHAR2(10);
    ls_model           VARCHAR2(100);
    model2             VARCHAR2(100);
    undertake          VARCHAR2(100);
    undertake_isc      VARCHAR2(100);
    rtnwid             VARCHAR2(50);
    vendor_survey      VARCHAR2(50);
    varpl_id           INT;
    hadpl              INT;
    varcount           INT;
    li_wid             INT;
    cnt                INT;
    mday               INT;
    adpt               VARCHAR2(50);
    chg_info_id        INT;
    i                  INT;
    varcountsignlist   INT;
    varsectionid       VARCHAR2(10);
    varsign_level      VARCHAR2(30);
    varsign_list       VARCHAR2(2);
    varmail            VARCHAR2(100);
    varmail2           VARCHAR2(100);
    varmail3           VARCHAR2(100);
    vendor_list        VARCHAR2(512);
    vname_list         NVARCHAR2(1024);
    uname              NVARCHAR2(50);
    vartitle           NVARCHAR2(500);
    varmatter          NVARCHAR2(500);
    varchgmemo         NVARCHAR2(500);
    var_released_date  DATE;
    chg_sdate_max      DATE;
    rtnmid             VARCHAR2(50);
    varecnno           VARCHAR2(50);
    ok_flag            VARCHAR2(1);
    ad_flag            VARCHAR2(1);
    varplandate_psw    VARCHAR2(50);
 --    ad_chg          VARCHAR2(1);
    varchgsectionid    VARCHAR2(10);
 --chg要的零件清單，要廠商調查時
    CURSOR cur_survey_parts(
        ecid INT
    ) IS
    SELECT
        DISTINCT sp.pl_id,
        p.partno
    FROM
        t_ec_survey_parts sp
        INNER JOIN t_ec_pl_info p
        ON sp.pl_id = p.pl_id
    WHERE
        sp.ec_id = ecid
    ORDER BY
        sp.pl_id ASC;
    survey_parts_field cur_survey_parts%rowtype;
 --chg要的零件清單，無廠商調查時
    CURSOR cur_ec_pl(
        ecid INT
    ) IS
    SELECT
        p.pl_id,
        p.partno
    FROM
        t_ec_pl_info p
    WHERE
        p.ec_id = ecid -- 2017/2/24取消source判斷  and p.source in ('V','R')
    ORDER BY
        p.pl_id ASC;
    ec_pl_field        cur_ec_pl%rowtype;
 -- 字串切割，有逗點者
    CURSOR cur_strsplit2(
        v_str VARCHAR2
    ) IS
    SELECT
        engineid AS str2
    FROM
        TABLE(CAST(f_pub_split(v_str) AS mytabletype));
    c_field2           cur_strsplit2%rowtype;
 --車系承辦
    CURSOR cur_model_taker(
        mid2 VARCHAR2
    ) IS
 /*SELECT S377_UNDERTAKER, S391_UNDERTAKER, PAINT_UNDERTAKER, BODY_UNDERTAKER, MODE_UNDERTAKER, PD_MG_TAKER
          FROM t_anp_model
          WHERE model = mid2 OR (mid2='ALL' AND model='EC');*/
    SELECT
        (
            SELECT
                t.undertaker
            FROM
                t_anp_model_other t
            WHERE
                (t.model = mid2
                OR (mid2 = 'ALL'
                AND model = 'EC'))
                AND typeid = 'A02-1'
        ) AS s377_undertaker,
        (
            SELECT
                t.undertaker
            FROM
                t_anp_model_other t
            WHERE
                (t.model = mid2
                OR (mid2 = 'ALL'
                AND model = 'EC'))
                AND typeid = 'A02-2'
        ) AS s391_undertaker,
        (
            SELECT
                t.undertaker
            FROM
                t_anp_model_other t
            WHERE
                (t.model = mid2
                OR (mid2 = 'ALL'
                AND model = 'EC'))
                AND typeid = 'A02-3'
        ) AS paint_undertaker,
        (
            SELECT
                t.undertaker
            FROM
                t_anp_model_other t
            WHERE
                (t.model = mid2
                OR (mid2 = 'ALL'
                AND model = 'EC'))
                AND typeid = 'A02-4'
        ) AS body_undertaker,
        (
            SELECT
                t.undertaker
            FROM
                t_anp_model_other t
            WHERE
                (t.model = mid2
                OR (mid2 = 'ALL'
                AND model = 'EC'))
                AND typeid = 'A02-5'
        ) AS mode_undertaker,
        (
            SELECT
                t.undertaker
            FROM
                t_anp_model_other t
            WHERE
                (t.model = mid2
                OR (mid2 = 'ALL'
                AND model = 'EC'))
                AND typeid = 'A10-3'
        ) AS pd_mg_taker
    FROM
        dual;
    m_field            cur_model_taker%rowtype;
BEGIN
    p_ec_vname(vareid, vname_list); --抓取裕器,東陽
    SELECT
        e.vendor_list,
        e.released_date,
        e.vendor_survey,
        e.ecnno,
        e.adpt INTO vendor_list,
        var_released_date,
        vendor_survey,
        varecnno,
        adpt
    FROM
        t_ec_info e
    WHERE
        e.ec_id = vareid;
    IF adpt = 'A09-F' THEN
 --赤色手配  Red Release
        SELECT
            f_sys_glossary_getnamebyfield('A08-2', '2') INTO mday
        FROM
            dual; --赤色手配管控日期, 3天
    ELSE
        SELECT
            f_sys_glossary_getnamebyfield('A08-3', '3') INTO mday
        FROM
            dual; --切換管控日期, 14天
    END IF;

    ok_flag := 'Y';
    ad_flag := 'N';
    varchgmemo := title;
    FOR i IN 1 .. 3 LOOP
        chgunit := 'X';
        IF i = 1 THEN
            p_ec_other_unit(title, 'M', chgunit); --抓取切換調查單位
        END IF;

        IF i = 2 THEN
            p_ec_other_unit(title, 'I', chgunit); --抓取切換調查單位
        END IF;

        IF i = 3 THEN
            FOR c_field2 IN cur_strsplit2(pdm_models) LOOP
                varcount := 0;
                SELECT
                    COUNT(*) INTO varcount
                FROM
                    t_anp_model m
                WHERE
                    m.model = c_field2.str2
                    AND NOT m.model IN ('INS', '999', '91A', 'EC');
                IF varcount > 0 THEN
                    chgunit := 'P'; --生管
                    exit;
                END IF;
            END LOOP;
        END IF;

        IF chgunit <> 'X' THEN
            ls_model := '';
            undertake := '';
            IF chgunit = 'M' OR chgunit = 'I' THEN
 --M:行銷部  I:INFINITI
                ls_model := 'ALL'; --不分車系承辦
                chgunit2 := 'A13-' || chgunit;
                SELECT
                    f_sys_glossary_getnamebyfield(chgunit2, '1') INTO undertake
                FROM
                    dual; --依切換調查單位抓取承辦
            ELSE
                ls_model := pdm_models;
            END IF;

            FOR c_field2 IN cur_strsplit2(ls_model) LOOP
                model2 := c_field2.str2;
                IF ls_model <> 'ALL' THEN
 --生管車系承辦
                    IF instr('INS,999,91A,EC', model2) = 0 THEN
                        FOR m_field IN cur_model_taker(model2) LOOP
                            undertake := m_field.pd_mg_taker;
                        END LOOP;
                    END IF;
                END IF;

                IF undertake IS NOT NULL THEN
 --undertaker已決定, 用undertaker>>varSectionID抓取varSign_List
                    SELECT
                        e.name,
                        e.mailaddress INTO uname,
                        varmail
                    FROM
                        t_sys_employinfo e
                    WHERE
                        e.employno = undertake;
 --20210720:為避免承辦調科，零件切換單位不取承辦科別，取公用參數定義的零件切換單位科別
                    SELECT
                        COUNT(*) INTO varcount
                    FROM
                        t_sys_glossary g
                    WHERE
                        g.glossarytypeid LIKE 'A10%'
                        AND g.glossary3 = chgunit;
                    IF varcount <> 0 THEN
                        SELECT
                            g.glossary2 INTO varchgsectionid
                        FROM
                            t_sys_glossary g
                        WHERE
                            g.glossarytypeid LIKE 'A10%'
                            AND g.glossary3 = chgunit;
                    ELSE
                        IF chgunit = 'M' THEN
                            varchgsectionid := 'YNW0J00';
                        END IF;

                        IF chgunit = 'I' THEN
                            varchgsectionid := 'YNL0F00';
                        END IF;
                    END IF;

                    varsectionid := f_sys_employinfo_getsectid(undertake);
 --IF chgUnit='M' AND varSectionID<>'YNW0J00' THEN --行銷承辦換科
                    IF chgunit = 'M' AND varsectionid <> varchgsectionid THEN
 --行銷承辦換科
                        SELECT
                            f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-2', 2)) INTO varmail2
                        FROM
                            dual; --資管科
                        SELECT
                            f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-9', 2)) INTO varmail3
                        FROM
                            dual; --ISC
                        p_sys_mail_add(varmail2, varmail3, 'ESS行銷(產銷管理科)承辦離調職', uname, '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
                        ok_flag := 'N';
                    END IF;
 --IF chgUnit='I' AND varSectionID<>'YNL0F00' THEN --INFINITI
                    IF chgunit = 'I' AND varsectionid <> varchgsectionid THEN
 --INFINITI
                        SELECT
                            f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-2', 2)) INTO varmail2
                        FROM
                            dual; --資管科
                        SELECT
                            f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-9', 2)) INTO varmail3
                        FROM
                            dual; --ISC
                        p_sys_mail_add(varmail2, varmail3, 'ESS-INFINITI(通路管理科)承辦離調職', uname, '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
                        ok_flag := 'N';
                    END IF;

                    SELECT
                        COUNT(*) INTO varcountsignlist
                    FROM
                        t_sys_glossary g
                    WHERE
                        g.glossarytypeid LIKE 'A12-%'
                        AND g.glossary2 = 'Y'
                        AND g.glossary3 = varsectionid;
                    IF varcountsignlist > 0 THEN
                        SELECT
                            g.glossary1,
                            g.glossary4 INTO varsign_level,
                            varsign_list
                        FROM
                            t_sys_glossary g
                        WHERE
                            g.glossarytypeid LIKE 'A12-%'
                            AND g.glossary2 = 'Y'
                            AND g.glossary3 = varsectionid
                            AND ROWNUM = 1;
                    ELSE
                        varsign_list := NULL;
                    END IF;

                    hadpl := 0;
                    IF vendor_survey = 'Y' THEN
 --抓取T_EC_SURVEY_PARTS
                        FOR survey_parts_field IN cur_survey_parts(vareid) LOOP
                            varpl_id := survey_parts_field.pl_id;
                            cnt := 0;
                            varplandate_psw := '';
                            SELECT
                                COUNT(*) INTO cnt
                            FROM
                                t_anp_part p
                                JOIN t_anp_doc d
                                ON p.partid = d.partid
                            WHERE
                                p.dcpartno = survey_parts_field.partno
                                AND d.docddlid = 28;
                            IF cnt > 0 THEN
                                SELECT
                                    to_char(MAX(d.plandate), 'YYYY/MM/DD') INTO varplandate_psw
                                FROM
                                    t_anp_part p
                                    JOIN t_anp_doc d
                                    ON p.partid = d.partid
                                WHERE
                                    p.dcpartno = survey_parts_field.partno
                                    AND d.docddlid = 28;
                                IF varplandate_psw IS NOT NULL THEN
                                    varchgmemo := varchgmemo || ', PSW PLANDATE=' || varplandate_psw;
                                END IF;
                            END IF;

                            varcount := 0;
                            SELECT
                                COUNT(*) INTO varcount
                            FROM
                                t_ec_chg_info c
                            WHERE
                                c.ec_id = vareid
                                AND c.chg_unit = chgunit
                                AND c.car = model2
                                AND c.pl_id = varpl_id;
                            vartitle := 'ESS零件切換調查通知單(承辦).';
                            varmatter := '請進行' || varecnno || '零件' || survey_parts_field.partno || '切換填寫.';
                            IF varcount = 0 THEN
 --要新增
                                p_sys_mail_add(varmail, '', vartitle, '您好, ' || varmatter, '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
                                UPDATE t_sys_worklist w
                                SET
                                    w.comptime = sysdate
                                WHERE
                                    w.worklistid IN (
                                        SELECT
                                            c.worklistid
                                        FROM
                                            t_ec_chg_info c
                                        WHERE
                                            c.ec_id = vareid
                                            AND c.chg_unit = chgunit
                                            AND c.car = model2
                                            AND c.pl_id = varpl_id
                                    );
                                pa_sys_worklist.p_worklist_add(undertake, '13-02-07', vartitle, varmatter, rtnwid);
                                li_wid := to_number(rtnwid);
                                SELECT
                                    s_t_ec_chg_info.nextval INTO chg_info_id
                                FROM
                                    dual;
                                hadpl := 1;
                                ad_flag := 'Y';
 --20210720:為避免承辦調科，零件切換單位不取承辦科別，取公用參數定義的零件切換單位科別
                                SELECT
                                    COUNT(*) INTO varcount
                                FROM
                                    t_sys_glossary g
                                WHERE
                                    g.glossarytypeid LIKE 'A10%'
                                    AND g.glossary3 = chgunit;
                                IF varcount <> 0 THEN
                                    SELECT
                                        g.glossary2 INTO varsectionid
                                    FROM
                                        t_sys_glossary g
                                    WHERE
                                        g.glossarytypeid LIKE 'A10%'
                                        AND g.glossary3 = chgunit;
                                END IF;

                                INSERT INTO t_ec_chg_info -- A07-1 切換-承辦未接收
                                (
                                    chg_id,
                                    ec_id,
                                    pl_id,
                                    car,
                                    undertake,
                                    chg_date,
                                    worklistid,
                                    status,
                                    chg_unit,
                                    taker_unit,
                                    sign_level,
                                    sign_list,
                                    creater,
                                    create_date,
                                    chg_memo
                                ) VALUES (
                                    chg_info_id,
                                    vareid,
                                    varpl_id,
                                    model2,
                                    undertake,
                                    sysdate,
                                    li_wid,
                                    'A07-1',
                                    chgunit,
                                    varsectionid,
                                    varsign_level,
                                    varsign_list,
                                    'SYS',
                                    sysdate,
                                    varchgmemo
                                );
                            ELSE
                                hadpl := 1;
                            END IF;

                            varchgmemo := title;
                        END LOOP; --cur_ec_parts
                    ELSE
 --抓取該ec所有有設變的pl
                        FOR ec_pl_field IN cur_ec_pl(vareid) LOOP
                            varpl_id := ec_pl_field.pl_id;
                            cnt := 0;
                            varplandate_psw := '';
                            SELECT
                                COUNT(*) INTO cnt
                            FROM
                                t_anp_part p
                                JOIN t_anp_doc d
                                ON p.partid = d.partid
                            WHERE
                                p.dcpartno = ec_pl_field.partno
                                AND d.docddlid = 28;
                            IF cnt > 0 THEN
                                SELECT
                                    to_char(MAX(d.plandate), 'YYYY/MM/DD') INTO varplandate_psw
                                FROM
                                    t_anp_part p
                                    JOIN t_anp_doc d
                                    ON p.partid = d.partid
                                WHERE
                                    p.dcpartno = survey_parts_field.partno
                                    AND d.docddlid = 28;
                                IF varplandate_psw IS NOT NULL THEN
                                    varchgmemo := varchgmemo || ', PSW PLANDATE=' || varplandate_psw;
                                END IF;
                            END IF;

                            varcount := 0;
                            SELECT
                                COUNT(*) INTO varcount
                            FROM
                                t_ec_chg_info c
                            WHERE
                                c.ec_id = vareid
                                AND c.chg_unit = chgunit
                                AND c.car = model2
                                AND c.pl_id = varpl_id;
                            vartitle := 'ESS零件切換調查通知單(承辦):';
                            varmatter := '請進行' || varecnno || '零件' || ec_pl_field.partno || '切換填寫..';
                            IF varcount = 0 THEN
 --要新增
                                p_sys_mail_add(varmail, '', vartitle, '您好, ' || varmatter, '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
                                pa_sys_worklist.p_worklist_add(undertake, '13-02-07', vartitle, varmatter, rtnwid);
                                li_wid := to_number(rtnwid);
                                SELECT
                                    s_t_ec_chg_info.nextval INTO chg_info_id
                                FROM
                                    dual;
                                hadpl := 1;
                                ad_flag := 'Y';
                                INSERT INTO t_ec_chg_info -- A07-1 切換-承辦未接收
                                (
                                    chg_id,
                                    ec_id,
                                    pl_id,
                                    car,
                                    undertake,
                                    chg_date,
                                    worklistid,
                                    status,
                                    chg_unit,
                                    taker_unit,
                                    sign_level,
                                    sign_list,
                                    creater,
                                    create_date,
                                    chg_memo
                                ) VALUES (
                                    chg_info_id,
                                    vareid,
                                    varpl_id,
                                    model2,
                                    undertake,
                                    sysdate,
                                    li_wid,
                                    'A07-1',
                                    chgunit,
                                    varsectionid,
                                    varsign_level,
                                    varsign_list,
                                    'SYS',
                                    sysdate,
                                    varchgmemo
                                );
                            ELSE
 --您好, 請進行ECN-1700502零件01125 N1041切換填寫.., 無廠商調查!
                                hadpl := 1;
 --IF vendor_survey='N' THEN --#173
                                varcount := 0;
                                SELECT
                                    COUNT(*) INTO varcount
                                FROM
                                    t_ec_chg_info c
                                WHERE
                                    c.ec_id = vareid
                                    AND c.chg_unit = chgunit
                                    AND c.car = model2
                                    AND c.pl_id = varpl_id
                                    AND c.status <> 'A07-4';
                                IF varcount > 0 THEN
                                    p_sys_mail_add(varmail, '', vartitle, '您好, ' || varmatter || ', 無廠商調查!', '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
                                    UPDATE t_sys_worklist w
                                    SET
                                        w.comptime = sysdate
                                    WHERE
                                        w.worklistid IN (
                                            SELECT
                                                c.worklistid
                                            FROM
                                                t_ec_chg_info c
                                            WHERE
                                                c.ec_id = vareid
                                                AND c.chg_unit = chgunit
                                                AND c.car = model2
                                                AND c.pl_id = varpl_id
                                        );
                                    pa_sys_worklist.p_worklist_add(undertake, '13-02-07', vartitle, varmatter, rtnwid);
                                    li_wid := to_number(rtnwid);
                                    UPDATE t_ec_chg_info c
                                    SET
                                        c.worklistid = li_wid
                                    WHERE
                                        c.ec_id = vareid
                                        AND c.chg_unit = chgunit
                                        AND c.pl_id = varpl_id
                                        AND c.car = model2;
                                END IF;
 --END IF;
                            END IF;

                            varchgmemo := title;
                        END LOOP; --cur_ec_pl
                    END IF;

                    IF hadpl = 0 THEN
 --車系承辦, 無PL, 新增虛擬NA件號(記錄)
                        varpl_id := 0;
                        varcount := 0;
                        SELECT
                            COUNT(*) INTO varcount
                        FROM
                            t_ec_chg_info c
                        WHERE
                            c.ec_id = vareid
                            AND c.chg_unit = chgunit
                            AND c.pl_id = varpl_id
                            AND c.car = model2;
                        IF varcount = 0 THEN
 --要新增
                            pa_sys_worklist.p_worklist_add(undertake, '13-02-07', '零件切換調查通知單', '請承辦進行' || varecnno || '零件:NA 切換填寫', rtnwid);
                            li_wid := to_number(rtnwid);
                            SELECT
                                s_t_ec_chg_info.nextval INTO chg_info_id
                            FROM
                                dual;
                            vartitle := 'ESS零件切換調查通知單(無廠商調查)';
                            varmatter := '請承辦進行' || varecnno || ',零件:NA 切換填寫';
                            p_sys_mail_add(varmail, '', vartitle, varmatter, '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
                            ad_flag := 'Y';
                            INSERT INTO t_ec_chg_info -- A07-1 切換-承辦未接收
                            (
                                chg_id,
                                ec_id,
                                pl_id,
                                car,
                                undertake,
                                chg_date,
                                worklistid,
                                status,
                                chg_unit,
                                taker_unit,
                                sign_level,
                                sign_list,
                                creater,
                                create_date,
                                chg_memo
                            ) VALUES (
                                chg_info_id,
                                vareid,
                                varpl_id,
                                model2,
                                undertake,
                                sysdate,
                                li_wid,
                                'A07-1',
                                chgunit,
                                varsectionid,
                                varsign_level,
                                varsign_list,
                                'SYS',
                                sysdate,
                                varchgmemo
                            );
                        ELSE
 --IF vendor_survey='N' THEN --#173
                            varcount := 0;
                            SELECT
                                COUNT(*) INTO varcount
                            FROM
                                t_ec_chg_info c
                            WHERE
                                c.ec_id = vareid
                                AND c.chg_unit = chgunit
                                AND c.car = model2
                                AND c.pl_id = varpl_id
                                AND c.status <> 'A07-4';
                            IF varcount > 0 THEN
                                vartitle := 'ESS零件切換調查通知單(無廠商調查)';
                                varmatter := '請承辦進行' || varecnno || ',零件:NA 切換填寫';
                                p_sys_mail_add(varmail, '', vartitle, varmatter, '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
                                UPDATE t_sys_worklist w
                                SET
                                    w.comptime = sysdate
                                WHERE
                                    w.worklistid IN (
                                        SELECT
                                            c.worklistid
                                        FROM
                                            t_ec_chg_info c
                                        WHERE
                                            c.ec_id = vareid
                                            AND c.chg_unit = chgunit
                                            AND c.car = model2
                                            AND c.pl_id = varpl_id
                                    );
                                pa_sys_worklist.p_worklist_add(undertake, '13-02-07', vartitle, varmatter, rtnwid);
                                li_wid := to_number(rtnwid);
                                UPDATE t_ec_chg_info c
                                SET
                                    c.worklistid = li_wid
                                WHERE
                                    c.ec_id = vareid
                                    AND c.chg_unit = chgunit
                                    AND c.pl_id = varpl_id
                                    AND c.car = model2;
                            END IF;
 --END IF;
                        END IF;
                    END IF; --IF hadpl = 0 THEN
                END IF; --IF UNDERTAKE <> NULL THEN
                undertake := '';
            END LOOP; --car
 -- 新增P_EC_SUM記錄(chg), 統計用, vendor是ec的所有廠商
            cnt := 0;
            chg_sdate_max := NULL;
            SELECT
                COUNT(*) INTO cnt
            FROM
                t_ec_survey_info s
            WHERE
                s.ec_id = vareid
                AND survey_vendor_edate IS NOT NULL;
            IF cnt > 0 THEN
                SELECT
                    MAX(s.survey_vendor_edate) INTO chg_sdate_max --SURVEY_VENDOR_EDATE:結束分發廠商日期, 最後一項實際結束日期
                FROM
                    t_ec_survey_info s
                WHERE
                    s.ec_id = vareid
                GROUP BY
                    s.ec_id;
            END IF;

            IF chg_sdate_max IS NULL THEN
                chg_sdate_max := sysdate;
            END IF;

            cnt := 0;
            SELECT
                COUNT(*) INTO cnt
            FROM
                t_ec_sum s
            WHERE
                s.report_type = 'C'
                AND s.ec_id = vareid
                AND s.unit = chgunit;
            IF cnt > 0 THEN
                UPDATE t_ec_sum s
                SET
                    s.vendor_list_na = vname_list,
                    s.sdate = chg_sdate_max,
                    s.pdate = chg_sdate_max + mday
                WHERE
                    s.report_type = 'C'
                    AND s.ec_id = vareid
                    AND s.unit = chgunit;
            ELSE
                INSERT INTO t_ec_sum (
                    report_type,
                    ec_id,
                    unit,
                    vendor_list_id,
                    vendor_list_na,
                    status,
                    sdate,
                    pdate,
                    creater,
                    create_date,
                    modifyer,
                    modify_date
                ) VALUES (
                    'C',
                    vareid,
                    chgunit,
                    vendor_list,
                    vname_list,
                    'A19-1',
                    chg_sdate_max,
                    chg_sdate_max + mday,
                    'SYS',
                    sysdate,
                    'SYS',
                    sysdate
                );
            END IF;

            COMMIT;
        END IF; --IF chgUnit <> 'X' THEN
    END LOOP; --i IN 1..3

 /* #173
    "1.廠商調查單的作業如果有一個承辦中斷業務(非本組業務)時，其他承辦的作業仍然要繼續進行不能暫停.(已於問題點37修正)
    2.零件切換調查如果有承辦點選""退回-須執行調查""時，其他承辦的單據必須要暫停，等廠商調查完成或再次送到生管後再繼續全部承辦的零件切換資訊.
    12/16 (1)與生管確認後，在A06當有承辦確認須執行廠商調查時，須將所有零件切換承辦的狀態暫停，等廠商調查執行完成之後再進行所有零件切換單重新填寫(由待處理開始).
    (2)當退回資管科重新確認後，發現這張設通單不須執行廠商調查，資管科退回零件切換單後須由原本的零件切換狀態繼續執行."
    
    "1. P_EC_ECCHGLIST_PG, A06LIST加入t_ec_info.status<>'A04-3'條件.
    2. A06退回-須執行調查：該ECN所有零件切換單承辦的待辦完成之，該切換單狀態保留不變更。
    3. A04產生切換單：資管科認為不用廠商調查時，已存在的切換單要重新發E-MAIL、產生待辦，切換狀態不更改；若資管科認為要調查，所有切換狀態改為A07-1待處理。"
    */

    IF vendor_survey = 'Y' THEN
 --#173
        UPDATE t_ec_chg_info c
        SET
            c.status = 'A07-1' --待處理
        WHERE
            c.ec_id = vareid;
    END IF;
 --    IF hadpl = 0 THEN --不調查，且無V件，知會用，只看設通單
 --        OutResult := 'ok';
 --    END IF;
    IF ok_flag = 'Y' THEN
 --有問題維持A04-1, A04重新分發
        UPDATE t_ec_info e
        SET
            e.status = 'A04-4'
        WHERE
            e.ec_id = vareid
            AND e.status <> 'A04-5'
            AND (
                SELECT
                    COUNT(*)
                FROM
                    t_ec_chg_info c
                WHERE
                    c.ec_id = vareid
            ) > 0; --零件切換中
    END IF;

    IF ad_flag = 'Y' THEN
 --切換單位補新增時
        UPDATE t_ec_info e
        SET
            e.status = 'A04-4'
        WHERE
            e.ec_id = vareid
            AND e.status = 'A04-5'; --結案改為切換中
    ELSE
        varcount := 0;
        SELECT
            COUNT(*) INTO varcount
        FROM
            t_ec_chg_info c
        WHERE
            c.ec_id = vareid;
        IF varcount = 0 THEN
            SELECT
                f_sys_glossary_getnamebyfield('A14-2', 2) INTO undertake
            FROM
                dual; --資管科窗口 920286
            SELECT
                f_sys_glossary_getnamebyfield('A14-9', 2) INTO undertake_isc
            FROM
                dual; --ISC
            p_sys_mail_add(undertake, undertake_isc, 'ESS【異常提醒】t_ec_chg_info零件切換單沒有產生記錄-' || to_char(sysdate, 'YYYYMMDD'), varecnno || ' >> 1.新車系未建立 2.承辦離調職', '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
            pa_sys_worklist.p_worklist_add(undertake, '13-02-08', '【異常提醒】設變調查e化-廠商分發', --主旨
            '【異常提醒】零件切換單沒有產生記錄', --內容
            rtnwid);
            li_wid := to_number(rtnwid);
            UPDATE t_sys_worklist w
            SET
                w.comptime = sysdate
            WHERE
                w.worklistid IN (
                    SELECT
                        e.worklistid
                    FROM
                        t_ec_info     e
                    WHERE
                        e.status = 'A04-6'
                        AND e.worklistid = 0
                );
            UPDATE t_ec_info e
            SET
                e.worklistid = li_wid,
                e.status = 'A04-6'
            WHERE
                e.ec_id = vareid;
        END IF;
    END IF;

    COMMIT;
 --    IF OutResult IS NULL THEN
 --      OutResult := 'ok';
 --    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
 --OutResult := 'error';
        dbms_output.put_line('err=' || sqlerrm);
END p_ec_add_chg_info;