Use SoftUni 

--ex1
Select TOP(5) e.EmployeeId, e.JobTitle, a.AddressId, a.AddressText
From Employees AS e 
Join Addresses AS a ON a.AddressID = e.AddressID
Order By a.AddressID

--ex2
Select TOP(50) e.FirstName, e.LastName, t.[Name], a.AddressText
From Employees AS e 
Join Addresses AS a ON a.AddressID = e.AddressID
Join Towns AS t ON t.TownID = a.TownID
Order By e.FirstName, e.LastName

--ex3
Select e.EmployeeID, e.FirstName, e.LastName, d.[Name] as DepartmentName
From Employees AS e 
Join Departments AS d ON d.DepartmentID = e.DepartmentID
Where d.[Name] = 'Sales'
Order By e.EmployeeID, e.LastName

--ex4
Select TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.[Name] as DepartmentName
From Employees AS e 
Join Departments AS d ON d.DepartmentID = e.DepartmentID
Where Salary >15000
Order By d.DepartmentID

--ex5
Select TOP(3) e.EmployeeID, e.FirstName
From Employees AS e
LEFT Join EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
Where ep.EmployeeID IS NULL
Order By e.EmployeeID

--ex6
Select e.FirstName, e.LastName, e.HireDate, d.[Name] as DeptName
From Employees AS e 
Join Departments AS d ON d.DepartmentID = e.DepartmentID
Where e.HireDate > '1.1.1999' and  d.[Name] in ('Sales', 'Finance' )
Order By HireDate

--ex7
Select TOP(5) e.EmployeeID, e.FirstName, p.[Name]
From Employees AS e 
Join EmployeesProjects AS ep ON ep.EmployeeID =e.EmployeeID
Join Projects AS p ON ep.ProjectID = p.ProjectID
Where p.StartDate > '08.13.2002' and p.EndDate IS NULL
Order By e.EmployeeID

--ex8
Select e.EmployeeID, e.FirstName, 
Case
When  DATEPART(YEAR,p.StartDate) <2005 Then p.[Name] 
Else Null
End 
As [ProjectName]
From Employees AS e 
Join EmployeesProjects AS ep ON ep.EmployeeID =e.EmployeeID
Join Projects AS p ON ep.ProjectID = p.ProjectID
Where  e.EmployeeID=24

--ex9
Select e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName
From Employees AS e 
Join Employees AS m ON m.EmployeeID =e.ManagerID
Where e.ManagerID in (3,7)
Order By e.EmployeeID

--ex10
Select TOP(50) e.EmployeeID, e.FirstName + ' ' + e.LastName AS EmployeeName, m.FirstName  + ' ' + m.LastName AS ManagerName,d.[Name] AS DepartmentName
From Employees AS e 
Join Employees AS m ON m.EmployeeID =e.ManagerID
Join Departments AS d ON d.DepartmentID = e.DepartmentID
Order By e.EmployeeID

--ex11
Select TOP(1) AVG(Salary) AS MinAverageSalary
From Employees AS e
Join Departments AS d ON d.DepartmentID = e.DepartmentID
Group By e.DepartmentID
Order By MinAverageSalary

use Geography
--ex12
Select c.CountryCode, m.MountainRange, p.PeakName,p.Elevation
From Countries AS c
Join MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
Join Mountains AS m ON m.Id = mc.MountainId
Join Peaks AS p ON p.MountainId = m.Id
Where c.CountryCode = 'BG' And p.Elevation > 2835
Order By p.Elevation Desc

--ex13
Select c.CountryCode, COUNT(m.MountainRange) 
From Countries AS c
Join MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
Join Mountains AS m ON m.Id = mc.MountainId
Where c.CountryCode IN ('US','RU','BG')
Group By c.CountryCode

--ex14
Select TOP(5) c.CountryName, r.RiverName
From Countries AS c
LEFT Join CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT Join Rivers AS r ON r.Id = cr.RiverId
Where ContinentCode = 'AF'
Order By c.CountryName

--ex15
Select ContinentCode, CurrencyCode,CurrencyUsage
From
(Select  ContinentCode,CurrencyCode,Count(CurrencyCode) AS CurrencyUsage, DENSE_RANK() Over(Partition By ContinentCode Order By Count(CurrencyCode)Desc) As Ranked
From Countries
Group By ContinentCode,CurrencyCode) AS cu
Where Ranked =1 And CurrencyUsage > 1
Order By ContinentCode

--ex16
Select Count(c.CountryCode) AS Count
From Countries AS c
Left Join  MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
Where mc.MountainId IS NULL

--ex17
Select Top(5) c.CountryName, MAX(p.Elevation) AS HighestPeakElevation, MAX(r.[Length]) AS LongestRiverLength
From Countries AS c
LEFT Join CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT Join Rivers AS r ON r.Id = cr.RiverId
LEFT Join MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT Join Mountains AS m ON m.Id = mc.MountainId
LEFT Join Peaks AS p On p.MountainId= m.Id
Group By c.CountryName
Order By HighestPeakElevation Desc,  LongestRiverLength DESC, c.CountryName

--ex18
Select Top(5) Country, [Highest Peak Name],[Highest Peak Elevation],[Mountain]
From
(Select c.CountryName AS Country, 
ISNULL(p.PeakName, '(no highest peak)') as [Highest Peak Name],
ISNULL(m.MountainRange,'(no mountain)') as [Mountain],
ISNULL(MAX(p.Elevation),0) AS [Highest Peak Elevation], 
DENSE_RANK() Over (Partition By c.CountryName Order By MAX(p.Elevation) Desc) AS Ranked
From Countries AS c
LEFT Join MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT Join Mountains AS m ON m.Id = mc.MountainId
LEFT Join Peaks AS p On p.MountainId= m.Id
Group By c.CountryName,p.PeakName,m.MountainRange) AS c
Where Ranked= 1
Order By Country,[Highest Peak Name]
