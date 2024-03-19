DROP TABLE empleados;
DROP TABLE bono;

CREATE TABLE empleados
AS SELECT * FROM employees;

CREATE TABLE bono
(id_empleado NUMBER(6),
 bono NUMBER(8,2));