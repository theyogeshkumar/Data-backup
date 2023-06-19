CREATE TABLE Departments
(
	DepartmentID int IDENTITY(1,1) PRIMARY KEY,
	DepartmentName nvarchar(40) NOT NULL
)

CREATE TABLE Employees
(
	EmployeeId int IDENTITY(1001,1) PRIMARY KEY,
	FirstName nvarchar(20) NOT NULL,
	LastName nvarchar(20) NOT NULL,
	DateofBirth smalldatetime NOT NULL,
	ContactNo bigint NOT NULL,
	DepartmentID int REFERENCES Departments(DepartmentID) ON UPDATE CASCADE ON DELETE SET NULL,
)