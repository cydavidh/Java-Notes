CREATE OR REPLACE PROCEDURE "P_EC_QRYECVENSURVEYUNITDLL" (
/*
   Function:Get data List For Drop Down List
   Output:Data List
   */
 returnValues OUT SYS_REFCURSOR
)
IS
BEGIN
  OPEN ReturnValues FOR
  select GLOSSARY1 unitname,MODIFYCONTENT unitid
  FROM  T_SYS_GLOSSARY
  where GLOSSARYTYPEID LIKE 'A05%';
END;


 
