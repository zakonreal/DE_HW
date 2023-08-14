--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой
-- будет постраничная разбивка всех продуктов (не более двух продуктов
-- на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3

create view pages_all_products as 
select code, model, speed, ram, hd, price, screen, 
    case 
	    when n%2=0 then n/2 
      	else n/2+1 
	end n_page, 
    case 
	    when all_lap%2= 0 then all_lap/2 
    	else all_lap/2+1 
    end all_pages
from (
      select *,
      row_number() over(order by code) as n, 
      count(*) over() as all_lap 
      from laptop
     ) t 

select * from pages_all_products

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type),
-- в рамках которого будет процентное соотношение всех товаров по типу устройства.
-- Вывод: производитель, тип, процент (%)

create view distribution_by_type as 
select maker, type,
(ct*100.0/(select count(*) from product)) as percent
from 
(
select maker, type, count(*) as ct
from product
group by maker, type
order by maker
) t1

select * from distribution_by_type

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/



--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as 
select * from ships 
where name like '% %'

select * from ships_two_words

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select t.name from
  (select ship as name from outcomes
  union
  select name from ships) as t  
  left join ships
  on t.name = ships.name
  where class is null and t.name like 'S%'


--task6 (lesson5)
-- Компьютерная фирма: Сделать график со средней ценой по всем товарам по каждому производителю (X: maker, Y: avg_price) на базе view all_products_050521

create view all_products_050521 as  
 
select * 
from 
 ( 
 select *, 
 row_number() over (partition by maker order by price DESC) as rn 
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
   join laptop 
   on product.model = laptop.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join pc 
    on product.model = pc.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1 
where rn >=1 and rn <=2 ; 
 
select maker, avg(price) from all_products_050521 group by maker


--task11 (lesson5)
-- Компьютерная фирма: Построить график с со средней и максимальной ценами на базе products_with_lowest_price (X: maker, Y1: max_price, Y2: avg)price

create view products_with_lowest_price as  
select * 
from 
 ( 
 select *, 
 row_number() over (partition by maker order by price) as rn 
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
   join laptop 
   on product.model = laptop.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join pc 
    on product.model = pc.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join printer 
    on product.model = printer.model 
    ) as t1 
 ) as t2 
where rn <=3 

select maker, avg(price), max(price) from products_with_lowest_price group by maker

-- task12 (lesson5)
-- https://leetcode.com/problems/department-top-three-salaries/description/

select Department, Employee, Salary 
from 
(select d.name Department, e.name Employee,e.Salary Salary,
dense_rank() over (partition by d.name order by e.salary desc) rank
from Department d
inner join Employee e
on e.departmentId = d.id)
where rank <= 3

-- task13 (lesson5): 
-- https://leetcode.com/problems/human-traffic-of-stadium/description/

select id, to_char(visit_date, 'yyyy-mm-dd') visit_date, p1 people
from
(select id, visit_date, people p1,
lead(people) over (order by visit_date) p2,
lead(people,2) over (order by visit_date) p3,
lag(people) over (order by visit_date) p4,
lag(people,2) over (order by visit_date) p5
from Stadium)
where (p1 >= 100 
and 
((p2 >= 100 and p3 >= 100)
or  (p4 >= 100 and p5 >= 100)
or  (p2 >= 100 and p4 >= 100)))

-- task14 (lesson4)
-- Компьютерная фирма: Создать процедуру, создающую копию таблицы pc с доп колонками:
-- flag_high_speed: с информацией по скоростью (скорость '40x' или '50x' - 1, остальные - 0);
-- price_rub: добавить цену в рублях (помножить колонку price на курс USDRUB);
-- ma_price: добавить среднее значение со скользящее среднее с окном 2 с сортировкой по цене и группировкой по cd.


CREATE OR REPLACE PROCEDURE public.task14()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
   USDRUB int := 80;

begin
    RAISE NOTICE 'START';
    CREATE table pc_with_flag_cd as
    with pc_task14 as 
    (select *,
    case when cd = '40x' or cd = '50x' then 1 else 0 end flag_high_speed,
    lag(price,2) over (partition by cd order by price) as ma_price
    from pc ) 
    
    select *,
    price * USDRUB as price_rub,
    avg(ma_price) over (partition by cd order by price)
    from pc_task14;

    RAISE NOTICE 'END';
    commit;
end;$procedure$
;

call public.task14();;

select  * from pc_with_flag_cd 






























