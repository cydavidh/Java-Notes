PROCEDURE P_EC_SURVEYSTATUS_SDO( -- 更新各階段的status
VARSTEP IN VARCHAR2,
VARKEYID IN VARCHAR2,
VARSTATUS IN VARCHAR2,
VARUNDERTAKER IN VARCHAR2,
VARSIGN_COMMENT IN VARCHAR2,
VAROVERDUEREASONDESCRIPTION IN NVARCHAR2,
OUTRESULT OUT VARCHAR2
) IS
ROWS NUMBER;

ROWS2 NUMBER;

RETURNWKID NUMBER;

VARWKID NUMBER;

--varSIGN_NOW    number;
--varSIGN_LEADER number;
--varSIGN_LIST   number;
VARTAKER VARCHAR2(10);

VAREC_ID NUMBER;

VARSID NUMBER;

VARNAME VARCHAR2(200);

VARPOSITIONNA VARCHAR2(200);

VARHISTNUM VARCHAR(3);

VARECNNO VARCHAR2(20);

VARSTATUS2 VARCHAR2(20);

VARVENDOR VARCHAR2(20);

VARLEADER VARCHAR2(20);

VARUT_UNITID VARCHAR2(10);

VARSURVEY_TAKER VARCHAR2(20);

VARSIGN_LIST CHAR(1);

VARSIGN_NOW CHAR(1);

VARSENDMAN VARCHAR2(20);

VARCOMMENT NVARCHAR2(1000);

VARTITLE NVARCHAR2(1000);

VARPDMMODELS VARCHAR2(200);

VARMAIL VARCHAR2(250);

VARMAIL2 VARCHAR2(250);

VARRV CHAR(1);

NEWWORKLISTID VARCHAR2(200);

VARUT_UNITNA VARCHAR2(30);

v_semail       varchar2(100);  --收件者

v_semail_na    varchar2(100);  --收件者姓名

v_ccmail       varchar2(500);  --副本

v_title        varchar2(100);  --主旨

v_body         varchar2(30000);  --內容1

VarContent     varchar2(32767);  --內容

VARRESULT VARCHAR2(10);

--SANYI_該科所有承辦
CURSOR SANYI_TAKER(ECID VARCHAR2, GRPID VARCHAR2) IS

SELECT
    DISTINCT ss.undertaker
FROM
    t_ec_sanyi ss
WHERE
    ss.ec_id_fk=ecid
    AND ss.sanyi_unit=grpid;

S_FIELD SANYI_TAKER%ROWTYPE;

CURSOR CUR_MAILADDRESS IS

SELECT
    b.mailaddress
FROM
    t_sys_employinfo  b,
    t_sys_useraccount a
WHERE
    b.employno = a.userid
    AND a.groupid = 'PISGroup1';

