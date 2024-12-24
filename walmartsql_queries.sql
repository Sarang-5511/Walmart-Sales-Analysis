use WalmartSales;

SET SQL_SAFE_UPDATES = 0;

select *
from walmart;

select count(*)
from walmart;

select distinct payment_method
from walmart;

update walmart
set totalprice=ROUND(totalprice,2);



-- Q1
select payment_method,count(invoice_id),sum(quantity)
from walmart
group by payment_method
order by payment_method asc;


-- Q2
select x.branch,x.category,x.avgrating
from (
select branch,category,avg(rating) as avgrating,rank() over(partition by branch order by avg(rating) desc) as rankgiven
from walmart
group by branch,category)x
where x.rankgiven=1;




-- Q3
select x.branch,x.day,x.totaltrans
from (
select branch,day,count(*) as totaltrans,rank() over (partition by branch order by count(*) desc) as rankgiven
from walmart
group by branch,day) x
where x.rankgiven=1;


-- Q4
select payment_method,sum(quantity) as totalitems
from walmart
group by payment_method
order by totalitems desc;



-- Q5 
select distinct city,category,
avg(rating) over(partition by city,category) as avgrating,
max(rating) over(partition by city,category) as maxrating,
min(rating) over(partition by city,category) as minrating
from walmart;



-- Q6
select category,sum(profit_margin),rank() over(order by sum(profit_margin) desc) as rankgiven
from walmart
group by category;


-- Q7
select x.branch,x.payment_method,x.totaltrans
from (
select branch,payment_method,count(*) as totaltrans,rank() over(partition by branch order by count(*) desc) as rankgiven
from walmart
group by branch,payment_method)x
where rankgiven=1;


-- Q8

select distinct x.branch,x.Dayslot,count(*) over (partition by branch,DaySlot) as totaltrans
from (
select branch,case when left(time,2) between 6 and 11 then "Morning"
when left(time,2) between 12 and 17 then "Afternoon"
else "Evening" end as DaySlot
from walmart)x;




-- Q9

select x.branch,x.year,x.totalrevenue,coalesce(ROUND(x.totalrevenue-lag(x.totalrevenue) over (partition by x.branch),2) ,0) changenew
from (
select branch,year,ROUND(sum(totalprice),2) AS totalrevenue
from walmart
group by branch,year
order by branch asc)x

