declare
	input_ecnno              char(11) := '&設通編號';
	input_vendor             varchar2(100) := '&廠商';
	input_models             varchar2(250) := '%&車系%';
	input_release_date_start date := to_date ( '&發行時間起始','YYYY-MM-DD' );
	input_release_date_end   date := to_date ( '&發行時間結束','YYYY-MM-DD' );
	input_survey_status      nvarchar2(300) := '&廠商調查狀態';
	input_unitname           nvarchar2(300) := '&廠商調查單位';
begin
	if input_ecnno = '           ' then
		input_ecnno := null;
	end if;
	for i in (
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
		  from (
			select distinct a.ec_id,
			                decode(
				                report_type,
				                null,
				                'S',
				                report_type
			                ) as report_type,
			                a.pdm_ecfileid,
			                a.ecnno,
			                a.pdm_models models,
			                a.title,
			                m.vendor_list_na as suppliername,
			                to_char(
				                a.released_date,
				                'YYYY/MM/DD'
			                ) released_date,
			                s.glossary1 as unitname,
			                to_char(
				                m.sdate,
				                'YYYY/MM/DD'
			                ) survey_vendor_sdate,
			                to_char(
				                m.pdate,
				                'YYYY/MM/DD'
			                ) survey_vendor_pdate,
			                to_char(
				                m.rdate,
				                'YYYY/MM/DD'
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
		)
	) loop
		if
			( i.ecnno = input_ecnno or input_ecnno is null )
			and ( i.suppliername = input_vendor or input_vendor is null )
			and ( i.models like input_models or input_models is null )
			and ( to_date(i.released_date,
        'YYYY/MM/DD') between input_release_date_start and input_release_date_end or input_release_date_start is null or input_release_date_end
        is null )
			and ( i.survey_status = input_survey_status or input_survey_status is null )
			and ( i.unitname = input_unitname or input_unitname is null )
		then
			dbms_output.put_line(i.ecnno
			                     || ', '
			                     || i.models
			                     || ', '
			                     || i.title
			                     || ', '
			                     || i.suppliername
			                     || ', '
			                     || i.released_date
			                     || ', '
			                     || i.unitname
			                     || ', '
			                     || i.survey_vendor_sdate
			                     || ', '
			                     || i.survey_vendor_pdate
			                     || ', '
			                     || i.survey_vendor_edate
			                     || ', '
			                     || i.survey_status);
		end if;
	end loop;
end;