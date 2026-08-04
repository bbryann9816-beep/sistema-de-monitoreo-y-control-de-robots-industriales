SELECT
    id_calibracion,
    resultado,
    metodo,
    proxima_calibracion,
    observaciones
FROM calibraciones
WHERE resultado = 'aprobado'
AND   metodo    = 'patron_nist'
ORDER BY proxima_calibracion DESC LIMIT 3 OFFSET 0;

SELECT
    r.nombre       as 'Robot',         
    m.nombre       as 'Marca',        
    m.pais_origen  as 'País'           
FROM        robots r                    
INNER JOIN  marcas m                   
ON          r.id_marca = m.id_marca;  


SELECT
    s.num_serie                     as 'Número de serie',
    s.tipo_sensor                   as 'Tipo de sensor',
    s.ubicacion                     as 'Ubicacion',
    unidad_medida                   as 'Unidad de media',
    r.nombre                        as 'Nombre del robot'
FROM        sensores s 
INNER JOIN  robots r
ON          s.id_robot = r.id_robot
WHERE       s.tipo_sensor =            'temperatura'        
ORDER BY    r.nombre ASC;

SELECT                                                                                  
                ot.id_orden                             AS 'Orden de trabajo',
                ot.tipo_trabajo                         AS 'Tipo de trabajo',
                ot.estado                               AS 'Estado',
                r.nombre                                AS 'Nombre del robot',
                op.nombre                               AS 'Nombre del operador',
                op.apellido                             AS 'Apellido del operador'
FROM            ordenes_trabajo ot
INNER JOIN      robots r 
ON              ot.id_robot=r.id_robot
INNER JOIN      operadores op
ON              ot.id_operador=op.id_operador
ORDER BY        ot.id_orden ASC;

SELECT
                c.id_calibracion                        AS 'ID de calibracion',
                c.resultado                             AS 'Resultado',
                c.metodo                                AS 'Metodo',
                s.tipo_sensor                           AS 'Tipo de sensor',
                s.ubicacion                             AS 'Ubicacion',
                op.nombre                               AS 'Nombre del operador',
                op.apellido                             AS 'Apellido del operador'
FROM            calibraciones c 
INNER JOIN      sensores s 
ON              c.id_sensor=s.id_sensor
INNER JOIN      operadores op         
ON              c.id_operador=op.id_operador
WHERE           c.resultado                             IN ('rechazado','ajuste_menor')
ORDER BY        c.id_calibracion                        ASC;

SELECT
                op.nombre                               AS 'Nombre del operador',
                op.apellido                             AS 'Apellido del operador',
                COUNT(*)                                AS 'Total Ordenes'
FROM            calibraciones c   
INNER JOIN      operadores OP
ON              c.id_operador=op.id_operador
GROUP BY        op.id_operador, op.nombre, op.apellido
ORDER BY        COUNT(*)                              DESC;     
                

SELECT 
                op.nombre                                AS 'Nombre del operador',                     
                op.apellido                              AS 'Apellido del operador',       
                COUNT(*)                                 AS 'Total de ordenes',
                SUM(ot.duracion_horas)                   AS 'Horas de trabajo'
FROM            ordenes_trabajo ot 
INNER JOIN      operadores OP
ON              ot.id_operador=op.id_operador              
GROUP BY        op.id_operador, op.nombre, op.apellido
ORDER BY        COUNT(*)                                DESC;


SELECT
                r.nombre                        AS      'Nombre del Robot',
                COUNT(*)                        AS      'Total',
                r.estado                        AS      'Estado del Robot'
FROM            ordenes_trabajo ot
INNER JOIN      robots r  
ON              ot.id_robot=r.id_robot
GROUP BY        r.id_robot, r.nombre, r.estado
HAVING          COUNT(*)>=1
ORDER BY        COUNT(*)                        DESC;   

SELECT
                op.nombre       AS 'Nombre del operador',
                op.apellido     AS 'Apellido del operador',
                COUNT(*)        AS 'Numero de equipos totales calibrados por operador'
FROM            calibraciones c 
INNER JOIN      operadores OP 
ON              c.id_operador=op.id_operador
GROUP BY        op.id_operador, op.nombre, op.apellido
HAVING          COUNT(*)>=2
ORDER BY        COUNT(*)        DESC;

