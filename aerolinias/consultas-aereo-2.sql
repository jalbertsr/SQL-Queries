/*1(Aerolinies) Nom dels passatgers nascuts entre l’any 1960 i 1990.*/
select p.nom
from passatger p
where p.data_naixement between to_date('01/01/1960','dd/mm/yyyy') and to_date('31/12/1990','dd/mm/yyyy') 
order by 1;

/*2 Pes total de les maletes facturades per passatgers espanyols.*/
select sum(m.pes) as Pes_total
from passatger p, maleta m
where p.nif = m.PASSATGER and p.pais='Espanya'
order by 1;

/*3(Aerolinies) Nombre de passatgers dels vols d'IBERIA per països. Es demana país i nombre de passatgers.*/
select p.pais, count(p.nif) as nombre_passsatger
from passatger p, vol v, bitllet b
where b.CODI_VOL = v.CODI and v.COMPANYIA='IBERIA' and b.PASSATGER = p.Nif 
group by p.pais
order by 1

/*4(Aerolinies) Codi, data i pes total dels vols que han facturat, en total, un pes igual o superior a 26 kgs.*/
select m.codi_vol,to_char(m.data,'dd/mm/yyyy'), sum(m.pes) as pes_total
from maleta m
group by m.codi_vol, m.data, to_char(m.data,'dd/mm/yyyy')
having sum(m.pes) >= 26
order by 1,2,3

/*5(Aerolinies) Marca i model d’avió amb més files.*/
select distinct a.MARCA, a.MODEL
from avio a, butaques b
where a.MATRICULA = b.MATRICULA_AVIO and b.fila = (select max(b1.fila) from butaques b1 )
order by 1;

/*6 (Aerolinies) Nom del(s) aeroport(s) amb el mínim de terminals possible.*/
select a.NOM
from aeroport a, porta_embarcament p
where a.CODI_AEROPORT = p.CODI_AEROPORT 
group by a.nom
having count(distinct p.TERMINAL) = (select min(count(distinct p1.TERMINAL))
                          from aeroport a1, porta_embarcament p1
                          where a1.CODI_AEROPORT = p1.CODI_AEROPORT 
                          group by a1.nom)
                    
order by 1

/*7	(Aerolinies) Nom del personal lliure els dilluns.*/
select p.NOM
from personal p
minus
(select p1.nom
from personal p1, personal_avio pa, vol v
where p1.ss = pa.ss and pa.matricula = v.AVIO and v.dia='Dilluns')
order by 1;

/*8 (Aerolinies) Nom del/s passatger/s que sempre vola amb primera classe.*/
select p.NOM
from passatger p, bitllet b
where  b.passatger = p.nif and b.categoria = 'Primera'
group by (p.nom,b.categoria)
minus
(select p1.NOM
from passatger p1, bitllet b1
where  b1.passatger = p1.nif and b1.categoria <> 'Primera'
group by (p1.nom,b1.categoria))
order by 1