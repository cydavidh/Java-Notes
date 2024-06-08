CREATE OR REPLACE PACKAGE BODY "PA_EC_MANAGE" AS

  PROCEDURE P_EC_GetMyDDL(
      varKey       IN VARCHAR2
     ,varVal       IN VARCHAR2
     ,varVal2      IN VARCHAR2
     ,returnValues OUT SYS_REFCURSOR
  ) IS
     --varVal3 VARCHAR2(100);
     --varVal4 VARCHAR2(100);
     var2 varchar2(100);
  BEGIN
      --  varIn := varKey;
      -- 固定回傳id, name變數
      CASE varKey
         WHEN 'carList' THEN
            OPEN ReturnValues FOR
               SELECT m.MODEL id, m.MODEL label FROM T_ANP_MODEL m;

         WHEN 'sectionList' THEN
            OPEN ReturnValues FOR
               SELECT G.GLOSSARY2 id, (SELECT E.UNITNA
                          FROM T_SYS_EMPLOYINFO E
                         WHERE G.GLOSSARY2 = E.UNITID
                           AND ROWNUM <= 1) label
                 FROM T_SYS_GLOSSARY G
                WHERE G.GLOSSARYTYPEID LIKE ('%304%'); --設計科別代號

         WHEN 'ecAllSectionList' THEN
            OPEN returnValues FOR
              /* SELECT distinct g.GLOSSARY2 id, e.UNITNA label, e.DEPARTMENTID , e.unitid
                 FROM T_SYS_GLOSSARY g inner join T_SYS_EMPLOYINFO e on g.GLOSSARY2 = e.UNITID
                WHERE g.GLOSSARYTYPEID IN ('A05-1', 'A05-2') --零技, PEO
                   OR g.GLOSSARYTYPEID LIKE 'A02%' --SANYI調查單位
                   OR g.GLOSSARYTYPEID LIKE 'A10%' --零件切換調查單位
                ORDER BY e.DEPARTMENTID ASC, e.unitid asc;
                */
                 select * from (
                   SELECT distinct '1' as orderby, g.GLOSSARY2 id, e.UNITNA label, e.DEPARTMENTID , e.unitid, g.modifycontent as flag
                     FROM T_SYS_GLOSSARY g inner join T_SYS_EMPLOYINFO e on g.GLOSSARY2 = e.UNITID
                    WHERE g.GLOSSARYTYPEID IN ('A05-1', 'A05-2') --零技, PEO
                   union all
                   SELECT distinct '3' as orderby, g.GLOSSARY2 id, e.UNITNA label, e.DEPARTMENTID , e.unitid, g1.modifycontent as flag
                     FROM T_SYS_GLOSSARY g inner join T_SYS_EMPLOYINFO e on g.GLOSSARY2 = e.UNITID
                     join T_SYS_GLOSSARY g1 on e.DEPARTMENTID = g1.GLOSSARY2
                        WHERE  g.GLOSSARYTYPEID LIKE 'A02%' --SANYI調查單位
                        and g1.GLOSSARYTYPEID = 'A05-3'
                   union all
                   SELECT distinct '2' as orderby, g.GLOSSARY2 id, e.UNITNA label, e.DEPARTMENTID , e.unitid, N'C' as flag
                     FROM T_SYS_GLOSSARY g inner join T_SYS_EMPLOYINFO e on g.GLOSSARY2 = e.UNITID
                         WHERE g.GLOSSARYTYPEID LIKE 'A10%' --零件切換調查單位
                  ) a
                  ORDER BY  a.orderby,a.flag desc, a.unitid asc;

         WHEN 'isAdmin' THEN
            OPEN returnValues FOR
               select F_EC_PowerUser(varVal) id, '' label from dual;

         WHEN 'isVendor' THEN
            OPEN returnValues FOR
               select count(*) id, '' label from T_SYS_USERACCOUNT u WHERE u.USERID=varVal and u.isoem='1';

         WHEN 'isLeader' THEN
            OPEN returnValues FOR
               select count(*) id, '' label from T_SYS_USERGROUP ug WHERE ug.USERID=varVal and ug.GROUPID='PISGroup31';

         WHEN 'NDTypeDllList' THEN
            OPEN ReturnValues FOR
               SELECT Glossary2 AS id, Glossary1 AS label
                 FROM t_sys_glossary
                WHERE GlossaryTypeID LIKE 'A17-%'
                ORDER BY ListOrder, GlossaryTypeID;

         WHEN 'getGlossary' THEN
            OPEN ReturnValues FOR
               SELECT GlossaryTypeID AS id, Glossary1 AS label
                 FROM t_sys_glossary
                WHERE GlossaryTypeID LIKE varVal || '-%'
                  AND (Glossary2 IS NULL OR Glossary2 = ' ')
                  AND state = 'Y'
                ORDER BY ListOrder, GlossaryTypeID;

         WHEN 'utUnitList' THEN --該承辦的科所有成員, 或過濾該員
            OPEN returnValues FOR
               SELECT e.EMPLOYNO id, e.EMPLOYNO || ' ' || e.name label
                 FROM T_SYS_EMPLOYINFO e
                WHERE e.unitid = varVal
                  AND (e.INSERVICE = varVal2 OR e.INSERVICE='Y' AND e.employno<>varVal2)
                ORDER BY id ASC;

         WHEN 'utSurveyChgList' THEN --調查或切換的承辦list
            OPEN returnValues FOR
               select  DISTINCT id,label
               from (
               SELECT DISTINCT S.SURVEY_TAKER id, (SELECT E.name
                                   FROM T_SYS_EMPLOYINFO E
                                  WHERE E.EMPLOYNO = S.SURVEY_TAKER) label
               FROM T_EC_SURVEY_INFO S
               WHERE S.UT_UNITID = varVal
                  AND (S.STATUS NOT IN ('A06-K', 'A07-4') AND (S.STATUS LIKE 'A06%' OR S.STATUS LIKE 'A07%'))
               union all
               select s.undertaker id, (SELECT E.name
                                   FROM T_SYS_EMPLOYINFO E
                                  WHERE E.EMPLOYNO = S.undertaker) label
                FROM t_Ec_Sanyi s
                WHERE sanyi_unit = varVal
                AND (S.STATUS NOT IN ('A06-K','A06-L') AND (S.STATUS LIKE 'A06%' ))
                union all
                select  c.undertake id, (SELECT E.name
                                   FROM T_SYS_EMPLOYINFO E
                                  WHERE E.EMPLOYNO = c.undertake) label
                from t_ec_chg_info c
                where c.taker_unit = varVal
                AND (c.STATUS NOT IN ('A07-4') AND (c.STATUS LIKE 'A07%' ))
                )
                ORDER BY id ASC;

          WHEN 'leaderList' THEN --調查科別所屬Leader
            OPEN ReturnValues FOR
              select employno id, name label from t_sys_employinfo emp inner join T_SYS_USERGROUP ug
              on emp.employno=ug.userid
              where emp.unitid in (select s.ut_unitid from t_ec_survey_info s where s.survey_id = varVal )
              and emp.employno<> (select survey_taker from t_ec_survey_info s where s.survey_id = varVal) and ug.groupid = 'PISGroup31';

         WHEN 'signLayer_pd' THEN --簽核層級 by科別或部門
            OPEN returnValues FOR
                 SELECT G.GLOSSARY4 id, G.GLOSSARY1 label
                 FROM T_SYS_GLOSSARY G
                WHERE (G.GLOSSARYTYPEID LIKE 'A11%' or G.GLOSSARYTYPEID LIKE 'A12%') AND G.GLOSSARY2='Y'
                AND (G.GLOSSARY3=varVal
                OR G.GLOSSARY3=(SELECT E.DEPARTMENTID FROM T_SYS_EMPLOYINFO E WHERE E.UNITID=varVal AND ROWNUM<=1));
                --AND (G.GLOSSARY3 =(select s.ut_unitid from t_ec_survey_info s where s.survey_id = varVal )
                --OR G.GLOSSARY3=(SELECT E.DEPARTMENTID FROM T_SYS_EMPLOYINFO E WHERE E.UNITID=(select s.ut_unitid from t_ec_survey_info s where s.survey_id = varVal ) AND ROWNUM<=1));

         WHEN 'signLayer' THEN --簽核層級 by案件
            OPEN returnValues FOR
                 SELECT G.GLOSSARY4 id, G.GLOSSARY1 label
                 FROM T_SYS_GLOSSARY G
                WHERE (G.GLOSSARYTYPEID LIKE 'A11%' or G.GLOSSARYTYPEID LIKE 'A12%') AND G.GLOSSARY2='Y'
                AND (G.GLOSSARY3 =(select s.ut_unitid from t_ec_survey_info s where s.survey_id = varVal )
                OR G.GLOSSARY3=(SELECT E.DEPARTMENTID FROM T_SYS_EMPLOYINFO E WHERE E.UNITID=(select s.ut_unitid from t_ec_survey_info s where s.survey_id = varVal ) AND ROWNUM<=1));


         WHEN 'YorN' THEN --Radio選項(是、否)
            OPEN returnValues FOR
               SELECT 'N' id, '否' label FROM dual
               union all
               SELECT 'Y' id, '是' label FROM dual;

         WHEN 'a11ListStatus' THEN -- -1(科長以下),0(科長),1(科長以上),9(admin),8(vendor),2(leader)
            var2 := SUBSTR(varVal,1,1); -- -1 -> -, 不然-1與1衝突
            var2 := '%' || var2 || '%';
            OPEN returnValues FOR
              SELECT GLOSSARYTYPEID id, GLOSSARY1 label FROM T_SYS_GLOSSARY
              WHERE GLOSSARYTYPEID LIKE 'A06%' AND GLOSSARY3='A11' AND GLOSSARY2 LIKE var2;


         ELSE
            OPEN ReturnValues FOR SELECT 'NA' id, 'NA' label FROM dual;

      END CASE;

  EXCEPTION
      WHEN OTHERS THEN
         OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' label FROM dual;
  END;


  PROCEDURE P_EC_SurveyLIST(
      varPageSize    IN VARCHAR2 --每頁數量
     ,varPageNO      IN VARCHAR2 --當前頁
     ,varstep        IN VARCHAR2
     ,varecn         IN VARCHAR2
     ,varsurvey_id   IN VARCHAR2
     ,varcar         IN VARCHAR2
     ,varSection     IN VARCHAR2
     ,varUT_UNITID   IN VARCHAR2 --調查科別ID
     ,varUndertake   IN VARCHAR2
     ,varuserid      IN VARCHAR2
     ,varRole        IN VARCHAR2
     ,varStatus      IN VARCHAR2
     ,ReturnValues   OUT SYS_REFCURSOR
     ,OutRecordCount OUT VARCHAR2 --記錄數
  ) IS
      -- Sql
      varSql         VARCHAR2(8000);
      varOrderby     VARCHAR2(500);
      varSubSql      VARCHAR2(4000);
      varSubSql2     VARCHAR2(100);
      -- Page
      VarCountSql    VARCHAR2(4000);
      VarCount       INT;
      VarMinRowNO    INT;
      VarMaxRowNO    INT;
      var2 varchar2(100);
      
  BEGIN
      
      varSql := ' SELECT '''' pagesize, '''' curpage, DECODE(S.DIST_UNIT,''Y'',''零技科'',''P'',''PEO'',''S'',''三義工廠'') distUnitNA
        , S.SURVEY_TAKER AS undertakeID
        ,(SELECT P.NAME FROM T_SYS_EMPLOYINFO P WHERE P.EMPLOYNO=S.SURVEY_TAKER) undertakeNA
        ,(SELECT UNITNA FROM T_SYS_EMPLOYINFO EMP WHERE EMP.UNITID=S.UT_UNITID AND ROWNUM<=1) utUnitNA
        , E.DESIGNER, E.DES_UNITID as desGrp
        , (SELECT P2.name FROM T_SYS_EMPLOYINFO P2 WHERE P2.EMPLOYNO=E.designer) designerNA
        , (SELECT P2.UNITNA FROM T_SYS_EMPLOYINFO P2 WHERE P2.EMPLOYNO=E.designer) desGrpNA
        , S.DIST_VENDOR as vendorID
        , (SELECT distinct V.SUPPLIERCODE || ''  '' || V.SUPPLIERNAME FROM T_ANP_SUPPLIER V WHERE V.SUPPLIERCODE=S.DIST_VENDOR) vendorNA
        , TO_CHAR(E.released_date,''YYYY/MM/DD'') as releaseDate
        , S.status, (select GLOSSARY1 from T_SYS_GLOSSARY where GLOSSARYTYPEID=S.status) as statusNA
        , (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=S.sign_leader) as sign_leaderNA
        , S.SURVEY_ID AS surveyID, E.ECNNO, E.PDM_MODELS, S.UT_UNITID, S.SURVEY_TITLE as TITLE
        , case when s.status in (''A06-1'',''A06-2'',''A06-6'') then
         decode(s.COMMENT2,null,''呈請同意'',s.COMMENT2) ELSE decode(s.COMMENT2,null,'''',s.COMMENT2) end  as COMMENT2
        , s.RETURN_FLAG, s.sign_leader, s.sign_level
        , decode(e.adpt,''A09-G'',e.ADPT_OTHER_DATE,(select GLOSSARY1 from T_SYS_GLOSSARY where GLOSSARYTYPEID= e.adpt)) as adptNA
        , s.cd_cnt, e.dwg_cnt, s.content2, s.sign_history, s.parts_flag, s.YN_ATTACHID, s.VENDOR_ATTACHID
        ,(case when 1=1 then (select attachpath from t_sys_attach where t_sys_attach.attachid = s.YN_ATTACHID)end) as attachpath_Y
        ,(case when 1=1 then (select attach from t_sys_attach where t_sys_attach.attachid = s.YN_ATTACHID)end) as attachname_Y
        ,(case when 1=1 then (select attachpath from t_sys_attach where t_sys_attach.attachid = s.VENDOR_ATTACHID)end) as attachpath_V
        ,(case when 1=1 then (select attach from t_sys_attach where t_sys_attach.attachid = s.VENDOR_ATTACHID)end) as attachname_V 
        , E.PDM_ECFILEID , E.PDM_ATTACHID , s.overDueReasonDescription, S.VENDOR_MEMO, S.VENDOR_COMMENT
        , TO_CHAR(s.survey_vendor_pdate,''YYYY-MM-DD HH24:Mi:SS'') as survey_vendor_pdate
        , TO_CHAR(s.survey_vendor_udate,''YYYY-MM-DD HH24:Mi:SS'') as survey_vendor_udate
      FROM T_EC_INFO E INNER JOIN T_EC_SURVEY_INFO S on S.EC_ID=E.EC_ID
      WHERE 1=1 ';

      CASE varstep
         WHEN 'A11LIST' THEN --廠商、承辦、Leader、主管回覆LIST
            if varRole = '8' then --廠商
               --varSubSql2 := ' and S.DIST_VENDOR = substr(''G1492'',1,4) ';
               varSubSql2 := ' and S.DIST_VENDOR = substr(''' || varuserid || ''',1,4) ';
            end if;
            
            varSubSql := varSubSql || varSubSql2;
            IF varStatus IS NOT NULL THEN
               varSubSql :=  varSubSql || ' AND S.STATUS = ''' || varStatus || '''';
            ELSE
               var2 := SUBSTR(varRole,1,1); -- -1 -> -, 不然-1與1衝突
               varSubSql :=  varSubSql || ' AND S.STATUS IN (SELECT GLOSSARYTYPEID FROM T_SYS_GLOSSARY WHERE GLOSSARYTYPEID LIKE ''A06%'' AND GLOSSARY3=''A11'' AND GLOSSARY2 LIKE ''%'||var2||'%'')';
            END IF;
            CASE
              WHEN varRole = '-1' and varuserid <> 'xxx' THEN -- -1(科長以下) 510507黃福銘  515952陳鐓鍠
                select count(*) into varCount --判斷是否為LEADER
                from T_SYS_USERGROUP
                where groupid in (select groupid from T_SYS_GROUP where groupname = 'YNTC Leader')
                and userid = varuserid ;
                
                IF varCount = 0 THEN --不是LEADER, 是承辦
                   varSubSql := varSubSql || ' AND  S.STATUS IN  (''A06-D'',''A06-E'',''A06-J'') '; --taker status
                   varSubSql := varSubSql || ' AND S.SURVEY_TAKER = ''' || varuserid || ''' ';
                ELSE   --是LEADER
                   varSubSql := varSubSql || ' AND ( ( S.STATUS IN  (''A06-D'',''A06-E'',''A06-J'') ';
                   varSubSql := varSubSql || ' AND S.SURVEY_TAKER = ''' || varuserid || ''') or ( '; 
                   varSubSql := varSubSql || ' S.STATUS IN ( ''A06-G'', ''A06-I'') '; 
                   varSubSql := varSubSql || ' AND (S.Sign_Now = ''0'' ';
                   varSubSql := varSubSql || ' AND S.Sign_Leader = ''' || varuserid || ''' OR S.Sign_Now=''x'' AND S.UT_UNITID='''||varSection||''')) )';
                END IF;
                
              WHEN varRole = '0' or varuserid = 'xxx' THEN --varRole = 0(科長), Sign_Now = 1(Sign_Level簽核層級第1個),
                varSubSql := varSubSql || ' AND S.Sign_Now = ''1''  ';
                varSubSql := varSubSql || ' AND (S.UT_UNITID = ''' || varUT_UNITID || ''' OR S.UT_UNITID='''||varSection||''') ';
                                              
              WHEN varRole = '1' THEN --varRole = 1(科長以上), Sign_Now = 2(Sign_Level簽核層級第二個),Sign_Now = 3(Signoff_Level簽核層級第三個)
                varSubSql := varSubSql || ' AND (( S.Sign_Now <> ''X'' AND S.UT_UNITID in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || '%'' 
                and depusrid not like ''%' || varuserid || ''' )) or ( S.Sign_Now = ''3'' AND S.UT_UNITID in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || ''')))';    
           
              ELSE
                varSubSql := varSubSql;

              --WHEN varRole = '8' THEN --varRole = 8(vendor)
                
            END CASE;
                    
            varOrderby := ' ORDER BY releasedate ASC ';
         WHEN 'A11LOAD' THEN --廠商、承辦、Leader、主管回覆LOAD
             varSubSql := varSubSql || ' AND s.survey_id = ' || varsurvey_id;
             
         WHEN 'A18LIST' THEN
            varSubSql := varSubSql || ' AND (S.STATUS NOT IN (''A06-K'') AND S.STATUS LIKE ''A06%''
                   OR  S.STATUS NOT IN (''A07-4'') AND S.STATUS LIKE ''A07%'') ';
            IF varsection IS NOT NULL THEN
               varSubSql := varSubSql || ' AND S.UT_UNITID = (''' || varSection || ''') ';
            END IF;
            IF varUndertake IS NOT NULL THEN
               varSubSql := varSubSql || ' AND S.SURVEY_TAKER = (''' || varUndertake || ''') ';
            END IF;
            varOrderby := ' ORDER BY vendorID ASC';

         WHEN 'A18LOAD' THEN
            varSubSql := varSubSql || ' AND S.SURVEY_ID IN (' || varsurvey_id || ')';
            insert into t_ec_sql_log values(sysdate, varSubSql, 'P_EC_SurveyLIST-A18LOAD');
             
         ELSE
            OPEN ReturnValues FOR SELECT 'NA' id, 'NA' NAME FROM dual;
            
      END CASE;

      IF varecn IS NOT NULL THEN
         varSubSql := varSubSql || ' AND E.ECNNO LIKE UPPER(''%' || varecn || '%'') ';
      END IF;
      IF varcar IS NOT NULL THEN
         varSubSql := varSubSql || ' AND E.PDM_MODELS LIKE UPPER(''%' || varcar || '%'') ';
      END IF;
      IF varUndertake IS NOT NULL THEN
         varSubSql := varSubSql;
      END IF;
      
/*      IF varSection IS NOT NULL THEN
         varSubSql := varSubSql || ' AND E.DES_UNITID LIKE UPPER(''' || varSection || '%'') ';
      END IF;
*/   
      
      -- 取記錄數
      IF varSubSql IS NOT NULL THEN 
        varSql := varSql || varSubSql;
      END IF;
      IF varOrderby IS NOT NULL THEN 
        varSql := varSql || varOrderby;
      END IF;
      VarCountSql := 'select count(*) from (' || varSql || ')';
      EXECUTE IMMEDIATE VarCountSql  INTO VarCount;
      OutRecordCount := TO_CHAR(VarCount);

      --執行分頁查詢
      -- XX當每頁筆數大於 0 時, 才做分頁, 不大於0為匯出(Export)用
      VarMaxRowNO := TO_NUMBER(varPageSize) * TO_NUMBER(varPageNO);
      VarMinRowNO := VarMaxRowNO - TO_NUMBER(varPageSize) + 1;
      IF varPageSize > '0' THEN
         VarSql := ' SELECT to_number('||varPageSize||') * (to_number('||varPageNO||')-1)+rownum as no, B.* FROM (
                   SELECT A.*, rownum rn FROM  (' || VarSql || ') A
                      WHERE rownum <= ' || TO_CHAR(VarMaxRowNO) || ') B
               WHERE rn >=  ' || TO_CHAR(VarMinRowNO) || ' order by no ';
      END IF;

      OPEN ReturnValues FOR varSql;
  EXCEPTION
     WHEN OTHERS THEN
        OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' NAME FROM dual;
  END;

  PROCEDURE P_EC_EcChgLIST_PG( --查詢零件切換T_EC_CHG_INFO
      varPageSize    IN VARCHAR2 --每頁數量
     ,varPageNO      IN VARCHAR2 --當前頁
     ,varEcnNumber   IN VARCHAR2
     ,varStep        IN VARCHAR2
     ,varKeyId       IN VARCHAR2
     ,varUT_UNITID   IN VARCHAR2 --調查科別ID
     ,varUserid      IN VARCHAR2 --登入者
     ,varUndertake   IN VARCHAR2 --查詢承辦
     ,varRole        IN VARCHAR2 -- -1(科長以下),0(科長),1(科長以上),9(admin),8(vendor)
     ,ReturnValues   OUT SYS_REFCURSOR
     ,OutRecordCount OUT VARCHAR2 --?記錄數
  ) IS
      -- Sql
      varSql     VARCHAR2(4000);
      varSubSql     VARCHAR2(4000);
      varOrderby VARCHAR2(500);
     -- var2       VARCHAR2(50);
      -- Page
      VarCountSql VARCHAR2(4000);
      VarCount    INT;
      VarMinRowNO INT;
      VarMaxRowNO INT;
  BEGIN
      varSql := ' SELECT distinct C.UNDERTAKE AS undertakeID,c.TAKER_UNIT as utUnitID
        , (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=C.UNDERTAKE) undertakeNA
        , (SELECT UNITNA FROM T_SYS_EMPLOYINFO WHERE UNITID=C.TAKER_UNIT AND ROWNUM<=1) utUnitNA
        , C.status , (select GLOSSARY1 from T_SYS_GLOSSARY where GLOSSARYTYPEID=C.status) as statusNA
        , E.DESIGNER, E.DES_UNITID as desGrp
        , (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=E.DESIGNER) designerNA
        , (SELECT UNITNA FROM T_SYS_EMPLOYINFO WHERE UNITID=E.DES_UNITID AND ROWNUM<=1) desGrpNA
        , TO_CHAR(E.RELEASED_DATE,''YYYY/MM/DD'') as releaseDate
        , E.ECNNO, E.PDM_MODELS, E.EC_ID, E.PDM_ECFILEID, E.PDM_ATTACHID SQL2
        , DECODE(E.VENDOR_SURVEY,''Y'',''０'',''N'',''Ｘ'',''X'',''Ｘ'') vendorSurvey
        , C.CAR
            FROM T_EC_INFO E INNER
            JOIN T_EC_CHG_INFO C ON E.EC_ID=C.EC_ID
          --  INNER JOIN T_ANP_MODEL M ON M.PD_MG_TAKER=C.UNDERTAKE AND M.MODEL=C.CAR
            WHERE 1=1 ';

    /*  --抓取各狀態值
      var2 := SUBSTR(varRole,1,1); -- -1 -> -, 不然-1與1衝突
      varSubSql :=  varSubSql || ' AND C.STATUS IN (SELECT GLOSSARYTYPEID FROM T_SYS_GLOSSARY WHERE GLOSSARYTYPEID LIKE ''A07%'' AND GLOSSARY3=''A06'' AND GLOSSARY2 LIKE ''%'||var2||'%'')';
    */
       CASE
              WHEN varRole = '-1' THEN -- -1(科長以下)
                select count(*) into varCount --判斷是否為LEADER
                from T_SYS_USERGROUP
                where groupid in (select groupid from T_SYS_GROUP where groupname = '切換Leader')
                and userid = varuserid ;

                IF varCount = 0 THEN --不是LEADER
                   varSubSql := varSubSql || ' AND  c.STATUS IN  (''A07-1'',''A07-2'',''A07-5'') ';
                   varSubSql := varSubSql || ' AND C.UNDERTAKE = ''' || varUserid || '''';
                ELSE   --是LEADER
                   varSubSql := varSubSql || ' AND ( ( c.STATUS IN  (''A07-1'',''A07-2'',''A07-5'') ';
                   varSubSql := varSubSql || ' AND c.UNDERTAKE = ''' || varuserid || ''') or ( ';
                   varSubSql := varSubSql || ' c.STATUS = ''A07-3'' ';
                   varSubSql := varSubSql || ' AND c.Sign_Now = ''0'' ';
                   varSubSql := varSubSql || ' AND c.Sign_Leader = ''' || varuserid || ''') )';
                END IF;

              WHEN varRole = '0' THEN --varRole = 0(科長), Sign_Now = 1(Sign_Level簽核層級第1個),
                varSubSql := varSubSql || ' AND c.STATUS = ''A07-3'' ';
                varSubSql := varSubSql || ' AND c.Sign_Now = ''1''  ';
                varSubSql := varSubSql || ' AND C.TAKER_UNIT = ''' || varUT_UNITID || '''';

              WHEN varRole = '1' THEN --varRole = 1(科長以上), Sign_Now = 2(Sign_Level簽核層級第二個),Sign_Now = 3(Signoff_Level簽核層級第三個)
                varSubSql := varSubSql || ' AND c.STATUS = ''A07-3'' ';
                varSubSql := varSubSql || ' AND (( c.Sign_Now in (''1'', ''2'') AND C.TAKER_UNIT in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || '%''
                and depusrid not like ''%' || varuserid || ''' )) or ( c.Sign_Now = ''3'' AND C.TAKER_UNIT in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || ''')))';

              WHEN varRole = '9' THEN --varRole = 9(admin)
                 varSubSql := varSubSql || ' AND c.STATUS IN (''A07-1'',''A07-2'',''A07-3'',''A07-5'') ';
              ELSE
                 varSubSql := '';
      END CASE;



      CASE varstep
         WHEN 'A06LOAD' THEN
            IF varKeyId IS NOT NULL THEN
               varSubSql := varSubSql || ' AND E.EC_ID = ''' || varKeyId || '''';
            END IF;
         WHEN 'A06LIST' THEN
            IF varEcnNumber IS NOT NULL THEN
               varSubSql := varSubSql || ' AND E.ECNNO = ''' || varEcnNumber || '''';
            END IF;
            varSubSql := varSubSql || ' AND E.STATUS <> ''A04-3'' ';

            varOrderby := ' ORDER BY releaseDate desc';
         WHEN 'A18LIST' THEN
              --varSql:=replace(varSql, 'SQL2', ', c.CAR');
              varSql:=replace(varSql, 'SQL2', ', F_EC_GetMutiID(''C'',c.ec_id,c.car) chg_id');
              varSubSql := ' AND C.UNDERTAKE = ''' || varUndertake || '''';
              varSubSql := varSubSql || ' AND c.STATUS IN (''A07-1'',''A07-2'',''A07-3'',''A07-5'') ';
         WHEN 'A18LOAD' THEN
              varSql:=replace(varSql, 'SQL2', ', F_EC_GetMutiID(''C'',c.ec_id,c.car) chg_id');
              varSubSql := ' AND C.UNDERTAKE = ''' || varUndertake || '''';
              varSubSql := varSubSql || ' AND c.STATUS IN (''A07-1'',''A07-2'',''A07-3'',''A07-5'') ';
              varSubSql := varSubSql || ' AND c.chg_id IN (' || varKeyId ||') ';
         ELSE
            OPEN ReturnValues FOR
               SELECT 'NA' id, 'NA' NAME
                 FROM dual;

      END CASE;

      --insert into t_ec_sql_log values(sysdate, varSql, 'P_EC_EcChgLIST_PG');
      
      IF varUndertake IS NOT NULL THEN
        varSql := varSql;
      END IF;

      varSql := varSql || varSubSql || varOrderby;
      -- 取記錄數
      VarCountSql := 'select count(*) from (' || varSql || ')';
      EXECUTE IMMEDIATE VarCountSql INTO VarCount;
      OutRecordCount := TO_CHAR(VarCount);

      --執行分頁查詢
      -- XX當每頁筆數大於 0 時, 才做分頁, 不大於0為匯出(Export)用
      VarMaxRowNO := TO_NUMBER(varPageSize) * TO_NUMBER(varPageNO);
      VarMinRowNO := VarMaxRowNO - TO_NUMBER(varPageSize) + 1;
      IF varPageSize > '0' THEN
         VarSql := ' SELECT to_number('||varPageSize||') * (to_number('||varPageNO||')-1)+rownum as no, B.* FROM (
                   SELECT A.*, rownum rn FROM  (' || VarSql || ') A
                      WHERE rownum <= ' || TO_CHAR(VarMaxRowNO) || ') B
               WHERE rn >=  ' || TO_CHAR(VarMinRowNO) || ' order by no ';
      END IF;

      OPEN ReturnValues FOR varSql;

  EXCEPTION
     WHEN OTHERS THEN
        OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' NAME FROM dual;
  END;

  PROCEDURE P_EC_EcSanyiLIST_PG(
      varPageSize    IN VARCHAR2 --每頁數量
     ,varPageNO      IN VARCHAR2 --當前頁
     ,varEcnNumber   IN VARCHAR2 --設通編號-查詢條件
     ,varStep        IN VARCHAR2 --階段值
     ,varCar         IN VARCHAR2 --車系-查詢條件
     ,varUserid      IN VARCHAR2 --登入者，承辦、主管、管理者
     ,varUndertake   IN VARCHAR2 --查詢承辦
     ,varRole        IN VARCHAR2 -- -1(科長以下),0(科長),1(科長以上),9(admin),8(vendor)
     ,varKeyId        IN VARCHAR2  -- ecid or ss_id
     ,ReturnValues   OUT SYS_REFCURSOR
     ,OutRecordCount OUT VARCHAR2 --?記錄數
  ) IS
      -- Sql
      varSql     VARCHAR2(4000);
      varSubSql     VARCHAR2(4000);
      varOrderby VARCHAR2(500);
      -- Page
      VarCountSql VARCHAR2(4000);
      VarCount    INT;
      VarMinRowNO INT;
      VarMaxRowNO INT;
  BEGIN
      varSql := ' SELECT DISTINCT
         (SELECT UNITNA FROM T_SYS_EMPLOYINFO WHERE UNITID=SS.SANYI_UNIT AND ROWNUM<=1) utUnitNA
          , SS.STATUS, (select substr(GLOSSARY1,4) from T_SYS_GLOSSARY where GLOSSARYTYPEID=SS.STATUS) as statusNA
          , E.DESIGNER, E.DES_UNITID as desGrp
          , (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=E.DESIGNER) designerNA
          , (SELECT UNITNA FROM T_SYS_EMPLOYINFO WHERE UNITID=E.DES_UNITID AND ROWNUM<=1) desGrpNA
          , TO_CHAR(E.RELEASED_DATE,''YYYY/MM/DD'') as releasedate
          , E.ECNNO, E.PDM_MODELS, E.EC_ID
          , E.PDM_ECFILEID, E.PDM_ATTACHID SQL2
        FROM T_EC_INFO E INNER JOIN T_EC_SURVEY_INFO S ON E.EC_ID=S.EC_ID
             INNER JOIN T_EC_SANYI SS ON S.SURVEY_ID=SS.SURVEY_ID_FK
        WHERE 1=1 ';

      CASE
         WHEN varRole = '-1' THEN -- -1(科長以下),0(科長),1(科長以上),9(admin),8(vendor)
           varSubSql := varSubSql || ' AND (SS.STATUS IN (''A06-D'',''A06-E'',''A06-J'') ';
           varSubSql := varSubSql || ' AND SS.UNDERTAKER = ''' || varUserid || '''';
           varSubSql := varSubSql || ' OR SS.SIGN_LEADER = ''' || varUserid || ''''; -- OR LEADER
           varSubSql := varSubSql || ' AND SS.STATUS IN (''A06-G'',''A06-I'') )'; --主管待處理，主管審核中
         WHEN varRole='0' OR varRole='1' THEN
           varSubSql := varSubSql || ' AND SS.STATUS IN (''A06-G'',''A06-I'') ';
--           varSubSql := varSubSql || ' AND SS.SANYI_UNIT = (select F_SYS_EMPLOYINFO_GETSECTID('''||varUserid||''') from dual) '; --該登入主管該科的案件
           --201810 by jessica, 修改追加原科長離職由跨科處長代理(K0L00 由K3000處長代理)  
           varSubSql := varSubSql || ' AND (SS.SANYI_UNIT = (select F_SYS_EMPLOYINFO_GETSECTID('''||varUserid||''') from dual) OR SS.SANYI_UNIT IN (select distinct o.leaddepartid from t_sys_leaderinfo o where o.employno = '''||varUserid||'''))';
         WHEN varRole='9' THEN
            varSubSql := varSubSql || ' AND SS.STATUS IN (''A06-D'',''A06-E'',''A06-F'',''A06-J'',''A06-I'',''A06-G'') ';
         ELSE
            varSubSql := '';
      END CASE;

      CASE varstep
         WHEN 'A15LIST' THEN
            IF varEcnNumber IS NOT NULL THEN
               varSubSql := varSubSql || ' AND E.ECNNO = ''' || varEcnNumber || '''';
            END IF;
            IF varCar IS NOT NULL THEN
               varSubSql := varSubSql || ' AND SS.CAR = ''' || varCar || '''';
            END IF;
            varOrderby := ' ORDER BY releaseDate ASC';

         WHEN 'A15LOAD_TOCHG' THEN
            varSql:= replace(varSql, 'SQL2', ', SS.CAR, SS.SS_ID,SS.UNDERTAKER AS undertakeID, (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=SS.UNDERTAKER) undertakeNA');
            IF varKeyId IS NOT NULL THEN
               varSubSql := varSubSql || ' AND E.EC_ID = ''' || varKeyId || '''';
            END IF;
            IF varUserid IS NOT NULL THEN
               varSubSql := varSubSql || ' AND SS.UNDERTAKER = ''' || varUserid || '''';
            END IF;

         WHEN 'A18LIST' THEN
              varSql:= replace(varSql, 'SQL2', ', SS.CAR, SS.SS_ID,SS.UNDERTAKER AS undertakeID, (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=SS.UNDERTAKER) undertakeNA');
              varSubSql := ' AND SS.UNDERTAKER = ''' || varUndertake || '''';
              varSubSql := varSubSql || ' AND SS.STATUS IN (''A06-D'',''A06-E'',''A06-F'',''A06-J'',''A06-I'',''A06-G'') ';

         WHEN 'A18LOAD' THEN
              varSql:= replace(varSql, 'SQL2', ', SS.CAR, SS.SS_ID,SS.UNDERTAKER AS undertakeID, (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=SS.UNDERTAKER) undertakeNA');
              varSubSql := ' AND SS.UNDERTAKER = ''' || varUndertake || '''';
              varSubSql := varSubSql || ' AND SS.STATUS IN (''A06-D'',''A06-E'',''A06-F'',''A06-J'',''A06-I'',''A06-G'') ';
              varSubSql := varSubSql || ' AND SS.SS_ID IN (' || varKeyId || ') ';
         ELSE
            OPEN ReturnValues FOR
               SELECT 0 id, 'NA' NAME FROM dual;
      END CASE;

      -- 取記錄數
      varSql := varSql || varSubSql;
      VarCountSql := 'select count(*) from (' || varSql || ')';
      EXECUTE IMMEDIATE VarCountSql INTO VarCount;
      OutRecordCount := TO_CHAR(VarCount);

      --執行分頁查詢
      -- XX當每頁筆數大於 0 時, 才做分頁, 不大於0為匯出(Export)用
      VarMaxRowNO := TO_NUMBER(varPageSize) * TO_NUMBER(varPageNO);
      VarMinRowNO := VarMaxRowNO - TO_NUMBER(varPageSize) + 1;
      VarSql := VarSql || varOrderby;
      IF varPageSize > '0' THEN
         VarSql := ' SELECT to_number('||varPageSize||') * (to_number('||varPageNO||')-1)+rownum as no, B.* FROM (
                   SELECT A.*, rownum rn FROM  (' || VarSql || ') A
                      WHERE rownum <= ' || TO_CHAR(VarMaxRowNO) || ') B
               WHERE rn >= ' || TO_CHAR(VarMinRowNO) || ' ORDER BY rn asc';
      END IF;

      OPEN ReturnValues FOR varSql;

  EXCEPTION
     WHEN OTHERS THEN
        OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' NAME FROM dual;
  END;

  PROCEDURE P_EC_ChgParts( --查詢零件切換 T_EC_CHG_INFO & pl_info
      varStep         IN VARCHAR2
     ,varKeyid        IN VARCHAR2
     ,varTAKER_UNIT   IN VARCHAR2
     ,varUserid       IN VARCHAR2
     ,varRole         IN VARCHAR2
     ,ReturnValues   OUT SYS_REFCURSOR
  ) IS
     varSql     VARCHAR2(4000);
  BEGIN
      --select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=varUserid

      varSql := 'SELECT ROWNUM AS NO,A.*
           FROM (SELECT E.ECNNO, E.EC_ID, C.CAR, E.PDM_MODELS
           , C.UNDERTAKE AS undertakeID
           , (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=C.UNDERTAKE) undertakeNA
           , decode(C.UNDERTAKE,null,''0'',decode(C.UNDERTAKE,'''||varUserid || ''',''1'',''0'')) as isOwner
           , PL.PARTNO, PL.PARTNAME
           , TO_CHAR(C.CHG_DATE,''YYYY/MM/DD'') AS chgDate
           , C.CHG_MEMO as chgMemo
           , C.chg_id,c.sign_history,c.comment2 as sign_comment,PL.bd,PL.formal_pn
           , PL.SOURCE AS part_src
           ,case when LENGTH(PL.FORMAL_PN) <> 11 OR PL.FORMAL_PN IS NULL then
             ''-'' else
             (select SOURCE from (
                 select a.* from (
                   SELECT P2.SOURCE, P2.PL_ID pid FROM T_EC_PL_INFO P2
                     WHERE P2.PARTNO=FORMAL_PN
                 ) a order by pid desc
              ) where rownum<=1)
              end as opart_src

          FROM T_EC_INFO E INNER JOIN T_EC_CHG_INFO C ON E.EC_ID=C.EC_ID
          LEFT JOIN T_EC_PL_INFO PL ON PL.PL_ID=C.PL_ID
          WHERE 1=1 ';

      IF varKeyid IS NOT NULL THEN
         varSql := varSql || ' AND E.EC_ID = ''' || varKeyid || '''';
      END IF;

      IF varRole <> '9' and varTAKER_UNIT IS NOT NULL THEN
         varSql := varSql || ' AND c.taker_unit = ''' || varTAKER_UNIT || '''';
      END IF;

      CASE varStep
         WHEN 'A06LOAD' THEN
            --若是字串值要補單引號
            --IF Instr(varMultiDocStatus, chr(39)||','||chr(39)) = 0 AND Instr(varMultiDocStatus, ',') > 0 THEN
            --multiDocStatuscode := replace(varMultiDocStatus, ',', chr(39)||','||chr(39));
            CASE
              WHEN varRole = '-1' THEN -- -1(科長以下),0(科長),1(科長以上),9(admin),8(vendor)
                varSql := varSql || ' AND C.STATUS IN (''A07-1'',''A07-2'',''A07-5'') ';
              WHEN varRole='0' OR varRole='1' THEN
                varSql := varSql || ' AND C.STATUS IN (''A07-3'') ';
                --varSql := varSql || ' AND C.SIGN_LIST = ''' || varUserid || '''';
              WHEN varRole='9' THEN
                varSql := varSql || ' AND C.STATUS IN (''A07-1'',''A07-2'',''A07-5'',''A07-3'') ';
            END CASE;
             varSql := varSql || '  ORDER BY isOwner desc,PARTNO';
             varSql := varSql || '  ) A ORDER BY NO';

         ELSE
          OPEN ReturnValues FOR
             SELECT 'NA' id, 'NA' NAME FROM dual;
      END CASE;

      OPEN ReturnValues FOR varSql;

  EXCEPTION
     WHEN OTHERS THEN
        OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' NAME FROM dual;
  END;

  PROCEDURE P_EC_SurveyParts( --零技,PEO-調查零件T_EC_SURVEY_PARTS
      varStep        IN VARCHAR2
     ,varEcid        IN VARCHAR2
     ,ReturnValues   OUT SYS_REFCURSOR
  ) IS
     varSql     VARCHAR2(4000);
     --varOrderby VARCHAR2(500);
  BEGIN
      varSql := 'SELECT ROWNUM AS NO,A.*
        FROM
        ( SELECT SP.PL_ID
        , E.ECNNO, PL.PARTNO, PL.PARTNAME, E.PDM_MODELS
        , DECODE(S.DIST_VENDOR,null,''無'',S.DIST_VENDOR) as vendorID
        , decode((select SUPPLIERNAME from T_ANP_SUPPLIER where SUPPLIERCODE=S.DIST_VENDOR AND ROWNUM<=1),null,''無'',(select SUPPLIERNAME from T_ANP_SUPPLIER where SUPPLIERCODE=S.DIST_VENDOR AND ROWNUM<=1)) vendorNA
        , S.UT_UNITID, (SELECT UNITNA FROM T_SYS_EMPLOYINFO EMP WHERE EMP.UNITID=S.UT_UNITID AND ROWNUM<=1) SANYI_UNIT_NA
        , S.SURVEY_TAKER, (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=S.SURVEY_TAKER) undertakeNA
        , SP.OLD_PART_PD_CNT, SP.OLD_PART_HALF_CNT
        , SP.RUN_PD_DATE,SP.NEW_PART_PRICE
        , NEW_PART_MODEL_COST, NEW_PART_CHK_COST, NEW_PART_CLIP_COST
        , SP.SURVEY_MEMO, SP.survey_parts_id
        , S.STATUS, (select substr(GLOSSARY1,4) from T_SYS_GLOSSARY where GLOSSARYTYPEID=S.status) as statusNA
        FROM T_EC_INFO E LEFT JOIN T_EC_SURVEY_INFO S ON E.EC_ID=S.EC_ID
        LEFT JOIN T_EC_SANYI SS ON SS.SURVEY_ID_FK=S.SURVEY_ID
        LEFT JOIN T_EC_SURVEY_PARTS SP ON SP.SURVEY_ID=S.SURVEY_ID
        LEFT JOIN T_EC_PL_INFO PL ON SP.PL_ID=PL.PL_ID
        WHERE 1=1 ';

      IF varecid IS NOT NULL THEN
          varSql := varSql || ' AND E.EC_ID = ''' || varEcid || '''';
      END IF;
      /* IF varUserid IS NOT NULL THEN
          varSql := varSql || ' AND E.EC_ID = ''' || varEcid || '''';
      END IF;
      IF varRole IS NOT NULL THEN
          varSql := varSql || ' AND E.EC_ID = ''' || varEcid || '''';
      END IF;
      */
      CASE varStep
         WHEN 'A06LOAD' THEN
            varSql := varSql || ' AND E.STATUS = ''A04-4'' AND (S.STATUS = ''A06-K'' OR S.STATUS IS NULL)';
            varSql := varSql || ' ORDER BY S.DIST_VENDOR ASC, PL.PARTNO ASC';
            varSql := varSql || '  ) A ORDER BY NO';
         ELSE
            OPEN ReturnValues FOR
               SELECT 'NA' id, 'NA' NAME FROM dual;

      END CASE;

      OPEN ReturnValues FOR varSql;

  EXCEPTION
     WHEN OTHERS THEN
        OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' NAME FROM dual;
  END;

  --三義工廠-調查零件T_EC_SANYI, T_EC_SURVEY_PARTS
  PROCEDURE P_EC_SurveySanyiParts(
     varStep        IN VARCHAR2
     ,varEcid        IN VARCHAR2
     ,varTaker       IN VARCHAR2
     ,varStatus      IN VARCHAR2
     ,ReturnValues   OUT SYS_REFCURSOR
  ) IS
     -- Sql
     varSql           VARCHAR2(4000);
     varSubSql        VARCHAR2(4000);
     --varOrderby VARCHAR2(500);
  BEGIN
     varSql := ' SELECT SP.PL_ID
        , E.ECNNO, PL.PARTNO, PL.PARTNAME, E.PDM_MODELS
        , S.DIST_VENDOR as vendorID
        , (select SUPPLIERNAME from T_ANP_SUPPLIER where SUPPLIERCODE=S.DIST_VENDOR) vendorNA
        , SS.SANYI_UNIT, (SELECT UNITNA FROM T_SYS_EMPLOYINFO EMP WHERE EMP.UNITID=SS.SANYI_UNIT AND ROWNUM<=1) SANYI_UNIT_NA
        , SS.UNDERTAKER UNDERTAKE, (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=SS.UNDERTAKER) undertakeNA
        , SP.OLD_PART_PD_CNT, SP.OLD_PART_HALF_CNT
        , to_char(SP.RUN_PD_DATE,''YYYY/MM/DD'') as RUN_PD_DATE, SP.NEW_PART_PRICE
        , NEW_PART_MODEL_COST, NEW_PART_CHK_COST, NEW_PART_CLIP_COST
        , SP.SURVEY_MEMO, SS.CAR, SP.survey_parts_id
        , SS.STATUS, (select substr(GLOSSARY1,4) from T_SYS_GLOSSARY where GLOSSARYTYPEID=SS.status) as statusNA
        , (select GLOSSARY2 from T_SYS_GLOSSARY where GLOSSARYTYPEID LIKE ''A06%'' AND GLOSSARY1=SS.status) as unitStatusNA
        , SS.SIGN_COMMENT, SSU.SIGN_HISTORY
        FROM T_EC_INFO E INNER JOIN T_EC_SURVEY_INFO S ON E.EC_ID=S.EC_ID
        LEFT JOIN T_EC_SANYI SS ON S.SURVEY_ID=SS.SURVEY_ID_FK
        LEFT JOIN T_EC_SANYI_UNIT SSU ON SS.SURVEY_ID_FK=SSU.SURVEY_ID_FK2 AND SS.SANYI_UNIT=SSU.SANYI_UNIT2
        LEFT JOIN T_EC_SURVEY_PARTS SP ON SS.SURVEY_ID_FK=SP.SURVEY_ID AND SS.SS_ID=SP.SS_ID_FK
        LEFT JOIN T_EC_PL_INFO PL ON SP.PL_ID=PL.PL_ID
        WHERE S.DIST_VENDOR=''SANYI'' AND SP.SS_ID_FK>0 ';

      IF varecid IS NOT NULL THEN
          varSubSql := varSubSql || ' AND E.EC_ID = ''' || varEcid || '''';
      END IF;
    /*  IF varStatus IS NOT NULL THEN
          varSql := varSql || ' AND SS.STATUS = ''' || varStatus || '''';
      END IF;*/
      IF varTaker IS NOT NULL THEN
          IF varStatus='A06-I' OR varStatus='A06-G' THEN --主管進入
            IF SUBSTR(varTaker,1,2)='<>' THEN
               varSubSql := varSubSql || ' AND SS.SANYI_UNIT <> F_SYS_EMPLOYINFO_GETSECTID(''' || SUBSTR(varTaker,3) || ''')';
            ELSE
               varSubSql := varSubSql || ' AND SS.SANYI_UNIT IN F_SYS_EMPLOYINFO_GETSECTID(''' || varTaker || ''')';
            END IF;
          ELSE --承辦進入
            IF SUBSTR(varTaker,1,2)='<>' THEN
               varSubSql := varSubSql || ' AND SS.UNDERTAKER <> ''' || SUBSTR(varTaker,3) || '''';
            ELSE
               varSubSql := varSubSql || ' AND SS.UNDERTAKER = ''' || varTaker || '''';
            END IF;
          END IF;
      END IF;


      CASE varStep
         WHEN 'A15LOAD' THEN
--            varSubSql := varSubSql || ' AND E.STATUS = ''A04-2'' ORDER BY SS.STATUS ASC, SS.SANYI_UNIT ASC, SS.CAR ASC ';
            varSubSql := varSubSql || ' ORDER BY SS.STATUS ASC, SS.SANYI_UNIT ASC, SS.CAR ASC ';
         ELSE
            OPEN ReturnValues FOR
               SELECT 'NA' id, 'NA' NAME
                 FROM dual;

      END CASE;

      varSql := varSql || varSubSql;
      OPEN ReturnValues FOR varSql;

  EXCEPTION
     WHEN OTHERS THEN
        OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' NAME FROM dual;
  END;

  PROCEDURE P_EC_ChgTakerSave( --重新指派承辦
     varkeyId      IN VARCHAR2, --T_EC_SURVEY_INFO.SURVEY_ID 調查單ID
                                 --或T_EC_SANYI.SS_ID 三義工廠ID
                                 --或T_EC_CHG_INFO.EC_ID 零件切換ID      varOldEmp     IN VARCHAR2, --原承辦
     varNewEmp     IN VARCHAR2, --新承辦
     varUserSec    IN VARCHAR2, --登入者科別
     varCar        IN VARCHAR2, --承辦車系
     varStep       IN VARCHAR2, --A15Chg、A18Chg
     OutResult     OUT VARCHAR2
  ) IS
      datacount1 NUMBER(10); --是否為調查科別
     -- datacount2 NUMBER(10); --是否為三義工廠科別
      datacount3 NUMBER(10); --是否為零件切換科別
      varMail    NVARCHAR2(250);
      varEcnno   VARCHAR2(20);
      --rows number;
      rtnMid number;
      --   surveyWorkID    VARCHAR2 (10);              --survey待辦事項ID
     varSql VARCHAR2(2000);

  BEGIN
      SELECT COUNT(*)
        INTO datacount1
        FROM T_SYS_GLOSSARY G, T_SYS_EMPLOYINFO E
       WHERE G.GLOSSARYTYPEID LIKE '%A05%' --1.1.1 「設變調查單位」- 零技科 A05-1, PEO A05-2
         AND E.UNITID = varUserSec
         AND G.GLOSSARY2 =  E.UNITID;

    /*  SELECT COUNT(*)
        INTO datacount2
        FROM T_SYS_GLOSSARY G, T_SYS_EMPLOYINFO E
       WHERE G.GLOSSARYTYPEID LIKE '%A02%'
         AND E.UNITID = varUserSec
         AND G.GLOSSARY2 = E.UNITID;
   */
      SELECT COUNT(*)
        INTO datacount3
        FROM T_SYS_GLOSSARY G, T_SYS_EMPLOYINFO E
       WHERE G.GLOSSARYTYPEID LIKE '%A10%'
         AND E.UNITID = varUserSec
         AND G.GLOSSARY2 = E.UNITID;

      --更新所選的調查主檔『承辦』
      IF datacount1 <> 0 THEN --調查單位
        varSql := 'UPDATE T_EC_SURVEY_INFO S
            SET SURVEY_TAKER = ''' || varNewEmp || '''
            ,isalert = ''N''
          WHERE SURVEY_ID in (' || varkeyId || ')';

          EXECUTE IMMEDIATE varSql;

         --rows := sql%rowcount;
         varSql := 'UPDATE T_SYS_WORKLIST
            SET USERID = ''' || varNewEmp || ''', SENDTIME=SYSDATE
          WHERE COMPTIME IS NULL
            AND WORKLISTID IN (SELECT WORKLISTID FROM T_EC_SURVEY_INFO
           WHERE SURVEY_ID in (' || varkeyId || '))';

          EXECUTE IMMEDIATE varSql;

      ELSIF datacount3 <> 0 THEN -- 零件切換(A06Chg用)
         UPDATE T_EC_CHG_INFO
            SET UNDERTAKE = varNewEmp
            ,isalert = 'N'
         WHERE EC_ID = varkeyId and (CAR=varCar or varCar is null);
         --rows := sql%rowcount;

         UPDATE T_SYS_WORKLIST --更新待辦事項
            SET USERID = varNewEmp
            , SENDTIME=SYSDATE
          WHERE COMPTIME IS NULL
            AND WORKLISTID IN (SELECT WORKLISTID FROM T_EC_CHG_INFO
                                WHERE EC_ID = varkeyId and (CAR=varCar or varCar is null));
      END IF;

      IF varStep = 'A18Chg_C' THEN  --A18重新指派承辦(零件切換調查_生管、行銷、Infiniti)

        varSql := 'UPDATE  T_EC_CHG_INFO
            SET  UNDERTAKE = ''' || varNewEmp || '''
            ,isalert = ''N''
          WHERE chg_ID in (' || varkeyId || ')';

          EXECUTE IMMEDIATE varSql;

          --更新待辦事項
          varSql := 'UPDATE T_SYS_WORKLIST
            SET USERID = '''|| varNewEmp || ''', SENDTIME=SYSDATE
          WHERE COMPTIME IS NULL
            AND WORKLISTID IN (SELECT WORKLISTID FROM T_EC_CHG_INFO
           WHERE chg_ID in (' || varkeyId || '))';

          EXECUTE IMMEDIATE varSql;

      ELSIF varStep = 'A18Chg_S' THEN   --A18重新指派承辦(三義工廠調查)
            varSql := 'UPDATE  T_EC_SANYI
            SET  UNDERTAKER = ''' || varNewEmp || '''
            ,isalert = ''N''
          WHERE SS_ID in (' || varkeyId || ')';

          EXECUTE IMMEDIATE varSql;

          --更新待辦事項
          varSql := 'UPDATE T_SYS_WORKLIST
            SET USERID = ''' || varNewEmp || ''', SENDTIME=SYSDATE
          WHERE COMPTIME IS NULL
            AND WORKLISTID IN (SELECT WORKLISTID FROM T_EC_SANYI
           WHERE SS_ID in (' || varkeyId || '))';

          EXECUTE IMMEDIATE varSql;

      ELSIF varStep = 'A15Chg' THEN --A15三義工廠調查 TO CHG
         UPDATE T_EC_SANYI
          SET UNDERTAKER = varNewEmp, STATUS='A06-D' --待處理
          ,isalert = 'N'
           WHERE SS_ID = varkeyId;
         --rows := sql%rowcount;

         UPDATE T_SYS_WORKLIST --更新待辦事項
            SET USERID = varNewEmp
            , SENDTIME=SYSDATE
          WHERE COMPTIME IS NULL
            AND WORKLISTID IN (SELECT WORKLISTID FROM T_EC_SANYI
                                WHERE SS_ID = varkeyId);

          SELECT f_sys_employinfo_getmail3byno(varNewEmp) into varMail FROM DUAL; --新承辦
          SELECT DISTINCT E.ECNNO INTO varEcnno FROM T_EC_SANYI S INNER JOIN T_EC_INFO E ON S.EC_ID_FK=E.EC_ID WHERE SS_ID = varkeyId;
          P_SYS_Mail_Add(varMail, '', 'ESS三義工廠承辦更換!', '請新承辦進行' ||varEcnno||' 調查內容確認!','', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1

      END IF;

      commit;
      OutResult := 'ok';
  EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         OutResult := SQLERRM;

  END P_EC_ChgTakerSave;

  PROCEDURE P_EC_SurveyStatus_sdo( -- 更新各階段的status
        varStep         IN VARCHAR2,
        varkeyId        IN VARCHAR2,
        varStatus       IN VARCHAR2,
        varUndertaker   IN VARCHAR2,
        varSign_comment IN VARCHAR2,
        varOverDueReasonDescription        IN NVARCHAR2,
        OutResult       OUT VARCHAR2
  ) IS
       rows           number;
       rows2          number;
       returnWkId     number;
       varWkid        number;
       --varSIGN_NOW    number;
       --varSIGN_LEADER number;
       --varSIGN_LIST   number;
       vartaker       VARCHAR2(10);
       varEc_id       number;
       varSid         number;

       varName        VARCHAR2(200);
       varPositionna  VARCHAR2(200);
       varHistNum     varchar(3);
       varEcnno       VARCHAR2(20);
       varStatus2     VARCHAR2(20);
       varVendor      VARCHAR2(20);
       varLeader      VARCHAR2(20);
       varUt_unitid    VARCHAR2(10);
       varSurvey_taker VARCHAR2(20);
       varSign_List    char(1);
       varSign_now     char(1);
       varSendMan      VARCHAR2(20);
       varComment      NVARCHAR2(1000);
       varTitle        NVARCHAR2(1000);
       varPdmModels    VARCHAR2(200);
       varMail         VARCHAR2(250);
       varMail2        VARCHAR2(250);
       varRV           CHAR(1);
       newWorkListId  VARCHAR2(200);
       varUt_unitna  VARCHAR2(30);
       v_semail       varchar2(100);  --收件者
       v_semail_na    varchar2(100);  --收件者姓名
       v_ccmail       varchar2(500);  --副本
       v_title        varchar2(100);  --主旨
       v_body         varchar2(30000);  --內容1
       VarContent     varchar2(32767);  --內容
       VarResult      varchar2(10);

      --SANYI_該科所有承辦
      CURSOR sanyi_taker(ecid VARCHAR2, grpid VARCHAR2) IS
         SELECT distinct SS.UNDERTAKER FROM t_ec_sanyi SS
          WHERE SS.EC_ID_FK=ecid AND SS.SANYI_UNIT=grpid;
      s_field sanyi_taker%ROWTYPE;
      
      Cursor Cur_MailAddress Is
      Select b.mailAddress From T_SYS_EmployInfo b,T_SYS_UserAccount a
      Where b.EmployNo = a.UserID And a.GroupID = 'PISGroup1';

  BEGIN
      IF varStep = 'A11SendV' THEN
         select s.survey_taker,i.ecnno,s.dist_vendor|| ' ' || sp.suppliername, sp.suppliername,''
              ,to_char(decode(s.sign_history, null, 1, substr(s.sign_history,0,instr(s.sign_history,'.')-1)+1))
         into varSurvey_taker,varEcnno,varVendor,varName,varPositionna,varHistNum
         from t_ec_survey_info s
         join t_ec_info i on s.ec_id = i.ec_id
         join t_anp_supplier sp on s.dist_vendor = sp.suppliercode
         where s.survey_id = varkeyId;
      ELSE
        --取得簽核歷程用之姓名及職稱
        IF varStep <> 'A11LOAD' and varStep <> 'A11_LoadSaveC' and varStep <> 'A11_LoadSaveM'  THEN
            select e.name,e.positionna into varName,varPositionna
              from t_sys_employinfo e where e.employno = varUndertaker;
        END IF;

        IF varStep = 'A11SendY' or varStep = 'A11Agree' or varStep = 'A11Reject' THEN
          --取得簽核歷程用之流水號
          select distinct to_char(decode(s.sign_history, null, 1, substr(s.sign_history,0,instr(s.sign_history,'.')-1)+1)),s.worklistid,
              i.ecnno,s.dist_vendor|| ' ' || sp.suppliername,s.sign_leader,s.ut_unitid,s.survey_taker,s.Sign_List,s.Sign_now
          into varHistNum,varWkid,varEcnno,varVendor,varLeader,varUt_unitid,varSurvey_taker,varSign_List,varSign_now
          from t_ec_survey_info s
          join t_ec_info i on s.ec_id = i.ec_id
          join t_anp_supplier sp on s.dist_vendor = sp.suppliercode
          where s.survey_id = varkeyId;

        ELSIF varStep = 'A06sendNg' or varStep = 'A06send' THEN
         --取得簽核歷程用之流水號
         select distinct max(to_char(decode(c.sign_history, null, 1, substr(c.sign_history,0,instr(c.sign_history,'.')-1)+1))),
                c.sign_leader,i.ecnno,c.taker_unit,e.deptna,c.Sign_List,c.Sign_now
         into varHistNum,varLeader,varEcnno,varUt_unitid,varUt_unitna,varSign_List,varSign_now
          from t_ec_chg_info c
          join t_ec_info i on c.ec_id = i.ec_id
          join t_sys_employinfo e on c.taker_unit = e.unitid
          where i.ec_id = varkeyId and (e.employno = varUndertaker or F_EC_PowerUser(varUndertaker) = 1)
          and c.status = varStatus
           group by  c.sign_leader,i.ecnno,c.taker_unit,e.deptna,c.Sign_List,c.Sign_now;

         ELSIF varStep = 'A06chkOk' or varStep = 'A06chkNg' THEN
         --取得簽核歷程用之流水號
         select distinct max(to_char(decode(c.sign_history, null, 1, substr(c.sign_history,0,instr(c.sign_history,'.')-1)+1))),
                c.sign_leader,i.ecnno,c.taker_unit,c.Sign_List,c.Sign_now
         into varHistNum,varLeader,varEcnno,varUt_unitid,varSign_List,varSign_now
          from t_ec_chg_info c
          join t_ec_info i on c.ec_id = i.ec_id
           join t_sys_employinfo e on c.taker_unit = e.unitid
          where i.ec_id = varkeyId and (e.employno = varUndertaker or F_EC_PowerUser(varUndertaker) = 1)
          and c.status = varStatus
          group by  c.sign_leader,i.ecnno,c.taker_unit,c.Sign_List,c.Sign_now;
       ELSIF (varStep = 'A15send' or varStep = 'A15chkOk' or varStep = 'A15chkNg' OR varStep = 'A15notSelf') THEN
          --取得(該科)簽核歷程用之流水號
          --201811, jessica盧科長015469隸屬單位在生技部經理室(K0A00)但O人令權限設定在377總裝組(K0L00)
          select distinct to_char(decode(su.sign_history, null, 1, substr(su.sign_history,0,instr(su.sign_history,'.')-1)+1)),
            i.ecnno,sp.suppliercode|| ' ' || sp.suppliername,s.sign_leader,s.sanyi_unit, sp.suppliername, s.Sign_List,s.Sign_now, s.survey_id_fk, i.title, i.pdm_models
            into varHistNum,varEcnno,varVendor,varLeader,varUt_unitid,varUt_unitna,varSign_List,varSign_now, varSid, varTitle, varPdmModels
          from t_ec_sanyi s
          inner join t_ec_info i on s.ec_id_fk=i.ec_id
          inner join t_anp_supplier sp on sp.suppliercode='SANYI'
          left join t_ec_sanyi_unit su on s.survey_id_fk=su.survey_id_fk2 and s.sanyi_unit=su.sanyi_unit2
            where s.ec_id_fk=varkeyId 
             and (s.SANYI_UNIT = F_SYS_EMPLOYINFO_GETSECTID(varUndertaker) or
                  varUndertaker = F_SYS_EMPLOYINFO_GETLEADERBYSE(s.SANYI_UNIT));
        END IF;
      END IF;


      CASE varStep
        --// -> 處理中
        WHEN 'A06LOAD' THEN
          UPDATE T_EC_CHG_INFO S SET STATUS = 'A07-2'
          , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
          WHERE EC_ID = varkeyId and STATUS = 'A07-1' and (UNDERTAKE = varUndertaker  or F_EC_PowerUser(varUndertaker) = 1) ;

        WHEN 'A06send' THEN --完成送出
          varComment:=varSign_comment;
          IF varComment IS NULL THEN
             varComment:='承辦呈送!';
          END IF;
          --3.5.2 零件切換調查狀態設為A07-6切換-承辦送出完成；該生管的待辦完成之。
          UPDATE T_SYS_WORKLIST SET COMPTIME=SYSDATE --更新待辦事項
            WHERE COMPTIME IS NULL AND WORKLISTID IN
              (SELECT WORKLISTID FROM T_EC_CHG_INFO
              WHERE EC_ID = varkeyId and STATUS = varStatus and (UNDERTAKE = varUndertaker or F_EC_PowerUser(varUndertaker) = 1));

          UPDATE T_EC_CHG_INFO S
          SET STATUS = 'A07-6' , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
          WHERE EC_ID = varkeyId and TAKER_UNIT = varUt_unitid and (UNDERTAKE = varUndertaker or F_EC_PowerUser(varUndertaker) = 1);

          UPDATE T_EC_CHG_INFO S
          SET  sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 呈送零件切換調查，意見：' || varComment || chr(10) || sign_history
          , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
          WHERE EC_ID = varkeyId and TAKER_UNIT = varUt_unitid and (UNDERTAKE = varUndertaker or F_EC_PowerUser(varUndertaker) = 1);

          --3.5.3 該ECN+科的所有零件切換調查狀態皆已承辦送出(A07-6)
          SELECT COUNT(*) INTO rows --所有切換調查完成
                FROM T_EC_CHG_INFO
              WHERE EC_ID = varkeyId and TAKER_UNIT = varUt_unitid AND STATUS <> 'A07-6';

          IF rows = 0 THEN
          --主管審核List(Sign_List)為空白時：零件切換調查狀態設為A07-4切換-主管審核完成，設通單狀態設為A04-5資管科_結案；
             IF varSign_List is null then
                  UPDATE T_EC_CHG_INFO S SET STATUS = 'A07-4' , Sign_Now = '0'
                  WHERE EC_ID = varkeyId and TAKER_UNIT = varUt_unitid and STATUS = 'A07-6';

                  --所有切換調查完成，設通單也完成
                  UPDATE T_EC_INFO SET STATUS = 'A04-5'  ,isalert = 'N'
                  , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
                  WHERE EC_ID = varkeyId;
                  
                  --A06chkOk(最後一張調查單時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A07-4 確認-主管審核完成，且生管部回覆日期<=預計答覆日, T_EC_SUM.status = A19-3
                  --P_EC_STATUS_CAL(varkeyId);
                  UPDATE T_EC_SUM SET STATUS = 'A19-3',rdate = SYSDATE
                     , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
                     WHERE EC_ID = varkeyId
                       AND REPORT_TYPE = 'C'
                       AND UNIT in (select S.GLOSSARY3 from t_sys_glossary s where S.GLOSSARYTYPEID LIKE 'A10-%' AND  S.GLOSSARY2 = varUt_unitid )
                       AND TO_CHAR(sysdate,'YYYYMMDD') <= TO_CHAR(pdate,'YYYYMMDD');
                   --A06chkOk(最後一張調查單時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A07-4 確認-主管審核完成，且生管部回覆日期>預計答覆日, T_EC_SUM.status = A19-4
                   UPDATE T_EC_SUM SET STATUS = 'A19-4',rdate = SYSDATE
                     , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
                     WHERE EC_ID = varkeyId
                       AND REPORT_TYPE = 'C'
                       AND UNIT in (select S.GLOSSARY3 from t_sys_glossary s where S.GLOSSARYTYPEID LIKE 'A10-%' AND  S.GLOSSARY2 = varUt_unitid )
                       AND TO_CHAR(sysdate,'YYYYMMDD') > TO_CHAR(pdate,'YYYYMMDD');
                  
              ELSE
                --3.5.4 該ECN所有零件切換調查狀態皆已承辦送出(A07-6)且主管審核List(Sign_List)為非空白時：?ECN+科的所有承辦的零件切換調查狀態設為A07-3切換-主管審核中，新增審核主管待辦事項
                  UPDATE T_EC_CHG_INFO S
                  SET STATUS = 'A07-3' ,Sign_Now = decode(sign_leader,null,1,0),isalert = 'N'
                  WHERE EC_ID = varkeyId and STATUS = 'A07-6' and TAKER_UNIT = varUt_unitid ;

                  --5.1.6 產生下一關(若Leader有值則送給Leader，若Leader為空則送給切換單位之科主管)的待辦。
                  if varLeader is not null then
                    varSendMan := varLeader;
                  else
                    select f_sys_employinfo_getleaderbyse(varUt_unitid) into varSendMan from dual;
                  end if;

                  PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                      '13-02-07',      --功能選單ID
                                       varEcnno || ' 零件切換調查 請審核', --主旨
                                       varEcnno || ' 零件切換調查 請審核', --內容
                                       newWorkListId    --成功:WorkListID;  失敗:-1
                                      );

                    UPDATE T_EC_CHG_INFO S
                    SET s.worklistid = newWorkListId
                    WHERE EC_ID = varkeyId and STATUS = 'A07-3' and TAKER_UNIT = varUt_unitid ;
           END IF;
         END IF;

        WHEN 'A06chkOk' THEN --審核同意
             --4.1.1 該主管的待辦完成
             UPDATE T_SYS_WORKLIST SET COMPTIME=SYSDATE
              WHERE COMPTIME IS NULL AND WORKLISTID IN (SELECT WORKLISTID
                    FROM T_EC_CHG_INFO WHERE EC_ID = varkeyId and TAKER_UNIT = varUt_unitid);

             varComment:=varSign_comment;
             IF varComment IS NULL THEN
                 varComment:='審核同意!';
             END IF;

             --4.1.2  若非最後一關卡(Sign_List <>Sign_Now），呈送下一關卡進行審核：Sign_Now = Sign_Now + 1；新增下一關主管待辦事項。
             if (varSign_List <> varSign_Now) then
               --Sign_Now = Sign_Now + 1
               varSign_Now := varSign_Now+1;

               UPDATE T_EC_CHG_INFO
               SET  Sign_Now = varSign_Now
               ,sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 同意零件切換調查，意見：' || varComment || chr(10) || sign_history
               ,isalert = 'N'
               WHERE EC_ID = varkeyId and STATUS = varStatus and TAKER_UNIT = varUt_unitid ;

               --5.2.3.2  下一關卡人員為取調查科別所屬T_SYS_LEADERLAYER的第幾N個工號(N即為T_EC_SURVEY_INFO.Sign_Now）
               --科長:substr(depusrid,0,6),副理:substr(depusrid,8,6),經理:substr(depusrid,15,6)
               select substr(depusrid,decode(varSign_Now,1,0,decode(varSign_Now,2,8,15)),6) into varSendMan
               from T_SYS_LEADERLAYER where id = varUt_unitid;

               --5.2.6 新增下一關卡待辦
               PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                  '13-02-07',      --功能選單ID
                                   varEcnno || ' 零件切換調查 請審核', --主旨
                                   varEcnno || ' 零件切換調查 請審核', --內容
                                   newWorkListId    --成功:WorkListID;  失敗:-1
                                  );

              UPDATE T_EC_CHG_INFO
                SET worklistid = newWorkListId
              WHERE EC_ID = varkeyId and STATUS = varStatus and TAKER_UNIT = varUt_unitid ;
            else
              --　4.1.3  若為最後一關卡(Sign_List = Sign_Now)：零件切換調查狀態設為A07-4切換-主管審核完成，設通單狀態設為A04-5資管科_結案
              UPDATE T_EC_CHG_INFO S SET STATUS = 'A07-4'
              ,sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 同意零件切換調查，意見：' || varComment || chr(10) || sign_history
              , MODIFYER = varUndertaker, MODIFY_DATE = SYSDATE
              WHERE EC_ID = varkeyId and STATUS = varStatus and TAKER_UNIT = varUt_unitid ;

              --3.5.3 該ECN所有零件切換調查狀態皆已 A07-4切換-主管審核完成
              SELECT COUNT(*) INTO rows --所有切換調查  主管審核完成
                  FROM T_EC_CHG_INFO
              WHERE EC_ID = varkeyId AND STATUS <> 'A07-4';

              IF rows = 0 THEN
                 UPDATE T_EC_INFO SET STATUS = 'A04-5' ,isalert = 'N'
                 , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
                 WHERE EC_ID = varkeyId;
                 
                  --A06chkOk(最後一張調查單時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A07-4 確認-主管審核完成，且生管部回覆日期<=預計答覆日, T_EC_SUM.status = A19-3
                  --P_EC_STATUS_CAL(varkeyId);
                  UPDATE T_EC_SUM SET STATUS = 'A19-3',rdate = SYSDATE
                     , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
                     WHERE EC_ID = varkeyId
                       AND REPORT_TYPE = 'C'
                       AND UNIT in (select S.GLOSSARY3 from t_sys_glossary s where S.GLOSSARYTYPEID LIKE 'A10-%' AND  S.GLOSSARY2 = varUt_unitid )
                       AND pdate > sysdate;
                   --A06chkOk(最後一張調查單時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A07-4 確認-主管審核完成，且生管部回覆日期>預計答覆日, T_EC_SUM.status = A19-4
                   UPDATE T_EC_SUM SET STATUS = 'A19-4',rdate = SYSDATE
                     , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
                     WHERE EC_ID = varkeyId
                       AND REPORT_TYPE = 'C'
                       AND UNIT in (select S.GLOSSARY3 from t_sys_glossary s where S.GLOSSARYTYPEID LIKE 'A10-%' AND  S.GLOSSARY2 = varUt_unitid )
                       AND pdate <= sysdate;
              END IF;
            END IF;
            
        WHEN 'A06chkNg' THEN --審核退回
          varComment:=varSign_comment;
             IF varComment IS NULL THEN
                 varComment:='審核退回!';
             END IF;

          --4.2.1 零件切換調查狀態設為A07-5 切換-主管退回承辦；該主管的待辦完成之。
          UPDATE T_EC_CHG_INFO S SET STATUS = 'A07-5', Sign_Now = decode(sign_leader,null,1,0)
          ,sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 退回零件切換調查，意見：' || varComment || chr(10) || sign_history
          ,isalert = 'N'
          , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
          WHERE EC_ID = varkeyId and STATUS = varStatus and TAKER_UNIT = varUt_unitid ;

          rows := sql%rowcount;
          IF rows > 0 THEN
            UPDATE T_SYS_WORKLIST SET COMPTIME=SYSDATE --更新待辦事項
              WHERE COMPTIME IS NULL AND WORKLISTID IN (SELECT WORKLISTID
                FROM T_EC_CHG_INFO WHERE EC_ID = varkeyId and TAKER_UNIT = varUt_unitid );

            --取得該ECN+科的所有承辦
            declare cursor dc_cur is
            select c.undertake
            from  T_EC_CHG_INFO c
            WHERE EC_ID = varkeyId and TAKER_UNIT = varUt_unitid ;

            begin
            open dc_cur;
            loop
            fetch dc_cur into varSurvey_taker;
            exit when dc_cur%notfound;

                    PA_SYS_WORKLIST.P_WORKLIST_ADD(varSurvey_taker,   --對象
                                          '13-02-07',      --功能選單ID
                                           varEcnno || ' 零件切換調查 主管退回，請承辦重新確認', --主旨
                                           varEcnno || ' 零件切換調查 主管退回，請承辦重新確認', --內容
                                           newWorkListId    --成功:WorkListID;  失敗:-1
                                          );

                    UPDATE T_EC_CHG_INFO S
                    SET s.worklistid = newWorkListId
                    WHERE EC_ID = varkeyId and STATUS = 'A07-5' and TAKER_UNIT = varUt_unitid and  undertake = varSurvey_taker;

            end loop;
            close dc_cur;
            end;

          END IF;


       --//退回-須執行調查sendNg & 完成送出send & 審核同意chkOk & 審核退回chkNg, by ecn為單位
        WHEN 'A06sendNg' THEN --3.3 退回-須執行調查：將該ECN退回YNTC資管科(設通單狀態A04-3 零件切換_退回，新增待辦)，再確認是否要先執行調查；該生管的待辦完成之。
          varComment:=varSign_comment;
          IF varComment IS NULL THEN
             varComment:='退回-須執行調查!';
          END IF;

         UPDATE T_EC_CHG_INFO S
          SET sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 退回，意見：' || varComment || chr(10) || sign_history
          , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
          --, s.status = 'A07-7' --切換-承辦退回資管, 問題173
          WHERE EC_ID = varkeyId and STATUS IN ('A07-2','A07-5') and (UNDERTAKE = varUndertaker  or F_EC_PowerUser(varUndertaker) = 1);

          UPDATE T_EC_INFO S SET STATUS = 'A04-3'
          , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
          WHERE EC_ID = varkeyId;

          UPDATE T_SYS_WORKLIST SET COMPTIME=SYSDATE --更新待辦事項
            WHERE WORKLISTID in (SELECT WORKLISTID FROM T_EC_CHG_INFO
                  WHERE EC_ID = varkeyId) --and UNDERTAKE = varUndertaker, 問題173
                  AND COMPTIME IS NULL;

           select g.glossary2 into varSendMan from t_sys_glossary g where g.glossarytypeid = 'A14-2';

           --5.2.4.2.2 新增資管科承辦(公用參數A14-2)待辦
           PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                              '13-02-08',      --功能選單ID
                               varEcnno || ' 零件切換調查 退回-須執行調查，請確認', --主旨
                               varEcnno || ' 零件切換調查 退回-須執行調查，請確認', --內容
                               newWorkListId    --成功:WorkListID;  失敗:-1
                              );

          UPDATE T_EC_INFO i
            SET i.worklistid = newWorkListId
          WHERE EC_ID  = varkeyId ;

           -- 發送Email給資管窗口 CC資管主管
           --資管窗口
           select e.mailaddress,e.name into v_semail,v_semail_na
           from T_SYS_EMPLOYINFO e
           inner join T_SYS_GLOSSARY g on e.employno = g.glossary2
           where g.glossarytypeid = 'A14-2' and e.INSERVICE = 'Y';

            --資管主管
/*           select e.mailaddress into v_ccmail
           from T_SYS_EMPLOYINFO e
           where e.unitid in (
                 select distinct e.unitid
                 from T_SYS_EMPLOYINFO e
                 inner join T_SYS_GLOSSARY g on e.employno = g.glossary2
                 where g.glossarytypeid = 'A14-2' and e.INSERVICE = 'Y' )
           and INSERVICE = 'Y' AND POSITIONTYPE <> 11;*/

           v_title := 'ESS<退回通知>'|| varUt_unitna  ||'退回廠商或零件切換調查';
           v_body := v_semail_na ||' 先生/小姐 您好：<br>' || varUt_unitna || '退回設通單' || varEcnno ||'，請進入設變調查e化系統執行EC>>管理>>「分發廠商調整」功能。';
           VarContent := '<html><head></head><body><P>'|| v_body ||'</P></body></html>';

           p_sys_mail_add(v_semail,v_ccmail,v_title,VarContent,'','Y','','',VarResult);
           if VarResult = '-1' then
              rollback;
              return;
           end if;


        WHEN 'A15LOAD' THEN --ccc
          IF varStatus = 'A06-D' THEN --承辦待處理A06-D -> 處理中A06-E
            UPDATE T_EC_SANYI SS SET STATUS = 'A06-E'
            , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
            WHERE EC_ID_FK = varkeyId AND UNDERTAKER = varUndertaker;
          END IF;
          IF varStatus = 'A06-G' THEN --確認-主管待處理A06-G -> 確認-主管審核中A06-I
            UPDATE T_EC_SANYI SS SET STATUS = 'A06-I'
            , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
            WHERE EC_ID_FK = varkeyId AND SS.SANYI_UNIT=varUt_unitid;
          END IF;


        --3.2 完成送出按鈕：將T_EC_SANYI該ECN,該承辦的狀態改為A06-F(確認-承辦完成), 該承辦待辦完成
        --3.2.1 該ECN,該科所有記錄的狀態皆為「A06-F」時呈送主管審核(T_EC_SANYI狀態改為A06-G, 新增待辦)
        WHEN 'A15send' THEN --判斷給Lader或主管
          varStatus2:='A06-F'; --確認-承辦完成
          varComment:=varSign_comment;
          IF varComment IS NULL THEN
             varComment:='承辦呈送!';
          END IF;


        WHEN 'A15notSelf' THEN
          varStatus2:='A06-L';--確認-非本組業務
          varComment:=varSign_comment;
          IF varComment IS NULL THEN
             varComment:='非本組業務!';
          END IF;


        -- 主管退回A15chkNg、主管同意A15chkOk、完成送出A15send、非本組業務A15notSelf
        WHEN 'A15chkNg' THEN
          UPDATE T_EC_SANYI S SET STATUS = 'A06-J' --確認-主管退回承辦
            , isalert = 'N'
            , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
            WHERE S.EC_ID_FK = varkeyId AND S.SANYI_UNIT = varUt_unitid;
          UPDATE T_SYS_WORKLIST SET COMPTIME=SYSDATE --待辦完成
            WHERE WORKLISTID IN (SELECT WORKLISTID FROM T_EC_SANYI S
                WHERE S.EC_ID_FK = varkeyId AND S.SANYI_UNIT = varUt_unitid);
          UPDATE T_EC_SANYI_UNIT SU --更新呈核履歷
            SET SIGN_HISTORY = varHistNum ||'. ' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 退回，意見： ' || varSign_comment || chr(10) || SIGN_HISTORY
            WHERE SU.SURVEY_ID_FK2=varSid AND SU.SANYI_UNIT2=varUt_unitid;

          --新增退回的待辦
          FOR s_field IN sanyi_taker(varkeyId, varUt_unitid) LOOP --各車系loop
            vartaker := s_field.undertaker;
            PA_SYS_WORKLIST.P_WorkList_Add(vartaker, '13-02-06', varTittle => '三義工廠-主管退回', varMatter => '三義工廠-'||varEcnno||'主管退回', ReturnVal => returnWkId);
            IF returnWkId <> '-1' THEN
              UPDATE T_EC_SANYI S SET S.WORKLISTID=returnWkId
              WHERE S.EC_ID_FK=varkeyId AND S.UNDERTAKER=vartaker AND S.SANYI_UNIT = varUt_unitid;
            END IF;
          END LOOP;


        WHEN 'A15chkOk' THEN
          IF varSign_List = varSign_now THEN
            UPDATE T_EC_SANYI S SET STATUS = 'A06-K' --確認-主管審核完成
              , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
              WHERE S.EC_ID_FK = varkeyId AND S.SANYI_UNIT = varUt_unitid;
            commit;
          ELSE
            UPDATE T_EC_SANYI S SET Sign_now = Sign_now + 1 --下一位主管
              , isalert = 'N'
              , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
              WHERE S.EC_ID_FK = varkeyId AND S.SANYI_UNIT = varUt_unitid;

            P_EC_SIGNMAN(varkeyId, varUt_unitid, varSign_now+1, varSendMan);--抓下一關主管id

            PA_SYS_WORKLIST.P_WorkList_Add(varSendMan, '13-02-06', varTittle => '三義工廠-主管待審核', varMatter => '請主管進行'||varEcnno||'調查內容審核!', ReturnVal => returnWkId);
            IF returnWkId <> '-1' THEN
              UPDATE T_EC_SANYI SS SET SS.WORKLISTID=returnWkId WHERE SS.EC_ID_FK = varkeyId AND SS.SANYI_UNIT =varUt_unitid; --IN varUt_unitid;
            END IF;
          END IF;

          UPDATE T_SYS_WORKLIST SET COMPTIME=SYSDATE --待辦完成
            WHERE WORKLISTID IN (SELECT WORKLISTID FROM T_EC_SANYI S WHERE S.EC_ID_FK = varkeyId AND S.SANYI_UNIT = varUt_unitid);

          varComment:=varSign_comment;
          IF varComment IS NULL THEN
             varComment:='簽核完成!';
          END IF;
          
          UPDATE T_EC_SANYI_UNIT SU --更新呈核履歷
            SET SIGN_HISTORY = varHistNum ||'. ' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 同意，意見： ' || varComment || chr(10) || SIGN_HISTORY
            WHERE SU.SURVEY_ID_FK2=varSid AND SU.SANYI_UNIT2=varUt_unitid;

        WHEN 'A11LOAD' THEN --待處理->處理中
          UPDATE T_EC_SURVEY_INFO S SET STATUS = varStatus WHERE SURVEY_ID = varkeyId;

        WHEN 'A11SendV' THEN --廠商填寫(廠商送出)
          --3.4.1.2 廠商執行回覆，發送E-MAIL通知、新增待辦給調查承辦，調查表狀態改為A06-D確認-承辦待處理。
          UPDATE T_EC_SURVEY_INFO
          SET STATUS = 'A06-D'  , isalert = 'N'
          WHERE SURVEY_ID = varkeyId;

          SELECT S.WORKLISTID INTO varWkid FROM T_EC_SURVEY_INFO S WHERE S.SURVEY_ID=varkeyId;

          PA_SYS_WORKLIST.P_WorkList_Complete(varWkid,returnWkId);

          varSendMan := varSurvey_taker ;--抓下一關為調查承辦
          PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                          '13-02-04',      --功能選單ID
                                           varEcnno || ' ' || varVendor || ' 廠商調查表請審核', --主旨
                                           varEcnno || ' ' || varVendor || ' 廠商調查表請審核', --內容
                                           returnWkId    --成功:WorkListID;  失敗:-1
                                         );

         UPDATE T_EC_SURVEY_INFO
          SET VENDOR_comment = comment2
              ,worklistid = returnWkId
              ,sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 呈送廠商調查表，意見：' || comment2 || chr(10) || sign_history
              ,comment2 = ''
          WHERE SURVEY_ID = varkeyId;


       WHEN 'A11SendY' THEN --廠商填寫(承辦同意)
         /* 3.4.2.3 依照審核者List(T_EC_SURVEY_INFO.Signoff_List)送至下一關卡進行審核，調查表狀態設為A06-G 確認-主管待處理。
         3.4.2.4 通知下一關卡：發送E-MAIL通知主管、新增主管待辦。
         3.4.2.5 將該承辦的待辦事項(記錄)完成。 */

          UPDATE T_EC_SURVEY_INFO s
          SET STATUS = 'A06-G'
              , isalert = 'N'
              ,taker_sign_date = sysdate
              ,sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 呈送廠商調查表，意見：' || comment2 || chr(10) || sign_history
              ,Sign_Now = decode(sign_leader,null,1,0)
              --,Sign_List = decode(sign_level,'科長',1,decode(sign_level,'科長,副理',2,decode(sign_level,'科長,副理,經理',3,0)))
              --SIGN_LIST分發就決定了，而且是抓參數表
              ,survey_vendor_udate = decode(s.overduereasondescription,null,null,sysdate)
              ,s.overduereasondescription = varOverDueReasonDescription
          WHERE SURVEY_ID = varkeyId;

          --5.1.6 將承辦的待辦完成，產生下一關(若Leader有值則送給Leader，若Leader為空則送給調查單位之科主管)的待辦。
          PA_SYS_WORKLIST.P_WorkList_Complete(varWkid,varRV);
          if varLeader is not null then
            varSendMan := varLeader;
          else
            --select f_sys_employinfo_getleaderbyse(varUt_unitid) into varSendMan from dual;
            select substr(a.depusrid,1,6) into varSendMan
            from t_sys_leaderlayer a where id = varUt_unitid;
          end if;
          PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                          '13-02-04',      --功能選單ID
                                           varEcnno || ' ' || varVendor || ' 廠商調查表請審核', --主旨
                                           varEcnno || ' ' || varVendor || ' 廠商調查表請審核', --內容
                                           newWorkListId    --成功:WorkListID;  失敗:-1
                                          );

          UPDATE T_EC_SURVEY_INFO
          SET comment2 = ''
              ,worklistid = newWorkListId
          WHERE SURVEY_ID = varkeyId;


       WHEN 'A11Agree' THEN --廠商回覆後YULON審核(主管同意)
        --更新簽核歷程t_ec_survey_info.sign_history
        UPDATE T_EC_SURVEY_INFO
        SET  sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna||' 同意廠商調查表，意見： '|| comment2 || chr(10) || sign_history        WHERE SURVEY_ID = varkeyId;

        IF varSign_Now = 1 THEN
          UPDATE T_EC_SURVEY_INFO
          SET DEPMGR_SIGN = to_char(sysdate,'yyyy/mm/dd') || ' ' || varName
          WHERE SURVEY_ID = varkeyId;
        END IF;
        IF varSign_Now = 2 THEN
          UPDATE T_EC_SURVEY_INFO
          SET SENIOR_SIGN = to_char(sysdate,'yyyy/mm/dd') || ' ' || varName
          WHERE SURVEY_ID = varkeyId;
        END IF;
        IF varSign_Now = 3 THEN
          UPDATE T_EC_SURVEY_INFO
          SET  GM_SIGN = to_char(sysdate,'yyyy/mm/dd') || ' ' || varName
          WHERE SURVEY_ID = varkeyId;
        END IF;
             
        PA_SYS_WORKLIST.P_WorkList_Complete(varWkid,varRV);

        if (varSign_List <> varSign_Now) then -- 5.2.3 若非最後一關卡(Sign_List <>Sign_Now），呈送下一關卡進行審核。
            --5.2.3.1  Sign_Now = Sign_Now + 1
            varSign_Now := varSign_Now+1;

            UPDATE T_EC_SURVEY_INFO
            SET  Sign_Now = varSign_Now
            WHERE SURVEY_ID = varkeyId ;

            --5.2.3.2  下一關卡人員為取調查科別所屬T_SYS_LEADERLAYER的第幾N個工號(N即為T_EC_SURVEY_INFO.Sign_Now）
            --科長:substr(depusrid,0,6),副理:substr(depusrid,8,6),經理:substr(depusrid,15,6)
            select substr(depusrid,decode(varSign_Now,1,0,decode(varSign_Now,2,8,15)),6) into varSendMan
            from T_SYS_LEADERLAYER where id = varUt_unitid;

            --5.2.6 新增下一關卡待辦
            PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                '13-02-04',      --功能選單ID
                                 varEcnno || ' ' || varVendor || ' 廠商調查表請審核', --主旨
                                 varEcnno || ' ' || varVendor || ' 廠商調查表請審核', --內容
                                 newWorkListId    --成功:WorkListID;  失敗:-1
                                );

            UPDATE T_EC_SURVEY_INFO
              SET comment2 = ''
                  ,worklistid = newWorkListId
                  , isalert = 'N'
            WHERE SURVEY_ID = varkeyId ;

        else --若為最後一關卡(Sign_List = Sign_Now）
            --20170522cyc: do reject for leader
            rows := 0;
            SELECT count(*) INTO rows FROM T_SYS_USERGROUP UG 
            WHERE UG.USERID=varUndertaker AND UG.GROUPID='PISGroup31'; --yntc leader
            IF rows = 0 THEN -- do it, not leader
              update t_ec_survey_info s
               set status = 'A06-K'   -- 3.4.2.3.1 調查表狀態設為A06-K 確認-主管審核完成 (登入者待辦完成)。
               ,survey_vendor_edate = sysdate --3.4.2.3.2 實際答覆日設為SYSDATE
              where s.survey_id = varkeyId;

              update t_ec_survey_info s
              set OverdueDays =  to_date(to_char(survey_vendor_edate,'yyyy/mm/dd'),'yyyy/mm/dd') -   to_date(to_char(survey_vendor_pdate,'yyyy/mm/dd'),'yyyy/mm/dd')
               -- 3.4.2.3.3 若實際答覆日(系統日)>預計答覆日，逾期天數設為實際答覆日-預計答覆日。
              where s.survey_id = varkeyId
              and survey_vendor_edate > survey_vendor_pdate ;

               --3.5.3 該ECN+科的所有調查狀態皆已 A06-K 確認-主管審核完成
              SELECT COUNT(*) INTO rows --該ECN+科的所有調查狀態  主管審核完成
                  FROM t_ec_survey_info S
              WHERE S.EC_ID ||S.DIST_UNIT IN ( SELECT EC_ID||DIST_UNIT FROM t_ec_survey_info where Survey_id = varkeyId)
               AND STATUS <> 'A06-K' AND STATUS <> 'A06-9'; --確認-主管審核完成 , 填單-資管科同意不須調查

              IF rows = 0 THEN
                --A11Agree(最後一張調查表時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A06-K 確認-主管審核完成，且實際答覆日<=預計答覆日, T_EC_SUM.status = \
                --P_EC_STATUS_CAL(varkeyId);
                UPDATE T_EC_SUM SET STATUS = 'A18-3',rdate = SYSDATE
                   , MODIFYER = varUndertaker, MODIFY_DATE = SYSDATE
                   WHERE EC_ID IN ( SELECT EC_ID FROM t_ec_survey_info where Survey_id = varkeyId)
                     AND REPORT_TYPE = 'S'
                     AND UNIT in (select S.MODIFYCONTENT from t_sys_glossary s where S.GLOSSARYTYPEID LIKE 'A05-%' AND  S.GLOSSARY2 = varUt_unitid )
                     AND TO_CHAR(sysdate,'YYYYMMDD') <= TO_CHAR(pdate,'YYYYMMDD');
                     
                --A11Agree(最後一張調查表時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A06-K 確認-主管審核完成，且實際答覆日＞預計答覆日, T_EC_SUM.status = A18-4
                UPDATE T_EC_SUM SET STATUS = 'A18-4',rdate = SYSDATE
                   , MODIFYER = varUndertaker, MODIFY_DATE = SYSDATE
                   WHERE EC_ID IN ( SELECT EC_ID FROM t_ec_survey_info where Survey_id = varkeyId)
                     AND REPORT_TYPE = 'S'
                     AND UNIT in (select S.MODIFYCONTENT from t_sys_glossary s where S.GLOSSARYTYPEID LIKE 'A05-%' AND  S.GLOSSARY2 = varUt_unitid )
                     AND TO_CHAR(sysdate,'YYYYMMDD') > TO_CHAR(pdate,'YYYYMMDD');
              END IF;

              /* 3.4.2.4 若此ECN所有調查表T_EC_SURVEY_INFO.STATUS狀態皆為A06-K：
                 3.4.2.4.1 該ECN所有調查單皆完成時，進入零件切換調查*/
              select count(*) into rows
              from t_ec_survey_info e where e.ec_id in
              (select s.ec_id from  t_ec_survey_info s
              where s.survey_id = varkeyId)
              and e.status <> 'A06-9'; --填單-資管科同意不須調查

              select count(*) into rows2
              from t_ec_survey_info e where e.ec_id in
              (select s.ec_id from t_ec_survey_info s
              where s.survey_id = varkeyId)
              and e.status <> 'A06-9' and e.status = 'A06-K';

              if rows = rows2 then
                select e.ec_id,e.title,e.pdm_models
                  into varEc_id,varTitle,varPdmModels
                from t_ec_info e
                join t_ec_survey_info s on  e.ec_id = s.ec_id
                where s.survey_id = varkeyId ;

                PA_EC_DIST.P_EC_ADD_CHG_INFO(varEc_id,varTitle,varPdmModels);
              end if;
            END IF;
        end if;


       WHEN 'A11Reject' THEN
          --廠商填寫(退回)
          --3.5.1 若狀態為A06-E 確認-承辦處理中時，承辦意見欄位必填，退回調查表給廠商，調查表狀態設為A06-C 廠商-重新處理(承辦退回)。(發送E-MAIL通知廠商、新增廠商待辦、承辦待辦完成)
          --3.5.2 若狀態為A06-I 確認-主管審核中時，主管意見欄位必填，退回調查表給承辦，調查表狀態設為A06-J 確認-主管退回承辦。(發送E-MAIL通知承辦、新增承辦待辦、主管待辦完成)
          IF varStatus = 'A06-E' THEN --承辦處理中A06-E -> 廠商-重新處理(承辦退回)A06-C
             varStatus2 := 'A06-C';
             varSendMan := substr(varVendor,0,4)||'2';
          ELSIF varStatus = 'A06-I' THEN  --確認-主管審核中A06-I -> 確認-主管退回承辦A06-J
             varStatus2 := 'A06-J';
             varSendMan := varSurvey_taker;
          END IF;

          IF varSendMan IS NOT NULL THEN
            --6-2. 更新簽核歷程t_ec_survey_info.sign_history
            UPDATE T_EC_SURVEY_INFO S SET STATUS = varStatus2, isalert = 'N'
                ,sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 退回廠商調查表，意見： ' || varSign_comment || chr(10) || sign_history
            WHERE SURVEY_ID = varkeyId;

            --6-3. 此關卡之待辦完成、新增下一關承辦待辦
            PA_SYS_WORKLIST.P_WorkList_Complete(varWkid,varRV);
            PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                             '13-02-04',      --功能選單ID
                                             varEcnno || ' ' || varVendor || ' 廠商調查表被退回，請重新調查', --主旨
                                             varEcnno || ' ' || varVendor || ' 廠商調查表被退回，請重新調查', --內容
                                             newWorkListId    --成功:WorkListID;  失敗:-1
                                            );

            UPDATE T_EC_SURVEY_INFO
            SET comment2 = ''
                ,worklistid = newWorkListId
            WHERE SURVEY_ID = varkeyId;
          END IF;
            
      WHEN 'A11_LoadSaveC' THEN
          UPDATE T_EC_SURVEY_INFO
          SET VENDOR_COMMENT = varSign_comment
          WHERE SURVEY_ID = varkeyId;

      WHEN 'A11_LoadSaveM' THEN
          UPDATE T_EC_SURVEY_INFO
          SET VENDOR_MEMO = varSign_comment
          WHERE SURVEY_ID = varkeyId;

        ELSE
             OutResult := 'ok';
      END CASE;

      --單次送出判斷
      IF (varStep = 'A15send' or varStep = 'A15notSelf') THEN
        UPDATE T_EC_SANYI SS SET STATUS = varStatus2
          , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
          , ss.sign_comment=''
          WHERE SS.EC_ID_FK = varkeyId AND SS.UNDERTAKER = varUndertaker;

        UPDATE T_SYS_WORKLIST SET COMPTIME=SYSDATE --待辦完成, 該承辦可能會有多筆待辦
          WHERE WORKLISTID IN (SELECT WORKLISTID FROM T_EC_SANYI SS WHERE SS.EC_ID_FK = varkeyId AND SS.UNDERTAKER = varUndertaker);

        UPDATE T_EC_SANYI_UNIT SU --更新呈核履歷
          SET SIGN_HISTORY = varHistNum ||'. ' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna || decode(varStep,'A15send',' 呈送簽核，意見：',' 非本組業務，意見：') || varComment || chr(10) || SIGN_HISTORY
         WHERE SU.SURVEY_ID_FK2=varSid AND SU.SANYI_UNIT2=varUt_unitid;

        rows:=0;
        rows2:=0;
        SELECT COUNT(*) INTO rows FROM T_EC_SANYI SS
        WHERE  SS.STATUS NOT IN ('A06-F','A06-L') --承辦完成, 非本組業務
           AND SS.EC_ID_FK = varkeyId AND SS.SANYI_UNIT = varUt_unitid;
          
        SELECT COUNT(*) INTO rows2 FROM T_EC_SANYI SS
        WHERE SS.STATUS = 'A06-F'  --承辦完成
          AND SS.EC_ID_FK = varkeyId AND SS.SANYI_UNIT = varUt_unitid;
          
        IF (  rows = 0   --該ECN+科之所有案件皆已為"承辦完成"或"非本組業務"
              AND rows2 > 0   --且該ECN+科有"承辦完成"的筆數
              AND (
                  (varStep = 'A15send' AND varStatus2 = 'A06-F')  --該ECN+科之最後一筆為"承辦完成"
                  or (varStep = 'A15notSelf' AND varStatus2 = 'A06-L') --該ECN+科之最後一筆為"非本組業務"
                  )
            ) THEN --有案件完成，進入主管審核, 送出才執行此
          varStatus2:='A06-G'; -- 確認-主管待處理
          UPDATE T_EC_SANYI SS SET STATUS = varStatus2
            , isalert = 'N'
            , Sign_Now = decode(sign_leader,null,1,0)
            , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
            WHERE SS.EC_ID_FK = varkeyId AND SS.SANYI_UNIT = varUt_unitid;

          if varLeader is not null then
            varSendMan := varLeader;
          else
            if varSign_Now is null then
              varSign_Now := 1;
            end if;
            P_EC_SIGNMAN(varkeyId, varUt_unitid, varSign_Now, varSendMan);--抓下一關主管id
          end if;

          PA_SYS_WORKLIST.P_WorkList_Add(varSendMan, '13-02-06', varTittle => '三義工廠-主管待審核', varMatter => '請主管進行'||varEcnno||'調查內容審核!', ReturnVal => returnWkId);
          IF returnWkId <> '-1' THEN
            UPDATE T_EC_SANYI SS SET SS.WORKLISTID=returnWkId WHERE SS.EC_ID_FK = varkeyId AND SS.SANYI_UNIT =varUt_unitid;
          END IF;
        END IF;
      END IF;

      commit;

      --判斷是否為最後一關
      IF (varStep = 'A15chkOk' or varStep = 'A15notSelf') THEN
          rows:=0;
          --3.5.3 該ECN所有三義工廠調查狀態皆已 A06-K 確認-主管審核完成 或為 A06-L非本組業務
          SELECT COUNT(*) INTO rows --所有三義工廠調查狀態  主管審核完成
              FROM T_EC_SANYI S
          WHERE S.EC_ID_FK = varkeyId  AND STATUS <> 'A06-K' AND STATUS <> 'A06-L'; --確認-主管審核完成
          
          IF rows=0 THEN --三義工廠各科調查完成，此調查單也完成
              UPDATE T_EC_SURVEY_INFO SI SET SI.STATUS='A06-K', SI.SURVEY_VENDOR_EDATE=SYSDATE
                , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
              WHERE SI.SURVEY_ID=varSid OR (SI.EC_ID = varkeyId AND SI.UT_UNITID='SANYI');

              --A15chkOk(最後一張調查表時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A06-K 確認-主管審核完成，且實際答覆日<=預計答覆日, T_EC_SUM.status = A18-3
              --P_EC_STATUS_CAL(varkeyId);
              UPDATE T_EC_SUM SET STATUS = 'A18-3',rdate = SYSDATE
                 , MODIFYER = varUndertaker, MODIFY_DATE = SYSDATE
                 WHERE EC_ID = varkeyId
                   AND REPORT_TYPE = 'S'
                   AND UNIT = 'S'
                   AND TO_CHAR(sysdate,'YYYYMMDD') <= TO_CHAR(pdate,'YYYYMMDD');

              --A11Agree(最後一張調查表時)呼叫A04-P_EC_STATUS_CAL(ec_id)，調查表狀態為A06-K 確認-主管審核完成，且實際答覆日＞預計答覆日, T_EC_SUM.status = A18-4
              UPDATE T_EC_SUM SET STATUS = 'A18-4',rdate = SYSDATE
                 , MODIFYER = varUndertaker, MODIFY_DATE = SYSDATE
                 WHERE EC_ID = varkeyId
                   AND REPORT_TYPE = 'S'
                   AND UNIT = 'S'
                   AND TO_CHAR(sysdate,'YYYYMMDD') > TO_CHAR(pdate,'YYYYMMDD');
                   
              rows:=0;
              SELECT COUNT(*) INTO rows FROM T_EC_SURVEY_INFO SI
              WHERE SI.STATUS<>'A06-K' AND SI.EC_ID = varkeyId;
              IF rows=0 THEN --所有調查單完成，進入零件切換調查 --與A04共用
                 PA_EC_DIST.P_EC_ADD_CHG_INFO(varkeyId, varTitle, varPdmModels);
              END IF;
          END IF;
      END IF;

      commit;

      --3.4.1 所有組別皆設定「非本組業務」時則退回資管科(同A06的退回)。
      IF (varStep = 'A15notSelf') THEN
        rows:=0;
        rows2:=0;
        SELECT COUNT(*) INTO rows FROM T_EC_SANYI SS
        WHERE NOT SS.STATUS IN ('A06-L') AND SS.EC_ID_FK = varkeyId; --非本組業務
          --AND SS.SANYI_UNIT = varUt_unitid
        SELECT COUNT(*) INTO rows2 FROM T_EC_SANYI SS
        WHERE SS.STATUS = 'A06-L' AND SS.EC_ID_FK = varkeyId; --非本組業務
          --AND SS.SANYI_UNIT = varUt_unitid;

        IF rows=0 AND rows2>0 THEN
          UPDATE T_EC_INFO E SET E.STATUS = 'A04-6' --廠商調查_退回
            , MODIFYER=varUndertaker, MODIFY_DATE=SYSDATE
            WHERE E.EC_ID = varkeyId;

          SELECT f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-2',2)) into varMail FROM DUAL; --資管科
          SELECT f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-9',2)) into varMail2 FROM DUAL; --ISC
          P_SYS_Mail_Add(varMail, varMail2, 'ESS三義工廠退回-皆為非本組業務!', '請承辦進行' ||varEcnno||' 廠商確認!','', 'Y', '', '', returnWkId);  --成功:MailID;  失敗:-1

          PA_SYS_WORKLIST.P_WorkList_Add(f_sys_glossary_getnamebyfield('A14-2',2), '13-02-08', varTittle => '三義工廠退回-皆為非本組業務!', varMatter => '請承辦進行' ||varEcnno||' 廠商確認!', ReturnVal => returnWkId);
          IF returnWkId <> '-1' THEN
            UPDATE T_EC_INFO E SET E.WORKLISTID=returnWkId WHERE E.EC_ID = varkeyId;
            UPDATE T_EC_SURVEY_INFO S SET S.SIGN_HISTORY='ESS三義工廠退回-皆為非本組業務!' WHERE S.EC_ID = varkeyId AND S.DIST_VENDOR='SANYI';
          END IF;

          -- 發送Email給資管窗口 CC資管主管
           --資管窗口
           select e.mailaddress,e.name into v_semail,v_semail_na
           from T_SYS_EMPLOYINFO e
           inner join T_SYS_GLOSSARY g on e.employno = g.glossary2
           where g.glossarytypeid = 'A14-2' and e.INSERVICE = 'Y';

            --資管主管
/*           select e.mailaddress into v_ccmail
           from T_SYS_EMPLOYINFO e
           where e.unitid in (
                 select distinct e.unitid
                 from T_SYS_EMPLOYINFO e
                 inner join T_SYS_GLOSSARY g on e.employno = g.glossary2
                 where g.glossarytypeid = 'A14-2' and e.INSERVICE = 'Y' )
           and INSERVICE = 'Y' AND POSITIONTYPE <> 11 ;*/

           v_title := 'ESS<退回通知>'|| varUt_unitna  ||'退回廠商或零件切換調查';
           v_body := v_semail_na ||' 先生/小姐 您好：<br>' || varUt_unitna || '退回設通單' || varEcnno ||'，請進入設變調查e化系統執行EC>>管理>>「分發廠商調整」功能。';
           VarContent := '<html><head></head><body><P>'|| v_body ||'</P></body></html>';

           p_sys_mail_add(v_semail,v_ccmail,v_title,VarContent,'','Y','','',VarResult);
           if VarResult = '-1' then
              rollback;
              return;
           end if;

        END IF;
      END IF;

     commit;

      OutResult := 'ok';

      EXCEPTION
         WHEN OTHERS THEN
            ROLLBACK;
            For Rec_MailAddress In Cur_MailAddress Loop
                  v_semail_na := v_semail_na || Rec_MailAddress.MailAddress || ',' ;
            End Loop;
            
            P_SYS_Mail_Add(v_semail_na,'','ESS P_EC_SurveyStatus_sdo ERROR',varStep||','||varkeyId||','||varUndertaker||','||SQLERRM,'','','','',VarResult);
            OutResult := SQLERRM;

  END P_EC_SurveyStatus_sdo;

  --A06零件切換SAVE
  PROCEDURE P_EC_PartsChgSurveySAVE(
        varkeyId        IN VARCHAR2, --ID
        varChg_date     IN VARCHAR2,
        varMemo         IN NVARCHAR2,
        varCOMMENT      IN NVARCHAR2,
        OutResult       OUT VARCHAR2
  ) IS
  BEGIN

       UPDATE T_EC_CHG_INFO S
          SET CHG_DATE = TO_DATE(varChg_date, 'YYYY/MM/DD'),
              CHG_MEMO = varMemo,
              COMMENT2 = varCOMMENT
       WHERE CHG_ID = varkeyId;

      /* --更新待辦事項
       UPDATE T_SYS_WORKLIST SET COMPTIME=SYSDATE
              WHERE COMPTIME IS NULL AND WORKLISTID IN (SELECT WORKLISTID FROM T_EC_CHG_INFO WHERE CHG_ID = varkeyId);
       */
       OutResult := 'ok';

       EXCEPTION
          WHEN OTHERS THEN
             dbms_output.put_line(sqlcode);
             dbms_output.put_line(sqlerrm);
             ROLLBACK;
             OutResult := SQLERRM;

  END P_EC_PartsChgSurveySAVE;


  --A11零件調查資訊SAVE
  PROCEDURE P_EC_vendorPartsSave(
        varkeyId                 IN VARCHAR2, --ID
        varOLD_PART_STOCK        IN VARCHAR2,
        varOLD_PART_NUMBER       IN VARCHAR2,
        varOLD_PART_PD_CNT       IN VARCHAR2,
        varOLD_PART_HALF_CNT     IN VARCHAR2,
        varNEW_PART_MODEL        IN VARCHAR2,
        varNEW_PART_CHK          IN VARCHAR2,
        varNEW_PART_CLIP         IN VARCHAR2,
        varNEW_PART_PRICE        IN VARCHAR2,
        varNEW_PART_CHK_COST     IN VARCHAR2,
        varNEW_PART_MODEL_COST   IN VARCHAR2,
        varNEW_PART_CLIP_COST    IN VARCHAR2,
        varSURVEY_MEMO           IN VARCHAR2,
        varRUN_MODEL_DATE        IN VARCHAR2,
        varRUN_SAMPLE_DATE       IN VARCHAR2,
        varRUN_PD_DATE           IN VARCHAR2,
        OutResult                OUT VARCHAR2
  ) IS
  BEGIN

       UPDATE T_EC_SURVEY_PARTS SP
          SET OLD_PART_STOCK = TO_DATE(varOLD_PART_STOCK, 'YYYY/MM/DD')
              ,OLD_PART_NUMBER = varOLD_PART_NUMBER
              ,OLD_PART_PD_CNT = varOLD_PART_PD_CNT
              ,OLD_PART_HALF_CNT = varOLD_PART_HALF_CNT
              ,NEW_PART_MODEL = varNEW_PART_MODEL
              ,NEW_PART_CHK = varNEW_PART_CHK
              ,NEW_PART_CLIP = varNEW_PART_CLIP
              ,NEW_PART_PRICE = varNEW_PART_PRICE
              ,NEW_PART_CHK_COST = varNEW_PART_CHK_COST
              ,NEW_PART_MODEL_COST = varNEW_PART_MODEL_COST
              ,NEW_PART_CLIP_COST = varNEW_PART_CLIP_COST
              ,SURVEY_MEMO = varSURVEY_MEMO
              ,RUN_MODEL_DATE = TO_DATE(varRUN_MODEL_DATE, 'YYYY/MM/DD')
              ,RUN_SAMPLE_DATE = TO_DATE(varRUN_SAMPLE_DATE, 'YYYY/MM/DD')
              ,RUN_PD_DATE = TO_DATE(varRUN_PD_DATE, 'YYYY/MM/DD')
              ,SP.MODIFY_DATE=SYSDATE, SP.MODIFYER='vendor'
       WHERE SP.SURVEY_PARTS_ID = varkeyId;

       EXCEPTION
          WHEN OTHERS THEN
             dbms_output.put_line(sqlcode);
             dbms_output.put_line(sqlerrm);
             ROLLBACK;
             OutResult := SQLERRM;

  END P_EC_vendorPartsSave;

  --A15三義工廠調查資訊SAVE
  PROCEDURE P_EC_SanyiSAVE(
      varKey       In VARCHAR2,       --- survey_part_id
      varPD_CNT    In VARCHAR2,       --- 庫存
      varUseDate   In VARCHAR2,       --- 採用日期
      varCost      In VARCHAR2,       --- 成本變動
      varMode      In VARCHAR2,       --- 模具變動
      varMemo      In NVARCHAR2,       --- 調查的備註
      varComment   In NVARCHAR2,    --- 意見說明
      OutResult    OUT VARCHAR2
  ) IS
      VarResult    VARCHAR2(50);
      varMailAddress  varchar2(200);
  
  Cursor Cur_MailAddress Is
    Select b.mailAddress From T_SYS_EmployInfo b,T_SYS_UserAccount a
      Where b.EmployNo = a.UserID And a.GroupID = 'PISGroup1';
      
  BEGIN
       UPDATE T_EC_SURVEY_PARTS --零件調查更新
          SET OLD_PART_PD_CNT = varPD_CNT
              ,RUN_PD_DATE = TO_DATE(varUseDate, 'YYYY/MM/DD')
              ,NEW_PART_PRICE = varCost
              ,NEW_PART_MODEL_COST = varMode
              ,SURVEY_MEMO = varMemo
       WHERE SURVEY_PARTS_ID = varKey;

       UPDATE T_EC_SANYI --說明意見更新
         SET SIGN_COMMENT = varComment
       WHERE SS_ID IN (SELECT SS_ID_FK FROM T_EC_SURVEY_PARTS WHERE SURVEY_PARTS_ID=varKey);

       OutResult := 'ok';

       EXCEPTION
          WHEN OTHERS THEN
             dbms_output.put_line(sqlcode);
             dbms_output.put_line(sqlerrm);
             ROLLBACK;
             For Rec_MailAddress In Cur_MailAddress Loop
                varMailAddress := varMailAddress || Rec_MailAddress.MailAddress || ',' ;
             End Loop;
             P_SYS_Mail_Add(varMailAddress,'','ESS P_EC_SanyiSAVE ERROR','varKey='||varKey||','||SQLERRM,'','','','',VarResult);
             OutResult := SQLERRM;

  END P_EC_SanyiSAVE;

  PROCEDURE P_EC_VendorParts( --廠商調查-零件清單
      varStep        IN VARCHAR2
     ,varSid         IN VARCHAR2  -- survey_id
     ,varTaker       IN VARCHAR2
     ,varRole        IN VARCHAR2 --角色
     ,ReturnValues   OUT SYS_REFCURSOR
     ,OutRecordCount OUT VARCHAR2 --?記錄數
  ) IS
     varSql     VARCHAR2(8000);
     varOrderby VARCHAR2(500);
     varSubSql      VARCHAR2(1000);
     VarCountSql    VARCHAR2(8000);
     VarCount       int;
  BEGIN
      -- SS_ID_FK<>0是三義工廠的調查零件，只抓取為0者
      varSql := 'SELECT SP.PL_ID
        , E.ECNNO, PL.PARTNO, PL.PARTNAME, E.PDM_MODELS
        , S.DIST_VENDOR as vendorID
        , (select SUPPLIERNAME from T_ANP_SUPPLIER where SUPPLIERCODE=S.DIST_VENDOR AND ROWNUM<=1) vendorNA
        , S.UT_UNITID, (SELECT UNITNA FROM T_SYS_EMPLOYINFO EMP WHERE EMP.UNITID=S.UT_UNITID AND ROWNUM<=1) UT_UNITID_NA
        , S.SURVEY_TAKER, (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=S.SURVEY_TAKER) undertakeNA
        , OLD_PART_STOCK,OLD_PART_NUMBER,OLD_PART_PD_CNT,OLD_PART_HALF_CNT
        ,NEW_PART_MODEL,NEW_PART_CHK,NEW_PART_CLIP
        ,NEW_PART_PRICE,NEW_PART_MODEL_COST,NEW_PART_CHK_COST,NEW_PART_CLIP_COST
        ,RUN_MODEL_DATE,RUN_SAMPLE_DATE,RUN_PD_DATE
        ,DWGNO, DWGVER, FORMAL_PN
        ,case when LENGTH(PL.FORMAL_PN) <> 11 OR PL.FORMAL_PN IS NULL then
          ''-'' else
           (select dwgver2 from (
               select a.* from (
                 SELECT P2.DWGNO||'', ''||P2.DWGVER dwgver2, P2.PL_ID pid
                   FROM T_EC_PL_INFO P2 WHERE P2.PARTNO=FORMAL_PN
               ) a order by pid desc
            ) where rownum<=1)
            end as opart_dwg_ver
        , SP.SURVEY_MEMO, SP.survey_parts_id
        , S.STATUS, (select substr(GLOSSARY1,4) from T_SYS_GLOSSARY where GLOSSARYTYPEID=S.status) statusNA
        FROM T_EC_INFO E INNER JOIN T_EC_SURVEY_INFO S ON E.EC_ID=S.EC_ID
        LEFT JOIN T_EC_SURVEY_PARTS SP ON SP.SURVEY_ID=S.SURVEY_ID
        LEFT JOIN T_EC_PL_INFO PL ON PL.PL_ID=SP.PL_ID
        WHERE SP.SS_ID_FK=0 ';

      varSubSql := ' ';
      IF varSid IS NOT NULL THEN
          varSubSql := varSubSql || ' AND S.SURVEY_ID = ' || varSid ;
      END IF;
      IF varRole IS NOT NULL THEN
         VarCount:=0;
      END IF;
      IF varStep IS NOT NULL THEN
         VarCount:=0;
      END IF;
      IF varTaker IS NOT NULL THEN
         VarCount:=0;
      END IF;

      varOrderby := ' ORDER BY PL.PARTNO ASC';

      -- 取記錄數
      varSql := 'SELECT rownum as no, a.* FROM ('||varSql||varSubSql||varOrderby||') a';
      VarCountSql := 'select count(*) from (' || varSql || ')';
      EXECUTE IMMEDIATE VarCountSql  INTO VarCount;
      OutRecordCount := TO_CHAR(VarCount);

      OPEN ReturnValues FOR varSql;
  EXCEPTION
     WHEN OTHERS THEN
        OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' NAME FROM dual;
  END P_EC_VendorParts;

  /* A15,A09,A10,A11 附件操作
  * 取得 附件列表
  * @author cyc
  */
  PROCEDURE P_EC_FILE_LIST(
       varFileId       IN     VARCHAR2,         -- 檔案 ID
       varKeyId        IN     VARCHAR2,         -- ec_id或survey_id
       varType         IN     VARCHAR2,         -- pdm,yntc,vendor
       returnValues       OUT SYS_REFCURSOR     --?記錄數
  )IS
       varSql          VARCHAR2 (2000);
       varTable        VARCHAR2 (100);
       varSelColumn    VARCHAR2 (100);
       varWhColumn     VARCHAR2 (100);
  BEGIN
       IF varFileId Is Not Null THEN
            varSql := 'SELECT F.ATTACHID, F.ATTACH, F.ATTACHPATH FROM T_SYS_ATTACH F
                   WHERE F.ATTACHID = ' || varFileId || ' ORDER BY F.ATTACHID ';
       ELSE
            CASE varType
               WHEN 'pdm_all' THEN --ec電子檔+附件
                    varTable:='T_EC_INFO';
                    varSelColumn:='PDM_ECFILEID,PDM_ATTACHID';
                    varWhColumn:='EC_ID';
               WHEN 'pdm_ec' THEN --ec電子檔
                    varTable:='T_EC_INFO';
                    varSelColumn:='PDM_ECFILEID';
                    varWhColumn:='EC_ID';
               WHEN 'pdm_att' THEN --附件
                    varTable:='T_EC_INFO';
                    varSelColumn:='PDM_ATTACHID';
                    varWhColumn:='EC_ID';
               WHEN 'yntc' THEN
                    varTable:='T_EC_SURVEY_INFO';
                    varSelColumn:='YN_ATTACHID';
                    varWhColumn:='SURVEY_ID';
               WHEN 'vendor' THEN
                    varTable:='T_EC_SURVEY_INFO';
                    varSelColumn:='VENDOR_ATTACHID';
                    varWhColumn:='SURVEY_ID';
            END CASE;

            varSql := 'SELECT F.ATTACHID , F.ATTACH , F.ATTACHPATH FROM T_SYS_ATTACH F
                   WHERE F.ATTACHID IN (SELECT ENGINEID FROM TABLE(SELECT F_PUB_SPLIT('||varSelColumn||') FROM '||varTable||' WHERE '||varWhColumn||' = ' || varKeyId || '))
                   ORDER BY F.ATTACHID ASC';
       END IF;

       OPEN ReturnValues FOR varSql;
  END P_EC_FILE_LIST;

  --抓取下一關的簽核主管
  PROCEDURE P_EC_SIGNMAN(
     varkeyId        IN VARCHAR2,
     varUt_unitid    IN VARCHAR2,
     varSign_now     IN VARCHAR2,
     varSendMan       OUT VARCHAR2
  ) IS
     --varSendMan VARCHAR2 (100);
  BEGIN

    select ID INTO varSendMan from --動態抓取下一關簽核的主管ID
    ( SELECT DISTINCT * FROM (
        SELECT ROWNUM AS ROWNUM1, TO_CHAR(ENGINEID) AS ID FROM TABLE(SELECT F_PUB_SPLIT(L.DEPUSRID) FROM T_SYS_LEADERLAYER L WHERE L.ID=varUt_unitid)
        UNION ALL
        SELECT ROWNUM AS ROWNUM1, TO_CHAR(L.EMPLOYNO) AS ID FROM T_SYS_LEADERINFO L WHERE L.LEADDEPARTID=varUt_unitid
      ) ORDER BY ROWNUM1 ASC
    ) a
    INNER JOIN
    (SELECT ROWNUM as ROWNUM2, ENGINEID AS NAME FROM TABLE(SELECT F_PUB_SPLIT('科長,副理,經理') FROM DUAL)) b
    ON a.ROWNUM1=b.ROWNUM2
    INNER JOIN
    (SELECT * FROM
      (SELECT ROWNUM AS ROWNUM1, ENGINEID AS NAME2 FROM TABLE(SELECT F_PUB_SPLIT(S.SIGN_LEVEL) FROM T_EC_SANYI S WHERE S.EC_ID_FK=varkeyId AND S.SANYI_UNIT=varUt_unitid AND ROWNUM<=1))
      WHERE ROWNUM1=varSign_now
    ) ON NAME=NAME2;

    IF varSendMan IS NULL THEN
       varSendMan := 'xxx';
    END IF;

  END P_EC_SIGNMAN;

PROCEDURE P_EC_ChgTakerGetUnitFlag( --重新指派承辦取得查詢科別所屬的FLAG--> Y、P: 調查單 / S:三義工廠 / C:零件切換
     varQuSection      IN VARCHAR2, --查詢科別
     varFlag           OUT VARCHAR2 --FLAG--> Y、P: 調查單 / S:三義工廠 / C:零件切換
  ) IS

  BEGIN
      select flag into varFlag
       from (
                   SELECT distinct '1' as orderby, g.GLOSSARY2 id, e.UNITNA label, e.DEPARTMENTID , e.unitid, g.modifycontent as flag
                     FROM T_SYS_GLOSSARY g inner join T_SYS_EMPLOYINFO e on g.GLOSSARY2 = e.UNITID
                    WHERE g.GLOSSARYTYPEID IN ('A05-1', 'A05-2') --零技, PEO
                   union all
                   SELECT distinct '3' as orderby, g.GLOSSARY2 id, e.UNITNA label, e.DEPARTMENTID , e.unitid, g1.modifycontent as flag
                     FROM T_SYS_GLOSSARY g inner join T_SYS_EMPLOYINFO e on g.GLOSSARY2 = e.UNITID
                     join T_SYS_GLOSSARY g1 on e.DEPARTMENTID = g1.GLOSSARY2
                        WHERE  g.GLOSSARYTYPEID LIKE 'A02%' --SANYI調查單位
                        and g1.GLOSSARYTYPEID = 'A05-3'
                   union all
                   SELECT distinct '2' as orderby, g.GLOSSARY2 id, e.UNITNA label, e.DEPARTMENTID , e.unitid, N'C' as flag
                     FROM T_SYS_GLOSSARY g inner join T_SYS_EMPLOYINFO e on g.GLOSSARY2 = e.UNITID
                         WHERE g.GLOSSARYTYPEID LIKE 'A10%' --零件切換調查單位
                  ) a
      where  a.id = varQuSection;
  END P_EC_ChgTakerGetUnitFlag;

END PA_EC_MANAGE;
