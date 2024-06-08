CREATE OR REPLACE PROCEDURE "P_EC_QRYECSQL"(
    /* 13-03 �]�q��d��sql
        */varReport_type       IN VARCHAR2, -- �\��GA08->�]�q��d�ߡBA17�]�q��έp
    varEc_id             IN VARCHAR2,
    varEcnNo             IN VARCHAR2, -- �]�q�s��
    varSupplier          IN VARCHAR2, -- �t�ӥN��
    varModel             IN VARCHAR2, -- ���t
    varVenSurveyStatus   IN VARCHAR2, -- �t�ӽլd���A
    varVenSurveyunit     IN VARCHAR2, -- �t�ӽլd���
    varPtChgSurveyStatus IN VARCHAR2, -- �s������լd���A
    varPtChgSurveyunit   IN VARCHAR2, -- �s�������T���
    varRlsDateS          IN VARCHAR2, -- E-BOM�o���_
    varRlsDateE          IN VARCHAR2, -- E-BOM�o��騴
    varDist_unit         IN VARCHAR2, -- �t�ӽլd��O
    varChg_unit          IN VARCHAR2, -- �s�������O
    varVensur_status     IN VARCHAR2, -- �t�ӽլd���A(����/�O��)
    varPtchg_status      IN VARCHAR2, -- �s������լd���A(����/�O��)
    varDueType           IN VARCHAR2, -- �w�p����(N:���g, N1:�U�g)
    varDesSection        IN VARCHAR2, -- �]�p��O
    varDesigner          IN VARCHAR2, -- �]�p�ӿ�
    --cydavidh
    varDesignerSurveySection IN VARCHAR2, --�]�p����ϥΪ�
    varSurveyUnitX           IN VARCHAR2, --�]�p����H�~
    
    varSelSql   OUT VARCHAR2, -- SELECT SQL
    varJoinSql  OUT VARCHAR2, -- JOIN SQL
    varWhereSql OUT VARCHAR2 -- WHERE SQL
    ) IS
    ecidCond               VARCHAR2(100);
    ecnnoCond              VARCHAR2(100);
    supplierCond           VARCHAR2(100);
    modelCond              VARCHAR2(100);
    venStatusCond          VARCHAR2(200);
    venunitCond            VARCHAR2(100);
    ptChgStatusCond        VARCHAR2(200);
    ptChgunitCond          VARCHAR2(100);
    rlsdateSCond           VARCHAR2(100);
    rlsdateECond           VARCHAR2(100);
    dist_unitCond          VARCHAR2(100);
    chg_unitCond           VARCHAR2(100);
    vensur_statustCond     VARCHAR2(200);
    ptchg_statustCond      VARCHAR2(200);
    duetypeCond            VARCHAR2(200);
    dessectionCond         VARCHAR2(200);
    designerCond           VARCHAR2(200);
    varWDays               number;
    varFunc                VARCHAR2(10);
    varReportType_tmp      VARCHAR2(1);
    --cydavidh
    varSurveyUnitHolder    VARCHAR2(1);
    varSurveySectionHolder VARCHAR2(200);

