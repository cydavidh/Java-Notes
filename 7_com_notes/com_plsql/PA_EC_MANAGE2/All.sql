CREATE OR REPLACE PACKAGE BODY "PA_EC_MANAGE2" AS

   PROCEDURE P_EC_SurveyLIST
   (
     varPageSize    IN VARCHAR2, --每頁數量
     varPageNO      IN VARCHAR2, --當前頁
     varstep        IN VARCHAR2,
     varecn         IN VARCHAR2, --ECN CO
     varsurvey_id   IN VARCHAR2, --Survey ID
     varcar         IN VARCHAR2, --車型
     varSection     IN VARCHAR2, --發行科別ID
     varUT_UNITID   IN VARCHAR2, --調查科別ID
     varUndertake   IN VARCHAR2, --調查承辦ID(暫不用)
     varuserid      IN VARCHAR2, --登入者
     varRole        IN VARCHAR2, --角色:-1(科長以下),0(科長),1(科長以上),9(admin)
     ReturnValues   OUT SYS_REFCURSOR,
     OutRecordCount OUT VARCHAR2 --?記錄數
   ) IS
      -- Sql
      varSql     VARCHAR2(4000);
      varSubSql  VARCHAR(1000);
      varOrderby VARCHAR(500);
      -- Page
      VarCountSql VARCHAR2(4000);
      VarCount    INT;
      VarMinRowNO INT;
      VarMaxRowNO INT;
   BEGIN

      varSql := ' SELECT DECODE(S.DIST_UNIT,''Y'',''零技科'',''P'',''PEO'',''S'',''三義工廠'') distUnitNA
        , S.SURVEY_TAKER AS undertakeID
        ,(SELECT P.NAME FROM T_SYS_EMPLOYINFO P WHERE P.EMPLOYNO=S.SURVEY_TAKER) undertakeNA
        ,(SELECT UNITNA FROM T_SYS_EMPLOYINFO EMP WHERE EMP.UNITID=S.UT_UNITID AND ROWNUM<=1) utUnitNA
        , E.DESIGNER, E.DES_UNITID as desGrp
        , (SELECT P2.name FROM T_SYS_EMPLOYINFO P2 WHERE P2.EMPLOYNO=E.designer) designerNA
        , (SELECT UNITNA FROM T_SYS_EMPLOYINFO EMP WHERE EMP.UNITID=E.DES_UNITID AND ROWNUM<=1) desGrpNA
        , S.DIST_VENDOR as vendorID
        , (SELECT V.SUPPLIERCODE || ''  '' || V.SUPPLIERNAME FROM T_ANP_SUPPLIER V WHERE V.SUPPLIERCODE=S.DIST_VENDOR AND ROWNUM<=1) vendorNA
        , TO_CHAR(E.released_date,''YYYY/MM/DD'') as releasedate
        , (select GLOSSARY1 from T_SYS_GLOSSARY where GLOSSARYTYPEID=S.status) as statusNA
        , (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=s.sign_leader) as sign_leaderNA
        , S.SURVEY_ID AS surveyID, E.ECNNO, E.PDM_MODELS, S.UT_UNITID, s.survey_title as title, S.status
        , case when s.status in (''A06-1'',''A06-2'',''A06-6'') then
         decode(s.COMMENT2,null,''呈請同意'',s.COMMENT2) ELSE decode(s.COMMENT2,null,'''',s.COMMENT2) end  as COMMENT2
        , s.RETURN_FLAG, s.sign_leader, s.sign_level
        , decode(e.adpt,''A09-G'',e.ADPT_OTHER_DATE,(select GLOSSARY1 from T_SYS_GLOSSARY where GLOSSARYTYPEID= e.adpt)) as adptNA
        , s.cd_cnt, e.dwg_cnt, s.content2, s.sign_history, s.parts_flag, s.YN_ATTACHID, s.VENDOR_ATTACHID
        ,(case when 1=1 then (select attachpath from t_sys_attach where t_sys_attach.attachid = s.YN_ATTACHID)end) as attachpath_Y
        ,(case when 1=1 then (select attach from t_sys_attach where t_sys_attach.attachid = s.YN_ATTACHID)end) as attachname_Y
        ,(case when 1=1 then (select attachpath from t_sys_attach where t_sys_attach.attachid = s.VENDOR_ATTACHID)end) as attachpath_V
        ,(case when 1=1 then (select attach from t_sys_attach where t_sys_attach.attachid = s.VENDOR_ATTACHID)end) as attachname_V
        , E.PDM_ECFILEID , E.PDM_ATTACHID
        ,(case when 1=1 then (select attachpath from t_sys_attach where t_sys_attach.attachid = E.PDM_ATTACHID)end) as attachpath_P
        ,(case when 1=1 then (select attach from t_sys_attach where t_sys_attach.attachid = E.PDM_ATTACHID)end) as attachname_P
      FROM T_EC_INFO E INNER JOIN T_EC_SURVEY_INFO S on S.EC_ID=E.EC_ID
      WHERE 1=1 ';


      CASE varstep
         WHEN 'A09LIST' THEN
            varSql := varSql || ' and S.DIST_UNIT <> ''S'' ';
            CASE
              WHEN varRole = '-1' THEN -- -1(科長以下)
                select count(*) into varCount --判斷是否為LEADER
                from T_SYS_USERGROUP
                where groupid in (select groupid from T_SYS_GROUP where groupname = 'YNTC Leader')
                and userid = varuserid ;

                IF varCount = 0 THEN --不是LEADER
                   varSubSql := ' AND S.STATUS IN (''A06-1'',''A06-2'',''A06-6'') ';
                   varSubSql := varSubSql || ' AND S.SURVEY_TAKER = ''' || varuserid || ''' ';
                ELSE   --是LEADER
                   varSubSql := ' AND ( ( S.STATUS IN  (''A06-1'',''A06-2'',''A06-6'') ';
                   varSubSql := varSubSql || ' AND S.SURVEY_TAKER = ''' || varuserid || ''') or ( ';
                   varSubSql := varSubSql || ' S.STATUS = ''A06-5'' ';
                   varSubSql := varSubSql || ' AND S.Sign_Now = ''0'' ';
                   varSubSql := varSubSql || ' AND S.Sign_Leader = ''' || varuserid || ''') )';
                END IF;

              WHEN varRole = '0' THEN --varRole = 0(科長), Sign_Now = 1(Sign_Level簽核層級第1個),
                varSubSql := ' AND S.STATUS = ''A06-5'' ';
                varSubSql := varSubSql || ' AND S.Sign_Now = ''1''  ';
                varSubSql := varSubSql || ' AND S.UT_UNITID = ''' || varUT_UNITID || '''';

              WHEN varRole = '1' THEN --varRole = 1(科長以上), Sign_Now = 2(Sign_Level簽核層級第二個),Sign_Now = 3(Signoff_Level簽核層級第三個)
                varSubSql := ' AND S.STATUS = ''A06-5'' ';
                varSubSql := varSubSql || ' AND (( S.Sign_Now in (''1'', ''2'') AND S.UT_UNITID in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || '%''
                and depusrid not like ''%' || varuserid || ''' )) or ( S.Sign_Now = ''3'' AND S.UT_UNITID in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || ''')))';

              WHEN varRole = '9' THEN --varRole = 9(admin)
                varSubSql :=  ' AND S.STATUS IN (''A06-1'',''A06-2'',''A06-6'',''A06-5'') ';

            END CASE;

            varSql := varSql || varSubSql;
            varOrderby := ' ORDER BY releasedate ASC ';

         WHEN 'A09LOAD' THEN
            varSql := varSql || ' AND s.survey_id = ' || varsurvey_id;

         WHEN 'A11LOAD' THEN --cyc20170313:廠商檔案上傳用到.
            varSql := varSql || ' AND s.survey_id = ' || varsurvey_id;

         ELSE
            OPEN ReturnValues FOR SELECT 'NA' id, 'NA' NAME FROM dual;

      END CASE;

      IF varecn IS NOT NULL THEN
         varSql := varSql || ' AND E.ECNNO LIKE UPPER(''%' || varecn || '%'') ';
      END IF;
      IF varcar IS NOT NULL THEN
         varSql := varSql || ' AND E.PDM_MODELS LIKE UPPER(''%' || varcar || '%'') ';
      END IF;

      IF varSection IS NOT NULL THEN
         varSql := varSql || ' AND E.DES_UNITID LIKE UPPER(''' || varSection || '%'') ';
      END IF;
      /*
      IF varuserid IS NOT NULL THEN
         varSql := varSql || ' AND S.SURVEY_TAKER LIKE UPPER(''' || varuserid || '%'') ';
      END IF;
      IF varuserid IS NOT NULL THEN
         varSql := varSql || ' AND S.SURVEY_TAKER = (''' || varuserid || ''') ';
      END IF;
*/
      -- 取記錄數
      VarCountSql := 'select count(*) from (' || varSql || ')';
      EXECUTE IMMEDIATE VarCountSql  INTO VarCount;
      OutRecordCount := TO_CHAR(VarCount);

      --執行分頁查詢
      -- XX當每頁筆數大於 0 時, 才做分頁, 不大於0為匯出(Export)用
      VarMaxRowNO := TO_NUMBER(varPageSize) * TO_NUMBER(varPageNO);
      VarMinRowNO := VarMaxRowNO - TO_NUMBER(varPageSize) + 1;
      IF varPageSize > '0' THEN
         VarSql := 'SELECT to_number('||varPageSize||') * (to_number('||varPageNO||')-1)+rownum as no,B.*
            FROM (
                   SELECT A.*, rownum rn
                   FROM  (' || VarSql || varOrderby || ') A
                   WHERE rownum <= ' || TO_CHAR(VarMaxRowNO) || ') B
             WHERE rn >= ' || TO_CHAR(VarMinRowNO);
      END IF;

      OPEN ReturnValues FOR varSql;

   EXCEPTION
      WHEN OTHERS THEN
         OPEN ReturnValues FOR SELECT 'ERR' id, 'ERR' NAME FROM dual;
   END;

 -- 更新各階段的status
 PROCEDURE P_EC_SurveyStatus_sdo(
        varStep       IN NVARCHAR2,
        varkeyId      IN NVARCHAR2, --ID
        varStatus     IN NVARCHAR2, --New Status
        varUndertaker IN NVARCHAR2,
        OutResult     OUT VARCHAR2
    ) IS
       varName VARCHAR2(200);
       varPositionna VARCHAR2(200);
       varHistNum varchar(3);
       varWkid  VARCHAR2(200);
       varEcnno   VARCHAR2(20);
       varVendor VARCHAR2(20);
       varLeader VARCHAR2(20);
       varUt_unitid    VARCHAR2(10);
       varSurvey_taker VARCHAR2(20);
       varReturn_flag  char(1);
       varReturn_flag_msg NVARCHAR2(200);
       varSign_List char(1);
       varSign_now char(1);
       varRV  CHAR(1);
       varSendMan  VARCHAR2(20);
       newWorkListId  VARCHAR2(200);
       varDays      int;
       varUt_unitna  VARCHAR2(30);
       v_semail       varchar2(100);  --收件者
       v_semail_na    varchar2(100);  --收件者姓名
       v_ccmail       varchar2(500);  --副本
       v_title        varchar2(100);  --主旨
       v_body         varchar2(30000);  --內容1
       VarContent     varchar2(32767);  --內容
       VarResult      varchar2(10);

    BEGIN
      if (varStep = 'A09Send' or varStep = 'A09Agree' or varStep = 'A09Reject' ) then
        --取得簽核歷程用之姓名及職稱
        select e.name,e.positionna
        into varName,varPositionna
        from t_sys_employinfo e where e.employno = varUndertaker;

        --取得簽核歷程用之流水號
        select distinct to_char(decode(s.sign_history, null, 1, substr(s.sign_history,0,instr(s.sign_history,'.')-1)+1)),s.worklistid,
            i.ecnno,s.dist_vendor|| ' ' || sp.suppliername,s.sign_leader,s.ut_unitid,e.unitna,s.survey_taker,s.return_flag,s.Sign_List,s.Sign_now
        into varHistNum,varWkid,varEcnno,varVendor,varLeader,varUt_unitid,varUt_unitna,varSurvey_taker,varReturn_flag,varSign_List,varSign_now
        from t_ec_survey_info s
        join t_ec_info i on s.ec_id = i.ec_id
        join t_anp_supplier sp on s.dist_vendor = sp.suppliercode
        join t_sys_employinfo e on s.ut_unitid = e.unitid
        where s.survey_id = varkeyId;
      end if;

      CASE varStep
        WHEN 'A09LOAD' THEN  --設通調查表填寫:將調查單狀態(t_ec_survey_info.status)由A06-1承辦未接收 改為 A06-2承辦處理。
          UPDATE T_EC_SURVEY_INFO
          SET STATUS = 'A06-2'
          WHERE SURVEY_ID = varkeyId;

        WHEN 'A09PARTSLIST' THEN  --設通調查表-設變部品清單:將[設變部品清單閱讀狀態](t_ec_survey_info.parts_flag) 改為"Y"
          UPDATE T_EC_SURVEY_INFO
          SET parts_flag = 'Y'
          WHERE SURVEY_ID = varkeyId;

        WHEN 'A09Send' THEN --設通調查表填寫(呈核簽核)
          --5.1.2  將調查表的狀態改為「A06-5填單-主管審核」
          --5.1.3  更新承辦完成日t_ec_survey_info.taker_sign_date、簽核歷程t_ec_survey_info.sign_history。
          --5.1.4 若LEADER有值，Sign_Now=0；若LEADER無值則Sign_Now=1
          --5.1.5 Sign_List依user所選的簽核主管層級(sign_level)來決定：科長為1、科長,副理為2、科長,副理,經理為3
          IF varReturn_flag = 'Y' THEN
            varReturn_flag_msg:=',重啟流程至資管科';
          ELSE
            varReturn_flag_msg:='.';
          END IF;

          UPDATE T_EC_SURVEY_INFO
          SET STATUS = 'A06-5'
              , isalert = 'N'
              ,taker_sign_date = sysdate
              ,sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 呈送簽核，意見：' || comment2 ||varReturn_flag_msg|| chr(10) || sign_history
              ,Sign_Now = decode(sign_leader,null,1,0)
              ,Sign_List = decode(sign_level,'科長',1,decode(sign_level,'科長,副理',2,decode(sign_level,'科長,副理,經理',3,0)))
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
                                          '13-02-01',      --功能選單ID
                                           varEcnno || ' ' || varVendor || ' 設通調查表請審核', --主旨
                                           varEcnno || ' ' || varVendor || ' 設通調查表請審核', --內容
                                           newWorkListId    --成功:WorkListID;  失敗:-1
                                          );

          UPDATE T_EC_SURVEY_INFO
          SET comment2 = ''
              ,worklistid = newWorkListId
          WHERE SURVEY_ID = varkeyId;

       WHEN 'A09Agree' THEN   --設通調查表填寫(同意)
        --5.2.2 更新簽核歷程t_ec_survey_info.sign_history
        UPDATE T_EC_SURVEY_INFO
        SET  sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 同意，意見： ' || comment2 || chr(10) || sign_history
        WHERE SURVEY_ID = varkeyId ;

        --5.2.5 此關卡之待辦完成
        PA_SYS_WORKLIST.P_WorkList_Complete(varWkid,varRV);

        if (varSign_List <> varSign_Now) then -- 5.2.3 若非最後一關卡(Sign_List <>Sign_Now），呈送下一關卡進行審核。
             --5.2.3.1  Sign_Now = Sign_Now + 1
             varSign_Now := varSign_Now+1;

             UPDATE T_EC_SURVEY_INFO
             SET  Sign_Now = varSign_Now
              , isalert = 'N'
             WHERE SURVEY_ID = varkeyId ;

             --5.2.3.2  下一關卡人員為取調查科別所屬T_SYS_LEADERLAYER的第幾N個工號(N即為T_EC_SURVEY_INFO.Sign_Now）
             --科長:substr(depusrid,0,6),副理:substr(depusrid,8,6),經理:substr(depusrid,15,6)
             select substr(depusrid,decode(varSign_Now,1,0,decode(varSign_Now,2,8,15)),6)
             into varSendMan
             from T_SYS_LEADERLAYER
             where id = varUt_unitid;

             --5.2.6 新增下一關卡待辦
             PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                '13-02-01',      --功能選單ID
                                 varEcnno || ' ' || varVendor || ' 設通調查表請審核', --主旨
                                 varEcnno || ' ' || varVendor || ' 設通調查表請審核', --內容
                                 newWorkListId    --成功:WorkListID;  失敗:-1
                                );


            UPDATE T_EC_SURVEY_INFO
              SET comment2 = ''
                  ,worklistid = newWorkListId
            WHERE SURVEY_ID = varkeyId ;

        else --5.2.4 若為最後一關卡(Sign_List = Sign_Now）
          --5.2.4.1 若"重啟流程"為"否"時，將調查單狀態(t_ec_survey_info.status) 改為 「A06-A 廠商-待處理」，送交廠商進行調查。
          --5.2.4.2 若"重啟流程"為"是"時，經承辦確認設通單內容不符/圖面缺/不須廠商調查，主管"同意"後退回資管科進行轉下游會辦/重新分發處理
          --5.2.4.3  更新 廠商回覆逾期日(survey_vendor_date_expaired) 為系統日＋７(參數A08-3, GLOSSARY4)
          select to_number(GLOSSARY4) into varDays
          from t_sys_glossary g where g.glossarytypeid = 'A08-3';

          UPDATE T_EC_SURVEY_INFO
          SET  STATUS = decode(Return_flag,'N','A06-A', 'A06-9')
            , comment2 = ''
            , survey_vendor_date_expaired = sysdate + varDays
          WHERE SURVEY_ID = varkeyId;

          --重啟流程為是：5.2.4.2.1 將調查單狀態(t_ec_survey_info.status) 改為「A06-9 填單-資管科同意退回」、將設通單狀態(T_EC_INFO.status)更改為 A04-6廠商調查_退回
          if varReturn_flag = 'Y' then
              UPDATE T_EC_INFO
              SET STATUS = 'A04-6'
              WHERE EC_ID IN(
               SELECT EC_ID
               FROM T_EC_SURVEY_INFO
               WHERE SURVEY_ID = varkeyId );

             select g.glossary2
               into varSendMan
             from t_sys_glossary g where g.glossarytypeid = 'A14-2';

             --5.2.4.2.2 新增資管科承辦(公用參數A14-2)待辦
             PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                '13-02-08',      --功能選單ID
                                 varEcnno || ' ' || varVendor || ' 設通調查表重啟流程，請確認', --主旨
                                 varEcnno || ' ' || varVendor || ' 設通調查表重啟流程，請確認', --內容
                                 newWorkListId    --成功:WorkListID;  失敗:-1
                                );


            UPDATE T_EC_INFO i
              SET i.worklistid = newWorkListId
            WHERE EC_ID IN(
               SELECT EC_ID
               FROM T_EC_SURVEY_INFO
               WHERE SURVEY_ID = varkeyId );

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

           v_title := '<退回通知>'|| varUt_unitna  ||'退回廠商或零件切換調查';
           v_body := v_semail_na ||' 先生/小姐 您好：<br>' || varUt_unitna || '退回設通單' || varEcnno ||'，請進入設變調查e化系統執行EC>>管理>>「分發廠商調整」功能。';
           VarContent := '<html><head></head><body><P>'|| v_body ||'</P></body></html>';

           p_sys_mail_add(v_semail,v_ccmail,v_title,VarContent,'','Y','','',VarResult);
           if VarResult = '-1' then
              rollback;
              return;
           end if;

          else --重啟流程為否
             varSendMan := substr(varVendor,0,4)||'2';
            --5.2.6 新增下一關卡廠商待辦
             PA_SYS_WORKLIST.P_WORKLIST_ADD(varSendMan,   --對象
                                '13-02-04',      --功能選單ID
                                 varEcnno || ' ' || varVendor || ' 廠商調查表請填寫', --主旨
                                 varEcnno || ' ' || varVendor || ' 廠商調查表請填寫', --內容
                                 newWorkListId    --成功:WorkListID;  失敗:-1
                                );

             UPDATE T_EC_SURVEY_INFO
              SET worklistid = newWorkListId
               , isalert = 'N'
             WHERE SURVEY_ID = varkeyId ;

          end if;
        end if;

       WHEN 'A09Reject' THEN
          --設通調查表填寫(退回)
          --6-1. 將調查單狀態(t_ec_survey_info.status) 設為A06-6填單-主管退回承辦。
          UPDATE T_EC_SURVEY_INFO S SET STATUS = 'A06-6'
              , isalert = 'N'
          --6-2. 更新簽核歷程t_ec_survey_info.sign_history
              ,sign_history = varHistNum ||'.' || to_char(sysdate,'yyyy/mm/dd HH24:MM:SS') || ' ' || varName || ' ' || varPositionna|| ' 退回，意見： ' || comment2 || chr(10) || sign_history
          WHERE SURVEY_ID = varkeyId;

          --6-3. 此關卡之待辦完成、新增下一關承辦待辦
          PA_SYS_WORKLIST.P_WorkList_Complete(varWkid,varRV);
          PA_SYS_WORKLIST.P_WORKLIST_ADD(varSurvey_taker,   --對象
                                           '13-02-01',      --功能選單ID
                                           varEcnno || ' ' || varVendor || ' 設通調查表被退回，請重新填寫', --主旨
                                           varEcnno || ' ' || varVendor || ' 設通調查表被退回，請重新填寫', --內容
                                           newWorkListId    --成功:WorkListID;  失敗:-1
                                          );

          UPDATE T_EC_SURVEY_INFO
          SET comment2 = ''
              ,worklistid = newWorkListId
          WHERE SURVEY_ID = varkeyId;

        ELSE
             OutResult := 'ok';
      END CASE;

       OutResult := 'ok';

       EXCEPTION
          WHEN OTHERS THEN
             ROLLBACK;
             OutResult := SQLERRM;

    END P_EC_SurveyStatus_sdo;


   -- A09_填寫設通調查表 13-02-01-02-02 - 儲存
   PROCEDURE P_EC_NewSurveyUpdate (
      varSurveyId     IN      VARCHAR2, -- 流水號S_T_EC_SURVEY(PK)
      varStatus       IN      VARCHAR2, -- 調查表狀態(A06-2承辦處理、A06-6主管退回、A06-5填單-主管審核)
      varComment      IN      VARCHAR2, -- 承辦/主管意見
      varReturn_Flag  IN      VARCHAR2, -- 重啟流程
      varTitle        IN      VARCHAR2, -- 主旨
      varSign_Leader  IN      VARCHAR2, -- 組長
      varSign_Level   IN      VARCHAR2, -- 簽核主管層級
      varCdCnt        IN      VARCHAR2, -- CD張數
      varEcChgContent IN      VARCHAR2, -- 設計變更內容
      varOverDueReasonDescription IN      VARCHAR2, --逾期原因
      varUserId       IN      VARCHAR2, -- 登入者ID
      OutResult       OUT     VARCHAR2
    )
    is

    BEGIN
      if (varStatus = 'A06-2' or varStatus = 'A06-6') then --狀態為A06-2承辦處理、A06-6主管退回
          update t_ec_survey_info s
          set s.comment2 = varComment
          ,s.return_flag = varReturn_Flag
          ,s.sign_leader = varSign_Leader
          ,s.Sign_Level = varSign_Level
          ,s.cd_cnt = varCdCnt
          ,s.content2 = varEcChgContent
          ,s.survey_title = varTitle
          ,s.overduereasondescription = varOverDueReasonDescription
          ,s.modifyer = varUserId
          ,s.modify_date = sysdate
          where s.survey_id = varSurveyId;

      else --狀態為A06-5填單-主管審核
          update t_ec_survey_info s
          set s.comment2 = varComment
         -- ,s.overduereasondescription = varOverDueReasonDescription
          ,s.modifyer = varUserId
          ,s.modify_date = sysdate
          where s.survey_id = varSurveyId;
      end if;
      OutResult := 0;

      EXCEPTION
      WHEN OTHERS
      THEN
           ROLLBACK;
           OutResult := -1;

    END P_EC_NewSurveyUpdate;

    --A09_填寫設通調查表 13-02-01-02-01 -設變部品清單查詢
   PROCEDURE P_EC_SurveyEcPartsList(
     varSurveyid    IN VARCHAR2,
     ReturnValues   OUT SYS_REFCURSOR
   )
   IS
     varSql     VARCHAR2(1000);
   BEGIN
      varSql := 'SELECT P.survey_parts_id,P.req_ANPQP,P.req_test,decode(I.changemaker,''A'',''新增'',decode(I.changemaker,''D'',''取消'','''')) as changemaker ,
      substr(I.partno,1,11) as partno,I.partname,I.dwgno,I.dwgver
      FROM T_EC_SURVEY_PARTS P
      JOIN  T_EC_PL_INFO I ON I.PL_ID = P.PL_ID
      WHERE P.SURVEY_ID = ' || varSurveyid
      || ' order by I.partno';

      OPEN ReturnValues FOR varSql ;

   END P_EC_SurveyEcPartsList;


     --A09_填寫設通調查表 13-02-01-03-01 --設變部品清單儲存
   PROCEDURE  P_EC_SurveyEcPartsSave(
      varColumnName  IN VARCHAR2, -- anpqp註記：req_ANPQP、試裝註記：req_test
      varPartIdsY    IN VARCHAR2, -- 零件註記為Y之id清單, EX. 117,118,120
      varPartIdsN    IN VARCHAR2, -- 零件註記為N之id清單, EX. 119,121
      varUserId      IN VARCHAR2, -- 登入者ID
      OutResult   OUT VARCHAR2
    )
   IS
   BEGIN
     OutResult := 'ok';

     if ( varColumnName = 'req_ANPQP') then

        Update T_EC_SURVEY_PARTS P
        set P.req_ANPQP = 'Y'
        ,p.modifyer = varUserId
        ,p.modify_date = sysdate
        WHERE P.survey_parts_id in (
        SELECT ENGINEID
        FROM TABLE(
             SELECT F_PUB_SPLIT(varPartIdsY) FROM DUAL
             )
        );

        Update T_EC_SURVEY_PARTS P
        set P.req_ANPQP = 'N'
        ,p.modifyer = varUserId
        ,p.modify_date = sysdate
        WHERE P.survey_parts_id  in (
        SELECT ENGINEID
        FROM TABLE(
             SELECT F_PUB_SPLIT(varPartIdsN) FROM DUAL
             )
        );

      elsif (varColumnName = 'req_test') then

         Update T_EC_SURVEY_PARTS P
        set P.req_test = 'Y'
        ,p.modifyer = varUserId
        ,p.modify_date = sysdate
        WHERE P.survey_parts_id in (
        SELECT ENGINEID
        FROM TABLE(
             SELECT F_PUB_SPLIT(varPartIdsY) FROM DUAL
             )
        );

        Update T_EC_SURVEY_PARTS P
        set P.req_test = 'N'
        ,p.modifyer = varUserId
        ,p.modify_date = sysdate
        WHERE P.survey_parts_id  in (
        SELECT ENGINEID
        FROM TABLE(
             SELECT F_PUB_SPLIT(varPartIdsN) FROM DUAL
             )
        );

      end if;

      OutResult := 0;

      EXCEPTION
      WHEN OTHERS
      THEN
           ROLLBACK;
           OutResult := -1;

   END P_EC_SurveyEcPartsSave;

   --A09、A11 調查表附件上傳
   PROCEDURE P_EC_SurveyFileUpdate
   (
      varStep        IN   VARCHAR2,  --附件種類:A09LOAD、A11LOAD
      varSurveyid    IN   VARCHAR2,  --流水號S_T_EC_SURVEY(PK)
      varAttchid     IN   NVARCHAR2, --附件ID
      OutResult   OUT  VARCHAR2   --?果：0成功；-1失?；
    )
    is
    begin
      if varStep = 'A09LOAD' then
         update t_ec_survey_info s set s.yn_attachid = varAttchid where s.survey_id = varSurveyid;
      else
         update t_ec_survey_info s set s.vendor_attachid = varAttchid where s.survey_id = varSurveyid;
      end if;
      COMMIT;

      OutResult := 0;

      EXCEPTION
      WHEN OTHERS
      THEN
           ROLLBACK;
           OutResult := -1;
   end P_EC_SurveyFileUpdate;

END PA_EC_MANAGE2;

