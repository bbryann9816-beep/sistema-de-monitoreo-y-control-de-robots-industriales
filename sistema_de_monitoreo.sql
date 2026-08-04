CREATE DATABASE IF NOT EXISTS sistemas_monitoreo
character set utf8mb4
COLLATE utf8mb4_unicode_ci;

use sistemas_monitoreo;

create table if not exists marcas (
id_marca int not null auto_increment,
nombre varchar(100) not null,
pais_origen varchar(100) default null,
activo tinyint(1) not null default 1,
created_at datetime not null default current_timestamp,
primary key (id_marca)
)engine=InnoDB;

create table if not exists operadores(
id_operador int not null auto_increment,
nombre varchar(100) not null,
apellido varchar(100) not null,
num_empleado varchar(35) not null unique,
turno enum ( 'matutino','vespertino','nocturno') not null,
especialidad text,
email varchar(150) not null unique,
tel varchar(20) default null,
activo tinyint(1) not null default 1,
created_at datetime not null default current_timestamp,
updated_at datetime not null default current_timestamp on update current_timestamp,
primary key(id_operador)
)engine=InnoDB;


create table if not exists robots(
id_robot int not null auto_increment,
id_marca int default null,
nombre varchar(100) not null,
num_serie varchar(30) not null unique,
modelo varchar(100) default null,
grados_libertad int default null,
celda_trabajo varchar(100) default null,
capacidad_carga decimal(5,2) default null,
estado enum ('operativo','mantenimiento','fuera_servicio') not null default 'operativo',
activo tinyint(1) not null default 1,
created_at datetime not null default current_timestamp,
updated_at datetime not null default current_timestamp on update current_timestamp,
primary key(id_robot),
constraint fk_robot_marcas
foreign key(id_marca) references marcas (id_marca)
on delete restrict
on update cascade
)engine=InnoDB;

create table if not exists sensores (
id_sensor int not null auto_increment,
id_robot  int default null,
id_marca int default null,
tipo_sensor enum('temperatura','presion','vibracion','posicion','torque') not null,
num_serie varchar(100) not null unique,
unidad_medida varchar(100) default null,
valor_minimo decimal(7,2) default null,
valor_maximo decimal(7,2) default null,
ubicacion varchar(100) default null,
activo tinyint(1) not null default 1,
created_at datetime not null default current_timestamp,
updated_at datetime not null default current_timestamp on update current_timestamp,
primary key(id_sensor),
constraint fk_sensores_robots
foreign key(id_robot) references robots (id_robot)
on delete restrict
on update cascade,
constraint fk_sensores_marcas
foreign key(id_marca) references marcas (id_marca)
on delete restrict
on update cascade
)engine=InnoDB;

create table if not exists ordenes_trabajo (
id_orden int not null auto_increment,
id_robot int not null,
id_operador int not null,
tipo_trabajo enum ('operacion','inspeccion','ajuste','paro_programado') not null,
descripcion text default null,
prioridad enum ('baja','media','alta','critica') not null default 'media',
fecha_inicio datetime not null,
fecha_fin datetime default null,
duracion_horas decimal(5,2) default null,
estado enum ('pendiente','en_proceso','completado','cancelado') not null default 'pendiente',
observaciones text default null,
created_at datetime not null default current_timestamp,
updated_at datetime not null default current_timestamp on update current_timestamp,
primary key(id_orden),
constraint fk_ordenes_trabajo_robots
foreign key(id_robot) references robots (id_robot)
on delete restrict
on update cascade,
constraint fk_ordenes_trabajo_operadores
foreign key(id_operador) references operadores (id_operador)
on delete restrict
on update cascade
)engine=InnoDB;

