--1.	Nombre de los pasajeros veganos nacidos en los años 80.
SELECT P.NOM
FROM PASSATGER P
WHERE P.DATA_NAIXEMENT BETWEEN TO_DATE('01/01/1980','dd/mm/yyyy') AND TO_DATE('31/12/1989','dd/mm/yyyy')
AND P.OBSERVACIONS = 'Vega/na'
ORDER BY 1;

--2. Suma del precio de todas las reservas realizadas por Bar 20 pa K.
SELECT SUM(R.PREU)
FROM RESERVA R, COMPRADOR C
WHERE C.NIF = R.COMPRADOR
AND C.NOM = 'Bar 20 pa K'
ORDER BY 1;

--3. Día de la semana y número de vuelos diferentes en los que ha pilotado Charles Augustus Lindbergh cada día diferente de la semana en que ha tenido vuelo.
SELECT V.DIA, COUNT(V.DIA)
FROM PERSONAL P, PERSONAL_AVIO PA, AVIO A, VOL V
WHERE P.SS = PA.SS 
AND PA.MATRICULA = A.MATRICULA
AND V.AVIO = A.MATRICULA
AND P.NOM = 'Charles Augustus Lindbergh'
GROUP BY V.DIA
ORDER BY 1,2;

--4. Nombre y nacionalidad de los compradores con dos o más reservas.
SELECT C.NOM, C.PAIS
FROM COMPRADOR C, RESERVA R
WHERE C.NIF = R.COMPRADOR
GROUP BY C.NOM, C.PAIS
HAVING COUNT(C.NOM) >= 2 --HAVING COUNT(*)>=2 TAMBE ES CORRECTE
ORDER BY 1, 2;

--5. Nombre, ciudad y país del aeropuerto del que han salido más vuelos. Indicar también el número de vuelos.
SELECT A1.NOM, A1.CIUTAT, A1.PAIS, COUNT(A1.NOM)
FROM AEROPORT A1, VOL V1
WHERE A1.CODI_AEROPORT = V1.ORIGEN
GROUP BY A1.NOM, A1.CIUTAT, A1.PAIS
HAVING COUNT(A1.NOM) =
(SELECT MAX(N_VUELOS) FROM(SELECT COUNT(A.NOM) AS N_VUELOS
FROM AEROPORT A, VOL V
WHERE A.CODI_AEROPORT = V.ORIGEN
GROUP BY A.NOM));

 --6. Nombre del piloto que más horas de vuelo ha acumulado.
SELECT PE1.NOM
FROM PILOT P1, PERSONAL PE1
WHERE PE1.SS = P1.SS
AND P1.HORES_VOL = (SELECT MAX(P.HORES_VOL)
                          FROM PILOT P)
ORDER BY 1;

 --7. Aeropuerto (nombre, ciudad, país) que no es destino de ningún vuelo.
SELECT A.NOM, A.CIUTAT, A.PAIS
FROM AEROPORT A, VOL V
MINUS
(SELECT A.NOM, A.CIUTAT, A.PAIS
FROM AEROPORT A, VOL V
WHERE A.CODI_AEROPORT = V.DESTI)
ORDER BY 1;

--1. Nom de tots els auxiliars.
SELECT P.NOM
FROM PERSONAL P, AUXILIAR A
WHERE A.SS = P.SS
ORDER BY 1;

--2. Nom dels passatgers que han volat en primera classe.
SELECT DISTINCT P.NOM
FROM PASSATGER P, BITLLET B, VIATGES VI
WHERE B.PASSATGER = VI.NIF_PASSATGER
AND P.NIF = VI.NIF_PASSATGER
AND B.CATEGORIA = 'Primera'
ORDER BY 1;

--Segona forma de fer el exercici 2 (join de codivol enlloc de passatger)
SELECT DISTINCT P.NOM
FROM PASSATGER P, VIATGES V, BITLLET B
WHERE P.NIF=V.NIF_PASSATGER
AND V.CODI_VOL=B.CODI_VOL
AND V.NIF_PASSATGER=B.PASSATGER
AND B.CATEGORIA='Primera'
ORDER BY 1;

--3. Nombre de vols per model d’avió. Es demana el model i el nombre de vols. 
SELECT A.MODEL, COUNT(*) AS NUM_VOLS --COUNT(V.AVIO) AS X tambe es correcte
FROM AVIO A, VOL V
WHERE A.MATRICULA = V.AVIO
GROUP BY A.MODEL 
ORDER BY 1,2;

