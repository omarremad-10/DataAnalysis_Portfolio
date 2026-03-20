select * from employee_demographics;

select * from employee_salary;

select emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id as emp_name,
emp2.first_name as first_name_emp,
emp2.last_name as last_name_emp
from employee_salary as emp1
JOIN employee_salary as emp2
on emp1.employee_id +1  = emp2.employee_id;


select first_name,last_name, 'Old Man' as label
from employee_demographics
where age > 40 and gender = 'male'
UNION
select first_name,last_name, 'Old Lady' as label
from employee_demographics
where age > 40 and gender = 'female'
UNION
select first_name,last_name, 'highly paid employee' as label
from employee_salary
where salary > 70000 
order by first_name, last_name ; 

select lower(first_name)
from employee_demographics
order by first_name;

select first_name,last_name,salary,
case	
when salary < 50000 then salary * 1.05
when salary > 50000 then salary * 1.07
end as New_Salary,
case	
when dept_id = 6 then salary * .10
end as Bonus
from employee_salary;


select *
from employee_demographics
where employee_id in (
		        select employee_id
                from employee_salary
                where dept_id =1
);

select first_name,salary,
(select avg(salary) 
from employee_salary)
from employee_salary;

select *
from
( select gender,avg(age),min(age),max(age),count(age)
from employee_demographics
group by gender) as agg_table;



select gender, avg(salary) as AVG_SALARY
from employee_demographics as dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
group by gender
;

select dem.first_name,dem.last_name,gender,salary, sum(salary) over(partition by gender order by dem.employee_id) as Rolling_Total
from employee_demographics as dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
;

select dem.employee_id,dem.first_name,dem.last_name,gender,salary, 
row_number() over(partition by gender order by salary desc)
from employee_demographics as dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
;

with CTE_EXAMPLE (Gender,Avg_Sal,MIN_Sal,MAX_Sal,Count_Sal) as 
(
select gender,avg(salary) as avg_sal,min(salary) as min_sal,max(salary) as max_sal,count(salary) as count_sal
from employee_demographics as dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
group by gender
)
select avg(avg_sal)
from CTE_EXAMPLE;


with cte_Example1 as 
(
select employee_id,gender,birth_date
from employee_demographics as dem
where birth_date > '1985-01-01'
),
cte_Example2 as
(
select employee_id,salary
from employee_salary
where salary > 50000
)
select *
from cte_Example1
join cte_Example2
on cte_Example1.employee_id = cte_Example2.employee_id;


Create temporary table Temp_Table
(
first_name varchar(50),
last_name varchar(50),
favourite_movie varchar(100)
);

select *
from Temp_Table;

INSERT into Temp_Table
values ('omar','emad','Lord of the rings');

select *
from Temp_Table;

create temporary table salary_over_50k
select *
from employee_salary
where salary >= 50000;

select * 
from salary_over_50k;

create procedure large_salaries1()
select * 
from employee_salary
where salary >=50000;


DELIMITER $$
create procedure large_salaries3()
begin
select *
from employee_salary
where salary >= 50000;
select *
from employee_salary
where salary >= 100000;
end $$
DELIMITER;


DELIMITER $$
create procedure  large_salariess(omdani int)
begin
select salary
from employee_salary
where employee_id = omdani
;
end $$
DELIMITER ;

call large_salariess(1);


delimiter $$
create trigger employee_insert
after insert on employee_salary
for each row
begin 
insert into employee_demographics
(employee_id,first_name,last_name)
values (new.employee_id,new.first_name,new.last_name);
end $$
delimiter ;

insert into employee_salary (employee_id,first_name,last_name,occupation,salary,dept_id)
values(13,'omar','emad','data analyst',1000000,null);

select *
from employee_salary;


select *
from employee_demographics;


delimiter $$
create event delete_retirees
on schedule every 10 second
do
begin
delete
from employee_demographics
where age >= 60;
end $$
delimiter ;

select * from employee_demographics;







