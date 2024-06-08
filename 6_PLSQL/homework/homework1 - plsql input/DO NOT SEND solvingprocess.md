請使用解答附件寫一個PL/SQL新增INPUT” 設通編號”、 ”廠商”、  ” 車系    ”、 ” 發行時間”、 ” 車系  ”、 ” 廠商調查狀態 ”、 ” 廠商調查單位 ”、 ” 零件切換調查狀態 ”、” 零件切換資訊單位 “   查詢AND條件
==============================================================
解答附件：
```sql
select ecnno,models,title,suppliername,released_date,unitname,survey_vendor_sdate, survey_vendor_pdate,survey_vendor_edate,survey_status
from(
SELECT DISTINCT A.EC_ID,
decode(report_type,NULL,'S',report_type) AS report_type
      ,A.pdm_EcFileID,A.ECNNO, A.PDM_MODELS MODELS, A.TITLE
      , M.VENDOR_LIST_NA as SUPPLIERNAME, TO_CHAR(A.RELEASED_DATE,'YYYY/MM/DD') RELEASED_DATE,
             S.GLOSSARY1 as Unitname,
             TO_CHAR(M.sdate,'YYYY/MM/DD') SURVEY_VENDOR_SDATE,
             TO_CHAR(M.pdate,'YYYY/MM/DD') SURVEY_VENDOR_PDATE,
             TO_CHAR(M.rdate,'YYYY/MM/DD') SURVEY_VENDOR_EDATE,
             S1.GLOSSARY2 SURVEY_STATUS
         FROM T_EC_INFO A
         
         Left JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = 'S'
         LEFT JOIN T_SYS_GLOSSARY S  ON  S.GLOSSARYTYPEID LIKE 'A05-%' AND  S.MODIFYCONTENT  = M.UNIT
                  LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE 'A18-%' AND S1.GLOSSARYTYPEID = M.status
                  where 1=1 
                  
                  and A.RELEASED_DATE between date '2022-01-01' and date '2022-12-31' 
                  
                  and A.PDM_MODELS like '%21B%')
```

====================================================================
這份作業看起來是要求你使用 PL/SQL 寫一個查詢，條件是給定了多個欄位，你需要根據這些欄位來篩選出符合條件的資料。

你需要做的事情是根據提供的解答附件中的 SQL 查詢，將其轉換成一個 PL/SQL 的程式，讓它能夠接收輸入，然後根據輸入的條件進行資料查詢。

這個 PL/SQL 程式需要接受以下輸入：

設通編號 (ECNNO)
廠商 (SUPPLIERNAME)
車系 (MODELS)
發行時間範圍 (RELEASED_DATE)
廠商調查狀態 (SURVEY_STATUS)
廠商調查單位 (UNITNAME)
零件切換調查狀態 (SURVEY_VENDOR_SDATE)
零件切換資訊單位 (SURVEY_VENDOR_EDATE)
你可以使用 PL/SQL 中的 DECLARE, BEGIN, END, SELECT INTO, 和 WHERE 等語法來實現這個需求。在程式的開頭，你需要聲明這些輸入參數，然後使用它們來構建你的查詢語句。最後，你可以使用 DBMS_OUTPUT.PUT_LINE 將結果輸出到終端或者其他介面上。

"查詢AND條件" 意味着你需要在 PL/SQL 程式中使用所有提供的條件作為查詢的篩選條件，並且這些條件應該是使用邏輯運算符 "AND" 連接的。

換句話說，當你構建查詢時，應該將所有提供的條件都包含在 WHERE 子句中，並使用 "AND" 連接它們，以確保查詢結果符合所有給定的條件。這樣的查詢將返回滿足所有條件的記錄。

舉例來說，如果給定了 "通編號"、"廠商" 和 "車系" 這三個條件，你的查詢應該像這樣：

```sql
SELECT *
FROM your_table
WHERE ECNNO = your_input_ecnno
  AND SUPPLIERNAME = your_input_suppliername
  AND MODELS = your_input_models;
```

