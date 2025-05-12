-- Script para crear la base de datos ----> bdretardados		              
-- Autor. Sergio Capacho              
-- Fecha de última actualización: Jueves 01/Mayo/2025 - 08:00 Pm   

-- Abrir_Postgres_desde_consola
-- 1.- Cmd
-- 2.- C:\...> psql --version
-- 3.- C:\...> chcp 1252
--	Esto de hace para evitar que se genere una advertencia  
--	por codificación en la consola (850)
-- 4.- C:\....>  psql -h localhost -U postgres





-------------------------------------------------------------------------
-- 01.- BLOQUE CREAR BDRETARDADOS
SELECT 'Paso 00: Bloque Crear BDRETARDADOS .....'  AS paso, pg_sleep(10);
-------------------------------------------------------------------------

\! cls
\c postgres
SELECT 'Paso 01.1: Iniciando el Script.....'  AS paso, pg_sleep(01);


SELECT 'Paso 01.2: Listado BDs Actuales.....'  AS paso, pg_sleep(02);
\l


-- 0 Eliminando la base de datos si existe
SELECT 'Paso 01.3: Eliminar la  BDretardados si Existe.....'  AS paso, pg_sleep(05);
DROP DATABASE IF EXISTS bdretardados;

\l

\! cls
SELECT 'Paso 01.4: Crear BDretardados.....'  AS paso, pg_sleep(05);
CREATE DATABASE  bdretardados with ENCODING='UTF8';

/*
CREATE DATABASE bdretardados
       OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Spanish_Colombia.1252'
       LC_CTYPE = 'Spanish_Colombia.1252'
       CONNECTION LIMIT = -1;
*/

SELECT 'Paso 01.5: Conectandose a bdretardados.....'  AS paso, pg_sleep(05);
\c bdretardados






-------------------------------------------------------------------------
-- 02.- BLOQUE DE CREAR TABLAS
SELECT 'Paso 02: Bloque Crear TABLAS .....'  AS paso, pg_sleep(10);
-------------------------------------------------------------------------

-- TMSTATUS
SELECT 'Paso 02.1: Trabajando con TMSTATUS .....................'  AS paso, pg_sleep(05);
CREATE  TABLE  tmstatus(
	cods	 INTEGER	  not null      primary key  ,
	dstatus varchar(12)    not null) ;

INSERT    INTO   tmstatus  (cods,dstatus)  VALUES  (0,  'ELIMINADO'); 
INSERT    INTO   tmstatus  (cods,dstatus)  VALUES  (1,  'ACTIVO'); 

SELECT  *   FROM  tmstatus ;     



-- TMCARGOS
SELECT 'Paso 02.2: Trabajando con TMCARGOS .....................'  AS paso, pg_sleep(05);
CREATE   TABLE    tmcargos(
	codcar	 SERIAL primary key  not null,
	dcargo	 varchar(30) 		not null,
	sueldo	 decimal(12,2)  	not null,
	fkcods	 INTEGER	 	not null	 DEFAULT 1,
	foreign  key(fkcods)  references  tmstatus(cods)  on  update  cascade  on  delete    restrict );

INSERT    INTO  tmcargos (dcargo,	sueldo)	   VALUES	
		('PRESIDENTE' ,	 5000000.00) ,
		('VICE PRESIDENTE',	 4500000.00) ,
		('GERENTE' ,		 4000000.00), 
		('SUB-GERENTE' ,  	 3500000.00) ,
		('COORDINADOR',	 3000000.00),
		('SUPERVISOR', 	 2500000.00);  

SELECT    *    FROM    tmcargos ; 

SELECT codcar, dcargo, to_char( sueldo, '999G999G999D99' ) As "Sueldo"
FROM tmcargos; 



-- TMEMPLEADOS
SELECT 'Paso 02.3: Trabajando con TMEMPLEADOS.....'  AS paso, pg_sleep(05);
CREATE  TABLE   tmempleados (
		cedemple	 varchar(12) 	not null PRIMARY KEY,
		nomemple	 varchar(40)  not null,
		fecha 		 date 		not null,
		fkcodcar	 integer 	not null,
		fkcods		 integer 	not null DEFAULT 1,
		foreign  key(fkcodcar)  references  tmcargos(codcar)  on  update  cascade    on  delete  restrict,
		foreign  key(fkcods)  references  tmstatus(cods)  on  update  cascade    on  delete  restrict) ;

