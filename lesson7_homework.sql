--task1  (lesson7)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, sum(amount*unit_price) costs
from GoodTypes
join Goods
on good_type_id=type
join Payments
on good = good_id
and date like '2005%'
group by good_type_name

--task2  (lesson7)
-- https://sql-academy.org/ru/trainer/tasks/37

select floor(min(DATEDIFF(NOW(), birthday)/365)) year
from Student

--task3  (lesson7)
-- https://sql-academy.org/ru/trainer/tasks/44

select floor(max(DATEDIFF(NOW(), birthday)/365)) max_year
from Student s1
join Student_in_class s2
on s1.id=s2.student 
join class cl
on s2.class=cl.id
and cl.name like '10%'

--task4 (lesson7)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name,
sum(unit_price * amount) costs
from payments
join familyMembers
on family_member=member_id 
join Goods
on good=good_id
join GoodTypes
on type=good_type_id
and good_type_name = 'entertainment'
group by status, member_name

--task5  (lesson7)
-- https://sql-academy.org/ru/trainer/tasks/55

with t1 as
(
select name, count(company),
dense_rank() OVER(ORDER BY count(company)) rnk
from Trip
join Company
on Company.id=Trip.company
group by name
)
delete from Company
where name in (select name from t1 where rnk=1)

--task6  (lesson7)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom from 
(
select classroom, count(classroom),
dense_rank() OVER(ORDER BY count(classroom) desc) rnk
from Schedule
group by classroom
) t
where rnk=1

--task7  (lesson7)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name from Teacher t
join Schedule sc
on t.id=sc.teacher
join Subject s
on s.id=sc.subject
where s.name='Physical Culture'
order by last_name

--task8  (lesson7)
-- https://sql-academy.org/ru/trainer/tasks/63

select concat(last_name, '.', left(first_name, 1),
'.', left(middle_name, 1), '.') as name
from Student
order by name