這樣的查詢將只返回符合所有三個條件的記錄。
====================================================================
```sql
select ecnno, models, title, suppliername, released_date, unitname, survey_vendor_sdate, survey_vendor_pdate, survey_vendor_edate, survey_status
from (
    SELECT DISTINCT A.EC_ID,
    decode(report_type, NULL, 'S', report_type) AS report_type,
           A.pdm_EcFileID, A.ECNNO, A.PDM_MODELS MODELS, A.TITLE,
           M.VENDOR_LIST_NA as SUPPLIERNAME, TO_CHAR(A.RELEASED_DATE,'YYYY/MM/DD') RELEASED_DATE,
           S.GLOSSARY1 as Unitname,
           TO_CHAR(M.sdate,'YYYY/MM/DD') SURVEY_VENDOR_SDATE,
           TO_CHAR(M.pdate,'YYYY/MM/DD') SURVEY_VENDOR_PDATE,
           TO_CHAR(M.rdate,'YYYY/MM/DD') SURVEY_VENDOR_EDATE,
           S1.GLOSSARY2 SURVEY_STATUS
    FROM T_EC_INFO A
    LEFT JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = 'S'
    LEFT JOIN T_SYS_GLOSSARY S ON S.GLOSSARYTYPEID LIKE 'A05-%' AND S.MODIFYCONTENT = M.UNIT
    LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE 'A18-%' AND S1.GLOSSARYTYPEID = M.status
    where 1=1 
    and A.ECNNO = :input_ecnno  -- 綁定變量 :input_ecnno 為輸入的設通編號
    and M.VENDOR_LIST_NA = :input_suppliername  -- 綁定變量 :input_suppliername 為輸入的廠商名稱
    and A.RELEASED_DATE between date '2022-01-01' and date '2022-12-31'
    and A.PDM_MODELS like '%21B%'
) 
```
========================================================================
```sql
DECLARE
  input_ecnno CHAR(11) := '&設通編號';
  input_vendor VARCHAR2(100) := '&廠商';
BEGIN
  -- Run the query with conditional logic for each input
  FOR i IN (
    SELECT ecnno, models, title, suppliername, released_date, unitname,
           survey_vendor_sdate, survey_vendor_pdate, survey_vendor_edate, survey_status
    FROM (
        SELECT DISTINCT A.EC_ID,
                        decode(report_type, NULL, 'S', report_type) AS report_type,
                        A.pdm_EcFileID, A.ECNNO, A.PDM_MODELS MODELS, A.TITLE,
                        M.VENDOR_LIST_NA as SUPPLIERNAME, TO_CHAR(A.RELEASED_DATE,'YYYY/MM/DD') RELEASED_DATE,
                        S.GLOSSARY1 as Unitname,
                        TO_CHAR(M.sdate,'YYYY/MM/DD') SURVEY_VENDOR_SDATE,
                        TO_CHAR(M.pdate,'YYYY/MM/DD') SURVEY_VENDOR_PDATE,
                        TO_CHAR(M.rdate,'YYYY/MM/DD') SURVEY_VENDOR_EDATE,
                        S1.GLOSSARY2 SURVEY_STATUS
        FROM T_EC_INFO A
        LEFT JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = 'S'
        LEFT JOIN T_SYS_GLOSSARY S ON S.GLOSSARYTYPEID LIKE 'A05-%' AND S.MODIFYCONTENT = M.UNIT
        LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE 'A18-%' AND S1.GLOSSARYTYPEID = M.status
        WHERE (A.ECNNO = input_ecnno OR input_ecnno IS NULL)
          AND (M.VENDOR_LIST_NA = input_vendor OR input_vendor IS NULL)
          AND A.RELEASED_DATE BETWEEN DATE '2022-01-01' AND DATE '2022-12-31'
          AND A.PDM_MODELS LIKE '%21B%'
    )
  )
  LOOP
    dbms_output.put_line(i.ecnno || ', ' || i.models || ', ' || i.title || ', ' ||
                         i.suppliername || ', ' || i.released_date || ', ' || i.unitname || ', ' ||
                         i.survey_vendor_sdate || ', ' || i.survey_vendor_pdate || ', ' || i.survey_vendor_edate || ', ' ||
                         i.survey_status);
  END LOOP;
END;
```
================================================================================
```sql

DECLARE
  input_ecnno CHAR(11) := '&設通編號';
  input_vendor VARCHAR2(100) := '&廠商';
  input_models VARCHAR2(250) := '&車系'; 
  input_release_date_start DATE := TO_DATE('&發行時間起始', 'YYYY-MM-DD'); 
  input_release_date_end DATE := TO_DATE('&發行時間結束', 'YYYY-MM-DD'); 
  input_survey_status NVARCHAR2(300) := '&廠商調查狀態'; 
  input_unitname NVARCHAR2(300) := '&廠商調查單位';
BEGIN
  FOR i IN (
    SELECT ecnno, models, title, suppliername, released_date, unitname,
           survey_vendor_sdate, survey_vendor_pdate, survey_vendor_edate, survey_status
    FROM (
        SELECT DISTINCT A.EC_ID,
                        decode(report_type, NULL, 'S', report_type) AS report_type,
                        A.pdm_EcFileID, A.ECNNO, A.PDM_MODELS MODELS, A.TITLE,
                        M.VENDOR_LIST_NA as SUPPLIERNAME, TO_CHAR(A.RELEASED_DATE,'YYYY/MM/DD') RELEASED_DATE,
                        S.GLOSSARY1 as Unitname,
                        TO_CHAR(M.sdate,'YYYY/MM/DD') SURVEY_VENDOR_SDATE,
                        TO_CHAR(M.pdate,'YYYY/MM/DD') SURVEY_VENDOR_PDATE,
                        TO_CHAR(M.rdate,'YYYY/MM/DD') SURVEY_VENDOR_EDATE,
                        S1.GLOSSARY2 SURVEY_STATUS
        FROM T_EC_INFO A
        LEFT JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = 'S'
        LEFT JOIN T_SYS_GLOSSARY S ON S.GLOSSARYTYPEID LIKE 'A05-%' AND S.MODIFYCONTENT = M.UNIT
        LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE 'A18-%' AND S1.GLOSSARYTYPEID = M.status
        WHERE (A.ECNNO = input_ecnno OR input_ecnno IS NULL)
          AND (M.VENDOR_LIST_NA = input_vendor OR input_vendor IS NULL)
          AND (A.PDM_MODELS = input_models OR input_models IS NULL)
          AND (A.RELEASED_DATE BETWEEN input_release_date_start AND input_release_date_end OR input_release_date_start IS NULL OR input_release_date_end IS NULL)
          AND (S1.GLOSSARY2 = input_survey_status OR input_survey_status IS NULL)
          AND (S.GLOSSARY1 = input_unitname OR input_unitname IS NULL)
          AND A.PDM_MODELS LIKE '%21B%'
    )
  )
  LOOP
    dbms_output.put_line(i.ecnno || ', ' || i.models || ', ' || i.title || ', ' ||
                         i.suppliername || ', ' ||  i.released_date || ', ' || i.unitname || ', ' ||
                         i.survey_vendor_sdate || ', ' || i.survey_vendor_pdate || ', ' || i.survey_vendor_edate || ', ' ||
                         i.survey_status);
  END LOOP;
END;

```