BEGIN
    --cydavidh
    IF varSurveyUnitX = 'S' OR varVenSurveyunit = 'S' THEN
        varSurveyUnitHolder := 'S';
    ELSIF varSurveyUnitX = 'P' OR varVenSurveyunit = 'P' THEN
        varSurveyUnitHolder := 'P';
    ELSIF (varSurveyUnitX != 'P' and varSurveyUnitX != 'S' and
          varSurveyUnitX IS NOT NULL) or varVenSurveyunit = 'Y' THEN
        varSurveyUnitHolder := 'Y';
        if varDesignerSurveySection IS NOT NULL THEN
            varSurveySectionHolder := varDesignerSurveySection;
        ELSE
            varSurveySectionHolder := varSurveyUnitX;
        END IF;
    END IF;

    -- EC_ID����
    ecidCond := ' AND M.EC_ID = ''' || varEc_id || ''' ';
    -- �]�q�s������
    ecnnoCond := ' AND A.ECNNO LIKE ''' || varEcnNo || '%'' ';
    -- �t�ӥN������
    supplierCond := ' AND UPPER(m.vendor_list_ID) LIKE UPPER(''%' ||
                    substr(varSupplier, 1, 4) || '%'') ';
    -- ���t����
    modelCond := ' AND INSTR(A.PDM_MODELS,''' || varModel || ''')>0 ';
    -- �t�ӽլd���A����
    venStatusCond := ' AND m.status = ''' || varVenSurveyStatus || ''' ';
    -- �t�ӽլd������
    venunitCond := ' AND m.UNIT = ''' || varSurveyUnitHolder || ''' ';
    -- �s������լd���A����
    ptChgStatusCond := ' AND m.status = ''' || varPtChgSurveyStatus ||
                       ''' ';
    -- �s�������T������
    ptChgunitCond := ' AND m.UNIT = ''' || varPtChgSurveyunit || ''' ';
    -- E-BOM�o������
    rlsdateSCond := ' AND TO_CHAR(A.RELEASED_DATE,''YYYY/MM/DD'') >=''' ||
                    varRlsDateS || ''' ';
    rlsdateECond := ' AND TO_CHAR(A.RELEASED_DATE,''YYYY/MM/DD'') <=''' ||
                    varRlsDateE || ''' ';
    -- �t�ӽլd��O���� S: Y P S %
    dist_unitCond := ' AND M.UNIT LIKE ''%' || varDist_unit || '%'' ';
    -- �s�������O���� c: P M I %
    chg_unitCond := ' AND M.UNIT LIKE ''%' || varChg_unit || '%'' ';
    -- �t�ӽլd���A(����/�O��)����
    vensur_statustCond := ' AND DECODE(M.STATUS,''A18-3'',''OK'',DECODE(M.STATUS,''A18-4'',''OK'',DECODE(M.STATUS,''A18-2'',''DUE'',''''))) = ''' ||
                          varVensur_status || ''' ';
    -- �s������լd���A(����/�O��)����
    ptchg_statustCond := ' AND DECODE(M.STATUS,''A19-3'',''OK'',DECODE(M.STATUS,''A19-4'',''OK'',DECODE(M.STATUS,''A19-2'',''DUE'',''''))) = ''' ||
                         varPtchg_status || ''' ';
    -- �w�p��������
    duetypeCond := ' AND TRUNC(M.PDATE) BETWEEN DECODE(''' || varDueType ||
                   ''',''N'',TRUNC(SYSDATE),TRUNC(F_EC_CHK_WEEK(SYSDATE,6))) AND TRUNC(F_EC_CHK_WEEK(SYSDATE+DECODE(''' ||
                   varDueType || ''',''N1'',7,0),5)) ';
    -- �]�p��O����
    dessectionCond := ' AND A.DES_UNITID = ''' || varDesSection || ''' ';
    -- �]�p�ӿ����
    designerCond := ' AND A.DESIGNER = ''' || varDesigner || ''' ';

    select to_number(g.glossary2)
      into varWDays
      from t_sys_glossary g
     where g.glossarytypeid = 'A08-3';

    varReportType_tmp := substr(varReport_type, 0, 1);
    if length(rtrim(varReport_type)) > 1 then
        varFunc := substr(varReport_type, 2);
    end if;
    --cydavidh
    IF (varReportType_tmp = 'S') THEN
        --�]�q��έp--"�t�ӽլd�^�Ъ��p"�ƭȶi�J��"�]�q�檬�A�@����"
        IF varSurveyUnitHolder = 'Y' THEN
            varSelSql := 'SELECT DISTINCT A.EC_ID,decode(report_type,NULL,''S'',report_type) AS report_type
      ,A.pdm_EcFileID,A.ECNNO, A.PDM_MODELS MODELS, A.TITLE
      , M.VENDOR_LIST_NA as SUPPLIERNAME, TO_CHAR(A.RELEASED_DATE,''YYYY/MM/DD'') RELEASED_DATE,
             S2.GLOSSARY1 as Unitname,
             TO_CHAR(M.sdate,''YYYY/MM/DD'') SURVEY_VENDOR_SDATE,
             TO_CHAR(M.pdate,''YYYY/MM/DD'') SURVEY_VENDOR_PDATE,
             TO_CHAR(M.rdate,''YYYY/MM/DD'') SURVEY_VENDOR_EDATE,
             S1.GLOSSARY2 SURVEY_STATUS
         FROM T_EC_INFO A ';
        
            IF (varFunc IS NULL) THEN
                varJoinSql := ' Inner JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = ''' ||
                              varReportType_tmp || ''' ';
            ELSE
                varJoinSql := ' Left  JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = ''' ||
                              varReportType_tmp || ''' ';
            END IF;
            IF varSurveyUnitHolder IS NOT NULL THEN
                varJoinSql := varJoinSql ||
                              'LEFT JOIN T_EC_SURVEY_INFO O ON A.EC_ID = O.EC_ID' ||
                              ' LEFT JOIN T_SYS_GLOSSARY S2 ON S2.GLOSSARY2 = O.UT_UNITID  AND S2.GLOSSARYTYPEID LIKE ''A05-%''';
            END IF;
            varJoinSql := varJoinSql || '
                LEFT JOIN T_SYS_GLOSSARY S  ON  S.GLOSSARYTYPEID LIKE ''A05-%'' AND  S.MODIFYCONTENT  = M.UNIT
                  LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE ''A18-%'' AND S1.GLOSSARYTYPEID = M.status
                  where 1=1 ';
        ELSE
            varSelSql := 'SELECT DISTINCT A.EC_ID,decode(report_type,NULL,''S'',report_type) AS report_type
      ,A.pdm_EcFileID,A.ECNNO, A.PDM_MODELS MODELS, A.TITLE
      , M.VENDOR_LIST_NA as SUPPLIERNAME, TO_CHAR(A.RELEASED_DATE,''YYYY/MM/DD'') RELEASED_DATE,
             S.GLOSSARY1 as Unitname,
             TO_CHAR(M.sdate,''YYYY/MM/DD'') SURVEY_VENDOR_SDATE,
             TO_CHAR(M.pdate,''YYYY/MM/DD'') SURVEY_VENDOR_PDATE,
             TO_CHAR(M.rdate,''YYYY/MM/DD'') SURVEY_VENDOR_EDATE,
             S1.GLOSSARY2 SURVEY_STATUS
         FROM T_EC_INFO A ';
        
            IF (varFunc IS NULL) THEN
                varJoinSql := ' Inner JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = ''' ||
                              varReportType_tmp || ''' ';
            ELSE
                varJoinSql := ' Left  JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID AND M.report_type = ''' ||
                              varReportType_tmp || ''' ';
            END IF;
            varJoinSql := varJoinSql || ' LEFT JOIN T_SYS_GLOSSARY S  ON  S.GLOSSARYTYPEID LIKE ''A05-%'' AND  S.MODIFYCONTENT  = M.UNIT
                  LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE ''A18-%'' AND S1.GLOSSARYTYPEID = M.status
                  where 1=1 ';
        END IF;
    ELSIF (varReportType_tmp = 'C') THEN
        --�]�q��έp--"�s�������T�^�Ъ��p"�ƭȶi�J��"�]�q�檬�A�@����"
    
        varSelSql := 'SELECT DISTINCT A.EC_ID,decode(report_type,NULL,''C'',report_type) AS report_type,A.pdm_EcFileID,A.ECNNO ';
    
        IF (varFunc IS NULL) THEN
            varSelSql := varSelSql || ' , A.PDM_MODELS MODELS ';
        ELSE
            varSelSql := varSelSql ||
                         ', C.CAR||''(''||(SELECT E.NAME FROM T_SYS_EMPLOYINFO E WHERE E.EMPLOYNO=C.UNDERTAKE)||'')'' AS MODELS';
        END IF;
    
        varSelSql := varSelSql ||
                     ', A.TITLE, M.VENDOR_LIST_NA as SUPPLIERNAME, TO_CHAR(A.RELEASED_DATE,''YYYY/MM/DD'') RELEASED_DATE,
             S.GLOSSARY1 as CHG_SURVEY_UNIT,
             TO_CHAR(M.sdate,''YYYY/MM/DD'') CHG_SDATE,
             TO_CHAR(M.PDATE,''YYYY/MM/DD'') CHG_PDATE,
             TO_CHAR(M.RDATE,''YYYY/MM/DD'') CHG_RDATE,';
    
        IF (varFunc IS NULL) THEN
            varSelSql := varSelSql || 'S1.GLOSSARY2 CHG_STATUS';
        ELSE
            varSelSql := varSelSql ||
                         '(SELECT GLOSSARY1 FROM T_SYS_GLOSSARY WHERE GLOSSARYTYPEID=C.STATUS)||'', ''||TO_CHAR(C.CHG_DATE,''YYYY/MM/DD'')||'', ''||C.CHG_MEMO||'', ''||C.COMMENT2 CHG_STATUS';
        END IF;
    
        varSelSql := varSelSql || ' FROM T_EC_INFO A ';
    
        IF (varFunc IS NULL) THEN
            varJoinSql := ' Inner JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID ';
        ELSE
            varJoinSql := ' Left  JOIN T_EC_SUM M ON M.EC_ID = A.EC_ID inner join t_ec_chg_info C ON M.EC_ID=C.EC_ID ';
        END IF;
        varJoinSql := varJoinSql || ' LEFT JOIN T_SYS_GLOSSARY S  ON  S.GLOSSARYTYPEID LIKE ''A10-%'' AND  S.GLOSSARY3     = M.UNIT
              LEFT JOIN T_SYS_GLOSSARY S1 ON S1.GLOSSARYTYPEID LIKE ''A19-%'' AND S1.GLOSSARYTYPEID = M.status
              where m.report_type = ''' ||
                      varReportType_tmp || ''' ';
    
    END IF;

    --cydavidh
    IF varSurveyUnitHolder != 'P' and varSurveyUnitHolder != 'S' THEN
        varWhereSql := varWhereSql || ' AND O.UT_UNITID = ''' ||
                       varSurveySectionHolder || ''' ';
    END IF;
    
    IF varSurveyUnitHolder != 'P' or varSurveyUnitHolder != 'S' THEN 
                varWhereSql := varWhereSql || venunitCond;
    END IF;

    IF varEc_id IS NOT NULL THEN
        varWhereSql := varWhereSql || ecidCond;
    END IF;

    IF varEcnNo IS NOT NULL THEN
        varWhereSql := varWhereSql || ecnnoCond;
    END IF;

    IF varSupplier IS NOT NULL THEN
        varWhereSql := varWhereSql || supplierCond;
    END IF;

    IF varModel IS NOT NULL THEN
        varWhereSql := varWhereSql || modelCond;
    END IF;

    IF varVenSurveyStatus IS NOT NULL THEN
        varWhereSql := varWhereSql || venStatusCond;
    END IF;

    IF varVenSurveyunit IS NOT NULL THEN
        varWhereSql := varWhereSql || venunitCond;
    END IF;

    IF varPtChgSurveyStatus IS NOT NULL THEN
        varWhereSql := varWhereSql || ptChgStatusCond;
    END IF;

    IF varPtChgSurveyunit IS NOT NULL THEN
        varWhereSql := varWhereSql || ptChgunitCond;
    END IF;

    IF varRlsDateS IS NOT NULL THEN
        varWhereSql := varWhereSql || rlsdateSCond;
    END IF;

    IF varRlsDateE IS NOT NULL THEN
        varWhereSql := varWhereSql || rlsdateECond;
    END IF;

    IF varDist_unit IS NOT NULL THEN
        varWhereSql := varWhereSql || dist_unitCond;
    END IF;

    IF varChg_unit IS NOT NULL THEN
        varWhereSql := varWhereSql || chg_unitCond;
    END IF;

    IF varVensur_status IS NOT NULL THEN
        varWhereSql := varWhereSql || vensur_statustCond;
    END IF;

    IF varPtchg_status IS NOT NULL THEN
        varWhereSql := varWhereSql || ptchg_statustCond;
    END IF;

    IF varDueType IS NOT NULL THEN
        IF (varReportType_tmp = 'S') THEN
            --�]�q��έp--"�t�ӽլd�^�Ъ��p"�ƭȶi�J��"�]�q�檬�A�@����"
            duetypeCond := duetypeCond || ' AND M.STATUS = ''A18-1'' ';
        ELSIF (varReportType_tmp = 'C') THEN
            --�]�q��έp--"�s�������T�^�Ъ��p"�ƭȶi�J��"�]�q�檬�A�@����"
            duetypeCond := duetypeCond || ' AND M.STATUS = ''A19-1'' ';
        END IF;
        varWhereSql := varWhereSql || duetypeCond;
    END IF;

    IF varDesSection IS NOT NULL THEN
        varWhereSql := varWhereSql || dessectionCond;
    END IF;

    IF varDesigner IS NOT NULL THEN
        varWhereSql := varWhereSql || designerCond;
    END IF;

    IF (varReportType_tmp = 'C') THEN
        varWhereSql := varWhereSql ||
                       ' ORDER BY CHG_STATUS DESC, CHG_PDATE ASC ';
    ELSE
        varWhereSql := varWhereSql ||
                       ' ORDER BY SURVEY_STATUS DESC, SURVEY_VENDOR_PDATE ASC ';
    END IF;

END;
/
