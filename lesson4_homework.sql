--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop).
-- Вывести: model, maker, type

select model, maker, type from product order by maker

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех,
-- у кого цена вышей средней PC - "1", у остальных - "0"

select * ,
case when price > (select avg(price) from printer) then 1
else 0
end price_avg
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select name from ships where class is null

 select t.name, class from
  (select ship as name from outcomes
    union
  select name from ships) as t  
  left join ships
  on t.name = ships.name
  where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

with t_b as
(select name, cast(date as char(4)) from battles),
t_sh as
(select cast(launched as char(4)) from ships)

select distinct name from t_b
where date not in (select launched from t_sh)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle
from outcomes 
join ships   
on ship = name
where class = 'Kongo'

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом,
-- если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as 
with t1 as 
(
select pr.model,price from product pr
join pc
on pr.model=pc.model 
union
select pr.model,price from product pr
join laptop l
on pr.model=l.model 
union 
select pr.model,price from product pr
join printer pri
on pr.model=pri.model
)
select model,price,
case when price>300 then '+'
end flag_300
from t1

select * from all_products_flag_300

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом,
-- если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as 
with t2 as 
(
select pr.model,price from product pr
join pc
on pr.model=pc.model 
union
select pr.model,price from product pr
join laptop l
on pr.model=l.model 
union 
select pr.model,price from product pr
join printer pri
on pr.model=pri.model
)
select model,price,
case when price> (select avg(price) from t2) then '+'
end flag_avg
from t2

select * from all_products_flag_avg_price


--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with t2 as
(
select maker, pr.model,price from product pr
join printer pri
on pr.model=pri.model
)
select model from t2
where price > (select avg(price) from t2 where maker in ('D','C') )

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with t3 as 
(
select maker, pr.model,price from product pr
join pc
on pr.model=pc.model 
union
select maker, pr.model,price from product pr
join laptop l
on pr.model=l.model 
union 
select maker, pr.model,price from product pr
join printer pri
on pr.model=pri.model
),
t4 as 
(
select maker, pr.model,price from product pr
join printer pri
on pr.model=pri.model
)

select model from t3
where price > (select avg(price) from t4 where maker in ('D','C') )

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

with t5 as 
(
select pr.model, avg(price) as price_avg from product pr
join pc
on pr.model=pc.model 
where maker = 'A'
group by pr.model
union
select pr.model, avg(price) from product pr
join laptop l
on pr.model=l.model 
where maker = 'A'
group by pr.model
union 
select pr.model, avg(price) from product pr
join printer pri
on pr.model=pri.model
where maker = 'A'
group by pr.model
)

select avg(price_avg) from t5


--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as
select maker, count(maker) from product
group by maker
order by maker

select * from count_products_by_makers

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)



--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as 
select * 
from printer
where model in
(select pr.model from product pr
join printer pri 
on pr.model=pri.model
where maker != 'D')

select * from printer_updated

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select code, pri.model, color, type, price, maker 
from printer_updated pri
left join 
(select maker, model from product) as pr
on pri.model=pr.model

select * from printer_updated_with_makers

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes).
-- Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as
with t1 as
(select ship, class
from outcomes
left join ships
on ship=name
where result = 'sunk')
select count(t1.ship), cl.class
from classes cl
left join t1
on cl.class=t1.class or cl.class = t1.ship
group by cl.class

select * from sunk_ships_by_classes

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)




--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as 
select * ,
case when numguns>=9 then 1
else 0
end flag
from classes

select * from classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

select country, count(class) from classes
group by country

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(name) from ships 
where name like 'M%' or name like 'O%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(name) from ships 
where name like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

select launched as year, count(name) from ships
group by launched

