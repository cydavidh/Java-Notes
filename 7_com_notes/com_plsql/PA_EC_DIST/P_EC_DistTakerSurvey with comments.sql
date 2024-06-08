CREATE OR REPLACE PROCEDURE P_EC_DISTTAKERSURVEY
 /* 前置作業：plm的ec及pl轉入 t_ec_info, t_pl_info
     *   A04 廠商分發
     *     1. 提醒承辦開始調查
     *     2. 若不須廠商調查則直接進行零件切換調查(生管,行銷,零服)
     * @author cyc
    */
 --   OutResult OUT VARCHAR --,0,儲存成功 --,-1,儲存失敗
AS
    vareid             INT;
    vendor_list        VARCHAR2(100); --G149,A101
    vendor_survey      VARCHAR2(1); --Y OR N
    undertake          VARCHAR2(100);
    vid                VARCHAR2(12); --G149
    i                  INT;
    j                  INT;
    k                  INT;
    mday               INT;
    li_wid             INT;
    datacount1         NUMBER;
    datacount2         NUMBER;
    li_sid             NUMBER;
    cnt                INT;
    cnt2_model         INT;
    li_sp_cnt          INT;
    survey_psrts_id    NUMBER;
    li_ssid            NUMBER;
    rtnwid             VARCHAR2(50);
    rtnmid             VARCHAR2(50);
    varunit            VARCHAR2(1);
    varunit2           VARCHAR2(1); --追加分發零技科, Y OR ''
    varmtag            VARCHAR2(10);
    varstatus          VARCHAR2(10);
    ls_ut_unitid       VARCHAR2(10);
    model              VARCHAR2(10);
    pdm_models         VARCHAR2(100);
    ls_model           VARCHAR2(100);
    title              VARCHAR2(500);
    adpt               VARCHAR2(50);
    desgrp             VARCHAR2(50);
    varmail            VARCHAR2(250);
    varmail2           VARCHAR2(250);
    varmail3           VARCHAR2(250);
    varng_vendordev    VARCHAR2(1024);
    varng_novendorid   VARCHAR2(1024);
    varng_vendoridnot4 VARCHAR2(1024);
    varng_nomodel      VARCHAR2(1024);
    varng_msg          VARCHAR2(2024);
    varng_vendor       VARCHAR2(2024);
    varsp              VARCHAR2(512);
    varsignlist        INT;
    varsignlevel       NVARCHAR2(250);
    varecnno           CHAR(11);
    varvendor          NVARCHAR2(10);
    varpl_vid          NVARCHAR2(10); --比對PL上的VID
    vname_list         NVARCHAR2(1024);
    vname              NVARCHAR2(50);
    varutname          NVARCHAR2(50);
    var_released_date  DATE;
    varsqlerrm         NVARCHAR2(2000);
    li_ssunit          INT;
 -- 1. 抓取待分發的EC清單，STATUS:A04-1待處理；vendor_list:分發廠商, ex: B154,G149
    CURSOR EC_INFO_LIST IS
    SELECT
        EC_ID,
        ECNNO,
        VENDOR_LIST,
        VENDOR_SURVEY,
        TITLE,
        PDM_MODELS,
        DES_UNITID,
        RELEASED_DATE,
        E.ADPT
    FROM
        T_EC_INFO E
    WHERE
        E.STATUS = 'A04-1' --AND e.vendor_survey='Y'
 -- and ecnno in ('ECN-2100431')
 --e.released_date=to_date('20170220','YYYYMMDD')
 --e.ecnno='ECN-1701159'
 --e.ecnno In ('ECN-1700064','ECN-1700054','ECN-1700069')
 --VENDOR_LIST LIKE '%SANYI%'
    ORDER BY
        EC_ID ASC;
 -- 字串切割，有逗點者
    CURSOR CUR_STRSPLIT(
        V_STR VARCHAR2
    ) IS
    SELECT
        ENGINEID AS STR2
    FROM
        TABLE(CAST(F_PUB_SPLIT(V_STR) AS MYTABLETYPE));
    c_field            CUR_STRSPLIT%ROWTYPE;
 -- 字串切割，有逗點者
    CURSOR CUR_STRSPLIT2(
        V_STR VARCHAR2
    ) IS
    SELECT
        ENGINEID AS STR2
    FROM
        TABLE(CAST(F_PUB_SPLIT(V_STR) AS MYTABLETYPE));
    c_field2           CUR_STRSPLIT2%ROWTYPE;
 --該EC的零件清單, V:local件, A:設變後或新增的零件
 --20161103:第一次先傳vid進來比對，第二次傳vid=%
 --varUnit: P, Y

 /* 20210712:若沒有零件清單時，會取pl_id=0,
      所以 T_EC_pl_info要有一筆資料 pl_id=0, ec_id=0,chagemaker='A',  partno='NA',partname='無設變件號'),
      所有沒有件號的ECN都可以正常發給三義工廠
    */
    CURSOR CUR_EC_PARTS(
        ECID INT,
        VID VARCHAR2,
        VARUNIT VARCHAR2
    ) IS
    SELECT
        PL_ID
    FROM
        T_EC_PL_INFO P
    WHERE
        (EC_ID = ECID
        OR VID = 'NA')
        AND P.CHANGEMAKER = 'A'
        AND (VARUNIT = 'Y'
        AND P.SOURCE IN ('V', 'R')
        OR (VARUNIT = 'P'
        AND P.BD IN (
            SELECT
                G.GLOSSARY2
            FROM
                T_SYS_GLOSSARY G
            WHERE
                G.GLOSSARYTYPEID LIKE 'A01%'
        ))
        OR (VARUNIT = 'S'
        AND (P.SOURCE IN ('V', 'R')
        OR VID = 'NA')))
        AND (VID <> '%'
        AND P.YLRLSMAKER1 = VID
        OR VID = '%'
        AND P.YLRLSMAKER1 IS NULL
        OR VID = 'NA'
        AND P.PL_ID = 0)
    ORDER BY
        PL_ID ASC;
    p_field            CUR_EC_PARTS%ROWTYPE;
 --該SURVEY的零件清單(零技或PEO用)

 /*    CURSOR cur_survey_parts(sid int) IS
      SELECT pl_id FROM T_EC_survey_info s INNER JOIN P_EC_survey_parts sp on s.survey_id=sp.survey_id
      WHERE s.survey_id = sid;
    sp_field cur_survey_parts%ROWTYPE;*/
 --該SURVEY的零件清單(SANYI用)

 /*    CURSOR cur_survey_parts_sanyi(sid int) IS
      SELECT pl_id FROM T_EC_survey_info s INNER JOIN P_EC_sanyi si on s.survey_id=si.survey_id_fk
        INNER JOIN P_EC_survey_parts sp on si.survey_id_fk=sp.survey_id
      WHERE s.survey_id = sid;
    ss_field cur_survey_parts_sanyi%ROWTYPE;*/
 --車系承辦a
    CURSOR CUR_MODEL_TAKER(
        MID2 VARCHAR2
    ) IS
 /*SELECT S377_UNDERTAKER, S391_UNDERTAKER, PAINT_UNDERTAKER, BODY_UNDERTAKER, MODE_UNDERTAKER, PD_MG_TAKER
                              FROM t_anp_model
                              WHERE model = mid2 OR (mid2='ALL' AND model='EC');*/
    SELECT
        (
            SELECT
                T.UNDERTAKER
            FROM
                T_ANP_MODEL_OTHER T
            WHERE
                (T.MODEL = MID2
                OR (MID2 = 'ALL'
                AND MODEL = 'EC'))
                AND TYPEID = 'A02-1'
        ) AS S377_UNDERTAKER,
        (
            SELECT
                T.UNDERTAKER
            FROM
                T_ANP_MODEL_OTHER T
            WHERE
                (T.MODEL = MID2
                OR (MID2 = 'ALL'
                AND MODEL = 'EC'))
                AND TYPEID = 'A02-2'
        ) AS S391_UNDERTAKER,
        (
            SELECT
                T.UNDERTAKER
            FROM
                T_ANP_MODEL_OTHER T
            WHERE
                (T.MODEL = MID2
                OR (MID2 = 'ALL'
                AND MODEL = 'EC'))
                AND TYPEID = 'A02-3'
        ) AS PAINT_UNDERTAKER,
        (
            SELECT
                T.UNDERTAKER
            FROM
                T_ANP_MODEL_OTHER T
            WHERE
                (T.MODEL = MID2
                OR (MID2 = 'ALL'
                AND MODEL = 'EC'))
                AND TYPEID = 'A02-4'
        ) AS BODY_UNDERTAKER,
        (
            SELECT
                T.UNDERTAKER
            FROM
                T_ANP_MODEL_OTHER T
            WHERE
                (T.MODEL = MID2
                OR (MID2 = 'ALL'
                AND MODEL = 'EC'))
                AND TYPEID = 'A02-5'
        ) AS MODE_UNDERTAKER,
        (
            SELECT
                T.UNDERTAKER
            FROM
                T_ANP_MODEL_OTHER T
            WHERE
                (T.MODEL = MID2
                OR (MID2 = 'ALL'
                AND MODEL = 'EC'))
                AND TYPEID = 'A10-3'
        ) AS PD_MG_TAKER
    FROM
        DUAL;
    m_field            CUR_MODEL_TAKER%ROWTYPE;
 --抓雙承辦

 /*CURSOR cur_dup_taker(varmTag VARCHAR2, desgrp VARCHAR2, varEid int, vid VARCHAR2, PDM_MODELS VARCHAR2) IS
      --IF left(varmTag,1)='m' THEN varmTag := SUBSTR(varmTag,2,4);
      SELECT S.DEVELOPER, E.unitid
      FROM T_ANP_SUPPLIER S INNER JOIN T_SYS_EMPLOYINFO E ON E.employno = S.DEVELOPER
      WHERE S.SUPPLIERCODE LIKE varmTag AND E.unitid IN (SELECT g.GLOSSARY2 FROM T_SYS_GLOSSARY g WHERE g.GLOSSARYTYPEID in ('A05-1','A05-2') )
         AND (S.DES_GRP IS NULL OR S.DES_GRP = desgrp)
         AND (S.BD_NO IS NULL OR S.BD_NO IN (SELECT SUBSTR(P.BD, 1, 6) FROM T_EC_PL_INFO P WHERE P.EC_ID = varEid AND P.SOURCE = 'V' AND (P.YLRLSMAKER1 LIKE varmTag or P.YLRLSMAKER1=vid)) )
         AND (S.MODEL IS NULL OR INSTR(PDM_MODELS, S.MODEL) > 0)
         AND E.INSERVICE='Y'
         AND ROWNUM <= 1;
    dup_field cur_dup_taker%ROWTYPE;*/