--4. Data i codi de vol dels vols que tenen fetes més de 2 reserves diferents. Recordeu que una reserva ve donada pel seu localitzador.
SELECT B.DATA, B.CODI_VOL --TO_CHAR(B.DATA,'dd/mm/yyyy') ES UN ALTRE FORMAT CORRECTE
FROM BITLLET B, RESERVA R
WHERE B.NUMERO_RESERVA = R.LOCALITZADOR
GROUP BY B.CODI_VOL, B.DATA
HAVING COUNT(*)>2
ORDER BY 1,2;

--5. Nom de la(/es) companyia(/es) amb mès butaques reservades per algun dels seus vols. Es demana nom de la companyia y nombre de butaques reservades. Recordeu que els vols s'identifiquen pel codi i la data.
SELECT V.COMPANYIA, COUNT(*) AS NUM_BUTAQUE
FROM VOL V, BUTAQUES B, AVIO A, BITLLET BI
WHERE V.AVIO = A.MATRICULA
AND A.MATRICULA = B.MATRICULA_AVIO
AND B.MATRICULA_AVIO = BI.MATRICULA_AVIO
AND BI.NUMERO_RESERVA = (SELECT MAX(B1.NUMERO_RESERVA) FROM BITLLET B1 )
GROUP BY V.COMPANYIA
ORDER BY 1,2; ---POT ESTAR CORRECTA

--6	Nom de l'aeroport espanyol que va rebre menys numero de passatgers.
SELECT A1.NOM
FROM AEROPORT A1, BITLLET B1
WHERE B1.CODI_AEROPORT = A1.CODI_AEROPORT 
AND A1.PAIS = 'Espanya'
GROUP BY A1.NOM
HAVING COUNT(A1.NOM) =
(SELECT MIN(COUNT(A.NOM))
FROM AEROPORT A, BITLLET B
WHERE B.CODI_AEROPORT = A.CODI_AEROPORT 
AND A.PAIS = 'Espanya'
GROUP BY A.NOM)
ORDER BY 1;

--1. Nombre de pasajeros Españoles nacidos mas tarde de 1980
SELECT P.NOM
FROM PASSATGER P
WHERE P.DATA_NAIXEMENT > TO_DATE('01/01/1980','dd/mm/yyyy')
AND P.PAIS = 'Espanya'
ORDER BY 1;

--2. Países a los que pertenecen los pilotos de aviones de la base de datos.
SELECT PE.PAIS
FROM PERSONAL PE, PILOT P
WHERE P.SS = PE.SS
ORDER BY 1;

--3. Butacas (fila y letra) diferentes de los billetes del pasajero Borja Mon de York en cualquiera de sus viajes.
SELECT DISTINCT B.FILA_SEIENT, B.LLETRA_SEIENT --ES POT UTILITZAR UN GROUP BY ENLLOC DE UN DISTINCT
FROM BITLLET B, VIATGES VI, PASSATGER P
WHERE B.PASSATGER = VI.NIF_PASSATGER
AND VI.NIF_PASSATGER = P.NIF
AND P.NOM = 'Borja Mon de York'
ORDER BY 1,2;

--4. Nombre, ciudad y país de los aeropuertos de los que han salido más de 5 vuelos diferentes, independientemente del número de fechas en que haya operado cada vuelo.
SELECT A.NOM, A.CIUTAT, A.PAIS
FROM AEROPORT A, VOL V
WHERE A.CODI_AEROPORT = V.ORIGEN
GROUP BY A.NOM, A.CIUTAT, A.PAIS
HAVING COUNT(DISTINCT V.CODI)>5 
ORDER BY 1,2,3;

--1. Nombre de pasajeros españoles nacidos en los años 90.
SELECT P.NOM
FROM PASSATGER P
WHERE P.DATA_NAIXEMENT BETWEEN TO_DATE('01/01/1990','dd/mm/yyyy') AND TO_DATE('31/12/1999','dd/mm/yyyy')
AND P.PAIS = 'Espanya'
ORDER BY 1;

--2. Peso total facturado por Chema Pamundi en el total de sus vuelos.
SELECT SUM(M.PES) AS PES_TOTAL
FROM MALETA M, BITLLET B, VIATGES V, PASSATGER P
WHERE M.PASSATGER = B.PASSATGER
AND B.PASSATGER = V.NIF_PASSATGER
AND V.NIF_PASSATGER = P.NIF
AND P.NOM = 'Chema Pamundi'
GROUP BY M.PES
ORDER BY 1;

