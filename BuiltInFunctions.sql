Use SoftUni

--ex1
Select FirstName, LastName 
From Employees
Where FirstName Like 'sa%'

--ex2
Select FirstName, LastName 
From Employees
Where LastName Like '%ei%'

--ex3
Select FirstName 
From Employees
Where  DepartmentID in (3,10) and HireDate between '1995/01/01' and '2005/12/31'

--ex4
Select FirstName, LastName 
From Employees
Where JobTitle Not Like '%engineer%'

--ex5
Select Name
From Towns
Where Len(Name) in(5,6)
order by Name

--ex6
Select *
From Towns
Where LEFT(Name,1) in ('e','m','k','b') or Name like '[MKEB]%'
order by Name

--ex7
Select *
From Towns
Where Name NOT like '[RBD]%'
order by Name

--ex8
Create view V_EmployeesHiredAfter2000 
AS Select FirstName, LastName
From Employees
Where DATEPART(YEAR,HireDate) > '2000'

--Ex 9
Select FirstName, LastName
From Employees
Where Len(LastName) =5

--Ex10
Select EmployeeID, FirstName, LastName,Salary, Dense_Rank() Over (Partition By Salary Order By EmployeeID) AS Rank
From Employees
Where Salary Between 10000 and 50000 
Order by Salary desc

--Ex11
Select * From
(
Select EmployeeID, FirstName, LastName,Salary, Dense_Rank() Over (Partition By Salary Order By EmployeeID) AS Rank
From Employees
Where Salary Between 10000 and 50000 
) As Result
Where [Rank] = 2
Order by Salary desc
 

 Use Geography
 --ex12
 Select CountryName as 'Country Name',IsoCode as 'ISO Code'
From Countries
Where CountryName like '%a%a%a%'
order by IsoCode

 --ex13
Select PeakName, RiverName, LOWER(LEFT(PeakName, LEN(PeakName)-1) + LOWER(RiverName)) as 'Mix'
From Peaks,Rivers
Where RIGHT(PeakName,1) = Left(RiverName,1)
order by [Mix]

Use Diablo
--ex14
Select Top(50) Name, Format([Start],'yyyy-MM-dd') As [Start]
From Games
Where DATEPART(YEAR,[Start]) Between 2011 And 2012
Order By [Start], [Name]

--ex 15
Select Username, Substring(Email,CHARINDEX('@', Email) + 1, LEN(Email)) as 'EmailProvider'
From Users
order by [EmailProvider], Username

--ex16
Select Username, IpAddress
From Users
Where IpAddress like '___.1%.%.___'
Order By Username

--ex 17
Select [Name], 
Case
When DATEPART(HOUR,Start) Between 0 and 11 then 'Morning'
When DATEPART(HOUR,Start) Between 12 and 17 then 'Afternoon'
When DATEPART(HOUR,Start) Between 18 and 23 then 'Evening'
End 
As [Part of the Day],
Case
When Duration <=3 Then 'Extra Short'
When Duration Between 4 and 6 Then 'Short'
When Duration >6 Then 'Long'
Else 'Extra Long'
End As [Duration]
From Games
Order By [Name],[Duration],[Part of the Day]

Use Orders
--ex 18
Select ProductName,OrderDate, 
DATEADD(DAY,3,OrderDate) As [Pay Due], 
DATEADD(MONTH,1,OrderDate) As [Deliver Due]
From Orders