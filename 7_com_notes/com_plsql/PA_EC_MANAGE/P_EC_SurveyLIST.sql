PROCEDURE P_EC_SURVEYLIST (
VARPAGESIZE IN VARCHAR2 --每頁數量
,
VARPAGENO IN VARCHAR2 --當前頁
,
VARSTEP IN VARCHAR2,
VARECN IN VARCHAR2,
VARSURVEY_ID IN VARCHAR2,
VARCAR IN VARCHAR2,
VARSECTION IN VARCHAR2,
VARUT_UNITID IN VARCHAR2 --調查科別ID
,
VARUNDERTAKE IN VARCHAR2,
VARUSERID IN VARCHAR2,
VARROLE IN VARCHAR2,
VARSTATUS IN VARCHAR2,
RETURNVALUES OUT SYS_REFCURSOR,
OUTRECORDCOUNT OUT VARCHAR2 --記錄數
) IS

-- Sql
VARSQL VARCHAR2(8000);

VARORDERBY VARCHAR2(500);

VARSUBSQL VARCHAR2(4000);

VARSUBSQL2 VARCHAR2(100);

-- Page
VARCOUNTSQL VARCHAR2(4000);

VARCOUNT INT;

VARMINROWNO INT;

VARMAXROWNO INT;

VAR2 VARCHAR2(100);

