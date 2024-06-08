CREATE OR REPLACE PROCEDURE "P_EC_QRYECSURVEYUNITXDLL"(
                                                         /*
                                                            Function:Get data List For Drop Down List
                                                            Output:Data List
                                                            */returnValues OUT SYS_REFCURSOR) IS
BEGIN
    OPEN ReturnValues FOR
        SELECT GLOSSARY1 AS unitname,
               CASE
                   WHEN GLOSSARY1 = 'PEO' THEN
                    CAST('P' AS NVARCHAR2(300))
                   WHEN GLOSSARY1 = '三義工廠' THEN
                    CAST('S' AS NVARCHAR2(300))
                   ELSE
                    GLOSSARY2
               END AS unitid
          FROM T_SYS_GLOSSARY
         WHERE GLOSSARYTYPEID LIKE 'A05%'
           AND (modifycontent != 'Y' OR modifycontent IS NULL);
END;
/
