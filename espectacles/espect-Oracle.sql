-----------------------------------------
--
-- espect-Oracle.sq
--
-- BASE DE DADES
-- 2011-2012
-- Grau Enginyeria Informàtica
-- Escola d'Enginyeria
--
-----------------------------------------
-----------------------------------------
--
-- Aquest script:
--
--        1) Crea les taules de la base de dades ESPECTACLES,
--        2) crea les constraints, i
--        3) hi afegeix els registres. 
--
-- Si ja s'ha executat previament, l'script
-- esborra les taules de la base de dades i les torna a editar. 
-- De tal manera, cal IGNORAR els missatges d'error que dóna 
-- la primera vegada que s'executa. 
--













set termout on
prompt %
prompt %
prompt % Bases de Dades 1
prompt % Enginyeria Informàtica. 2011-2012
prompt % Escola dEnginyeria (EE)
prompt % Universitat Autònoma de Barcelona (UAB)
prompt %
prompt %
prompt %       "ESPECTACLES"  
prompt %       (Base de dades per a Oracle)
prompt %
prompt %	Aquest script:
prompt %
prompt %	        1) Crea les taules de la base de dades ESPECTACLES,
prompt %        	  2) crea les constraints, i
prompt % 	        3) hi afegeix els registres. 
prompt %
prompt % 	Si ja s'ha executat previament, l'script esborra les taules 
prompt % 	de la base de dades i les torna a editar. 
prompt %
set termout off


-- Indiquem la creació de les taules
set termout on
prompt %
prompt _
prompt _		1. Creant les taules: ESPECTACLES, ESPECTADORS, RECINTES, ZONES_RECINTE, 
prompt _                                PREUS_ESPECTACLES, SEIENTS, REPRESENTACIONS i ENTRADES
prompt _
set termout off


-- Taula ESPECTACLES
DROP TABLE ESPECTACLES CASCADE CONSTRAINTS ; 

CREATE TABLE ESPECTACLES (
  Codi          NUMBER        NOT NULL, 
  Nom           VARCHAR2 (50), 
  Tipus         VARCHAR2 (50), 
  Data_Inicial  DATE, 
  Data_Final    DATE, 
  Interpret     VARCHAR2 (50), 
  Codi_Recinte  NUMBER, 
  CONSTRAINT ESPECTACLES_PK
  PRIMARY KEY ( Codi ) ) ; 


-- Taula ESPECTADORS 
DROP TABLE ESPECTADORS CASCADE CONSTRAINTS ; 

CREATE TABLE ESPECTADORS (
  DNI             NUMBER        NOT NULL, 
  Nom             VARCHAR2 (20),
  Cognoms	      VARCHAR2 (30),
  Adreça          VARCHAR2 (50), 
  Telefon         NUMBER, 
  Ciutat          VARCHAR2 (50), 
  Compte_Corrent  VARCHAR2 (25),
  Num_Targeta     NUMBER, 
  CONSTRAINT ESPECTADORS_PK
  PRIMARY KEY ( DNI ) ) ; 


-- Taula RECINTES
DROP TABLE RECINTES CASCADE CONSTRAINTS ; 

CREATE TABLE RECINTES ( 
  Codi     NUMBER        NOT NULL, 
  Nom      VARCHAR2 (50), 
  Adreça   VARCHAR2 (50), 
  Ciutat   VARCHAR2 (50), 
  Telefon  NUMBER, 
  Horari   VARCHAR2 (50), 
  CONSTRAINT RECINTES_PK
  PRIMARY KEY ( Codi ) ) ; 

-- Taula ZONES_RECINTE
DROP TABLE ZONES_RECINTE CASCADE CONSTRAINTS ; 

CREATE TABLE ZONES_RECINTE ( 
  Codi_Recinte  NUMBER        NOT NULL, 
  Zona          VARCHAR2 (20)  NOT NULL, 
  Capacitat     NUMBER, 
  CONSTRAINT ZONES_Recinte_PK
  PRIMARY KEY ( Codi_Recinte, Zona ) ) ; 


-- Taula PREUS_ESPECTACLES
DROP TABLE PREUS_ESPECTACLES CASCADE CONSTRAINTS ; 

