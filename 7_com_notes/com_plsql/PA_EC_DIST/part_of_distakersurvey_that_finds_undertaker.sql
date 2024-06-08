CNT := 0;

SELECT
    COUNT(*) INTO cnt
FROM
    t_anp_supplier   s
    INNER JOIN t_sys_employinfo e
    ON e.employno = s.developer
    INNER JOIN t_ec_info e2
    ON e2.ec_id = vareid
WHERE
    s.suppliercode LIKE varmtag
    AND e.unitid IN (
        SELECT
            g.glossary2
        FROM
            t_sys_glossary   g
        WHERE
            g.glossarytypeid IN ('A05-1', 'A05-2')
    )
    AND (s.des_grp = desgrp
    OR s.des_grp IS NULL)
    AND (s.bd_no IS NULL
    OR s.bd_no IN (
        SELECT
            substr(p.bd, 1, 6)
        FROM
            t_ec_pl_info     p
        WHERE
            p.ec_id = vareid
    )
    OR e2.add_dist LIKE '%PEO%')
    AND (s.model IS NULL
    OR instr(pdm_models, s.model) > 0)
    AND e.inservice = 'Y'
    AND ROWNUM <= 1;

IF CNT > 0 THEN

SELECT
    s.developer,
    e.unitid INTO undertake,
    ls_ut_unitid
FROM
    t_anp_supplier   s
    INNER JOIN t_sys_employinfo e
    ON e.employno = s.developer
    INNER JOIN t_ec_info e2
    ON e2.ec_id = vareid
WHERE
    s.suppliercode LIKE varmtag
    AND e.unitid IN (
        SELECT
            g.glossary2
        FROM
            t_sys_glossary   g
        WHERE
            g.glossarytypeid IN ('A05-1', 'A05-2')
    )
    AND (s.des_grp IS NULL
    OR s.des_grp = desgrp)
    AND (s.bd_no IS NULL
    OR s.bd_no IN (
        SELECT
            substr(p.bd, 1, 6)
        FROM
            t_ec_pl_info     p
        WHERE
            p.ec_id = vareid
    )
    OR e2.add_dist LIKE '%PEO%')
    AND (s.model IS NULL
    OR instr(pdm_models, s.model) > 0)
    AND e.inservice = 'Y'
    AND ROWNUM <= 1;

END IF;