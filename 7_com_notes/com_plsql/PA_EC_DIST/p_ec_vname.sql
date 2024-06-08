PROCEDURE P_EC_VNAME(
VAREID IN VARCHAR2, --ec_id
OUTRESULT OUT VARCHAR2
) IS
VID_LIST VARCHAR2(512);

VID VARCHAR2(512);

VNAME NVARCHAR2(512);

VNAME_LIST NVARCHAR2(512);

CNT INT;

-- 字串切割，有逗點者
CURSOR CUR_STRSPLIT2(V_STR VARCHAR2) IS

SELECT
    engineid AS str2
FROM
    TABLE(CAST(f_pub_split(v_str) AS mytabletype));

C_FIELD2 CUR_STRSPLIT2%ROWTYPE;

BEGIN
    SELECT
        e.vendor_list INTO vid_list
    FROM
        t_ec_info e
    WHERE
        e.ec_id=vareid;
    FOR c_field2 IN cur_strsplit2(vid_list) LOOP
        vid := c_field2.str2;
        SELECT
            COUNT(*) INTO cnt
        FROM
            t_anp_supplier sp
        WHERE
            sp.suppliercode=c_field2.str2;
        IF cnt > 0 THEN
            SELECT
                sp.suppliername INTO vname
            FROM
                t_anp_supplier sp
            WHERE
                sp.suppliercode=c_field2.str2;
            IF vname_list IS NULL THEN
                vname_list := vname;
            ELSE
                vname_list := vname_list||','||vname;
            END IF;
        END IF;
    END LOOP;

    IF vname_list IS NOT NULL THEN
        outresult := vname_list;
    END IF;
END p_ec_vname;