BEGIN
    IF varstep = 'A11SendV' THEN
        SELECT
            s.survey_taker,
            i.ecnno,
            s.dist_vendor|| ' ' || sp.suppliername,
            sp.suppliername,
            '',
            to_char(decode(s.sign_history, NULL, 1, substr(s.sign_history, 0, instr(s.sign_history, '.')-1)+1)) INTO varsurvey_taker,
            varecnno,
            varvendor,
            varname,
            varpositionna,
            varhistnum
        FROM
            t_ec_survey_info s
            JOIN t_ec_info i
            ON s.ec_id = i.ec_id
            JOIN t_anp_supplier sp
            ON s.dist_vendor = sp.suppliercode
        WHERE
            s.survey_id = varkeyid;
    ELSE
 --取得簽核歷程用之姓名及職稱
        IF varstep <> 'A11LOAD' AND varstep <> 'A11_LoadSaveC' AND varstep <> 'A11_LoadSaveM' THEN
            SELECT
                e.name,
                e.positionna INTO varname,
                varpositionna
            FROM
                t_sys_employinfo e
            WHERE
                e.employno = varundertaker;
        END IF;

        IF varstep = 'A11SendY' OR varstep = 'A11Agree' OR varstep = 'A11Reject' THEN
 --取得簽核歷程用之流水號
            SELECT
                DISTINCT to_char(decode(s.sign_history, NULL, 1, substr(s.sign_history, 0, instr(s.sign_history, '.')-1)+1)),
                s.worklistid,
                i.ecnno,
                s.dist_vendor|| ' ' || sp.suppliername,
                s.sign_leader,
                s.ut_unitid,
                s.survey_taker,
                s.sign_list,
                s.sign_now INTO varhistnum,
                varwkid,
                varecnno,
                varvendor,
                varleader,
                varut_unitid,
                varsurvey_taker,
                varsign_list,
                varsign_now
            FROM
                t_ec_survey_info s
                JOIN t_ec_info i
                ON s.ec_id = i.ec_id
                JOIN t_anp_supplier sp
                ON s.dist_vendor = sp.suppliercode
            WHERE
                s.survey_id = varkeyid;
        ELSIF varstep = 'A06sendNg' OR varstep = 'A06send' THEN
 --取得簽核歷程用之流水號
            SELECT
                DISTINCT MAX(to_char(decode(c.sign_history, NULL, 1, substr(c.sign_history, 0, instr(c.sign_history, '.')-1)+1))),
                c.sign_leader,
                i.ecnno,
                c.taker_unit,
                e.deptna,
                c.sign_list,
                c.sign_now INTO varhistnum,
                varleader,
                varecnno,
                varut_unitid,
                varut_unitna,
                varsign_list,
                varsign_now
            FROM
                t_ec_chg_info    c
                JOIN t_ec_info i
                ON c.ec_id = i.ec_id
                JOIN t_sys_employinfo e
                ON c.taker_unit = e.unitid
            WHERE
                i.ec_id = varkeyid
                AND (e.employno = varundertaker
                OR f_ec_poweruser(varundertaker) = 1)
                AND c.status = varstatus
            GROUP BY
                c.sign_leader,
                i.ecnno,
                c.taker_unit,
                e.deptna,
                c.sign_list,
                c.sign_now;
        ELSIF varstep = 'A06chkOk' OR varstep = 'A06chkNg' THEN
 --取得簽核歷程用之流水號
            SELECT
                DISTINCT MAX(to_char(decode(c.sign_history, NULL, 1, substr(c.sign_history, 0, instr(c.sign_history, '.')-1)+1))),
                c.sign_leader,
                i.ecnno,
                c.taker_unit,
                c.sign_list,
                c.sign_now INTO varhistnum,
                varleader,
                varecnno,
                varut_unitid,
                varsign_list,
                varsign_now
            FROM
                t_ec_chg_info    c
                JOIN t_ec_info i
                ON c.ec_id = i.ec_id
                JOIN t_sys_employinfo e
                ON c.taker_unit = e.unitid
            WHERE
                i.ec_id = varkeyid
                AND (e.employno = varundertaker
                OR f_ec_poweruser(varundertaker) = 1)
                AND c.status = varstatus
            GROUP BY
                c.sign_leader,
                i.ecnno,
                c.taker_unit,
                c.sign_list,
                c.sign_now;
        ELSIF (varstep = 'A15send'
        OR varstep = 'A15chkOk'
        OR varstep = 'A15chkNg'
        OR varstep = 'A15notSelf') THEN
 --取得(該科)簽核歷程用之流水號
 --201811, jessica盧科長015469隸屬單位在生技部經理室(K0A00)但O人令權限設定在377總裝組(K0L00)
            SELECT
                DISTINCT to_char(decode(su.sign_history, NULL, 1, substr(su.sign_history, 0, instr(su.sign_history, '.')-1)+1)),
                i.ecnno,
                sp.suppliercode|| ' ' || sp.suppliername,
                s.sign_leader,
                s.sanyi_unit,
                sp.suppliername,
                s.sign_list,
                s.sign_now,
                s.survey_id_fk,
                i.title,
                i.pdm_models INTO varhistnum,
                varecnno,
                varvendor,
                varleader,
                varut_unitid,
                varut_unitna,
                varsign_list,
                varsign_now,
                varsid,
                vartitle,
                varpdmmodels
            FROM
                t_ec_sanyi      s
                INNER JOIN t_ec_info i
                ON s.ec_id_fk=i.ec_id
                INNER JOIN t_anp_supplier sp
                ON sp.suppliercode='SANYI'
                LEFT JOIN t_ec_sanyi_unit su
                ON s.survey_id_fk=su.survey_id_fk2
                AND s.sanyi_unit=su.sanyi_unit2
            WHERE
                s.ec_id_fk=varkeyid
                AND (s.sanyi_unit = f_sys_employinfo_getsectid(varundertaker)
                OR varundertaker = f_sys_employinfo_getleaderbyse(s.sanyi_unit));
        END IF;
    END IF;

    CASE varstep
 --// -> 處理中
        WHEN 'A06LOAD' THEN
            UPDATE t_ec_chg_info s
            SET
                status = 'A07-2',
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                ec_id = varkeyid
                AND status = 'A07-1'
                AND (undertake = varundertaker
                OR f_ec_poweruser(varundertaker) = 1);
        WHEN 'A06send' THEN --完成送出
            varcomment:=varsign_comment;
            IF varcomment IS NULL THEN
                varcomment:='承辦呈送!';
            END IF;
 --3.5.2 零件切換調查狀態設為A07-6切換-承辦送出完成；該生管的待辦完成之。
            UPDATE t_sys_worklist
            SET
                comptime=sysdate --更新待辦事項
            WHERE
                comptime IS NULL
                AND worklistid IN (
                    SELECT
                        worklistid
                    FROM
                        t_ec_chg_info
                    WHERE
                        ec_id = varkeyid
                        AND status = varstatus
                        AND (undertake = varundertaker
                        OR f_ec_poweruser(varundertaker) = 1)
                );
            UPDATE t_ec_chg_info s
            SET
                status = 'A07-6',
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                ec_id = varkeyid
                AND taker_unit = varut_unitid
                AND (undertake = varundertaker
                OR f_ec_poweruser(varundertaker) = 1);
            UPDATE t_ec_chg_info s
            SET
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 呈送零件切換調查，意見：' || varcomment || chr(
                    10
                ) || sign_history,
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                ec_id = varkeyid
                AND taker_unit = varut_unitid
                AND (undertake = varundertaker
                OR f_ec_poweruser(varundertaker) = 1);
 --3.5.3 該ECN+科的所有零件切換調查狀態皆已承辦送出(A07-6)
            SELECT
                COUNT(*) INTO rows --所有切換調查完成
            FROM
                t_ec_chg_info
            WHERE
                ec_id = varkeyid
                AND taker_unit = varut_unitid
                AND status <> 'A07-6';
            IF rows = 0 THEN
 --主管審核List(Sign_List)為空白時：零件切換調查狀態設為A07-4切換-主管審核完成，設通單狀態設為A04-5資管科_結案；
                IF varsign_list IS NULL THEN
                    UPDATE t_ec_chg_info s
                    SET
                        status = 'A07-4',
                        sign_now = '0'
                    WHERE
                        ec_id = varkeyid
                        AND taker_unit = varut_unitid
                        AND status = 'A07-6';
 --所有切換調查完成，設通單也完成
                    UPDATE t_ec_info
                    SET
                        status = 'A04-5',
                        isalert = 'N',
                        modifyer=varundertaker,
                        modify_date=sysdate
                    WHERE
                        ec_id = varkeyid;
 --A06chkOk(最後一張調查單時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A07-4 確認-主管審核完成，且生管部回覆日期<=預計答覆日, T_EC_SUM.status = A19-3
 --P_EC_STATUS_CAL(varkeyId);
                    UPDATE t_ec_sum
                    SET
                        status = 'A19-3',
                        rdate = sysdate,
                        modifyer=varundertaker,
                        modify_date=sysdate
                    WHERE
                        ec_id = varkeyid
                        AND report_type = 'C'
                        AND unit IN (
                            SELECT
                                s.glossary3
                            FROM
                                t_sys_glossary   s
                            WHERE
                                s.glossarytypeid LIKE 'A10-%'
                                AND s.glossary2 = varut_unitid
                        )
                        AND to_char(sysdate, 'YYYYMMDD') <= to_char(pdate, 'YYYYMMDD');
 --A06chkOk(最後一張調查單時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A07-4 確認-主管審核完成，且生管部回覆日期>預計答覆日, T_EC_SUM.status = A19-4
                    UPDATE t_ec_sum
                    SET
                        status = 'A19-4',
                        rdate = sysdate,
                        modifyer=varundertaker,
                        modify_date=sysdate
                    WHERE
                        ec_id = varkeyid
                        AND report_type = 'C'
                        AND unit IN (
                            SELECT
                                s.glossary3
                            FROM
                                t_sys_glossary   s
                            WHERE
                                s.glossarytypeid LIKE 'A10-%'
                                AND s.glossary2 = varut_unitid
                        )
                        AND to_char(sysdate, 'YYYYMMDD') > to_char(pdate, 'YYYYMMDD');
                ELSE
 --3.5.4 該ECN所有零件切換調查狀態皆已承辦送出(A07-6)且主管審核List(Sign_List)為非空白時：?ECN+科的所有承辦的零件切換調查狀態設為A07-3切換-主管審核中，新增審核主管待辦事項
                    UPDATE t_ec_chg_info s
                    SET
                        status = 'A07-3',
                        sign_now = decode(
                            sign_leader,
                            NULL,
                            1,
                            0
                        ),
                        isalert = 'N'
                    WHERE
                        ec_id = varkeyid
                        AND status = 'A07-6'
                        AND taker_unit = varut_unitid;
 --5.1.6 產生下一關(若Leader有值則送給Leader，若Leader為空則送給切換單位之科主管)的待辦。
                    IF varleader IS NOT NULL THEN
                        varsendman := varleader;
                    ELSE
                        SELECT
                            f_sys_employinfo_getleaderbyse(varut_unitid) INTO varsendman
                        FROM
                            dual;
                    END IF;

                    pa_sys_worklist.p_worklist_add(varsendman, --對象
                    '13-02-07', --功能選單ID
                    varecnno || ' 零件切換調查 請審核', --主旨
                    varecnno || ' 零件切換調查 請審核', --內容
                    newworklistid --成功:WorkListID;  失敗:-1
                    );
                    UPDATE t_ec_chg_info s
                    SET
                        s.worklistid = newworklistid
                    WHERE
                        ec_id = varkeyid
                        AND status = 'A07-3'
                        AND taker_unit = varut_unitid;
                END IF;
            END IF;
        WHEN 'A06chkOk' THEN --審核同意
 --4.1.1 該主管的待辦完成
            UPDATE t_sys_worklist
            SET
                comptime=sysdate
            WHERE
                comptime IS NULL
                AND worklistid IN (
                    SELECT
                        worklistid
                    FROM
                        t_ec_chg_info
                    WHERE
                        ec_id = varkeyid
                        AND taker_unit = varut_unitid
                );
            varcomment:=varsign_comment;
            IF varcomment IS NULL THEN
                varcomment:='審核同意!';
            END IF;
 --4.1.2  若非最後一關卡(Sign_List <>Sign_Now），呈送下一關卡進行審核：Sign_Now = Sign_Now + 1；新增下一關主管待辦事項。
            IF (varsign_list <> varsign_now) THEN
 --Sign_Now = Sign_Now + 1
                varsign_now := varsign_now+1;
                UPDATE t_ec_chg_info
                SET
                    sign_now = varsign_now,
                    sign_history = varhistnum ||'.' || to_char(
                        sysdate,
                        'yyyy/mm/dd HH24:MM:SS'
                    ) || ' ' || varname || ' ' || varpositionna|| ' 同意零件切換調查，意見：' || varcomment || chr(
                        10
                    ) || sign_history,
                    isalert = 'N'
                WHERE
                    ec_id = varkeyid
                    AND status = varstatus
                    AND taker_unit = varut_unitid;
 --5.2.3.2  下一關卡人員為取調查科別所屬T_SYS_LEADERLAYER的第幾N個工號(N即為T_EC_SURVEY_INFO.Sign_Now）
 --科長:substr(depusrid,0,6),副理:substr(depusrid,8,6),經理:substr(depusrid,15,6)
                SELECT
                    substr(depusrid, decode(varsign_now, 1, 0, decode(varsign_now, 2, 8, 15)), 6) INTO varsendman
                FROM
                    t_sys_leaderlayer
                WHERE
                    id = varut_unitid;
 --5.2.6 新增下一關卡待辦
                pa_sys_worklist.p_worklist_add(varsendman, --對象
                '13-02-07', --功能選單ID
                varecnno || ' 零件切換調查 請審核', --主旨
                varecnno || ' 零件切換調查 請審核', --內容
                newworklistid --成功:WorkListID;  失敗:-1
                );
                UPDATE t_ec_chg_info
                SET
                    worklistid = newworklistid
                WHERE
                    ec_id = varkeyid
                    AND status = varstatus
                    AND taker_unit = varut_unitid;
            ELSE
 --　4.1.3  若為最後一關卡(Sign_List = Sign_Now)：零件切換調查狀態設為A07-4切換-主管審核完成，設通單狀態設為A04-5資管科_結案
                UPDATE t_ec_chg_info s
                SET
                    status = 'A07-4',
                    sign_history = varhistnum ||'.' || to_char(
                        sysdate,
                        'yyyy/mm/dd HH24:MM:SS'
                    ) || ' ' || varname || ' ' || varpositionna|| ' 同意零件切換調查，意見：' || varcomment || chr(
                        10
                    ) || sign_history,
                    modifyer = varundertaker,
                    modify_date = sysdate
                WHERE
                    ec_id = varkeyid
                    AND status = varstatus
                    AND taker_unit = varut_unitid;
 --3.5.3 該ECN所有零件切換調查狀態皆已 A07-4切換-主管審核完成
                SELECT
                    COUNT(*) INTO rows --所有切換調查  主管審核完成
                FROM
                    t_ec_chg_info
                WHERE
                    ec_id = varkeyid
                    AND status <> 'A07-4';
                IF rows = 0 THEN
                    UPDATE t_ec_info
                    SET
                        status = 'A04-5',
                        isalert = 'N',
                        modifyer=varundertaker,
                        modify_date=sysdate
                    WHERE
                        ec_id = varkeyid;
 --A06chkOk(最後一張調查單時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A07-4 確認-主管審核完成，且生管部回覆日期<=預計答覆日, T_EC_SUM.status = A19-3
 --P_EC_STATUS_CAL(varkeyId);
                    UPDATE t_ec_sum
                    SET
                        status = 'A19-3',
                        rdate = sysdate,
                        modifyer=varundertaker,
                        modify_date=sysdate
                    WHERE
                        ec_id = varkeyid
                        AND report_type = 'C'
                        AND unit IN (
                            SELECT
                                s.glossary3
                            FROM
                                t_sys_glossary   s
                            WHERE
                                s.glossarytypeid LIKE 'A10-%'
                                AND s.glossary2 = varut_unitid
                        )
                        AND pdate > sysdate;
 --A06chkOk(最後一張調查單時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A07-4 確認-主管審核完成，且生管部回覆日期>預計答覆日, T_EC_SUM.status = A19-4
                    UPDATE t_ec_sum
                    SET
                        status = 'A19-4',
                        rdate = sysdate,
                        modifyer=varundertaker,
                        modify_date=sysdate
                    WHERE
                        ec_id = varkeyid
                        AND report_type = 'C'
                        AND unit IN (
                            SELECT
                                s.glossary3
                            FROM
                                t_sys_glossary   s
                            WHERE
                                s.glossarytypeid LIKE 'A10-%'
                                AND s.glossary2 = varut_unitid
                        )
                        AND pdate <= sysdate;
                END IF;
            END IF;
        WHEN 'A06chkNg' THEN --審核退回
            varcomment:=varsign_comment;
            IF varcomment IS NULL THEN
                varcomment:='審核退回!';
            END IF;
 --4.2.1 零件切換調查狀態設為A07-5 切換-主管退回承辦；該主管的待辦完成之。
            UPDATE t_ec_chg_info s
            SET
                status = 'A07-5',
                sign_now = decode(
                    sign_leader,
                    NULL,
                    1,
                    0
                ),
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 退回零件切換調查，意見：' || varcomment || chr(
                    10
                ) || sign_history,
                isalert = 'N',
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                ec_id = varkeyid
                AND status = varstatus
                AND taker_unit = varut_unitid;
            rows := sql%rowcount;
            IF rows > 0 THEN
                UPDATE t_sys_worklist
                SET
                    comptime=sysdate --更新待辦事項
                WHERE
                    comptime IS NULL
                    AND worklistid IN (
                        SELECT
                            worklistid
                        FROM
                            t_ec_chg_info
                        WHERE
                            ec_id = varkeyid
                            AND taker_unit = varut_unitid
                    );
 --取得該ECN+科的所有承辦
                DECLARE
                    CURSOR dc_cur IS
                    SELECT
                        c.undertake
                    FROM
                        t_ec_chg_info c
                    WHERE
                        ec_id = varkeyid
                        AND taker_unit = varut_unitid;
                BEGIN
                    OPEN dc_cur;
                    LOOP
                        FETCH dc_cur INTO varsurvey_taker;
                        EXIT WHEN dc_cur%notfound;
                        pa_sys_worklist.p_worklist_add(varsurvey_taker, --對象
                        '13-02-07', --功能選單ID
                        varecnno || ' 零件切換調查 主管退回，請承辦重新確認', --主旨
                        varecnno || ' 零件切換調查 主管退回，請承辦重新確認', --內容
                        newworklistid --成功:WorkListID;  失敗:-1
                        );
                        UPDATE t_ec_chg_info s
                        SET
                            s.worklistid = newworklistid
                        WHERE
                            ec_id = varkeyid
                            AND status = 'A07-5'
                            AND taker_unit = varut_unitid
                            AND undertake = varsurvey_taker;
                    END LOOP;

                    CLOSE dc_cur;
                END;
            END IF;
 --//退回-須執行調查sendNg & 完成送出send & 審核同意chkOk & 審核退回chkNg, by ecn為單位
        WHEN 'A06sendNg' THEN --3.3 退回-須執行調查：將該ECN退回YNTC資管科(設通單狀態A04-3 零件切換_退回，新增待辦)，再確認是否要先執行調查；該生管的待辦完成之。
            varcomment:=varsign_comment;
            IF varcomment IS NULL THEN
                varcomment:='退回-須執行調查!';
            END IF;
            UPDATE t_ec_chg_info s
            SET
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 退回，意見：' || varcomment || chr(
                    10
                ) || sign_history,
                modifyer=varundertaker,
                modify_date=sysdate
 --, s.status = 'A07-7' --切換-承辦退回資管, 問題173
            WHERE
                ec_id = varkeyid
                AND status IN ('A07-2', 'A07-5')
                AND (undertake = varundertaker
                OR f_ec_poweruser(varundertaker) = 1);
            UPDATE t_ec_info s
            SET
                status = 'A04-3',
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                ec_id = varkeyid;
            UPDATE t_sys_worklist
            SET
                comptime=sysdate --更新待辦事項
            WHERE
                worklistid IN (
                    SELECT
                        worklistid
                    FROM
                        t_ec_chg_info
                    WHERE
                        ec_id = varkeyid
                ) --and UNDERTAKE = varUndertaker, 問題173
                AND comptime IS NULL;
            SELECT
                g.glossary2 INTO varsendman
            FROM
                t_sys_glossary g
            WHERE
                g.glossarytypeid = 'A14-2';
 --5.2.4.2.2 新增資管科承辦(公用參數A14-2)待辦
            pa_sys_worklist.p_worklist_add(varsendman, --對象
            '13-02-08', --功能選單ID
            varecnno || ' 零件切換調查 退回-須執行調查，請確認', --主旨
            varecnno || ' 零件切換調查 退回-須執行調查，請確認', --內容
            newworklistid --成功:WorkListID;  失敗:-1
            );
            UPDATE t_ec_info i
            SET
                i.worklistid = newworklistid
            WHERE
                ec_id = varkeyid;
 -- 發送Email給資管窗口 CC資管主管
 --資管窗口
            SELECT
                e.mailaddress,
                e.name INTO v_semail,
                v_semail_na
            FROM
                t_sys_employinfo e
                INNER JOIN t_sys_glossary g
                ON e.employno = g.glossary2
            WHERE
                g.glossarytypeid = 'A14-2'
                AND e.inservice = 'Y';
 --資管主管

 /*           select e.mailaddress into v_ccmail
           from T_SYS_EMPLOYINFO e
           where e.unitid in (
                 select distinct e.unitid
                 from T_SYS_EMPLOYINFO e
                 inner join T_SYS_GLOSSARY g on e.employno = g.glossary2
                 where g.glossarytypeid = 'A14-2' and e.INSERVICE = 'Y' )
           and INSERVICE = 'Y' AND POSITIONTYPE <> 11;*/
            v_title := 'ESS<退回通知>'|| varut_unitna ||'退回廠商或零件切換調查';
            v_body := v_semail_na ||' 先生/小姐 您好：<br>' || varut_unitna || '退回設通單' || varecnno ||'，請進入設變調查e化系統執行EC>>管理>>「分發廠商調整」功能。';
            varcontent := '<html><head></head><body><P>'|| v_body ||'</P></body></html>';
            p_sys_mail_add(v_semail, v_ccmail, v_title, varcontent, '', 'Y', '', '', varresult);
            IF varresult = '-1' THEN
                ROLLBACK;
                return;
            END IF;
        WHEN 'A15LOAD' THEN --ccc
            IF varstatus = 'A06-D' THEN --承辦待處理A06-D -> 處理中A06-E
                UPDATE t_ec_sanyi ss
                SET
                    status = 'A06-E',
                    modifyer=varundertaker,
                    modify_date=sysdate
                WHERE
                    ec_id_fk = varkeyid
                    AND undertaker = varundertaker;
            END IF;

            IF varstatus = 'A06-G' THEN --確認-主管待處理A06-G -> 確認-主管審核中A06-I
                UPDATE t_ec_sanyi ss
                SET
                    status = 'A06-I',
                    modifyer=varundertaker,
                    modify_date=sysdate
                WHERE
                    ec_id_fk = varkeyid
                    AND ss.sanyi_unit=varut_unitid;
            END IF;
 --3.2 完成送出按鈕：將T_EC_SANYI該ECN,該承辦的狀態改為A06-F(確認-承辦完成), 該承辦待辦完成
 --3.2.1 該ECN,該科所有記錄的狀態皆為「A06-F」時呈送主管審核(T_EC_SANYI狀態改為A06-G, 新增待辦)
        WHEN 'A15send' THEN --判斷給Lader或主管
            varstatus2:='A06-F'; --確認-承辦完成
            varcomment:=varsign_comment;
            IF varcomment IS NULL THEN
                varcomment:='承辦呈送!';
            END IF;
        WHEN 'A15notSelf' THEN
            varstatus2:='A06-L'; --確認-非本組業務
            varcomment:=varsign_comment;
            IF varcomment IS NULL THEN
                varcomment:='非本組業務!';
            END IF;
 -- 主管退回A15chkNg、主管同意A15chkOk、完成送出A15send、非本組業務A15notSelf
        WHEN 'A15chkNg' THEN
            UPDATE t_ec_sanyi s
            SET
                status = 'A06-J' --確認-主管退回承辦
,
                isalert = 'N',
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                s.ec_id_fk = varkeyid
                AND s.sanyi_unit = varut_unitid;
            UPDATE t_sys_worklist
            SET
                comptime=sysdate --待辦完成
            WHERE
                worklistid IN (
                    SELECT
                        worklistid
                    FROM
                        t_ec_sanyi       s
                    WHERE
                        s.ec_id_fk = varkeyid
                        AND s.sanyi_unit = varut_unitid
                );
            UPDATE t_ec_sanyi_unit su --更新呈核履歷
            SET
                sign_history = varhistnum ||'. ' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 退回，意見： ' || varsign_comment || chr(
                    10
                ) || sign_history
            WHERE
                su.survey_id_fk2=varsid
                AND su.sanyi_unit2=varut_unitid;
 --新增退回的待辦
            FOR s_field IN sanyi_taker(varkeyid, varut_unitid) LOOP --各車系loop
                vartaker := s_field.undertaker;
                pa_sys_worklist.p_worklist_add(vartaker, '13-02-06', vartittle => '三義工廠-主管退回', varmatter => '三義工廠-'||varecnno||'主管退回', returnval => returnwkid);
                IF returnwkid <> '-1' THEN
                    UPDATE t_ec_sanyi s
                    SET
                        s.worklistid=returnwkid
                    WHERE
                        s.ec_id_fk=varkeyid
                        AND s.undertaker=vartaker
                        AND s.sanyi_unit = varut_unitid;
                END IF;
            END LOOP;
        WHEN 'A15chkOk' THEN
            IF varsign_list = varsign_now THEN
                UPDATE t_ec_sanyi s
                SET
                    status = 'A06-K' --確認-主管審核完成
,
                    modifyer=varundertaker,
                    modify_date=sysdate
                WHERE
                    s.ec_id_fk = varkeyid
                    AND s.sanyi_unit = varut_unitid;
                COMMIT;
            ELSE
                UPDATE t_ec_sanyi s
                SET
                    sign_now = sign_now + 1 --下一位主管
,
                    isalert = 'N',
                    modifyer=varundertaker,
                    modify_date=sysdate
                WHERE
                    s.ec_id_fk = varkeyid
                    AND s.sanyi_unit = varut_unitid;
                p_ec_signman(varkeyid, varut_unitid, varsign_now+1, varsendman); --抓下一關主管id
                pa_sys_worklist.p_worklist_add(varsendman, '13-02-06', vartittle => '三義工廠-主管待審核', varmatter => '請主管進行'||varecnno||'調查內容審核!', returnval => returnwkid);
                IF returnwkid <> '-1' THEN
                    UPDATE t_ec_sanyi ss
                    SET
                        ss.worklistid=returnwkid
                    WHERE
                        ss.ec_id_fk = varkeyid
                        AND ss.sanyi_unit =varut_unitid; --IN varUt_unitid;
                END IF;
            END IF;
            UPDATE t_sys_worklist
            SET
                comptime=sysdate --待辦完成
            WHERE
                worklistid IN (
                    SELECT
                        worklistid
                    FROM
                        t_ec_sanyi       s
                    WHERE
                        s.ec_id_fk = varkeyid
                        AND s.sanyi_unit = varut_unitid
                );
            varcomment:=varsign_comment;
            IF varcomment IS NULL THEN
                varcomment:='簽核完成!';
            END IF;
            UPDATE t_ec_sanyi_unit su --更新呈核履歷
            SET
                sign_history = varhistnum ||'. ' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 同意，意見： ' || varcomment || chr(
                    10
                ) || sign_history
            WHERE
                su.survey_id_fk2=varsid
                AND su.sanyi_unit2=varut_unitid;
        WHEN 'A11LOAD' THEN --待處理->處理中
            UPDATE t_ec_survey_info s
            SET
                status = varstatus
            WHERE
                survey_id = varkeyid;
        WHEN 'A11SendV' THEN --廠商填寫(廠商送出)
 --3.4.1.2 廠商執行回覆，發送E-MAIL通知、新增待辦給調查承辦，調查表狀態改為A06-D確認-承辦待處理。
            UPDATE t_ec_survey_info
            SET
                status = 'A06-D',
                isalert = 'N'
            WHERE
                survey_id = varkeyid;
            SELECT
                s.worklistid INTO varwkid
            FROM
                t_ec_survey_info s
            WHERE
                s.survey_id=varkeyid;
            pa_sys_worklist.p_worklist_complete(varwkid, returnwkid);
            varsendman := varsurvey_taker; --抓下一關為調查承辦
            pa_sys_worklist.p_worklist_add(varsendman, --對象
            '13-02-04', --功能選單ID
            varecnno || ' ' || varvendor || ' 廠商調查表請審核', --主旨
            varecnno || ' ' || varvendor || ' 廠商調查表請審核', --內容
            returnwkid --成功:WorkListID;  失敗:-1
            );
            UPDATE t_ec_survey_info
            SET
                vendor_comment = comment2,
                worklistid = returnwkid,
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 呈送廠商調查表，意見：' || comment2 || chr(
                    10
                ) || sign_history,
                comment2 = ''
            WHERE
                survey_id = varkeyid;
        WHEN 'A11SendY' THEN --廠商填寫(承辦同意)

 /* 3.4.2.3 依照審核者List(T_EC_SURVEY_INFO.Signoff_List)送至下一關卡進行審核，調查表狀態設為A06-G 確認-主管待處理。
         3.4.2.4 通知下一關卡：發送E-MAIL通知主管、新增主管待辦。
         3.4.2.5 將該承辦的待辦事項(記錄)完成。 */
            UPDATE t_ec_survey_info s
            SET
                status = 'A06-G',
                isalert = 'N',
                taker_sign_date = sysdate,
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 呈送廠商調查表，意見：' || comment2 || chr(
                    10
                ) || sign_history,
                sign_now = decode(
                    sign_leader,
                    NULL,
                    1,
                    0
                )
 --,Sign_List = decode(sign_level,'科長',1,decode(sign_level,'科長,副理',2,decode(sign_level,'科長,副理,經理',3,0)))
 --SIGN_LIST分發就決定了，而且是抓參數表
