-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920

select name, class
from ships
where launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942

select name, class
from ships
where launched > 1920 and launched <= 1942


-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class

select class, count(name)
from ships
group by class

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)

select class, country
from classes 
where bore >=16


-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.

select ship
from outcomes 
where battle = 'North Atlantic' and result = 'sunk'

-- ������� 6: ������� �������� (ship) ���������� ������������ �������

select ship from outcomes 
join battles   
on battle = name
where result = 'sunk'
and 
date =
(select max(date)
from  battles 
join outcomes   
on name = battle
where result = 'sunk')

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������

select ship, class
from outcomes 
join ships   
on ship = name
where result = 'sunk'

-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class

select ship, ships.class
from classes 
join ships   
on classes.class = ships.class
join outcomes
on ship = name
where bore >=16

-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class

select class from classes
where country = 'USA'


-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class

select name, ships.class
from classes 
join ships   
on classes.class = ships.class
where country = 'USA'

-- hackerrank 1:
-- https://www.hackerrank.com/challenges/the-report/problem

select 
 case
 when Grades.Grade > 7 then Students.Name
 end,
Grades.Grade, Students.Marks 
from Students 
join Grades
on Students.Marks between Grades.Min_Mark and Max_Mark
order by Grades.Grade desc, Students.Name;
