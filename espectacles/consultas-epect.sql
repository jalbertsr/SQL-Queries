-- 1. Codi, nom i població dels recintes que només tenen una zona.
select R.codi, R.nom, R.ciutat
from Recintes RE, Zones_Recinte ZR
where R.codi = ZR.Codi_Recinte
group by R.codi, R.nom, R.ciutat
having COUNT(*) = 1
order by R.codi;

-- 2. Nom i codi del recinte del que s’han venut més entrades.
select R.nom, R.codi, COUNT (*) AS Num_entrades
from Recinte R, Entrades EN
where R.Codi = EN.codi_recinte
group by R.nom, R.codi
having COUNT >= ALL ( select COUNT(*)
from Entrades EN2
group by EN2.codi recinte );

-- 3. Espectadors (DNI, nom i cognoms) que no han vist cap espectacle de El Tricicle.
select EP.dni, EP.nom, EP.cognoms
from Espectadors EP
MINUS ( select EP.dni, EP.nom, EP.cognoms
from Espectadors EP, Espectacles ES, Entrades EN
where EP.dni = EN.dni_client AND
EN.codi_espectacles = ES.codi AND
ES.nom = "El Tricicle");

-- 4. DNI dels espectadors que han assistit a tots els espectacles de l’intèpret El Tricicle
select EP.dni_client
from Espectacles EP, Entrades R
where EP.codi = EN.codi_espectacles AND
EP.Interpret = "El Tricicle"
group by EP.dni_client
having COUNT (DISTINCT EP.codi) = ( select COUNT (*)
from Espectacles EP
where EP.Interpret = "El Tricicle");

-- 5. Nombre d’espectadors per espectacle en promig.
select T1.Total_Espectadors / T2.Total_Espectacle AS PROMIG
from ( select COUNT (*) AS Total_Espectadors
from Entrades) T1
(select COUNT (*) AS Total_Espectacles
from Espectacles) T2;

-- 6. Promig d’ocupació dels espectacles de Barcelona.
select T1.Aforo_Venut / T2.Total_Aforo AS PROMIG
from ( select COUNT (*) AS Aforo_Venut
from Recinte R, Entrades EN
where R.ciutat ="Barcelona" AND
R.codi = EN.codi_recinte) T1
( select COUNT (*) AS Total_Aforo
from Recinte R, Seients S
where R.ciutat ="Barcelona" AND
R.codi = S.codi_recinte) T2;

-- 7. Nom de l’espectacle amb el preu de l’entrada més barat.
select DISTINCT EP.nom, PE.Preu AS Preu
from Espectacles EP, Preus_Espectacles PE
where EP.codi = PE.codis_espectacles AND
PE.Preu <= ( select MIN(PE2.Preu) /*Comparación de PREU con la de la entrada que tenga el precio mínimo*/
from Preus_Espectacles PE2);

-- 8. Nom de l’espectacle amb el preu de l’espectacle més car.
select EP.nom, PE:Preu AS Preu
from Espectacles EP, Preus_Espectacles PE
where EP.codi = PE.codis_espectacles AND
PE.Preu >= ( select MAX(PE2.Preu) /*Comparación de PREU con la de la entrada que tenga el precio máximo*/ 
from Preus_Espectacles PE2);

-- 9. Zona de recinte amb més capacitat i nom del recinte on es troba aquesta zona.
select R.nom, ZR.zones, ZR.capacitat AS Capacitat
from Recinte R, Zones_Recinte ZR
where R.Codi = ZR.codi_recinte AND
ZR.capacitat >= ( select MAX(ZR2.Capacitat)
from Zones_Recintes ZR2);

-- 10. Aforament total dels recintes de Barcelona
select SUM(ZR.capacitat) AS Total_Capacitat
from Recintes R, Zones_Recintes ZR
where R.codi = ZR.codi_recinte AND
R.Ciutat = "Barcelona";

-- 11. Nombre de representacions que es realitzen el 20 d’Octubre del 2011.
select Codi_Espectacle, COUNT(*) AS Num_Rep
from Representacions
where data = TO_DATE ("20/09/2011", "dd/mm/yyyy")
group by Codi_espectacle

-- 12. Nom de l’espectacle teatral amb més espectadors /*Especifica tipo*/
select ES.nom, COUNT (*) Num_Espectadors
from Espectacles ES, Entrades EN
where ES.Codi = EN.codi_espectacles AND
ES.tipus = "Teatre"
group by ES.nom
having COUNT (*) >= ALL ( select count (*)
from Espectacles ES2, Entrades EN2
where ES2.Codi = EN2.codi_espectacles AND
ES2.tipus = "Teatre"
group by ES.nom );

