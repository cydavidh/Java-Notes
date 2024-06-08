SELECT a.ecnno,
       a.pdm_models,
       a.title,
       a.vendor_list_na,
       a.released_date,
       CASE
         WHEN a.unit = g1.modifycontent AND g1.glossarytypeid LIKE 'A05%' THEN
          g1.glossary1
         ELSE
          null
       END AS unit,
       TO_CHAR(a.sdate, 'YYYY/MM/DD') AS sdate,
       TO_CHAR(a.pdate, 'YYYY/MM/DD') AS pdate,
       TO_CHAR(a.rdate, 'YYYY/MM/DD') AS rdate,
       CASE
         WHEN a.status LIKE 'A18%' THEN
          g2.glossary2
         ELSE
          NULL
       END AS status

  FROM (SELECT i.ec_id,
               i.ecnno,
               i.pdm_models,
               i.title,
               j.vendor_list_na,
               i.released_date,
               j.unit,
               j.sdate,
               j.pdate,
               j.rdate,
               j.status
          FROM T_EC_INFO i
          JOIN T_EC_SUM j
            ON i.ec_id = j.ec_id) a
 inner JOIN t_Sys_Glossary g2
    ON a.status = g2.glossarytypeid
   AND g2.glossarytypeid LIKE 'A18%'
  JOIN t_Sys_Glossary g1
    ON a.unit = g1.modifycontent
   AND g1.glossarytypeid LIKE 'A05%'

 WHERE (a.released_date between to_date('2022-01-01', 'yyyy-MM-dd') and
       to_date('2022-12-31', 'yyyy-MM-dd'))
   and pdm_models = '21B'

-- we first join t_ec_info and t_ec_sum to get a table with both the model and the investigation dates.
-- then we join the table (investigation status, status) with the glossary g2 (id) to find out the status of the investigation (ongoing, completed)
-- then we join the above result (investigation unit code, unit) with the glossary g1(investigation unit code)
-- now we have a big table that joined the glossary twice, but that's ok. now we can replace the original (status) and (unit) with the glossary from the glossary table.