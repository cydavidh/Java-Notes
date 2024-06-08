PROCEDURE P_EC_VENDORPARTSSAVE(
VARKEYID IN VARCHAR2, --ID
VAROLD_PART_STOCK IN VARCHAR2,
VAROLD_PART_NUMBER IN VARCHAR2,
VAROLD_PART_PD_CNT IN VARCHAR2,
VAROLD_PART_HALF_CNT IN VARCHAR2,
VARNEW_PART_MODEL IN VARCHAR2,
VARNEW_PART_CHK IN VARCHAR2,
VARNEW_PART_CLIP IN VARCHAR2,
VARNEW_PART_PRICE IN VARCHAR2,
VARNEW_PART_CHK_COST IN VARCHAR2,
VARNEW_PART_MODEL_COST IN VARCHAR2,
VARNEW_PART_CLIP_COST IN VARCHAR2,
VARSURVEY_MEMO IN VARCHAR2,
VARRUN_MODEL_DATE IN VARCHAR2,
VARRUN_SAMPLE_DATE IN VARCHAR2,
VARRUN_PD_DATE IN VARCHAR2,
OUTRESULT OUT VARCHAR2
) IS

BEGIN
    UPDATE t_ec_survey_parts sp
    SET
        old_part_stock = to_date(
            varold_part_stock,
            'YYYY/MM/DD'
        ),
        old_part_number = varold_part_number,
        old_part_pd_cnt = varold_part_pd_cnt,
        old_part_half_cnt = varold_part_half_cnt,
        new_part_model = varnew_part_model,
        new_part_chk = varnew_part_chk,
        new_part_clip = varnew_part_clip,
        new_part_price = varnew_part_price,
        new_part_chk_cost = varnew_part_chk_cost,
        new_part_model_cost = varnew_part_model_cost,
        new_part_clip_cost = varnew_part_clip_cost,
        survey_memo = varsurvey_memo,
        run_model_date = to_date(
            varrun_model_date,
            'YYYY/MM/DD'
        ),
        run_sample_date = to_date(
            varrun_sample_date,
            'YYYY/MM/DD'
        ),
        run_pd_date = to_date(
            varrun_pd_date,
            'YYYY/MM/DD'
        ),
        sp.modify_date=sysdate,
        sp.modifyer='vendor'
    WHERE
        sp.survey_parts_id = varkeyid;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
        ROLLBACK;
        outresult := sqlerrm;
END p_ec_vendorpartssave;