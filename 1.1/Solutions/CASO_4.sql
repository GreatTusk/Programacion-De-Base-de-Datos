DECLARE
    v_tipo_propiedad VARCHAR2(50);
    v_cantidad       NUMBER;
    v_valor_total    VARCHAR2(50);
    v_resumen        VARCHAR2(100) := 'RESUMEN DE: ';
    v_total_prop     VARCHAR2(100) := 'TOTAL PROPIEDADES: ';
    v_total_valor    VARCHAR2(100) := 'VALOR TOTAL ARRIENDO: ';
    TYPE v_lista_tipos IS TABLE OF VARCHAR2(50);
    v_tipos          v_lista_tipos := v_lista_tipos('Casa sin Amoblar',
                                                    'Casa Amoblada',
                                                    'Departamento sin Amoblar',
                                                    'Departamento Amoblado',
                                                    'Local Comercial',
                                                    'Parcela sin Casa',
                                                    'Parcela con Casa',
                                                    'Sitio');
BEGIN
    FOR i IN 1..v_tipos.count LOOP
        BEGIN
            SELECT t.DESC_TIPO_PROPIEDAD,
                   COUNT(p.NRO_PROPIEDAD),
                   TO_CHAR(SUM(p.VALOR_ARRIENDO), '$999,999,999')
            INTO v_tipo_propiedad, v_cantidad, v_valor_total
            FROM PROPIEDAD p
                     INNER JOIN TIPO_PROPIEDAD t ON p.ID_TIPO_PROPIEDAD = t.ID_TIPO_PROPIEDAD
            WHERE t.DESC_TIPO_PROPIEDAD = v_tipos(i)
            GROUP BY t.DESC_TIPO_PROPIEDAD;

            DBMS_OUTPUT.PUT_LINE(v_resumen || v_tipo_propiedad);
            DBMS_OUTPUT.PUT_LINE(v_total_prop || v_cantidad);
            DBMS_OUTPUT.PUT_LINE(v_total_valor || v_valor_total);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for ' || v_tipos(i));
        END;
    END LOOP;
END;
