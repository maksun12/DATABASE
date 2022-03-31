use Gringotts

--ex1
Select Count(*) AS [Count]
From WizzardDeposits

--ex2
Select Max(MagicWandSize) AS LongestMagicWand
From WizzardDeposits

--ex3
Select  DepositGroup,Max(MagicWandSize)
From WizzardDeposits
Group By DepositGroup

--ex4
Select Top(2) DepositGroup
From WizzardDeposits
Group by DepositGroup
order by AVG(MagicWandSize) 

--ex5
Select DepositGroup,Sum(DepositAmount) as TotalSum
From WizzardDeposits
Group by DepositGroup

--ex6
Select DepositGroup,Sum(DepositAmount) as TotalSum
From WizzardDeposits 
Where MagicWandCreator = 'Ollivander family' 
Group by DepositGroup
Having Sum(DepositAmount) < 150000
Order by TotalSum desc

--ex7
Select DepositGroup,Sum(DepositAmount) as TotalSum
From WizzardDeposits 
Where MagicWandCreator = 'Ollivander family' 
Group by DepositGroup
Having Sum(DepositAmount) < 150000
Order by TotalSum desc

--ex8
Select DepositGroup,MagicWandCreator,Min(DepositCharge) as MinDepositCharge
From WizzardDeposits
Group By DepositGroup, MagicWandCreator
Order by MagicWandCreator, DepositGroup

--ex9
Select res.AgeGruop, COUNT(res.AgeGruop) as WizardCount
From
(Select 
Case
When Age Between 0 And 10 Then '[0-10]'
When Age Between 11 And 20 Then '[11-20]'
When Age Between 21 And 30 Then '[21-30]'
When Age Between 31 And 40 Then '[31-40]'
When Age Between 41 And 50 Then '[41-50]'
When Age Between 51 And 60 Then '[51-60]'
When Age >=61 Then '[61+]'
End
AS [AgeGruop]
From WizzardDeposits) 
As res
Group By res.AgeGruop

--ex10
Select LEFT(FirstName,1) as FirstLetter
From WizzardDeposits
Where DepositGroup='Troll Chest'
Group By LEFT(FirstName,1)

--ex11
Select DepositGroup,IsDepositExpired, AVG(DepositInterest)
From WizzardDeposits
Where DepositStartDate >'01/01/1985'
Group By DepositGroup, IsDepositExpired
Order By DepositGroup desc, IsDepositExpired

--ex12
Select 
Sum(Guest.DepositAmount-Host.DepositAmount) AS [Difference]
From WizzardDeposits As Host
Join WizzardDeposits As Guest On Host.Id = Guest.Id +1

--ex12 with lead
Select  Sum(res.[Difference]) 
From
(Select Host.DepositAmount - Lead(Host.DepositAmount, 1) Over(Order By Host.Id) as [Difference]
From WizzardDeposits As Host) as res


use SoftUni
--ex13 
Select DepartmentID, Sum(Salary) AS TotalSalary
From Employees
Group By DepartmentID 
Order By DepartmentID

--ex14
Select DepartmentID, MIN(Salary) as MinimumSalary
From Employees
Where DepartmentID IN (2,5,7) And HireDate >'01/01/2000'
Group By DepartmentID 
Order By DepartmentID

--ex15
Select * INTO MyNewTable
From Employees
Where Salary >30000

Delete From MyNewTable
Where ManagerID=42

Update MyNewTable 
Set Salary +=5000
Where DepartmentID=1

Select DepartmentID,Avg(Salary) as AverageSalary 
From MyNewTable
Group By DepartmentID

--ex16
Select DepartmentID, MAX(Salary) AS MaxSalary
From Employees
Group By DepartmentID
Having MAX(Salary) Not Between 30000 and 70000

--ex17
Select Count(Salary) as Count
From Employees
Where ManagerID is Null

--ex18
Select Distinct res.DepartmentID,res.Salary
From
(SELECT DepartmentID, Salary,DENSE_RANK() Over(Partition By DepartmentID Order By Salary Desc) As Ranked  
     FROM Employees ) as res
Where Ranked = 3

--ex19
Select Top(10) FirstName, LastName, DepartmentID
From Employees as e
Where Salary > (Select AVG(Salary) From Employees Where DepartmentID = e.DepartmentID Group By DepartmentID)
Order By DepartmentID
