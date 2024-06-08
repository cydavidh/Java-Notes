CREATE OR REPLACE PROCEDURE "P_EC_QRYECLIST" (
   /* 13-03 �]�q��d��List
    */
   varPageSize           IN     VARCHAR2,                       --�C���ƶq
   varPageNO             IN     VARCHAR2,                       --��e��
   varEcnNo              IN     VARCHAR2,                       -- �]�q�s��
   varSupplier           IN     VARCHAR2,                       -- �t�ӥN��
   varModel              IN     VARCHAR2,                       -- ���t
   varVenSurveyStatus    IN     VARCHAR2,                       -- �t�ӽլd���A
   varVenSurveyunit      IN     VARCHAR2,                       -- �t�ӽլd���
   varPtChgSurveyStatus  IN     VARCHAR2,                       -- �s������լd���A
   varPtChgSurveyunit    IN     VARCHAR2,                       -- �s�������T���
   varRlsDateS           IN     VARCHAR2,                       -- E-BOM�o���_
   varRlsDateE           IN     VARCHAR2,                       -- E-BOM�o��騴
   varEc_id              IN     VARCHAR2,
   varReport_type        IN     VARCHAR2,                          -- ���������GS�t�ӽլd/C�s�����
   varUnit               IN     VARCHAR2,                       -- �t�ӽլd/�s�������O
   varStatus             IN     VARCHAR2,                       -- �t�ӽլd/�s��������A(����/�O��)
   varDueType            IN     VARCHAR2,                       -- �w�p����(N:���g, N1:�U�g)
 --  varDevtaker           IN     VARCHAR2,                       -- �s�ީӿ�
   varDesSection         IN     VARCHAR2,                       -- �]�p��O
   varDesigner           IN     VARCHAR2,                       -- �]�p�ӿ�
   --cydavidh
   varDesignerSurveySection     IN     VARCHAR2,                    --�]�p�լd��O
   varSurveyUnitX        IN     VARCHAR2,                    --�]�p�լd��O
   
   returnValues          OUT    SYS_REFCURSOR,
   OutRecordCount        OUT    VARCHAR2                        --�O����
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
    varDueType, varDesSection, varDesigner, varDesignerSurveySection, varSurveyUnitX, varSelSql, varJoinSql,
    varWhereSql);

   varSql := varSelSql || varJoinSql || varWhereSql;

   -- ���O����
   VarCountSql := 'select count(*) from (' || varSql || ')';
   EXECUTE IMMEDIATE VarCountSql INTO VarCount;
   OutRecordCount := TO_CHAR (VarCount);
   --insert into t_ec_sql_log values(sysdate, VarCountSql, 'P_EC_QryEcLIST, �]�q��d��');


   --��������d��
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

   insert into t_ec_sql_log values(sysdate, varSql, 'P_EC_QryEcLIST v7, �]�q��d��');
   commit;

   OPEN returnValues FOR varSql;
END;


 
/
