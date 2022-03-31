--CREATE DATABASE Hotel

--USE Hotel

CREATE TABLE Employees
(
Id INT PRIMARY KEY,
FirstName VARCHAR(90) NOT NULL,
LastName VARCHAR(90) NOT NULL,
Title VARCHAR(50) NOT NULL,
Notes VARCHAR(MAX)
)

INSERT INTO Employees (Id,FirstName,LastName,Title,Notes) VALUES
(1, 'Gesho', 'Petkov', 'AEO', NULL),
(2, 'Sasho', 'Petrov', 'BEO', 'random note'),
(3, 'Petko', 'Ivanov', 'CEO', NULL)

CREATE TABLE Customers
(
AccountNumber INT PRIMARY KEY,
FirstName VARCHAR(90) NOT NULL,
LastName VARCHAR(90) NOT NULL,
PhoneNumber CHAR(10) NOT NULL,
EmergencyName VARCHAR(90) NOT NULL,
EmergencyNumber CHAR(10) NOT NULL,
Notes VARCHAR(MAX)
)
 
INSERT INTO Customers VALUES
(120,'Dimitar', 'Kadiev','1234567890', 'Gesho','1234567030',NULL),
(210,'Dimitar', 'Aleksiev','1265567890', 'Petko','5554567030',NULL),
(330,'Ivan', 'Ivanov','1324567890', 'Asq','1266667030','random note')

CREATE TABLE RoomStatus
(
RoomStatus VARCHAR(20) NOT NULL,
Notes VARCHAR(MAX)
)
 
INSERT INTO RoomStatus VALUES
('Cleaning',NULL),
('Free','random note'),
('Not free',NULL)

CREATE TABLE RoomTypes
(
RoomType VARCHAR(20) NOT NULL,
Notes VARCHAR(MAX)
)


INSERT INTO RoomTypes VALUES
('Child', NULL),
('Apartment',NULL),
('One Bedroom','random note')


CREATE TABLE BedTypes
(
BedType VARCHAR(20) NOT NULL,
Notes VARCHAR(MAX)
)
INSERT INTO BedTypes VALUES
('Single',NULL),
('Double','random note'),
('Child', NULL)

CREATE TABLE Rooms
(
RoomNumber INT PRIMARY KEY,
RoomType VARCHAR(20) NOT NULL,
BedType VARCHAR(20) NOT NULL,
Rate INT,
RoomStatus VARCHAR(20) NOT NULL,
Notes VARCHAR(MAX)
)

INSERT INTO Rooms VALUES
(120,'Apartment','Single',10,'Free',NULL),
(210,'One Bedroom','Single',15,'Not Free',NULL),
(330,'Child','Double',5,'Free',NULL)

CREATE TABLE Payments
(
Id INT PRIMARY KEY,
EmployeeId INT NOT NULL,
PaymentDate DATETIME NOT NULL,
AccountNumber INT NOT NULL,
FirstDateOccupied DATETIME NOT NULL,
LastDateOccupied DATETIME NOT NULL,
TotalDays INT NOT NULL,
AmountCharged Decimal(15,2),
TaxRate INT,
TaxAmount INT,
PaymentTotal DECIMAL(15,2),
Notes VARCHAR(MAX)
)

INSERT INTO Payments VALUES
(1,1,GETDATE(),120,'5/5/2012', '5/8/2012', 3 , 480.23, NULL,NULL,43.23,NULL),
(2,1,GETDATE(),120,'1/5/2012', '5/7/2012', 5 , 444.23, NULL,NULL,23.15,NULL),
(3,1,GETDATE(),120,'7/5/2012', '5/6/2012', 7 , 464.23, NULL,NULL,33.53,NULL)

CREATE TABLE Occupancies
(
Id INT PRIMARY KEY,
EmployeeId INT NOT NULL,
DateOccupied DATETIME NOT NULL,
AccountNumber INT NOT NULL,
RoomNumber INT NOT NULL,
RateApplied Int,
PhoneCharge DECIMAL(15,2),
Notes VARCHAR(MAX)
)

INSERT INTO Occupancies VALUES
(1,120,GETDATE(),120,120,0,0,NULL),
(2,210,GETDATE(),120,120,0,0,NULL),
(3,330,GETDATE(),120,120,0,0,NULL)