-- PATENTES AHEW11,ASEZ11,BC1002,BT1002,VR1003
SET SERVEROUT ON;
VAR b_patente VARCHAR2(6);
EXEC b_patente := &b_patente;
DECLARE
    v_anno_pasado VARCHAR2(4);
    -- VARIABLES PARA CONSULTA
    v_patente CAMION.NRO_PATENTE%TYPE;
    v_valor_arriendo_dia CAMION.VALOR_ARRIENDO_DIA%TYPE;
    v_valor_garantia_dia CAMION.VALOR_GARANTIA_DIA%TYPE;
    v_cantidad_arriendos NUMBER;
BEGIN

    v_anno_pasado := TO_CHAR(TRUNC(SYSDATE, 'YEAR') - 1, 'YYYY');

    SELECT c.NRO_PATENTE,
           c.VALOR_ARRIENDO_DIA,
           c.VALOR_GARANTIA_DIA,
           COUNT(ac.ID_ARRIENDO)
    INTO v_patente, v_valor_arriendo_dia, v_valor_garantia_dia, v_cantidad_arriendos
    FROM CAMION c
             INNER JOIN MDY3131_P2.ARRIENDO_CAMION AC on c.NRO_PATENTE = AC.NRO_PATENTE
    WHERE c.NRO_PATENTE = :b_patente
    AND TO_CHAR(AC.FECHA_INI_ARRIENDO, 'YYYY') = v_anno_pasado
    group by c.VALOR_GARANTIA_DIA, c.VALOR_ARRIENDO_DIA, c.NRO_PATENTE;

--     INSERT INTO HIST_ARRIENDO_ANUAL_CAMION VALUES (v_anno_pasado, v_patente, v_valor_arriendo_dia, v_valor_garantia_dia, v_cantidad_arriendos);
    SAVEPOINT SP1;
    IF v_cantidad_arriendos < 5 THEN
        UPDATE CAMION
        SET VALOR_ARRIENDO_DIA = ROUND(VALOR_ARRIENDO_DIA * 0.775),
            VALOR_GARANTIA_DIA = ROUND(VALOR_GARANTIA_DIA * 0.775)
        WHERE NRO_PATENTE = v_patente;
    END IF;

    COMMIT;

--     DBMS_OUTPUT.PUT_LINE('NRO_PATENTE: ' || v_patente);
--     DBMS_OUTPUT.PUT_LINE('VALOR_ARRIENDO_DIA: ' || v_valor_arriendo_dia);
--     DBMS_OUTPUT.PUT_LINE('VALOR_GARANTIA_DIA: ' || v_valor_garantia_dia);
--     DBMS_OUTPUT.PUT_LINE('CANTIDAD_ARRIENDOS: ' || v_cantidad_arriendos);
--     DBMS_OUTPUT.PUT_LINE('ANNO: ' || v_anno_pasado);

END;

SELECT c.NRO_PATENTE,
           c.VALOR_ARRIENDO_DIA,
           c.VALOR_GARANTIA_DIA,
           COUNT(ac.ID_ARRIENDO)
    FROM CAMION c
             INNER JOIN MDY3131_P2.ARRIENDO_CAMION AC on c.NRO_PATENTE = AC.NRO_PATENTE
    WHERE TO_CHAR(AC.FECHA_INI_ARRIENDO, 'YYYY') = '2023'
    HAVING COUNT(ac.ID_ARRIENDO) < 5
    group by c.VALOR_GARANTIA_DIA, c.VALOR_ARRIENDO_DIA, c.NRO_PATENTE;