CREATE TABLE PREUS_ESPECTACLES ( 
  Codi_Espectacle  NUMBER        NOT NULL, 
  Codi_Recinte     NUMBER        NOT NULL, 
  Zona             VARCHAR2 (20) NOT NULL, 
  Preu             NUMBER, 
  CONSTRAINT Preus_Espectacles_PK
  PRIMARY KEY ( Codi_Espectacle, Codi_Recinte, Zona ) ) ; 


-- Taula SEIENTS 
DROP TABLE SEIENTS CASCADE CONSTRAINTS ; 

CREATE TABLE SEIENTS ( 
  Codi_Recinte  NUMBER        NOT NULL, 
  Zona          VARCHAR2 (20) NOT NULL, 
  Fila          NUMBER        NOT NULL, 
  Numero        NUMBER        NOT NULL, 
  CONSTRAINT SEIENTS_PK
  PRIMARY KEY ( Codi_Recinte, Fila, Numero, Zona ) ) ; 


-- Taula REPRESENTACIONS 
DROP TABLE REPRESENTACIONS CASCADE CONSTRAINTS ;

CREATE TABLE REPRESENTACIONS ( 
  Codi_Espectacle  NUMBER        NOT NULL, 
  Data             DATE          NOT NULL, 
  Hora             DATE          NOT NULL, 
  CONSTRAINT REPRESENTACIONS_PK
  PRIMARY KEY ( Codi_Espectacle, Data, Hora ) ) ; 


-- Taula ENTRADES 
DROP TABLE ENTRADES CASCADE CONSTRAINTS ;

CREATE TABLE ENTRADES ( 
  Codi_Espectacle  NUMBER        NOT NULL, 
  Data             DATE          NOT NULL, 
  Hora             DATE          NOT NULL, 
  Codi_Recinte     NUMBER        NOT NULL, 
  Zona             VARCHAR2 (20) NOT NULL, 
  Fila             NUMBER        NOT NULL, 
  Numero           NUMBER        NOT NULL, 
  DNI_Client       NUMBER, 
  CONSTRAINT ENTRADES_PK
  PRIMARY KEY ( Codi_Espectacle, Codi_Recinte, Data, Fila, Hora, Numero, Zona ) ) ; 


set termout on
prompt _
prompt _		2. Afegint les restriccions -constraints-: Claus foranes
prompt _
set termout off

-- Referència ESPECTACLES --> RECINTES
ALTER TABLE ESPECTACLES ADD  CONSTRAINT ESPECTACLES_FK1
 FOREIGN KEY (Codi_Recinte) 
  REFERENCES RECINTES (Codi) ;

-- Referència ZONES_RECINTE--> RECINTES
ALTER TABLE ZONES_RECINTE ADD  CONSTRAINT ZONES_RECINTE_FK1
 FOREIGN KEY (Codi_Recinte) 
  REFERENCES RECINTES (Codi) ;

-- Referència PREUS_ESPECTACLES --> ESPECTACLES
ALTER TABLE PREUS_ESPECTACLES ADD  CONSTRAINT PREUS_ESPECTACLES_FK1
 FOREIGN KEY (Codi_Espectacle) 
  REFERENCES ESPECTACLES (Codi) ;

-- PREUS_ESPECTACLES --> ZONES_RECINTE
ALTER TABLE PREUS_ESPECTACLES ADD  CONSTRAINT PREUS_ESPECTACLES_FK2
 FOREIGN KEY (Codi_Recinte, Zona) 
  REFERENCES ZONES_RECINTE (Codi_Recinte, Zona) ;

-- Referència SEIENTS --> ZONES_RECINTE
ALTER TABLE SEIENTS ADD  CONSTRAINT SEIENTS_FK1
 FOREIGN KEY (Codi_Recinte, Zona) 
  REFERENCES ZONES_RECINTE (Codi_Recinte, Zona) ;

-- Referència ENTRADES --> REPRESENTACIONS
ALTER TABLE ENTRADES ADD  CONSTRAINT ENTRADES_FK1
 FOREIGN KEY (Codi_Espectacle, Data, Hora) 
  REFERENCES REPRESENTACIONS (Codi_Espectacle, Data, Hora) ;

-- Referència ENTRADES --> SEIENTS 
ALTER TABLE ENTRADES ADD  CONSTRAINT ENTRADES_FK2
 FOREIGN KEY (Codi_Recinte, Fila, Numero, Zona) 
  REFERENCES SEIENTS (Codi_Recinte, Fila, Numero, Zona) ;