SELECT
                s.tipo_sensor           AS 'Tipo de sensor',
                COUNT(*)                AS 'Total',
                AVG(c.valor_antes)      AS 'Promedio'
FROM            calibraciones c
INNER JOIN      sensores s
ON              c.id_sensor = s.id_sensor
WHERE           c.resultado =              'aprobado'
GROUP BY        s.tipo_sensor        
HAVING          COUNT(*) > 1
ORDER BY        COUNT(*) DESC;

SELECT
                r.nombre                AS 'Nombre del robot',
                r.estado                AS 'Estado del robot',
                op.nombre               AS 'Nombre del operador',
                op.apellido             AS 'Apellido del operador',
                COUNT(*)                AS 'Total',
                SUM(ot.duracion_horas)  AS 'Total horas'
FROM            ordenes_trabajo ot
INNER JOIN      robots r
ON              ot.id_robot=r.id_robot
INNER JOIN      operadores op
ON              ot.id_operador=op.id_operador
WHERE           r.estado=                  'operativo'
GROUP BY        r.id_robot, r.nombre, r.estado, op.id_operador, op.nombre, op.apellido
HAVING          COUNT(*)>=1
ORDER BY        COUNT(*)               DESC LIMIT 5 OFFSET 0;                              


SELECT  
                r.nombre                AS 'Nombre del robot',
                r.estado                AS 'Estado del robot',
                ot.id_orden             AS 'ID de la orden',
                ot.tipo_trabajo         AS 'Tipo de trabajo'
FROM            robots r
LEFT JOIN       ordenes_trabajo ot                
ON              r.id_robot=ot.id_robot
ORDER BY        r.nombre               ASC;

SELECT
                op.nombre              AS 'Nombre del operador',
                op.apellido            AS 'Apellido del operador',
                c.id_calibracion       AS 'ID calibraciones'
FROM            operadores op
LEFT JOIN       calibraciones c
ON              op.id_operador=c.id_operador
WHERE NOT       c.id_calibracion IS NULL
ORDER BY        op.nombre              ASC;


SELECT
                COUNT(*) 
FROM            ordenes_trabajo
WHERE           id_robot = 1; 

SELECT  
                estado
FROM            robots
WHERE           id_robot=1;

SELECT
                nombre,
                estado
FROM            robots
WHERE           estado = (
SELECT          estado
FROM            robots
WHERE           id_robot =1
 );

SELECT
                r.id_robot    AS 'ID del robot',
                r.nombre      AS 'Nombre del robot',
                r.estado      AS 'Estado del robot'
FROM            robots r
WHERE           id_robot IN (
SELECT          ot.id_robot
FROM            ordenes_trabajo ot
WHERE           ot.estado = 'pendiente'
);

SELECT
                r.nombre            AS 'Nombre de robot',
                r.estado            AS 'Estado del robot'
FROM            robots r
WHERE           id_robot = (
SELECT          r2.estado
FROM            robots r2
WHERE           r2.id_robot = 8    
);

SELECT 
                r.nombre            AS 'Nombre del robot',
                r.estado            AS 'Esdado del robot'
FROM            robots r
WHERE           r.id_robot IN (
SELECT          ot.id_robot
FROM            ordenes_trabajo ot
WHERE           ot.estado = 'completo'   
);

SELECT  
                op.nombre                AS 'Nombre del operador',
                op.apellido              AS 'Apellido del operador'
FROM            operadores op
WHERE           op.id_operador IN(
SELECT          c.id_operador
FROM            calibraciones c
WHERE           c.resultado = 'aprobado'     
);

SELECT
                r.id_robot              AS 'ID del robot',
                r.nombre                AS 'Nombre del robot',
                r.estado                AS 'Estado del robot'
FROM            robots r
WHERE           r.id_robot IN (                
SELECT
                ot.id_robot
FROM            ordenes_trabajo ot
WHERE           ot.tipo_trabajo = 'inspeccion'
);


SELECT
                r.id_robot              AS 'ID del robot',
                r.nombre                AS 'Nombre del robot',
                r.estado                AS 'Estado del robot'
