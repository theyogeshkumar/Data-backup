
Create Schema Production;

Create Table Production.ProductCategory(
 ProductCategoryID INT Primary Key Identity(1000,1),
 ProductCategoryName VARCHAR(20)
 )

 Create Table Production.ProductSubCategory(
  ProductSubCategory INT Primary Key Identity(1001,1),
  ProductSubCategoryName Varchar(20) Not Null,
  ProductCategoryID INT References Production.ProductCategory(ProductCategoryID) On Delete Cascade Not Null
 )

 Create Table Production.Product(
  ProductId INT Primary Key Identity(1000,1),
  ProductName Varchar(20) Not Null,
  ProductCost Money,
  ProductSubCategoryID Int References production.ProductSubCategory(ProductSubCategory) On Delete Cascade Not Null
 )

 Create Schema Person;

  Create Table Person.Person(
	PersonId INT Primary Key Identity(1000,1),
	Title Varchar(20),
	FirstName Varchar(20) Not Null,
	MiddleName Varchar(20),
	LastName Varchar(20),
	Gender Varchar(20) Check( Gender IN('Male','Female','Others')),
	ModifiedDate Date
  )
  

 Create Schema HumanResources;

 Create Table HumanResources.Department(
  DepartmentID INT Primary Key Identity(1000,1),
  DepartmentName Varchar(20) Not Null
 )

 Create Table HumanResources.Employee(
 EmployeeId INT Primary Key Identity(1000,1),
 Designation Varchar(20) Not Null,
 ManagerID  Varchar(20),
 DateOfJoining Date,
 DerpartmentID INT References HumanResources.Department(DepartmentID) On Delete Cascade Not Null,
 PersonID INT References Person.Person(PersonID) On Delete Cascade Not Null
 )

 Create Schema Sales;

 Create Table Sales.Country(
  CountryID INT Primary Key Identity(1000,1),
  CountryName Varchar(20) Not Null
 )

 Create Table Sales.Territory(
  TerritoryID INT Primary Key Identity(1000,1),
  TerritoryName Varchar(20) Not Null,
  CountryID INT References Sales.Country(CountryID) On Delete Cascade Not Null
 )

 Create Table Sales.Customer(
  CustomerID INT Primary Key Identity(1000,1),
  PersonID INT References Person.Person(PersonID) On Delete Cascade Not Null,
  TerritoryID INT References Sales.Territory(TerritoryID) On Delete Cascade Not Null,
  CustomerGrade Varchar(20)
 )

 Create Table Sales.SalesOrderHeader(
	SalesOrderHeaderID INT Primary Key Identity(1000,1),
	OrderDate Date,
	CustomerID INT References Sales.Customer(CustomerID) Not Null,
	SalesPersonID INT References HumanResources.Employee(EmployeeID) ON Delete Cascade Not Null
 )

 Create Table Sales.SalesOrderDetails(
 SalesOrderDetailsID INT Primary Key Identity(1000,1),
 SalesOrderHeaderID INT References Sales.SalesOrderHeader(SalesOrderHeaderID),
 ProductID INT References Production.Product(ProductID) On Delete Cascade,
 OrderQuantity INT 
 )
--Lab3
--1
SELECT BusinessEntityID, concat(FirstName,' ',MiddleName,' ', LastName),ModifiedDate FROM Person.Person Where ModifiedDate > 2000-12-29
--3
SELECT ProductID,Name FROM Production.Product Where Name like 'Chain%';
--4
SELECT BusinessEntityID, FirstName, MiddleName,LastName FROM Person.Person WHERE MiddleName Like '[B,E]' ;
--5
SElECT  SalesOrderID, OrderDate, totaldue from Sales.SalesOrderHeader Where year(OrderDate) = 2001 And Month(OrderDate)= 9 And Totaldue > 1000
Select * from Sales.SalesOrderHeader 

--7.
SELECT ProductID, Name, Color FROM Production.Product WHERE Color <> 'Blue'
--8.
SELECT BusinessEntityID,FirstName, MiddleName,LastName FROM Person.Person group By LastName, FirstName, MiddleName
--9. 
SELECT CONCAT(AddressLine1 ,'(', City , PostalCode, ')') AS FullAddress FROM Person.Address
--10.	
   Select ProductID, IsNull(Color,'No Color') AS Description, Name from production.Product
--11.
 Select ProductID, CONCAT('Name: ',IsNull(Color,' ')) AS Description, Name from production.Product
--12
 Select SpecialOfferID, Description, (MaxQty - MinQty) AS Difference from Sales. SpecialOffer