create table if not exists calibraciones (
id_calibracion int not null auto_increment,
id_sensor int not null,
id_operador int not null,
valor_antes decimal(7,2) default null,
valor_despues decimal(7,2) default null,
valor_referencia decimal(7,2) default null,
resultado enum ('aprobado','rechazado','ajuste_menor') not null default 'aprobado',
metodo enum ('patron_nist','comparacion','automatico') not null default 'comparacion',
proxima_calibracion date default null,
observaciones text default null,
created_at datetime not null default current_timestamp,
primary key(id_calibracion),
constraint fk_calibraciones_sensores
foreign key(id_sensor) references sensores (id_sensor)
on delete restrict
on update cascade,
constraint fk_calibraciones_operadores
foreign key(id_operador) references operadores (id_operador)
on delete restrict
on update cascade
)engine=InnoDB;

-- insercion de datos:

INSERT INTO marcas (nombre, pais_origen, activo) VALUES
('FANUC',      'Japón',        1),
('ABB',        'Suecia',       1),
('KUKA',       'Alemania',     1),
('Yaskawa',    'Japón',        1),
('Universal',  'Dinamarca',    1),
('Epson',      'Japón',        1);

select * from marcas;

INSERT INTO operadores 
    (nombre, apellido, num_empleado, turno, especialidad, email, tel, activo) 
VALUES
('Carlos',    'Ramírez',   'EMP-2024-001', 'matutino',   
 'Soldadura Robotizada',    'carlos.ramirez@planta.com',   '5551112233', 1),

('Laura',     'Torres',    'EMP-2024-002', 'matutino',   
 'Programación CNC',        'laura.torres@planta.com',     '5554445566', 1),

('Miguel',    'Sánchez',   'EMP-2024-003', 'vespertino', 
 'Ensamble Automatizado',   'miguel.sanchez@planta.com',   '5557778899', 1),

('Ana',       'Flores',    'EMP-2024-004', 'vespertino', 
 'Metrología y Calibración','ana.flores@planta.com',       '5552223344', 1),

('Roberto',   'Mendoza',   'EMP-2024-005', 'nocturno',   
 'Mantenimiento Eléctrico', 'roberto.mendoza@planta.com',  '5559998877', 1),

('Sofía',     'Gutiérrez', 'EMP-2024-006', 'nocturno',   
 'Control y Automatización','sofia.gutierrez@planta.com',  '5553334455', 1);
 
 select * from operadores;
 
 INSERT INTO robots 
    (id_marca, nombre, num_serie, modelo, grados_libertad, 
     celda_trabajo, capacidad_carga, estado, activo)
VALUES
(1, 'Robot Soldador A1',      'FANUC-SR-001', 'ARC Mate 100iD',  6, 
    'Celda 1 - Soldadura',     12.00, 'operativo',       1),

(2, 'Robot Ensamblador B1',   'ABB-EN-002',   'IRB 2600',         6, 
    'Celda 2 - Ensamble',      20.00, 'operativo',       1),

(3, 'Robot Paletizador C1',   'KUKA-PA-003',  'KR 700 PA',        4, 
    'Celda 3 - Paletizado',   700.00, 'operativo',       1),

(4, 'Robot Pintura D1',       'YASK-PI-004',  'EPX2050',          7, 
    'Celda 4 - Pintura',        5.00, 'mantenimiento',   1),

(1, 'Robot Soldador A2',      'FANUC-SR-005', 'ARC Mate 120iD',   6, 
    'Celda 1 - Soldadura',     16.00, 'operativo',       1),

(5, 'Robot Colaborativo E1',  'UR-CO-006',    'UR10e',            6, 
    'Celda 5 - Colaborativa',  12.50, 'operativo',       1),

(6, 'Robot Dispensador F1',   'EPS-DI-007',   'T6-B901S',         6, 
    'Celda 6 - Dispensado',     1.00, 'fuera_servicio',  1),

(2, 'Robot Fresado B2',       'ABB-FR-008',   'IRB 6700',         6, 
    'Celda 7 - Fresado',       235.00,'operativo',       1);
    
select * from robots;    

INSERT INTO sensores 
    (id_robot, id_marca, tipo_sensor, num_serie, unidad_medida,
     valor_minimo, valor_maximo, ubicacion, activo)
VALUES
-- Robot 1: FANUC Soldador A1
(1, 1, 'temperatura', 'SEN-TEMP-001', '°C',    15.00, 85.00,  
    'Eje 1 - Base',         1),
