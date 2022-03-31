CREATE DATABASE TableRelations

USE TableRelations
--EX1
Create Table Passports 
(
PassportID INT PRIMARY KEY IDENTITY(101,1),
PassportNumber CHAR(8)
)

Create Table Persons
(
PersonID INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30),
Salary Decimal(15,2),
PassportID INT UNIQUE FOREIGN KEY REFERENCES Passports(PassportID)
)
 
Insert INTO Passports Values
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons Values
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101)
 
 --EX2

Create Table Manufacturers
(
ManufacturerID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
EstablishedOn DATETIME
)

CREATE TABLE Models
(
ModelID INT PRIMARY KEY IDENTITY(101,1),
Name VARCHAR(50),
ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers Values
('BMW', '07/03/1916'),
('Tesla','01/01/2003'),
('Lada','01/05/1966')

Insert Into Models Values
('X1',1),
('i6',1),
('Model S',2),
('Model X',2),
('Model 3',2),
('Nova',3)

--EX3

CREATE Table Students
(
StudentID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50)
)

CREATE Table Exams
(
ExamID INT PRIMARY KEY IDENTITY(101,1),
Name VARCHAR(50)
)

CREATE Table StudentsExams
(
StudentID INT,
ExamID INT    

CONSTRAINT PK_Students_Exams Primary Key(StudentID,ExamID),
CONSTRAINT FK_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_Exams FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

INSERT INTO Students Values
('Mila'),
('Toni'),
('Ron')

INSERT INTO Exams Values
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

INSERT INTO StudentsExams Values
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103)

--Ex4

Create Table Teachers
(
TeacharID INT PRIMARY KEY IDENTITY(101,1),
Name VARCHAR(50),
ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacharID)
)

INSERT INTO Teachers VALUES
('John',NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)

--Ex5

CREATE TABLE Cities
(
CityID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL
)

Create Table Customers
(
CustomerID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
Birthday DATE,
CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

Create TABLE Orders
(
OrderID INT PRIMARY KEY IDENTITY,
CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes
(
ItemTypeID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL
)

Create TABLE Items
(
ItemID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

Create TABLE OrderItems
(
OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
ItemID INT  FOREIGN KEY REFERENCES Items(ItemID)

Constraint PK_Order_Item Primary Key(OrderID,ItemID)
)

--EX 6

Create DATABASE University
use University

Create TABLE Majors
(
MajorID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL
)

Create TABLE Students
(
StudentID INT PRIMARY KEY IDENTITY,
StudentNumber Char(10) NOT NULL,
StudentName VARCHAR(50) NOT NULL,
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

Create TABLE Payments
(
PaymentID INT PRIMARY KEY IDENTITY,
PaymentDate DATE Not Null,
PaymentAmount Decimal(15,2) Not Null,
StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

Create TABLE Subjects
(
SubjectID INT PRIMARY KEY IDENTITY,
SubjectName VARCHAR(50) NOT NULL
)

Create TABLE Agenda
(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
SubjectID INT  FOREIGN KEY REFERENCES Subjects(SubjectID)

Constraint PK_Student_Subject Primary Key(StudentID,SubjectID)
)
--EX 9
Use Geography

SELECT Mountains.MountainRange, Peaks.PeakName, Peaks.Elevation
FROM Mountains 
Join Peaks ON Peaks.MountainId=Mountains.Id
WHERE Mountains.MountainRange = 'Rila'
ORDER BY Peaks.Elevation DESC