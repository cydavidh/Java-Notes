CREATE OR REPLACE PROCEDURE "P_EC_QRYECLIST" (
   /* 13-03 設通單查詢List
    */
   varPageSize           IN     VARCHAR2,                       --每頁數量
   varPageNO             IN     VARCHAR2,                       --當前頁
   varEcnNo              IN     VARCHAR2,                       -- 設通編號
   varSupplier           IN     VARCHAR2,                       -- 廠商代號
   varModel              IN     VARCHAR2,                       -- 車系
   varVenSurveyStatus    IN     VARCHAR2,                       -- 廠商調查狀態
   varVenSurveyunit      IN     VARCHAR2,                       -- 廠商調查單位
   varPtChgSurveyStatus  IN     VARCHAR2,                       -- 零件切換調查狀態
   varPtChgSurveyunit    IN     VARCHAR2,                       -- 零件切換資訊單位
   varRlsDateS           IN     VARCHAR2,                       -- E-BOM發行日起
   varRlsDateE           IN     VARCHAR2,                       -- E-BOM發行日迄
   varEc_id              IN     VARCHAR2,
   varReport_type        IN     VARCHAR2,                          -- 報表類型：S廠商調查/C零件切換
   varUnit               IN     VARCHAR2,                       -- 廠商調查/零件切換科別
   varStatus             IN     VARCHAR2,                       -- 廠商調查/零件切換狀態(完成/逾期)
   varDueType            IN     VARCHAR2,                       -- 預計完成(N:本週, N1:下週)
 --  varDevtaker           IN     VARCHAR2,                       -- 零技承辦
   varDesSection         IN     VARCHAR2,                       -- 設計科別
   varDesigner           IN     VARCHAR2,                       -- 設計承辦
   returnValues          OUT    SYS_REFCURSOR,
   OutRecordCount        OUT    VARCHAR2                        --記錄數
)
IS
   -- SQL
   varSelSql         VARCHAR2 (4000);
   varJoinSql        VARCHAR2 (4000);
   varWhereSql       VARCHAR2 (4000);
   varSql            VARCHAR2 (4000);

   -- Page
   VarCountSql      VARCHAR2 (4000);
   VarCount         INT;
   VarMinRowNO      INT;
   VarMaxRowNO      INT;
   varDist_unit      CHAR(1);
   varVensur_status  VARCHAR2(5);
   varChg_unit       CHAR(1);
   varPtchg_status   VARCHAR2(5);
   varReportType_tmp       CHAR(1);
BEGIN
  if (varReport_type is null) then
     varReportType_tmp := 'S';
     varDist_unit := null;
     varVensur_status := null;
     varChg_unit := null;
     varPtchg_status := null;
   else
     varReportType_tmp := varReport_type ;
   end if;

   if (varReport_type = 'S') then
     varDist_unit := varUnit;
     if  (varStatus = '') then
          varVensur_status := null;
     else
          varVensur_status := varStatus;
     end if;
     varChg_unit := null;
     varPtchg_status := null;
   elsif (varReport_type = 'C') then
     varDist_unit := null;
     varVensur_status := null;
     varChg_unit := varUnit;
     if  (varStatus = '') then
          varPtchg_status := null;
     else
          varPtchg_status := varStatus;
     end if;
   end if;

   P_EC_QryEcSql(varReportType_tmp||'-A08',varEc_id, varEcnNo, varSupplier, varModel, varVenSurveyStatus,
    varVenSurveyunit, varPtChgSurveyStatus, varPtChgSurveyunit, varRlsDateS,
    varRlsDateE, varDist_unit, varChg_unit, varVensur_status, varPtchg_status,
    varDueType, varDesSection, varDesigner, varDesignerSurveySection, varSelSql, varJoinSql,
    varWhereSql);

   varSql := varSelSql || varJoinSql || varWhereSql;

   -- 取記錄數
   VarCountSql := 'select count(*) from (' || varSql || ')';
   EXECUTE IMMEDIATE VarCountSql INTO VarCount;
   OutRecordCount := TO_CHAR (VarCount);
   --insert into t_ec_sql_log values(sysdate, VarCountSql, 'P_EC_QryEcLIST, 設通單查詢');


   --執行分頁查詢
   VarMaxRowNO := TO_NUMBER (varPageSize) * TO_NUMBER (varPageNO);
   VarMinRowNO := VarMaxRowNO - TO_NUMBER (varPageSize) + 1;
   IF varPageSize >0 THEN
     VarSql :=
       ' SELECT *
          FROM (SELECT A.*, rownum rn
            FROM  (' || VarSql || ') A
            WHERE rownum <= ' || TO_CHAR (VarMaxRowNO) || ') B
          WHERE rn >= ' || TO_CHAR (VarMinRowNO);
   END IF;

   insert into t_ec_sql_log values(sysdate, varSql, 'P_EC_QryEcLIST v7, 設通單查詢');
   commit;

   OPEN returnValues FOR varSql;
END;


 
