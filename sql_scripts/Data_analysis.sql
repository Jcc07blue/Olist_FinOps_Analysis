use olist_db;

#TABLES CREATION AND DATA LOADING

CREATE TABLE geolocation (
  geolocation_zip_code_prefix int,
  geolocation_lat decimal(11,8),
  geolocation_lng decimal(10,8),
  geolocation_city TEXT,
  geolocation_state TEXT);
  
  
  CREATE TABLE order_items (
  order_id varchar(50),
  order_item_id varchar(50),
  product_id varchar(50),
  seller_id varchar(50),
  shipping_limit_date varchar(30),
  price decimal(10,8) ,
  freight_value decimal(10,8));
  
  CREATE TABLE order_payments (
  order_id varchar(50),
  payment_sequential int,
  payment_type TEXT,
  payment_installments int,
  payment_value decimal(10,8));

CREATE TABLE order_reviews (
  review_id varchar(50),
  order_id varchar(50),
  review_score TEXT,
  review_comment_title TEXT,
  review_creation_date varchar(30),
  review_answer_timestamp varchar(30));
  
  
  CREATE TABLE orders (
  order_id varchar(50),
  customer_id varchar(50),
  order_status text,
  order_purchase_timestamp varchar(30),
  order_approved_at varchar(30),
  order_delivered_carrier_date varchar(30),
  order_delivered_customer_date varchar(30),
  order_estimated_delivery_date varchar(30));
  
  CREATE TABLE products (
  product_id varchar(50),
  product_category_name text,
  product_name_lenght int,
  product_description_lenght int,
  product_photos_qty int,
  product_weight_g decimal(10,8),
  product_length_cm decimal(10,8),
  product_height_cm decimal(10,8),
  product_width_cm decimal(10,8));
  
CREATE TABLE sellers (
  seller_id varchar(50),
  seller_zip_code_prefix int,
  seller_city text,
  seller_state text);
  
  
alter table geolocation
modify column geolocation_lng DECIMAL (11,8);

  
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist/geolocation.csv'
INTO TABLE geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

alter table order_items
modify column price DECIMAL (12,2),
modify columN freight_value DECIMAL (12,2);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist/order_items.csv'
INTO TABLE order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

alter table order_payments
modify column payment_value DECIMAL(12,2);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist/order_payments.csv'
INTO TABLE order_payments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

TRUNCATE TABLE ORDER_REVIEWS;

ALTER TABLE order_reviews add column review_comment_message text;
ALTER TABLE order_reviews modify column review_creation_date text;
ALTER TABLE order_reviews MODIFY COLUMN review_comment_message TEXT AFTER review_comment_title;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist/order_reviews.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
ESCAPED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist/orders.csv'
INTO TABLE orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
ESCAPED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist/products.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist/sellers.csv'
INTO TABLE sellers
CHARACTER SET utf8mb4
FIELDS terminated by ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#DATA VALIDATION
#NULL VALUES

SELECT count(*) - count(customer_id),
count(*) - count(customer_unique_id),
count(*) - count(customer_zip_code_prefix)
from customers;

SELECT count(*) - count(geolocation_zip_code_prefix)
from geolocation;

SELECT count(*) - count(order_item_id),
count(*) - count(order_id),
count(*) - count(product_id),
count(*) - count(seller_id),
count(*) - count(shipping_limit_date),
count(*) - count(price),
count(*) - count(freight_value)
from order_items;

SELECT 
count(*) - count(order_id),
count(*) - count(payment_sequential),
count(*) - count(payment_type),
count(*) - count(payment_installments),
count(*) - count(payment_value)
from order_payments;

SELECT 
count(*) - count(order_id),
count(*) - count(review_id),
count(*) - count(review_score),
count(*) - count(review_comment_title),
count(*) - count(review_comment_message),
count(*) - count(review_creation_date),
count(*) - count(review_answer_timestamp)
from order_reviews;

SELECT 
count(*) - count(order_id),
count(*) - count(customer_id),
count(*) - count(order_status),
count(*) - count(order_purchase_timestamp),
count(*) - count(order_approved_at),
count(*) - count(order_delivered_carrier_date),
count(*) - count(order_delivered_customer_date),
count(*) - count(order_estimated_delivery_date)
from orders;