=================================================================================
If you're looking for a way to directly handle and view the results of your PL/SQL query as a table-like structure without using `dbms_output` or creating a pipelined function, you might consider using a simpler method such as leveraging SQL Developer's or another IDE's features, using a ref cursor, or utilizing a temporary table. Here’s how you can accomplish this using each method:

### 1. Using a Ref Cursor for Direct Results
A ref cursor allows you to return a cursor from a PL/SQL stored procedure directly to the client application, which can then fetch and display the results as if it were querying a table directly.

#### Example of Using a Ref Cursor:
```sql
CREATE OR REPLACE PROCEDURE get_survey_data(
  input_ecnno CHAR,
  input_vendor VARCHAR2,
  input_models VARCHAR2,
  input_release_date_start DATE,
  input_release_date_end DATE,
  input_survey_status NVARCHAR2,
  input_unitname NVARCHAR2,
  rc_out OUT SYS_REFCURSOR  -- Define an OUT parameter as a ref cursor
) IS
BEGIN
  OPEN rc_out FOR
    SELECT A.ECNNO, A.PDM_MODELS AS models, A.TITLE AS title,
           M.VENDOR_LIST_NA AS suppliername, A.RELEASED_DATE,
           S.GLOSSARY1 AS unitname,
           M.sdate AS survey_vendor_sdate,
           M.pdate AS survey_vendor_pdate,
           M.edate AS survey_vendor_edate,
           S1.GLOSSARY2 AS survey_status
    FROM T_EC_INFO A
    LEFT JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = 'S'
    LEFT JOIN T_SYS_GLOSSARY S ON S.GLOSSARYTYPEID LIKE 'A05-%' AND S.MODIFYCONTENT = M.UNIT
    LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE 'A18-%' AND S1.GLOSSARYTYPEID = M.status
    WHERE (A.ECNNO = input_ecnno OR input_ecnno IS NULL)
      AND (M.VENDOR_LIST_NA = input_vendor OR input_vendor IS NULL)
      AND (A.PDM_MODELS = input_models OR input_models IS NULL)
      AND (A.RELEASED_DATE BETWEEN input_release_date_start AND input_release_date_end OR input_release_date_start IS NULL OR input_release_date_end IS NULL)
      AND (S1.GLOSSARY2 = input_survey_status OR input_survey_status IS NULL)
      AND (S.GLOSSARY1 = input_unitname OR input_unitname IS NULL)
      AND A.PDM_MODELS LIKE '%21B%';
END;
/
```
- **Execution and Viewing in SQL Developer**: You can execute this procedure in Oracle SQL Developer and view the results by calling the procedure from an anonymous block and passing a cursor to a grid view.

