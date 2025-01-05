-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * 
from retail_sales
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 3 in the month of Nov-2022

select * 
from (select * from retail_sales where date_trunc('month',sale_date) = '2022-11-01' and quantity >3)
where category ='Clothing' 

 -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

 select category, sum(total_sale) as total_sales
 from retail_sales
 group by category 

 -- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

 select avg(age) as avg_age
 from retail_sales
 where category = 'Beauty'

 -- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

 select * 
 from retail_sales
 where total_sale > 1000

 -- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
 select gender, count(transaction_id) 
 from retail_sales
 group by gender

 -- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select *
from 
	(
	select 
	extract ('month' from sale_date) as month,
	extract ('year' from sale_date) as year,
	avg(total_sale) as avg_sales,
	Rank() over (partition by extract ('year' from sale_date) order by avg(total_sale) desc) as rnk
	from retail_Sales
	group by 1,2
	order by 2 
	 ) as t1
where rnk = 1

 -- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

 -- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category

select category , count(distinct(customer_id))
from retail_sales
group by category


-- Q.10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with shift_hours as (

	select *,
		case 
			when extract(hour from sale_time) < 12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as shift
	from retail_sales
	)
select shift, count(*) as count_of_order
from shift_hours
group by shift