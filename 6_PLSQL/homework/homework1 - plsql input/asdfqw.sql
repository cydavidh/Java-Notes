declare
  input_ecnno CHAR(11) := '&設通編號';
input_vendor varchar(100) := '&廠商'；
begin
  select ecnno, models, title, suppliername, released_date, unitname, survey_vendor_sdate, survey_vendor_pdate, survey_vendor_edate, survey_status
from (
    SELECT DISTINCT A.EC_ID,
    decode(report_type, NULL, 'S', report_type) AS report_type,
           A.pdm_EcFileID, A.ECNNO, A.PDM_MODELS MODELS, A.TITLE,
           M.VENDOR_LIST_NA as SUPPLIERNAME, TO_CHAR(A.RELEASED_DATE,'YYYY/MM/DD') RELEASED_DATE,
           S.GLOSSARY1 as Unitname,
           TO_CHAR(M.sdate,'YYYY/MM/DD') SURVEY_VENDOR_SDATE,
           TO_CHAR(M.pdate,'YYYY/MM/DD') SURVEY_VENDOR_PDATE,
           TO_CHAR(M.rdate,'YYYY/MM/DD') SURVEY_VENDOR_EDATE,
           S1.GLOSSARY2 SURVEY_STATUS
    FROM T_EC_INFO A
    LEFT JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = 'S'
    LEFT JOIN T_SYS_GLOSSARY S ON S.GLOSSARYTYPEID LIKE 'A05-%' AND S.MODIFYCONTENT = M.UNIT
    LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE 'A18-%' AND S1.GLOSSARYTYPEID = M.status
    where 1=1 
    and A.ECNNO = input_ecnno
    and M.VENDOR_LIST_NA = input_vendor
    and A.RELEASED_DATE between date '2022-01-01' and date '2022-12-31'
    and A.PDM_MODELS like '%21B%'
) 
end；