BEGIN
	SELECT
		''                                                       pagesize,
		''                                                       curpage,
		decode(s.dist_unit, 'Y', '零技科', 'P', 'PEO', 'S', '三義工廠') distunitna,
		s.survey_taker                                           AS undertakeid,
		(
			SELECT
				p.name
			FROM
				t_sys_employinfo p
			WHERE
				p.employno = s.survey_taker
		) undertakena,
		(
			SELECT
				unitna
			FROM
				t_sys_employinfo emp
			WHERE
				emp.unitid = s.ut_unitid
				AND ROWNUM <= 1
		) utunitna,
		e.designer,
		e.des_unitid AS desgrp,
		(
			SELECT
				p2.name
			FROM
				t_sys_employinfo p2
			WHERE
				p2.employno = e.designer
		) designerna,
		(
			SELECT
				p2.unitna
			FROM
				t_sys_employinfo p2
			WHERE
				p2.employno = e.designer
		) desgrpna,
		s.dist_vendor AS vendorid,
		(
			SELECT
				DISTINCT v.suppliercode || '  ' || v.suppliername
			FROM
				t_anp_supplier v
			WHERE
				v.suppliercode = s.dist_vendor
		) vendorna,
		to_char(e.released_date,
		'YYYY/MM/DD') AS releasedate,
		s.status,
		(
			SELECT
				glossary1
			FROM
				t_sys_glossary
			WHERE
				glossarytypeid = s.status
		) AS statusna,
		(
			SELECT
				name
			FROM
				t_sys_employinfo
			WHERE
				employno = s.sign_leader
		) AS sign_leaderna,
		s.survey_id AS surveyid,
		e.ecnno,
		e.pdm_models,
		s.ut_unitid,
		s.survey_title AS title,
		CASE
			WHEN s.status IN ('A06-1', 'A06-2', 'A06-6') THEN
				decode(s.comment2, NULL, '呈請同意', s.comment2)
			ELSE
				decode(s.comment2, NULL, '', s.comment2)
		END AS comment2,
		s.return_flag,
		s.sign_leader,
		s.sign_level,
		decode(e.adpt,
		'A09-G',
		e.adpt_other_date,
		(
			SELECT
				glossary1
			FROM
				t_sys_glossary
			WHERE
				glossarytypeid = e.adpt
		)) AS adptna,
		s.cd_cnt,
		e.dwg_cnt,
		s.content2,
		s.sign_history,
		s.parts_flag,
		s.yn_attachid,
		s.vendor_attachid,
		(
			CASE
				WHEN 1=1 THEN
					(
						SELECT
							attachpath
						FROM
							t_sys_attach
						WHERE
							t_sys_attach.attachid = s.yn_attachid
					)
			END) AS attachpath_y,
		(
			CASE
				WHEN 1=1 THEN
					(
						SELECT
							attach
						FROM
							t_sys_attach
						WHERE
							t_sys_attach.attachid = s.yn_attachid
					)
			END) AS attachname_y,
		(
			CASE
				WHEN 1=1 THEN
					(
						SELECT
							attachpath
						FROM
							t_sys_attach
						WHERE
							t_sys_attach.attachid = s.vendor_attachid
					)
			END) AS attachpath_v,
		(
			CASE
				WHEN 1=1 THEN
					(
						SELECT
							attach
						FROM
							t_sys_attach
						WHERE
							t_sys_attach.attachid = s.vendor_attachid
					)
			END) AS attachname_v,
		e.pdm_ecfileid,
		e.pdm_attachid,
		s.overduereasondescription,
		s.vendor_memo,
		s.vendor_comment,
		to_char(s.survey_vendor_pdate,
		'YYYY-MM-DD HH24:Mi:SS') AS survey_vendor_pdate,
		to_char(s.survey_vendor_udate,
		'YYYY-MM-DD HH24:Mi:SS') AS survey_vendor_udate
	FROM
		t_ec_info        e
		INNER JOIN t_ec_survey_info s
		ON s.ec_id = e.ec_id
	WHERE
		1 = 1;
	CASE varstep
		WHEN 'A11LIST' THEN --廠商、承辦、Leader、主管回覆LIST
			IF varrole = '8' THEN --廠商 --varSubSql2 := ' and S.DIST_VENDOR = substr(''G1492'',1,4) ';
				varsubsql2 := ' and S.DIST_VENDOR = substr(''' || varuserid || ''',1,4) ';
			END IF;

			varsubsql := varsubsql || varsubsql2;
			IF varstatus IS NOT NULL THEN --簽核狀態
				varsubsql := varsubsql || ' AND S.STATUS = ''' || varstatus || '''';
			ELSE
				var2 := substr( varrole, 1, 1 ); -- -1 -> -, 不然-1與1衝突
				varsubsql := varsubsql || ' AND S.STATUS IN (SELECT GLOSSARYTYPEID FROM T_SYS_GLOSSARY WHERE GLOSSARYTYPEID LIKE ''A06%'' AND GLOSSARY3=''A11'' AND GLOSSARY2 LIKE ''%' || var2 || '%'')';
			END IF;

			CASE
				WHEN varrole = '-1' AND varuserid <> 'xxx' THEN -- -1(科長以下) 510507黃福銘  515952陳鐓鍠
					SELECT
						COUNT(*) INTO varcount --判斷是否為LEADER
					FROM
						t_sys_usergroup
					WHERE
						groupid IN (
							SELECT
								groupid
							FROM
								t_sys_group
							WHERE
								groupname = 'YNTC Leader'
						)
						AND userid = varuserid;
					IF varcount = 0 THEN --不是LEADER, 是承辦
						varsubsql := varsubsql || ' AND  S.STATUS IN  (''A06-D'',''A06-E'',''A06-J'') '; --taker status
						varsubsql := varsubsql || ' AND S.SURVEY_TAKER = ''' || varuserid || ''' ';
					ELSE --是LEADER
						varsubsql := varsubsql || ' AND ( ( S.STATUS IN  (''A06-D'',''A06-E'',''A06-J'') ';
						varsubsql := varsubsql || ' AND S.SURVEY_TAKER = ''' || varuserid || ''') or ( ';
						varsubsql := varsubsql || ' S.STATUS IN ( ''A06-G'', ''A06-I'') ';
						varsubsql := varsubsql || ' AND (S.Sign_Now = ''0'' ';
						varsubsql := varsubsql || ' AND S.Sign_Leader = ''' || varuserid || ''' OR S.Sign_Now=''x'' AND S.UT_UNITID=''' || varsection || ''')) )';
					END IF;
				WHEN varrole = '0' OR varuserid = 'xxx' THEN --varRole = 0(科長), Sign_Now = 1(Sign_Level簽核層級第1個),
					varsubsql := varsubsql || ' AND S.Sign_Now = ''1''  ';
					varsubsql := varsubsql || ' AND (S.UT_UNITID = ''' || varut_unitid || ''' OR S.UT_UNITID=''' || varsection || ''') ';
				WHEN varrole = '1' THEN --varRole = 1(科長以上), Sign_Now = 2(Sign_Level簽核層級第二個),Sign_Now = 3(Signoff_Level簽核層級第三個)
					varsubsql := varsubsql || ' AND (( S.Sign_Now <> ''X'' AND S.UT_UNITID in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || '%'' 
            and depusrid not like ''%' || varuserid || ''' )) or ( S.Sign_Now = ''3'' AND S.UT_UNITID in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || ''')))';
				ELSE
					varsubsql := varsubsql;
 --WHEN varRole = '8' THEN --varRole = 8(vendor)
			END CASE;

			varorderby := ' ORDER BY releasedate ASC ';
		WHEN 'A11LOAD' THEN --廠商、承辦、Leader、主管回覆LOAD
			varsubsql := varsubsql || ' AND s.survey_id = ' || varsurvey_id;
		WHEN 'A18LIST' THEN --重新指派承辦頁面
			varsubsql := varsubsql || ' AND (S.STATUS NOT IN (''A06-K'') AND S.STATUS LIKE ''A06%''
                OR  S.STATUS NOT IN (''A07-4'') AND S.STATUS LIKE ''A07%'') ';
			IF varsection IS NOT NULL THEN
				varsubsql := varsubsql || ' AND S.UT_UNITID = (''' || varsection || ''') ';
			END IF;

			IF varundertake IS NOT NULL THEN
				varsubsql := varsubsql || ' AND S.SURVEY_TAKER = (''' || varundertake || ''') ';
			END IF;

			varorderby := ' ORDER BY vendorID ASC';
		WHEN 'A18LOAD' THEN --重新指派承辦小視窗
			varsubsql := varsubsql || ' AND S.SURVEY_ID IN (' || varsurvey_id || ')';
			INSERT INTO t_ec_sql_log VALUES (
				sysdate,
				varsubsql,
				'P_EC_SurveyLIST-A18LOAD'
			);
		ELSE
			OPEN returnvalues FOR
				SELECT
					'NA' id,
					'NA' name
				FROM
					dual;
	END CASE;

	IF varecn IS NOT NULL THEN
		varsubsql := varsubsql || ' AND E.ECNNO LIKE UPPER(''%' || varecn || '%'') ';
	END IF;

	IF varcar IS NOT NULL THEN
		varsubsql := varsubsql || ' AND E.PDM_MODELS LIKE UPPER(''%' || varcar || '%'') ';
	END IF;

	IF varundertake IS NOT NULL THEN
		varsubsql := varsubsql;
	END IF;
 /*      IF varSection IS NOT NULL THEN
        varSubSql := varSubSql || ' AND E.DES_UNITID LIKE UPPER(''' || varSection || '%'') ';
    END IF;
*/
 -- 取記錄數
	IF varsubsql IS NOT NULL THEN
		varsql := varsql || varsubsql;
	END IF;

	IF varorderby IS NOT NULL THEN
		varsql := varsql || varorderby;
	END IF;

	varcountsql := 'select count(*) from (' || varsql || ')';
	EXECUTE IMMEDIATE varcountsql INTO varcount;
	outrecordcount := to_char(varcount);
 --執行分頁查詢
 -- XX當每頁筆數大於 0 時, 才做分頁, 不大於0為匯出(Export)用
	varmaxrowno := to_number ( varpagesize ) * to_number ( varpageno );
	varminrowno := varmaxrowno - to_number ( varpagesize ) + 1;
	IF varpagesize > '0' THEN
		varsql := ' SELECT to_number(' || varpagesize || ') * (to_number(' || varpageno || ')-1)+rownum as no, B.* FROM (
                SELECT A.*, rownum rn FROM  (' || varsql || ') A
                    WHERE rownum <= ' || to_char(varmaxrowno) || ') B
            WHERE rn >=  ' || to_char(varminrowno) || ' order by no ';
	END IF;

	OPEN returnvalues FOR varsql;
EXCEPTION
	WHEN OTHERS THEN
		OPEN returnvalues FOR
		SELECT
			'ERR' id,
			'ERR' name
		FROM
			dual;
END;