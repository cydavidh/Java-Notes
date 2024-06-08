procedure p_ec_disttakersurvey

/* 前置作業：plm的ec及pl轉入 t_ec_info, t_pl_info
     *   A04 廠商分發
     *     1. 提醒承辦開始調查
     *     2. 若不須廠商調查則直接進行零件切換調查(生管,行銷,零服)
     * @author cyc
    */
--   OutResult OUT VARCHAR --,0,儲存成功 --,-1,儲存失敗
as
vareid int;

vendor_list        varchar2(100); --G149,A101 廠商列表 ecn的廠商欄位有很多廠商,comma分隔

vendor_survey      varchar2(1); --Y OR N

undertake          varchar2(100); --承辦

vid                varchar2(12); --G149 廠商代號

i                  int; --用來追加分發零技科用

j int;

k int;

mday int;

li_wid int;

datacount1 number;

datacount2 number;

li_sid number;

cnt int;

cnt2_model int;

li_sp_cnt int;

survey_psrts_id number;

li_ssid number;

rtnwid varchar2(50);

rtnmid varchar2(50);

varunit            varchar2(1); --調查單位Y零技科，S三義，P:PEO

varunit2           varchar2(1); --追加分發零技科, Y OR ''

varmtag varchar2(10);

varstatus varchar2(10);

ls_ut_unitid varchar2(10);

model varchar2(10);

pdm_models varchar2(100);

ls_model varchar2(100);

title varchar2(500);

adpt varchar2(50);

--承揚：增加設計科承辦===============================================================
designer           varchar2(50); --設計科承辦

--======================================================================
desgrp             varchar2(50); --設計科別

varmail varchar2(250);

varmail2 varchar2(250);

varmail3 varchar2(250);

varng_vendordev varchar2(1024);

varng_novendorid varchar2(1024);

varng_vendoridnot4 varchar2(1024);

varng_nomodel varchar2(1024);

varng_msg varchar2(2024);

varng_vendor varchar2(2024);

varsp varchar2(512);

varsignlist int;

varsignlevel nvarchar2(250);

varecnno char(11);

varvendor nvarchar2(10);

varpl_vid          nvarchar2(10); --比對PL上的VID

vname_list nvarchar2(1024);

vname nvarchar2(50);

varutname nvarchar2(50);

var_released_date date;

varsqlerrm nvarchar2(2000);

li_ssunit int;

-- 1. 抓取待分發的EC清單，STATUS:A04-1待處理；vendor_list:分發廠商, ex: B154,G149
cursor ec_info_list is

select
    ec_id,
    ecnno,
    vendor_list,
    vendor_survey,
    title,
    pdm_models,
    designer,
    des_unitid,
    released_date,
    e.adpt
from
    t_ec_info e
where
    e.status = 'A04-1' --AND e.vendor_survey='Y'
 -- and ecnno in ('ECN-2100431')
 --e.released_date=to_date('20170220','YYYYMMDD')
 --e.ecnno='ECN-1701159'
 --e.ecnno In ('ECN-1700064','ECN-1700054','ECN-1700069')
 --VENDOR_LIST LIKE '%SANYI%'
order by
    ec_id asc;

-- 字串切割，有逗點者
cursor cur_strsplit(
v_str varchar2
) is

select
    engineid as str2
from
    table(cast(f_pub_split(v_str) as mytabletype));

c_field cur_strsplit%rowtype;

-- 字串切割，有逗點者
cursor cur_strsplit2(
v_str varchar2
) is

select
    engineid as str2
from
    table(cast(f_pub_split(v_str) as mytabletype));

c_field2 cur_strsplit2%rowtype;

--該EC的零件清單, V:local件, A:設變後或新增的零件
--20161103:第一次先傳vid進來比對，第二次傳vid=%
--varUnit: P, Y

/* 20210712:若沒有零件清單時，會取pl_id=0,
      所以 T_EC_pl_info要有一筆資料 pl_id=0, ec_id=0,chagemaker='A',  partno='NA',partname='無設變件號'),
      所有沒有件號的ECN都可以正常發給三義工廠
    */
cursor cur_ec_parts(
ecid int,
vid varchar2,
varunit varchar2
) is

select
    pl_id
from
    t_ec_pl_info   p
where
    (ec_id = ecid
    or vid = 'NA')
    and p.changemaker = 'A'
    and (varunit = 'Y'
    and p.source in ('V', 'R')
    or (varunit = 'P'
    and p.bd in (
        select
            g.glossary2
        from
            t_sys_glossary g
        where
            g.glossarytypeid like 'A01%'
    ))
    or (varunit = 'S'
    and (p.source in ('V', 'R')
    or vid = 'NA')))
    and (vid <> '%'
    and p.ylrlsmaker1 = vid
    or vid = '%'
    and p.ylrlsmaker1 is null
    or vid = 'NA'
    and p.pl_id = 0)
order by
    pl_id asc;

p_field cur_ec_parts%rowtype;

--該SURVEY的零件清單(零技或PEO用)

/*    CURSOR cur_survey_parts(sid int) IS
      SELECT pl_id FROM T_EC_survey_info s INNER JOIN P_EC_survey_parts sp on s.survey_id=sp.survey_id
      WHERE s.survey_id = sid;
    sp_field cur_survey_parts%ROWTYPE;*/
--該SURVEY的零件清單(SANYI用)

/*    CURSOR cur_survey_parts_sanyi(sid int) IS
      SELECT pl_id FROM T_EC_survey_info s INNER JOIN P_EC_sanyi si on s.survey_id=si.survey_id_fk
        INNER JOIN P_EC_survey_parts sp on si.survey_id_fk=sp.survey_id
      WHERE s.survey_id = sid;
    ss_field cur_survey_parts_sanyi%ROWTYPE;*/
--車系承辦a
cursor cur_model_taker(
mid2 varchar2
) is

/*SELECT S377_UNDERTAKER, S391_UNDERTAKER, PAINT_UNDERTAKER, BODY_UNDERTAKER, MODE_UNDERTAKER, PD_MG_TAKER
                              FROM t_anp_model
                              WHERE model = mid2 OR (mid2='ALL' AND model='EC');*/
select
    (
        select
            t.undertaker
        from
            t_anp_model_other t
        where
            (t.model = mid2
            or (mid2 = 'ALL'
            and model = 'EC'))
            and typeid = 'A02-1'
    ) as s377_undertaker,
    (
        select
            t.undertaker
        from
            t_anp_model_other t
        where
            (t.model = mid2
            or (mid2 = 'ALL'
            and model = 'EC'))
            and typeid = 'A02-2'
    ) as s391_undertaker,
    (
        select
            t.undertaker
        from
            t_anp_model_other t
        where
            (t.model = mid2
            or (mid2 = 'ALL'
            and model = 'EC'))
            and typeid = 'A02-3'
    ) as paint_undertaker,
    (
        select
            t.undertaker
        from
            t_anp_model_other t
        where
            (t.model = mid2
            or (mid2 = 'ALL'
            and model = 'EC'))
            and typeid = 'A02-4'
    ) as body_undertaker,
    (
        select
            t.undertaker
        from
            t_anp_model_other t
        where
            (t.model = mid2
            or (mid2 = 'ALL'
            and model = 'EC'))
            and typeid = 'A02-5'
    ) as mode_undertaker,
    (
        select
            t.undertaker
        from
            t_anp_model_other t
        where
            (t.model = mid2
            or (mid2 = 'ALL'
            and model = 'EC'))
            and typeid = 'A10-3'
    ) as pd_mg_taker