FROM            robots r
WHERE           r.id_robot > (
SELECT          AVG(id_robot)
FROM            robots r   
);

SELECT
                op.nombre               AS 'Nombre del operador',
                op.apellido             AS 'Apellido del operador'
FROM            operadores op
WHERE           op.id_operador IN(
SELECT          c.id_operador 
FROM            calibraciones c
WHERE           c.resultado = 'rechazado'    
);                


SELECT
                r.id_robot              AS 'ID del robot',
                r.nombre                AS 'Nombre del robot',
                r.estado                AS 'Estado del robot'
FROM            robots r
WHERE           r.id_robot IN (
SELECT          ot.id_robot
FROM            ordenes_trabajo ot
WHERE           estado = 'pendiente'    
);                         

SELECT
                op. nombre             AS 'Nombre del operador',
                op.apellido            AS 'Apellido del oerador'
FROM            operadores op
WHERE           op.id_operador         IN (
SELECT          c.id_operador
FROM            calibraciones c
WHERE           c.resultado = 'aprobado'
);   

SELECT
                ot.id_orden            AS 'ID de orden',
                ot.tipo_trabajo         AS 'Tipo de trabajo',
                ot.duracion_horas      AS 'Duracion en horas'
FROM            ordenes_trabajo ot
WHERE           ot.duracion_horas     > (
SELECT          AVG(ot2.duracion_horas)
FROM            ordenes_trabajo ot2
WHERE           ot2.estado = 'completado'    
);                



SELECT
                ot.id_robot,
                COUNT(*) AS total_ordenes
FROM            ordenes_trabajo ot
GROUP BY        ot.id_robot;

SELECT          AVG(total_ordenes) AS 'Promedio de ordenes'
FROM (
    SELECT
                ot.id_robot,
                COUNT(*) AS total_ordenes
    FROM        ordenes_trabajo ot
    GROUP BY    ot.id_robot
) AS            cantidades;

SELECT
               r.id_robot           AS 'ID',
               r.nombre             AS 'Nombre del robot',
               COUNT(*)             AS 'Total'
FROM           robots r
WHERE          r.id_robot IN(
SELECT         ot.id_robot
FROM           ordenes_trabajo ot
WHERE          ot.id_robot = r.id_robot       
)
GROUP BY      r.id_robot, r.nombre
ORDER BY      total                DESC ;


SELECT  
                r.id_robot         AS 'ID',
                r.nombre           AS 'Nombre del robot',
                COUNT(*)           AS 'Total' 
FROM            robots r
WHERE           
EXISTS           (
SELECT          1
FROM            ordenes_trabajo ot
WHERE           ot.id_robot= r.id_robot
AND             ot.tipo_trabajo = 'operacion'    
)
GROUP BY       r.id_robot, r.nombre
HAVING         COUNT(*) > 2
;
     

SELECT      t.id_robot        AS 'ID',
            t.total           AS 'Total'
FROM     (
            SELECT   ot.id_robot,
                     COUNT(*)  AS total
            FROM     ordenes_trabajo ot
            GROUP BY ot.id_robot
         ) t
WHERE    t.total >= 2;

SELECT
            r.id_robot       AS 'ID',
            r.nombre         AS 'Nombre',
            r.estado         AS 'Estado'
FROM        robots r
WHERE       r.id_robot IN (
SELECT      ot.id_robot
FROM        ordenes_trabajo ot
WHERE       ot.estado = 'completado'
);             


SELECT
            op.nombre        AS 'Nombre',
            op.apellido      AS 'Apellido'
FROM        operadores op
WHERE       op.id_operador IN(
SELECT      C.id_operador
FROM        calibraciones c
WHERE       c.resultado = 'rechazado'       
);

SELECT
            r.id_robot          AS 'ID',
            r.nombre            AS 'Nombre',
            r.capacidad_carga   AS 'Capacidad de carga'
FROM        robots r
WHERE       r.capacidad_carga   >(
SELECT      r2.capacidad_carga
FROM        robots r2
WHERE       r2.nombre = 'robot_alfa'    
);            