--13
 Select SpecialOfferID, Description, (IsNull(MaxQty, 100)*DiscountPct) AS Discount from Sales. SpecialOffer
--14
 Select SUBSTRING(AddressLine1, 1,10) As Address From Person.Address
 --15
  Select SalesOrderID, OrderDate,ShipDate, DATEDIFF(dd, OrderDate, ShipDate) As NoOfDays From Sales.SalesOrderHeader
--16
  Select SalesOrderID,Convert(Date, OrderDate) As OrdDate, Convert(Date, ShipDtae) As ShipDate From Sales.SalesOrderHeader
--17
  select SalesOrderID, OrderDate, DateAdd(MM, 6, OrderDate) AS AddMonth from Sales.SalesOrderHeader

--18
  Select SalesOrderID, OrderDate, YEAR(OrderDate) AS Year, Month(OrderDate) As Month From Sales.SalesOrderHeader
--19
   Select ROUND(RAND() * 9, 0) + 1
--20
   Select SalesOrderID, OrderDate From Sales.SalesOrderHeader Where Year(OrderDate) = '2001'

--21 
   
   Select SalesOrderID,OrderDate From Sales.SalesOrderHeader Order By Month(OrderDate), Year(OrderDate)
--22
    Select  Emp.Jobtitle, Emp.BirthDate, PP.Firstname, PP.LastName From HumanResources.Employee As Emp Inner Join Person.Person
	On Emp.BusinessEntityID = pp.BusinessEntityID

--23
	Select CustomerID, SalesQuota, Bonus From Sales.SalesOrderheader As SOH Inner Join Sales.Salesperson as SP on SOH.SalespersonID = SP.BusinessEntityID

--25
	Select Color, Size PM.CatalogDescription From production.ProductionModel AS PM Inner Join production.Product As PP ON PM.ProducModelID = PP.ProductionID
--30
	Select Sum(ListPrice) as MAx, MIN(ListPrice) As Min, AVG(ListPrice) As Avg From Production.Product
--31
	Select Sum(OrderQty) as Total, ProductID From Sales.SalesOrderDetails group by productID
--32
	 select Count(*) As Count, SalesorderID From Sales.SalesOrderDetails group by SalesOrderID
--33
	select Count(*) As Count, ProductLine From production.Product group By ProductLine
--34
 Select Count(*), CustomerID, year(OrderDate) As Year From Sales.SalesOrderHeader Group By CustomerID, Year(OrderDate)

--Lab 4
--Labs 5

 --1

CREATE FUNCTION dbo.Fn_Prime(@Low int, @High int)
RETURNS @Output TABLE(
  prime int
  )
AS
Begin
DECLARE @Flag INT=0
If @Low = 1
Begin
 Set @Low = @Low +1
End
WHILE @Low<=@High
BEGIN
    DECLARE @J INT = @Low-1
    SET @Flag =1
    WHILE @J>1
    BEGIN
        IF @Low % @J=0
        BEGIN
            SET @Flag=0
        END
        SET @J=@J-1
    END
    IF @Flag =1
    BEGIN
        INSERT INTO @Output VALUES (@Low)
    END
    SET @Low=@Low+1
END
Return 
END
SELECT * FROM dbo.Fn_Prime(3,200)

---2

 Create Function fn_catname(
@categoryName varchar(20))
Returns Table 
AS Return  SELECT Name FROM Production.Product WHERE ProductSubcategoryID IN
(
	SELECT ProductSubcategoryID FROM Production.ProductSubcategory
	WHERE ProductCategoryID =
	(
		SELECT ProductCategoryID FROM Production.ProductCategory
		WHERE NAME = @categoryName
	)
)

select * from fn_catname('Bikes')


--6
Create TABLE Bank(
      AccountID INT PRIMARY KEY IDENTITY(1000,1),
      CustomerName VARCHAR(30) NOT NULL,
      AccountType  VARCHAR(20) CHECK(AccountType In ('Current','Saving')),
      Balance INT CHECK (Balance > 0),
      ModifiedDate DATE);

	  select * from BankAccounts

Create TABLE Transactions(
	TransactionID INT PRIMARY KEY IDENTITY(1000,1),
    AccountID INT  REFERENCES Bank(AccountID) On Delete CASCADE NOT NULL,
    TransactionDate Date,
    TransactionType VARCHAR(20) CHECK(TransactionType IN('Debit','Credit')),
	TransactionAmount INT NOT NULL
 )
 
 INSERT INTO Bank VALUES('Rajen','Saving',10000,GETDATE())
 INSERT INTO Bank VALUES('Aj','Current',50000,GETDATE())
 INSERT INTO Bank VALUES('Joel','Saving',100000,GETDATE())
 INSERT INTO Bank VALUES('Mahesh','Saving',90000,GETDATE())

