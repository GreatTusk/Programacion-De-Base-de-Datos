DESCRIBE EMPLEADO;
-- DESCRIBE CLIENTE;
-- DESCRIBE ESTADO_CIVIL;
-- SELECT *
-- FROM ESTADO_CIVIL;

sET SERVEROUTPUT ON;
VARIABLE b_run_empleado NUMBER;
EXEC b_run_empleado:= &rn;
DECLARE
    v_bono         NUMBER(23);
    v_bonificacion NUMBER;
    v_nombre       VARCHAR(100);
    v_run          VARCHAR(100);
    v_sueldo       NUMBER;
BEGIN
    SELECT NOMBRE_EMP || ' ' || APPATERNO_EMP || ' ' || APMATERNO_EMP,
           NUMRUT_EMP || '-' || DVRUT_EMP,
           SUELDO_EMP
    INTO v_nombre, v_run, v_sueldo
    from EMPLEADO
    WHERE NUMRUT_EMP = 11846972
      AND SUELDO_EMP < 500000
      AND ID_CATEGORIA_EMP != 3;
    -- PORCENTAJE DE BONIFICACION
    v_bono := &bono;
    v_bonificacion := ROUND(v_sueldo * (v_bono / 100));
    dbms_output.put_line('DATOS CALCULO BONIFICACION EXTRA DEL ' || TO_CHAR(v_bono) || '% DEL SUELDO');
    dbms_output.put_line('NOMBRE EMPLEADO: ' || V_NOMBRE);
    dbms_output.put_line('RUN: ' || v_run);
    dbms_output.put_line('Sueldo: ' || v_sueldo);
    dbms_output.put_line('Bonificacion extra: ' || v_bonificacion);
END;