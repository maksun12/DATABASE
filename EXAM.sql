Create Database Bitbucket
use Bitbucket

--ex1
Create Table Users
(
Id INT NOT NULL Primary Key Identity,
Username VARCHAR(30) NOT NULL,
[Password] VARCHAR(30) NOT NULL,
Email VARCHAR(30) NOT NULL

)

Create Table Repositories 
(
Id INT NOT NULL Primary Key Identity,
[Name] VARCHAR(50) NOT NULL,
)

Create Table RepositoriesContributors 
(
RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) Not Null,
ContributorId INT FOREIGN KEY REFERENCES Users(Id) Not Null

Constraint PK_RepositoriesContributosr primary Key (RepositoryId,ContributorId)
)

Create Table Issues 
(
Id INT NOT NULL Primary Key Identity,
Title VARCHAR(255) NOT NULL,
IssueStatus char(6) NOT NULL,
RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) Not Null,
AssigneeId INT FOREIGN KEY REFERENCES Users(Id) Not Null
)

Create Table Commits 
(
Id INT NOT NULL Primary Key Identity,
[Message] VARCHAR(255) NOT NULL,
IssueId INT FOREIGN KEY REFERENCES Issues(Id),
RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) Not Null,
ContributorId INT FOREIGN KEY REFERENCES Users(Id) Not Null
)

Create Table Files 
(
Id INT NOT NULL Primary Key Identity,
[Name] VARCHAR(100) NOT NULL,
Size Decimal(18,2) NOT NULL,
ParentId INT FOREIGN KEY REFERENCES Files(Id),
CommitId INT FOREIGN KEY REFERENCES Commits(Id) Not Null
)

--ex2
Insert INTO Files(Name,Size,ParentId,CommitId) Values
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy',	1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json',	14034.87, 3, 6),
('Operate.xix',	7662.92, 7, 7)

Insert INTO Issues(Title,IssueStatus,RepositoryId,AssigneeId) Values
('Critical Problem with HomeController.cs file', 'open', 1,	4),
('Typo fix in Judge.html', 'open',	4,	3),
('Implement documentation for UsersService.cs',	'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)


--ex3
Update  Issues
Set IssueStatus = 'closed'
Where AssigneeId= 6

--ex4
Delete From Issues Where RepositoryId=3
Delete From RepositoriesContributors Where RepositoryId=3

--ex5
Select Id,Message,RepositoryId,ContributorId
From Commits
Order By Id,Message,RepositoryId,ContributorId

--ex6
Select Id,Name,Size
From Files
Where Size>1000 And Name Like '%html%'
Order By Size desc,Id,Name

--ex7
Select i.Id,Username +' : '+Title
From Users u
Join Issues i ON u.Id=i.AssigneeId
Order By i.Id desc,i.AssigneeId

--ex8
SELECT f1.Id, f1.[Name], CONCAT(f1.Size, 'KB') AS [Size] FROM Files AS f1
LEFT JOIN Files AS f2 ON f1.Id = f2.ParentId
WHERE f2.Id IS NULL
ORDER BY f1.Id, f1.[Name], f1.Size DESC

--ex9
Select Top(5) r.Id,r.Name, COUNT(*) as Commits
From Repositories r
Join RepositoriesContributors rp ON rp.RepositoryId=r.Id
Left Join Commits c ON c.RepositoryId=rp.RepositoryId
Group By r.Id, r.Name
Order By Commits Desc,r.Id,r.Name
--ex10
Select u.Username,AVG(Size) as Size
From Users u
Join Commits c ON c.ContributorId = u.Id
Join Files f On f.CommitId=c.Id
Group By u.Username
Order By Size desc,u.Username

--ex11
Go
Create Function udf_AllUserCommits (@username Varchar(30)) 
Returns INT
Begin
  Declare @result Int
  SET @result = (Select Count(*) as Count
From Users u
Join Commits c ON c.ContributorId=u.Id
Where @username=u.Username
Group By u.Id)
If (@result Is Null)
Set @result=0;  

Return @result;
End
--ex12
Go
Create PROC usp_SearchForFiles (@fileExtension VARCHAR(100))
AS
Select Id,Name,CAST(Size AS varchar(30)) + 'KB' as Size
From Files
Where Name Like '%' + @fileExtension 
Order By Id,Name,Size desc

EXEC usp_SearchForFiles 'txt'

Select Id,Name,CAST(Size AS varchar(30)) + 'KB'
From Files
Where Name Like '%txt' 
Order By Id,Name,Size desc

Select Substring(Name,CHARINDEX('.', Name) + 1, LEN(Name)) as 'EmailProvider'
From Files
Where Name Like '%.%'