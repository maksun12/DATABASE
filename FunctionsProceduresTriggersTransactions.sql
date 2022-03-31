use SoftUni

--ex1
Create  PROC usp_GetEmployeesSalaryAbove35000 AS
Select FirstName, LastName
From Employees
Where Salary >35000

EXEC usp_GetEmployeesSalaryAbove35000

--ex2
Create PROC usp_GetEmployeesSalaryAboveNumber(@inputSalary DECIMAL(18,4)) AS
Select FirstName, LastName
From Employees
Where Salary >=@inputSalary

EXEC usp_GetEmployeesSalaryAboveNumber 48100

--ex3 
Create PROC usp_GetTownsStartingWith (@InputSartIndex NVARCHAR(20)) AS
Select [Name]
From Towns
Where Name Like @InputSartIndex + '%'

Exec usp_GetTownsStartingWith 'b'

--ex4
Create PROC usp_GetEmployeesFromTown  (@InputTown NVARCHAR(20)) AS
Select FirstName,LastName
From Employees as e
Join Addresses AS a ON a.AddressID =e.AddressID
Join Towns AS t ON a.TownID = t.TownID
Where t.[Name]= @InputTown 

Exec usp_GetEmployeesFromTown 'Sofia'

--ex5
Create Function ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
Returns VARCHAR(20)
AS
Begin
Declare @result VARCHAR(20)

IF(@salary <30000)
   SET @result = 'Low'
Else IF(@salary >=30000 and @salary <=50000)
   SET @result = 'Average'
Else 
   Set @result = 'High'

return @result;
End
 
--ex6
Create PROC usp_EmployeesBySalaryLevel(@InputLevelSalary NVARCHAR(20)) 
as
Select FirstName,LastName
From Employees
Where dbo.ufn_GetSalaryLevel(Salary) = @InputLevelSalary

Exec usp_EmployeesBySalaryLevel 'High'

--ex7
Create FUNCTION ufn_IsWordComprised(@setOfLetters Varchar(MAX), @word Varchar(MAX)) 
Returns Bit
Begin
Declare @count Int=1;

While (@count<=LEN( @word))
Begin
  Declare @currentLetter Char(1) = Substring(@word,@count,1)
  If(CHARINDEX(@currentLetter,@setOfLetters)=0)
    Return 0
	
	SET @count +=1;
End
Return 1
End

--ex8
Create Proc usp_DeleteEmployeesFromDepartment (@departmentId INT) AS

Alter Table Departments
Alter Column ManagerID INT Null

Delete From EmployeesProjects
Where EmployeeID IN (SELECT EmployeeID FROM Employees Where DepartmentID = @departmentId)

Update Employees
Set ManagerID=Null
Where EmployeeID IN (Select EmployeeId From Employees Where DepartmentID=@departmentId)

Update Employees 
Set ManagerID = Null
Where ManagerID IN (Select EmployeeID From Employees Where DepartmentID=@departmentId)

Update Departments 
Set ManagerID=Null
Where ManagerID In (Select EmployeeId From Employees Where DepartmentID=@departmentId)

Delete
From Employees
Where DepartmentID=@departmentId

Delete From Departments
Where DepartmentID=@departmentId

Select COUNT(*) From Employees 
Where DepartmentID=@departmentId

use Bank
--ex 9 
Create Proc usp_GetHoldersFullName  AS
Select FirstName  + ' ' + LastName as [Full Name]
From AccountHolders

--ex10
Create Proc usp_GetHoldersWithBalanceHigherThan (@totalBalance Decimal(15,2)) AS
Select FirstName,LastName
From AccountHolders AS ah
Join Accounts AS a ON a.AccountHolderId=ah.Id
Group By FirstName,LastName
Having Sum(Balance) > @totalBalance
Order By FirstName,LastName

Exec dbo.usp_GetHoldersWithBalanceHigherThan 50000

--ex 11
Create Function ufn_CalculateFutureValue(@sum Decimal(15,2),@yearlyInterestRate Float,@numOfYears Int)
Returns Decimal(15,4)
Begin
  Declare @result Decimal(15,4)
  SET @result = (@sum*Power((1+@yearlyInterestRate),@numOfYears))
  
Return @result
End

--ex12
Create Proc usp_CalculateFutureValueForAccount(@accountId INT,@interestRate Float) AS
Select a.Id,ah.FirstName,ah.LastName,Balance as [Current Balance], dbo.ufn_CalculateFutureValue(Balance,@interestRate,5) as [Balance in 5 years]
From AccountHolders as ah
Join Accounts as a ON a.AccountHolderId = ah.Id
Where a.Id=@accountId

use Diablo
--ex13
Create Function ufn_CashInUsersGames(@gameName VARCHAR(100)) 
Returns Table
AS
Return (Select Sum(k.TotalCash) as TotalCash
From (Select Cash AS TotalCash, ROW_NUMBER() Over (Order By Cash Desc) AS RowNumber
From Games AS g
Join UsersGames AS ug On ug.GameId=g.Id
Where Name = @gameName) AS k
Where k.RowNumber % 2 =1)