Update Bank set Balance =  Balance + 100 where AccountID = 1000

create trigger Tg_banktrans
on Bank
after update
as
begin
    declare @aid int;
    declare @bal money;
	Declare @del money;
	DECLARE @NewVal Money;
    set @aid = (select AccountID from inserted)
    set @bal = (select Balance from inserted)
	Set @del = (select Balance from deleted)
	Set @NewVal = @bal-@del
	If (@NewVal > 0)
     insert into Transactions values(@aid, getdate(), 'Credit', @NewVal )
	Else
	 insert into Transactions values(@aid, getdate(), 'Debit', @NewVal )
end 

--7
--1
 Create Procedure SP_Str @Str varchar(20)
 AS
 BEGIN
 BEGIN Try
	 DECLARE @var INT
	 SET @var = (SELECT CAST(@Str AS INT ))
	 While (@var>0)
	  Begin
	    print 'Hello'
		SET @var = @var -1;
	  End
 End Try
 Begin catch
    Print 'error'
 End catch
END

DROP Procedure SP_Str
exec SP_Str @Str ='as'

--2
 Create table #Employee(
 EmpID INT Primary Key Identity(1000,1),
 EmpName Varchar(20) NOT NULL,
 EmpSalary money
 )

 Create Procedure Sp_Emp_Sal @eName varchar(20), @eSalary money
 As
 Begin
  Begin Try
   If @eSalary > 10000
	Begin
		 Insert Into #Employee Values(@eName, @eSalary);
	End
   Else
    Begin 
	RAISERROR('Salary must be greater than 10000!',16,0)
   End
 End Try
   begin Catch
   Select ERROR_NUMBER() AS ErrorNO, ERROR_MESSAGE() AS Message
 End Catch
END

Exec Sp_Emp_Sal @eName = 'Noel', @eSalary = 1000


--8

A deadlock problem occurs when two or more operations already want to access resources locked by
the other one. In this circumstance, database resources are affected negatively because both processes are 
constantly waiting for each other

Resolving deadlock problems

After diagnosing a deadlock problem, the next step is to attempt to resolve the deadlock issue resulting between 
two concurrently running applications each of which have locked a resource the other application needs. 
The guidelines provided here can help you to resolve the deadlock problem you are experiencing and help you to prevent such
future incidents.

Procedure
Use the following steps to diagnose the cause of the unacceptable deadlock problem.

1.Obtain information from the lock event monitor or administration notification log about all tables where agents 
are experiencing deadlocks.
2.Use the information in the administration notification log to decide how to resolve the deadlock problem.
There are a number of guidelines that help to reduce lock contention and lock wait time. Consider the following options:
	Each application connection should process its own set of rows to avoid lock waits.

    Deadlock frequency can sometimes be reduced by ensuring that all applications access their common data in the same 
	order - meaning, for example, that they access (and therefore lock) rows in Table A, followed by Table B, followed by
	Table C, and so on. If two applications take incompatible locks on the same objects in different order, they run a much
	larger risk of deadlocking.

	A lock timeout is not much better than a deadlock, because both cause a transaction to be rolled back, but if you must 
	minimize the number of deadlocks, you can do it by ensuring that a lock timeout will usually occur before a potential 
	related deadlock can be detected. To do this, set the value of the locktimeout database configuration parameter 
	(units of seconds) to be much lower than the value of the dlchktime database configuration parameter (units of milliseconds).
	Otherwise, if locktimeout is longer than the dlchktime interval, the deadlock detector could wake up just after the deadlock
	situation began, and detect the deadlock before the lock timeout occurs.

	Avoid concurrent DDL operations if possible. For example, DROP TABLE statements can result in a large number of catalog 
	updates as rows might have to be deleted for the table indexes, primary keys, check constraints, and so on, in addition 
	to the table itself. If other DDL operations are dropping or creating objects, there can be lock conflicts and even occasional
	deadlocks.
   It is best practice to commit the following actions as soon as possible:
		Write actions such as delete, insert, and update
		Data definition language (DDL) statements, such as ALTER, CREATE, and DROP
		BIND and REBIND commands
3.The deadlock detector is unable to know about and resolve the following situation, so your application design must guard against
this. An application, particularly a multithreaded one, can have a deadlock involving a DB2® lock wait and a wait for a resource 
outside of the DB2 software, such as a semaphore. For example, connection A can be waiting for a lock held by connection B, and B
can be waiting for a semaphore held by A.