-- 13. Nom, ciutat i capacitat del recinte amb menys capacitat. */No especifica nada*/
select R.nom, R.ciutat, SUM(ZR.Capacitat) AS Cap_Total
from Recinte R, Zones_Recinte ZR
where R.Codi = ZR.codi_recinte
group by R.nom, R.ciutat, ZR.capacitat
having SUM(ZR.Capacitat) <= ALL ( select SUM(Capacitat)
from Zones_Recintes
group by codi_recinte);

-- 15. Intèrprets que van realitzar algun espectacle l’any 2011, però que no n’han fet
cap l’any 2012.
select DISTINCT ES.Interpret
from Espectacle ES, Representacions RE
where ES.codi = RE.codi_espectacle AND
RE.data BETWEEN TO_DATE ("01/01/2011","dd/mm/yyyy") AND
TO_DATE("31/01/2011","dd/mm/yyyy")
NOT EXIST ( select *
from Espextacles ES2, Representacions RE2
where ES2.codi = RE2.codi_espectacles AND
ES2.Interpret = ES.Interpret AND
RE2.data > TO_DATE ("01/01/2012", "dd/mm/yyyy"));

-- 16. Seients (zona, fila i número) que no s’han ocupat en cap de les representacions de El país de les cent paraules.
select S.zona, S.fila, S.numero
from Seient S, Espectacles ES
where S.codi_recinte = ES.codi_recinte AND
ES.nom = "El pais de la cent paraules"
NOT EXIST ( select *
from Entrades EN
where EN.codi_recinte = S.codi_recinte AND
EN.zona = S.zona AND
EN.fila = S.fila AND
EN.numero =S.numero AND
ES.codi = EN.codi_espectacle)
order by S.zona, S.fila, S.numero;

-- 17. Representacions d’espectacles (nom de l’espectacle, data i hora) en què s’han venut totes les entrades, ordenat per nom de l’espectacle i data.
select ES.nom, ES.data, TO_CHAR (EN.hora "HH24:Mi:SS") AS hora
from Espectacles ES, Entrades EN
where ES.codi = EN.codi_recinte AND
EXIST ( select *
from Seient S
where EN.zona = S.zona AND
EN.fila = S.fila AND
EN.numero = S.numero)
order by ES.nom, ES.data;

-- 18. Nom dels espectacles que s’han representat a Barcelona durant el mes de gener del 2012 ordenats per nombre d’entrades promig venudes per dia.
select ES.nom, COUNT (*) / COUNT (DISTINCT EN.data) AS MITJANA
from Espectacles ES, Recinte R, Representacions RS
where ES.codi = R.codi AND
R.ciutat = "Barcelona" AND
ES.Data_Inicial BETWEEN TO_CHAR ("01/01/2012","dd/mm/yyyy")
TO_CHAR ("31/01/2012","dd/mm/yyyy")
ES.Data_Final BETWEEN TO_CHAR ("01/01/2012","dd/mm/yyyy")
TO_CHAR ("31/01/2012","dd/mm/yyyy")
group by ES.nom
order by MITJANA;

-- 19. Preu màxim i mínim per cadascun dels espectacles representats al Liceu. A més dels preus s’ha de recuperar també el nom de l’espectacle i les dates inicial i final, ordenat per data d’inici.
select ES.nom, ES.data_inicial, ES.data_final, MAX (PE.preu) AS Preu_Max,
MIN(PE.preu) AS Preu_Min,
from Recintes R, Espectacles ES, Preu_Espectacle PE
where R.nom = "Liceu" AND
ES.codi_recinte = R.codi AND
PE.codi_espectacle = ES.codi AND
PE.codi_recinte = ES.codi_recinte
group by ES.nom, ES.Data_inicial, ES. Data_final
order by ES.Data_Inicial;

-- 20. Data, hora i nombre d’entrades venudes de cadascuna de les representacions de El Màgic d’Oz, ordenat per nombre d’entrades venudes.
select EN.data, TO_CHAR(EN.hora,'HH24:MI:SS'),COUNT (*) AS Num_Entrades
from Espectacles ES, Entrades EN
where ES.nom = "El Mago d' Oz" AND
EN.codi_espectacles = ES.codi;