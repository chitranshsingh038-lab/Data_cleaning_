use public_file_cleaning;

select * from coffee_sales;

#removing unwanted space
update coffee_sales
       set date_=trim(lower(date_)),
           datetime_=trim(lower(datetime_)),
           cash_type=trim(lower(cash_type)),
           money=trim(money),
           coffee_name=trim(lower(coffee_name));

# filling null values in card column
update coffee_sales
   set card_='payment_by_cash' where 
	   cash_type='cash'
       and (card_ is null or trim(card_)='');
   
# identifying any missing value or any null cell
select * from coffee_sales
where trim(date_) ='' or date_ is null
   or (datetime_)='' or datetime_ is null
   or (cash_type)='' or cash_type is null
   or (card_) ='' or card_ is null
   or (money) ='' or money is null
   or (coffee_name) ='' or money is null;
   
# finding any speling mistake in cash_type
select cash_type,count(*),monet as total_payments from coffee_sales
group by cash_type,money
order by total_payments;

# no spelling mistake 
# only two payment modes cash,card

# finding spelling mistake in coffee_name
select coffee_name,count(*),money from coffee_sales
group by coffee_name,money
order by coffee_name,count(*) desc;

# no spelling mistake found

update coffee_sales
set money= case 
	when coffee_name='hot chocolate'then 35.76
    when coffee_name='cocoa' then 35.76
    when  coffee_name='espresso' then 21.06
    when  coffee_name='cortado' then 25.96
    when  coffee_name='cappuccino' then 35.76
	when  coffee_name='americano' then 25.96
    when  coffee_name='latte' then 35.76
    when  coffee_name ='americano with milk' then 30.86 end;
    
# cleaning Date_ column

# checking data format 
describe coffee_sales;

#finding maximum and minimum and maximum date
SELECT 
    MIN(date_) AS lowest_date,
    MAX(date_) AS highest_date
FROM coffee_sales;

# minimum date='1/2/2025'
# maximum date='31/12/2024'

# checking any wrong formated-value in date
SELECT *
FROM coffee_sales
WHERE STR_TO_DATE(date_, '%Y-%m-%d') IS NULL
  AND date_ IS NOT NULL
  AND TRIM(date_) <> '';
  
# identifying any mistake in date(day) column
select * from coffee_sales
where day(date_)>1
   or day(date_)<31
   or month(date_)>1
   or month(date_)<12;

# checking duplicate rows it exist
SELECT 
    date_,datetime_,cash_type,
    card_,money,coffee_name,
    COUNT(*) AS duplicate_count
FROM coffee_sales
GROUP BY 
    date_,datetime_,cash_type,
    card_,money,coffee_name
HAVING COUNT(*) > 1;

# convert dare column to date format
alter table coffee_sales
add column dates_  Date;

update coffee_sales
set dates_=str_to_date(trim(date_), '%d-%m-%Y');

alter table coffee_sales
drop date_;

alter table coffee_sales
modify column dates_ date first ;

commit

# dara cleaning complited 