-- Referència ENTRADES --> ESPECTADORS
ALTER TABLE ENTRADES ADD  CONSTRAINT ENTRADES_FK3
 FOREIGN KEY (DNI_Client) 
  REFERENCES ESPECTADORS (DNI) ;


set termout on
prompt _
prompt _		3. Afegint Registres a les Taules
prompt _
set termout off

--
-- Inserció de dades a les taulas de la base de dades Espectacles
--


--
-- Taula ESPECTADORS
--

INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
10000000, 'Jordi', 'Robles Sánchez', 'Avda Tarraco, 35', 972773374, 'Tarragona', '1010-101-10-1000000000'
, 987654321); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
11111111, 'Pepe', 'Pinto Pando', 'C/ Pintat, 23', 938882882, 'Cerdanyola', '1111-111-11-1234567890'
, 222222222); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
22222222, 'José', 'Colorado Gris', 'C/ Colorin, 24', 938882883, 'Barcelona', '2222-222-22-2345678901'
, 333333333); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
33333333, 'Fernando', 'Vilariño Freire', 'C/ SQL, 84', 938882884, 'Cerdanyola', '3333-333-33-3456789012'
, 444444444); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
44444444, 'Enric', 'Martí Gòdia', 'C/ Date, 29', 938882885, 'Sabadell', '4444-444-44-4567890123'
, 555555555); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
55555555, 'José', 'López Lacruz', 'C/ Xirgu, 34', 938882886, 'Sant Cugat del Vallès', '5555-555-55-5678901234'
, 666666666); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
66666666, 'Luis', 'Marín Badia', 'Rambles, 87 3-1', 932083374, 'Barcelona', '6666-666-66-6789012345'
, 777777777); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
77777777, 'Emili', 'Ponce Ribes', 'Aragó, 359 4-2', 931093388, 'Barcelona', '7777-777-77-7890123456'
, 888888888); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
88888888, 'Rosa', 'Orellana Pérez', 'Merinals, 34 at-2', 937290032, 'Sabadell', '8888-888-88-8901234567'
, 999999999); 
INSERT INTO ESPECTADORS ( DNI, Nom, Cognoms, Adreça, Telefon, Ciutat, Compte_Corrent, Num_Targeta ) VALUES ( 
99999999, 'Vicenç', 'Portolés Susqueda', 'Llull, 298 4-3', 932061199, 'Barcelona', '9999-999-99-9012345678'
, 123456789); 
commit;


--
-- Taula RECINTES
--

INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
100, 'Liceu', 'Les Rambles', 'Barcelona', 935813434, '22:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
101, 'Victòria', 'Rambla, 25', 'Barcelona', 932003294, '21:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
102, 'Nacional', 'Glòries, 35', 'Barcelona', 932049937, '22:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
103, 'Romea', 'P. Urquinaona, 12', 'Barcelona', 932003769, '22:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
104, 'La Faràndula', 'Alfons XIII, 67', 'Sabadell', 937250012, '18:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
105, 'Modern', 'Vinci, 54', 'Sant Cugat del Vallès', 937149932, '18:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
106, 'Municipal', 'Riera, 35', 'Girona', 972883256, '22:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
107, 'La Seu', 'Noguera, 35', 'Lleida', 973338298, '18:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
108, 'Valira', 'Rambla, 12', 'La Seu d''Urgell', 973239941, '18:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
109, 'Coliseu', 'Avda del Mar, 87', 'Tarragona', 974992310, '17:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
110, 'Auditori', 'Glòries, 38', 'Barcelona', 932087745, '21:00'); 
INSERT INTO RECINTES ( Codi, Nom, Adreça, Ciutat, Telefon, Horari ) VALUES ( 
111, 'Palau de la Música', 'Via Layetana, 232', 'Barcelona', 932034428, '21:30'); 
commit;



