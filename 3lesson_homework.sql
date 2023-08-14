--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. 
-- Вывести: класс и число потопленных кораблей.

with tab as
(select ship, class from outcomes
left join ships
on ship=name
where result = 'sunk')

select cl.class, count(tab.ship) from classes cl
left join tab
on cl.class=tab.class
or 
cl.class = tab.ship

group by cl.class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
-- Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. 
-- Вывести: класс, год.

select cl.class, min(sh.launched) years from classes cl
left join ships sh
on cl.class=sh.class
group by cl.class

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, 
--вывести имя класса и число потопленных кораблей.

with tab as 
(select ship, 
case when result = 'sunk' then 1
end out1 
from outcomes)
 
select cl.class, sum(out1) out_1 from classes cl
left join ships sh 
on cl.class = sh.class
left join
(select ship, out1 from tab
where out1=1) as t
on cl.class = t.ship or sh.name = t.ship 

group by cl.class
having count(cl.class)>2
and 
sum(out1) is not null

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения
-- (учесть корабли из таблицы Outcomes).

with tab1 as 
(select ou.ship, numguns, displacement from outcomes ou
join classes cl
on ou.ship = cl.class 
and 
ou.ship not in (select name from ships)
union
select sh.name, numguns, displacement
from ships sh
join classes cl 
on sh.class = cl.class),

tab2 as 
(select max(numguns), displacement
from outcomes ou
join classes cl 
on ou.ship = cl.class
and 
ou.ship not in (select name from ships)
group by displacement
union
select max(numguns), displacement
from ships sh
join classes cl 
on sh.class = cl.class
group by displacement)

select ship from tab1
join tab2
on tab1.numguns = tab2.max
and 
tab1.displacement = tab2.displacement

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM 
--и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with tab1 as
(select maker from 
(select model, max(speed) from pc
where ram = (select min(ram) from pc)
group by model) as t
join product pr
on t.model=pr.model
),

tab2 as
(select maker from product pr
join printer p
on pr.model=p.model)

select distinct tab1.maker from tab1
join tab2
on tab1.maker = tab2.maker

-- leetcode 
-- https://leetcode.com/problems/actors-and-directors-who-cooperated-at-least-three-times/

select actor_id, director_id from ActorDirector
group by actor_id, director_id
having count(director_id) >= 3