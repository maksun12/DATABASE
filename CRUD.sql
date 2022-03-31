USE SoftUni

SELECT Name 
FROM Departments

Select FirstName, LastName, Salary 
From Employees

Select FirstName,MiddleName , LastName From Employees

Select FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Address] 
From Employees

Select Distinct Salary 
From Employees

Select * From Employees 
WHERE JobTitle ='Sales Representative'

Select FirstName,LastName,JobTitle 
From Employees 
WHERE Salary  between 20000 and 30000

Select FirstName + ' ' +MiddleName + ' ' +LastName AS [Full Name] 
From Employees 
Where Salary = 25000 or Salary IN (25000,14000,12500,23600)

Select  FirstName, LastName, Salary 
From Employees
Where Salary > 50000 
ORDER BY Salary DESC 

Select FirstName, LastName
From Employees
Where DepartmentID != 4

Select * 
From Employees 
Order By Salary Desc, FirstName asc,LastName desc, MiddleName asc
 
CREATE VIEW V_EmployeesSalaries 
AS Select FirstName,LastName,Salary 
From Employees

CREATE VIEW V_EmployeeNameJobTitle 
AS Select FirstName + ' ' + ISNULL(MiddleName,'') + ' ' + LastName 
AS [Full Name], JobTitle  
From Employees 

Select Distinct JobTitle
From Employees
ORDER BY JobTitle ASC

Select TOP(10) * 
From Projects 
Order By StartDate, Name

Select Top(7) FirstName, LastName,HireDate
From Employees
Order By HireDate Desc

Update Employees 
SET Salary = Salary * 1.12
Where DepartmentID IN (1,2,4,11)
Select Salary From Employees

USE Geography

Select PeakName 
From Peaks 
Order By PeakName

SELECT TOP(30) CountryName,Population 
FROM Countries 
Where ContinentCode='EU' 
Order By Population Desc

Select CountryName,CountryCode,  
CASE
    WHEN CurrencyCode = 'EUR' THEN 'Euro'
    ELSE 'Not Euro'
END AS Currency
    From Countries 
	Order By CountryName 


USE Diablo

Select Name From Characters Order By Name