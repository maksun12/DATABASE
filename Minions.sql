CREATE DATABASE Minions --��������� �� ��.

USE Minions --���������� �� ��.

CREATE TABLE Minions --��������� �� �������.
(
Id INT PRIMARY KEY,
[Name] varchar(30),
Age INT
)

CREATE TABLE Towns --��������� �� �������.
(
Id INT PRIMARY KEY,
[Name] varchar(30)
)

ALTER TABLE Minions --������� �� ������a
ADD TownId INT --�������� �� ������

ALTER TABLE Minions --������� �� ������
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id) --������ ����� ��� ������.

--Ctrl + Shift + R - ���������� �� ���.


INSERT INTO Towns (Id, Name) VALUES -- �������� �� ���������� � �������.
(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna')

INSERT INTO Minions (Id, Name, Age,TownId) VALUES
(1,'Kevin',22,1),
(2,'Bob',15,3),
(3,'Steward',NULL,2)

SELECT * FROM Minions

DELETE FROM Minions -- ��������� �� ����� �� �������.

DROP TABLE Minions -- ��������� �� �������.
DROP TABLE Towns

CREATE TABLE Users --��������� �� �������.
(
Id BIGINT PRIMARY KEY IDENTITY,
Username VARCHAR(30) NOT NULL,
[Password] VARCHAR(26) NOT NULL,
ProfilePicture VARCHAR(MAX),
LastLoginTime DATETIME,
IsDeleted BIT
)

INSERT INTO Users  (Username, [Password], ProfilePicture,LastLoginTime,IsDeleted) VALUES
('asd','asd255','https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_160x56dp.png', '1/12/2021',0),
('sss','asd3332','https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_160x56dp.png', '2/13/2021',1),
('asddd','asd123122','https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_160x56dp.png', '3/14/2021',0),
('asasdasdd','as23d2','https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_160x56dp.png', '4/15/2021',0),
('asasdasdssd','as23d2','https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_160x56dp.png', '4/15/2021',0)

ALTER TABLE Users
DROP CONSTRAINT PK_IdUsername --��������� �� ����

ALTER TABLE Users 
ADD PRIMARY KEY (Id, Username) --��������� ���� � ������ ���

ALTER TABLE Users 
ADD CONSTRAINT PK_IdUsername PRIMARY KEY (Id, Username) --��������� ���� � ��������� ���

ALTER TABLE Users
ADD CONSTRAINT CH_PasswordIsAtLeast5Symbols Check (LEN([Password]) > 5) --�������� �� �������

ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime --��������� �� default ��������

SELECT * From Users