SELECT 
count(*) - count(product_id),
count(*) - count(product_category_name),
count(*) - count(product_name_lenght),
count(*) - count(product_description_lenght),
count(*) - count(product_photos_qty),
count(*) - count(product_weight_g),
count(*) - count(product_length_cm),
count(*) - count(product_height_cm),
count(*) - count(product_width_cm)
from products;

SELECT 
count(*) - count(seller_id),
count(*) - count(seller_zip_code_prefix),
count(*) - count(seller_city),
count(*) - count(seller_state)
from sellers;

#UPDATE OF DATE COLUMNS FROM VAR/TEXT TO DATETIME

UPDATE order_items 
SET shipping_limit_date = STR_TO_DATE(shipping_limit_date, '%Y-%m-%d %H:%i:%s');

UPDATE order_reviews
SET review_creation_date = str_to_date(review_creation_date, '%Y-%m-%d %H:%i:%s'),
	review_answer_timestamp = str_to_date(review_answer_timestamp, '%Y-%m-%d %H:%i:%s');
    
select distinct * from orders;
    
UPDATE orders
SET order_purchase_timestamp = if (order_purchase_timestamp = '' or order_purchase_timestamp is null, null, str_to_date(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')), 
	order_approved_at = if (order_approved_at = '' or order_approved_at is null, null, str_to_date(order_approved_at, '%Y-%m-%d %H:%i:%s')),
	order_delivered_carrier_date = if (order_delivered_carrier_date= '' or order_delivered_carrier_date is null, null, str_to_date(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')),
	order_delivered_customer_date = if (order_delivered_customer_date = '' or order_delivered_customer_date is null, null, str_to_date(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')),
	order_estimated_delivery_date = if (order_estimated_delivery_date = '' or order_estimated_delivery_date is null, null, str_to_date(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s'));
    
ALTER TABLE order_items
modify column shipping_limit_date datetime;

ALTER TABLE order_reviews
modify column review_creation_date datetime,
modify column review_answer_timestamp datetime;

ALTER TABLE orders
modify column order_purchase_timestamp datetime,
modify column order_approved_at datetime,
modify column order_delivered_carrier_date datetime,
modify column order_delivered_customer_date datetime,
modify column order_estimated_delivery_date datetime;

#DUPLICATES REVIEW, PK AND FK ASSIGNATION

select customer_id, count(*) as count
from customers
group by customer_id
having count > 1;

select customer_unique_id, count(*) as count
from customers
group by customer_unique_id
having count > 1;

alter table customers
modify column customer_id VARCHAR(50);

alter table customers
add primary key (customer_id);

select geolocation_zip_code_prefix, count(*) as count
from geolocation
group by geolocation_zip_code_prefix
having count > 1;

alter table order_items
add column ID int auto_increment primary key first;

alter table order_payments
add column payment_unique_id int auto_increment primary key first;

alter table order_reviews
add column review_unique_id int auto_increment primary key first;

alter table orders
add primary key (order_id);

select product_id, count(*) as count
from products
group by product_id
having count >1;

alter table products
add primary key (product_id);

select seller_id, count(*) as count
from sellers
group by seller_id
having count > 1;

alter table sellers
add primary key (seller_id);

select distinct product_id
from order_items
where product_id not in (select product_id from products);

select distinct seller_id
from order_items
where seller_id not in (select seller_id from sellers);

delete from order_items
where product_id not in (select product_id from products);

delete from order_items
where seller_id not in (select seller_id from sellers);

alter table order_items add CONSTRAINT fk_order_items_orders foreign key (order_id) references orders(order_id) on delete cascade,
add constraint fk_order_items_products foreign key (product_id) references products(product_id) on delete cascade,
add constraint fk_order_items_sellers foreign key (seller_id) references sellers(seller_id) on delete cascade;

select distinct order_id
from order_payments 
where order_id not in (select order_id from orders);

delete from order_payments
where order_id not in (select order_id from orders);

alter table order_payments add CONSTRAINT fk_order_payments_orders foreign key (order_id) references orders(order_id) on delete cascade; 

select distinct order_id
from order_reviews
where order_id not in (select order_id from orders);

delete from order_reviews
where order_id not in (select order_id from orders);

alter table order_reviews add constraint fk_order_reviews_orders foreign key (order_id) references orders(order_id) on delete cascade;
  
select distinct customer_id
from orders
where customer_id not in (select customer_id from customers);

alter table orders add constraint fk_orders_customers foreign key (customer_id) references customers(customer_id) on delete cascade;