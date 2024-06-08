PROCEDURE P_EC_GETDISTUNIT(
VAREID IN INT --ec_id
, VARVID IN VARCHAR2 --廠商id, B141
, OUTRESULT OUT VARCHAR2
) IS

--  varIn varchar2(100);
CNT INT;

BEGIN
 --  varIn := varKey;
    IF varvid = '---' OR varvid IS NULL OR varvid = ' ' OR varvid = 'KD' THEN
        outresult := 'A'; --廠商ID異常
    ELSE
        cnt := 0;
        SELECT
            COUNT(*) INTO cnt
        FROM
            t_sys_glossary g
        WHERE
            g.glossarytypeid = 'A05-3'
            AND g.glossary3 = varvid; --SANYI
        IF cnt > 0 THEN
 --open returnVar for select 'S' from dual;
            outresult := 'S';
        ELSE
 --PEO: 依BD+廠商, 不管SOURCE
 --零技科: V1
            SELECT
                COUNT(*) INTO cnt
            FROM
                (
                    SELECT
                        e.ec_id,
                        e.add_dist,
                        p.bd
                    FROM
                        t_ec_info    e
                        LEFT JOIN t_ec_pl_info p
                        ON e.ec_id = p.ec_id
                )              ep,
                t_anp_supplier sup,
                t_sys_glossary g
            WHERE
                ep.ec_id = vareid
                AND g.glossarytypeid LIKE 'A01%' --五大模組BD
                AND substr(g.glossary3, 2) = varvid --B141
                AND sup.suppliercode = g.glossary3 --mB141
                AND ( (substr(ep.bd, 1, 6) = g.glossary2)
                OR (upper(ep.add_dist) LIKE '%PEO%') ); --cyc20170413:加入追加分發單位的判斷, ECN-1600809
 --AND p.YLRLSMAKER1 = varVid --B154, K->K會對不到
 --AND p.source = 'V' -- 設變K->K會對不到
 --AND p.level2 = '1'
 --AND p.ylrlsmaker1 = substr(g.glossary3, 2)
 --AND p.CHANGEMAKER = 'A'

 /*
            SELECT COUNT(*) INTO cnt FROM 
              (SELECT e.ec_id, e.add_dist, p.bd FROM T_EC_INFO e 
                 left join T_EC_PL_INFO p on e.ec_id = p.ec_id) ep
              ,T_ANP_SUPPLIER sup, T_SYS_GLOSSARY g 
            WHERE ep.ec_id = varEid
               AND g.glossarytypeid LIKE 'A01%' --五大模組BD
               AND substr(g.glossary3, 2) = varVid --B141
               AND sup.suppliercode = g.glossary3 --mB141
               AND  (substr(ep.bd, 1, 6) = g.glossary2);
*/
            IF cnt > 0 THEN
                outresult := 'P'; -- PEO
 -- varUnit為P(PEO)時, 該ECN在P_EC_PL_INFO有V件且2階以下(含)的記錄：
 -- 3.1 其他條件：當ECN調查廠商屬於上述的5個廠商時，但卻有不屬於上述的5個BD 或為V2...n 時(綠底)，設通單的調查廠商追加分發到零技科.
                SELECT
                    COUNT(*) INTO cnt
                FROM
                    t_ec_pl_info   p
                WHERE
                    p.ec_id = vareid
                    AND substr(p.bd, 1, 6) NOT IN (
                        SELECT
                            g.glossary2
                        FROM
                            t_sys_glossary g
                        WHERE
                            g.glossarytypeid LIKE 'A01%'
                    ) --五大模組BD
                    AND p.ylrlsmaker1 = varvid
                    AND (p.source = 'V'
                    AND p.level2 >= '2');
                IF cnt > 0 THEN
                    outresult := 'Q'; --追加分發零技科
                END IF;
            ELSE
                SELECT
                    COUNT(*) INTO cnt
                FROM
                    t_anp_supplier s
                WHERE
                    s.suppliercode = varvid
                    AND s.developer IS NOT NULL
                    AND s.developer <> ' ';
                IF cnt > 0 THEN
                    outresult := 'Y'; --YNTC一般廠商，零技科
                ELSE
                    outresult := 'B'; --not found for T_ANP_SUPPLIER
                END IF;
 /* 
              SELECT COUNT(*) INTO cnt FROM 
              (SELECT e.ec_id, e.add_dist, p.bd FROM T_EC_INFO e 
                 left join T_EC_PL_INFO p on e.ec_id = p.ec_id) ep
              ,T_ANP_SUPPLIER sup, T_SYS_GLOSSARY g 
              WHERE ep.ec_id = varEid
               AND g.glossarytypeid LIKE 'A01%' --五大模組BD
               AND substr(g.glossary3, 2) = varVid --B141
               AND sup.suppliercode = g.glossary3 --mB141
               AND UPPER(ep.add_dist) like '%PEO%';
               
               IF cnt > 0 THEN
                  OutResult := 'T'; --追加分發PEO
               END IF;
               */
            END IF;
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        outresult := 'C';
        dbms_output.put_line('err=' || sqlerrm);
END p_ec_getdistunit;