--
-- Taula ESPECTACLES
--
 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1000, 'Entre Tres', 'Teatre',  TO_Date( '01/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '03/24/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'El Tricicle', 103); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1001, 'L''auca del senyor Esteve', 'Teatre',  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '03/03/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Pere Borràs', 105); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1002, 'Els Pastorets', 'Teatre',  TO_Date( '12/26/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'La Joventut de la Faràndula'
, 104); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1003, 'Concert de Nadal', 'Música',  TO_Date( '12/25/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '12/25/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Orquestra Auditori'
, 110); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1004, 'Concert d''any nou', 'Música',  TO_Date( '01/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '01/08/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Orquestra Nacional d''Austria'
, 110); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1005, 'Jazz a la tardor', 'Música',  TO_Date( '10/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '10/15/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'George Benson', 111); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1006, 'La Ventafocs', 'Teatre',  TO_Date( '10/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'La Joventut de la Faràndula'
, 104); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1007, 'El Màgic d''Oz', 'Teatre',  TO_Date( '11/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '11/17/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'La Joventut de la Faràndula'
, 106); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1008, 'Els Habitants de la Casa deshabitada', 'Teatre',  TO_Date( '12/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '12/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Sant Vicenç', 104); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1009, 'West Side Story', 'Musical',  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '11/27/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'T de Teatre', 105); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1010, 'Hamlet', 'Opera',  TO_Date( '03/30/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '04/07/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Pavarotti', 100); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1011, 'Otelo', 'Opera',  TO_Date( '10/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '01/20/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Placido Domingo'
, 100); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1012, 'La extraña pareja', 'Teatre',  TO_Date( '06/08/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '06/30/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Grup Tarraco', 102); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1013, 'La Caputxeta', 'Teatre',  TO_Date( '05/10/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '05/17/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'La Joventut de la Faràndula'
, 108); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1014, 'Pallassos sense fronteres', 'Teatre',  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Tortell Poltrona'
, 108); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1015, 'Mar i Cel', 'Musical',  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '03/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Dagoll Dagom', 101); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1016, 'El país de les Cent Paraules', 'Teatre',  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'La Joventut de la Faràndula'
, 108); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1017, 'Exit', 'Teatre',  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '01/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'El Tricicle', 109); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1018, 'Terrific', 'Teatre',  TO_Date( '03/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'El Tricicle', 106); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1019, 'Cinco Horas con Mario', 'Teatre',  TO_Date( '06/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '06/22/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Lola Herrera', 103); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1020, 'Cianur i puntes de coixí', 'Teatre',  TO_Date( '12/25/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '12/31/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Grup Tarraco', 105); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1021, 'Sweeney Todd', 'Teatre',  TO_Date( '11/11/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '11/18/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Constantino Romero'
, 106); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1022, 'Veus búlgares', 'Música',  TO_Date( '09/29/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '01/25/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Cor Nacional de Bulgària'
, 111); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1023, 'El jorobado de Notre Dame', 'Musical',  TO_Date( '03/28/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '03/28/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Dagoll Dagom', 101); 
INSERT INTO ESPECTACLES ( Codi, Nom, Tipus, Data_Inicial, Data_Final, Interpret, Codi_Recinte ) VALUES ( 
1024, 'En Patufet', 'Teatre',  TO_Date( '11/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
,  TO_Date( '11/15/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'La Joventut de la Faràndula'
, 104); 
commit;
 


--
-- Taula REPRESENTACIONS
--
 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '01/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '01/27/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/03/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/08/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/10/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/16/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/17/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/22/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '02/24/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/03/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/08/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/10/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/16/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/17/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/22/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1000,  TO_Date( '03/24/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1001,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1001,  TO_Date( '02/24/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1001,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1001,  TO_Date( '03/03/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1002,  TO_Date( '12/26/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1002,  TO_Date( '12/29/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1002,  TO_Date( '01/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1002,  TO_Date( '01/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1002,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1003,  TO_Date( '12/25/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1004,  TO_Date( '01/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1004,  TO_Date( '01/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1004,  TO_Date( '01/03/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1004,  TO_Date( '01/04/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1004,  TO_Date( '01/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1004,  TO_Date( '01/06/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1004,  TO_Date( '01/07/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1004,  TO_Date( '01/08/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1005,  TO_Date( '10/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1005,  TO_Date( '10/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1005,  TO_Date( '10/15/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1006,  TO_Date( '10/05/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1006,  TO_Date( '10/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1006,  TO_Date( '10/12/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1006,  TO_Date( '10/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1007,  TO_Date( '11/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1007,  TO_Date( '11/03/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1007,  TO_Date( '11/10/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1007,  TO_Date( '11/17/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1008,  TO_Date( '12/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1009,  TO_Date( '11/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1009,  TO_Date( '11/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1009,  TO_Date( '11/27/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1010,  TO_Date( '03/30/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1010,  TO_Date( '03/31/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1010,  TO_Date( '04/06/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1010,  TO_Date( '04/07/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '10/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '10/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '11/04/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '11/11/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '12/31/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '01/10/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '01/13/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1011,  TO_Date( '01/20/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '05/22/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/08/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/16/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/16/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/29/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/30/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1012,  TO_Date( '06/30/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1013,  TO_Date( '05/10/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1013,  TO_Date( '05/17/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '01/19/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '01/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '02/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '02/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '02/16/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '03/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '03/16/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1015,  TO_Date( '03/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1016,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1017,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1017,  TO_Date( '01/19/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1017,  TO_Date( '01/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1018,  TO_Date( '03/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1018,  TO_Date( '03/29/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1018,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1019,  TO_Date( '06/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1019,  TO_Date( '06/22/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1020,  TO_Date( '12/25/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 12:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1020,  TO_Date( '12/28/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1020,  TO_Date( '12/31/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1021,  TO_Date( '11/11/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1021,  TO_Date( '11/18/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1022,  TO_Date( '09/29/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1022,  TO_Date( '10/26/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1022,  TO_Date( '11/30/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1022,  TO_Date( '12/29/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1022,  TO_Date( '01/25/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1023,  TO_Date( '03/28/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1024,  TO_Date( '11/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO REPRESENTACIONS ( Codi_Espectacle, Data, Hora ) VALUES ( 
1024,  TO_Date( '11/15/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
commit;



--
-- Taula ZONES_Recinte
--
 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
100, 'Lateral D', 4); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
100, 'Lateral E', 4); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
100, 'Pis 1', 10); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
100, 'Pis 2', 5); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
100, 'Platea', 40); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
101, 'Pis', 10); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
101, 'Platea', 25); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
102, 'Lateral D', 5); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
102, 'Lateral E', 5); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
102, 'Pis 1', 20); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
102, 'Pis 2', 10); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
102, 'Platea', 50); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
103, 'Platea', 20); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
104, 'Pis', 10); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
104, 'Platea', 30); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
105, 'Platea', 20); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
106, 'Pis', 7); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
106, 'Platea', 20); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
107, 'Pis', 8); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
107, 'Platea', 20); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
108, 'Pis', 5); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
108, 'Platea', 20); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
109, 'Platea', 15); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
110, 'Lateral D', 8); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
110, 'Lateral E', 8); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
110, 'Pis', 10); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
110, 'Platea', 30); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
111, 'Lateral D', 5); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
111, 'Lateral E', 5); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
111, 'Pis', 8); 
INSERT INTO ZONES_Recinte ( Codi_Recinte, Zona, Capacitat ) VALUES ( 
111, 'Platea', 25); 
commit;



--
-- Taula PREUS_ESPECTACLES
--


INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1000, 103, 'Platea', 21); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1001, 105, 'Platea', 14); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1002, 104, 'Pis', 4); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1002, 104, 'Platea', 6); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1003, 110, 'Lateral D', 20); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1003, 110, 'Lateral E', 20); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1003, 110, 'Pis', 20); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1003, 110, 'Platea', 24); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1004, 110, 'Lateral D', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1004, 110, 'Lateral E', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1004, 110, 'Pis', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1004, 110, 'Platea', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1005, 111, 'Lateral D', 10); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1005, 111, 'Lateral E', 10); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1005, 111, 'Pis', 12); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1005, 111, 'Platea', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1006, 104, 'Pis', 4); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1006, 104, 'Platea', 6); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1007, 106, 'Pis', 4); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1007, 106, 'Platea', 6); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1008, 104, 'Pis', 9); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1008, 104, 'Platea', 12); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1009, 105, 'Platea', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1010, 100, 'Lateral D', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1010, 100, 'Lateral E', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1010, 100, 'Pis 1', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1010, 100, 'Pis 2', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1010, 100, 'Platea', 21); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1011, 100, 'Lateral D', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1011, 100, 'Lateral E', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1011, 100, 'Pis 1', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1011, 100, 'Pis 2', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1011, 100, 'Platea', 21); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1012, 102, 'Lateral D', 14); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1012, 102, 'Lateral E', 14); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1012, 102, 'Pis 1', 12); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1012, 102, 'Pis 2', 8); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1012, 102, 'Platea', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1013, 108, 'Pis', 4); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1013, 108, 'Platea', 6); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1014, 108, 'Pis', 3); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1014, 108, 'Platea', 3); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1015, 101, 'Pis', 12); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1015, 101, 'Platea', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1016, 108, 'Pis', 4); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1016, 108, 'Platea', 6); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1017, 109, 'Platea', 12); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1018, 106, 'Pis', 10); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1018, 106, 'Platea', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1019, 103, 'Platea', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1020, 105, 'Platea', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1021, 106, 'Pis', 12); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1021, 106, 'Platea', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1022, 111, 'Lateral D', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1022, 111, 'Lateral E', 15); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1022, 111, 'Pis', 12); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1022, 111, 'Platea', 18); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1023, 101, 'Pis', 10); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1023, 101, 'Platea', 16); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1024, 104, 'Pis', 9); 
INSERT INTO PREUS_ESPECTACLES ( Codi_Espectacle, Codi_Recinte, Zona, Preu ) VALUES ( 
1024, 104, 'Platea', 12); 
commit;