INSERT	  INTO  tmempleados (cedemple,	nomemple,   fecha,	fkcodcar)  VALUES 
		('1000' , 'ROBERTO JAIMES' , '1978-03-03' , 3),
		('2000' , 'ZILA CONTRERAS' , '1980-10-05' , 2),
		('3000' , 'MARTHA' 	      , '1996-11-22' , 3),
		('4000' , 'CARLOS'         , '2000-07-15' , 4),
		('5000' , 'MATIAS'         , '2005-09-25' , 4),
		('6000' , 'NATASHA'	      , '2007-10-28' , 1),
		('7000' , 'PEGGY CARTER'   , '1999-08-29' , 2),
		('8000' , 'YSA CAPACHO'    , '1993-07-23' , 2),
		('9000' , 'MARIA'          , '2003-07-07' , 4);

SELECT    *    FROM    tmempleados ;  



-- TMEXCUSAS
SELECT 'Paso 02.4: Trabajando con TMEXCUSAS .......................................'  AS paso, pg_sleep(05);
CREATE    TABLE    tmexcusas(
	codexcu	  SERIAL	  not  null	 primary key,
	dexcusa	 varchar(30)	  not null,
	fkcods   	 INTEGER 	  not  null	 DEFAULT 1,
	foreign  key(fkcods)  references  tmstatus(cods)  
			on  update  cascade  on  delete  restrict)  ;

INSERT	  INTO    tmexcusas(dexcusa)    VALUES	 
 	('ME QUEDE DORMIDO' ),
	('SALI TARDE DE LA CASA'),
	('NO ME BUSCARON'),
	('PELIE CON EL AGUILA'),
	('MUCHA LLUVIA'),
	('MUCHO TRAFICO'),
	('EL CARRO NO ME QUIERE'),
 	('ME SECUESTRARON') ;

SELECT    *    FROM    tmexcusas ;  



-- TMUSUARIOS
SELECT 'Paso 02.5: Trabajando con TMUSUARIOS ..........................'  AS paso, pg_sleep(05);


CREATE  TABLE   tmusuarios (
	nu	  SERIAL 	  not null    primary key,
	nombre	  varchar(40)	  not null,
	usuario  varchar(40)	  not null,
	clave    varchar(40)	  not null,
	nivel    integer	  not null, 
	fkcods	  integer 	  not null	 DEFAULT 1,
	foreign  key(fkcods)  references  tmstatus(cods)  
			on  update  cascade  on  delete    restrict );

INSERT  INTO  tmusuarios (nombre,	usuario, clave, nivel)  VALUES
	('WILFREDO',  'CERO',	1234, 	0), /* 0--> Usuario suspendido   */	
	('YSA',	'UNO',		1234,	1), /* 1--> Módulo Maestros      */
	('GREISY',	'DOS',		1234,	2), /* 2--> Módulo Procesos      */
	('ZILA',	'TRES',	1234,	3), /* 3--> Módulo Reportes      */
	('SERGIO',	'CUATRO',	1234,	4); /* 4--> Acceso total         */
						    /*  --> Niveles de Usuario.  */
SELECT  *  FROM  TMUSUARIOS;  



-- TDRETARDOS
SELECT 'Paso 02.6: Trabajando con TDRETARDOS ..................'  AS paso, pg_sleep(05);
CREATE   TABLE  tdretardos(
	nr	  	SERIAL		not null PRIMARY KEY,
	fkcedemple	varchar(12) 	not null,
	fkcodexcu	integer 	not null,
	fecha	  	date 		not null,
	hora	  	time 		not null,
	fkcods	  	integer 	not null DEFAULT 1,
	foreign  key(fkcedemple)  references  tmempleados(cedemple)  
			on  update  cascade  on  delete  restrict,
	foreign  key(fkcodexcu)	 references    tmexcusas(codexcu)	 
			on  update  cascade  on  delete restrict,
	foreign  key(fkcods)	 references    tmstatus(cods)	 
			on  update  cascade  on  delete restrict);
	
	
