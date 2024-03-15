SET SERVEROUTPUT ON;
VAR b_runcli NUMBER;
EXEC b_runcli := &run;
--
--DESCRIBE CLIENTE;
--DESCRIBE ESTADO_CIVIL;
--SELECT * FROM ESTADO_CIVIL;
--Ruts: 12487147, 12861354, 13050258
DECLARE
    v_nombre   VARCHAR(100);
    v_run      VARCHAR(100);
    v_sueldo   NUMBER;
    v_estcivil VARCHAR(10);
BEGIN
    SELECT c.NOMBRE_CLI || ' ' || c.APPATERNO_CLI || ' ' || c.APMATERNO_CLI,
           c.NUMRUT_CLI || '-' || c.DVRUT_CLI,
           e.DESC_ESTCIVIL,
           c.RENTA_CLI
    INTO v_nombre, v_run, v_estcivil, v_sueldo
    FROM CLIENTE c
             INNER JOIN ESTADO_CIVIL e on e.ID_ESTCIVIL = c.ID_ESTCIVIL
    WHERE c.NUMRUT_CLI = :b_runcli
      AND (c.ID_ESTCIVIL NOT IN (2, 5)
        OR (c.ID_ESTCIVIL IN (3, 4) AND c.RENTA_CLI >= &renta));

    dbms_output.put_line('DATOS DEL CLIENTE');
    dbms_output.put_line('-----------------');
    dbms_output.put_line('Nombre: ' || v_nombre);
    dbms_output.put_line('RUN: ' || v_run);
    dbms_output.put_line('Estado civil: ' || v_estcivil);
    dbms_output.put_line('Renta: ' || TO_CHAR(V_SUELDO, '$999G999G999'));

END;