--
-- Taula SEIENTS
--

INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Lateral D', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Lateral D', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Lateral D', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Lateral D', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Lateral E', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Lateral E', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Lateral E', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Lateral E', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 1', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 2', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 2', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 2', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 2', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Pis 2', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 3, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
100, 'Platea', 4, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Pis', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 3, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 3, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 3, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 3, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
101, 'Platea', 3, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral D', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral D', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral D', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral D', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral D', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral E', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral E', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral E', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral E', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Lateral E', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 1', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Pis 2', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 3, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 4, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
102, 'Platea', 5, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
103, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Pis', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
104, 'Platea', 3, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
105, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Pis', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Pis', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Pis', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Pis', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Pis', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Pis', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Pis', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
106, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Pis', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Pis', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Pis', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Pis', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Pis', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Pis', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Pis', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Pis', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
107, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Pis', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Pis', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Pis', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Pis', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Pis', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
108, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
109, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral D', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral D', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral D', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral D', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral D', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral D', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral D', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral D', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral E', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral E', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral E', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral E', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral E', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral E', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral E', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Lateral E', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Pis', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
110, 'Platea', 3, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral D', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral D', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral D', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral D', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral D', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral E', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral E', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral E', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral E', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Lateral E', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Pis', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Pis', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Pis', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Pis', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Pis', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Pis', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Pis', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Pis', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 1, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 5); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 6); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 7); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 8); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 9); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 2, 10); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 3, 1); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 3, 2); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 3, 3); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 3, 4); 
INSERT INTO SEIENTS ( Codi_Recinte, Zona, Fila, Numero ) VALUES ( 
111, 'Platea', 3, 5); 
commit;


