DESCRIBE PRODUCTO_INVERSION_CLIENTE;
DESCRIBE CLIENTE;

SET SERVEROUT ON;
var b_run NUMBER;
EXEC b_run := &run;

DECLARE
    v_nro_cli NUMBER;
    v_run VARCHAR2(20);
    v_nombre_cli VARCHAR2(100);
    v_ofi_cli VARCHAR2(100);
    v_total_ahorrado NUMBER;
    v_fecha_cumple date;
    v_cumpleannos VARCHAR2(30);
    
   
    v_monto_giftcard NUMBER(10);
    v_detalle VARCHAR2(100) := NULL;
BEGIN
    
    SELECT 
        pi.NRO_CLIENTE,
        TO_CHAR(cli.NUMRUN, '09G999G999') || '-' || cli.DVRUN,
        INITCAP(cli.PNOMBRE || ' ' || cli.SNOMBRE  || ' ' || cli.APPATERNO  || ' ' || cli.APMATERNO),
        po.NOMBRE_PROF_OFIC,
        cli.FECHA_NACIMIENTO,
        SUM(pi.MONTO_TOTAL_AHORRADO)
    INTO 
        v_nro_cli, v_run, v_nombre_cli, v_ofi_cli, v_fecha_cumple, v_total_ahorrado
    FROM
        PRODUCTO_INVERSION_CLIENTE pi
    INNER JOIN
        CLIENTE cli ON cli.nro_cliente = PI.nro_cliente
    INNER JOIN
        PROFESION_OFICIO po ON cli.COD_PROF_OFIC = po.COD_PROF_OFIC 
    WHERE 
        cli.NUMRUN = :b_run
    group by pi.NRO_CLIENTE, TO_CHAR(cli.NUMRUN, '09G999G999') || '-' || cli.DVRUN, INITCAP(cli.PNOMBRE || ' ' || cli.SNOMBRE || ' ' || cli.APPATERNO || ' ' || cli.APMATERNO), po.NOMBRE_PROF_OFIC, cli.FECHA_NACIMIENTo ;
        
    v_cumpleannos := TO_CHAR(v_fecha_cumple, 'DD "de" Month');
    
    v_monto_giftcard :=
        CASE
            WHEN v_total_ahorrado <= 900000 THEN 0
            WHEN v_total_ahorrado <= 2000000 THEN 50000
            WHEN v_total_ahorrado <= 5000000 THEN 100000
            WHEN v_total_ahorrado <= 8000000 THEN 200000
            WHEN v_total_ahorrado <= 15000000 THEN 300000
            else null
        END;
        
    IF EXTRACT(MONTH FROM v_fecha_cumple) = EXTRACT(MONTH FROM SYSDATE) + 1 THEN
        v_detalle := 'El cliente no está de cumpleaños en el mes pasado';
    END IF;
    
    INSERT INTO CUMPLEANNO_CLIENTE VALUES(v_nro_cli, v_run, v_nombre_cli, v_ofi_cli, v_cumpleannos,v_monto_giftcard, v_detalle );
    commit;
END;