INSERT	  INTO   tdretardos  (fkcedemple,	fkcodexcu,	fecha,	hora)   VALUES 
	('2000', 3,	'2022-04-05',	'08:32:00'),
	('5000', 3,	'2022-04-05',	'08:50:00'),
	('4000', 1,	'2022-04-06',	'09:09:00'),
	('3000', 5,	'2022-04-06',	'09:13:00'),
	('6000', 7,	'2022-04-11',	'08:21:00'),
	('1000', 2,	'2022-04-14',	'08:16:00'),
	('2000', 6,	'2022-04-17',	'10:00:00'),
	('3000', 7,	'2022-04-19',	'08:11:00'),
	('2000', 3,	'2022-04-21',	'08:13:00'),
	('1000', 8,	'2022-04-21',	'08:15:00'),
	('5000', 2,	'2022-04-21',	'08:20:00'),
	('2000', 6,	'2022-04-23',	'08:27:00'),
	('3000', 4,	'2022-04-23',	'03:30:00'),
	('4000', 2,	'2022-04-23',	'08:45:00'),
	('6000', 5,	'2022-04-25',	'08:05:00'),
	('2000', 4,	'2022-04-25',	'08:32:00'),
	('4000', 1,	'2022-04-27',	'09:00:00'),
	('6000', 7,	'2022-04-28',	'09:00:00'),



	('1000', 1,	'2022-01-07',	'10:43:00'),
	('3000', 3,	'2022-01-07',	'10:50:00'),
	('4000', 7,	'2022-01-10',	'09:00:00'),
	('5000', 5,	'2022-01-12',	'08:20:00'),
	('6000', 6,	'2022-01-15',	'09:14:00'),


	('3000', 2,	'2022-05-01',	'08:40:00'),
	('2000', 8,	'2022-05-03',	'08:20:00'),
	('7000', 1,	'2022-05-05',	'09:00:00'),
	('6000', 3,	'2022-05-07',	'08:20:00'),
	('1000', 8,	'2022-05-13',	'08:17:00'),
	('4000', 2,	'2022-05-15',	'08:23:00'),
	('1000', 6,	'2022-05-16',	'09:05:00'),
	('3000', 7,	'2022-05-19',	'09:14:00'),
	('4000', 2,	'2022-05-26',	'08:17:00'),
	('4000', 5,	'2022-05-27',	'08:20:00'),
	('6000', 6,	'2022-05-27',	'08:22:00'),



	('3000', 3,	'2022-02-01',	'08:40:00'),
	('2000', 8,	'2022-02-03',	'08:20:00'),
	('5000', 6,	'2022-02-01',	'09:00:00'),
	('6000', 3,	'2022-02-07',	'08:20:00'),
	('1000', 1,	'2022-02-13',	'08:17:00'),
	('4000', 2,	'2022-02-15',	'08:23:00'),
	('1000', 5,	'2022-02-16',	'09:05:00'),
	('3000', 7,	'2022-02-19',	'09:14:00'),
	('4000', 5,	'2022-02-26',	'08:17:00'),
	('4000', 3,	'2022-02-27',	'08:20:00'),
	('6000', 6,	'2022-02-27',	'08:22:00'),


	('2000',	4,	'2022-03-05',	'08:32:00'),
	('5000',	6,	'2022-03-05',	'08:50:00'),
	('4000',	7,	'2022-03-06',	'09:09:00'),
	('3000',	3,	'2022-03-06',	'09:13:00'),
	('6000',	7,	'2022-03-11',	'08:21:00'),
	('1000',	3,	'2022-03-14',	'08:16:00'),
	('2000',	6,	'2022-03-17',	'10:00:00'),
	('3000',	5,	'2022-03-19',	'08:11:00'),
	('5000',	2,	'2022-03-21',	'08:20:00'),
	('2000',	6,	'2022-03-23',	'08:27:00'),
	('3000',	5,	'2022-03-23',	'03:30:00'),
	('4000',	7,	'2022-03-23',	'08:45:00'),
	('6000',	5,	'2022-03-25',	'08:05:00'),
	('2000',	3,	'2022-03-25',	'08:32:00'),
	('4000',	6,	'2022-03-26',	'09:00:00'),
	('6000',	5,	'2022-03-28',	'09:00:00') ,


		
	('6000',	4,	'2022-01-05',	'08:32:00'),
	('3000',	6,	'2022-01-05',	'08:40:00'),
	('2000',	7,	'2022-01-06',	'09:00:00'),
	('3000',	3,	'2022-01-06',	'09:10:00'),
	('5000',	7,	'2022-01-11',	'08:17:00'),		
	('7000',	3,	'2022-01-14',	'08:32:00'),
	('3000',	6,	'2022-01-17',	'09:47:00'),
	('6000',	2,	'2022-01-21',	'08:24:00'),
	('4000',	6,	'2022-01-23',	'08:37:00'),
	('3000',	5,	'2022-01-23',	'03:20:00'),
	('2000',	7,	'2022-01-23',	'08:15:00'),
	('1000',	5,	'2022-01-25',	'08:35:00'),
	('6000',	3,	'2022-01-25',	'08:38:00'),
	('4000',	6,	'2022-01-27',	'09:00:00'),



	('3000',	2,	'2022-06-01',	'08:40:00'),
	('2000',	8,	'2022-06-03',	'08:20:00'),
	('7000',	1,	'2022-06-05',	'09:00:00'),
	('6000',	3,	'2022-06-07',	'08:20:00'),
	('1000',	8,	'2022-06-13',	'08:17:00'),
	('4000',	2,	'2022-06-15',	'08:23:00'),
	('1000',	6,	'2022-06-16',	'09:05:00'),
	('3000',	7,	'2022-06-19',	'09:14:00'),
	('4000',	2,	'2022-06-26',	'08:17:00'),
	('4000',	5,	'2022-06-27',	'08:20:00'),
	('6000',	6,	'2022-06-27',	'08:22:00'),
	('6000',	6,	'2022-06-27',	'08:22:00'),


			
	('1000',	2,	'2022-07-01',	'08:40:00'),
	('4000',	8,	'2022-07-03',	'08:20:00'),
	('7000',	1,	'2022-07-05',	'09:00:00'),
	('5000',	3,	'2022-07-07',	'08:20:00'),
	('3000',	8,	'2022-07-13',	'08:17:00'),
	('2000',	2,	'2022-07-15',	'08:23:00'),
			

	('6000',	6,	'2022-07-16',	'09:05:00'),
	('1000',	7,	'2022-07-19',	'09:14:00'),
	('6000',	2,	'2022-07-26',	'08:17:00'),
	('7000',	5,	'2022-11-27',	'08:20:00'),
	('3000',	6,	'2022-07-27',	'08:22:00') ,


	('1000',	1,	'2022-01-01',	'08:20:00'),
	('4000',	3,	'2022-02-03',	'08:35:00'),
	('7000',	7,	'2022-03-05',	'09:11:00'),
	('5000',	6,	'2022-04-07',	'08:21:00'),
	('3000',	2,	'2022-05-13',	'08:17:00'),
	('2000',	8,	'2022-06-15',	'08:12:00'),
	('6000',	4,	'2022-07-16',	'09:15:00'),
	('1000',	6,	'2022-08-19',	'09:19:00'),
	('6000',	7,	'2022-09-26',	'08:37:00'),
	('7000',	4,	'2022-10-27',	'08:25:00'),
	('3000',	6,	'2021-11-22',	'08:41:00'), 
	
	
	
	('1000',	1,	'2022-11-01',	'08:20:00'),
	('4000',	3,	'2022-11-03',	'08:35:00'),
	('6000',	7,	'2022-11-05',	'09:11:00'),
	('5000',	6,	'2022-11-07',	'08:21:00'),
	('3000',	2,	'2022-11-13',	'08:17:00'),
	('2000',	8,	'2022-11-15',	'08:12:00'),
	('7000',	4,	'2022-11-10',	'08:27:00'),
	('6000',	4,	'2022-11-16',	'09:15:00'),
	('1000',	6,	'2022-11-19',	'09:19:00'),
	('6000',	3,	'2022-11-12',	'08:40:00'),	
	('6000',	7,	'2022-11-26',	'08:37:00'),
	('6000',	4,	'2022-11-27',	'08:25:00'),
	('3000',	6,	'2021-11-22',	'08:41:00'),
	('6000',	6,	'2022-11-03',	'09:05:00'),
	('6000',	1,	'2022-11-19',	'09:05:00');


