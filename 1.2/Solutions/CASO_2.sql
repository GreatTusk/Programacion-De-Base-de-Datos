SET SERVEROUT ON;
DESCRIBE EMPLEADO;

-- VARIABLE BIND CONTENIENDO EL RUT DEL EMPLEADO
VAR b_rut NUMBER;
exec b_rut := &rut;

DECLARE
    -- VARIABLES QUE ALMACENAN LOS DATOS DEL EMPLEADO
    v_dv                 EMPLEADO.DVRUN_EMP%TYPE;
    v_pnombre            EMPLEADO.PNOMBRE_EMP%TYPE;
    v_resto_nombre       VARCHAR2(50);
    v_sbase              EMPLEADO.SUELDO_BASE%TYPE;
    v_fcontrato          EMPLEADO.FECHA_CONTRATO%TYPE;
    v_apaterno           EMPLEADO.APPATERNO_EMP%TYPE;
    v_id_ecivil          EMPLEADO.ID_ESTADO_CIVIL%TYPE;
    v_id_comuna          EMPLEADO.ID_COMUNA%TYPE;
    -- VARIABLES QUE FORMAN EL NOMBRE DE USUARIO DEL EMPLEADO
    v_tres_letras_nombre VARCHAR2(3);
    v_largo_pnombre      NUMBER;
    v_sueldo_lst_digitos NUMBER;
    v_annos_en_empresa   NUMBER;
    v_nombre_usuario     VARCHAR2(20);
    -- VARIABLES QUE FORMAN LA CONTRASENA DEL USUARIO
    v_tercer_d_rut       VARCHAR2(1);
    v_anno_n_plus_two    NUMBER;
    v_fechanac           EMPLEADO.FECHA_NAC%TYPE;
    v_lst_d_sld_m_one    varchar2(3);
    v_two_char_app       VARCHAR2(3); -- Increase size to handle potential values
    v_mes_anno           VARCHAR2(6);
    v_nombre_comuna      COMUNA.NOMBRE_COMUNA%TYPE;
    v_char_at_0_comuna   VARCHAR2(2);
    v_contrasena         VARCHAR2(21);
BEGIN
    -- SENTENCIA SQL PARA OBTENER LOS DATOS DEL EMPLEADO
    SELECT DVRUN_EMP,
           PNOMBRE_EMP,
           SNOMBRE_EMP || ' ' || APPATERNO_EMP || ' ' || APMATERNO_EMP,
           SUELDO_BASE,
           FECHA_CONTRATO,
           APPATERNO_EMP,
           ID_ESTADO_CIVIL,
           ID_COMUNA,
           FECHA_NAC
    INTO v_dv, v_pnombre, v_resto_nombre, v_sbase, v_fcontrato, v_apaterno, v_id_ecivil, v_id_comuna, v_fechanac
    FROM empleado
    WHERE NUMRUN_EMP = :b_rut;

    -- FORMACION DEL NOMBRE DE USUARIO
    v_tres_letras_nombre := SUBSTR(v_pnombre, 1, 3);
    v_largo_pnombre := LENGTH(v_pnombre);
    v_sueldo_lst_digitos := SUBSTR(v_sbase, -1);
    v_annos_en_empresa := ROUND(MONTHS_BETWEEN(SYSDATE, v_fcontrato) / 12);
    v_nombre_usuario :=
            RPAD(v_tres_letras_nombre || v_largo_pnombre || '*' || v_sueldo_lst_digitos || v_dv || v_annos_en_empresa,
                 9, 'X');
        DBMS_OUTPUT.PUT_LINE(v_nombre_usuario);
    -- FORMACION DE LA CONTRASENA DEL USUARIO
    v_tercer_d_rut := SUBSTR(TO_CHAR(:b_rut), 3, 1);
    v_anno_n_plus_two := TO_NUMBER(SUBSTR(TO_CHAR(v_fechanac, 'YYYY'), 1, 4)) + 2;
    IF TO_NUMBER(SUBSTR(v_sbase, -3)) - 1 < 0 THEN
        v_lst_d_sld_m_one := '999';
    ELSE
        v_lst_d_sld_m_one := lpad(to_char(TO_NUMBER(SUBSTR(v_sbase, -3)) - 1), 3, '0');
    END IF;

    -- VARIACION SEGUN ESTADO CIVIL
    IF v_id_ecivil = 10 OR v_id_ecivil = 60 THEN
        v_two_char_app := SUBSTR(v_apaterno, 1, 2);
    ELSIF v_id_ecivil = 20 OR v_id_ecivil = 30 THEN
        v_two_char_app := SUBSTR(v_apaterno, 1, 1) || SUBSTR(v_apaterno, -1);
    ELSIF v_id_ecivil = 40 THEN
        v_two_char_app := SUBSTR(v_apaterno, -3, 2);
    ELSE
        v_two_char_app := SUBSTR(v_apaterno, -2);
    END IF;

    v_mes_anno := TO_CHAR(SYSDATE, 'MMYYYY');

    SELECT NOMBRE_COMUNA INTO v_nombre_comuna FROM COMUNA WHERE ID_COMUNA = v_id_comuna;
    v_char_at_0_comuna := SUBSTR(v_nombre_comuna, 1, 1);

    v_contrasena := v_tercer_d_rut || v_anno_n_plus_two || v_lst_d_sld_m_one || LOWER(v_two_char_app) || v_mes_anno ||
                    v_char_at_0_comuna;

    DBMS_OUTPUT.PUT_LINE(v_contrasena);

    INSERT INTO USUARIO_CLAVE VALUES (v_mes_anno, :b_rut, v_dv, v_pnombre || ' ' || v_resto_nombre, v_nombre_usuario, v_contrasena);
    COMMIT;
END;
