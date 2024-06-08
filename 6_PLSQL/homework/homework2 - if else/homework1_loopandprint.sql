DECLARE
  input_ecnno CHAR(11) := '&�]�q�s��';
  input_vendor VARCHAR2(100) := '&�t��';
  input_models VARCHAR2(250) := '%&���t%'; 
  input_release_date_start DATE := TO_DATE('&�o��ɶ��_�l', 'YYYY-MM-DD'); 
  input_release_date_end DATE := TO_DATE('&�o��ɶ�����', 'YYYY-MM-DD'); 
  input_survey_status NVARCHAR2(300) := '&�t�ӽլd���A'; 
  input_unitname NVARCHAR2(300) := '&�t�ӽլd���';
BEGIN
  IF input_ecnno = '           ' THEN
    input_ecnno := NULL;
  END IF;
  FOR i IN (
    SELECT ecnno, models, title, suppliername, released_date, unitname,
           survey_vendor_sdate, survey_vendor_pdate, survey_vendor_edate, survey_status
    FROM (
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
        WHERE 1=1
		      AND (A.ECNNO = input_ecnno OR input_ecnno IS NULL)
          AND (M.VENDOR_LIST_NA = input_vendor OR input_vendor IS NULL)
          AND (A.PDM_MODELS LIKE input_models OR input_models IS NULL)
          AND (A.RELEASED_DATE BETWEEN input_release_date_start AND input_release_date_end OR input_release_date_start IS NULL OR input_release_date_end IS NULL)
          AND (S1.GLOSSARY2 = input_survey_status OR input_survey_status IS NULL)
          AND (S.GLOSSARY1 = input_unitname OR input_unitname IS NULL)
    )
  )
  LOOP
    dbms_output.put_line(i.ecnno || ', ' || i.models || ', ' || i.title || ', ' ||
                         i.suppliername || ', ' ||  i.released_date || ', ' || i.unitname || ', ' ||
                         i.survey_vendor_sdate || ', ' || i.survey_vendor_pdate || ', ' || i.survey_vendor_edate || ', ' ||
                         i.survey_status);
  END LOOP;
END;