SELECT
           ot.id_orden         AS 'ID',
           ot.tipo_trabajo     AS 'Tipo de trabjo',
           ot.duracion_horas   AS 'Duracion en horas'
FROM       ordenes_trabajo ot
WHERE      ot.duracion_horas = (
SELECT     MAX(ot2.duracion_horas)
FROM       ordenes_trabajo ot2    
);

SELECT
            r.id_robot          AS 'ID',
            r.nombre            AS 'Nombre',
            r.capacidad_carga   AS 'Capacidad de Carga'
FROM        robots r
WHERE       r.capacidad_carga = (
SELECT      MIN(r2.capacidad_carga)
FROM        robots  r2    
);            

SELECT  
            c.id_calibracion        AS 'ID',
            c.valor_antes           AS 'Valores iniciales',
            c.resultado             AS 'Resultados'
FROM        calibraciones c
WHERE       c.valor_antes > (
SELECT      AVG(c2.valor_antes)
FROM        calibraciones c2    
);

SELECT AVG(valor_antes)
FROM calibraciones;


SELECT
            r.id_robot              AS 'ID',
            r.nombre                AS 'Nombre',
            r.estado                AS 'Estado'
FROM        robots r
WHERE       r.id_robot              NOT IN (
SELECT      ot.id_robot
FROM        ordenes_trabajo ot          
);

  
SELECT
            r.id_robot              AS 'ID',
            r.nombre                AS 'Nombre',
            r.estado                AS 'Estado'
FROM        robots r
WHERE       EXISTS (
SELECT      1
FROM        ordenes_trabajo ot
WHERE       ot.id_robot = r.id_robot  
);

SELECT
            r.id_robot              AS 'ID',
            r.nombre                AS 'Nombre'
FROM        robots r
WHERE       NOT EXISTS (
SELECT      1
FROM        ordenes_trabajo ot
WHERE       ot.id_robot = r.id_robot    
);


SELECT
            r.nombre        AS 'Nombre',
            t.total         AS 'Total D'
FROM        (
SELECT      ot.id_robot,
            COUNT(*)        AS 'Total'
FROM        ordenes_trabajo ot
GROUP BY    ot.id_robot          
)                           AS t 
JOIN        robots r        ON  t.id_robot=r.nombre
WHERE       t.total > 2;

SELECT
            r.nombre        AS 'Nombre'
FROM        robots r
WHERE       r.id_robot      IN (
SELECT      ot.id_robot
FROM        ordenes_trabajo ot
WHERE       ot.estado = 'completado'    
);


SELECT
            r.nombre        AS 'Nombre'
FROM        robots r
WHERE       EXISTS (
SELECT      1
FROM        ordenes_trabajo ot
WHERE       ot.id_robot = r.id_robot
AND         ot.estado = 'pendiente'    
);            

SELECT 
            r.nombre            AS 'Nombre'
FROM        robots r
WHERE       r.id_robot = (
SELECT      ot.id_robot
FROM        ordenes_trabajo ot
GROUP BY    ot.id_robot
ORDER BY    SUM (costo) DESC
LIMIT       1          
);

CREATE TABLE IF NOT EXISTS costos (
id_costo            INT NOT NULL AUTO_INCREMENT,
id_robot            INT DEFAULT NULL,
id_orden            INT DEFAULT NULL,
id_operador         INT DEFAULT NULL,
monto               DECIMAL (10,2) NOT NULL,
tipo_costo          ENUM ('mano_obra', 'materiales_repuestos', 'contratista') NOT NULL,
descripcion         VARCHAR (100) DEFAULT NULL,
activo              TINYINT (1) NOT NULL DEFAULT 1,
created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY         (id_costo),
                    CONSTRAINT          fk_costos_robots
                    FOREIGN KEY         (id_robot) REFERENCES robots (id_robot)
                    ON DELETE RESTRICT 
                    ON UPDATE CASCADE,
                    CONSTRAINT          fk_costos_ordenes_trabajo
                    FOREIGN KEY         (id_orden) REFERENCES ordenes_trabajo (id_orden)
                    ON DELETE RESTRICT 
                    ON UPDATE CASCADE,
                    CONSTRAINT          fk_costos_operadores
                    FOREIGN KEY         (id_operador) REFERENCES operadores (id_operador)
                    ON DELETE RESTRICT 
                    ON UPDATE CASCADE                     
)ENGINE=InnoDB;


