/*1(Aerolinies) Nom i telèfon de tots les persones portugueses. */
select p.nom,p.telefon
from passatger p
where p.pais =  'Portugal'
order by 1,2

/*2(Aerolinies) Total de bitllets venuts per la companyia IBERIA. */
select count(*)
from vol v, bitllet b
where v.companyia = 'IBERIA' and v.codi = b.CODI_VOL
order by 1

/*3(Aerolinies) Nombre de Bitllets per compradors. Es demana nom del comprador i nombre de bitllets comprats. */
select c.nom, count(*)
from comprador c, bitllet b, reserva r
where c.NIF= r.comprador and r.localitzador = b.numero_reserva
group by c.nom
order by 1

/*4(Aerolinies) Data i codi de vol dels vols amb més de 3 passatgers. */
select to_char(b.data,'dd/mm/yyyy') as data, b.codi_vol
from bitllet b
group by to_char(b.data,'dd/mm/yyyy'), b.codi_vol
having count(*) > 3
order by 1,2

/*5(Aerolinies) Nombre de vegades que apareix la nacionalitat més freqüent entre els passatgers. 
Es demana la  nacionalitat i nombre de vegades que apareix.*/
select p.pais, count(*)
from passatger p 
group by p.PAIS
having count(*) = (select max(count(*)) from passatger p group by p.pais)
order by 1

/*6(Arolinies) NIF i nom del(s) passatger(s) que ha(n) facturat menys pes en els seus vols.*/
select p.nif, p.nom
from passatger p, maleta m
where m.passatger = p.nif
group by m.passatger, p.nif, p.nom
having sum(m.pes) =(select min(sum(m1.pes)) from maleta m1  group by m1.passatger)
order by 1,2

/*7(Aerolinies) Nom dels passatgers que tenen bitllet, però no han fet mai cap reserva.*/
select p.nom
from passatger p,bitllet b
where b.passatger = p.nif
minus
(select c.nom
from comprador c)
order by 1

/*8	(Arolinies) Nom de la Companyia que vola a tots els aeroports espanyols.*/
(select r.companyia
from (select v.companyia,v.desti from vol v) r)
minus
(select t.companyia
from (
       (select s.codi_aeroport, r2.companyia
        from (select a.codi_aeroport from aeroport a where pais = 'Espanya') s,
             (select v.companyia,v.desti from vol v) r2
        minus
        (select r3.desti,r3.companyia 
         from (select v.companyia,v.desti from vol v) r3 ))t ))
		 
		 
/*Otra opcion es hacer para el ejerecicio 8*/
select v.companyia
from vol v,aeroport a2
where v.desti = a2.codi_aeroport and a2.pais = 'Espanya'
group by v.companyia
having count(distinct a2.nom)= (select count(*)
                                from aeroport a
                                where a.pais='Espanya'
                                group by a.pais)
order by 1