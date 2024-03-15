VARIABLE b_run NUMBER;
exec :b_run := &RUT;

DESCRIBE EMPLEADO;
--Ruts: 12260812, 11999100
DECLARE
    v_nombre        VARCHAR2(100);
    v_run           VARCHAR2(10);
    v_sueldo        NUMBER;
    v_aumento       NUMBER := &aumento;
    v_aumento_2     NUMBER := &aumento_2;
    v_reajuste_1    NUMBER;
    v_reajuste_2    NUMBER;
    v_rango_inicial NUMBER := &rango_inicial;
    v_rango_final   NUMBER := &rango_final;
BEGIN

    SELECT NOMBRE_EMP || ' ' || APPATERNO_EMP || ' ' || APMATERNO_EMP,
           NUMRUT_EMP || '-' || DVRUT_EMP,
           SUELDO_EMP
    INTO v_nombre, v_run, v_sueldo
    from empleado
    where NUMRUT_EMP = :b_run
    and SUELDO_EMP BETWEEN 200000 AND 400000;

    v_reajuste_1 := ROUND(v_sueldo + (v_sueldo * v_aumento / 100));
    v_reajuste_2 := ROUND(v_sueldo + (v_sueldo * v_aumento_2 / 100));

    dbms_output.put_line('NOMBRE DEL EMPLEADO: ' || v_nombre);
    dbms_output.put_line('RUN DEL EMPLEADO: ' || v_run);
    dbms_output.put_line('SIMULACIÓN 1: Aumentar en ' || v_aumento || '% el salario de todos los empleados');
    dbms_output.put_line('SUELDO ACTUAL: ' || v_sueldo);
    dbms_output.put_line('SUELDO REAJUSTADO: ' || v_reajuste_1);
    dbms_output.put_line('SIMULACIÓN 2: Aumentar en ' || v_aumento_2 ||
                         '% el salario de los empleados que poseen salarios entre ' || TO_CHAR(v_rango_inicial, '$999G999G999') ||
                         ' y ' || TO_CHAR(v_rango_final, '$999G999G999'));
    dbms_output.put_line('SUELDO ACTUAL: ' || v_sueldo);
    dbms_output.put_line('SUELDO REAJUSTADO: ' || v_reajuste_2);
    DBMS_OUTPUT.PUT_LINE('Reajuste: ' || (ROUND(v_sueldo * v_aumento_2 / 100)));

end;