declare
  input_ecnno              char(11) := '&設通編號';
  input_vendor             varchar2(100) := '&廠商';
  input_models             varchar2(250) := '%&車系%';
  input_release_date_end   date := to_date('&發行時間結束', 'YYYY-MM-DD');
  input_survey_status      nvarchar2(300) := '&廠商調查狀態';
  input_unitname           nvarchar2(300) := '&廠商調查單位';
  input_release_date_start date := input_release_date_end - 100;
  執行結果                 varchar2(300);

  cursor cursor1 is
    select ecnno,
           models,
           title,
           suppliername,
           released_date,
           unitname,
           survey_vendor_sdate,
           survey_vendor_pdate,
           survey_vendor_edate,
           survey_status
      from (select distinct a.ec_id,
                            decode(report_type, null, 'S', report_type) as report_type,
                            a.pdm_ecfileid,
                            a.ecnno,
                            a.pdm_models models,
                            a.title,
                            m.vendor_list_na as suppliername,
                            to_char(a.released_date, 'YYYY/MM/DD') released_date,
                            s.glossary1 as unitname,
                            to_char(m.sdate, 'YYYY/MM/DD') survey_vendor_sdate,
                            to_char(m.pdate, 'YYYY/MM/DD') survey_vendor_pdate,
                            to_char(m.rdate, 'YYYY/MM/DD') survey_vendor_edate,
                            s1.glossary2 survey_status
              from t_ec_info a
              left join t_ec_sum m
                on m.ec_id = a.ec_id
               and m.report_type = 'S'
              left join t_sys_glossary s
                on s.glossarytypeid like 'A05-%'
               and s.modifycontent = m.unit
              left join t_sys_glossary s1
                on s1.glossarytypeid like 'A18-%'
               and s1.glossarytypeid = m.status
             where 1 = 1
             and ROWNUM <= 50 --避免buffer overflow
               and (a.ecnno = input_ecnno or input_ecnno is null)
               and (m.vendor_list_na = input_vendor or input_vendor is null)
               and (a.pdm_models like input_models or input_models is null)
               and (a.released_date between input_release_date_start and
                   input_release_date_end or
                   input_release_date_start is null or
                   input_release_date_end is null)
               and (s1.glossary2 = input_survey_status or
                   input_survey_status is null)
               and (s.glossary1 = input_unitname or input_unitname is null));
  output1 cursor1%rowtype;
begin
  if input_ecnno = '           ' then
    input_ecnno := null;
  end if;
  open cursor1;
  fetch cursor1
    into output1;
  if cursor1%notfound then
    執行結果 := '查無資料';
    dbms_output.put_line(執行結果);
  else
    loop
      執行結果 := output1.ecnno || ', ' || output1.models || ', ' ||
              output1.title || ', ' || output1.suppliername || ', ' ||
              output1.released_date || ', ' || output1.unitname || ', ' ||
              output1.survey_vendor_sdate || ', ' ||
              output1.survey_vendor_pdate || ', ' ||
              output1.survey_vendor_edate || ', ' || output1.survey_status;
      dbms_output.put_line(執行結果);
      fetch cursor1
        into output1;
      exit when cursor1%notfound;
    end loop;
  end if;
  close cursor1;
end;