SELECT 'robots' AS tabla, COUNT(*) AS total FROM robots
UNION
SELECT 'ordenes_trabajo', COUNT(*) FROM ordenes_trabajo
UNION
SELECT 'operadores', COUNT(*) FROM operadores;

INSERT INTO costos (id_robot, id_orden, id_operador, monto, tipo_costo, descripcion) VALUES
(1, 9, 1, 150.00,  'mano_obra',              'Revisión general motor'),
(2, 10, 2, 320.50,  'materiales_repuestos',   'Cambio de sensores'),
(3, 11, 3, 200.00,  'contratista',            'Servicio externo brazo hidráulico'),
(4, 12, 4, 85.00,   'mano_obra',              'Ajuste de calibración'),
(5, 13, 5, 450.75,  'materiales_repuestos',   'Reemplazo de piezas mecánicas'),
(6, 14, 6, 130.00,  'mano_obra',              'Mantenimiento preventivo'),
(7, 15, 1, 275.00,  'contratista',            'Reparación sistema eléctrico'),
(8, 16, 2, 520.00,  'materiales_repuestos',   'Cambio de componentes críticos');


SELECT id_orden
FROM ordenes_trabajo
ORDER BY id_orden;

SELECT id_costo
FROM costos
ORDER BY id_costo;


SELECT
                r.nombre            AS 'Nombre'
FROM            robots r
WHERE           r.id_robot NOT IN (
SELECT          co.id_robot
FROM            costos co  
);

SELECT
                r.nombre            AS 'Nombre'
FROM            robots r
WHERE           r.id_robot IN (
SELECT          co.id_robot
FROM            costos co  
);


SELECT
                co.id_robot         AS 'ID',
                co.monto            AS 'Monto'
FROM            costos co
JOIN            robots r ON r.id_robot = co.id_robot
WHERE           co.monto > ALL (
SELECT          co2.monto
FROM            costos co2
WHERE           co2.tipo_costo = 'mano_obra'    
);


SELECT
                r.nombre            AS 'Nombre',
                co.monto            AS 'Monto'
FROM            costos co
JOIN            robots r ON r.id_robot = co.id_robot
WHERE           monto > ANY (
SELECT          co2.monto
FROM            costos co2
WHERE           co2.tipo_costo = 'contratista'
);                


SELECT
                r.id_robot      AS 'ID',
                r.nombre        AS 'Nombre'
FROM            robots r
WHERE           (
SELECT          COUNT(*)        AS 'Total'
FROM            costos co
WHERE           co.id_robot = r.id_robot    
) > 1;


SELECT
                r.id_robot                 AS 'ID',
                r.nombre                   AS 'Nombre',
(SELECT         COUNT(*)
FROM            costos co
WHERE           co.id_robot = r.id_robot) AS 'Total'
FROM            robots r;


SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre',
                SUM(co.monto)       AS 'Total'
FROM            costos co
JOIN            robots r ON r.id_robot = co.id_robot
GROUP BY        r.nombre, r.id_robot
HAVING          SUM(co.monto) > (
SELECT          AVG(co.monto)
FROM            costos co    
);

SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre'
FROM            robots r
WHERE           r.id_robot IN (
SELECT          co.id_robot
FROM            costos co
WHERE           co.monto > (
SELECT          AVG(co2.monto)
FROM            costos co2
WHERE           co2.tipo_costo = 'materiales_repuestos'
)    
);                


SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre',
                r.modelo            AS 'Modelo'
FROM            robots r
WHERE            
NOT EXISTS      (
SELECT          ot.id_orden
FROM            ordenes_trabajo ot
WHERE           ot.id_robot = r.id_robot    
);


SELECT
                ot.id_robot             AS 'ID',
                ot.id_orden             AS 'Orden',
                OP.id_operador          AS 'Operador'