(1, 1, 'vibracion',   'SEN-VIB-002',  'mm/s',   0.00, 12.50,  
    'Eje 3 - Codo',         1),
(1, 4, 'torque',      'SEN-TOR-003',  'Nm',      0.00, 150.00, 
    'Eje 6 - Muñeca',       1),

-- Robot 2: ABB Ensamblador B1
(2, 2, 'posicion',    'SEN-POS-004',  'mm',      0.00, 2600.00,
    'Eje 2 - Hombro',       1),
(2, 2, 'temperatura', 'SEN-TEMP-005', '°C',     15.00, 80.00,  
    'Controlador',          1),

-- Robot 3: KUKA Paletizador C1
(3, 3, 'presion',     'SEN-PRE-006',  'bar',     2.00, 8.00,   
    'Sistema Hidráulico',   1),
(3, 3, 'vibracion',   'SEN-VIB-007',  'mm/s',    0.00, 15.00,  
    'Eje 1 - Base',         1),

-- Robot 4: Yaskawa Pintura D1
(4, 4, 'temperatura', 'SEN-TEMP-008', '°C',     10.00, 60.00,  
    'Cabezal de Pintura',   1),
(4, 4, 'presion',     'SEN-PRE-009',  'bar',     1.50, 6.00,   
    'Sistema de Pintura',   1),

-- Robot 5: FANUC Soldador A2
(5, 1, 'temperatura', 'SEN-TEMP-010', '°C',     15.00, 85.00,  
    'Eje 1 - Base',         1),
(5, 1, 'torque',      'SEN-TOR-011',  'Nm',      0.00, 180.00, 
    'Eje 6 - Muñeca',       1),

-- Robot 6: Universal Colaborativo E1
(6, 5, 'posicion',    'SEN-POS-012',  'mm',      0.00, 1300.00,
    'TCP - Herramienta',    1),
(6, 5, 'torque',      'SEN-TOR-013',  'Nm',      0.00, 28.00,  
    'Eje 6 - Muñeca',       1);

select * from sensores;

INSERT INTO ordenes_trabajo 
    (id_robot, id_operador, tipo_trabajo, descripcion, prioridad,
     fecha_inicio, fecha_fin, duracion_horas, estado, observaciones)
VALUES
-- Órdenes completadas
(1, 1, 'operacion',      
 'Operación de soldadura chasis línea A',          
 'alta',    '2024-01-10 06:00:00', '2024-01-10 14:00:00', 8.00,   
 'completado', 'Sin novedades'),

(2, 2, 'ajuste',         
 'Ajuste de parámetros velocidad ensamble',        
 'media',   '2024-01-12 06:00:00', '2024-01-12 09:30:00', 3.50,   
 'completado', 'Velocidad reducida 10%'),

(3, 3, 'inspeccion',     
 'Inspección rutinaria sistema hidráulico',        
 'media',   '2024-01-15 14:00:00', '2024-01-15 16:00:00', 2.00,   
 'completado', 'Presión dentro de parámetros'),

(4, 4, 'paro_programado',
 'Paro programado limpieza cabezal pintura',       
 'alta',    '2024-02-01 14:00:00', '2024-02-01 18:00:00', 4.00,   
 'completado', 'Cabezal limpio y calibrado'),

-- Órdenes en proceso
(5, 1, 'operacion',      
 'Operación soldadura chasis línea B turno mañana',
 'alta',    '2024-03-01 06:00:00', NULL,                   NULL,   
 'en_proceso', NULL),

(6, 2, 'ajuste',         
 'Ajuste velocidad robot colaborativo celda 5',    
 'media',   '2024-03-05 06:00:00', NULL,                   NULL,   
 'en_proceso', 'Esperando aprobación supervisor'),

-- Órdenes pendientes
(7, 5, 'inspeccion',     
 'Revisión sistema dispensado robot F1',           
 'critica',  '2024-03-10 22:00:00', NULL,                  NULL,   
 'pendiente', 'Robot fuera de servicio requiere revisión'),

