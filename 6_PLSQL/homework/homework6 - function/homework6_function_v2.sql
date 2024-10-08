--用來call function

DECLARE
  v_result VARCHAR2(30000);
BEGIN
  v_result := get_ec_info('&設通編號', '&廠商', '&車系', '&發行時間結束', '&廠商調查狀態', '&廠商調查單位');
  DBMS_OUTPUT.PUT_LINE(v_result);
END;


--function

CREATE OR REPLACE FUNCTION get_ec_info(input_ecnno            IN VARCHAR2,
                                       input_vendor           IN VARCHAR2,
                                       input_models           IN VARCHAR2,
                                       input_release_date_end IN VARCHAR2,
                                       input_survey_status    IN NVARCHAR2,
                                       input_unitname         IN NVARCHAR2)
  RETURN VARCHAR2 IS
  v_result             VARCHAR2(30000);
  v_release_date_start DATE;
  v_release_date_end   DATE;
  v_models             VARCHAR2(100);
  CURSOR cursor1 IS
    SELECT ecnno,
           models,
           title,
           suppliername,
           released_date,
           unitname,
           survey_vendor_sdate,
           survey_vendor_pdate,
           survey_vendor_edate,
           survey_status
      FROM (SELECT DISTINCT a.ec_id,
                            decode(report_type, NULL, 'S', report_type) AS report_type,
                            a.pdm_ecfileid,
                            a.ecnno,
                            a.pdm_models models,
                            a.title,
                            m.vendor_list_na AS suppliername,
                            to_char(a.released_date, 'YYYY/MM/DD') released_date,
                            s.glossary1 AS unitname,
                            to_char(m.sdate, 'YYYY/MM/DD') survey_vendor_sdate,
                            to_char(m.pdate, 'YYYY/MM/DD') survey_vendor_pdate,
                            to_char(m.rdate, 'YYYY/MM/DD') survey_vendor_edate,
                            s1.glossary2 survey_status
              FROM t_ec_info a
              LEFT JOIN t_ec_sum m
                ON m.ec_id = a.ec_id
               AND m.report_type = 'S'
              LEFT JOIN t_sys_glossary s
                ON s.glossarytypeid LIKE 'A05-%'
               AND s.modifycontent = m.unit
              LEFT JOIN t_sys_glossary s1
                ON s1.glossarytypeid LIKE 'A18-%'
               AND s1.glossarytypeid = m.status
             WHERE 1 = 1
               AND ROWNUM <= 50 -- 用來避免 buffer overflow
               AND (a.ecnno = input_ecnno OR input_ecnno IS NULL)
               AND (m.vendor_list_na = input_vendor OR input_vendor IS NULL)
               AND (a.pdm_models LIKE v_models OR v_models IS NULL)
               AND (a.released_date BETWEEN v_release_date_start AND
                   v_release_date_end OR v_release_date_start IS NULL OR
                   v_release_date_end IS NULL)
               AND (s1.glossary2 = input_survey_status OR
                   input_survey_status IS NULL)
               AND (s.glossary1 = input_unitname OR input_unitname IS NULL));
  output1 cursor1%rowtype;
BEGIN
  v_release_date_end   := to_date(input_release_date_end, 'YYYY-MM-DD');
  v_release_date_start := v_release_date_end - 100; --設定開始時間為前100天
  v_models             := '%' || input_models || '%';
  OPEN cursor1;
  FETCH cursor1
    INTO output1;
  IF cursor1%notfound THEN
    --捕捉notfound例外
    v_result := '查無資料';
  ELSE
    LOOP
      v_result := v_result || output1.ecnno || ', ' || output1.models || ', ' ||
                  output1.title || ', ' || output1.suppliername || ', ' ||
                  output1.released_date || ', ' || output1.unitname || ', ' ||
                  output1.survey_vendor_sdate || ', ' ||
                  output1.survey_vendor_pdate || ', ' ||
                  output1.survey_vendor_edate || ', ' ||
                  output1.survey_status || chr(10);
      FETCH cursor1
        INTO output1;
      EXIT WHEN cursor1%notfound;
    END LOOP;
  END IF;

  CLOSE cursor1;
  RETURN v_result;
END;
