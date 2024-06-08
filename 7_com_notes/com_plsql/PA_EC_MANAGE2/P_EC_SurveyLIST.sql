procedure p_ec_surveylist

( varpagesize in varchar2, --每頁數量
varpageno in varchar2, --當前頁
varstep in varchar2,
varecn in varchar2, --ECN CO
varsurvey_id in varchar2, --Survey ID
varcar in varchar2, --車型
varsection in varchar2, --發行科別ID
varut_unitid in varchar2, --調查科別ID
varundertake in varchar2, --調查承辦ID(暫不用)
varuserid in varchar2, --登入者
varrole in varchar2, --角色:-1(科長以下),0(科長),1(科長以上),9(admin)
returnvalues out sys_refcursor,
outrecordcount out varchar2 --?記錄數
) is
 -- Sql
varsql varchar2(4000);

varsubsql varchar(1000);

varorderby varchar(500);

-- Page
varcountsql varchar2(4000);

varcount int;

varminrowno int;

varmaxrowno int;

begin
    varsql := ' SELECT DECODE(S.DIST_UNIT,''Y'',''零技科'',''P'',''PEO'',''S'',''三義工廠'') distUnitNA
        , S.SURVEY_TAKER AS undertakeID
        ,(SELECT P.NAME FROM T_SYS_EMPLOYINFO P WHERE P.EMPLOYNO=S.SURVEY_TAKER) undertakeNA
        ,(SELECT UNITNA FROM T_SYS_EMPLOYINFO EMP WHERE EMP.UNITID=S.UT_UNITID AND ROWNUM<=1) utUnitNA
        , E.DESIGNER, E.DES_UNITID as desGrp
        , (SELECT P2.name FROM T_SYS_EMPLOYINFO P2 WHERE P2.EMPLOYNO=E.designer) designerNA
        , (SELECT UNITNA FROM T_SYS_EMPLOYINFO EMP WHERE EMP.UNITID=E.DES_UNITID AND ROWNUM<=1) desGrpNA
        , S.DIST_VENDOR as vendorID
        , (SELECT V.SUPPLIERCODE || ''  '' || V.SUPPLIERNAME FROM T_ANP_SUPPLIER V WHERE V.SUPPLIERCODE=S.DIST_VENDOR AND ROWNUM<=1) vendorNA
        , TO_CHAR(E.released_date,''YYYY/MM/DD'') as releasedate
        , (select GLOSSARY1 from T_SYS_GLOSSARY where GLOSSARYTYPEID=S.status) as statusNA
        , (select NAME from T_SYS_EMPLOYINFO where EMPLOYNO=s.sign_leader) as sign_leaderNA
        , S.SURVEY_ID AS surveyID, E.ECNNO, E.PDM_MODELS, S.UT_UNITID, s.survey_title as title, S.status
        , case when s.status in (''A06-1'',''A06-2'',''A06-6'') then
         decode(s.COMMENT2,null,''呈請同意'',s.COMMENT2) ELSE decode(s.COMMENT2,null,'''',s.COMMENT2) end  as COMMENT2
        , s.RETURN_FLAG, s.sign_leader, s.sign_level
        , decode(e.adpt,''A09-G'',e.ADPT_OTHER_DATE,(select GLOSSARY1 from T_SYS_GLOSSARY where GLOSSARYTYPEID= e.adpt)) as adptNA
        , s.cd_cnt, e.dwg_cnt, s.content2, s.sign_history, s.parts_flag, s.YN_ATTACHID, s.VENDOR_ATTACHID
        ,(case when 1=1 then (select attachpath from t_sys_attach where t_sys_attach.attachid = s.YN_ATTACHID)end) as attachpath_Y
        ,(case when 1=1 then (select attach from t_sys_attach where t_sys_attach.attachid = s.YN_ATTACHID)end) as attachname_Y
        ,(case when 1=1 then (select attachpath from t_sys_attach where t_sys_attach.attachid = s.VENDOR_ATTACHID)end) as attachpath_V
        ,(case when 1=1 then (select attach from t_sys_attach where t_sys_attach.attachid = s.VENDOR_ATTACHID)end) as attachname_V
        , E.PDM_ECFILEID , E.PDM_ATTACHID
        ,(case when 1=1 then (select attachpath from t_sys_attach where t_sys_attach.attachid = E.PDM_ATTACHID)end) as attachpath_P
        ,(case when 1=1 then (select attach from t_sys_attach where t_sys_attach.attachid = E.PDM_ATTACHID)end) as attachname_P
      FROM T_EC_INFO E INNER JOIN T_EC_SURVEY_INFO S on S.EC_ID=E.EC_ID
      WHERE 1=1 ';
    case varstep
        when 'A09LIST' then
            varsql := varsql || ' and S.DIST_UNIT <> ''S'' ';
            case
                when varrole = '-1' then -- -1(科長以下)
                    select
                        count(*) into varcount --判斷是否為LEADER
                    from
                        t_sys_usergroup
                    where
                        groupid in (
                            select
                                groupid
                            from
                                t_sys_group
                            where
                                groupname = 'YNTC Leader'
                        )
                        and userid = varuserid;
                    if varcount = 0 then --不是LEADER
                        varsubsql := ' AND S.STATUS IN (''A06-1'',''A06-2'',''A06-6'') ';
                        varsubsql := varsubsql || ' AND S.SURVEY_TAKER = ''' || varuserid || ''' ';
                    else --是LEADER
                        varsubsql := ' AND ( ( S.STATUS IN  (''A06-1'',''A06-2'',''A06-6'') ';
                        varsubsql := varsubsql || ' AND S.SURVEY_TAKER = ''' || varuserid || ''') or ( ';
                        varsubsql := varsubsql || ' S.STATUS = ''A06-5'' ';
                        varsubsql := varsubsql || ' AND S.Sign_Now = ''0'' ';
                        varsubsql := varsubsql || ' AND S.Sign_Leader = ''' || varuserid || ''') )';
                    end if;
                when varrole = '0' then --varRole = 0(科長), Sign_Now = 1(Sign_Level簽核層級第1個),
                    varsubsql := ' AND S.STATUS = ''A06-5'' ';
                    varsubsql := varsubsql || ' AND S.Sign_Now = ''1''  ';
                    varsubsql := varsubsql || ' AND S.UT_UNITID = ''' || varut_unitid || '''';
                when varrole = '1' then --varRole = 1(科長以上), Sign_Now = 2(Sign_Level簽核層級第二個),Sign_Now = 3(Signoff_Level簽核層級第三個)
                    varsubsql := ' AND S.STATUS = ''A06-5'' ';
                    varsubsql := varsubsql || ' AND (( S.Sign_Now in (''1'', ''2'') AND S.UT_UNITID in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || '%''
                and depusrid not like ''%' || varuserid || ''' )) or ( S.Sign_Now = ''3'' AND S.UT_UNITID in (select id from t_sys_leaderlayer where depusrid like ''%' || varuserid || ''')))';
                when varrole = '9' then --varRole = 9(admin)
                    varsubsql := ' AND S.STATUS IN (''A06-1'',''A06-2'',''A06-6'',''A06-5'') ';
            end case;

            varsql := varsql || varsubsql;
            varorderby := ' ORDER BY releasedate ASC ';
        when 'A09LOAD' then
            varsql := varsql || ' AND s.survey_id = ' || varsurvey_id;
        when 'A11LOAD' then --cyc20170313:廠商檔案上傳用到.
            varsql := varsql || ' AND s.survey_id = ' || varsurvey_id;
        else
            open returnvalues for
                select
                    'NA' id,
                    'NA' name
                from
                    dual;
    end case;

    if varecn is not null then
        varsql := varsql || ' AND E.ECNNO LIKE UPPER(''%' || varecn || '%'') ';
    end if;

    if varcar is not null then
        varsql := varsql || ' AND E.PDM_MODELS LIKE UPPER(''%' || varcar || '%'') ';
    end if;

    if varsection is not null then
        varsql := varsql || ' AND E.DES_UNITID LIKE UPPER(''' || varsection || '%'') ';
    end if;
 /*
      IF varuserid IS NOT NULL THEN
         varSql := varSql || ' AND S.SURVEY_TAKER LIKE UPPER(''' || varuserid || '%'') ';
      END IF;
      IF varuserid IS NOT NULL THEN
         varSql := varSql || ' AND S.SURVEY_TAKER = (''' || varuserid || ''') ';
      END IF;
*/
 -- 取記錄數
    varcountsql := 'select count(*) from (' || varsql || ')';
    execute immediate varcountsql into varcount;
    outrecordcount := to_char(varcount);
 --執行分頁查詢
 -- XX當每頁筆數大於 0 時, 才做分頁, 不大於0為匯出(Export)用
    varmaxrowno := to_number(varpagesize) * to_number(varpageno);
    varminrowno := varmaxrowno - to_number(varpagesize) + 1;
    if varpagesize > '0' then
        varsql := 'SELECT to_number('||varpagesize||') * (to_number('||varpageno||')-1)+rownum as no,B.*
            FROM (
                   SELECT A.*, rownum rn
                   FROM  (' || varsql || varorderby || ') A
                   WHERE rownum <= ' || to_char(varmaxrowno) || ') B
             WHERE rn >= ' || to_char(varminrowno);
    end if;

    open returnvalues for varsql;
exception
    when others then
        open returnvalues for
        select
            'ERR' id,
            'ERR' name
        from
            dual;
end;