--3. Código de vuelo y número de fechas diferentes en que ha operado cada vuelo de la compañía IBERIA.
SELECT V.CODI, COUNT(DISTINCT V.CODI) AS DATES_DIF
FROM VOL V
WHERE V.COMPANYIA = 'IBERIA'
GROUP BY V.CODI
ORDER BY 1,2;

--4. Horario de salida de vuelos en la cual salen más de 2 vuelos hacia España, independientemente del vuelo concreto del que se trate. Indicar también el número de vuelos hacia España que salen en cada uno de estos horarios.
SELECT TO_CHAR(V.HORA_SORTIDA,'HH24:MI:SS'), COUNT(*) AS NUM_VOLS
FROM VOL V, AEROPORT A
WHERE V.DESTI = A.CODI_AEROPORT
AND A.PAIS = 'Espanya'
GROUP BY TO_CHAR(V.HORA_SORTIDA,'HH24:MI:SS')
HAVING COUNT(*)> 2
ORDER BY 1,2;

--5. Día(s) de la semana en el que hay menos vuelos con destino a China (Xina).
SELECT V.DIA
FROM VOL V, AEROPORT A
WHERE V.DESTI = A.CODI_AEROPORT
AND A.PAIS = 'Xina'
GROUP BY V.DIA
HAVING COUNT(V.CODI) = (SELECT MIN(COUNT(V1.CODI))
                  FROM VOL V1, AEROPORT A1
                  WHERE V1.DESTI = A1.CODI_AEROPORT
                  AND A1.PAIS = 'Xina'
                  GROUP BY V1.CODI)
ORDER BY 1;

--6. Nombre y nacionalidad de los pasajeros cuyo país tiene 5 aeropuertos.
SELECT DISTINCT P1.NOM, P1.PAIS
FROM PASSATGER P1, VIATGES VI1, VOL VO1, AEROPORT A1
WHERE P1.NIF=VI1.NIF_PASSATGER
AND VI1.CODI_VOL=VO1.CODI
AND VO1.ORIGEN=A1.CODI_AEROPORT
AND P1.PAIS=(SELECT A.PAIS
FROM AEROPORT A
GROUP BY A.PAIS
HAVING COUNT(A.PAIS)>5)
ORDER BY 1,2;

--7. Nombre de los pasajeros que no han facturado más de 10 kilos en ninguno de sus vuelos.
SELECT P.NOM
FROM PASSATGER P, MALETA M
MINUS (SELECT P.NOM
      FROM PASSATGER P, MALETA M
      WHERE M.PASSATGER = P.NIF
      GROUP BY P.NOM
      HAVING SUM(M.PES) > 10)
ORDER BY 1;

--1. Nom de tots els pilots
SELECT P.NOM
FROM PERSONAL P, PILOT PI
WHERE PI.SS = P.SS
ORDER BY 1;

--2. Nom dels aeroports d’Espanya d'on surten vols.
SELECT DISTINCT A.NOM
FROM AEROPORT A, VOL V
WHERE V.ORIGEN = A.CODI_AEROPORT 
AND A.PAIS = 'Espanya'
ORDER BY 1;

--3. Nombre de Bitllets venuts de cada companyia durant el 2013. Es demana la companyia i nombre de bitllets.
SELECT V.COMPANYIA, COUNT(*) AS NUM_BITLLET
FROM VOL V, BITLLET B, VIATGES VI
WHERE V.CODI = VI.CODI_VOL
AND VI.CODI_VOL = B.CODI_VOL
AND B.DATA BETWEEN TO_DATE('1/1/2013','dd/mm/yyyy') AND TO_DATE('31/12/2013','dd/mm/yyyy')
GROUP BY V.COMPANYIA
ORDER BY 1,2;

--4. Data i codi de vol dels vols amb 5 passatgers o més amb bitllet.
SELECT B.CODI_VOL, TO_CHAR(B.DATA,'dd/mm/yyyy') AS DATA
FROM BITLLET B
GROUP BY B.CODI_VOL, TO_CHAR(B.DATA,'dd/mm/yyyy')
HAVING COUNT(*)>= 5 
ORDER BY 1,2;