SELECT    *    FROM    tdretardos ;  



-------------------------------------------------------------------------
-- 03.- BLOQUE CONSULTAS
SELECT 'Paso 03: Bloque CONSULTAS .....'  AS paso, pg_sleep(10);
-------------------------------------------------------------------------

SELECT 'Paso 03.1: Consulta ordenada ....................................'  AS paso, pg_sleep(05);


SELECT nr, 
	fkcedemple, 
	nomemple,
	fkcodexcu, 
	dexcusa, 
	Y.fecha, 
	Y.hora
FROM  tmempleados AS M, tdretardos AS Y, tmexcusas AS T
WHERE  ( Y.fkcedemple='6000'  and  M.cedemple='6000' ) 
		and  Y.fkcodexcu = T.codexcu  
			and  (Y.fecha >= '2022-11-01' and  Y.fecha <= '2022-11-30') 
ORDER  BY  Y.fecha DESC;



SELECT  nr,   
	fkcedemple AS "Cédula",   
	nomemple AS "Nombre",
	fkcodexcu AS "Código", 
	dexcusa, 
	tdretardos.fecha, 
	tdretardos.hora
FROM  tdretardos , tmempleados ,  tmexcusas   
WHERE  (fkcedemple = cedemple)  and   (fkcodexcu = codexcu)  and  (fkcedemple = '7000' ) 
ORDER BY tdretardos.fkcodexcu, tdretardos.fecha  ;





