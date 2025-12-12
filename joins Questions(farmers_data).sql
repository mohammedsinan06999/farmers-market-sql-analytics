use farmers_market;
select * from booth;
select *from customer;
select *from customer_purchases;
select *from market_date_info;
select *from product;
select *from product_category;
select *from vendor;
select *from vendor_booth_assignments;
select *from vendor_inventory;
select *from zip_data;

#1.	List all the products and their product categories
select p.product_name,p.product_size,p.product_category_id,pc.product_category_name from product p 
left join product_category pc 
on p.product_category_id=pc.product_category_id;

# 2.	Get all the Customers who have purchased nothing from the market yet.
select customer_id from customer 
except 
select customer_id from customer_purchases;

select  c.customer_id,c.customer_first_name,c.customer_last_name
from customer as c  left join customer_purchases as cp
on c.customer_id=cp.customer_id
where cp.customer_id is null;

# 3.	List all the customers and their associated purchases
select c.customer_id,
concat(c.customer_first_name,' ',c.customer_last_name),
cp.market_date,cp.product_id
from customer c
left join customer_purchases cp
on c.customer_id=cp.customer_id;

# 4.	Write a query that returns a list of all customers who did not purchase on March 2, 2019
select c.customer_id,
concat(c.customer_first_name,' ',c.customer_last_name),
cp.market_date
from customer c
left join customer_purchases cp
on c.customer_id=cp.customer_id
where cp.market_date !='2019-03-2';


#5.	filter out vendors who brought at least 10 items to the farmer’s market over the time period - 2019-05-02 and 2019-05-16
select v.vendor_id,v.vendor_name,v.vendor_type,cp.market_date 
from vendor v
left join customer_purchases cp
on v.vendor_id=cp.vendor_id
where cp.market_date between '2019-05-02 ' and '2019-05-16'
limit 10 ;


# 6.	Show details about all farmer’s market booths and every vendor booth assignment for every market date

select b.*,vb.*
from booth b
left join vendor_booth_assignments vb 
on b.booth_number=vb.booth_number;

#7.find out how much this customer had spent at each vendor, regardless of date? (Include customer_first_name, customer_last_name, customer_id, vendor_name, vendor_id, price)
select c.customer_first_name,c.customer_last_name,c.customer_id,
       v.vendor_name,v.vendor_id,
       sum(cp.cost_to_customer_per_qty) as price
from customer c 
left join customer_purchases cp on c.customer_id=cp.customer_id
right join vendor v on v.vendor_id=cp.vendor_id
group by c.customer_first_name,c.customer_last_name,c.customer_id,
v.vendor_name,v.vendor_id;
	
#8.	get the lowest and highest prices within each product category include (product_category_name, product_category_id, lowest price, highest _price)
select pc.product_category_name,pc.product_category_id,min(vi.original_price) as lowest_price,max(vi.original_price) as highest_price
from product p 
join product_category pc on pc.product_category_id=p.product_category_id
join vendor_inventory vi on vi.product_id=p.product_id
group by pc.product_category_name,pc.product_category_id
order by pc.product_category_name;

#9.	Count how many products were for sale on each market date, or how many different products each vendor offered.
select market_date,count(distinct product_id) as total_product_for_sale from vendor_inventory
group by market_date order by market_date;

#or
select v.vendor_id,v.vendor_name,v.vendor_type,count(vi.product_id) as vendor_offered from vendor v
join vendor_inventory vi on v.vendor_id=vi.vendor_id
group by v.vendor_id order by v.vendor_id;

#10.In addition to the count of different products per vendor, we also want the average original price of a product per vendor?
select v.vendor_id,v.vendor_name,count(distinct vi.product_id) as different_product,avg(vi.original_price) as avg_price
from vendor v join vendor_inventory vi on v.vendor_id=vi.vendor_id
group by v.vendor_id order by v.vendor_id;