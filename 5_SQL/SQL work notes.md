```sql
WITH TABLE_A AS (
select '1' as id, 'Jack' as name from dual union
select '2' as id, 'Albert' as name from dual union
select '3' as id, 'Will' as name from dual union
select '4' as id, 'Paula' as name from dual
),
TABLE_B AS (
select 'AA' as company_id, 'Paula' as name,'F' as gender, 52 as age from dual union
select 'YL' as company_id, 'Paula' as name,'F' as gender, 52 as age from dual union
select 'YN' as company_id, 'Jack' as name,'M' as gender, 37 as age from dual union
select 'YN' as company_id, 'Will' as name,'M' as gender, 30 as age from dual union
select 'SYSTEX' as company_id, 'Albert' as name,'M' as gender, 50 as age from dual
)
,
TABLE_C AS (
select 'YN' as company_id,'Yulon-Nissan Motor Co., Ltd' as company_name from dual union
select 'YL' as company_id,'Yulon Motor Co., Ltd' as company_name from dual union
select 'SYSTEX' as company_id,'SYSTEX Corporation' as company_name from dual
)
select * from table_a a 
right join table_b b on a.name = b.name
left join table_c c on b.company_id = c.company_id 

order by id
```
sql practice.


==================================================================================
PLM: gets the last login date and the number of login times in past year
wtuser to get all users that are not disabled
auditrecord to get all the login date and numbers
their common key is username in auditrecord and concatenating fullname+name+:Yulon-nissan in wtuser
--PLM���ıb�����m�W�B�u���B�̫�n������M�L�h�@�~�n�J����
--�H���������e���쪩��
SELECT 
    u.fullname AS �m�W,
    u.name AS �u��,
    MAX(a.eventtime) AS �̫�@���n�J���,
    COUNT(CASE WHEN a.eventtime >= sysdate - interval '1' year THEN a.eventtime END) AS �L�h�@�~�n�J����
FROM 
    wtuser u
LEFT JOIN 
    AUDITRECORD a ON u.fullname || ' (' || u.name || ': Yulon-Nissan)' = a.username
    AND a.eventkey = '*/wt.session.SessionUserAuditEvent/login'
WHERE 
    u.disabled = 0
GROUP BY 
    u.fullname, u.name

--�令���w�ɶ�����
SELECT u.fullname AS �m�W,
       u.name AS �u��,
       MAX(a.eventtime) AS �̫�@���n�J���,
       COUNT(a.eventtime) AS �L�h�@�~�n�J����
  FROM wtuser u
  LEFT JOIN (SELECT username, eventtime
               FROM AUDITRECORD
              WHERE eventkey = '*/wt.session.SessionUserAuditEvent/login'
                AND eventtime BETWEEN
                    TO_DATE('2024-05-06', 'yyyy-mm-dd') - INTERVAL '1' YEAR --�Цb��檺TO_DATE('2024-05-06'�^����J�@�˪�����C
                AND TO_DATE('2024-05-06', 'yyyy-mm-dd')) a
    ON u.fullname || ' (' || u.name || ': Yulon-Nissan)' = a.username
 WHERE u.disabled = 0
 GROUP BY u.fullname, u.name

==================================================================================
SELECT wtuser.name
     , wtuser.last
     , wfprocess.name          --�y�{�W��
     , wfassignedactivity.name --�ثe���d
     , wfprocess.UPDATESTAMPA2
     , wfprocess.CREATESTAMPA2 AS �y�{CREATE�ɶ�

  FROM workitem
     , wfassignedactivity
     , wfprocess
     , wtuser
 WHERE workitem.ida3a4 = wfassignedactivity.ida2a2
   AND wfassignedactivity.ida3parentprocessref = wfprocess.ida2a2
   AND wtuser.ida2a2 = workitem.ida3a2ownership
--and wfprocess.state = 'CLOSED_COMPLETED_EXECUTED'
   AND workitem.status <> 'COMPLETED'
   --AND wtuser.disabled = 0;
   AND wtuser.name IN ( 'DV003'
 );
==================================================================================

SELECT u.fullname AS �m�W,
       u.name AS �u��
    ,   MAX(a.eventtime) AS �̫�@���n�J���
    ,   COUNT(a.eventtime) AS �L�h�@�~�n�J����
    , process_count AS �b�~�y�{�ƶq
FROM wtuser u
  LEFT JOIN (SELECT username, eventtime
               FROM AUDITRECORD
              WHERE eventkey = '*/wt.session.SessionUserAuditEvent/login'
                AND eventtime BETWEEN
                    TO_DATE('2024-05-06', 'yyyy-mm-dd') - INTERVAL '1' YEAR --�Цb��檺TO_DATE('2024-05-06'�^����J�@�˪�����C
                AND TO_DATE('2024-05-06', 'yyyy-mm-dd')) a
    ON u.fullname || ' (' || u.name || ': Yulon-Nissan)' = a.username
LEFT JOIN
(SELECT wtuser.name
     , COUNT(*) AS process_count
  FROM workitem
     , wfassignedactivity
     , wfprocess
     , wtuser
 WHERE workitem.ida3a4 = wfassignedactivity.ida2a2
   AND wfassignedactivity.ida3parentprocessref = wfprocess.ida2a2
   AND wtuser.ida2a2 = workitem.ida3a2ownership
   AND workitem.status <> 'COMPLETED'
   GROUP BY wtuser.name
) b ON b.name = u.name
WHERE 
    u.disabled = 0
GROUP BY 
    u.fullname, u.name, process_count

==================================================================================
--PIS�����b¾���u�m�W�B���B¾��
SELECT e.emp_no as EMPLOYNO, decode(e.end_date,null,'Y','N') as INSERVICE, e.emp_name as name
     , e.emp_unit, d.dept_name, e.emp_title
FROM yl_employee  e
  LEFT JOIN yl_department d ON d.dept_no = e.emp_unit
 WHERE  decode(e.end_date, null, 'Y', 'N') = 'Y'
 ORDER BY e.emp_no;

====================================================================================================