```sql
DECLARE
  rc SYS_REFCURSOR;
BEGIN
  get_survey_data(NULL, NULL, NULL, NULL, NULL, NULL, NULL, rc);
  -- Tool like SQL Developer can display the results directly from rc
END;
```

### 2. Using a Global Temporary Table
Another approach is to insert the results into a global temporary table and then query this table after running your procedure:

#### Step 1: Create a Global Temporary Table
```sql
CREATE GLOBAL TEMPORARY TABLE temp_survey_data (
  ecnno VARCHAR2(11),
  models VARCHAR2(250),
  title VARCHAR2(300),
  suppliername VARCHAR2(100),
  released_date DATE,
  unitname NVARCHAR2(300),
  survey_vendor_sdate DATE,
  survey_vendor_pdate DATE,
  survey_vendor_edate DATE,
  survey_status NVARCHAR2(300)
) ON COMMIT PRESERVE ROWS;
```

#### Step 2: Modify Your Procedure to Use the Temporary Table
```sql
CREATE OR REPLACE PROCEDURE populate_temp_survey_data IS
BEGIN
  INSERT INTO temp_survey_data
  SELECT ...
  FROM your_joined_tables_and_conditions;
END;
/
```

- **View the Data**: After executing the procedure, you can simply query the `temp_survey_data` table to view the results.

These approaches provide flexibility depending on how you prefer to handle and view your data. Using a ref cursor is typically more straightforward for directly retrieving query results, while using a temporary table might be more suitable for complex workflows or when results need to be accessed multiple times or by multiple sessions in a controlled manner.