BEGIN
    SELECT
        F_SYS_EMPLOYINFO_GETMAIL3BYNO(F_SYS_GLOSSARY_GETNAMEBYFIELD('A14-2',
        2)) INTO VARMAIL
    FROM
        DUAL; --資管科窗口
    SELECT
        F_SYS_EMPLOYINFO_GETMAIL3BYNO(F_SYS_GLOSSARY_GETNAMEBYFIELD('A14-9',
        2)) INTO VARMAIL2
    FROM
        DUAL; --ISC
    varng_msg := ''; --分發異常通知信
    varsp := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
 --大loop，開始一個一個ecn去loop
    FOR EC_INFO IN EC_INFO_LIST LOOP
        VAREID := EC_INFO.EC_ID;
        VENDOR_LIST := EC_INFO.VENDOR_LIST;
        VENDOR_SURVEY := EC_INFO.VENDOR_SURVEY;
        PDM_MODELS := EC_INFO.PDM_MODELS;
        TITLE := EC_INFO.TITLE;
        DESGRP := EC_INFO.DES_UNITID;
        VARECNNO := EC_INFO.ECNNO;
        ADPT := EC_INFO.ADPT;
        VAR_RELEASED_DATE := EC_INFO.RELEASED_DATE;
        VARNG_VENDORDEV := ':'; --廠商開發承辦有問題
        VARNG_NOVENDORID := ':'; --無此廠商代碼
        VARNG_VENDORIDNOT4 := ':'; --廠商代碼長度<>4
        VARNG_NOMODEL := ':'; --車型未設定
        VARNG_VENDOR := ':'; --調查廠商ng
 --要分發廠商
        IF VENDOR_SURVEY = 'Y' THEN
 --這段是在改赤色手配管控日期
            IF VENDOR_LIST IS NULL OR VENDOR_LIST = ' ' THEN
                VARNG_VENDOR := VARNG_VENDOR || VARECNNO || ', ';
            END IF;

            IF ADPT = 'A09-F' THEN
 --赤色手配  Red Release
                SELECT
                    F_SYS_GLOSSARY_GETNAMEBYFIELD('A08-2',
                    '2') INTO MDAY
                FROM
                    DUAL; --赤色手配管控日期, 3天
            ELSE
                SELECT
                    F_SYS_GLOSSARY_GETNAMEBYFIELD('A08-3',
                    '2') INTO MDAY
                FROM
                    DUAL; --一般調查單管控日期, 14天
            END IF;
 --抓名字，比較不重要
            P_EC_VNAME(VAREID, VNAME_LIST); --抓取裕器,東陽
 --先loop廠商
            FOR C_FIELD IN CUR_STRSPLIT(VENDOR_LIST) LOOP
 --如果是sanyi就設定變數為三義工廠
 --如果名字四個字又不是三義工廠就寫錯誤訊息之類
                IF C_FIELD.STR2 = '三義工廠' OR C_FIELD.STR2 = 'SANYI' THEN
                    VID := 'SANYI';
                ELSIF (LENGTH(C_FIELD.STR2) <> 4
                AND C_FIELD.STR2 <> 'SANYI') THEN
 --含KD,---
                    VARNG_VENDORIDNOT4 := VARNG_VENDORIDNOT4 || C_FIELD.STR2 || ', ';
                    VID := '---';
                END IF;

                IF (LENGTH(C_FIELD.STR2) = 4
                AND C_FIELD.STR2 <> '三義工廠') THEN
                    VID := C_FIELD.STR2;
                    DATACOUNT1 := 0;
                    SELECT
                        COUNT(*) INTO DATACOUNT1
                    FROM
                        T_ANP_SUPPLIER
                    WHERE
                        SUPPLIERCODE = VID;
                    IF DATACOUNT1 = 0 THEN
                        VARNG_NOVENDORID := VARNG_NOVENDORID || VID || ', ';
 --EXIT WHEN datacount1 = 0;  --cyc20171127: KD,G154 run full
                    END IF;
                END IF;
 --這個procedure用來判斷調查單位的
                VARUNIT2 := '';
                P_EC_GETDISTUNIT(VAREID, VID, VARUNIT); -- Y, P, S, Q, A(---,''), B(not found), C(ERR) --抓取調查單位
 --如果需要追加就是Q
                IF VARUNIT = 'Q' THEN
                    VARUNIT2 := 'Y'; --追加分發零技科在一個
                    VARUNIT := 'P';
                END IF;

                IF VARUNIT = 'Y' OR VARUNIT = 'S' OR VARUNIT = 'P' THEN
                    I := 1;
                    IF VARUNIT2 = 'Y' THEN
                        J := 2; --追加分發零技科
                    ELSE
                        J := 1;
                    END IF;

                    LOOP
                        UNDERTAKE := '';
                        LS_UT_UNITID := '';
                        LI_WID := 0;
                        LI_SID := 0;
                        SELECT
                            COUNT(*) --是否已存在設通調查表
                            INTO LI_SID
                        FROM
                            T_EC_SURVEY_INFO S
                        WHERE
                            S.EC_ID = VAREID
                            AND S.DIST_UNIT = VARUNIT
                            AND S.DIST_VENDOR = VID;
                        IF 1 = 1 OR LI_SID = 0 THEN
 --
                            IF LI_SID > 0 THEN
 --如果已經存在設同調查表的話
                                SELECT
                                    S.SURVEY_ID INTO LI_SID
                                FROM
                                    T_EC_SURVEY_INFO S
                                WHERE
                                    S.EC_ID = VAREID
                                    AND S.DIST_UNIT = VARUNIT
                                    AND S.DIST_VENDOR = VID;
                                IF VARUNIT <> 'S' THEN
 --如果調查單位不是三義工廠
                                    RTNWID := 0; --檢查是否存在待辦項目
                                    SELECT
                                        COUNT(*) INTO RTNWID
                                    FROM
                                        T_SYS_WORKLIST W
                                    WHERE
                                        W.USERID = (
                                            SELECT
                                                S.SURVEY_TAKER
                                            FROM
                                                T_EC_SURVEY_INFO S
                                            WHERE
                                                S.SURVEY_ID = LI_SID
                                        )
                                        AND W.TITTLE LIKE '%' || VARECNNO || '%設通調查表請填寫'
                                        AND ROWNUM <= 1;
                                    IF RTNWID > 0 THEN
 --如果已經存在代辦項目
                                        SELECT
                                            W.WORKLISTID INTO RTNWID
                                        FROM
                                            T_SYS_WORKLIST W
                                        WHERE
                                            W.USERID = (
                                                SELECT
                                                    S.SURVEY_TAKER
                                                FROM
                                                    T_EC_SURVEY_INFO S
                                                WHERE
                                                    S.SURVEY_ID = LI_SID
                                            )
                                            AND W.TITTLE LIKE '%' || VARECNNO || '%設通調查表請填寫'
                                            AND ROWNUM <= 1;
                                        UPDATE T_EC_SURVEY_INFO S
                                        SET
                                            S.STATUS = 'A06-1',
                                            S.WORKLISTID = RTNWID
                                        WHERE
                                            S.SURVEY_ID = LI_SID
                                            AND (S.STATUS = 'A06-7'
                                            OR S.STATUS = 'A06-9'); --資管再轉回調查單位
                                        UPDATE T_SYS_WORKLIST W
                                        SET
                                            W.COMPTIME = NULL
                                        WHERE
                                            W.WORKLISTID = RTNWID;
                                    END IF;
                                END IF;
                            END IF;

                            IF VARUNIT = 'S' THEN
 --如果調查單位是三義工廠
                                VARUNIT := 'S';
                                UNDERTAKE := 'SANYI';
                                LS_UT_UNITID := 'SANYI';
                                VARSTATUS := 'A06-D'; --設變調查狀態：確認-承辦待處理
                            ELSE
                                VARSTATUS := 'A06-1'; --設變調查狀態：填單－承辦待處理
                                VARMTAG := '';
                                IF VARUNIT = 'Y' THEN
                                    VARMTAG := VID || '%';
                                ELSE
                                    VARMTAG := 'm' || VID || '%';
                                END IF;
 --承揚：下面這段是抓承辦或者雙承辦（單承辦就（IS NULL) ，雙的話就指定）
 --雙承辦，EX:裕器，依設計科別、BD、車系指定不同承辦, 取一位
 --20170628:not must chk bd for pl list 必須要檢查bd
 --20170921:EC.ADD_DIST LIKE PEO
 --承揚：現在新的ecn清單裡面會多一個必須要增加分發單位給peo，而不需要用不屬於五大模組的bd號碼來判斷
 --現在裕器其實也沒有雙承辦了，正式db裡t_anp_supplier裡面承辦窗口就一個而已
                                CNT := 0;
                                SELECT
                                    COUNT(*) INTO CNT
                                FROM
                                    T_ANP_SUPPLIER S
                                    INNER JOIN T_SYS_EMPLOYINFO E
                                    ON E.EMPLOYNO = S.DEVELOPER
                                    INNER JOIN T_EC_INFO E2
                                    ON E2.EC_ID = VAREID
                                WHERE
                                    S.SUPPLIERCODE LIKE VARMTAG
                                    AND E.UNITID IN (
                                        SELECT
                                            G.GLOSSARY2
                                        FROM
                                            T_SYS_GLOSSARY G
                                        WHERE
                                            G.GLOSSARYTYPEID IN ('A05-1', 'A05-2')
                                    ) --設變調查單位 零技科 PEO
                                    AND (S.DES_GRP = DESGRP
                                    OR --科別
                                    S.DES_GRP IS NULL)
                                    AND (S.BD_NO IS NULL
                                    OR --BD
                                    S.BD_NO IN (
                                        SELECT
                                            SUBSTR(P.BD,
                                            1,
                                            6)
                                        FROM
                                            T_EC_PL_INFO P
                                        WHERE
                                            P.EC_ID = VAREID
                                    )
                                    OR E2.ADD_DIST LIKE '%PEO%')
                                    AND (S.MODEL IS NULL
                                    OR INSTR(PDM_MODELS, S.MODEL) > 0) --車系
                                    AND E.INSERVICE = 'Y' --在職
                                    AND ROWNUM <= 1;
                                IF CNT > 0 THEN
                                    SELECT
                                        S.DEVELOPER,
                                        E.UNITID INTO UNDERTAKE,
                                        LS_UT_UNITID
                                    FROM
                                        T_ANP_SUPPLIER S
                                        INNER JOIN T_SYS_EMPLOYINFO E
                                        ON E.EMPLOYNO = S.DEVELOPER
                                        INNER JOIN T_EC_INFO E2
                                        ON E2.EC_ID = VAREID
                                    WHERE
                                        S.SUPPLIERCODE LIKE VARMTAG
                                        AND E.UNITID IN (
                                            SELECT
                                                G.GLOSSARY2
                                            FROM
                                                T_SYS_GLOSSARY G
                                            WHERE
                                                G.GLOSSARYTYPEID IN ('A05-1', 'A05-2')
                                        )
                                        AND (S.DES_GRP IS NULL
                                        OR S.DES_GRP = DESGRP)
                                        AND (S.BD_NO IS NULL
                                        OR S.BD_NO IN (
                                            SELECT
                                                SUBSTR(P.BD,
                                                1,
                                                6)
                                            FROM
                                                T_EC_PL_INFO P
                                            WHERE
                                                P.EC_ID = VAREID
                                        )
                                        OR E2.ADD_DIST LIKE '%PEO%')
                                        AND (S.MODEL IS NULL
                                        OR INSTR(PDM_MODELS, S.MODEL) > 0)
                                        AND E.INSERVICE = 'Y'
                                        AND ROWNUM <= 1;
                                END IF;
                            END IF;

                            IF UNDERTAKE IS NULL THEN
                                SELECT
                                    S.DEVELOPER INTO UNDERTAKE
                                FROM
                                    T_ANP_SUPPLIER S
                                WHERE
                                    S.SUPPLIERCODE = VID;
                                IF UNDERTAKE IS NULL THEN
                                    UNDERTAKE := '空的!';
                                END IF;

                                VARNG_VENDORDEV := VARNG_VENDORDEV || VARMTAG || ', ';
                            ELSE
                                IF UNDERTAKE = 'SANYI' THEN --如果是sanyi的話就先暫時不抓簽核層級，之後再抓。
                                    LI_WID := 0;
                                    VARSIGNLIST := '';
                                    VARSIGNLEVEL := '';
                                ELSE
                                    SELECT
                                        S.SUPPLIERNAME INTO VARVENDOR
                                    FROM
                                        T_ANP_SUPPLIER S
                                    WHERE
                                        S.SUPPLIERCODE = VID;
                                    SELECT
                                        G.GLOSSARY4,
                                        G.GLOSSARY1 INTO VARSIGNLIST,
                                        VARSIGNLEVEL --抓取簽核List數、簽核層級
                                    FROM
                                        T_SYS_GLOSSARY G
                                    WHERE
                                        G.GLOSSARYTYPEID LIKE 'A11%'
                                        AND G.GLOSSARY2 = 'Y'
                                        AND (G.GLOSSARY3 = LS_UT_UNITID
                                        OR G.GLOSSARY3 = (
                                            SELECT
                                                E.DEPARTMENTID
                                            FROM
                                                T_SYS_EMPLOYINFO E
                                            WHERE
                                                E.UNITID = LS_UT_UNITID
                                                AND ROWNUM <= 1
                                        ));
                                END IF;

                                LI_SID := 0; --確認是否已經存在設通調查表
                                SELECT
                                    COUNT(*) INTO LI_SID
                                FROM
                                    T_EC_SURVEY_INFO S
                                WHERE
                                    S.EC_ID = VAREID
                                    AND S.DIST_UNIT = VARUNIT
                                    AND S.DIST_VENDOR = VID;
                                IF LI_SID = 0 THEN
 --如果不存在設通調查表
                                    LI_WID := NULL;
                                    IF UNDERTAKE <> 'SANYI' THEN
 --如果承辦不是三義工廠
                                        PA_SYS_WORKLIST.P_WORKLIST_ADD(UNDERTAKE, --新增承辦待辦事項
                                        '13-02-01', VARECNNO || ' ' || VID || VARVENDOR || ' 設通調查表請填寫', --主旨
                                        VARECNNO || ' ' || VID || VARVENDOR || ' 設通調查表請填寫', --內容
                                        RTNWID);
                                        LI_WID := TO_NUMBER(RTNWID);
                                    END IF;

                                    SELECT
                                        S_T_EC_SURVEY_INFO.NEXTVAL INTO LI_SID
                                    FROM
                                        DUAL;
 -- 新增P_EC_SURVEY_INFO記錄(varUnit為Y 或 P 或 S皆要新增)
                                    INSERT INTO T_EC_SURVEY_INFO (
                                        SURVEY_ID,
                                        EC_ID,
                                        DIST_UNIT,
                                        DIST_VENDOR,
                                        SURVEY_TAKER,
                                        SURVEY_VENDOR_SDATE,
                                        SURVEY_VENDOR_PDATE,
                                        STATUS,
                                        WORKLISTID,
                                        UT_UNITID,
                                        SIGN_LEVEL,
                                        SIGN_LIST,
                                        CREATER,
                                        CREATE_DATE,
                                        MODIFYER,
                                        MODIFY_DATE,
                                        SURVEY_TITLE,
                                        SIGN_HISTORY
                                    ) VALUES (
                                        LI_SID,
                                        VAREID,
                                        VARUNIT,
                                        VID,
                                        UNDERTAKE,
                                        SYSDATE,
                                        SYSDATE + MDAY,
                                        VARSTATUS,
                                        LI_WID,
                                        LS_UT_UNITID,
                                        VARSIGNLEVEL,
                                        VARSIGNLIST,
                                        'SYS',
                                        SYSDATE,
                                        'SYS',
                                        SYSDATE,
                                        TITLE,
                                        ''
                                    );
                                ELSE
                                    LI_SID := 0;
                                    SELECT
                                        S.SURVEY_ID　 --檢查存在設通調查表
                                        INTO LI_SID
                                    FROM
                                        T_EC_SURVEY_INFO S
                                    WHERE
                                        S.EC_ID = VAREID
                                        AND S.DIST_UNIT = VARUNIT
                                        AND S.DIST_VENDOR = VID;
                                    IF LI_SID > 0 THEN
 --如果存在設通調查表
                                        LI_WID := 0;
                                        SELECT
                                            COUNT(*) --檢查存在待辦項目
                                            INTO LI_WID
                                        FROM
                                            T_SYS_WORKLIST T
                                        WHERE
                                            T.WORKLISTID IN (
                                                SELECT
                                                    S.WORKLISTID
                                                FROM
                                                    T_EC_SURVEY_INFO S
                                                WHERE
                                                    S.SURVEY_ID = LI_SID
                                            )
                                            AND MENUID = '13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
                                        IF LI_WID > 0 THEN
 --如果存在代辦項目
                                            UPDATE T_SYS_WORKLIST T --更新待辦項目
                                            SET
                                                T.USERID = UNDERTAKE,
                                                T.COMPTIME = NULL
                                            WHERE
                                                T.WORKLISTID IN (
                                                    SELECT
                                                        S.WORKLISTID
                                                    FROM
                                                        T_EC_SURVEY_INFO S
                                                    WHERE
                                                        S.SURVEY_ID = LI_SID
                                                )
                                                AND MENUID = '13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
                                        ELSE
                                            PA_SYS_WORKLIST.P_WORKLIST_ADD(UNDERTAKE, --新增待辦項目
                                            '13-02-01', VARECNNO || ' ' || VID || VARVENDOR || ' 設通調查表請填寫.', --主旨
                                            VARECNNO || ' ' || VID || VARVENDOR || ' 設通調查表請填寫.', --內容
                                            RTNWID);
                                            LI_WID := TO_NUMBER(RTNWID);
                                            UPDATE T_EC_SURVEY_INFO S
                                            SET
                                                S.WORKLISTID = RTNWID
                                            WHERE
                                                S.SURVEY_ID = LI_SID;
                                        END IF;
                                        UPDATE T_EC_SURVEY_INFO S --更新設通調查表承辦以及狀態
                                        SET
                                            S.SURVEY_TAKER = UNDERTAKE,
                                            S.STATUS = 'A06-1', --填單 承辦待處理
                                            S.RETURN_FLAG = 'N',
                                            S.ISALERT = 'N' -- A06-9 -> A06-1
                                        WHERE
                                            S.SURVEY_ID = LI_SID;
                                    END IF;
                                END IF;
 -- 新增P_EC_SUM記錄(survey), 統計用, vendor是該調查單位各自的廠商
                                CNT := 0;
                                SELECT
                                    COUNT(*) INTO CNT
                                FROM
                                    T_EC_SUM S
                                WHERE
                                    S.REPORT_TYPE = 'S'
                                    AND S.EC_ID = VAREID
                                    AND S.UNIT = VARUNIT;
                                SELECT
                                    SP.SUPPLIERNAME INTO VNAME
                                FROM
                                    T_ANP_SUPPLIER SP
                                WHERE
                                    SP.SUPPLIERCODE = VID;
                                IF UNDERTAKE <> 'SANYI' THEN
                                    SELECT
                                        E.NAME INTO VARUTNAME
                                    FROM
                                        T_SYS_EMPLOYINFO E
                                    WHERE
                                        E.EMPLOYNO = UNDERTAKE;
                                    VNAME := VNAME || '(' || VARUTNAME || ')';
                                END IF;

                                IF CNT > 0 THEN
                                    UPDATE T_EC_SUM S
                                    SET
                                        S.VENDOR_LIST_NA = S.VENDOR_LIST_NA || ',' || VNAME,
                                        S.VENDOR_LIST_ID = S.VENDOR_LIST_ID || ',' || VID
                                    WHERE
                                        S.REPORT_TYPE = 'S'
                                        AND S.EC_ID = VAREID
                                        AND S.UNIT = VARUNIT
                                        AND NOT S.VENDOR_LIST_ID LIKE '%' || VID || '%';
                                ELSE
                                    INSERT INTO T_EC_SUM (
                                        REPORT_TYPE,
                                        EC_ID,
                                        UNIT,
                                        VENDOR_LIST_ID,
                                        VENDOR_LIST_NA,
                                        STATUS,
                                        SDATE,
                                        PDATE,
                                        CREATER,
                                        CREATE_DATE,
                                        MODIFYER,
                                        MODIFY_DATE
                                    ) VALUES (
                                        'S',
                                        VAREID,
                                        VARUNIT,
                                        VID,
                                        VNAME,
                                        'A18-1',
                                        SYSDATE,
                                        SYSDATE + MDAY,
                                        'SYS',
                                        SYSDATE,
                                        'SYS',
                                        SYSDATE
                                    );
                                END IF;

                                COMMIT;
                            END IF;
                        ELSE
                            SELECT
                                SURVEY_ID INTO LI_SID
                            FROM
                                T_EC_SURVEY_INFO S
                            WHERE
                                S.EC_ID = VAREID
                                AND S.DIST_UNIT = VARUNIT
                                AND S.DIST_VENDOR = VID;
                        END IF;

                        IF LI_SID > 0 THEN
 --exists survey
 --新增P_EC_SURVEY_PARTS
                            VARPL_VID := VID;
                            FOR K IN 1 .. 3 LOOP
                                CNT := 0;
                                FOR P_FIELD IN CUR_EC_PARTS(VAREID, VARPL_VID, VARUNIT) LOOP
 --V件,changemake=A
                                    CNT := 1;
                                    LS_MODEL := '';
                                    LI_SP_CNT := 0;
                                    IF VARUNIT <> 'S' THEN
                                        LS_MODEL := 'EC';
                                        LI_SP_CNT := 1;
                                    ELSE
                                        LS_MODEL := PDM_MODELS;
                                        LI_SP_CNT := 5; --SANYI五組
                                    END IF;

                                    FOR C_FIELD2 IN CUR_STRSPLIT2(LS_MODEL) LOOP
 --各車系loop
                                        MODEL := C_FIELD2.STR2;
                                        CNT2_MODEL := 0;
                                        FOR M_FIELD IN CUR_MODEL_TAKER(MODEL) LOOP
 --抓取車系承辦
                                            CNT2_MODEL := 1;
                                            FOR I IN 1 .. LI_SP_CNT LOOP
                                                IF VARUNIT = 'S' THEN
                                                    CASE I
                                                        WHEN 1 THEN
                                                            UNDERTAKE := M_FIELD.S377_UNDERTAKER; --K0L00
                                                        WHEN 2 THEN
                                                            UNDERTAKE := M_FIELD.S391_UNDERTAKER; --K0Q00 動力生技組
                                                        WHEN 3 THEN
                                                            UNDERTAKE := M_FIELD.PAINT_UNDERTAKER; --K0K00
                                                        WHEN 4 THEN
                                                            UNDERTAKE := M_FIELD.BODY_UNDERTAKER; --K0J00
                                                        WHEN 5 THEN
                                                            UNDERTAKE := M_FIELD.MODE_UNDERTAKER; --K0R00 壓造生技組
                                                    END CASE;
                                                END IF;

                                                LI_SSID := 0;
                                                IF UNDERTAKE IS NOT NULL AND VARUNIT = 'S' THEN --如果調查單位是三義工廠的話
                                                    SELECT
                                                        COUNT(*) INTO LI_SSUNIT
                                                    FROM
                                                        T_SYS_GLOSSARY G
                                                    WHERE
                                                        G.GLOSSARYTYPEID LIKE 'A02%'
                                                        AND G.GLOSSARY3 = I
                                                        AND G.STATE = 'Y';
                                                    IF LI_SSUNIT > 0 THEN
                                                        SELECT
                                                            GLOSSARY2 INTO LS_UT_UNITID
                                                        FROM
                                                            T_SYS_GLOSSARY G
                                                        WHERE
                                                            G.GLOSSARYTYPEID LIKE 'A02%'
                                                            AND G.GLOSSARY3 = I
                                                            AND G.STATE = 'Y';
                                                        SELECT
                                                            COUNT(*) --查看有沒有待辦事項
                                                            INTO LI_SSID
                                                        FROM
                                                            T_EC_SANYI SI
                                                        WHERE
                                                            SI.SURVEY_ID_FK = LI_SID
                                                            AND SI.SANYI_UNIT = LS_UT_UNITID
                                                            AND SI.CAR = MODEL; --不用承辦，可能會換
                                                        IF LI_SSID = 0 THEN
                                                            PA_SYS_WORKLIST.P_WORKLIST_ADD(UNDERTAKE, --新增三義承辦待辦事項
                                                            '13-02-06', '填寫' || VARECNNO || '廠商調查通知單(SANYI)', '填寫' || VARECNNO || '廠商調查通知單(SANYI)', RTNWID);
                                                            LI_WID := TO_NUMBER(RTNWID);
                                                            SELECT
                                                                S_T_EC_SANYI.NEXTVAL INTO LI_SSID
                                                            FROM
                                                                DUAL;
                                                            SELECT
                                                                G.GLOSSARY4, --新增簽核層級
                                                                G.GLOSSARY1 INTO VARSIGNLIST,
                                                                VARSIGNLEVEL
                                                            FROM
                                                                T_SYS_GLOSSARY G
                                                            WHERE
                                                                G.GLOSSARYTYPEID LIKE 'A11%'
                                                                AND G.GLOSSARY2 = 'Y'
                                                                AND (G.GLOSSARY3 = LS_UT_UNITID
                                                                OR G.GLOSSARY3 = (
                                                                    SELECT
                                                                        E.DEPARTMENTID
                                                                    FROM
                                                                        T_SYS_EMPLOYINFO E
                                                                    WHERE
                                                                        E.UNITID = LS_UT_UNITID
                                                                        AND ROWNUM <= 1
                                                                ));
                                                            INSERT INTO T_EC_SANYI --新增三義工廠調查表
                                                            (
                                                                SS_ID,
                                                                EC_ID_FK,
                                                                SURVEY_ID_FK,
                                                                SANYI_UNIT,
                                                                CAR,
                                                                UNDERTAKER,
                                                                WORKLISTID,
                                                                STATUS,
                                                                SIGN_LEVEL,
                                                                SIGN_LIST,
                                                                CREATER,
                                                                CREATE_DATE,
                                                                MODIFYER,
                                                                MODIFY_DATE
                                                            ) VALUES (
                                                                LI_SSID,
                                                                VAREID,
                                                                LI_SID,
                                                                LS_UT_UNITID,
                                                                MODEL,
                                                                UNDERTAKE,
                                                                LI_WID,
                                                                'A06-D',
                                                                VARSIGNLEVEL,
                                                                VARSIGNLIST,
                                                                'SYS',
                                                                SYSDATE,
                                                                'SYS',
                                                                SYSDATE
                                                            );
                                                        ELSE
                                                            SELECT
                                                                SI.SS_ID INTO LI_SSID
                                                            FROM
                                                                T_EC_SANYI SI
                                                            WHERE
                                                                SI.SURVEY_ID_FK = LI_SID
                                                                AND SI.SANYI_UNIT = LS_UT_UNITID
                                                                AND SI.CAR = MODEL;
                                                        END IF;
 --INSERT INTO P_EC_SANYI_UNIT
                                                        DATACOUNT2 := 0;
                                                        SELECT
                                                            COUNT(*) INTO DATACOUNT2
                                                        FROM
                                                            T_EC_SANYI_UNIT SI
                                                        WHERE
                                                            SI.SURVEY_ID_FK2 = LI_SID
                                                            AND SI.SANYI_UNIT2 = LS_UT_UNITID;
                                                        IF DATACOUNT2 = 0 THEN
                                                            INSERT INTO T_EC_SANYI_UNIT (
                                                                SURVEY_ID_FK2,
                                                                SANYI_UNIT2,
                                                                SIGN_HISTORY
                                                            ) VALUES (
                                                                LI_SID,
                                                                LS_UT_UNITID,
                                                                ''
                                                            );
                                                        END IF;
                                                    END IF; -- end of "IF li_ssunit > 0 THEN"
                                                END IF;

                                                IF VARUNIT <> 'S' OR VARUNIT = 'S' AND LI_SSID > 0 THEN
 --找不到承辦時ssid會為0
 --varpl_id := 86789;
                                                    DATACOUNT2 := 0; --處理P_EC_survey_parts
                                                    SELECT
                                                        COUNT(*) INTO DATACOUNT2
                                                    FROM
                                                        T_EC_SURVEY_PARTS P
                                                    WHERE
                                                        P.SURVEY_ID = LI_SID
                                                        AND P.PL_ID = P_FIELD.PL_ID
                                                        AND P.SS_ID_FK = LI_SSID;
                                                    IF DATACOUNT2 = 0 THEN
                                                        SELECT
                                                            S_T_EC_SURVEY_PARTS.NEXTVAL INTO SURVEY_PSRTS_ID
                                                        FROM
                                                            DUAL;
 -- 依適用車系產生多筆記錄，各車型承辦請參照A14要件-車型承辦sheet
                                                        INSERT INTO T_EC_SURVEY_PARTS (
                                                            SURVEY_PARTS_ID,
                                                            EC_ID,
                                                            SURVEY_ID,
                                                            PL_ID,
                                                            SS_ID_FK,
                                                            CREATER,
                                                            CREATE_DATE,
                                                            MODIFYER,
                                                            MODIFY_DATE
                                                        ) VALUES (
                                                            SURVEY_PSRTS_ID,
                                                            VAREID,
                                                            LI_SID,
                                                            P_FIELD.PL_ID,
                                                            LI_SSID,
                                                            'SYS',
                                                            SYSDATE,
                                                            'SYS',
                                                            SYSDATE
                                                        );
                                                    END IF;
                                                END IF;
                                            END LOOP;
                                        END LOOP;

                                        IF CNT2_MODEL = 0 THEN
 --車型檔抓不到資料
                                            VARNG_NOMODEL := VARNG_NOMODEL || LS_MODEL || ', ';
                                        END IF;
                                    END LOOP;

                                    COMMIT;
                                END LOOP; --新增P_EC_SURVEY_PARTS
                                IF K = 1 AND CNT = 0 THEN
 --by廠商,無V件.
                                    VARPL_VID := '%';
                                END IF;

                                IF K = 2 AND CNT = 0 THEN
 --此ecn無V件.
                                    VARPL_VID := 'NA'; --跑第3次，新增NA件號
                                    SELECT
                                        COUNT(*) INTO CNT
                                    FROM
                                        T_EC_SURVEY_INFO S
                                    WHERE
                                        S.SURVEY_ID = LI_SID
                                        AND (S.SIGN_HISTORY IS NOT NULL);
                                    IF CNT = 1 THEN
 --history有值, 避免重跑把值蓋掉
                                        UPDATE T_EC_SURVEY_INFO S
                                        SET
                                            S.SIGN_HISTORY = S.SIGN_HISTORY || '，' || TO_CHAR(
                                                SYSDATE,
                                                'yyyy/mm/dd HH24:MM:SS'
                                            ) || ' SYS:此ECN無零件' || CHR(
                                                10
                                            )
                                        WHERE
                                            S.SURVEY_ID = LI_SID; -- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
                                    ELSE
                                        UPDATE T_EC_SURVEY_INFO S
                                        SET
                                            S.SIGN_HISTORY = '1.' || TO_CHAR(
                                                SYSDATE,
                                                'yyyy/mm/dd HH24:MM:SS'
                                            ) || ' SYS:此ECN無零件' || CHR(
                                                10
                                            )
                                        WHERE
                                            S.SURVEY_ID = LI_SID; -- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
                                    END IF;
                                END IF;
                            END LOOP; -- k=1 to 3
                            COMMIT;
                        ELSE
                            I := 3; -- exit
                        END IF; --IF li_sid > 0 THEN
                        I := I + 1;
                        IF VARUNIT2 = 'Y' THEN
                            VARUNIT := 'Y'; --追加分發零技科
                        END IF;

                        EXIT WHEN I > J;
                    END LOOP;
                ELSE
 -- <> Y P S
                    IF VARUNIT = 'A' THEN
 --IF varVid = '---' OR varVid IS NULL OR varVid = ' ' OR varVid = 'KD'THEN
                        VARNG_NOVENDORID := VARNG_NOVENDORID || VID || ', ';
                    ELSE
                        IF VARUNIT = 'B' THEN
 --廠商ID在t_anp_supplier找不到時開發承辦找不到
                            VARNG_VENDORDEV := VARNG_VENDORDEV || VID || ', ';
                        END IF;
                    END IF;
                END IF;
            END LOOP; -- for vendor_list
            IF VARNG_VENDORDEV = ':' AND VARNG_NOVENDORID = ':' AND VARNG_VENDORIDNOT4 = ':' AND VARNG_NOMODEL = ':' AND VARNG_VENDOR = ':' THEN
                UPDATE T_EC_INFO E
                SET
                    E.STATUS = 'A04-2'
                WHERE
                    E.EC_ID = VAREID
                    AND E.STATUS = 'A04-1'; --廠商調查中
            ELSE
                VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARECNNO || '：';
                IF VARNG_VENDORDEV <> ':' THEN
                    VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARSP || ' ANPQP-廠商對照開發承辦錯誤' || SUBSTR(VARNG_VENDORDEV, 1, LENGTH(VARNG_VENDORDEV) - 2);
                END IF;

                IF VARNG_NOVENDORID <> ':' THEN
                    VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARSP || ' 廠商ID在ANPQP系統未設定' || VARNG_NOVENDORID;
                END IF;

                IF VARNG_VENDORIDNOT4 <> ':' THEN
                    VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARSP || ' 廠商ID長度<>4' || SUBSTR(VARNG_VENDORIDNOT4, 1, LENGTH(VARNG_VENDORIDNOT4) - 2);
                END IF;

                IF VARNG_NOMODEL <> ':' THEN
                    VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARSP || ' 車型未設定' || SUBSTR(VARNG_NOMODEL, 1, LENGTH(VARNG_NOMODEL) - 2);
                    SELECT
                        F_SYS_EMPLOYINFO_GETMAIL3BYNO(F_SYS_GLOSSARY_GETNAMEBYFIELD('A14-3',
                        2)) INTO VARMAIL3
                    FROM
                        DUAL; --零管科窗口
                    VARMAIL := VARMAIL || ',' || VARMAIL3;
                END IF;

                VARNG_MSG := VARNG_MSG || '<BR>';
                UPDATE T_EC_INFO E
                SET
                    E.STATUS = 'A04-6',
                    E.WORKLISTID = 0
                WHERE
                    E.EC_ID = VAREID; --廠商調查_退回
            END IF;
        ELSE
 --不分發，直接轉切換調查
            IF VENDOR_SURVEY = 'N' AND (VENDOR_LIST IS NOT NULL
            OR VENDOR_LIST <> ' ') AND INSTR('KD,kd,---', VENDOR_LIST) = 0 THEN
                VARNG_VENDOR := VARNG_VENDOR || VARECNNO || ', ';
                VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || ' 廠商調查FLAG與LIST不一致' || SUBSTR(VARNG_VENDOR, 1, LENGTH(VARNG_VENDOR) - 2) || ',' || VARSP || VENDOR_SURVEY || ',' || VARSP || VENDOR_LIST || '<BR>';
                UPDATE T_EC_INFO E
                SET
                    E.STATUS = 'A04-6',
                    E.WORKLISTID = 0
                WHERE
                    E.EC_ID = VAREID; --廠商調查_退回
            ELSE
                P_EC_ADD_CHG_INFO(VAREID, TITLE, PDM_MODELS);
            END IF;
        END IF;

        COMMIT;
    END LOOP; --FOR ec_info IN ec_info_list LOOP
    IF VARNG_MSG IS NOT NULL THEN
        VARNG_MSG := '<html><body>您好!：' || VARNG_MSG || '</html></body>';
        P_SYS_MAIL_ADD(VARMAIL, VARMAIL2, 'ESS【異常提醒】設變調查e化-廠商分發', VARNG_MSG, '', 'Y', '', '', RTNMID); --成功:MailID;  失敗:-1
 --P_SYS_Mail_Add('515873', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
 --P_SYS_Mail_Add('A14-9,2', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
        SELECT
            F_SYS_GLOSSARY_GETNAMEBYFIELD('A14-2',
            2) INTO UNDERTAKE
        FROM
            DUAL; --資管科窗口 920286
        PA_SYS_WORKLIST.P_WORKLIST_ADD(UNDERTAKE, '13-02-08', '【異常提醒】設變調查e化-廠商分發', --主旨
        '【異常提醒】設變調查e化-廠商分發', --內容
        RTNWID);
        LI_WID := TO_NUMBER(RTNWID);
        UPDATE T_SYS_WORKLIST W
        SET
            W.COMPTIME = SYSDATE
        WHERE
            W.WORKLISTID IN (
                SELECT
                    E.WORKLISTID
                FROM
                    T_EC_INFO E
                WHERE
                    E.STATUS = 'A04-6'
                    AND E.WORKLISTID = 0
            );
        UPDATE T_EC_INFO E
        SET
            E.WORKLISTID = LI_WID
        WHERE
            E.STATUS = 'A04-6'
            AND E.WORKLISTID = 0;
    END IF;

    COMMIT;
    P_EC_STATUS_CAL(); --調查/切換, 會辦中狀態改為逾期
    COMMIT;
 --OutResult := '0';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
 --OutResult := '-1';
        VARSQLERRM := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('err=' || VARSQLERRM);
END P_EC_DISTTAKERSURVEY;

IF LI_SID > 0 THEN
 --如果存在設通調查表
    LI_WID := 0;
    SELECT
        COUNT(*) --檢查存在待辦項目
        INTO LI_WID
    FROM
        T_SYS_WORKLIST T
    WHERE
        T.WORKLISTID IN (
            SELECT
                S.WORKLISTID
            FROM
                T_EC_SURVEY_INFO S
            WHERE
                S.SURVEY_ID = LI_SID
        )
        AND MENUID = '13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
    IF LI_WID > 0 THEN
 --如果存在代辦項目
        UPDATE T_SYS_WORKLIST T --更新待辦項目
        SET
            T.USERID = UNDERTAKE,
            T.COMPTIME = NULL
        WHERE
            T.WORKLISTID IN (
                SELECT
                    S.WORKLISTID
                FROM
                    T_EC_SURVEY_INFO S
                WHERE
                    S.SURVEY_ID = LI_SID
            )
            AND MENUID = '13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
    ELSE
        PA_SYS_WORKLIST.P_WORKLIST_ADD(UNDERTAKE, --新增待辦項目
        '13-02-01', VARECNNO || ' ' || VID || VARVENDOR || ' 設通調查表請填寫.', --主旨
        VARECNNO || ' ' || VID || VARVENDOR || ' 設通調查表請填寫.', --內容
        RTNWID);
        LI_WID := TO_NUMBER(RTNWID);
        UPDATE T_EC_SURVEY_INFO S
        SET
            S.WORKLISTID = RTNWID
        WHERE
            S.SURVEY_ID = LI_SID;
    END IF;
    UPDATE T_EC_SURVEY_INFO S --更新設通調查表承辦以及狀態
    SET
        S.SURVEY_TAKER = UNDERTAKE,
        S.STATUS = 'A06-1', --填單 承辦待處理
        S.RETURN_FLAG = 'N',
        S.ISALERT = 'N' -- A06-9 -> A06-1
    WHERE
        S.SURVEY_ID = LI_SID;
END IF;
END IF;
 -- 新增P_EC_SUM記錄(survey), 統計用, vendor是該調查單位各自的廠商
CNT := 0;
SELECT
    COUNT(*) INTO CNT
FROM
    T_EC_SUM S
WHERE
    S.REPORT_TYPE = 'S'
    AND S.EC_ID = VAREID
    AND S.UNIT = VARUNIT;
SELECT
    SP.SUPPLIERNAME INTO VNAME
FROM
    T_ANP_SUPPLIER SP
WHERE
    SP.SUPPLIERCODE = VID;
IF UNDERTAKE <> 'SANYI' THEN
    SELECT
        E.NAME INTO VARUTNAME
    FROM
        T_SYS_EMPLOYINFO E
    WHERE
        E.EMPLOYNO = UNDERTAKE;
    VNAME := VNAME || '(' || VARUTNAME || ')';
END IF;

IF CNT > 0 THEN
    UPDATE T_EC_SUM S
    SET
        S.VENDOR_LIST_NA = S.VENDOR_LIST_NA || ',' || VNAME,
        S.VENDOR_LIST_ID = S.VENDOR_LIST_ID || ',' || VID
    WHERE
        S.REPORT_TYPE = 'S'
        AND S.EC_ID = VAREID
        AND S.UNIT = VARUNIT
        AND NOT S.VENDOR_LIST_ID LIKE '%' || VID || '%';
ELSE
    INSERT INTO T_EC_SUM (
        REPORT_TYPE,
        EC_ID,
        UNIT,
        VENDOR_LIST_ID,
        VENDOR_LIST_NA,
        STATUS,
        SDATE,
        PDATE,
        CREATER,
        CREATE_DATE,
        MODIFYER,
        MODIFY_DATE
    ) VALUES (
        'S',
        VAREID,
        VARUNIT,
        VID,
        VNAME,
        'A18-1',
        SYSDATE,
        SYSDATE + MDAY,
        'SYS',
        SYSDATE,
        'SYS',
        SYSDATE
    );
END IF;

COMMIT;
END IF;
ELSE
    SELECT
        SURVEY_ID INTO LI_SID
    FROM
        T_EC_SURVEY_INFO S
    WHERE
        S.EC_ID = VAREID
        AND S.DIST_UNIT = VARUNIT
        AND S.DIST_VENDOR = VID;
END IF;
IF LI_SID > 0 THEN
 --exists survey
 --新增P_EC_SURVEY_PARTS
    VARPL_VID := VID;
    FOR K IN 1 .. 3 LOOP
        CNT := 0;
        FOR P_FIELD IN CUR_EC_PARTS(VAREID, VARPL_VID, VARUNIT) LOOP
 --V件,changemake=A
            CNT := 1;
            LS_MODEL := '';
            LI_SP_CNT := 0;
            IF VARUNIT <> 'S' THEN
                LS_MODEL := 'EC';
                LI_SP_CNT := 1;
            ELSE
                LS_MODEL := PDM_MODELS;
                LI_SP_CNT := 5; --SANYI五組
            END IF;

            FOR C_FIELD2 IN CUR_STRSPLIT2(LS_MODEL) LOOP
 --各車系loop
                MODEL := C_FIELD2.STR2;
                CNT2_MODEL := 0;
                FOR M_FIELD IN CUR_MODEL_TAKER(MODEL) LOOP
 --抓取車系承辦
                    CNT2_MODEL := 1;
                    FOR I IN 1 .. LI_SP_CNT LOOP
                        IF VARUNIT = 'S' THEN
                            CASE I
                                WHEN 1 THEN
                                    UNDERTAKE := M_FIELD.S377_UNDERTAKER; --K0L00
                                WHEN 2 THEN
                                    UNDERTAKE := M_FIELD.S391_UNDERTAKER; --K0Q00 動力生技組
                                WHEN 3 THEN
                                    UNDERTAKE := M_FIELD.PAINT_UNDERTAKER; --K0K00
                                WHEN 4 THEN
                                    UNDERTAKE := M_FIELD.BODY_UNDERTAKER; --K0J00
                                WHEN 5 THEN
                                    UNDERTAKE := M_FIELD.MODE_UNDERTAKER; --K0R00 壓造生技組
                            END CASE;
                        END IF;

                        LI_SSID := 0;
                        IF UNDERTAKE IS NOT NULL AND VARUNIT = 'S' THEN --如果調查單位是三義工廠的話
                            SELECT
                                COUNT(*) INTO LI_SSUNIT
                            FROM
                                T_SYS_GLOSSARY G
                            WHERE
                                G.GLOSSARYTYPEID LIKE 'A02%'
                                AND G.GLOSSARY3 = I
                                AND G.STATE = 'Y';
                            IF LI_SSUNIT > 0 THEN
                                SELECT
                                    GLOSSARY2 INTO LS_UT_UNITID
                                FROM
                                    T_SYS_GLOSSARY G
                                WHERE
                                    G.GLOSSARYTYPEID LIKE 'A02%'
                                    AND G.GLOSSARY3 = I
                                    AND G.STATE = 'Y';
                                SELECT
                                    COUNT(*) --查看有沒有待辦事項
                                    INTO LI_SSID
                                FROM
                                    T_EC_SANYI SI
                                WHERE
                                    SI.SURVEY_ID_FK = LI_SID
                                    AND SI.SANYI_UNIT = LS_UT_UNITID
                                    AND SI.CAR = MODEL; --不用承辦，可能會換
                                IF LI_SSID = 0 THEN
                                    PA_SYS_WORKLIST.P_WORKLIST_ADD(UNDERTAKE, --新增三義承辦待辦事項
                                    '13-02-06', '填寫' || VARECNNO || '廠商調查通知單(SANYI)', '填寫' || VARECNNO || '廠商調查通知單(SANYI)', RTNWID);
                                    LI_WID := TO_NUMBER(RTNWID);
                                    SELECT
                                        S_T_EC_SANYI.NEXTVAL INTO LI_SSID
                                    FROM
                                        DUAL;
                                    SELECT
                                        G.GLOSSARY4, --新增簽核層級
                                        G.GLOSSARY1 INTO VARSIGNLIST,
                                        VARSIGNLEVEL
                                    FROM
                                        T_SYS_GLOSSARY G
                                    WHERE
                                        G.GLOSSARYTYPEID LIKE 'A11%'
                                        AND G.GLOSSARY2 = 'Y'
                                        AND (G.GLOSSARY3 = LS_UT_UNITID
                                        OR G.GLOSSARY3 = (
                                            SELECT
                                                E.DEPARTMENTID
                                            FROM
                                                T_SYS_EMPLOYINFO E
                                            WHERE
                                                E.UNITID = LS_UT_UNITID
                                                AND ROWNUM <= 1
                                        ));
                                    INSERT INTO T_EC_SANYI --新增三義工廠調查表
                                    (
                                        SS_ID,
                                        EC_ID_FK,
                                        SURVEY_ID_FK,
                                        SANYI_UNIT,
                                        CAR,
                                        UNDERTAKER,
                                        WORKLISTID,
                                        STATUS,
                                        SIGN_LEVEL,
                                        SIGN_LIST,
                                        CREATER,
                                        CREATE_DATE,
                                        MODIFYER,
                                        MODIFY_DATE
                                    ) VALUES (
                                        LI_SSID,
                                        VAREID,
                                        LI_SID,
                                        LS_UT_UNITID,
                                        MODEL,
                                        UNDERTAKE,
                                        LI_WID,
                                        'A06-D',
                                        VARSIGNLEVEL,
                                        VARSIGNLIST,
                                        'SYS',
                                        SYSDATE,
                                        'SYS',
                                        SYSDATE
                                    );
                                ELSE
                                    SELECT
                                        SI.SS_ID INTO LI_SSID
                                    FROM
                                        T_EC_SANYI SI
                                    WHERE
                                        SI.SURVEY_ID_FK = LI_SID
                                        AND SI.SANYI_UNIT = LS_UT_UNITID
                                        AND SI.CAR = MODEL;
                                END IF;
 --INSERT INTO P_EC_SANYI_UNIT
                                DATACOUNT2 := 0;
                                SELECT
                                    COUNT(*) INTO DATACOUNT2
                                FROM
                                    T_EC_SANYI_UNIT SI
                                WHERE
                                    SI.SURVEY_ID_FK2 = LI_SID
                                    AND SI.SANYI_UNIT2 = LS_UT_UNITID;
                                IF DATACOUNT2 = 0 THEN
                                    INSERT INTO T_EC_SANYI_UNIT (
                                        SURVEY_ID_FK2,
                                        SANYI_UNIT2,
                                        SIGN_HISTORY
                                    ) VALUES (
                                        LI_SID,
                                        LS_UT_UNITID,
                                        ''
                                    );
                                END IF;
                            END IF; -- end of "IF li_ssunit > 0 THEN"
                        END IF;

                        IF VARUNIT <> 'S' OR VARUNIT = 'S' AND LI_SSID > 0 THEN
 --找不到承辦時ssid會為0
 --varpl_id := 86789;
                            DATACOUNT2 := 0; --處理P_EC_survey_parts
                            SELECT
                                COUNT(*) INTO DATACOUNT2
                            FROM
                                T_EC_SURVEY_PARTS P
                            WHERE
                                P.SURVEY_ID = LI_SID
                                AND P.PL_ID = P_FIELD.PL_ID
                                AND P.SS_ID_FK = LI_SSID;
                            IF DATACOUNT2 = 0 THEN
                                SELECT
                                    S_T_EC_SURVEY_PARTS.NEXTVAL INTO SURVEY_PSRTS_ID
                                FROM
                                    DUAL;
 -- 依適用車系產生多筆記錄，各車型承辦請參照A14要件-車型承辦sheet
                                INSERT INTO T_EC_SURVEY_PARTS (
                                    SURVEY_PARTS_ID,
                                    EC_ID,
                                    SURVEY_ID,
                                    PL_ID,
                                    SS_ID_FK,
                                    CREATER,
                                    CREATE_DATE,
                                    MODIFYER,
                                    MODIFY_DATE
                                ) VALUES (
                                    SURVEY_PSRTS_ID,
                                    VAREID,
                                    LI_SID,
                                    P_FIELD.PL_ID,
                                    LI_SSID,
                                    'SYS',
                                    SYSDATE,
                                    'SYS',
                                    SYSDATE
                                );
                            END IF;
                        END IF;
                    END LOOP;
                END LOOP;

                IF CNT2_MODEL = 0 THEN
 --車型檔抓不到資料
                    VARNG_NOMODEL := VARNG_NOMODEL || LS_MODEL || ', ';
                END IF;
            END LOOP;

            COMMIT;
        END LOOP; --新增P_EC_SURVEY_PARTS
        IF K = 1 AND CNT = 0 THEN
 --by廠商,無V件.
            VARPL_VID := '%';
        END IF;

        IF K = 2 AND CNT = 0 THEN
 --此ecn無V件.
            VARPL_VID := 'NA'; --跑第3次，新增NA件號
            SELECT
                COUNT(*) INTO CNT
            FROM
                T_EC_SURVEY_INFO S
            WHERE
                S.SURVEY_ID = LI_SID
                AND (S.SIGN_HISTORY IS NOT NULL);
            IF CNT = 1 THEN
 --history有值, 避免重跑把值蓋掉
                UPDATE T_EC_SURVEY_INFO S
                SET
                    S.SIGN_HISTORY = S.SIGN_HISTORY || '，' || TO_CHAR(
                        SYSDATE,
                        'yyyy/mm/dd HH24:MM:SS'
                    ) || ' SYS:此ECN無零件' || CHR(
                        10
                    )
                WHERE
                    S.SURVEY_ID = LI_SID; -- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
            ELSE
                UPDATE T_EC_SURVEY_INFO S
                SET
                    S.SIGN_HISTORY = '1.' || TO_CHAR(
                        SYSDATE,
                        'yyyy/mm/dd HH24:MM:SS'
                    ) || ' SYS:此ECN無零件' || CHR(
                        10
                    )
                WHERE
                    S.SURVEY_ID = LI_SID; -- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
            END IF;
        END IF;
    END LOOP; -- k=1 to 3
    COMMIT;
ELSE
    I := 3; -- exit
END IF; --IF li_sid > 0 THEN
I := I + 1;
IF VARUNIT2 = 'Y' THEN
    VARUNIT := 'Y'; --追加分發零技科
END IF;

EXIT WHEN I > J;
END LOOP;
ELSE
 -- <> Y P S
    IF VARUNIT = 'A' THEN
 --IF varVid = '---' OR varVid IS NULL OR varVid = ' ' OR varVid = 'KD'THEN
        VARNG_NOVENDORID := VARNG_NOVENDORID || VID || ', ';
    ELSE
        IF VARUNIT = 'B' THEN
 --廠商ID在t_anp_supplier找不到時開發承辦找不到
            VARNG_VENDORDEV := VARNG_VENDORDEV || VID || ', ';
        END IF;
    END IF;
END IF;
END LOOP; -- for vendor_list
IF VARNG_VENDORDEV = ':' AND VARNG_NOVENDORID = ':' AND VARNG_VENDORIDNOT4 = ':' AND VARNG_NOMODEL = ':' AND VARNG_VENDOR = ':' THEN
    UPDATE T_EC_INFO E
    SET
        E.STATUS = 'A04-2'
    WHERE
        E.EC_ID = VAREID
        AND E.STATUS = 'A04-1'; --廠商調查中
ELSE
    VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARECNNO || '：';
    IF VARNG_VENDORDEV <> ':' THEN
        VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARSP || ' ANPQP-廠商對照開發承辦錯誤' || SUBSTR(VARNG_VENDORDEV, 1, LENGTH(VARNG_VENDORDEV) - 2);
    END IF;

    IF VARNG_NOVENDORID <> ':' THEN
        VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARSP || ' 廠商ID在ANPQP系統未設定' || VARNG_NOVENDORID;
    END IF;

    IF VARNG_VENDORIDNOT4 <> ':' THEN
        VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARSP || ' 廠商ID長度<>4' || SUBSTR(VARNG_VENDORIDNOT4, 1, LENGTH(VARNG_VENDORIDNOT4) - 2);
    END IF;

    IF VARNG_NOMODEL <> ':' THEN
        VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || VARSP || ' 車型未設定' || SUBSTR(VARNG_NOMODEL, 1, LENGTH(VARNG_NOMODEL) - 2);
        SELECT
            F_SYS_EMPLOYINFO_GETMAIL3BYNO(F_SYS_GLOSSARY_GETNAMEBYFIELD('A14-3',
            2)) INTO VARMAIL3
        FROM
            DUAL; --零管科窗口
        VARMAIL := VARMAIL || ',' || VARMAIL3;
    END IF;

    VARNG_MSG := VARNG_MSG || '<BR>';
    UPDATE T_EC_INFO E
    SET
        E.STATUS = 'A04-6',
        E.WORKLISTID = 0
    WHERE
        E.EC_ID = VAREID; --廠商調查_退回
END IF;
ELSE
 --不分發，直接轉切換調查
    IF VENDOR_SURVEY = 'N' AND (VENDOR_LIST IS NOT NULL
    OR VENDOR_LIST <> ' ') AND INSTR('KD,kd,---', VENDOR_LIST) = 0 THEN
        VARNG_VENDOR := VARNG_VENDOR || VARECNNO || ', ';
        VARNG_MSG := VARNG_MSG || '<BR>' || VARSP || ' 廠商調查FLAG與LIST不一致' || SUBSTR(VARNG_VENDOR, 1, LENGTH(VARNG_VENDOR) - 2) || ',' || VARSP || VENDOR_SURVEY || ',' || VARSP || VENDOR_LIST || '<BR>';
        UPDATE T_EC_INFO E
        SET
            E.STATUS = 'A04-6',
            E.WORKLISTID = 0
        WHERE
            E.EC_ID = VAREID; --廠商調查_退回
    ELSE
        P_EC_ADD_CHG_INFO(VAREID, TITLE, PDM_MODELS);
    END IF;
END IF;
COMMIT;
END LOOP; --FOR ec_info IN ec_info_list LOOP
IF VARNG_MSG IS NOT NULL THEN
    VARNG_MSG := '<html><body>您好!：' || VARNG_MSG || '</html></body>';
    P_SYS_MAIL_ADD(VARMAIL, VARMAIL2, 'ESS【異常提醒】設變調查e化-廠商分發', VARNG_MSG, '', 'Y', '', '', RTNMID); --成功:MailID;  失敗:-1
 --P_SYS_Mail_Add('515873', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
 --P_SYS_Mail_Add('A14-9,2', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
    SELECT
        F_SYS_GLOSSARY_GETNAMEBYFIELD('A14-2',
        2) INTO UNDERTAKE
    FROM
        DUAL; --資管科窗口 920286
    PA_SYS_WORKLIST.P_WORKLIST_ADD(UNDERTAKE, '13-02-08', '【異常提醒】設變調查e化-廠商分發', --主旨
    '【異常提醒】設變調查e化-廠商分發', --內容
    RTNWID);
    LI_WID := TO_NUMBER(RTNWID);
    UPDATE T_SYS_WORKLIST W
    SET
        W.COMPTIME = SYSDATE
    WHERE
        W.WORKLISTID IN (
            SELECT
                E.WORKLISTID
            FROM
                T_EC_INFO E
            WHERE
                E.STATUS = 'A04-6'
                AND E.WORKLISTID = 0
        );
    UPDATE T_EC_INFO E
    SET
        E.WORKLISTID = LI_WID
    WHERE
        E.STATUS = 'A04-6'
        AND E.WORKLISTID = 0;
END IF;

COMMIT;
P_EC_STATUS_CAL(); --調查/切換, 會辦中狀態改為逾期
COMMIT;
 --OutResult := '0';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
 --OutResult := '-1';
        VARSQLERRM := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('err=' || VARSQLERRM);
END P_EC_DISTTAKERSURVEY;