FROM            operadores op
JOIN            ordenes_trabajo ot ON ot.id_operador = op.id_operador
WHERE           
EXISTS          (
SELECT          r.id_robot
FROM            robots r
WHERE           r.estado = 'fuera_servicio'
AND             r.id_robot = ot.id_robot    
);

SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre',
                COUNT(ot.id_orden)  AS 'Total'
FROM            robots r
left JOIN       ordenes_trabajo ot ON ot.id_robot = r.id_robot
GROUP BY        r.id_robot, r.nombre;

SELECT
                op.id_operador      AS 'ID',
                op.nombre           AS 'Nombre',
                op.apellido         AS 'Apellido',
                COUNT(co.monto)     AS 'Total monto'
FROM            operadores op
LEFT JOIN       costos co ON op.id_operador = co.id_operador
GROUP BY        op.id_operador, op.nombre, op.apellido 
ORDER BY        COUNT(co.monto) DESC;


SELECT
                s.id_sensor         AS 'ID',
                s.tipo_sensor       AS 'Tipo de sensor'
FROM            sensores s
INNER JOIN      calibraciones c ON s.id_sensor = c.id_sensor
WHERE           c.resultado = 'rechazado';


SELECT
                r.nombre            AS 'Nombre',
                r.id_robot          AS 'ID',
                AVG(co.monto)     AS 'Promedio'
FROM            robots r
JOIN            costos co ON co.id_robot = r.id_robot
GROUP BY        r.nombre, r.id_robot
HAVING          AVG(co.monto)>1000;


SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre robot',
                op.nombre           AS 'Nombre OP',
                op.apellido         AS 'apellido'
FROM            robots r
INNER JOIN      ordenes_trabajo ot ON ot.id_robot = r.id_robot
INNER JOIN      operadores op ON op.id_operador = ot.id_operador
WHERE           r.id_robot IN (
SELECT          s.id_robot
FROM            sensores s
INNER JOIN      calibraciones c ON s.id_sensor = c.id_sensor           
WHERE           c.resultado = 'pendiente'    
);


SELECT
                op.nombre           AS 'Nombre',
                op.apellido         AS 'Apellido',
                COUNT(ot.id_orden)
FROM            operadores op
INNER JOIN      ordenes_trabajo ot ON ot.id_operador = op.id_operador
GROUP BY        op.nombre, op.apellido
ORDER BY         COUNT(ot.id_orden) DESC;


SELECT
                s.tipo_sensor       AS 'Tipo de sensor',
                op.nombre           AS 'nombre',
                op.apellido         AS 'Apellido'
FROM            operadores op
INNER JOIN      calibraciones c ON c.id_operador = op.id_operador
INNER JOIN      sensores s ON s.id_sensor = c.id_sensor
WHERE           c.proxima_calibracion >= DATE_SUB (NOW(),INTERVAL 1 MONTH);


SELECT
                s.tipo_sensor       AS 'Tipo de sensor',
                COUNT(c.id_sensor)  AS 'Total'           
FROM            sensores s
INNER JOIN      calibraciones c ON c.id_sensor = s.id_sensor
GROUP BY        s.tipo_sensor
HAVING          COUNT(c.id_sensor) > 1;


SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre',
                ot.tipo_trabajo     AS 'Tipo de trabajo'
FROM            robots r
LEFT JOIN       ordenes_trabajo ot ON ot.id_robot = r.id_robot
GROUP BY        r.id_robot, r.nombre, ot.tipo_trabajo;                


SELECT
                s.id_sensor         AS 'iD',
                s.tipo_Sensor       AS 'Tipo de sensor',
                c.resultado         AS 'Resultado'
FROM            sensores s
LEFT JOIN       calibraciones c ON c.id_sensor = s.id_sensor;


SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre'
FROM            robots r
LEFT JOIN       ordenes_trabajo ot ON ot.id_robot = r.id_robot
WHERE           ot.id_robot IS NULL;


SELECT
                s.id_sensor         AS 'ID',
                s.tipo_sensor       AS 'Tipo de sensor'
FROM            sensores s
LEFT JOIN       calibraciones c ON c.id_sensor = s.id_sensor
WHERE           c.id_sensor IS NULL;


SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre'
FROM            robots r
WHERE           r.id_robot IN (
SELECT          ot.id_robot
FROM            ordenes_trabajo ot
WHERE           ot.id_orden >= 1    
);

SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre'
FROM            robots r
WHERE EXISTS    (
SELECT          1
FROM            ordenes_trabajo ot
WHERE           ot.id_orden >= 1     
);    


SELECT
                r.id_robot                AS 'ID',
(SELECT         COUNT (*)
FROM            ordenes_trabajo ot
WHERE           ot.id_robot = r.id_robot) AS 'Total Ordenes'
FROM            robots r
;


SELECT
                s.id_sensor                 AS 'ID',
(SELECT         COUNT(*)
FROM            calibraciones c
WHERE           c.id_sensor = s.id_sensor)  AS 'Total Calibraciones',
(SELECT         MAX (created_at)
FROM            calibraciones c
WHERE           s.id_sensor = c.id_sensor)  AS 'Ultima calibracion'
FROM            sensores s;


SELECT
                op.id_operador                    AS 'ID',
(SELECT         count (*)
FROM            ordenes_trabajo ot
WHERE           op.id_operador = ot.id_operador)  AS 'Total odenes',
(SELECT         MAX(created_at)
FROM            ordenes_trabajo ot2
WHERE           op.id_operador = ot2.id_operador) AS 'Ultima orden'
FROM            operadores op;


SELECT
                r.id_robot                  AS 'ID',
                r.nombre                    AS 'Nombre',
CASE 
WHEN            r.estado = 'Operativo'      THEN 'Activo'
WHEN            r.estado = 'fuera_servicio' THEN 'Inactivo'
ELSE            'Activo'  
END AS          'Activo'
FROM            robots r;

SELECT
                s.id_sensor                   AS   'ID',
CASE
    WHEN        s.tipo_Sensor = 'temperatura' THEN 'Sensor de Temperatura'
    WHEN        s.tipo_Sensor = 'presion'     THEN 'Sensor de Presión'
    WHEN        s.tipo_Sensor = 'humedad'     THEN 'Sensor de Humedad'
    ELSE                                           'resultado por defecto'
END AS                                             'Tipo desconocido'
FROM            sensores s;          


SELECT
                r.id_robot          AS 'ID',
                r.id_marca          AS 'Marca',
                r.nombre            AS 'Nombre',
                COUNT(*)            AS 'Total'   
FROM            robots r
JOIN            ordenes_trabajo ot  ON ot.id_robot = r.id_robot
JOIN            marcas m            ON m.id_marca  = r.id_marca
GROUP BY        r.id_robot
ORDER BY        COUNT(*) DESC;

SELECT
                r.id_robot          AS 'ID',
                r.nombre            AS 'Nombre',
                COUNT(*)            AS 'Total'
FROM            robots r
JOIN            ordenes_trabajo ot  ON ot.id_robot = r.id_robot
GROUP BY        r.id_robot, r.nombre
HAVING          COUNT(*) > 2
ORDER BY        COUNT(*) DESC;

SELECT
               ot.id_robot          AS 'ID',
               ot.id_orden          AS 'Orden',
CASE 
    WHEN        ot.prioridad = 'alta'   THEN    'Alta Prioridad'
    WHEN        ot.prioridad = 'media'  THEN    'Media Prioridad'
    WHEN        ot.prioridad = 'baja'   THEN    'Baja Prioridad' 
    ELSE                                        'Sin clasificar'  
END                                 AS 'Calificacion'
FROM            ordenes_trabajo ot
JOIN            robots r ON r.id_robot = ot.id_robot;


SELECT
                r.id_robot                  AS 'ID robot',
                r.nombre                    AS 'Nombre del robot',    
                op.id_operador              AS 'ID operador',
                op.nombre                   AS 'Nombre',
                op.apellido                 AS 'Apellido',
                COUNT(*)                    AS 'Total'

FROM            operadores op
JOIN            ordenes_trabajo ot ON ot.id_operador = op.id_operador
JOIN            robots r           ON r.id_robot = ot.id_robot
GROUP BY        r.id_robot, r.nombre, op.id_operador, op.nombre, op.apellido
HAVING          COUNT(*) > 1
ORDER BY        COUNT(*) DESC;




