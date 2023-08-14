--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, дополнительно и необязательно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) 
-- и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.


-- 1 способ (создание таблицы)

create table table_10000_3
(
  column_name1 int not null,
  column_name2 int not null,
  column_name3 int not null
)

-- insert into table_10000_3 values (floor(random()*(max-min+1))+min, floor(random()*(max-min+1))+min, floor(random()*(max-min+1))+min)

do $$
begin
 for cnt in 1..10000 loop	
    insert into table_10000_3 values (floor(random()*(1000000-0+1))+0, floor(random()*(1000000-0+1))+0, floor(random()*(1000000-0+1))+0);
 end loop;
end; $$


 explain select * from table_10000_3
 explain select count(*) from table_10000_3
 explain select max(column_name1) from table_10000_3
 explain select min(column_name2) from table_10000_3
 explain select avg(column_name3) from table_10000_3
 explain select max(column_name1), min(column_name2), avg(column_name3) from table_10000_3
 explain select sum(column_name1)+sum(column_name2)+sum(column_name3) from table_10000_3
 
 
 explain analyze select * from table_10000_3
 explain analyze select count(*) from table_10000_3
 explain analyze select max(column_name1) from table_10000_3
 explain analyze select min(column_name2) from table_10000_3
 explain analyze select avg(column_name3) from table_10000_3
 explain analyze select max(column_name1), min(column_name2), avg(column_name3) from table_10000_3
 explain analyze select sum(column_name1)+sum(column_name2)+sum(column_name3) from table_10000_3
 
-- 2 способ (создание таблицы)

create table table1 as
 select floor(random()*1000000) as x,
        floor(random()*1000000) as y,
        floor(random()*1000000) as z
 from generate_series(1, 100000)

  select * from table1


--task2 (lesson 6)
-- https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/


select e.name from Employee e
where e.id in 
(select managerId from Employee
group by managerId
having count(id)>=5);


--task3 (lesson 6)
-- https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/

select id, cnt as num from 
(select id, count(*) as cnt 
from (select requester_id as id  
from RequestAccepted  c1 
union all 
select accepter_id as id from RequestAccepted  c2 )
group by id 
order by count(*) desc
)
where rownum <=1