from
    dual;

m_field cur_model_taker%rowtype;

--抓雙承辦

/*CURSOR cur_dup_taker(varmTag VARCHAR2, desgrp VARCHAR2, varEid int, vid VARCHAR2, PDM_MODELS VARCHAR2) IS
      --IF left(varmTag,1)='m' THEN varmTag := SUBSTR(varmTag,2,4);
      SELECT S.DEVELOPER, E.unitid
      FROM T_ANP_SUPPLIER S INNER JOIN T_SYS_EMPLOYINFO E ON E.employno = S.DEVELOPER
      WHERE S.SUPPLIERCODE LIKE varmTag AND E.unitid IN (SELECT g.GLOSSARY2 FROM T_SYS_GLOSSARY g WHERE g.GLOSSARYTYPEID in ('A05-1','A05-2') )
         AND (S.DES_GRP IS NULL OR S.DES_GRP = desgrp)
         AND (S.BD_NO IS NULL OR S.BD_NO IN (SELECT SUBSTR(P.BD, 1, 6) FROM T_EC_PL_INFO P WHERE P.EC_ID = varEid AND P.SOURCE = 'V' AND (P.YLRLSMAKER1 LIKE varmTag or P.YLRLSMAKER1=vid)) )
         AND (S.MODEL IS NULL OR INSTR(PDM_MODELS, S.MODEL) > 0)
         AND E.INSERVICE='Y'
         AND ROWNUM <= 1;
    dup_field cur_dup_taker%ROWTYPE;*/
