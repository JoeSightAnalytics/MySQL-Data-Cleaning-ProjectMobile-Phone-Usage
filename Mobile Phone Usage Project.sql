create database World_Mobile_Phone_Usage;
use world_mobile_phone_usage;
select *
from mobile_phone_usage;

# Data cleaing
-- Deal with duplicate values
-- Standardization of the dataset
-- Dealing with null values or blank values
-- Rank the dataset

# Dealing with duplicate values

select *
from mobile_phone_usage;

select *, row_number() over(partition by `Ã¯Â»Â¿name`, slug, `value`, date_of_information, region order by `Ã¯Â»Â¿name` ) Row_num
from mobile_phone_usage;

With Duplicate_cte as (
select *, row_number() over(partition by `Ã¯Â»Â¿name`, slug, `value`, date_of_information, region order by `Ã¯Â»Â¿name` ) Row_num
from mobile_phone_usage
)
select *
from Duplicate_cte
where row_num > 1;

-- This shows that there are no duplicate values

# Standardization of the dataset

-- Changing the name of the first column

alter table mobile_phone_usage
rename column Ã¯Â»Â¿name to Country;

select *
from mobile_phone_usage;

-- Let's chech to see if the first and second column are exactly the same

select *
from mobile_phone_usage
where country != slug;

-- Column 1 is the same as column 2 and so that renders column 2 redundant, so I have to delete column 2

alter table mobile_phone_usage
drop column slug;

select *
from mobile_phone_usage;

-- the column named value has its data type as text, that needs to be changed into int

alter table mobile_phone_usage
modify column `value` bigint;

-- I encountered a problem, I cannot convert the 'value' data type to bigint because the data have a comma, so I will have to remove the commas and then try changing it again


select *
from mobile_phone_usage;

update mobile_phone_usage
set `value` = replace(`value`, ',', '' );


select *
from mobile_phone_usage;

alter table mobile_phone_usage
modify column `value` bigint;

select `value`+ 0  test
from mobile_phone_usage;

select *
from mobile_phone_usage;

-- Lets try to look for null or blank values

select *
from mobile_phone_usage
where country is null
or country = '';

select *
from mobile_phone_usage
where `value` is null
or `value` = '';

select *
from mobile_phone_usage
where date_of_information is null
or date_of_information = '';

select *
from mobile_phone_usage
where region is null
or region = '';

-- It is for a fact that Wallis and Funtuna uses mobile phones. The value of zero can affect the visualization of the whole dataset and so I will remove it.
-- I understand that deleting data is a serious matter that is why I have the original data backed up.

delete
from mobile_phone_usage
where `value` is null
or `value` = '';

select *
from mobile_phone_usage;

-- Let us rank the data as it will be very useful in visualization of the data


select *, rank() over(order by `value` desc) Ranking
from mobile_phone_usage;

alter table mobile_phone_usage
add column `Rank` int;

set @`rank` = 0; 
update mobile_phone_usage
set `rank` = (@`rank` := @`rank` + 1)
order by `value` desc;

select *
from mobile_phone_usage;
