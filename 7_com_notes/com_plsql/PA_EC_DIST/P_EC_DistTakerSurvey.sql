CREATE OR REPLACE PACKAGE BODY "PA_EC_DIST" AS
  PROCEDURE P_EC_DistTakerSurvey
       /* 前置作業：plm的ec及pl轉入 t_ec_info, t_pl_info
        *   A04 廠商分發
        *     1. 提醒承辦開始調查
        *     2. 若不須廠商調查則直接進行零件切換調查(生管,行銷,零服)
        * @author cyc
       */
    --   OutResult OUT VARCHAR --,0,儲存成功 --,-1,儲存失敗
   AS
    varEid          int;
    vendor_list     VARCHAR2(100); --G149,A101
    vendor_survey   VARCHAR2(1); --Y OR N
    UNDERTAKE       VARCHAR2(100);
    vid             VARCHAR2(12); --G149
    i               int;
    j               int;
    k               int;
    mday            int;
    li_wid          int;
    datacount1      NUMBER;
    datacount2      NUMBER;
    li_sid          NUMBER;
    cnt             int;
    cnt2_model      int;
    li_sp_cnt       int;
    SURVEY_PSRTS_ID NUMBER;
    li_ssid         NUMBER;
    rtnWid          VARCHAR2(50);
    rtnMid          VARCHAR2(50);
    varUnit         VARCHAR2(1);
    varUnit2        VARCHAR2(1); --追加分發零技科, Y OR ''
    varmTag         VARCHAR2(10);
    varStatus       VARCHAR2(10);
    ls_UT_UNITID    VARCHAR2(10);
    model           VARCHAR2(10);
    PDM_MODELS      VARCHAR2(100);
    ls_model        VARCHAR2(100);
    title           VARCHAR2(500);
    adpt            VARCHAR2(50);
    desgrp          VARCHAR2(50);
    varMail         VARCHAR2(250);
    varMail2        VARCHAR2(250);
    varMail3        VARCHAR2(250);
    varNg_VendorDev    VARCHAR2(1024);
    varNg_NoVendorId    VARCHAR2(1024);
    varNg_VendorIdNot4   VARCHAR2(1024);
    varNg_NoModel   VARCHAR2(1024);
    varNg_Msg       VARCHAR2(2024);
    varNg_Vendor    VARCHAR2(2024);
    varSP           VARCHAR2(512);
    varSignList     int;
    varSignLevel    NVARCHAR2(250);
    varEcnno        CHAR(11);
    varVendor       NVARCHAR2(10);
    varPL_vid       NVARCHAR2(10); --比對PL上的VID
    vname_list      NVARCHAR2(1024);
    vname           NVARCHAR2(50);
    varUTName       NVARCHAR2(50);
    var_released_date date;
    varSQLERRM          Nvarchar2(2000);
    li_ssunit           int;

    -- 1. 抓取待分發的EC清單，STATUS:A04-1待處理；vendor_list:分發廠商, ex: B154,G149
    CURSOR ec_info_list IS
      SELECT ec_id, ecnno, vendor_list, vendor_survey, title, PDM_MODELS, DES_UNITID, RELEASED_DATE, e.adpt
      FROM T_EC_info e
      WHERE e.status = 'A04-1' --AND e.vendor_survey='Y'
      -- and ecnno in ('ECN-2100431')
      --e.released_date=to_date('20170220','YYYYMMDD')
      --e.ecnno='ECN-1701159'
      --e.ecnno In ('ECN-1700064','ECN-1700054','ECN-1700069')
      --VENDOR_LIST LIKE '%SANYI%'
      ORDER BY ec_id ASC;

    -- 字串切割，有逗點者
    CURSOR cur_strSplit(v_str VARCHAR2) IS
      SELECT engineid AS str2
      FROM TABLE(CAST(f_pub_split(v_str) AS myTableType));
      c_field cur_strSplit%ROWTYPE;

    -- 字串切割，有逗點者
    CURSOR cur_strSplit2(v_str VARCHAR2) IS
      SELECT engineid AS str2
      FROM TABLE(CAST(f_pub_split(v_str) AS myTableType));
    c_field2 cur_strSplit2%ROWTYPE;

    --該EC的零件清單, V:local件, A:設變後或新增的零件
    --20161103:第一次先傳vid進來比對，第二次傳vid=%
    --varUnit: P, Y
    /* 20210712:若沒有零件清單時，會取pl_id=0,
      所以 T_EC_pl_info要有一筆資料 pl_id=0, ec_id=0,chagemaker='A',	partno='NA',partname='無設變件號'),
      所有沒有件號的ECN都可以正常發給三義工廠
    */
    CURSOR cur_ec_parts(ecid int, vid VARCHAR2, varUnit VARCHAR2) IS
      SELECT pl_id FROM T_EC_pl_info p
      WHERE (ec_id = ecid OR vid='NA') AND p.CHANGEMAKER = 'A'
            AND ( varUnit='Y' AND p.source in ('V','R')
                  or (varUnit='P' AND p.bd in (SELECT G.GLOSSARY2 FROM T_SYS_GLOSSARY G WHERE G.GLOSSARYTYPEID LIKE 'A01%'))
                  or (varUnit='S' AND (p.source in ('V','R') OR vid='NA'))
                )
            AND (vid<>'%' AND p.ylrlsmaker1 = vid OR vid='%' AND p.ylrlsmaker1 IS NULL OR vid='NA' AND p.pl_id=0)
      ORDER BY pl_id ASC;
    p_field cur_ec_parts%ROWTYPE;

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
    CURSOR cur_model_taker(mid2 VARCHAR2) IS
      /*SELECT S377_UNDERTAKER, S391_UNDERTAKER, PAINT_UNDERTAKER, BODY_UNDERTAKER, MODE_UNDERTAKER, PD_MG_TAKER
      FROM t_anp_model
      WHERE model = mid2 OR (mid2='ALL' AND model='EC');*/
       select
          (SELECT t.undertaker FROM t_anp_model_other t  where (t.model = mid2 OR (mid2='ALL' AND model='EC'))  and typeid ='A02-1' ) as S377_UNDERTAKER,
          (SELECT t.undertaker FROM t_anp_model_other t  where (t.model = mid2 OR (mid2='ALL' AND model='EC'))  and typeid ='A02-2' ) as S391_UNDERTAKER,
          (SELECT t.undertaker FROM t_anp_model_other t  where (t.model = mid2 OR (mid2='ALL' AND model='EC'))  and typeid ='A02-3' ) as PAINT_UNDERTAKER,
          (SELECT t.undertaker FROM t_anp_model_other t  where (t.model = mid2 OR (mid2='ALL' AND model='EC'))  and typeid ='A02-4' ) as BODY_UNDERTAKER,
          (SELECT t.undertaker FROM t_anp_model_other t  where (t.model = mid2 OR (mid2='ALL' AND model='EC'))  and typeid ='A02-5' ) as MODE_UNDERTAKER,
          (SELECT t.undertaker FROM t_anp_model_other t  where (t.model = mid2 OR (mid2='ALL' AND model='EC'))  and typeid ='A10-3' ) as PD_MG_TAKER
         from dual;
    m_field cur_model_taker%ROWTYPE;

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
      SELECT f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-2',2)) into varMail FROM DUAL; --資管科窗口
      SELECT f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-9',2)) into varMail2 FROM DUAL; --ISC
      varNg_Msg:= ''; --分發異常通知信
      varSP := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
      
      FOR ec_info IN ec_info_list LOOP
         varEid        := ec_info.ec_id;
         vendor_list   := ec_info.vendor_list;
         vendor_survey := ec_info.vendor_survey;
         PDM_MODELS    := ec_info.PDM_MODELS;
         title         := ec_info.title;
         desgrp        := ec_info.DES_UNITID;
         varEcnno      := ec_info.ecnno;
         adpt          := ec_info.adpt;
         
         var_released_date      := ec_info.released_date;

         varNg_VendorDev        := ':'; --廠商開發承辦有問題
         varNg_NoVendorId       := ':'; --無此廠商代碼
         varNg_VendorIdNot4     := ':'; --廠商代碼長度<>4
         varNg_NoModel          := ':'; --車型未設定
         varNg_Vendor           := ':'; --調查廠商ng
         
         --要分發廠商
         IF vendor_survey = 'Y' THEN
            IF vendor_list IS NULL OR vendor_list = ' ' THEN
               varNg_Vendor := varNg_Vendor||varEcnno||', ';
            END IF;
            -- For vid In vendor_list --B154,G149會執行兩次
            IF adpt='A09-F' THEN --赤色手配  Red Release
              SELECT f_sys_glossary_getnamebyfield('A08-2', '2') INTO mday FROM DUAL; --赤色手配管控日期, 3天
            ELSE
              SELECT f_sys_glossary_getnamebyfield('A08-3', '2') INTO mday FROM DUAL; --一般調查單管控日期, 14天
            END IF;
            P_EC_VNAME(varEid, vname_list); --抓取裕器,東陽

            FOR c_field IN cur_strSplit(vendor_list) LOOP
               IF c_field.str2 = '三義工廠' or c_field.str2 = 'SANYI' THEN
                   vid := 'SANYI';
               ELSIF (LENGTH(c_field.str2) <> 4 AND c_field.str2 <> 'SANYI') THEN  --含KD,---
                   varNg_VendorIdNot4 := varNg_VendorIdNot4||c_field.str2||', ';
                   vid := '---';
               END IF; 

               IF (LENGTH(c_field.str2) = 4 AND c_field.str2 <> '三義工廠') THEN
                 vid := c_field.str2;
                 
                 datacount1 := 0;
                 SELECT COUNT(*) INTO datacount1
                 FROM T_ANP_SUPPLIER WHERE SUPPLIERCODE = vid;
                 IF datacount1 = 0 THEN
                     varNg_NoVendorId := varNg_NoVendorId||vid||', ';
                     --EXIT WHEN datacount1 = 0;  --cyc20171127: KD,G154 run full
                 END IF;
               END IF;
               
               varUnit2 := '';
               P_EC_GetDistUnit(varEid, vid, varUnit); -- Y, P, S, Q, A(---,''), B(not found), C(ERR) --抓取調查單位
               IF varUnit = 'Q' THEN
                  varUnit2 := 'Y'; --追加分發零技科
                  varUnit  := 'P';
               END IF;

               IF varUnit = 'Y' OR varUnit = 'S' OR varUnit = 'P' THEN
                  i := 1;
                  IF varUnit2 = 'Y' THEN
                     j := 2; --追加分發零技科
                  ELSE
                     j := 1;
                  END IF;

                  LOOP
                     UNDERTAKE    := '';
                     ls_UT_UNITID := '';
                     li_wid       := 0;
                     li_sid       := 0;

                     --SELECT survey_id INTO li_sid -- 抓取該ecn+varUnit+調查廠商是否已存在
                     SELECT count(*) INTO li_sid
                     FROM T_EC_survey_info s
                     WHERE s.ec_id = varEid AND s.dist_unit = varUnit AND s.dist_vendor = vid;
                     --If Sql%Rowcount = 0 Then
                     --IF SQL%NOTFOUND THEN
                     IF 1=1 OR li_sid = 0 THEN --進來為了更新用
                        IF li_sid > 0 THEN
                           SELECT s.survey_id INTO li_sid
                           FROM T_EC_survey_info s
                           WHERE s.ec_id = varEid AND s.dist_unit = varUnit AND s.dist_vendor = vid;
                           
                           IF varUnit <> 'S' THEN
                             rtnWid := 0;
                             SELECT count(*) INTO rtnWid
                               FROM T_SYS_WORKLIST W WHERE W.USERID =
                                (SELECT S.SURVEY_TAKER FROM T_EC_SURVEY_INFO S WHERE S.SURVEY_ID = li_sid)
                                AND W.TITTLE LIKE '%'||varEcnno||'%設通調查表請填寫' AND ROWNUM<=1;
                             
                             IF rtnWid > 0 THEN
                               SELECT W.WORKLISTID INTO rtnWid
                                 FROM T_SYS_WORKLIST W WHERE W.USERID =
                                  (SELECT S.SURVEY_TAKER FROM T_EC_SURVEY_INFO S WHERE S.SURVEY_ID = li_sid)
                                  AND W.TITTLE LIKE '%'||varEcnno||'%設通調查表請填寫' AND ROWNUM<=1;
                               
                               UPDATE T_EC_survey_info S
                                 SET S.STATUS = 'A06-1'
                                 ,S.WORKLISTID = rtnWid
                                 WHERE S.SURVEY_ID = li_sid AND (S.STATUS = 'A06-7' OR S.STATUS = 'A06-9'); --資管再轉回調查單位
                                 
                               UPDATE T_SYS_WORKLIST W SET W.COMPTIME = NULL WHERE W.WORKLISTID=rtnWid;
                             END IF;
                           END IF;
                        END IF;
                        --SELECT f_sys_glossary_getnamebyfield('A10-1',4) INTO v_isdetal From Dual;
                        IF varUnit = 'S' THEN
                           varUnit := 'S';
                           UNDERTAKE:='SANYI';
                           ls_UT_UNITID:='SANYI';
                           varStatus:='A06-D';
                        ELSE
                           varStatus:='A06-1';
                           varmTag := '';
                           IF varUnit = 'Y' THEN
                              varmTag := vid||'%';
                           ELSE -- 'P'
                              varmTag := 'm'||vid||'%';
                           END IF;

                           --雙承辦，EX:裕器，依設計科別、BD、車系指定不同承辦, 取一位
                           --20170628:not must chk bd for pl list 
                           --20170921:EC.ADD_DIST LIKE PEO
                           cnt := 0;
                           SELECT count(*) INTO cnt
                           FROM T_ANP_SUPPLIER S INNER JOIN T_SYS_EMPLOYINFO E ON E.employno = S.DEVELOPER
                           INNER JOIN T_EC_INFO E2 ON E2.EC_ID = varEid
                           WHERE S.SUPPLIERCODE LIKE varmTag AND E.unitid IN (SELECT g.GLOSSARY2 FROM T_SYS_GLOSSARY g WHERE g.GLOSSARYTYPEID in ('A05-1','A05-2') )
                              AND (S.DES_GRP = desgrp OR S.DES_GRP IS NULL)
                              AND (S.BD_NO IS NULL OR S.BD_NO IN (SELECT SUBSTR(P.BD, 1, 6) FROM T_EC_PL_INFO P WHERE P.EC_ID = varEid)
                                   OR E2.ADD_DIST LIKE '%PEO%' )
                              AND (S.MODEL IS NULL OR INSTR(PDM_MODELS, S.MODEL) > 0)
                              AND E.INSERVICE='Y'
                              AND ROWNUM <= 1;
                              
                           IF cnt > 0 THEN
                             SELECT S.DEVELOPER, E.unitid INTO UNDERTAKE, ls_UT_UNITID
                             FROM T_ANP_SUPPLIER S INNER JOIN T_SYS_EMPLOYINFO E ON E.employno = S.DEVELOPER
                             INNER JOIN T_EC_INFO E2 ON E2.EC_ID = varEid
                             WHERE S.SUPPLIERCODE LIKE varmTag AND E.unitid IN (SELECT g.GLOSSARY2 FROM T_SYS_GLOSSARY g WHERE g.GLOSSARYTYPEID in ('A05-1','A05-2') )
                                AND (S.DES_GRP IS NULL OR S.DES_GRP = desgrp)
                                AND (S.BD_NO IS NULL OR S.BD_NO IN (SELECT SUBSTR(P.BD, 1, 6) FROM T_EC_PL_INFO P WHERE P.EC_ID = varEid)
                                    OR E2.ADD_DIST LIKE '%PEO%' )
                                AND (S.MODEL IS NULL OR INSTR(PDM_MODELS, S.MODEL) > 0)
                                AND E.INSERVICE='Y'
                                AND ROWNUM <= 1;
                            END IF;

                          /*SELECT S.DEVELOPER, E.unitid
                            FROM T_ANP_SUPPLIER S INNER JOIN T_SYS_EMPLOYINFO E ON E.employno = S.DEVELOPER
                            WHERE S.SUPPLIERCODE = 'C117'
                              AND (S.DES_GRP IS NULL OR S.DES_GRP = 'YNQHB00')
                              AND (S.BD_NO IS NULL OR S.BD_NO IN (SELECT SUBSTR(P.BD, 1, 6) FROM T_EC_PL_INFO P WHERE P.EC_ID = 9 AND P.SOURCE = 'V' AND (P.YLRLSMAKER1 LIKE varmTag or P.YLRLSMAKER1=vid)) )
                              AND (S.MODEL IS NULL OR INSTR('12D', S.MODEL) > 0)
                              AND ROWNUM <= 1;

SELECT *
FROM T_ANP_SUPPLIER S INNER JOIN T_SYS_EMPLOYINFO E ON E.employno = S.DEVELOPER
WHERE S.SUPPLIERCODE LIKE 'A101%'
  AND E.unitid IN
   (SELECT g.GLOSSARY2 FROM T_SYS_GLOSSARY g WHERE g.GLOSSARYTYPEID in ('A05-1','A05-2') )
  AND (S.DES_GRP IS NULL OR S.DES_GRP = 'YNQCI00')
  AND (S.BD_NO IS NULL OR S.BD_NO
    IN (SELECT SUBSTR(P.BD, 1, 6) FROM T_EC_PL_INFO P WHERE P.EC_ID = 2134) )
  AND (S.MODEL IS NULL OR INSTR('12D', S.MODEL) > 0)
  AND E.INSERVICE='Y'
  AND ROWNUM <= 1;

                              */

                           -- AND (S.DES_GRP = 'YNQCJ00' OR (SELECT COUNT(*) FROM T_ANP_SUPPLIER S2 WHERE S2.SUPPLIERCODE='G154' AND S2.DES_GRP = 'YNQCJ00')=0 AND S.DES_GRP IS NULL )
                           -- AND (S.BD_NO IN (SELECT SUBSTR(P.BD,1,6) FROM T_EC_PL_INFO P WHERE P.EC_ID=24 AND P.SOURCE='V') OR S.BD_NO NOT IN (SELECT SUBSTR(P.BD,1,6) FROM T_EC_PL_INFO P WHERE P.EC_ID=24 AND P.SOURCE='V') AND S.BD_NO IS NULL)
                           -- AND (  INSTR('32R', S.MODEL)>0 OR INSTR('32R', S.MODEL)<=0 AND S.MODEL IS NULL)
                           -- AND ROWNUM<=1;
                        END IF;

                        IF UNDERTAKE IS NULL THEN
                            SELECT S.DEVELOPER INTO UNDERTAKE FROM T_ANP_SUPPLIER S WHERE S.SUPPLIERCODE=vid;
                            IF UNDERTAKE IS NULL THEN
                              UNDERTAKE := '空的!';
                            END IF;
                            varNg_VendorDev := varNg_VendorDev||varmTag||', ';
                        ELSE
                            IF UNDERTAKE='SANYI' THEN
                              li_wid := 0;
                              varSignList:='';
                              varSignLevel:='';
                            ELSE
                              SELECT S.SUPPLIERNAME INTO varVendor FROM T_ANP_SUPPLIER S WHERE S.SUPPLIERCODE=vid;
                              SELECT G.GLOSSARY4, G.GLOSSARY1 INTO varSignList, varSignLevel --抓取簽核List數、簽核層級
                              FROM T_SYS_GLOSSARY G
                              WHERE G.GLOSSARYTYPEID LIKE 'A11%' AND G.GLOSSARY2='Y'
                              AND (G.GLOSSARY3 = ls_UT_UNITID
                              OR G.GLOSSARY3=(SELECT E.DEPARTMENTID FROM T_SYS_EMPLOYINFO E WHERE E.UNITID=ls_UT_UNITID AND ROWNUM<=1));
                            END IF;

                            li_sid := 0;
                            SELECT count(*) INTO li_sid
                            FROM T_EC_survey_info s
                            WHERE s.ec_id = varEid AND s.dist_unit = varUnit AND s.dist_vendor = vid;
                            
                            IF li_sid = 0 THEN
                              li_wid := NULL;
                              IF UNDERTAKE<>'SANYI' THEN
                                PA_SYS_WORKLIST.P_WorkList_Add(UNDERTAKE, '13-02-01',
                                             varEcnno || ' ' || vid || varVendor || ' 設通調查表請填寫', --主旨
                                             varEcnno || ' ' || vid || varVendor || ' 設通調查表請填寫', --內容
                                             rtnWid);
                                li_wid := to_number(rtnWid);
                              END IF;
                              
                              SELECT S_T_EC_SURVEY_INFO.NextvaL INTO li_sid FROM DUAL;
                              -- 新增P_EC_SURVEY_INFO記錄(varUnit為Y 或 P 或 S皆要新增)
                              INSERT INTO T_EC_SURVEY_INFO (SURVEY_ID, EC_ID, DIST_UNIT, DIST_VENDOR, SURVEY_TAKER, survey_vendor_sdate, survey_vendor_pdate, STATUS,    worklistid, UT_UNITID,    SIGN_LEVEL,   SIGN_LIST,   CREATER, CREATE_DATE, MODIFYER, MODIFY_DATE, SURVEY_TITLE, SIGN_HISTORY)
                                                    VALUES (li_sid,    varEid, varUnit,  vid,         UNDERTAKE,    sysdate,             sysdate+mday,        varStatus, li_wid,     ls_UT_UNITID, varSignLevel, varSignList, 'SYS',    SYSDATE,     'SYS',    SYSDATE,    title,        '');
                            ELSE
                              li_sid := 0;
                              SELECT s.survey_id INTO li_sid
                              FROM T_EC_survey_info s
                              WHERE s.ec_id = varEid AND s.dist_unit = varUnit AND s.dist_vendor = vid;
                              
                              IF li_sid > 0 THEN
                                li_wid := 0;
                                SELECT COUNT(*) INTO li_wid FROM T_SYS_WORKLIST T 
                                WHERE T.WORKLISTID IN (SELECT s.worklistid FROM T_EC_SURVEY_INFO s WHERE s.survey_id = li_sid)
                                      AND MENUID='13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
                                
                                IF li_wid > 0 THEN
                                  UPDATE T_SYS_WORKLIST T SET T.USERID=UNDERTAKE, T.COMPTIME=NULL
                                  WHERE T.WORKLISTID IN (SELECT s.worklistid FROM T_EC_SURVEY_INFO s WHERE s.survey_id = li_sid)
                                        AND MENUID='13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
                                ELSE
                                  PA_SYS_WORKLIST.P_WorkList_Add(UNDERTAKE, '13-02-01',
                                               varEcnno || ' ' || vid || varVendor || ' 設通調查表請填寫.', --主旨
                                               varEcnno || ' ' || vid || varVendor || ' 設通調查表請填寫.', --內容
                                               rtnWid);
                                  li_wid := to_number(rtnWid);
                                  UPDATE T_EC_SURVEY_INFO S SET S.WORKLISTID=rtnWid WHERE s.survey_id = li_sid;
                                END IF;

                                UPDATE T_EC_SURVEY_INFO S SET S.SURVEY_TAKER = UNDERTAKE, S.STATUS='A06-1', S.RETURN_FLAG='N', S.ISALERT='N' -- A06-9 -> A06-1
                                WHERE s.survey_id = li_sid;
                              END IF;
                            END IF;

                            -- 新增P_EC_SUM記錄(survey), 統計用, vendor是該調查單位各自的廠商
                            cnt := 0;
                            SELECT count(*) INTO cnt FROM T_EC_SUM S
                            WHERE S.REPORT_TYPE='S' AND S.EC_ID=varEid AND S.UNIT=varUnit;

                            SELECT SP.SUPPLIERNAME INTO vname FROM T_ANP_SUPPLIER SP WHERE SP.SUPPLIERCODE = vid;
                            IF UNDERTAKE <> 'SANYI' THEN
                              SELECT E.NAME INTO varUTName FROM T_SYS_EMPLOYINFO E WHERE E.EMPLOYNO=UNDERTAKE;
                              vname:=vname||'('||varUTName||')';
                            END IF;

                            IF cnt > 0 THEN
                              UPDATE T_EC_SUM S SET
                                S.VENDOR_LIST_NA=S.VENDOR_LIST_NA||','||vname
                                ,S.VENDOR_LIST_ID=S.VENDOR_LIST_ID||','||vid
                              WHERE S.REPORT_TYPE='S' AND S.EC_ID=varEid AND S.UNIT=varUnit
                              AND not S.VENDOR_LIST_ID LIKE '%'||vid||'%';
                            ELSE
                              INSERT INTO T_EC_SUM(REPORT_TYPE, EC_ID,  UNIT,     VENDOR_LIST_ID, VENDOR_LIST_NA, STATUS,  SDATE,             PDATE,                  CREATER,  CREATE_DATE,  MODIFYER, MODIFY_DATE)
                                           VALUES ('S',         varEid, varUnit,  vid,            vname,          'A18-1', sysdate, sysdate+mday, 'SYS',    SYSDATE,      'SYS',    SYSDATE);
                            END IF;
                            commit;
                        END IF;
                     ELSE
                         SELECT survey_id INTO li_sid
                         FROM T_EC_survey_info s
                         WHERE s.ec_id = varEid AND s.dist_unit = varUnit AND s.dist_vendor = vid;
                     END IF; -- 新增P_EC_SURVEY_INFO

                     IF li_sid > 0 THEN
                       --新增P_EC_SURVEY_PARTS
                       varPL_vid := vid;
                       FOR k IN 1 .. 3 LOOP
                         cnt := 0;
                         FOR p_field IN cur_ec_parts(varEid, varPL_vid, varUnit) LOOP --V件,changemake=A
                            cnt := 1;
                            ls_model := '';
                            li_sp_cnt := 0;
                            IF varUnit <> 'S' THEN
                               ls_model := 'EC';
                               li_sp_cnt := 1;
                            ELSE
                               ls_model := PDM_MODELS;
                               li_sp_cnt := 5; --SANYI五組
                            END IF;

                            FOR c_field2 IN cur_strSplit2(ls_model) LOOP --各車系loop
                               model := c_field2.str2;
                               cnt2_model := 0;
                               FOR m_field IN cur_model_taker(model) LOOP --抓取車系承辦
                                  cnt2_model := 1;
                                  FOR i IN 1 .. li_sp_cnt LOOP
                                     IF varUnit = 'S' THEN
                                       CASE i
                                          WHEN 1 THEN
                                             UNDERTAKE := m_field.S377_UNDERTAKER; --K0L00
                                          WHEN 2 THEN
                                             UNDERTAKE := m_field.S391_UNDERTAKER; --K0Q00 動力生技組
                                          WHEN 3 THEN
                                             UNDERTAKE := m_field.PAINT_UNDERTAKER; --K0K00
                                          WHEN 4 THEN
                                             UNDERTAKE := m_field.BODY_UNDERTAKER; --K0J00
                                          WHEN 5 THEN
                                             UNDERTAKE := m_field.MODE_UNDERTAKER; --K0R00 壓造生技組
                                       END CASE;
                                     END IF;
                                     
                                     li_ssid := 0;
                                     IF UNDERTAKE IS NOT NULL AND varUnit = 'S' THEN -- 處理P_EC_sanyi
                                        /* SELECT GLOSSARY2 INTO ls_UT_UNITID FROM T_SYS_GLOSSARY G 
                                         WHERE G.GLOSSARYTYPEID LIKE 'A02%' AND G.GLOSSARY3=i; --三義工廠科別id
                                         */
                                         --三義工廠科別id
                                         SELECT COUNT(*) INTO li_ssunit 
                                         FROM T_SYS_GLOSSARY G 
                                         WHERE G.GLOSSARYTYPEID LIKE 'A02%' 
                                         AND G.GLOSSARY3 = i
                                         AND G.STATE = 'Y' ; 
                                         
                                         IF li_ssunit > 0 THEN
                                           SELECT GLOSSARY2 INTO ls_UT_UNITID 
                                           FROM T_SYS_GLOSSARY G 
                                           WHERE G.GLOSSARYTYPEID LIKE 'A02%' 
                                           AND G.GLOSSARY3 = i
                                           AND G.STATE = 'Y' ;
                                           
                                           SELECT count(*) INTO li_ssid FROM T_EC_SANYI SI
                                             WHERE SI.SURVEY_ID_FK = li_sid
                                               AND SI.SANYI_UNIT = ls_UT_UNITID
                                               AND SI.CAR = model; --不用承辦，可能會換
                                           IF li_ssid = 0 THEN
                                                PA_SYS_WORKLIST.P_WorkList_Add(UNDERTAKE, '13-02-06', '填寫'||varEcnno||'廠商調查通知單(SANYI)', '填寫'||varEcnno||'廠商調查通知單(SANYI)', rtnWid);
                                                li_wid := to_number(rtnWid);
                                                SELECT S_T_EC_SANYI.NextvaL INTO li_ssid FROM DUAL;

                                                SELECT G.GLOSSARY4, G.GLOSSARY1 INTO varSignList, varSignLevel --抓取簽核List數、簽核層級
                                                FROM T_SYS_GLOSSARY G
                                                WHERE G.GLOSSARYTYPEID LIKE 'A11%' AND G.GLOSSARY2='Y'
                                                AND (G.GLOSSARY3 = ls_UT_UNITID
                                                OR G.GLOSSARY3=(SELECT E.DEPARTMENTID FROM T_SYS_EMPLOYINFO E WHERE E.UNITID=ls_UT_UNITID AND ROWNUM<=1));

                                                INSERT INTO T_EC_SANYI
                                                   (SS_ID, EC_ID_FK, SURVEY_ID_FK, SANYI_UNIT, CAR, UNDERTAKER, WORKLISTID, STATUS, SIGN_LEVEL, SIGN_LIST, CREATER, CREATE_DATE, MODIFYER, MODIFY_DATE)
                                                VALUES
                                                   (li_ssid, varEid, li_sid, ls_UT_UNITID, model, UNDERTAKE, li_wid, 'A06-D', varSignLevel, varSignList, 'SYS', SYSDATE, 'SYS', SYSDATE);
                                           ELSE
                                               SELECT SI.SS_ID INTO li_ssid FROM T_EC_SANYI SI
                                                 WHERE SI.SURVEY_ID_FK = li_sid
                                                   AND SI.SANYI_UNIT = ls_UT_UNITID
                                                   AND SI.CAR = model;
                                           END IF;

                                           --INSERT INTO P_EC_SANYI_UNIT
                                           datacount2:=0;
                                           SELECT count(*) INTO datacount2 FROM T_EC_SANYI_UNIT SI
                                             WHERE SI.SURVEY_ID_FK2 = li_sid
                                               AND SI.SANYI_UNIT2 = ls_UT_UNITID;
                                           IF datacount2 = 0 THEN
                                                INSERT INTO T_EC_SANYI_UNIT(SURVEY_ID_FK2, SANYI_UNIT2, SIGN_HISTORY)
                                                VALUES(li_sid, ls_UT_UNITID, '');
                                           END IF;
                                           
                                         END IF;  -- end of "IF li_ssunit > 0 THEN"
                                         
                                     END IF;

                                     IF varUnit <> 'S' OR varUnit = 'S' AND li_ssid > 0 THEN --找不到承辦時ssid會為0
                                       --varpl_id := 86789;
                                       datacount2 := 0; --處理P_EC_survey_parts
                                       SELECT count(*) INTO datacount2 FROM T_EC_SURVEY_PARTS p
                                         WHERE p.survey_id = li_sid AND p.PL_ID = p_field.pl_id and p.ss_id_fk=li_ssid;

                                       IF datacount2 = 0 THEN
                                          SELECT S_T_EC_SURVEY_PARTS.NextvaL INTO SURVEY_PSRTS_ID FROM DUAL;
                                          -- 依適用車系產生多筆記錄，各車型承辦請參照A14要件-車型承辦sheet
                                          INSERT INTO T_EC_SURVEY_PARTS
                                             (SURVEY_PARTS_ID, EC_ID, SURVEY_ID, PL_ID, SS_ID_FK, CREATER, CREATE_DATE, MODIFYER, MODIFY_DATE)
                                          VALUES
                                             (SURVEY_PSRTS_ID, varEid, li_sid, p_field.pl_id, li_ssid, 'SYS', SYSDATE, 'SYS', SYSDATE);
                                       END IF;
                                     END IF;
                                  END LOOP;
                               END LOOP;
                               IF cnt2_model = 0 THEN --車型檔抓不到資料
                                 varNg_NoModel := varNg_NoModel||ls_model||', ';
                               END IF;
                            END LOOP;
                            commit;
                         END LOOP; --新增P_EC_SURVEY_PARTS
                         IF k = 1 and cnt = 0 THEN --by廠商,無V件.
                             varPL_vid := '%';
                         END IF;
                         IF k = 2 and cnt = 0 THEN --此ecn無V件.
                             varPL_vid := 'NA'; --跑第3次，新增NA件號
                             SELECT COUNT(*) INTO cnt
                             FROM T_EC_SURVEY_INFO S 
                             WHERE S.SURVEY_ID=li_sid AND (S.SIGN_HISTORY IS NOT NULL);
                             IF cnt = 1 THEN --history有值, 避免重跑把值蓋掉
                               UPDATE T_EC_SURVEY_INFO S SET S.SIGN_HISTORY=S.SIGN_HISTORY || '，' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' SYS:此ECN無零件' || chr(10)
                               WHERE S.SURVEY_ID=li_sid;-- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
                             ELSE
                               UPDATE T_EC_SURVEY_INFO S SET S.SIGN_HISTORY='1.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' SYS:此ECN無零件' || chr(10)
                               WHERE S.SURVEY_ID=li_sid;-- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
                             END IF;
                         END IF;
                       END LOOP; -- k=1 to 3
                       commit;
                     ELSE
                       i:=3; -- exit
                     END IF; --IF li_sid > 0 THEN

                     i := i + 1;
                     IF varUnit2 = 'Y' THEN
                        varUnit := 'Y'; --追加分發零技科
                     END IF;
                     EXIT WHEN i > j;
                  END LOOP;
               ELSE -- <> Y P S
                  IF varUnit = 'A' THEN --IF varVid = '---' OR varVid IS NULL OR varVid = ' ' OR varVid = 'KD'THEN
                     varNg_NoVendorId := varNg_NoVendorId||vid||', ';
                  ELSE
                     IF varUnit = 'B' THEN --廠商ID在t_anp_supplier找不到時開發承辦找不到
                        varNg_VendorDev := varNg_VendorDev||vid||', ';
                     END IF;
                  END IF;
               END IF;
            END LOOP; -- for vendor_list

            IF varNg_VendorDev=':' AND varNg_NoVendorId=':' AND varNg_VendorIdNot4=':' AND varNg_NoModel=':' AND varNg_Vendor=':' THEN
              UPDATE T_EC_INFO E SET E.STATUS='A04-2' WHERE E.EC_ID=varEid and E.STATUS='A04-1'; --廠商調查中
            ELSE
              varNg_Msg:=varNg_Msg||'<BR>'||varSp||varEcnno||'：';
              IF varNg_VendorDev<>':' THEN
                varNg_Msg:=varNg_Msg||'<BR>'||varSP||varSP||' ANPQP-廠商對照開發承辦錯誤'||substr(varNg_VendorDev, 1, length(varNg_VendorDev)-2);
              END IF;
              IF varNg_NoVendorId<>':' THEN
                varNg_Msg:=varNg_Msg||'<BR>'||varSP||varSP||' 廠商ID在ANPQP系統未設定'||varNg_NoVendorId;
              END IF;
              IF varNg_VendorIdNot4<>':' THEN
                varNg_Msg:=varNg_Msg||'<BR>'||varSP||varSP||' 廠商ID長度<>4'||substr(varNg_VendorIdNot4, 1, length(varNg_VendorIdNot4)-2);
              END IF;
              IF varNg_NoModel<>':' THEN
                varNg_Msg:=varNg_Msg||'<BR>'||varSP||varSP||' 車型未設定'||substr(varNg_NoModel, 1, length(varNg_NoModel)-2);
                SELECT f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-3',2)) into varMail3 FROM DUAL; --零管科窗口
                varMail:=varMail||','||varMail3;
              END IF;
              varNg_Msg:=varNg_Msg||'<BR>';
              UPDATE T_EC_INFO E SET E.STATUS='A04-6', E.WORKLISTID=0 WHERE E.EC_ID=varEid; --廠商調查_退回
            END IF;
         ELSE --不分發，直接轉切換調查
            IF vendor_survey = 'N' AND (vendor_list IS not NULL OR vendor_list <> ' ') AND INSTR('KD,kd,---', vendor_list) = 0 THEN
               varNg_Vendor := varNg_Vendor||varEcnno||', ';
               varNg_Msg:=varNg_Msg||'<BR>'||varSP||' 廠商調查FLAG與LIST不一致'||substr(varNg_Vendor, 1, length(varNg_Vendor)-2)||','||varSP||vendor_survey||','||varSP||vendor_list||'<BR>';
               UPDATE T_EC_INFO E SET E.STATUS='A04-6', E.WORKLISTID=0 WHERE E.EC_ID=varEid; --廠商調查_退回
            ELSE
               P_EC_ADD_CHG_INFO(varEid, title, PDM_MODELS);
            END IF;
         END IF;
         COMMIT;
      END LOOP; --FOR ec_info IN ec_info_list LOOP

      IF varNg_Msg IS NOT NULL THEN
        varNg_Msg:='<html><body>您好!：'||varNg_Msg||'</html></body>';
        P_SYS_Mail_Add(varMail, varMail2, 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
        --P_SYS_Mail_Add('515873', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
        --P_SYS_Mail_Add('A14-9,2', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
        SELECT f_sys_glossary_getnamebyfield('A14-2',2) into UNDERTAKE FROM DUAL; --資管科窗口 920286
        PA_SYS_WORKLIST.P_WorkList_Add(UNDERTAKE, '13-02-08',
          '【異常提醒】設變調查e化-廠商分發', --主旨
          '【異常提醒】設變調查e化-廠商分發', --內容
          rtnWid);
          li_wid := to_number(rtnWid);
        UPDATE T_SYS_WORKLIST W SET W.COMPTIME=SYSDATE WHERE W.WORKLISTID IN (SELECT E.WORKLISTID FROM T_EC_INFO E WHERE E.STATUS='A04-6' AND E.WORKLISTID=0);
        UPDATE T_EC_INFO E SET E.WORKLISTID = li_wid WHERE E.STATUS='A04-6' AND E.WORKLISTID=0;
      END IF;
      COMMIT;

      P_EC_STATUS_CAL();--調查/切換, 會辦中狀態改為逾期

      COMMIT;
      --OutResult := '0';

  EXCEPTION
     WHEN OTHERS THEN
         ROLLBACK;
         --OutResult := '-1';
         varSQLERRM := SQLERRM;
         dbms_output.put_line('err=' || varSQLERRM);

END P_EC_DistTakerSurvey;