begin
    select
        f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-2',
        2)) into varmail
    from
        dual; --資管科窗口
    select
        f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-9',
        2)) into varmail2
    from
        dual; --ISC
    varng_msg := ''; --分發異常通知信
    varsp := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
 --大loop，開始一個一個ecn去loop
    for ec_info in ec_info_list loop
        vareid := ec_info.ec_id;
        vendor_list := ec_info.vendor_list;
        vendor_survey := ec_info.vendor_survey;
        pdm_models := ec_info.pdm_models;
        title := ec_info.title;
 --承揚：增加設計科承辦==========================================================================================
        desinger := ec_info.designer;
 --=======================================================================================
        desgrp := ec_info.des_unitid;
        varecnno := ec_info.ecnno;
        adpt := ec_info.adpt;
        var_released_date := ec_info.released_date;
        varng_vendordev := ':'; --廠商開發承辦有問題
        varng_novendorid := ':'; --無此廠商代碼
        varng_vendoridnot4 := ':'; --廠商代碼長度<>4
        varng_nomodel := ':'; --車型未設定
        varng_vendor := ':'; --調查廠商ng
 --要分發廠商
        if vendor_survey = 'Y' then
 --這段是在改赤色手配管控日期
            if vendor_list is null or vendor_list = ' ' then
                varng_vendor := varng_vendor || varecnno || ', ';
            end if;

            if adpt = 'A09-F' then
 --赤色手配  Red Release
                select
                    f_sys_glossary_getnamebyfield('A08-2',
                    '2') into mday
                from
                    dual; --赤色手配管控日期, 3天
            else
                select
                    f_sys_glossary_getnamebyfield('A08-3',
                    '2') into mday
                from
                    dual; --一般調查單管控日期, 14天
            end if;
 --抓名字，比較不重要
            p_ec_vname(vareid, vname_list); --抓取裕器,東陽
 --先loop廠商
            for c_field in cur_strsplit(vendor_list) loop
 --如果是sanyi就設定變數為三義工廠
 --如果名字四個字又不是三義工廠就寫錯誤訊息之類
                if c_field.str2 = '三義工廠' or c_field.str2 = 'SANYI' then
                    vid := 'SANYI';
                elsif (length(c_field.str2) <> 4
                and c_field.str2 <> 'SANYI') then
 --含KD,---
                    varng_vendoridnot4 := varng_vendoridnot4 || c_field.str2 || ', ';
                    vid := '---';
                end if;

                if (length(c_field.str2) = 4
                and c_field.str2 <> '三義工廠') then
                    vid := c_field.str2;
                    datacount1 := 0;
                    select
                        count(*) into datacount1
                    from
                        t_anp_supplier
                    where
                        suppliercode = vid;
                    if datacount1 = 0 then
                        varng_novendorid := varng_novendorid || vid || ', ';
 --EXIT WHEN datacount1 = 0;  --cyc20171127: KD,G154 run full
                    end if;
                end if;
 --這個procedure用來判斷調查單位的
                varunit2 := '';
                p_ec_getdistunit(vareid, vid, varunit); -- Y, P, S, Q, A(---,''), B(not found), C(ERR) --抓取調查單位
 --如果需要追加就是Q
                if varunit = 'Q' then
                    varunit2 := 'Y'; --追加分發零技科在一個
                    varunit := 'P';
                end if;

                if varunit = 'Y' or varunit = 'S' or varunit = 'P' then
                    i := 1;
                    if varunit2 = 'Y' then
                        j := 2; --追加分發零技科
                    else
                        j := 1;
                    end if;

                    loop
                        undertake := '';
                        ls_ut_unitid := '';
                        li_wid := 0;
                        li_sid := 0;
                        select
                            count(*) --是否已存在設通調查表
                            into li_sid
                        from
                            t_ec_survey_info s
                        where
                            s.ec_id = vareid
                            and s.dist_unit = varunit
                            and s.dist_vendor = vid;
                        if 1 = 1 or li_sid = 0 then
                            if li_sid > 0 then
 --如果已經存在設同調查表的話
                                select
                                    s.survey_id into li_sid
                                from
                                    t_ec_survey_info s
                                where
                                    s.ec_id = vareid
                                    and s.dist_unit = varunit
                                    and s.dist_vendor = vid;
 --如果調查單位不是三義工廠
                                if varunit <> 'S' then
                                    rtnwid := 0;
 --檢查是否存在待辦項目
                                    select
                                        count(*) into rtnwid
                                    from
                                        t_sys_worklist w
                                    where
                                        w.userid = (
                                            select
                                                s.survey_taker
                                            from
                                                t_ec_survey_info s
                                            where
                                                s.survey_id = li_sid
                                        )
                                        and w.tittle like '%' || varecnno || '%設通調查表請填寫'
                                        and rownum <= 1;
 --如果已經存在代辦項目
                                    if rtnwid > 0 then
                                        select
                                            w.worklistid into rtnwid --將代辦項目的ID儲存進RTNWID變數
                                        from
                                            t_sys_worklist w
                                        where
                                            w.userid = (
                                                select
                                                    s.survey_taker
                                                from
                                                    t_ec_survey_info s
                                                where
                                                    s.survey_id = li_sid
                                            )
                                            and w.tittle like '%' || varecnno || '%設通調查表請填寫'
                                            and rownum <= 1;
 --更新調查表狀態以及調查表的代辦項目id欄位
                                        update t_ec_survey_info s
                                        set
                                            s.status = 'A06-1',
                                            s.worklistid = rtnwid
                                        where
                                            s.survey_id = li_sid
                                            and (s.status = 'A06-7'
                                            or s.status = 'A06-9'); --資管再轉回調查單位
                                        update t_sys_worklist w -- 更新調查表的完成時間
                                        set
                                            w.comptime = null
                                        where
                                            w.worklistid = rtnwid;
 --====================================================================================================
 -- 20240521 承揚：零技科設計科變更
 -- 如果調查單位是 Y 更新待辦事項為設計科承辦，更新調查表為承辦和設計科別
 -- 更新 t_ec_survey_info for column: survey_taker and ut_unitid
 -- 更新 t_sys_worklist for the userid.
                                        if varunit = y then
                                            update t_sys_worklist --更新待辦項目為設計科承辦
                                            set
                                                userid = designer,
                                            where
                                                worklistid = rtnwid;
                                            update t_ec_survey_info --更新調查表調查單位和承辦
                                            set
                                                survey_taker = designer,
                                                ut_unitid = desgrp
                                            where
                                                survey_id = li_sid;
                                        end if;
 --===============================================================================
                                    end if;
                                end if;
                            end if;
 --如果調查單位是三義工廠
                            if varunit = 'S' then
                                varunit := 'S';
                                undertake := 'SANYI';
                                ls_ut_unitid := 'SANYI';
                                varstatus := 'A06-D'; --設變調查狀態：確認-承辦待處理
 --如果調查單位不是三義工廠
 --=================================================================================================
                            elsif varunit = 'P' then
                                varstatus := 'A06-1'; --設變調查狀態：填單－承辦待處理
                                varmtag := 'm' || vid || '%';
 --=================================================================================================
 --雙承辦，EX:裕器，依設計科別、BD、車系指定不同承辦, 取一位
 --20170628:not must chk bd for pl list 必須要檢查bd
 --20170921:EC.ADD_DIST LIKE PEO
 --20240521 承揚：下面這段是抓承辦或者雙承辦（單承辦就（IS NULL) ，雙的話就指定）
 --現在新的ecn清單裡面會多一個必須要增加分發單位給peo，而不需要用不屬於五大模組的bd號碼來判斷
 --現在裕器其實也沒有雙承辦了，目前db裡t_anp_supplier裡面承辦窗口就一個而已
                                cnt := 0;
                                select
                                    count(*) into cnt
                                from
                                    t_anp_supplier s
                                    inner join t_sys_employinfo e
                                    on e.employno = s.developer
                                    inner join t_ec_info e2
                                    on e2.ec_id = vareid
                                where
                                    s.suppliercode like varmtag
                                    and e.unitid in (
                                        select
                                            g.glossary2
                                        from
                                            t_sys_glossary g
                                        where
                                            g.glossarytypeid in ('A05-1', 'A05-2')
                                    ) --設變調查單位 零技科 PEO
                                    and (s.des_grp = desgrp
                                    or --科別
                                    s.des_grp is null)
                                    and (s.bd_no is null
                                    or --BD
                                    s.bd_no in (
                                        select
                                            substr(p.bd,
                                            1,
                                            6)
                                        from
                                            t_ec_pl_info p
                                        where
                                            p.ec_id = vareid
                                    )
                                    or e2.add_dist like '%PEO%')
                                    and (s.model is null
                                    or instr(pdm_models, s.model) > 0) --車系
                                    and e.inservice = 'Y' --在職
                                    and rownum <= 1;
                                if cnt > 0 then
                                    select
                                        s.developer,
                                        e.unitid into undertake,
                                        ls_ut_unitid
                                    from
                                        t_anp_supplier s
                                        inner join t_sys_employinfo e
                                        on e.employno = s.developer
                                        inner join t_ec_info e2
                                        on e2.ec_id = vareid
                                    where
                                        s.suppliercode like varmtag
                                        and e.unitid in (
                                            select
                                                g.glossary2
                                            from
                                                t_sys_glossary g
                                            where
                                                g.glossarytypeid in ('A05-1', 'A05-2')
                                        )
                                        and (s.des_grp is null
                                        or s.des_grp = desgrp)
                                        and (s.bd_no is null
                                        or s.bd_no in (
                                            select
                                                substr(p.bd,
                                                1,
                                                6)
                                            from
                                                t_ec_pl_info p
                                            where
                                                p.ec_id = vareid
                                        )
                                        or e2.add_dist like '%PEO%')
                                        and (s.model is null
                                        or instr(pdm_models, s.model) > 0)
                                        and e.inservice = 'Y'
                                        and rownum <= 1;
                                end if;
 --承揚：如果調查單位為設計科，設定承辦為設計者================================================================================================
 --在t_sys_glossay新增了設計科的簽核層級。
                            elsif varunit = 'Y' then
                                varstatus := 'A06-1';
                                undertake := designer;
                                ls_ut_unitid := desgrp; --因爲有五科，爲了統一設定所以在t_sys_glossary内設定設計五科的Glossary3為Y
                            end if;
 --==================================================================================================================
                            if undertake is null then
                                select
                                    s.developer into undertake
                                from
                                    t_anp_supplier s
                                where
                                    s.suppliercode = vid;
                                if undertake is null then
                                    undertake := '空的!';
                                end if;

                                varng_vendordev := varng_vendordev || varmtag || ', ';
 --如果承辦undertake不是null的話
                            else
                                if undertake = 'SANYI' then --如果是sanyi的話就先暫時不抓簽核層級，之後再抓。
                                    li_wid := 0;
                                    varsignlist := '';
                                    varsignlevel := '';
                                else
                                    select
                                        s.suppliername into varvendor
                                    from
                                        t_anp_supplier s
                                    where
                                        s.suppliercode = vid;
                                    select
                                        g.glossary4,
                                        g.glossary1 into varsignlist,
                                        varsignlevel --抓取簽核List數、簽核層級
                                    from
                                        t_sys_glossary g
                                    where
                                        g.glossarytypeid like 'A11%'
                                        and g.glossary2 = 'Y' --正在使用中的簽核層級，否為'N'
                                        and (g.glossary3 = ls_ut_unitid --對應科別零技orPEO
                                        or g.glossary3 = (
                                            select
                                                e.departmentid
                                            from
                                                t_sys_employinfo e
                                            where
                                                e.unitid = ls_ut_unitid
                                                and rownum <= 1
                                        ));
                                end if;
 --確認是否已經存在設通調查表
                                li_sid := 0;
                                select
                                    count(*) into li_sid
                                from
                                    t_ec_survey_info s
                                where
                                    s.ec_id = vareid
                                    and s.dist_unit = varunit
                                    and s.dist_vendor = vid;
 --如果不存在設通調查表
                                if li_sid = 0 then
                                    li_wid := null;
 --如果承辦不是三義工廠
                                    if undertake <> 'SANYI' then
                                        pa_sys_worklist.p_worklist_add(undertake, --新增承辦待辦事項
                                        '13-02-01', varecnno || ' ' || vid || varvendor || ' 設通調查表請填寫', --主旨
                                        varecnno || ' ' || vid || varvendor || ' 設通調查表請填寫', --內容
                                        rtnwid);
                                        li_wid := to_number(rtnwid);
                                    end if;

                                    select
                                        s_t_ec_survey_info.nextval into li_sid
                                    from
                                        dual;
 -- 新增P_EC_SURVEY_INFO記錄(varUnit為Y 或 P 或 S皆要新增)
                                    insert into t_ec_survey_info (
                                        survey_id,
                                        ec_id,
                                        dist_unit,
                                        dist_vendor,
                                        survey_taker,
                                        survey_vendor_sdate,
                                        survey_vendor_pdate,
                                        status,
                                        worklistid,
                                        ut_unitid,
                                        sign_level,
                                        sign_list,
                                        creater,
                                        create_date,
                                        modifyer,
                                        modify_date,
                                        survey_title,
                                        sign_history
                                    ) values (
                                        li_sid,
                                        vareid,
                                        varunit,
                                        vid,
                                        undertake,
                                        sysdate,
                                        sysdate + mday,
                                        varstatus,
                                        li_wid,
                                        ls_ut_unitid,
                                        varsignlevel,
                                        varsignlist,
                                        'SYS',
                                        sysdate,
                                        'SYS',
                                        sysdate,
                                        title,
                                        ''
                                    );
                                else
                                    li_sid := 0;
                                    select
                                        s.survey_id　 --檢查存在設通調查表
                                        into li_sid
                                    from
                                        t_ec_survey_info s
                                    where
                                        s.ec_id = vareid
                                        and s.dist_unit = varunit
                                        and s.dist_vendor = vid;
 --如果存在設通調查表
                                    if li_sid > 0 then
 --檢查存在待辦項目
                                        li_wid := 0;
                                        select
                                            count(*) into li_wid
                                        from
                                            t_sys_worklist t
                                        where
                                            t.worklistid in (
                                                select
                                                    s.worklistid
                                                from
                                                    t_ec_survey_info s
                                                where
                                                    s.survey_id = li_sid
                                            )
                                            and menuid = '13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
 --如果存在代辦項目
                                        if li_wid > 0 then
                                            update t_sys_worklist t --更新待辦項目
                                            set
                                                t.userid = undertake,
                                                t.comptime = null
                                            where
                                                t.worklistid in (
                                                    select
                                                        s.worklistid
                                                    from
                                                        t_ec_survey_info s
                                                    where
                                                        s.survey_id = li_sid
                                                )
                                                and menuid = '13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
                                        else
                                            pa_sys_worklist.p_worklist_add(undertake, --新增待辦項目
                                            '13-02-01', varecnno || ' ' || vid || varvendor || ' 設通調查表請填寫.', --主旨
                                            varecnno || ' ' || vid || varvendor || ' 設通調查表請填寫.', --內容
                                            rtnwid);
                                            li_wid := to_number(rtnwid);
                                            update t_ec_survey_info s
                                            set
                                                s.worklistid = rtnwid
                                            where
                                                s.survey_id = li_sid;
                                        end if;
                                        update t_ec_survey_info s --更新設通調查表承辦以及狀態
                                        set
                                            s.survey_taker = undertake,
                                            s.status = 'A06-1', --填單 承辦待處理
                                            s.return_flag = 'N',
                                            s.isalert = 'N' -- A06-9 -> A06-1
                                        where
                                            s.survey_id = li_sid;
                                    end if;
                                end if;
 -- 新增P_EC_SUM記錄(survey), 統計用, vendor是該調查單位各自的廠商
                                cnt := 0;
                                select
                                    count(*) into cnt
                                from
                                    t_ec_sum s
                                where
                                    s.report_type = 'S'
                                    and s.ec_id = vareid
                                    and s.unit = varunit;
                                select
                                    sp.suppliername into vname
                                from
                                    t_anp_supplier sp
                                where
                                    sp.suppliercode = vid;
                                if undertake <> 'SANYI' then
                                    select
                                        e.name into varutname
                                    from
                                        t_sys_employinfo e
                                    where
                                        e.employno = undertake;
                                    vname := vname || '(' || varutname || ')';
                                end if;

                                if cnt > 0 then
                                    update t_ec_sum s
                                    set
                                        s.vendor_list_na = s.vendor_list_na || ',' || vname,
                                        s.vendor_list_id = s.vendor_list_id || ',' || vid
                                    where
                                        s.report_type = 'S'
                                        and s.ec_id = vareid
                                        and s.unit = varunit
                                        and not s.vendor_list_id like '%' || vid || '%';
                                else
                                    insert into t_ec_sum (
                                        report_type,
                                        ec_id,
                                        unit,
                                        vendor_list_id,
                                        vendor_list_na,
                                        status,
                                        sdate,
                                        pdate,
                                        creater,
                                        create_date,
                                        modifyer,
                                        modify_date
                                    ) values (
                                        'S',
                                        vareid,
                                        varunit,
                                        vid,
                                        vname,
                                        'A18-1',
                                        sysdate,
                                        sysdate + mday,
                                        'SYS',
                                        sysdate,
                                        'SYS',
                                        sysdate
                                    );
                                end if;

                                commit;
                            end if;
                        else
                            select
                                survey_id into li_sid
                            from
                                t_ec_survey_info s
                            where
                                s.ec_id = vareid
                                and s.dist_unit = varunit
                                and s.dist_vendor = vid;
                        end if;

                        if li_sid > 0 then
 --exists survey
 --新增P_EC_SURVEY_PARTS
                            varpl_vid := vid;
                            for k in 1 .. 3 loop
                                cnt := 0;
                                for p_field in cur_ec_parts(vareid, varpl_vid, varunit) loop
 --V件,changemake=A
                                    cnt := 1;
                                    ls_model := '';
                                    li_sp_cnt := 0;
                                    if varunit <> 'S' then
                                        ls_model := 'EC';
                                        li_sp_cnt := 1;
                                    else
                                        ls_model := pdm_models;
                                        li_sp_cnt := 5; --SANYI五組
                                    end if;

                                    for c_field2 in cur_strsplit2(ls_model) loop
 --各車系loop
                                        model := c_field2.str2;
                                        cnt2_model := 0;
                                        for m_field in cur_model_taker(model) loop
 --抓取車系承辦
                                            cnt2_model := 1;
                                            for i in 1 .. li_sp_cnt loop
                                                if varunit = 'S' then
                                                    case i
                                                        when 1 then
                                                            undertake := m_field.s377_undertaker; --K0L00
                                                        when 2 then
                                                            undertake := m_field.s391_undertaker; --K0Q00 動力生技組
                                                        when 3 then
                                                            undertake := m_field.paint_undertaker; --K0K00
                                                        when 4 then
                                                            undertake := m_field.body_undertaker; --K0J00
                                                        when 5 then
                                                            undertake := m_field.mode_undertaker; --K0R00 壓造生技組
                                                    end case;
                                                end if;

                                                li_ssid := 0;
                                                if undertake is not null and varunit = 'S' then --如果調查單位是三義工廠的話
                                                    select
                                                        count(*) into li_ssunit
                                                    from
                                                        t_sys_glossary g
                                                    where
                                                        g.glossarytypeid like 'A02%'
                                                        and g.glossary3 = i
                                                        and g.state = 'Y';
                                                    if li_ssunit > 0 then
                                                        select
                                                            glossary2 into ls_ut_unitid
                                                        from
                                                            t_sys_glossary g
                                                        where
                                                            g.glossarytypeid like 'A02%'
                                                            and g.glossary3 = i
                                                            and g.state = 'Y';
                                                        select
                                                            count(*) --查看有沒有待辦事項
                                                            into li_ssid
                                                        from
                                                            t_ec_sanyi si
                                                        where
                                                            si.survey_id_fk = li_sid
                                                            and si.sanyi_unit = ls_ut_unitid
                                                            and si.car = model; --不用承辦，可能會換
                                                        if li_ssid = 0 then
                                                            pa_sys_worklist.p_worklist_add(undertake, --新增三義承辦待辦事項
                                                            '13-02-06', '填寫' || varecnno || '廠商調查通知單(SANYI)', '填寫' || varecnno || '廠商調查通知單(SANYI)', rtnwid);
                                                            li_wid := to_number(rtnwid);
                                                            select
                                                                s_t_ec_sanyi.nextval into li_ssid
                                                            from
                                                                dual;
                                                            select
                                                                g.glossary4, --新增簽核層級
                                                                g.glossary1 into varsignlist,
                                                                varsignlevel
                                                            from
                                                                t_sys_glossary g
                                                            where
                                                                g.glossarytypeid like 'A11%'
                                                                and g.glossary2 = 'Y'
                                                                and (g.glossary3 = ls_ut_unitid
                                                                or g.glossary3 = (
                                                                    select
                                                                        e.departmentid
                                                                    from
                                                                        t_sys_employinfo e
                                                                    where
                                                                        e.unitid = ls_ut_unitid
                                                                        and rownum <= 1
                                                                ));
                                                            insert into t_ec_sanyi --新增三義工廠調查表
                                                            (
                                                                ss_id,
                                                                ec_id_fk,
                                                                survey_id_fk,
                                                                sanyi_unit,
                                                                car,
                                                                undertaker,
                                                                worklistid,
                                                                status,
                                                                sign_level,
                                                                sign_list,
                                                                creater,
                                                                create_date,
                                                                modifyer,
                                                                modify_date
                                                            ) values (
                                                                li_ssid,
                                                                vareid,
                                                                li_sid,
                                                                ls_ut_unitid,
                                                                model,
                                                                undertake,
                                                                li_wid,
                                                                'A06-D',
                                                                varsignlevel,
                                                                varsignlist,
                                                                'SYS',
                                                                sysdate,
                                                                'SYS',
                                                                sysdate
                                                            );
                                                        else
                                                            select
                                                                si.ss_id into li_ssid
                                                            from
                                                                t_ec_sanyi si
                                                            where
                                                                si.survey_id_fk = li_sid
                                                                and si.sanyi_unit = ls_ut_unitid
                                                                and si.car = model;
                                                        end if;
 --INSERT INTO P_EC_SANYI_UNIT
                                                        datacount2 := 0;
                                                        select
                                                            count(*) into datacount2
                                                        from
                                                            t_ec_sanyi_unit si
                                                        where
                                                            si.survey_id_fk2 = li_sid
                                                            and si.sanyi_unit2 = ls_ut_unitid;
                                                        if datacount2 = 0 then
                                                            insert into t_ec_sanyi_unit (
                                                                survey_id_fk2,
                                                                sanyi_unit2,
                                                                sign_history
                                                            ) values (
                                                                li_sid,
                                                                ls_ut_unitid,
                                                                ''
                                                            );
                                                        end if;
                                                    end if; -- end of "IF li_ssunit > 0 THEN"
                                                end if;

                                                if varunit <> 'S' or varunit = 'S' and li_ssid > 0 then
 --找不到承辦時ssid會為0
 --varpl_id := 86789;
                                                    datacount2 := 0; --處理P_EC_survey_parts
                                                    select
                                                        count(*) into datacount2
                                                    from
                                                        t_ec_survey_parts p
                                                    where
                                                        p.survey_id = li_sid
                                                        and p.pl_id = p_field.pl_id
                                                        and p.ss_id_fk = li_ssid;
                                                    if datacount2 = 0 then
                                                        select
                                                            s_t_ec_survey_parts.nextval into survey_psrts_id
                                                        from
                                                            dual;
 -- 依適用車系產生多筆記錄，各車型承辦請參照A14要件-車型承辦sheet
                                                        insert into t_ec_survey_parts (
                                                            survey_parts_id,
                                                            ec_id,
                                                            survey_id,
                                                            pl_id,
                                                            ss_id_fk,
                                                            creater,
                                                            create_date,
                                                            modifyer,
                                                            modify_date
                                                        ) values (
                                                            survey_psrts_id,
                                                            vareid,
                                                            li_sid,
                                                            p_field.pl_id,
                                                            li_ssid,
                                                            'SYS',
                                                            sysdate,
                                                            'SYS',
                                                            sysdate
                                                        );
                                                    end if;
                                                end if;
                                            end loop;
                                        end loop;

                                        if cnt2_model = 0 then
 --車型檔抓不到資料
                                            varng_nomodel := varng_nomodel || ls_model || ', ';
                                        end if;
                                    end loop;

                                    commit;
                                end loop; --新增P_EC_SURVEY_PARTS
                                if k = 1 and cnt = 0 then
 --by廠商,無V件.
                                    varpl_vid := '%';
                                end if;

                                if k = 2 and cnt = 0 then
 --此ecn無V件.
                                    varpl_vid := 'NA'; --跑第3次，新增NA件號
                                    select
                                        count(*) into cnt
                                    from
                                        t_ec_survey_info s
                                    where
                                        s.survey_id = li_sid
                                        and (s.sign_history is not null);
                                    if cnt = 1 then
 --history有值, 避免重跑把值蓋掉
                                        update t_ec_survey_info s
                                        set
                                            s.sign_history = s.sign_history || '，' || to_char(
                                                sysdate,
                                                'yyyy/mm/dd HH24:MM:SS'
                                            ) || ' SYS:此ECN無零件' || chr(
                                                10
                                            )
                                        where
                                            s.survey_id = li_sid; -- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
                                    else
                                        update t_ec_survey_info s
                                        set
                                            s.sign_history = '1.' || to_char(
                                                sysdate,
                                                'yyyy/mm/dd HH24:MM:SS'
                                            ) || ' SYS:此ECN無零件' || chr(
                                                10
                                            )
                                        where
                                            s.survey_id = li_sid; -- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
                                    end if;
                                end if;
                            end loop; -- k=1 to 3
                            commit;
                        else
                            i := 3; -- exit
                        end if; --IF li_sid > 0 THEN
                        i := i + 1;
                        if varunit2 = 'Y' then
                            varunit := 'Y'; --追加分發零技科
                        end if;

                        exit when i > j;
                    end loop;
                else
 -- <> Y P S
                    if varunit = 'A' then
 --IF varVid = '---' OR varVid IS NULL OR varVid = ' ' OR varVid = 'KD'THEN
                        varng_novendorid := varng_novendorid || vid || ', ';
                    else
                        if varunit = 'B' then
 --廠商ID在t_anp_supplier找不到時開發承辦找不到
                            varng_vendordev := varng_vendordev || vid || ', ';
                        end if;
                    end if;
                end if;
            end loop; -- for vendor_list
            if varng_vendordev = ':' and varng_novendorid = ':' and varng_vendoridnot4 = ':' and varng_nomodel = ':' and varng_vendor = ':' then
                update t_ec_info e
                set
                    e.status = 'A04-2'
                where
                    e.ec_id = vareid
                    and e.status = 'A04-1'; --廠商調查中
            else
                varng_msg := varng_msg || '<BR>' || varsp || varecnno || '：';
                if varng_vendordev <> ':' then
                    varng_msg := varng_msg || '<BR>' || varsp || varsp || ' ANPQP-廠商對照開發承辦錯誤' || substr(varng_vendordev, 1, length(varng_vendordev) - 2);
                end if;

                if varng_novendorid <> ':' then
                    varng_msg := varng_msg || '<BR>' || varsp || varsp || ' 廠商ID在ANPQP系統未設定' || varng_novendorid;
                end if;

                if varng_vendoridnot4 <> ':' then
                    varng_msg := varng_msg || '<BR>' || varsp || varsp || ' 廠商ID長度<>4' || substr(varng_vendoridnot4, 1, length(varng_vendoridnot4) - 2);
                end if;

                if varng_nomodel <> ':' then
                    varng_msg := varng_msg || '<BR>' || varsp || varsp || ' 車型未設定' || substr(varng_nomodel, 1, length(varng_nomodel) - 2);
                    select
                        f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-3',
                        2)) into varmail3
                    from
                        dual; --零管科窗口
                    varmail := varmail || ',' || varmail3;
                end if;

                varng_msg := varng_msg || '<BR>';
                update t_ec_info e
                set
                    e.status = 'A04-6',
                    e.worklistid = 0
                where
                    e.ec_id = vareid; --廠商調查_退回
            end if;
        else
 --不分發，直接轉切換調查
            if vendor_survey = 'N' and (vendor_list is not null
            or vendor_list <> ' ') and instr('KD,kd,---', vendor_list) = 0 then
                varng_vendor := varng_vendor || varecnno || ', ';
                varng_msg := varng_msg || '<BR>' || varsp || ' 廠商調查FLAG與LIST不一致' || substr(varng_vendor, 1, length(varng_vendor) - 2) || ',' || varsp || vendor_survey || ',' || varsp || vendor_list || '<BR>';
                update t_ec_info e
                set
                    e.status = 'A04-6',
                    e.worklistid = 0
                where
                    e.ec_id = vareid; --廠商調查_退回
            else
                p_ec_add_chg_info(vareid, title, pdm_models);
            end if;
        end if;

        commit;
    end loop; --FOR ec_info IN ec_info_list LOOP
    if varng_msg is not null then
        varng_msg := '<html><body>您好!：' || varng_msg || '</html></body>';
        p_sys_mail_add(varmail, varmail2, 'ESS【異常提醒】設變調查e化-廠商分發', varng_msg, '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
 --P_SYS_Mail_Add('515873', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
 --P_SYS_Mail_Add('A14-9,2', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
        select
            f_sys_glossary_getnamebyfield('A14-2',
            2) into undertake
        from
            dual; --資管科窗口 920286
        pa_sys_worklist.p_worklist_add(undertake, '13-02-08', '【異常提醒】設變調查e化-廠商分發', --主旨
        '【異常提醒】設變調查e化-廠商分發', --內容
        rtnwid);
        li_wid := to_number(rtnwid);
        update t_sys_worklist w
        set
            w.comptime = sysdate
        where
            w.worklistid in (
                select
                    e.worklistid
                from
                    t_ec_info e
                where
                    e.status = 'A04-6'
                    and e.worklistid = 0
            );
        update t_ec_info e
        set
            e.worklistid = li_wid
        where
            e.status = 'A04-6'
            and e.worklistid = 0;
    end if;

    commit;
    p_ec_status_cal(); --調查/切換, 會辦中狀態改為逾期
    commit;
 --OutResult := '0';
exception
    when others then
        rollback;
 --OutResult := '-1';
        varsqlerrm := sqlerrm;
        dbms_output.put_line('err=' || varsqlerrm);
end p_ec_disttakersurvey;

if li_sid > 0 then
 --如果存在設通調查表
    li_wid := 0;
    select
        count(*) --檢查存在待辦項目
        into li_wid
    from
        t_sys_worklist t
    where
        t.worklistid in (
            select
                s.worklistid
            from
                t_ec_survey_info s
            where
                s.survey_id = li_sid
        )
        and menuid = '13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
    if li_wid > 0 then
 --如果存在代辦項目
        update t_sys_worklist t --更新待辦項目
        set
            t.userid = undertake,
            t.comptime = null
        where
            t.worklistid in (
                select
                    s.worklistid
                from
                    t_ec_survey_info s
                where
                    s.survey_id = li_sid
            )
            and menuid = '13-02-01'; --13-02-01承辦填單  13-02-04廠商回覆
    else
        pa_sys_worklist.p_worklist_add(undertake, --新增待辦項目
        '13-02-01', varecnno || ' ' || vid || varvendor || ' 設通調查表請填寫.', --主旨
        varecnno || ' ' || vid || varvendor || ' 設通調查表請填寫.', --內容
        rtnwid);
        li_wid := to_number(rtnwid);
        update t_ec_survey_info s
        set
            s.worklistid = rtnwid
        where
            s.survey_id = li_sid;
    end if;
    update t_ec_survey_info s --更新設通調查表承辦以及狀態
    set
        s.survey_taker = undertake,
        s.status = 'A06-1', --填單 承辦待處理
        s.return_flag = 'N',
        s.isalert = 'N' -- A06-9 -> A06-1
    where
        s.survey_id = li_sid;
end if;
end if;
 -- 新增P_EC_SUM記錄(survey), 統計用, vendor是該調查單位各自的廠商
cnt := 0;
select
    count(*) into cnt
from
    t_ec_sum s
where
    s.report_type = 'S'
    and s.ec_id = vareid
    and s.unit = varunit;
select
    sp.suppliername into vname
from
    t_anp_supplier sp
where
    sp.suppliercode = vid;
if undertake <> 'SANYI' then
    select
        e.name into varutname
    from
        t_sys_employinfo e
    where
        e.employno = undertake;
    vname := vname || '(' || varutname || ')';
end if;

if cnt > 0 then
    update t_ec_sum s
    set
        s.vendor_list_na = s.vendor_list_na || ',' || vname,
        s.vendor_list_id = s.vendor_list_id || ',' || vid
    where
        s.report_type = 'S'
        and s.ec_id = vareid
        and s.unit = varunit
        and not s.vendor_list_id like '%' || vid || '%';
else
    insert into t_ec_sum (
        report_type,
        ec_id,
        unit,
        vendor_list_id,
        vendor_list_na,
        status,
        sdate,
        pdate,
        creater,
        create_date,
        modifyer,
        modify_date
    ) values (
        'S',
        vareid,
        varunit,
        vid,
        vname,
        'A18-1',
        sysdate,
        sysdate + mday,
        'SYS',
        sysdate,
        'SYS',
        sysdate
    );
end if;

commit;
end if;
else
    select
        survey_id into li_sid
    from
        t_ec_survey_info s
    where
        s.ec_id = vareid
        and s.dist_unit = varunit
        and s.dist_vendor = vid;
end if;
if li_sid > 0 then
 --exists survey
 --新增P_EC_SURVEY_PARTS
    varpl_vid := vid;
    for k in 1 .. 3 loop
        cnt := 0;
        for p_field in cur_ec_parts(vareid, varpl_vid, varunit) loop
 --V件,changemake=A
            cnt := 1;
            ls_model := '';
            li_sp_cnt := 0;
            if varunit <> 'S' then
                ls_model := 'EC';
                li_sp_cnt := 1;
            else
                ls_model := pdm_models;
                li_sp_cnt := 5; --SANYI五組
            end if;

            for c_field2 in cur_strsplit2(ls_model) loop
 --各車系loop
                model := c_field2.str2;
                cnt2_model := 0;
                for m_field in cur_model_taker(model) loop
 --抓取車系承辦
                    cnt2_model := 1;
                    for i in 1 .. li_sp_cnt loop
                        if varunit = 'S' then
                            case i
                                when 1 then
                                    undertake := m_field.s377_undertaker; --K0L00
                                when 2 then
                                    undertake := m_field.s391_undertaker; --K0Q00 動力生技組
                                when 3 then
                                    undertake := m_field.paint_undertaker; --K0K00
                                when 4 then
                                    undertake := m_field.body_undertaker; --K0J00
                                when 5 then
                                    undertake := m_field.mode_undertaker; --K0R00 壓造生技組
                            end case;
                        end if;

                        li_ssid := 0;
                        if undertake is not null and varunit = 'S' then --如果調查單位是三義工廠的話
                            select
                                count(*) into li_ssunit
                            from
                                t_sys_glossary g
                            where
                                g.glossarytypeid like 'A02%'
                                and g.glossary3 = i
                                and g.state = 'Y';
                            if li_ssunit > 0 then
                                select
                                    glossary2 into ls_ut_unitid
                                from
                                    t_sys_glossary g
                                where
                                    g.glossarytypeid like 'A02%'
                                    and g.glossary3 = i
                                    and g.state = 'Y';
                                select
                                    count(*) --查看有沒有待辦事項
                                    into li_ssid
                                from
                                    t_ec_sanyi si
                                where
                                    si.survey_id_fk = li_sid
                                    and si.sanyi_unit = ls_ut_unitid
                                    and si.car = model; --不用承辦，可能會換
                                if li_ssid = 0 then
                                    pa_sys_worklist.p_worklist_add(undertake, --新增三義承辦待辦事項
                                    '13-02-06', '填寫' || varecnno || '廠商調查通知單(SANYI)', '填寫' || varecnno || '廠商調查通知單(SANYI)', rtnwid);
                                    li_wid := to_number(rtnwid);
                                    select
                                        s_t_ec_sanyi.nextval into li_ssid
                                    from
                                        dual;
                                    select
                                        g.glossary4, --新增簽核層級
                                        g.glossary1 into varsignlist,
                                        varsignlevel
                                    from
                                        t_sys_glossary g
                                    where
                                        g.glossarytypeid like 'A11%'
                                        and g.glossary2 = 'Y'
                                        and (g.glossary3 = ls_ut_unitid
                                        or g.glossary3 = (
                                            select
                                                e.departmentid
                                            from
                                                t_sys_employinfo e
                                            where
                                                e.unitid = ls_ut_unitid
                                                and rownum <= 1
                                        ));
                                    insert into t_ec_sanyi --新增三義工廠調查表
                                    (
                                        ss_id,
                                        ec_id_fk,
                                        survey_id_fk,
                                        sanyi_unit,
                                        car,
                                        undertaker,
                                        worklistid,
                                        status,
                                        sign_level,
                                        sign_list,
                                        creater,
                                        create_date,
                                        modifyer,
                                        modify_date
                                    ) values (
                                        li_ssid,
                                        vareid,
                                        li_sid,
                                        ls_ut_unitid,
                                        model,
                                        undertake,
                                        li_wid,
                                        'A06-D',
                                        varsignlevel,
                                        varsignlist,
                                        'SYS',
                                        sysdate,
                                        'SYS',
                                        sysdate
                                    );
                                else
                                    select
                                        si.ss_id into li_ssid
                                    from
                                        t_ec_sanyi si
                                    where
                                        si.survey_id_fk = li_sid
                                        and si.sanyi_unit = ls_ut_unitid
                                        and si.car = model;
                                end if;
 --INSERT INTO P_EC_SANYI_UNIT
                                datacount2 := 0;
                                select
                                    count(*) into datacount2
                                from
                                    t_ec_sanyi_unit si
                                where
                                    si.survey_id_fk2 = li_sid
                                    and si.sanyi_unit2 = ls_ut_unitid;
                                if datacount2 = 0 then
                                    insert into t_ec_sanyi_unit (
                                        survey_id_fk2,
                                        sanyi_unit2,
                                        sign_history
                                    ) values (
                                        li_sid,
                                        ls_ut_unitid,
                                        ''
                                    );
                                end if;
                            end if; -- end of "IF li_ssunit > 0 THEN"
                        end if;

                        if varunit <> 'S' or varunit = 'S' and li_ssid > 0 then
 --找不到承辦時ssid會為0
 --varpl_id := 86789;
                            datacount2 := 0; --處理P_EC_survey_parts
                            select
                                count(*) into datacount2
                            from
                                t_ec_survey_parts p
                            where
                                p.survey_id = li_sid
                                and p.pl_id = p_field.pl_id
                                and p.ss_id_fk = li_ssid;
                            if datacount2 = 0 then
                                select
                                    s_t_ec_survey_parts.nextval into survey_psrts_id
                                from
                                    dual;
 -- 依適用車系產生多筆記錄，各車型承辦請參照A14要件-車型承辦sheet
                                insert into t_ec_survey_parts (
                                    survey_parts_id,
                                    ec_id,
                                    survey_id,
                                    pl_id,
                                    ss_id_fk,
                                    creater,
                                    create_date,
                                    modifyer,
                                    modify_date
                                ) values (
                                    survey_psrts_id,
                                    vareid,
                                    li_sid,
                                    p_field.pl_id,
                                    li_ssid,
                                    'SYS',
                                    sysdate,
                                    'SYS',
                                    sysdate
                                );
                            end if;
                        end if;
                    end loop;
                end loop;

                if cnt2_model = 0 then
 --車型檔抓不到資料
                    varng_nomodel := varng_nomodel || ls_model || ', ';
                end if;
            end loop;

            commit;
        end loop; --新增P_EC_SURVEY_PARTS
        if k = 1 and cnt = 0 then
 --by廠商,無V件.
            varpl_vid := '%';
        end if;

        if k = 2 and cnt = 0 then
 --此ecn無V件.
            varpl_vid := 'NA'; --跑第3次，新增NA件號
            select
                count(*) into cnt
            from
                t_ec_survey_info s
            where
                s.survey_id = li_sid
                and (s.sign_history is not null);
            if cnt = 1 then
 --history有值, 避免重跑把值蓋掉
                update t_ec_survey_info s
                set
                    s.sign_history = s.sign_history || '，' || to_char(
                        sysdate,
                        'yyyy/mm/dd HH24:MM:SS'
                    ) || ' SYS:此ECN無零件' || chr(
                        10
                    )
                where
                    s.survey_id = li_sid; -- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
            else
                update t_ec_survey_info s
                set
                    s.sign_history = '1.' || to_char(
                        sysdate,
                        'yyyy/mm/dd HH24:MM:SS'
                    ) || ' SYS:此ECN無零件' || chr(
                        10
                    )
                where
                    s.survey_id = li_sid; -- AND S.SIGN_HISTORY NOT LIKE '%此ECN無零件%';
            end if;
        end if;
    end loop; -- k=1 to 3
    commit;
else
    i := 3; -- exit
end if; --IF li_sid > 0 THEN
i := i + 1;
if varunit2 = 'Y' then
    varunit := 'Y'; --追加分發零技科
end if;

exit when i > j;
end loop;
else
 -- <> Y P S
    if varunit = 'A' then
 --IF varVid = '---' OR varVid IS NULL OR varVid = ' ' OR varVid = 'KD'THEN
        varng_novendorid := varng_novendorid || vid || ', ';
    else
        if varunit = 'B' then
 --廠商ID在t_anp_supplier找不到時開發承辦找不到
            varng_vendordev := varng_vendordev || vid || ', ';
        end if;
    end if;
end if;
end loop; -- for vendor_list
if varng_vendordev = ':' and varng_novendorid = ':' and varng_vendoridnot4 = ':' and varng_nomodel = ':' and varng_vendor = ':' then
    update t_ec_info e
    set
        e.status = 'A04-2'
    where
        e.ec_id = vareid
        and e.status = 'A04-1'; --廠商調查中
else
    varng_msg := varng_msg || '<BR>' || varsp || varecnno || '：';
    if varng_vendordev <> ':' then
        varng_msg := varng_msg || '<BR>' || varsp || varsp || ' ANPQP-廠商對照開發承辦錯誤' || substr(varng_vendordev, 1, length(varng_vendordev) - 2);
    end if;

    if varng_novendorid <> ':' then
        varng_msg := varng_msg || '<BR>' || varsp || varsp || ' 廠商ID在ANPQP系統未設定' || varng_novendorid;
    end if;

    if varng_vendoridnot4 <> ':' then
        varng_msg := varng_msg || '<BR>' || varsp || varsp || ' 廠商ID長度<>4' || substr(varng_vendoridnot4, 1, length(varng_vendoridnot4) - 2);
    end if;

    if varng_nomodel <> ':' then
        varng_msg := varng_msg || '<BR>' || varsp || varsp || ' 車型未設定' || substr(varng_nomodel, 1, length(varng_nomodel) - 2);
        select
            f_sys_employinfo_getmail3byno(f_sys_glossary_getnamebyfield('A14-3',
            2)) into varmail3
        from
            dual; --零管科窗口
        varmail := varmail || ',' || varmail3;
    end if;

    varng_msg := varng_msg || '<BR>';
    update t_ec_info e
    set
        e.status = 'A04-6',
        e.worklistid = 0
    where
        e.ec_id = vareid; --廠商調查_退回
end if;
else
 --不分發，直接轉切換調查
    if vendor_survey = 'N' and (vendor_list is not null
    or vendor_list <> ' ') and instr('KD,kd,---', vendor_list) = 0 then
        varng_vendor := varng_vendor || varecnno || ', ';
        varng_msg := varng_msg || '<BR>' || varsp || ' 廠商調查FLAG與LIST不一致' || substr(varng_vendor, 1, length(varng_vendor) - 2) || ',' || varsp || vendor_survey || ',' || varsp || vendor_list || '<BR>';
        update t_ec_info e
        set
            e.status = 'A04-6',
            e.worklistid = 0
        where
            e.ec_id = vareid; --廠商調查_退回
    else
        p_ec_add_chg_info(vareid, title, pdm_models);
    end if;
end if;
commit;
end loop; --FOR ec_info IN ec_info_list LOOP
if varng_msg is not null then
    varng_msg := '<html><body>您好!：' || varng_msg || '</html></body>';
    p_sys_mail_add(varmail, varmail2, 'ESS【異常提醒】設變調查e化-廠商分發', varng_msg, '', 'Y', '', '', rtnmid); --成功:MailID;  失敗:-1
 --P_SYS_Mail_Add('515873', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
 --P_SYS_Mail_Add('A14-9,2', '', 'ESS【異常提醒】設變調查e化-廠商分發', varNg_Msg, '', 'Y', '', '', rtnMid);  --成功:MailID;  失敗:-1
    select
        f_sys_glossary_getnamebyfield('A14-2',
        2) into undertake
    from
        dual; --資管科窗口 920286
    pa_sys_worklist.p_worklist_add(undertake, '13-02-08', '【異常提醒】設變調查e化-廠商分發', --主旨
    '【異常提醒】設變調查e化-廠商分發', --內容
    rtnwid);
    li_wid := to_number(rtnwid);
    update t_sys_worklist w
    set
        w.comptime = sysdate
    where
        w.worklistid in (
            select
                e.worklistid
            from
                t_ec_info e
            where
                e.status = 'A04-6'
                and e.worklistid = 0
        );
    update t_ec_info e
    set
        e.worklistid = li_wid
    where
        e.status = 'A04-6'
        and e.worklistid = 0;
end if;

commit;
p_ec_status_cal(); --調查/切換, 會辦中狀態改為逾期
commit;
 --OutResult := '0';
exception
    when others then
        rollback;
 --OutResult := '-1';
        varsqlerrm := sqlerrm;
        dbms_output.put_line('err=' || varsqlerrm);
end p_ec_disttakersurvey;