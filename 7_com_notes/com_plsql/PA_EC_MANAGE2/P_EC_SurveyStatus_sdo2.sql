PROCEDURE P_EC_SURVEYSTATUS_SDO(
VARSTEP IN NVARCHAR2,
VARKEYID IN NVARCHAR2, --ID
VARSTATUS IN NVARCHAR2, --New Status
VARUNDERTAKER IN NVARCHAR2,
OUTRESULT OUT VARCHAR2
) IS
VARNAME VARCHAR2(200);

VARPOSITIONNA VARCHAR2(200);

VARHISTNUM VARCHAR(3);

VARWKID VARCHAR2(200);

VARECNNO VARCHAR2(20);

VARVENDOR VARCHAR2(20);

VARLEADER VARCHAR2(20);

VARUT_UNITID VARCHAR2(10);

VARSURVEY_TAKER VARCHAR2(20);

VARRETURN_FLAG CHAR(1);

VARRETURN_FLAG_MSG NVARCHAR2(200);

VARSIGN_LIST CHAR(1);

VARSIGN_NOW CHAR(1);

VARRV CHAR(1);

VARSENDMAN VARCHAR2(20);

NEWWORKLISTID VARCHAR2(200);

VARDAYS INT;

VARUT_UNITNA VARCHAR2(30);

v_semail       varchar2(100);  --收件者

v_semail_na    varchar2(100);  --收件者姓名

v_ccmail       varchar2(500);  --副本

v_title        varchar2(100);  --主旨

v_body         varchar2(30000);  --內容1

VarContent     varchar2(32767);  --內容

VARRESULT VARCHAR2(10);

