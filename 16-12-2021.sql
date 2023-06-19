create database MySqlDatabase
use MySqlDatabase
create table Student(
	id int ,
	sname varchar(20),
	saddress varchar(20),
	age int
)
select * from Student
insert into Student values (1,'Bhushan','Mumbai',20), (2,'Rakshit','Mumbai',24),(3,'Rahul','Mumbai',28), (4,'Uma','Mumbai',21)
select * from Student where age>22
insert into Student values (25,'Rutuja','Mumbai',20)
update Student set sname='Rakshit R' where id=2

--index 
create index index_age on Student(age)
select * from Student where age>22

create table Products(
	prod_id int primary key,
	prod_name varchar(20),
	prod_price int,
	prod_quantity int
)
insert into Products values(1,'Mobile1',10000,12),(2,'Laptop1',15000,11),
(3,'Hard disk',5000,1),(4,'Speakers',800,8),(5,'Mobile2',10000,15)

select * from Products

--commit
--starting transaction
begin transaction
---SQL statements
insert into Products values(7,'Mobile3',8000,20)
update Products set prod_price=940 where prod_id=4
--comminting changes
commit transaction


---Rollback
begin transaction
---SQL statements
update Products set prod_price=940 where prod_id=10
delete from Products where prod_id=12
---undoing changes
rollback transaction

---@@Error
begin transaction 
insert into Products values(7,'Mobile4',8000,20)
--check error if any
if(@@ERROR>0)
begin
	rollback transaction
	print 'Error Found'
end
else
begin
	commit transaction
	print 'Error not  Found Data added'
end

select * from Products

insert into Products values(7,'Mobile4',8000,20)
update Products set prod_price=6000 where prod_id=3

begin transaction 
insert into Products values(9,'Mobile4',8000,20)
update Products set prod_price=7000 where prod_id=3
select * from Products
commit transaction


---savepoints
begin transaction 
--1
insert into Products values(11,'Mobile4',8000,20)

--creating save point
save transaction insertStatement
--2
delete from Products where prod_id=1
--3
select * from Products

rollback transaction insertStatement

commit

---Example
begin transaction buy
declare @pid int
set @pid=2;
declare @quantity int
set @quantity=3
declare @availableQty int
set @availableQty= (select prod_quantity from Products where prod_id=@pid)
update Products set prod_quantity =(@availableQty-@quantity) where prod_id=@pid
if(@availableQty<@quantity)
begin
	print 'No sufficient Quantity available'
	rollback transaction buy
end
else
begin
	print 'Your purchase has been done'
	commit transaction buy
end

select * from Products

---Exceptional Handling in SQL Server
--try catch , XACT_STATE, 
create table person(
	person_id int primary key identity,
	first_name varchar(20) not null,
	last_name varchar(20) not null	
)
create table work(
	wid int primary key identity,
	person_id int not null,
	work_info varchar(50),
	foreign key(person_id) references person(person_id)
)
drop table work
insert into person values ('abc','xyz'),('lmn','opq')

insert into work values(1,'Good work done')

select * from person
delete from  person where person_id=2
select * from work

--- create stored procedure to implement all error functions
drop proc getting_error_report
create proc getting_error_report
as
SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO
--- creating stored procedure for deleting prson from table 
create proc delete_person(@person_id int)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        -- delete the person
        DELETE FROM person 
        WHERE person_id = @person_id;
        -- if DELETE succeeds, commit the transaction
        COMMIT TRANSACTION;  
    END TRY
    BEGIN CATCH
        -- report exception
        EXEC getting_error_report
        
        -- Test if the transaction is uncommittable.  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  
        
        -- Test if the transaction is committable.  
        IF (XACT_STATE()) = 1  
        BEGIN  
            PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
            COMMIT TRANSACTION;     
        END;  
    END CATCH
END;
GO

	exec delete_person 15
	exec getting_error_report
	drop proc delete_person


	---Row, rank , partition function
create table Sales(
 cust_name varchar(20),
 prod_name varchar(20),
 amount float,
 brand_name varchar(20)
)

insert into Sales values ('Rakshit','Shoes',450,'Armani'),('Uma','Belt',4599,'Woodland'),
('Rahul','Shoes',450,'Armani'),('Rakshit','PErfume',450,'Armani')

select * from Sales

--row number - Only adding virtual rows for all rows present in our table
--row number is have to use with over keyword
select  ROW_NUMBER() over (order by cust_name) as Row_id,
		ROW_NUMBER() over (partition by brand_name order by brand_name) as RowForBrand,
		DENSE_RANK() over (order by cust_name) as CustId,
		cust_name,
		prod_name,
		amount,
		brand_name
		from Sales

---CTE
create table Employee(
Emp_id int primary key,
first_name varchar(50),
last_name varchar(50),
Manager_id int
)

insert into Employee values (2,'ABC', 'XYZ',1)
select * from Employee

--syntax for CTE
with getEmpBasicInfo(Emp_id,first_name)
as
(
	select Emp_id,first_name from Employee
)
select * from getEmpBasicInfo


begin transaction hello
insert into Products values(14,'acc',8000,20)
rollback transaction hello















--execution time

