select distinct a.ec_id,
                  decode(
                    report_type,null,'S',report_type
                  ) as report_type,
                  a.pdm_ecfileid,
                  a.ecnno,
                  a.pdm_models models,
                  a.title,
                  m.vendor_list_na as suppliername,
                  to_char(
                    a.released_date,'YYYY/MM/DD'
                  ) released_date,
                  s.glossary1 as unitname,
                  to_char(
                    m.sdate,'YYYY/MM/DD'
                  ) survey_vendor_sdate,
                  to_char(
                    m.pdate,'YYYY/MM/DD'
                  ) survey_vendor_pdate,
                  to_char(
                    m.rdate,'YYYY/MM/DD'
                  ) survey_vendor_edate,
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
     and a.released_date between date '2022-01-01' and date '2022-12-31'
     and a.pdm_models like '%21B%'
