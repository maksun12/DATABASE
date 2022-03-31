--ex1
Create Table Countries (Id INT PRIMARY KEY, Name VARCHAR(50))

Create Table Towns (Id INT PRIMARY KEY, Name VARCHAR(50), CountryCode INT FOREIGN KEY REFERENCES Countries(Id))

Create Table Minions (Id INT PRIMARY KEY, Name VARCHAR(50), Age INT, TownId INT FOREIGN KEY REFERENCES Towns(Id))

Create Table EvilnessFactors (Id INT PRIMARY KEY, Name VARCHAR(50))

Create Table Villains (Id INT PRIMARY KEY, Name VARCHAR(50), EvilnessFactorId INT FOREIGN KEY REFERENCES EvilnessFactors(Id))

Create Table MinionsVillains (MinionId INT FOREIGN KEY REFERENCES Minions(Id), VillainId INT FOREIGN KEY REFERENCES Villains(Id) CONSTRAINT PK_MinionsVillains Primary Key(MinionId,VillainId))


Insert INTO Countries Values (1, 'Bulgaria'), (2, 'Norway'), (3, 'Cyprus'), (4,'Greece'), (5,'UK')
Insert INTO Towns (Id,Name,CountryCode) Values (1,'Plovdiv',1), (2,'Oslo',2) , (3,'Larnaca',3), (4,'Athens',4), (5,'London',5)
Insert INTO Minions Values (1,'Stoyan', 12, 1), (2,'George',22,2), (3,'Ivan',25,3), (4,'Kiro',35,4), (5,'Niki',25,5)
Insert INTO EvilnessFactors Values (1,'super good'),(2,'good'),(3,'bad'),(4,'evil'),(5,'super evil')
Insert INTO Villains Values (1,'Gru',1),(2,'Ivo',2),(3,'Teo',3),(4,'Sto',4),(5,'Pro',5)
Insert INTO MinionsVillains Values (1,1),(2,2),(3,3),(4,4),(5,5)

--ex2
Select Name,Count(mv.MinionId)
From Villains v
Join MinionsVillains mv ON mv.VillainId=v.Id
Group By v.Id, v.Name
Having Count(mv.MinionId)>3