(8, 3, 'operacion',      
 'Operación fresado piezas aluminio lote 45',      
 'media',   '2024-03-15 14:00:00', NULL,                   NULL,   
 'pendiente', NULL);
 
 SHOW COLUMNS FROM ordenes_trabajo;
 
 select * from ordenes_trabajo;
 
 INSERT INTO calibraciones 
    (id_sensor, id_operador, valor_antes, valor_despues, valor_referencia,
     resultado, metodo, proxima_calibracion, observaciones)
VALUES
-- Sensor 1: Temperatura Robot FANUC A1
(1,  4, 82.50,  84.20,  85.00, 
 'aprobado',     'patron_nist',  '2024-07-10', 
 'Sensor dentro de tolerancia'),

-- Sensor 2: Vibración Robot FANUC A1
(2,  4, 13.20,  11.80,  12.50, 
 'ajuste_menor', 'comparacion',  '2024-06-15', 
 'Se ajustó amortiguador eje 3'),

-- Sensor 3: Torque Robot FANUC A1
(3,  6, 148.00, 149.50, 150.00,
 'aprobado',     'automatico',   '2024-09-01', 
 'Calibración automática exitosa'),

-- Sensor 4: Posición Robot ABB B1
(4,  4, 2598.50, 2600.10, 2600.00,
 'aprobado',     'patron_nist',  '2024-08-12', 
 'Exactitud dentro de ±0.5mm'),

-- Sensor 5: Temperatura Controlador ABB
(5,  6, 75.00,  78.50,  80.00, 
 'aprobado',     'comparacion',  '2024-07-20', 
 'Temperatura normal de operación'),

-- Sensor 6: Presión KUKA Paletizador
(6,  4, 7.80,   8.10,   8.00,  
 'rechazado',    'patron_nist',  '2024-04-01', 
 'Presión fuera de rango, revisar válvula'),

-- Sensor 7: Vibración KUKA Paletizador
(7,  6, 14.50,  14.20,  15.00, 
 'aprobado',     'automatico',   '2024-06-30', 
 'Vibración aceptable'),

-- Sensor 8: Temperatura Yaskawa Pintura
(8,  4, 58.00,  59.50,  60.00, 
 'aprobado',     'comparacion',  '2024-08-01', 
 'Post limpieza temperatura estable'),

-- Sensor 9: Presión Yaskawa Pintura
(9,  6, 5.80,   6.20,   6.00,  
 'ajuste_menor', 'patron_nist',  '2024-05-15', 
 'Se ajustó regulador de presión'),

-- Sensor 10: Temperatura FANUC A2
(10, 4, 83.00,  84.80,  85.00, 
 'aprobado',     'automatico',   '2024-09-10', 
 'Calibración rutinaria completada');
 
 select * from calibraciones;
 
 SELECT 'marcas'          AS tabla, COUNT(*) AS registros FROM marcas
UNION ALL
SELECT 'operadores',               COUNT(*)               FROM operadores
UNION ALL
SELECT 'robots',                   COUNT(*)               FROM robots
UNION ALL
SELECT 'sensores',                 COUNT(*)               FROM sensores
UNION ALL
SELECT 'ordenes_trabajo',          COUNT(*)               FROM ordenes_trabajo
UNION ALL
SELECT 'calibraciones',            COUNT(*)               FROM calibraciones;
 
 
 SELECT nombre, pais_origen FROM marcas;
 
 SELECT nombre AS 'Marca', pais_origen AS 'País de Origen' FROM marcas;
 
 select nombre, modelo, estado from robots where estado = 'operativo';
 
 select nombre, modelo, grados_libertad as 'grados de libertad', estado from robots where estado = 'operativo' and grados_libertad = 6;
 
 select num_serie as 'número de serie', tipo_sensor as' tipo de sensor', unidad_medida as 'unidad de medida' from sensores where tipo_sensor = 'temperatura' or tipo_sensor = 'presion';
 
 select num_serie as 'número de serie', tipo_sensor as' tipo de sensor', ubicacion from sensores where tipo_sensor in  ('temperatura','presion','torque');
 
 