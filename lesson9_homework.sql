--task1  (lesson9)
-- https://leetcode.com/problems/recyclable-and-low-fat-products/description/

select product_id from Products
where low_fats = 'Y' and recyclable = 'Y'

--task2  (lesson7)
-- https://leetcode.com/problems/daily-leads-and-partners/?envType=list&envId=e97a9e5m

select to_char(date_id,'yyyy-mm-dd') date_id,
make_name,
count(unique(lead_id)) unique_leads,
count(unique(partner_id)) unique_partners
from dailysales
group by date_id,make_name

--task3  (lesson7)
-- https://leetcode.com/problems/capital-gainloss/?envType=list&envId=e97a9e5m

select  stock_name, 
sum(case when operation = 'Buy' then -price else price end) capital_gain_loss
from stocks
group by stock_name

--task4 (lesson7)
-- https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/?envType=list&envId=e97a9e5m

select customer_id, count(*) count_no_trans 
from Visits 
where Visit_id not in (select visit_id from Transactions) 
group by customer_id

--task5  (lesson7)
-- https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem

with t1 as
(select submission_date, hacker_id, count(submission_id) as submisstion_made, sum(score) as total_score
from Submissions
group by submission_date, hacker_id),
t2 as
(select submission_date, hacker_id,
dense_rank() over(order by submission_date) as num1,
dense_rank() over(partition by hacker_id order by submission_date) as num2
from t1),
t3 as
(select t1.submission_date, t1.hacker_id, submisstion_made, total_score 
from t1 join t2 on t1.submission_date = t2.submission_date and t1.hacker_id = t2.hacker_id
where num2 = num1),
t4 as
(select submission_date, count(hacker_id) as submisstion_count
from t3
group by submission_date),
t5 as
(select submission_date, hacker_id, submisstion_made, total_score, 
row_number() over(partition by submission_date order by submisstion_made desc, hacker_id) as rn
from t1)

select t4.submission_date, submisstion_count, t5.hacker_id, name
from t4 join t5 on t4.submission_date = t5.submission_date
join Hackers on t5.hacker_id = Hackers.hacker_id
where rn = 1
order by t4.submission_date;