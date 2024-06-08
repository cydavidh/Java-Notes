declare
	type survey_record is record (
			ecnno               varchar2(100),
			models              varchar2(250),
			title               varchar2(100),
			suppliername        varchar2(100),
			released_date       date,
			unitname            nvarchar2(300),
			survey_vendor_sdate date,
			survey_vendor_pdate date,
			survey_vendor_edate date,
			survey_status       nvarchar2(300)
	);
	type survey_table is
		table of survey_record index by pls_integer;
	input_ecnno              char(11) := '&設通編號';
	input_vendor             varchar2(100) := '&廠商';
	input_models             varchar2(250) := '%&車系%';
	input_release_date_start date := to_date ( '&發行時間起始','YYYY-MM-DD' );
	input_release_date_end   date := to_date ( '&發行時間結束','YYYY-MM-DD' );
	input_survey_status      nvarchar2(300) := '&廠商調查狀態';
	input_unitname           nvarchar2(300) := '&廠商調查單位';
	surveys                  survey_table;
	cursor1                  sys_refcursor;
	output1                  survey_record;
begin
	if input_ecnno = '           ' then
		input_ecnno := null;
	end if;
	open cursor1 for select ecnno,
	                        models,
	                        title,
	                        suppliername,
	                        released_date,
	                        unitname,
	                        sdate,
	                        pdate,
	                        rdate,
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
		                                 a.released_date,
		                                 s.glossary1 as unitname,
		                                 m.sdate,
		                                 m.pdate,
		                                 m.rdate,
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
		                    and ( a.ecnno = input_ecnno
		                     or input_ecnno is null )
		                    and ( m.vendor_list_na = input_vendor
		                     or input_vendor is null )
		                    and ( a.pdm_models like input_models
		                     or input_models is null )
		                    and ( a.released_date between input_release_date_start and input_release_date_end
		                     or input_release_date_start is null
		                     or input_release_date_end is null )
		                    and ( s1.glossary2 = input_survey_status
		                     or input_survey_status is null )
		                    and ( s.glossary1 = input_unitname
		                     or input_unitname is null )
	                 );

	loop
		fetch cursor1 into output1;
		exit when cursor1%notfound;
		surveys(surveys.count + 1) := output1;
	end loop;
	close cursor1;
	for i in 1..surveys.count loop
		dbms_output.put_line(surveys(i).ecnno
		                     || ', '
		                     || surveys(i).models
		                     || ', '
		                     || surveys(i).title
		                     || ', '
		                     || surveys(i).suppliername
		                     || ', '
		                     || to_char(
		                               surveys(i).released_date,
		                               'YYYY/MM/DD'
		                        )
		                     || ', '
		                     || surveys(i).unitname
		                     || ', '
		                     || to_char(
		                               surveys(i).survey_vendor_sdate,
		                               'YYYY/MM/DD'
		                        )
		                     || ', '
		                     || to_char(
		                               surveys(i).survey_vendor_pdate,
		                               'YYYY/MM/DD'
		                        )
		                     || ', '
		                     || to_char(
		                               surveys(i).survey_vendor_edate,
		                               'YYYY/MM/DD'
		                        )
		                     || ', '
		                     || surveys(i).survey_status);
	end loop;

exception
	when no_data_found then
		dbms_output.put_line('查無資料');
	when value_error then
		dbms_output.put_line('資料量太大，請增加篩選條件');
end;