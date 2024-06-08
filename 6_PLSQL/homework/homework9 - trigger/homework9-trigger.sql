CREATE TABLE t_ec_info_log (
	log_id NUMBER,
	    ec_id              NUMBER,
		operation_name VARCHAR2(50),
		ecnno VARCHAR(50),
		modifier VARCHAR(50)
);


CREATE OR REPLACE TRIGGER TRG_ec_info_log
AFTER INSERT OR UPDATE OR DELETE ON t_ec_info
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO t_ec_info_log (log_id, ec_id, operation_name, ecnno, modifier)
        VALUES (S_T_EC_INFO_LOG.NEXTVAL, :NEW.ec_id, 'INSERT', :NEW.ecnno, USER);
    ELSIF UPDATING THEN
        INSERT INTO t_ec_info_log (log_id, ec_id, operation_name, ecnno, modifier)
        VALUES (S_T_EC_INFO_LOG.NEXTVAL, :NEW.ec_id, 'UPDATE', :NEW.ecnno, USER);
    ELSIF DELETING THEN
        INSERT INTO t_ec_info_log (log_id, ec_id, operation_name, ecnno, modifier)
        VALUES (S_T_EC_INFO_LOG.NEXTVAL, :OLD.ec_id, 'DELETE', :OLD.ecnno, USER);
    END IF;
END trg_ec_info_log;

CREATE SEQUENCE S_T_EC_INFO_LOG
    START WITH 1
    INCREMENT BY 1