--
-- Taula ENTRADES
--

INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '01/27/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 3, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '01/27/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 4, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 1, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 2, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 3, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 4, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 5, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 6, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 7, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 8, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 9, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 10, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 1, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 2, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 3, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 4, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 5, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 6, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 7, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 8, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 9, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 10, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 5, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 6, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/10/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 5, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/10/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 6, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 3, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 4, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '03/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 5, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '03/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 6, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '03/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 4, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '03/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '03/17/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 5, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1000,  TO_Date( '03/17/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 1, 6, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1001,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 1, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1001,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 2, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1001,  TO_Date( '03/03/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 6, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1001,  TO_Date( '03/03/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 7, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1001,  TO_Date( '03/03/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 8, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '12/26/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 5, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '12/26/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 6, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '12/26/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 7, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '12/26/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 8, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '12/29/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 5, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '12/29/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 7, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '12/29/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 8, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 7, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 8, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 5, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 7, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/01/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 8, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 7, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 8, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 9, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 6, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 7, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1002,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 8, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 4, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 5, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 6, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 7, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 4, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 5, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 6, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 7, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 1, 4, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1005,  TO_Date( '10/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 1, 5, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/05/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 5, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/05/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 6, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/05/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 7, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/05/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 8, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/05/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 9, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/05/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 5, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/05/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 6, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 5, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 6, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 7, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 4, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Pis', 1, 5, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 1, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 2, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 3, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 4, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 5, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 6, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 7, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 8, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 9, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1006,  TO_Date( '10/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 10, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 5, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 6, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/03/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 5, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/03/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 6, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/10/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 5, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/10/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 6, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/17/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 5, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/17/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 6, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1007,  TO_Date( '11/17/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 4, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1008,  TO_Date( '12/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 6, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1008,  TO_Date( '12/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 7, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1008,  TO_Date( '12/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 2, 8, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 5, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 6, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 7, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 1, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 2, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 3, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 4, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 5, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 6, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 7, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 8, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 9, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 10, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 1, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 2, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 3, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 4, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 8, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 9, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 10, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 7, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 8, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 9, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 10, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/13/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 10, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 5, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 6, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 1, 7, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 2, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 3, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1009,  TO_Date( '11/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 105, 'Platea', 2, 4, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '03/31/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Platea', 2, 5, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '03/31/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Platea', 2, 6, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '03/31/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Lateral D', 1, 1, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '03/31/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Lateral D', 1, 2, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '03/31/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Lateral D', 1, 3, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '03/31/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Lateral D', 1, 4, 66666666); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '04/06/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Platea', 3, 4, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '04/06/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Platea', 3, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '04/06/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Platea', 3, 6, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '04/06/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Lateral D', 1, 3, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1010,  TO_Date( '04/06/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 100, 'Lateral D', 1, 4, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1012,  TO_Date( '06/08/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 102, 'Platea', 1, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1012,  TO_Date( '06/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 102, 'Platea', 2, 5, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1012,  TO_Date( '06/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 11:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 102, 'Platea', 2, 6, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1012,  TO_Date( '06/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 102, 'Platea', 2, 6, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 3, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 4, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 5, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 6, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Pis', 1, 2, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Pis', 1, 3, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Pis', 1, 4, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 5, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 6, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 7, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Pis', 1, 2, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1014,  TO_Date( '05/26/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Pis', 1, 5, 88888888); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 4, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 5, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 6, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 5, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 6, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '02/23/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 7, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 1, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 2, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 3, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 4, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 5, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 6, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 7, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 8, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 9, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 10, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 1, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 2, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 3, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 4, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 5, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 6, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 7, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 8, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 9, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 1, 10, 11111111); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 1, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 2, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 3, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 4, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 6, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 7, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 8, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 9, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/02/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 10, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 5, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1015,  TO_Date( '03/09/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 6, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1016,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Pis', 1, 3, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1016,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Pis', 1, 4, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1016,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Pis', 1, 5, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1016,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 4, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1016,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1016,  TO_Date( '04/05/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 05:30:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 108, 'Platea', 1, 6, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1017,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 109, 'Platea', 1, 3, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1017,  TO_Date( '01/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 109, 'Platea', 1, 4, 22222222);
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '03/29/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 1, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '03/29/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 1, 6, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 5, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 6, 55555555); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 1, 2, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 1, 3, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 1, 4, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 1, 5, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 1, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 2, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1018,  TO_Date( '04/12/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 3, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1019,  TO_Date( '06/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 4, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1019,  TO_Date( '06/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1019,  TO_Date( '06/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 6, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1019,  TO_Date( '06/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 7, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1019,  TO_Date( '06/15/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 8, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1019,  TO_Date( '06/22/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 4, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1019,  TO_Date( '06/22/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 5, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1019,  TO_Date( '06/22/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 103, 'Platea', 2, 6, 44444444); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1021,  TO_Date( '11/11/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1021,  TO_Date( '11/11/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 6, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1021,  TO_Date( '11/18/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Platea', 2, 5, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1021,  TO_Date( '11/18/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Pis', 1, 4, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1021,  TO_Date( '11/18/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 10:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 106, 'Pis', 1, 5, 99999999); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1022,  TO_Date( '09/29/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 111, 'Platea', 2, 6, 33333333); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1023,  TO_Date( '03/28/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 5, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1023,  TO_Date( '03/28/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Platea', 2, 6, 22222222); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1023,  TO_Date( '03/28/2012 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 09:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 101, 'Pis', 1, 7, 77777777); 
INSERT INTO ENTRADES ( Codi_Espectacle, Data, Hora, Codi_Recinte, Zona, Fila, Numero, DNI_Client ) VALUES ( 
1024,  TO_Date( '11/08/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),  TO_Date( '12/30/1899 06:00:00 PM', 'MM/DD/YYYY HH:MI:SS AM')
, 104, 'Platea', 1, 5, 44444444); 
commit;



set termout on
prompt %
prompt % Base de Dades ESPECTACLES instal·lada i enllestida! Gaudiu-ne...
prompt %



