--Create DATABASE TripService
--use TripService

--ex1
Create Table Cities 
(
Id INT NOT NULL Primary Key Identity,
[Name] NVARCHAR(20) Not Null,
CountryCode CHAR(2)  Not Null
)

Create Table Hotels  
(
Id INT NOT NULL  Primary Key Identity,
[Name] NVARCHAR(30) Not Null,
CityId INT FOREIGN KEY REFERENCES Cities(Id) Not Null,
EmployeeCount INT NOT NULL,
BaseRate DECIMAL(18,2)
)

Create Table Rooms 
(
Id INT NOT NULL  Primary Key Identity,
Price DECIMAL(18,2) NOT NULL,
[Type] NVARCHAR(20)  NOT NULL,
Beds INT NOT NULL,
HotelId INT FOREIGN KEY REFERENCES Hotels(Id) Not Null
)
Create Table Trips 
(
Id INT NOT NULL Primary Key Identity,
RoomId INT FOREIGN KEY REFERENCES Rooms(Id) Not Null,
ArrivalDate DATE NOT NULL,
BookDate Date Not Null ,
ReturnDate DATE NOT NULL,
CancelDate DATE,
Check(BookDate<ArrivalDate),
Check(ArrivalDate<ReturnDate)
)
Create Table Accounts  
(
Id INT NOT NULL Primary Key Identity,
FirstName  NVARCHAR(50)  NOT NULL,
MiddleName  NVARCHAR(20),
LastName  NVARCHAR(50)  NOT NULL,
CityId INT FOREIGN KEY REFERENCES Cities(Id) Not Null,
BirthDate DATE NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE
)
Create Table AccountsTrips  
(
AccountId INT FOREIGN KEY REFERENCES Accounts(Id) Not Null,
TripId INT FOREIGN KEY REFERENCES Trips(Id) Not Null,
Luggage INT NOT NULL,
Constraint PK_AccountsTrips primary Key (AccountId,TripId),
Check(Luggage>=0)
)

--ex2
Insert Into Accounts(FirstName,MiddleName,LastName,CityId,BirthDate,Email) Values
('John','Smith','Smith',34,'1975-07-21','j_smith@gmail.com'),
('Gosho',NULL,'Petrov',	11,'1978-05-16','g_petrov@gmail.com'),
('Ivan','Petrovich','Pavlov',59,'1849-09-26','i_pavlov@softuni.bg'),
('Friedrich','Wilhelm',	'Nietzsche',2,'1844-10-15','f_nietzsche@softuni.bg')

Insert Into Trips(RoomId,BookDate,ArrivalDate,ReturnDate,CancelDate) Values
(101,	'2015-04-12','2015-04-14','2015-04-20',	'2015-02-02'),
(102,	'2015-07-07','2015-07-15','2015-07-22',	'2015-04-29'),
(103,	'2013-07-17','2013-07-23','2013-07-24',	NULL ),
(104,	'2012-03-17','2012-03-31','2012-04-01',	'2012-01-10'),
(109,	'2017-08-07','2017-08-28','2017-08-29',	NULL)

--ex3
Update  Rooms
Set  Price = Price*1.14
Where  HotelId IN (5,7,9)

--ex4
Delete From AccountsTrips
Where AccountId=47

--ex5
Select FirstName,LastName,Format(BirthDate,'MM-dd-yyyy'),c.Name [Hometown],Email
From Accounts as a
Join Cities AS c ON c.Id=a.CityId
Where Email Like 'e%'
Order By c.Name

--ex6
Select c.Name as City,Count(h.Id)
From Cities c
Join Hotels h On c.Id = h.CityId
Group By c.Name
Order By Count(h.Id) desc,c.Name

--ex7
SELECT
    a.Id AS AccountId, 
    a.FirstName + ' ' + a.LastName AS [FullName],
    MAX(DATEDIFF(day, T.ArrivalDate, T.ReturnDate)) AS LongestTrip,
    MIN(DATEDIFF(day, T.ArrivalDate, T.ReturnDate)) AS ShortestTrip  
FROM 
    Accounts a
JOIN 
    AccountsTrips at ON a.Id = AT.AccountId
JOIN 
    Trips t ON T.Id = AT.TripId
WHERE 
    a.MiddleName IS NULL AND t.CancelDate IS NULL
GROUP BY
    a.Id, a.FirstName, a.LastName
ORDER BY 
    LongestTrip DESC, ShortestTrip ASC

--ex8 
Select Top(10) c.Id,c.Name as City,c.CountryCode AS Country,Count(*) as Accounts
From Accounts a
Join Cities c On a.CityId=c.Id
Group By c.id, c.Name,c.CountryCode
Order By Accounts desc

--ex9
Select a.Id,a.Email,c.Name,COUNT(*) as Trips
From AccountsTrips at
Join Accounts a ON at.AccountId = a.Id
Join Cities c On a.CityId = c.Id
Join Trips t On t.Id=at.TripId
Join Rooms r On t.RoomId=r.Id
Join Hotels h ON r.HotelId = h.Id
Join Cities hc ON h.CityId=hc.Id
Where h.CityId = a.CityId
Group By a.Id,a.Email,c.Name
Order By Trips desc,a.Id

--ex10
Select t.Id, a.FirstName +' '+ ISnull(MiddleName +' ','') + a.LastName as [Full Name],c.Name as [From],hc.Name as [To], 
Case 
When CancelDate IS Null Then CONVERT(NVARCHAR,DATEDIFF(day, t.ArrivalDate, t.ReturnDate)) + ' ' +'days'
Else 'Canceled' 
END
AS Duration
From AccountsTrips at
Join Accounts a ON at.AccountId = a.Id
Join Cities c On a.CityId = c.Id
Join Trips t On t.Id=at.TripId
Join Rooms r On t.RoomId=r.Id
Join Hotels h ON r.HotelId = h.Id
Join Cities hc ON h.CityId=hc.Id
Order By [Full Name],t.Id