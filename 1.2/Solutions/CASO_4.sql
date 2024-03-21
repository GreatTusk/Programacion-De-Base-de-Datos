SET SERVEROUT ON;
VAR b_patente VARCHAR2(6);
EXEC b_patente := &b_patente;
VAR b_multa number;
EXEC b_multa := 25500;--&b_multa;

DECLARE
    v_mes_ant DATE;
    -- VARIABLES CONSULTA
    v_fecha_ini_arriendo ARRIENDO_CAMION.FECHA_INI_ARRIENDO%TYPE;
    v_dias_solicitados ARRIENDO_CAMION.DIAS_SOLICITADOS%TYPE;
    v_fecha_devolucion ARRIENDO_CAMION.FECHA_DEVOLUCION%TYPE;
    -- VARIABLES CALCULO
    v_dias_retraso NUMBER;
    v_multa NUMBER;
BEGIN
    v_mes_ant := ADD_MONTHS(SYSDATE, -1);

    SELECT
        fecha_ini_arriendo,
        DIAS_SOLICITADOS,
        FECHA_DEVOLUCION
    INTO v_fecha_ini_arriendo, v_dias_solicitados, v_fecha_devolucion
    FROM ARRIENDO_CAMION
    WHERE NRO_PATENTE = :b_patente AND TO_CHAR(FECHA_INI_ARRIENDO, 'MM') = TO_CHAR(v_mes_ant, 'MM')
    AND FECHA_DEVOLUCION - DIAS_SOLICITADOS > fecha_ini_arriendo;

    v_dias_retraso := v_fecha_devolucion - (v_fecha_ini_arriendo + v_dias_solicitados);
    v_multa := v_dias_retraso * :b_multa;

    DBMS_OUTPUT.PUT_LINE('Patente: ' || :b_patente);
    DBMS_OUTPUT.PUT_LINE('Fecha Inicio Arriendo: ' || v_fecha_ini_arriendo);
    DBMS_OUTPUT.PUT_LINE('Dias Solicitados: ' || v_dias_solicitados);
    DBMS_OUTPUT.PUT_LINE('Fecha Devolucion: ' || v_fecha_devolucion);
    DBMS_OUTPUT.PUT_LINE('Dias Retraso: ' || v_dias_retraso);
    DBMS_OUTPUT.PUT_LINE('Multa: ' || v_multa);
    
    INSERT INTO MULTA_ARRIENDO VALUES(TO_CHAR(v_mes_ant, 'YYYYMM'), :b_patente, v_fecha_ini_arriendo, v_dias_solicitados, v_fecha_devolucion, v_dias_retraso, v_multa);
    commit;
end;


SELECT * FROM MULTA_ARRIENDO;