BEGIN
    IF (varstep = 'A09Send'
    OR varstep = 'A09Agree'
    OR varstep = 'A09Reject' ) THEN
 --取得簽核歷程用之姓名及職稱
        SELECT
            e.name,
            e.positionna INTO varname,
            varpositionna
        FROM
            t_sys_employinfo e
        WHERE
            e.employno = varundertaker;
 --取得簽核歷程用之流水號
        SELECT
            DISTINCT to_char(decode(s.sign_history, NULL, 1, substr(s.sign_history, 0, instr(s.sign_history, '.')-1)+1)),
            s.worklistid,
            i.ecnno,
            s.dist_vendor|| ' ' || sp.suppliername,
            s.sign_leader,
            s.ut_unitid,
            e.unitna,
            s.survey_taker,
            s.return_flag,
            s.sign_list,
            s.sign_now INTO varhistnum,
            varwkid,
            varecnno,
            varvendor,
            varleader,
            varut_unitid,
            varut_unitna,
            varsurvey_taker,
            varreturn_flag,
            varsign_list,
            varsign_now
        FROM
            t_ec_survey_info s
            JOIN t_ec_info i
            ON s.ec_id = i.ec_id
            JOIN t_anp_supplier sp
            ON s.dist_vendor = sp.suppliercode
            JOIN t_sys_employinfo e
            ON s.ut_unitid = e.unitid
        WHERE
            s.survey_id = varkeyid;
    END IF;

    CASE varstep
        WHEN 'A09LOAD' THEN --設通調查表填寫:將調查單狀態(t_ec_survey_info.status)由A06-1承辦未接收 改為 A06-2承辦處理。
            UPDATE t_ec_survey_info
            SET
                status = 'A06-2'
            WHERE
                survey_id = varkeyid;
        WHEN 'A09PARTSLIST' THEN --設通調查表-設變部品清單:將[設變部品清單閱讀狀態](t_ec_survey_info.parts_flag) 改為"Y"
            UPDATE t_ec_survey_info
            SET
                parts_flag = 'Y'
            WHERE
                survey_id = varkeyid;
        WHEN 'A09Send' THEN --設通調查表填寫(呈核簽核)
 --5.1.2  將調查表的狀態改為「A06-5填單-主管審核」
 --5.1.3  更新承辦完成日t_ec_survey_info.taker_sign_date、簽核歷程t_ec_survey_info.sign_history。
 --5.1.4 若LEADER有值，Sign_Now=0；若LEADER無值則Sign_Now=1
 --5.1.5 Sign_List依user所選的簽核主管層級(sign_level)來決定：科長為1、科長,副理為2、科長,副理,經理為3
            IF varreturn_flag = 'Y' THEN
                varreturn_flag_msg:=',重啟流程至資管科';
            ELSE
                varreturn_flag_msg:='.';
            END IF;
            UPDATE t_ec_survey_info
            SET
                status = 'A06-5',
                isalert = 'N',
                taker_sign_date = sysdate,
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 呈送簽核，意見：' || comment2 ||varreturn_flag_msg|| chr(
                    10
                ) || sign_history,
                sign_now = decode(
                    sign_leader,
                    NULL,
                    1,
                    0
                ),
                sign_list = decode(
                    sign_level,
                    '科長',
                    1,
                    decode(sign_level, '科長,副理', 2, decode(sign_level, '科長,副理,經理', 3, 0))
                )
            WHERE
                survey_id = varkeyid;
 --5.1.6 將承辦的待辦完成，產生下一關(若Leader有值則送給Leader，若Leader為空則送給調查單位之科主管)的待辦。
            pa_sys_worklist.p_worklist_complete(varwkid, varrv);
            IF varleader IS NOT NULL THEN
                varsendman := varleader;
            ELSE
 --select f_sys_employinfo_getleaderbyse(varUt_unitid) into varSendMan from dual;
                SELECT
                    substr(a.depusrid, 1, 6) INTO varsendman
                FROM
                    t_sys_leaderlayer a
                WHERE
                    id = varut_unitid;
            END IF;

            pa_sys_worklist.p_worklist_add(varsendman, --對象
            '13-02-01', --功能選單ID
            varecnno || ' ' || varvendor || ' 設通調查表請審核', --主旨
            varecnno || ' ' || varvendor || ' 設通調查表請審核', --內容
            newworklistid --成功:WorkListID;  失敗:-1
            );
            UPDATE t_ec_survey_info
            SET
                comment2 = '',
                worklistid = newworklistid
            WHERE
                survey_id = varkeyid;
        WHEN 'A09Agree' THEN --設通調查表填寫(同意)
 --5.2.2 更新簽核歷程t_ec_survey_info.sign_history
            UPDATE t_ec_survey_info
            SET
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 同意，意見： ' || comment2 || chr(
                    10
                ) || sign_history
            WHERE
                survey_id = varkeyid;
 --5.2.5 此關卡之待辦完成
            pa_sys_worklist.p_worklist_complete(varwkid, varrv);
            IF (varsign_list <> varsign_now) THEN -- 5.2.3 若非最後一關卡(Sign_List <>Sign_Now），呈送下一關卡進行審核。
 --5.2.3.1  Sign_Now = Sign_Now + 1
                varsign_now := varsign_now+1;
                UPDATE t_ec_survey_info
                SET
                    sign_now = varsign_now,
                    isalert = 'N'
                WHERE
                    survey_id = varkeyid;
 --5.2.3.2  下一關卡人員為取調查科別所屬T_SYS_LEADERLAYER的第幾N個工號(N即為T_EC_SURVEY_INFO.Sign_Now）
 --科長:substr(depusrid,0,6),副理:substr(depusrid,8,6),經理:substr(depusrid,15,6)
                SELECT
                    substr(depusrid, decode(varsign_now, 1, 0, decode(varsign_now, 2, 8, 15)), 6) INTO varsendman
                FROM
                    t_sys_leaderlayer
                WHERE
                    id = varut_unitid;
 --5.2.6 新增下一關卡待辦
                pa_sys_worklist.p_worklist_add(varsendman, --對象
                '13-02-01', --功能選單ID
                varecnno || ' ' || varvendor || ' 設通調查表請審核', --主旨
                varecnno || ' ' || varvendor || ' 設通調查表請審核', --內容
                newworklistid --成功:WorkListID;  失敗:-1
                );
                UPDATE t_ec_survey_info
                SET
                    comment2 = '',
                    worklistid = newworklistid
                WHERE
                    survey_id = varkeyid;
            ELSE --5.2.4 若為最後一關卡(Sign_List = Sign_Now）
 --5.2.4.1 若"重啟流程"為"否"時，將調查單狀態(t_ec_survey_info.status) 改為 「A06-A 廠商-待處理」，送交廠商進行調查。
 --5.2.4.2 若"重啟流程"為"是"時，經承辦確認設通單內容不符/圖面缺/不須廠商調查，主管"同意"後退回資管科進行轉下游會辦/重新分發處理
 --5.2.4.3  更新 廠商回覆逾期日(survey_vendor_date_expaired) 為系統日＋７(參數A08-3, GLOSSARY4)
                SELECT
                    to_number(glossary4) INTO vardays
                FROM
                    t_sys_glossary g
                WHERE
                    g.glossarytypeid = 'A08-3';
                UPDATE t_ec_survey_info
                SET
                    status = decode(
                        return_flag,
                        'N',
                        'A06-A',
                        'A06-9'
                    ),
                    comment2 = '',
                    survey_vendor_date_expaired = sysdate + vardays
                WHERE
                    survey_id = varkeyid;
 --重啟流程為是：5.2.4.2.1 將調查單狀態(t_ec_survey_info.status) 改為「A06-9 填單-資管科同意退回」、將設通單狀態(T_EC_INFO.status)更改為 A04-6廠商調查_退回
                IF varreturn_flag = 'Y' THEN
                    UPDATE t_ec_info
                    SET
                        status = 'A04-6'
                    WHERE
                        ec_id IN(
                            SELECT
                                ec_id
                            FROM
                                t_ec_survey_info
                            WHERE
                                survey_id = varkeyid
                        );
                    SELECT
                        g.glossary2 INTO varsendman
                    FROM
                        t_sys_glossary g
                    WHERE
                        g.glossarytypeid = 'A14-2';
 --5.2.4.2.2 新增資管科承辦(公用參數A14-2)待辦
                    pa_sys_worklist.p_worklist_add(varsendman, --對象
                    '13-02-08', --功能選單ID
                    varecnno || ' ' || varvendor || ' 設通調查表重啟流程，請確認', --主旨
                    varecnno || ' ' || varvendor || ' 設通調查表重啟流程，請確認', --內容
                    newworklistid --成功:WorkListID;  失敗:-1
                    );
                    UPDATE t_ec_info i
                    SET
                        i.worklistid = newworklistid
                    WHERE
                        ec_id IN(
                            SELECT
                                ec_id
                            FROM
                                t_ec_survey_info
                            WHERE
                                survey_id = varkeyid
                        );
 -- 發送Email給資管窗口 CC資管主管
 --資管窗口
                    SELECT
                        e.mailaddress,
                        e.name INTO v_semail,
                        v_semail_na
                    FROM
                        t_sys_employinfo e
                        INNER JOIN t_sys_glossary g
                        ON e.employno = g.glossary2
                    WHERE
                        g.glossarytypeid = 'A14-2'
                        AND e.inservice = 'Y';
 --資管主管

 /*           select e.mailaddress into v_ccmail
           from T_SYS_EMPLOYINFO e
           where e.unitid in (
                 select distinct e.unitid
                 from T_SYS_EMPLOYINFO e
                 inner join T_SYS_GLOSSARY g on e.employno = g.glossary2
                 where g.glossarytypeid = 'A14-2' and e.INSERVICE = 'Y' )
           and INSERVICE = 'Y' AND POSITIONTYPE <> 11 ;*/
                    v_title := '<退回通知>'|| varut_unitna ||'退回廠商或零件切換調查';
                    v_body := v_semail_na ||' 先生/小姐 您好：<br>' || varut_unitna || '退回設通單' || varecnno ||'，請進入設變調查e化系統執行EC>>管理>>「分發廠商調整」功能。';
                    varcontent := '<html><head></head><body><P>'|| v_body ||'</P></body></html>';
                    p_sys_mail_add(v_semail, v_ccmail, v_title, varcontent, '', 'Y', '', '', varresult);
                    IF varresult = '-1' THEN
                        ROLLBACK;
                        return;
                    END IF;
                ELSE --重啟流程為否
                    varsendman := substr(varvendor, 0, 4)||'2';
 --5.2.6 新增下一關卡廠商待辦
                    pa_sys_worklist.p_worklist_add(varsendman, --對象
                    '13-02-04', --功能選單ID
                    varecnno || ' ' || varvendor || ' 廠商調查表請填寫', --主旨
                    varecnno || ' ' || varvendor || ' 廠商調查表請填寫', --內容
                    newworklistid --成功:WorkListID;  失敗:-1
                    );
                    UPDATE t_ec_survey_info
                    SET
                        worklistid = newworklistid,
                        isalert = 'N'
                    WHERE
                        survey_id = varkeyid;
                END IF;
            END IF;
        WHEN 'A09Reject' THEN
 --設通調查表填寫(退回)
 --6-1. 將調查單狀態(t_ec_survey_info.status) 設為A06-6填單-主管退回承辦。
            UPDATE t_ec_survey_info s
            SET
                status = 'A06-6',
                isalert = 'N'
 --6-2. 更新簽核歷程t_ec_survey_info.sign_history
,
                sign_history = varhistnum ||'.' || to_char(
                    sysdate,
                    'yyyy/mm/dd HH24:MM:SS'
                ) || ' ' || varname || ' ' || varpositionna|| ' 退回，意見： ' || comment2 || chr(
                    10
                ) || sign_history
            WHERE
                survey_id = varkeyid;
 --6-3. 此關卡之待辦完成、新增下一關承辦待辦
            pa_sys_worklist.p_worklist_complete(varwkid, varrv);
            pa_sys_worklist.p_worklist_add(varsurvey_taker, --對象
            '13-02-01', --功能選單ID
            varecnno || ' ' || varvendor || ' 設通調查表被退回，請重新填寫', --主旨
            varecnno || ' ' || varvendor || ' 設通調查表被退回，請重新填寫', --內容
            newworklistid --成功:WorkListID;  失敗:-1
            );
            UPDATE t_ec_survey_info
            SET
                comment2 = '',
                worklistid = newworklistid
            WHERE
                survey_id = varkeyid;
        ELSE
            outresult := 'ok';
    END CASE;

    outresult := 'ok';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        outresult := sqlerrm;
END p_ec_surveystatus_sdo;