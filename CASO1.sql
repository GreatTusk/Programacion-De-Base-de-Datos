DESCRIBE empleado;

VAR B_RUT NUMBER;
VAR b_anno_proceso NUMBER; 
EXEC B_RUT := &RUN;
EXEC B_RUT := &rut_empleado;

DECLARE
    v_numrun_emp NUMBER(9);
    v_dv VARCHAR(1);
    v_nombre VARCHAR(50);
    v_sueldo NUMBER(7);
    v_id_comuna NUMBER(3) := 0;   
    v_mov_adicional NUMBER(5) := 0;
    V_PORC_MOV NUMBER;
    V_TOTAL_MOV NUMBER;
    V_MOV_NORMAL NUMBER;
BEGIN

    SELECT
        NUMRUN_EMP,
        DVRUN_EMP,
        PNOMBRE_EMP || ' ' || SNOMBRE_EMP || ' ' || APPATERNO_EMP || ' ' || APMATERNO_EMP,
        SUELDO_BASE,
        ID_COMUNA
    INTO v_numrun_emp, v_dv, v_nombre, v_sueldo, v_id_comuna
    FROM EMPLEADO
    WHERE NUMRUN_EMP = :B_RUT;
    
    IF v_id_comuna = 117 THEN 
        v_mov_adicional := 20000;
    ELSIF v_id_comuna = 118 THEN
        v_mov_adicional := 25000;
    ELSIF v_id_comuna = 119 THEN
        v_mov_adicional := 30000;
    ELSIF v_id_comuna = 120 THEN
        v_mov_adicional := 35000;
    ELSIF v_id_comuna = 121 THEN
        v_mov_adicional := 40000;
    END IF;
    
    V_PORC_MOV:=  TRUNC(v_sueldo / 100000);
    V_MOV_NORMAL:= ROUND(V_PORC_MOV / 100 * v_sueldo);
    V_TOTAL_MOV := V_MOV_NORMAL + v_mov_adicional;   
    
    INSERT INTO PROY_MOVILIZACION VALUES
        (:b_anno_proceso, v_numrun_emp, v_dv, v_nombre, v_sueldo, V_PORC_MOV, V_MOV_NORMAL, V_TOTAL_MOV);

END;