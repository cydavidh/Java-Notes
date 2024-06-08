CREATE OR REPLACE PROCEDURE "P_EC_CHGVENDOR_CHG" (
 /* 13-02 分發廠商調整List
    *
    */
    vartype IN VARCHAR2, --A=Add,C=Change
    varecid IN VARCHAR2, --EC ID
    varnewvid IN VARCHAR2, --新廠商ID
    outresult OUT VARCHAR2
) --操作結果0:成功；-1：保存失敗；大於0為ID
IS
    varlist    VARCHAR2(100);
    varnewvid2 VARCHAR2(100);
BEGIN
    varlist := vartype||varnewvid; --CI161,G155,SANY
    INSERT INTO t_ec_sql_log VALUES(
        sysdate,
        varlist,
        'P_EC_CHGVENDOR_CHG'
    );
    varnewvid2 := varnewvid;
    varlist := f_ec_supplierlist_chk(varnewvid2); --I161,G155,SANYI
    IF vartype = 'A' THEN
        UPDATE t_ec_info
        SET
            vendor_list = vendor_list||','||varlist,
            vendor_survey='Y'
        WHERE
            ec_id = varecid;
    ELSE
        IF vartype = 'C' THEN
            UPDATE t_ec_info
            SET
                vendor_list = varlist,
                vendor_survey='Y'
            WHERE
                ec_id = varecid;
        END IF;
    END IF;
 --資管承辦的待辦完成
    UPDATE t_sys_worklist
    SET
        comptime=sysdate
    WHERE
        comptime IS NULL
        AND worklistid IN (
            SELECT
                worklistid
            FROM
                t_ec_info
            WHERE
                ec_id = varecid
        );
 --重設為A04-1待處理
    UPDATE t_ec_info e
    SET
        status = 'A04-1',
        worklistid = NULL,
        e.modifyer='QLB00',
        e.modify_date=sysdate
    WHERE
        ec_id = varecid;
    COMMIT;
    pa_ec_dist.p_ec_disttakersurvey();
 --OutResult := '0';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        outresult := '-1';
        ROLLBACK;
END p_ec_chgvendor_chg;