-----------------------------------------------------------------
--			BLOQUE JOIN
SELECT 'Paso 03.2: Bloque JOIN.....'  AS paso, pg_sleep(05);
-----------------------------------------------------------------
-- XCARGOS
CREATE   TABLE    xcargos(
	Codcar	SERIAL  primary key   not null,
	dcargo	 varchar(30) 		not null,
	sueldo	 decimal(12,2)  	not null,
	fkcods	 INTEGER	 	not null	 DEFAULT 1,
	foreign  key(fkcods)  references  tmstatus(cods) 
		on  update  cascade  on  delete    restrict )    ;

INSERT  INTO  xcargos (dcargo,  sueldo)  VALUES
	('PRESIDENTE' ,	5000000.00),
	('VICE PRESIDENTE',	4500000.00),
	('GERENTE' ,		4000000.00), 
	('SUB-GERENTE' ,	3500000.00),
	('COORDINADOR',	3000000.00),
	('SUPERVISOR', 	2500000.00);  

SELECT codcar,  dcargo, to_char( sueldo, '999G999G999D99' ) As "Sueldo"
FROM   xcargos   ;


-- XEMPLEADOS
CREATE  TABLE   xempleados ( 
	Cedemple  		varchar(12)   not null PRIMARY KEY,
	Nomemple		varchar(40)  not null,
	Fecha			date   not null,
	Fkcodcar		integer ,
	fkcods  		integer not null DEFAULT 1,
	foreign  key(fkcodcar)  references  xcargos(codcar)  
			on  update  cascade    on  delete  restrict,
	foreign  key(fkcods)  references  tmstatus(cods)  
			on  update  cascade    on  delete  restrict) ;

INSERT   INTO  xempleados (cedemple,	nomemple,   fecha,  fkcodcar)  VALUES 
	('1000' , 'ROBERTO JAIMES' ,'1978-03-03' , 3),
	('2000' , 'ZILA CONTRERAS' ,'1980-10-05' , 2),
	('3000' , 'MARTHA',		'1996-11-22' , 3),
	('4000' , 'CARLOS', 		'2000-07-15' , 4),
	('5000' , 'MATIAS', 		'2005-09-25' , 4),
	('6000' , 'NATASHA', 	'2007-10-28' , 1),
	('7000' , 'PEGGY CARTER', 	'1999-08-29' , 2),
	('8000' , 'YSA CAPACHO', 	'1993-07-23' , 2),
	('9000' , 'MARIA', 		'2003-07-07' , 4);

INSERT   INTO  xempleados (cedemple,  nomemple,   fecha)    VALUES 
	('3001' , 'RITA' , 		'1978-04-03'),
	('3002' , 'JOHANNA' , 	'1980-07-20'),
	('3003' , 'VLADIMIR' , 	'1998-05-22'),
	('3004' , 'ARMANDO' , 	'2007-07-21'),
	('7001' , 'MARIA GIL', 	'2002-04-17'),
	('7002' , 'JAMES' , 		'1997-10-28'),
	('7003' , 'FANNY', 		'1999-08-27'),
	('7004' , 'NATHALY' , 	'1993-07-23'),
	('7005' , 'THALIA' ,		'2003-07-09')   ;

SELECT * FROM xempleados ORDER BY cedemple;


-- INNER JOIN
SELECT  *
FROM	xempleados  AS   Izquierda  
JOIN   xcargos  AS   Derecha 
ON Izquierda.fkcodcar = Derecha.codcar
ORDER BY   Izquierda.cedemple ;


