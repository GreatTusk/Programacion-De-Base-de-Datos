SET SERVEROUT ON;

var b_run NUMBER;
EXEC b_run := &run;

DECLARE
    v_nro_cli NUMBER;
    v_nombre_cli VARCHAR2(100);
    v_run VARCHAR2(20);
    v_tipo_cli VARCHAR2(100);
    v_monto_solicitado NUMBER;
    
--    PESOS TODOSUMA
    v_factor NUMBER(9);
    v_pesos_adicionales NUMBER(4) := 1200;
    v_pesos_total NUMBER;
    
BEGIN
    
    SELECT 
        cc.NRO_CLIENTE,
        TO_CHAR(cli.NUMRUN, '09G999G999') || '-' || DVRUN,
        cli.PNOMBRE || ' ' || cli.SNOMBRE  || ' ' || cli.APPATERNO  || ' ' || cli.APMATERNO,
        tc.NOMBRE_TIPO_CLIENTE,
        SUM(cc.MONTO_SOLICITADO)
    INTO 
        v_nro_cli, v_run, v_nombre_cli, v_tipo_cli, v_monto_solicitado
    FROM
        credito_cliente cc
    INNER JOIN
        CLIENTE cli ON cli.nro_cliente = cc.nro_cliente
    INNER JOIN
        TIPO_CLIENTE tc ON cli.cod_tipo_cliente = tc.COD_TIPO_CLIENTE 
    WHERE 
        EXTRACT(YEAR FROM FECHA_SOLIC_CRED) = EXTRACT (YEAR FROM SYSDATE) - 1
        AND
        cli.NUMRUN = :b_run
    group by cc.NRO_CLIENTE, TO_CHAR(cli.NUMRUN, '09G999G999') || '-' || DVRUN, cli.PNOMBRE || ' ' || cli.SNOMBRE || ' ' || cli.APPATERNO || ' ' || cli.APMATERNO, tc.NOMBRE_TIPO_CLIENTE; 
       
    
    
    v_factor := (v_monto_solicitado / 100000);
    
    IF v_tipo_cli = 'Trabajadores independientes' THEN
        v_pesos_adicionales :=
            CASE
                WHEN v_monto_solicitado < 1000000 THEN v_pesos_adicionales + 100
                WHEN v_monto_solicitado < 3000000 THEN v_pesos_adicionales + 300
                ELSE v_pesos_adicionales + 550
             END;
    END IF;
    
    v_pesos_total :=  round(v_factor * v_pesos_adicionales);
    
    DBMS_OUTPUT.PUT_LINE('Total pesos: ' || v_pesos_total);
    DBMS_OUTPUT.PUT_LINE('Total pesos adicionales: ' || v_pesos_adicionales);
     DBMS_OUTPUT.PUT_LINE('Factor: ' || v_factor);
--    
----    INSERT INTO cliente_todosuma VALUES(v_nro_cli, v_run, v_nombre_cli, v_tipo_cli, v_monto_solicitado, v_pesos_total);
----    COMMIT;
END;
/
--describe tipo_cliente;
--
--describe credito_cliente;
--
-- SELECT 
--        cc.NRO_CLIENTE,
--        TO_CHAR(cli.NUMRUN, '09G999G999') || '-' || DVRUN,
--        cli.PNOMBRE || ' ' || cli.SNOMBRE  || ' ' || cli.APPATERNO  || ' ' || cli.APMATERNO,
--        tc.NOMBRE_TIPO_CLIENTE,
--        SUM(cc.MONTO_SOLICITADO)
--    FROM
--        credito_cliente cc
--    INNER JOIN
--        CLIENTE cli ON cli.nro_cliente = cc.nro_cliente
--    INNER JOIN
--        TIPO_CLIENTE tc ON cli.cod_tipo_cliente = tc.COD_TIPO_CLIENTE 
--    WHERE 
--        EXTRACT(YEAR FROM FECHA_SOLIC_CRED) = EXTRACT (YEAR FROM SYSDATE) - 1
--        AND
--        cli.NUMRUN = 21242003
--    group by cc.NRO_CLIENTE, TO_CHAR(cli.NUMRUN, '09G999G999') || '-' || DVRUN, cli.PNOMBRE || ' ' || cli.SNOMBRE || ' ' || cli.APPATERNO || ' ' || cli.APMATERNO, tc.NOMBRE_TIPO_CLIENTE; 