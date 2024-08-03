select * from customer
select * from customerOrder
select * from shipping


---the total amount spent and the country for the Pending delivery status for each country.
select 
a.country,
sum(b.amount) as total_amount,
c.status
from customer a
left join customerorder b
on a.customer_id=b.customer_id
left join shipping c
on a.customer_id=c.customer_id
where status='pending'
group by a.country,c.status


--the total number of transactions, total quantity sold, and total amount spent for each customer, along with the product details.

select 
customer_id,
count(*) as total_transaction,
count(item) as total_quantity_sold,
sum(amount) as total_amount_spent,
STRING_AGG(item,',') as product_details
from
customerorder
group by customer_id


---the maximum product purchased for each country.

select 
a.country,
count(b.item) as totalitemcount
from customer a
left join customerorder b
on a.customer_id=b.customer_id
group by a.country



---the most purchased product based on the age category less than 30 and above 30.

with data as
(select 
b.item,
case when age<30 then 'age_less_than_30'
when age>30 then 'age_above_30' end as age_category
from customer a
left join customerorder b
on a.customer_id=b.customer_id 
where b.item is not null)
select 
item as most_purchased_product,
age_category,total as number_of_times_purchased
from
(select 
item,
age_category,
count(item) as total,
DENSE_RANK() over (partition by age_category order by count(item) desc) as dns
from data 
group by item,age_category)x
where dns=1 and age_category is not null


----the country that had minimum transactions and sales amount.

select 
top 1 * from
(select 
a.country,
count(b.item) as total_Transactions,
sum(b.amount) as total_amount
from customer a
left join customerorder b
on a.customer_id=b.customer_id
group by a.country
)x
order by total_Transactions, total_amount asc





