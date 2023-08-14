--task 1 (lesson 8)
--https://www.codewars.com/kata/53da3dbb4a5168369a0000fe

select 
case when (number % 2) = 0 when 0 then 'Even' else 'Odd'
end is_even
from numbers

--task 2 (lesson 8)
--https://www.codewars.com/kata/53369039d7ab3ac506000467

select bool,
case when bool then 'Yes' else 'No'
end res
from booltoword

--task 3 (lesson 8)
--https://www.codewars.com/kata/5abcf0f930488ff1a6000b66

select * from students 
where ((quality1='evil' and quality2='cunning')
or (quality1='brave' and quality2 !='evil')
or  (quality1='studious' or quality2='intelligent')
or (quality1='hufflepuff' or quality2='hufflepuff'))
order by id