SELECT Izq.cedemple, Izq.nomemple, Izq.fecha, Der.dcargo
FROM   xempleados  AS Izq  
JOIN   xcargos  AS  Der 
ON     Izq.fkcodcar = Der.codcar 
ORDER BY Izq.cedemple ;


-- LEFT JOIN
SELECT Izq.cedemple,  Izq.nomemple,  Izq.fecha,  Izq.fkcodcar, Der.dcargo
FROM   xempleados  AS Izq  
LEFT JOIN   xcargos  AS  Der
ON   Izq.fkcodcar  =  Der.codcar 
ORDER BY Izq.cedemple ;


-- RIGHT JOIN
SELECT  Izq.cedemple, Izq.nomemple, Izq.fecha, Izq.fkcodcar, Der.dcargo
FROM   xempleados  AS Izq  
RIGHT JOIN   xcargos  AS  Der
ON    Izq.fkcodcar = Der.codcar 
ORDER BY Izq.cedemple ;


-- FULL JOIN
SELECT  Izq.cedemple, Izq.nomemple, Izq.fecha, Izq.fkcodcar, Der.dcargo
FROM    xempleados  AS Izq  
FULL JOIN   xcargos  AS  Der
ON    Izq.fkcodcar = Der.codcar 
ORDER BY Izq.cedemple ;


-- JOIN CON VARIAS TABLA
SELECT  cedemple AS "Cédula",
	 Nomemple AS "Nombre", 
	 fkcodcar AS "Código Cargo",
	 xcargos.dcargo,
	 xempleados.fkcods AS "Código Status",
	 tmstatus.dstatus 
FROM  xempleados 
JOIN  xcargos	  ON  xempleados.fkcodcar = xcargos.codcar
JOIN  tmstatus  ON  xempleados.fkcods = tmstatus.cods ;


SELECT  nr,   
	fkcedemple AS "Cédula",
	fkcodexcu AS "Código", 
	dexcusa, 
	Izq.fecha, 
	Izq.hora
FROM  tdretardos  AS Izq 
JOIN  tmempleados AS Der1  ON  Izq.fkcedemple = Der1.cedemple
JOIN  tmexcusas   AS Der2  ON  Izq.fkcodexcu = Der2.codexcu ;


SELECT  nr,   
	fkcedemple AS "Cédula",   
	nomemple AS "Nombre",
	fkcodexcu AS "Código", 
	dexcusa, 
	tdretardos.fecha, 
	tdretardos.hora
FROM  tdretardos , tmempleados ,  tmexcusas   
WHERE  (fkcedemple = cedemple)  and   (fkcodexcu = codexcu)  and  (fkcedemple = '7000' ) 
ORDER BY tdretardos.fkcodexcu, tdretardos.fecha  ;


SELECT  nr,   
	fkcedemple AS "Cédula",   
	nomemple AS "Nombre",
	fkcodexcu AS "Código", 
	dexcusa, 
	tdretardos.fecha, 
	tdretardos.hora
FROM  tdretardos  
INNER JOIN   tmempleados    ON  fkcedemple = cedemple
INNER JOIN   tmexcusas   ON  fkcodexcu = codexcu 
WHERE   fkcedemple = '7000'  
ORDER BY tdretardos.fkcodexcu, tdretardos.fecha  ;


SELECT  nr, 
	fkcedemple AS Cedula,  
	nomemple AS Nombre, 
	fkcodexcu AS Codigo, 
	dexcusa, 
	tdretardos.fecha, 
	tdretardos.hora
FROM  tdretardos  
INNER JOIN   tmempleados    ON  fkcedemple = cedemple
INNER JOIN   tmexcusas   ON  fkcodexcu = codexcu 
WHERE   fkcedemple = '7000'  
ORDER BY tdretardos.fkcodexcu, tdretardos.fecha;




-----------------------------------------------------------------
-- 04.- BLOQUE VISTAS
SELECT 'Paso 04: Bloque VISTAS .....'  AS paso, pg_sleep(05);
-----------------------------------------------------------------

-- to_char( Campo_Numérico, ‘999G999G999D99’ )   -----> Formato Númerico

CREATE OR REPLACE VIEW vtmcargos AS
	SELECT codcar, dcargo, to_char( sueldo, '999G999G999D99' ) As "Sueldo", dstatus, fkcods
	FROM tmcargos, tmstatus
	WHERE fkcods = cods
	ORDER BY codcar;

select * from vtmcargos;