,
                survey_vendor_udate = decode(
                    s.overduereasondescription,
                    NULL,
                    NULL,
                    sysdate
                ),
                s.overduereasondescription = varoverduereasondescription
            WHERE
                survey_id = varkeyid;
 --5.1.6 將承辦的待辦完成，產生下一關(若Leader有值則送給Leader，若Leader為空則送給調查單位之科主管)的待辦。
            pa_sys_worklist.p_worklist_complete(varwkid, varrv);
            IF varleader IS NOT NULL THEN
                varsendman := varleader;
            ELSE
 --select f_sys_employinfo_getleaderbyse(varUt_unitid) into varSendMan from dual;
                SELECT
                    substr(a.depusrid, 1, 6) INTO varsendman
                FROM
                    t_sys_leaderlayer a
                WHERE
                    id = varut_unitid;
            END IF;

            pa_sys_worklist.p_worklist_add(varsendman, --對象
            '13-02-04', --功能選單ID
            varecnno || ' ' || varvendor || ' 廠商調查表請審核', --主旨
            varecnno || ' ' || varvendor || ' 廠商調查表請審核', --內容
            newworklistid --成功:WorkListID;  失敗:-1
            );
            UPDATE t_ec_survey_info
            SET
                comment2 = '',
                worklistid = newworklistid
            WHERE
                survey_id = varkeyid;
        WHEN 'A11Agree' THEN --廠商回覆後YULON審核(主管同意)
 --更新簽核歷程t_ec_survey_info.sign_history
            UPDATE t_ec_survey_info
            SET
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna||' 同意廠商調查表，意見： '|| comment2 || chr(
                    10
                ) || sign_history
            WHERE
                survey_id = varkeyid;
            IF varsign_now = 1 THEN
                UPDATE t_ec_survey_info
                SET
                    depmgr_sign = to_char(
                        sysdate,
                        'yyyy/mm/dd'
                    ) || ' ' || varname
                WHERE
                    survey_id = varkeyid;
            END IF;

            IF varsign_now = 2 THEN
                UPDATE t_ec_survey_info
                SET
                    senior_sign = to_char(
                        sysdate,
                        'yyyy/mm/dd'
                    ) || ' ' || varname
                WHERE
                    survey_id = varkeyid;
            END IF;

            IF varsign_now = 3 THEN
                UPDATE t_ec_survey_info
                SET
                    gm_sign = to_char(
                        sysdate,
                        'yyyy/mm/dd'
                    ) || ' ' || varname
                WHERE
                    survey_id = varkeyid;
            END IF;

            pa_sys_worklist.p_worklist_complete(varwkid, varrv);
            IF (varsign_list <> varsign_now) THEN -- 5.2.3 若非最後一關卡(Sign_List <>Sign_Now），呈送下一關卡進行審核。
 --5.2.3.1  Sign_Now = Sign_Now + 1
                varsign_now := varsign_now+1;
                UPDATE t_ec_survey_info
                SET
                    sign_now = varsign_now
                WHERE
                    survey_id = varkeyid;
 --5.2.3.2  下一關卡人員為取調查科別所屬T_SYS_LEADERLAYER的第幾N個工號(N即為T_EC_SURVEY_INFO.Sign_Now）
 --科長:substr(depusrid,0,6),副理:substr(depusrid,8,6),經理:substr(depusrid,15,6)
                SELECT
                    substr(depusrid, decode(varsign_now, 1, 0, decode(varsign_now, 2, 8, 15)), 6) INTO varsendman
                FROM
                    t_sys_leaderlayer
                WHERE
                    id = varut_unitid;
 --5.2.6 新增下一關卡待辦
                pa_sys_worklist.p_worklist_add(varsendman, --對象
                '13-02-04', --功能選單ID
                varecnno || ' ' || varvendor || ' 廠商調查表請審核', --主旨
                varecnno || ' ' || varvendor || ' 廠商調查表請審核', --內容
                newworklistid --成功:WorkListID;  失敗:-1
                );
                UPDATE t_ec_survey_info
                SET
                    comment2 = '',
                    worklistid = newworklistid,
                    isalert = 'N'
                WHERE
                    survey_id = varkeyid;
            ELSE --若為最後一關卡(Sign_List = Sign_Now）
 --20170522cyc: do reject for leader
                rows := 0;
                SELECT
                    COUNT(*) INTO rows
                FROM
                    t_sys_usergroup ug
                WHERE
                    ug.userid=varundertaker
                    AND ug.groupid='PISGroup31'; --yntc leader
                IF rows = 0 THEN -- do it, not leader
                    UPDATE t_ec_survey_info s
                    SET
                        status = 'A06-K', -- 3.4.2.3.1 調查表狀態設為A06-K 確認-主管審核完成 (登入者待辦完成)。
                        survey_vendor_edate = sysdate --3.4.2.3.2 實際答覆日設為SYSDATE
                    WHERE
                        s.survey_id = varkeyid;

                    UPDATE t_ec_survey_info s
                    SET
                        overduedays = to_date(
                            to_char(survey_vendor_edate, 'yyyy/mm/dd'),
                            'yyyy/mm/dd'
                        ) - to_date(
                            to_char(survey_vendor_pdate, 'yyyy/mm/dd'),
                            'yyyy/mm/dd'
                        )
 -- 3.4.2.3.3 若實際答覆日(系統日)>預計答覆日，逾期天數設為實際答覆日-預計答覆日。
                    WHERE
                        s.survey_id = varkeyid
                        AND survey_vendor_edate > survey_vendor_pdate;

 --3.5.3 該ECN+科的所有調查狀態皆已 A06-K 確認-主管審核完成
                    SELECT
                        COUNT(*) INTO rows --該ECN+科的所有調查狀態  主管審核完成
                    FROM
                        t_ec_survey_info s
                    WHERE
                        s.ec_id ||s.dist_unit IN (
                            SELECT
                                ec_id||dist_unit
                            FROM
                                t_ec_survey_info
                            WHERE
                                survey_id = varkeyid
                        )
                        AND status <> 'A06-K'
                        AND status <> 'A06-9'; --確認-主管審核完成 , 填單-資管科同意不須調查
                    IF rows = 0 THEN
 --A11Agree(最後一張調查表時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A06-K 確認-主管審核完成，且實際答覆日<=預計答覆日, T_EC_SUM.status = \
 --P_EC_STATUS_CAL(varkeyId);
                        UPDATE t_ec_sum
                        SET
                            status = 'A18-3',
                            rdate = sysdate,
                            modifyer = varundertaker,
                            modify_date = sysdate
                        WHERE
                            ec_id IN (
                                SELECT
                                    ec_id
                                FROM
                                    t_ec_survey_info
                                WHERE
                                    survey_id = varkeyid
                            )
                            AND report_type = 'S'
                            AND unit IN (
                                SELECT
                                    s.modifycontent
                                FROM
                                    t_sys_glossary   s
                                WHERE
                                    s.glossarytypeid LIKE 'A05-%'
                                    AND s.glossary2 = varut_unitid
                            )
                            AND to_char(sysdate, 'YYYYMMDD') <= to_char(pdate, 'YYYYMMDD');
 --A11Agree(最後一張調查表時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A06-K 確認-主管審核完成，且實際答覆日＞預計答覆日, T_EC_SUM.status = A18-4
                        UPDATE t_ec_sum
                        SET
                            status = 'A18-4',
                            rdate = sysdate,
                            modifyer = varundertaker,
                            modify_date = sysdate
                        WHERE
                            ec_id IN (
                                SELECT
                                    ec_id
                                FROM
                                    t_ec_survey_info
                                WHERE
                                    survey_id = varkeyid
                            )
                            AND report_type = 'S'
                            AND unit IN (
                                SELECT
                                    s.modifycontent
                                FROM
                                    t_sys_glossary   s
                                WHERE
                                    s.glossarytypeid LIKE 'A05-%'
                                    AND s.glossary2 = varut_unitid
                            )
                            AND to_char(sysdate, 'YYYYMMDD') > to_char(pdate, 'YYYYMMDD');
                    END IF;
 /* 3.4.2.4 若此ECN所有調查表T_EC_SURVEY_INFO.STATUS狀態皆為A06-K：
                 3.4.2.4.1 該ECN所有調查單皆完成時，進入零件切換調查*/

                    SELECT
                        COUNT(*) INTO rows
                    FROM
                        t_ec_survey_info e
                    WHERE
                        e.ec_id IN (
                            SELECT
                                s.ec_id
                            FROM
                                t_ec_survey_info s
                            WHERE
                                s.survey_id = varkeyid
                        )
                        AND e.status <> 'A06-9'; --填單-資管科同意不須調查
                    SELECT
                        COUNT(*) INTO rows2
                    FROM
                        t_ec_survey_info e
                    WHERE
                        e.ec_id IN (
                            SELECT
                                s.ec_id
                            FROM
                                t_ec_survey_info s
                            WHERE
                                s.survey_id = varkeyid
                        )
                        AND e.status <> 'A06-9'
                        AND e.status = 'A06-K';
                    IF rows = rows2 THEN
                        SELECT
                            e.ec_id,
                            e.title,
                            e.pdm_models INTO varec_id,
                            vartitle,
                            varpdmmodels
                        FROM
                            t_ec_info        e
                            JOIN t_ec_survey_info s
                            ON e.ec_id = s.ec_id
                        WHERE
                            s.survey_id = varkeyid;
                        pa_ec_dist.p_ec_add_chg_info(varec_id, vartitle, varpdmmodels);
                    END IF;
                END IF;
            END IF;
        WHEN 'A11Reject' THEN
 --廠商填寫(退回)
 --3.5.1 若狀態為A06-E 確認-承辦處理中時，承辦意見欄位必填，退回調查表給廠商，調查表狀態設為A06-C 廠商-重新處理(承辦退回)。(發送E-MAIL通知廠商、新增廠商待辦、承辦待辦完成)
 --3.5.2 若狀態為A06-I 確認-主管審核中時，主管意見欄位必填，退回調查表給承辦，調查表狀態設為A06-J 確認-主管退回承辦。(發送E-MAIL通知承辦、新增承辦待辦、主管待辦完成)
            IF varstatus = 'A06-E' THEN --承辦處理中A06-E -> 廠商-重新處理(承辦退回)A06-C
                varstatus2 := 'A06-C';
                varsendman := substr(varvendor, 0, 4)||'2';
            ELSIF varstatus = 'A06-I' THEN --確認-主管審核中A06-I -> 確認-主管退回承辦A06-J
                varstatus2 := 'A06-J';
                varsendman := varsurvey_taker;
            END IF;

            IF varsendman IS NOT NULL THEN
 --6-2. 更新簽核歷程t_ec_survey_info.sign_history
                UPDATE t_ec_survey_info s
                SET
                    status = varstatus2,
                    isalert = 'N',
                    sign_history = varhistnum ||'.' || to_char(
                        sysdate,
                        'yyyy/mm/dd HH24:MM:SS'
                    ) || ' ' || varname || ' ' || varpositionna|| ' 退回廠商調查表，意見： ' || varsign_comment || chr(
                        10
                    ) || sign_history
                WHERE
                    survey_id = varkeyid;
 --6-3. 此關卡之待辦完成、新增下一關承辦待辦
                pa_sys_worklist.p_worklist_complete(varwkid, varrv);
                pa_sys_worklist.p_worklist_add(varsendman, --對象
                '13-02-04', --功能選單ID
                varecnno || ' ' || varvendor || ' 廠商調查表被退回，請重新調查', --主旨
                varecnno || ' ' || varvendor || ' 廠商調查表被退回，請重新調查', --內容
                newworklistid --成功:WorkListID;  失敗:-1
                );
                UPDATE t_ec_survey_info
                SET
                    comment2 = '',
                    worklistid = newworklistid
                WHERE
                    survey_id = varkeyid;
            END IF;
        WHEN 'A11_LoadSaveC' THEN
            UPDATE t_ec_survey_info
            SET
                vendor_comment = varsign_comment
            WHERE
                survey_id = varkeyid;
        WHEN 'A11_LoadSaveM' THEN
            UPDATE t_ec_survey_info
            SET
                vendor_memo = varsign_comment
            WHERE
                survey_id = varkeyid;
        ELSE
            outresult := 'ok';
    END CASE;




 --單次送出判斷
    IF (varstep = 'A15send'
    OR varstep = 'A15notSelf') THEN
        UPDATE t_ec_sanyi ss
        SET
            status = varstatus2,
            modifyer=varundertaker,
            modify_date=sysdate,
            ss.sign_comment=''
        WHERE
            ss.ec_id_fk = varkeyid
            AND ss.undertaker = varundertaker;
        UPDATE t_sys_worklist
        SET
            comptime=sysdate --待辦完成, 該承辦可能會有多筆待辦
        WHERE
            worklistid IN (
                SELECT
                    worklistid
                FROM
                    t_ec_sanyi       ss
                WHERE
                    ss.ec_id_fk = varkeyid
                    AND ss.undertaker = varundertaker
            );
        UPDATE t_ec_sanyi_unit su --更新呈核履歷
        SET
            sign_history = varhistnum ||'. ' || to_char(
                sysdate,
                'yyyy/mm/dd HH24:MM:SS'
            ) || ' ' || varname || ' ' || varpositionna || decode(
                varstep,
                'A15send',
                ' 呈送簽核，意見：',
                ' 非本組業務，意見：'
            ) || varcomment || chr(
                10
            ) || sign_history
        WHERE
            su.survey_id_fk2=varsid
            AND su.sanyi_unit2=varut_unitid;
        rows:=0;
        rows2:=0;
        SELECT
            COUNT(*) INTO rows
        FROM
            t_ec_sanyi ss
        WHERE
            ss.status NOT IN ('A06-F', 'A06-L') --承辦完成, 非本組業務
            AND ss.ec_id_fk = varkeyid
            AND ss.sanyi_unit = varut_unitid;
        SELECT
            COUNT(*) INTO rows2
        FROM
            t_ec_sanyi ss
        WHERE
            ss.status = 'A06-F' --承辦完成
            AND ss.ec_id_fk = varkeyid
            AND ss.sanyi_unit = varut_unitid;
        IF ( rows = 0 --該ECN+科之所有案件皆已為"承辦完成"或"非本組業務"
        AND rows2 > 0 --且該ECN+科有"承辦完成"的筆數
        AND ( (varstep = 'A15send'
        AND varstatus2 = 'A06-F') --該ECN+科之最後一筆為"承辦完成"
        OR (varstep = 'A15notSelf'
        AND varstatus2 = 'A06-L') --該ECN+科之最後一筆為"非本組業務"
        ) ) THEN --有案件完成，進入主管審核, 送出才執行此
            varstatus2:='A06-G'; -- 確認-主管待處理
            UPDATE t_ec_sanyi ss
            SET
                status = varstatus2,
                isalert = 'N',
                sign_now = decode(
                    sign_leader,
                    NULL,
                    1,
                    0
                ),
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                ss.ec_id_fk = varkeyid
                AND ss.sanyi_unit = varut_unitid;
            IF varleader IS NOT NULL THEN
                varsendman := varleader;
            ELSE
                IF varsign_now IS NULL THEN
                    varsign_now := 1;
                END IF;

                p_ec_signman(varkeyid, varut_unitid, varsign_now, varsendman); --抓下一關主管id
            END IF;

            pa_sys_worklist.p_worklist_add(varsendman, '13-02-06', vartittle => '三義工廠-主管待審核', varmatter => '請主管進行'||varecnno||'調查內容審核!', returnval => returnwkid);
            IF returnwkid <> '-1' THEN
                UPDATE t_ec_sanyi ss
                SET
                    ss.worklistid=returnwkid
                WHERE
                    ss.ec_id_fk = varkeyid
                    AND ss.sanyi_unit =varut_unitid;
            END IF;
        END IF;
    END IF;

    COMMIT;
 --判斷是否為最後一關
    IF (varstep = 'A15chkOk'
    OR varstep = 'A15notSelf') THEN
        rows:=0;
 --3.5.3 該ECN所有三義工廠調查狀態皆已 A06-K 確認-主管審核完成 或為 A06-L非本組業務
        SELECT
            COUNT(*) INTO rows --所有三義工廠調查狀態  主管審核完成
        FROM
            t_ec_sanyi s
        WHERE
            s.ec_id_fk = varkeyid
            AND status <> 'A06-K'
            AND status <> 'A06-L'; --確認-主管審核完成
        IF rows=0 THEN --三義工廠各科調查完成，此調查單也完成
            UPDATE t_ec_survey_info si
            SET
                si.status='A06-K',
                si.survey_vendor_edate=sysdate,
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                si.survey_id=varsid
                OR (si.ec_id = varkeyid
                AND si.ut_unitid='SANYI');
 --A15chkOk(最後一張調查表時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A06-K 確認-主管審核完成，且實際答覆日<=預計答覆日, T_EC_SUM.status = A18-3
 --P_EC_STATUS_CAL(varkeyId);
            UPDATE t_ec_sum
            SET
                status = 'A18-3',
                rdate = sysdate,
                modifyer = varundertaker,
                modify_date = sysdate
            WHERE
                ec_id = varkeyid
                AND report_type = 'S'
                AND unit = 'S'
                AND to_char(sysdate, 'YYYYMMDD') <= to_char(pdate, 'YYYYMMDD');
 --A11Agree(最後一張調查表時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A06-K 確認-主管審核完成，且實際答覆日＞預計答覆日, T_EC_SUM.status = A18-4
            UPDATE t_ec_sum
            SET
                status = 'A18-4',
                rdate = sysdate,
                modifyer = varundertaker,
                modify_date = sysdate
            WHERE
                ec_id = varkeyid
                AND report_type = 'S'
                AND unit = 'S'
                AND to_char(sysdate, 'YYYYMMDD') > to_char(pdate, 'YYYYMMDD');
            rows:=0;
            SELECT
                COUNT(*) INTO rows
            FROM
                t_ec_survey_info si
            WHERE
                si.status<>'A06-K'
                AND si.ec_id = varkeyid;
            IF rows=0 THEN --所有調查單完成，進入零件切換調查 --與A04共用
                pa_ec_dist.p_ec_add_chg_info(varkeyid, vartitle, varpdmmodels);
            END IF;
        END IF;
    END IF;

    COMMIT;
 --3.4.1 所有組別皆設定「非本組業務」時則退回資管科(同A06的退回)。
    IF (varstep = 'A15notSelf') THEN
        rows:=0;
        rows2:=0;
        SELECT
            COUNT(*) INTO rows
        FROM
            t_ec_sanyi ss
        WHERE
            NOT ss.status IN ('A06-L')
            AND ss.ec_id_fk = varkeyid; --非本組業務
 --AND SS.SANYI_UNIT = varUt_unitid
        SELECT
            COUNT(*) INTO rows2
        FROM
            t_ec_sanyi ss
        WHERE
            ss.status = 'A06-L'
            AND ss.ec_id_fk = varkeyid; --非本組業務
 --AND SS.SANYI_UNIT = varUt_unitid;
        IF rows=0 AND rows2>0 THEN
            UPDATE t_ec_info e
            SET
                e.status = 'A04-6' --廠商調查_退回
,
                modifyer=varundertaker,
                modify_date=sysdate
            WHERE
                e.ec_id = varkeyid;
            SELECT
                f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-2', 2)) INTO varmail
            FROM
                dual; --資管科
            SELECT
                f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-9', 2)) INTO varmail2
            FROM
                dual; --ISC
            p_sys_mail_add(varmail, varmail2, 'ESS三義工廠退回-皆為非本組業務!', '請承辦進行' ||varecnno||' 廠商確認!', '', 'Y', '', '', returnwkid); --成功:MailID;  失敗:-1
            pa_sys_worklist.p_worklist_add(f_sys_glossary_getnamebyfield('A14-2', 2), '13-02-08', vartittle => '三義工廠退回-皆為非本組業務!', varmatter => '請承辦進行' ||varecnno||' 廠商確認!', returnval => returnwkid);
            IF returnwkid <> '-1' THEN
                UPDATE t_ec_info e
                SET
                    e.worklistid=returnwkid
                WHERE
                    e.ec_id = varkeyid;
                UPDATE t_ec_survey_info s
                SET
                    s.sign_history='ESS三義工廠退回-皆為非本組業務!'
                WHERE
                    s.ec_id = varkeyid
                    AND s.dist_vendor='SANYI';
            END IF;
 -- 發送Email給資管窗口 CC資管主管
 --資管窗口
            SELECT
                e.mailaddress,
                e.name INTO v_semail,
                v_semail_na
            FROM
                t_sys_employinfo e
                INNER JOIN t_sys_glossary g
                ON e.employno = g.glossary2
            WHERE
                g.glossarytypeid = 'A14-2'
                AND e.inservice = 'Y';
 --資管主管

 /*           select e.mailaddress into v_ccmail
           from T_SYS_EMPLOYINFO e
           where e.unitid in (
                 select distinct e.unitid
                 from T_SYS_EMPLOYINFO e
                 inner join T_SYS_GLOSSARY g on e.employno = g.glossary2
                 where g.glossarytypeid = 'A14-2' and e.INSERVICE = 'Y' )
           and INSERVICE = 'Y' AND POSITIONTYPE <> 11 ;*/
            v_title := 'ESS<退回通知>'|| varut_unitna ||'退回廠商或零件切換調查';
            v_body := v_semail_na ||' 先生/小姐 您好：<br>' || varut_unitna || '退回設通單' || varecnno ||'，請進入設變調查e化系統執行EC>>管理>>「分發廠商調整」功能。';
            varcontent := '<html><head></head><body><P>'|| v_body ||'</P></body></html>';
            p_sys_mail_add(v_semail, v_ccmail, v_title, varcontent, '', 'Y', '', '', varresult);
            IF varresult = '-1' THEN
                ROLLBACK;
                return;
            END IF;
        END IF;
    END IF;

    COMMIT;
    outresult := 'ok';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        FOR rec_mailaddress IN cur_mailaddress LOOP
            v_semail_na := v_semail_na || rec_mailaddress.mailaddress || ',';
        END LOOP;

        p_sys_mail_add(v_semail_na, '', 'ESS P_EC_SurveyStatus_sdo ERROR', varstep||','||varkeyid||','||varundertaker||','||sqlerrm, '', '', '', '', varresult);
        outresult := sqlerrm;
END p_ec_surveystatus_sdo;