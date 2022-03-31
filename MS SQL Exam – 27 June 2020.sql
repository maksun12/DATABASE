--Create Database WMS

--use WMS

--ex1
Create Table Clients
(
ClientId INT Primary Key Identity  ,
FirstName Varchar(50) Not Null,
LastName Varchar(50) Not Null,
Phone Char(12) Check(Len(Phone)=12) Not Null
)

Create Table Mechanics
(
MechanicId INT Primary Key Identity,
FirstName Varchar(50) Not Null,
LastName Varchar(50) Not Null,
[Address] Varchar(255) Not Null
)

Create Table Models
(
ModelId INT Primary Key Identity,
[Name] Varchar(50) Unique Not Null,
)

Create Table Jobs
(
JobId INT Primary Key Identity,
ModelId INT FOREIGN KEY REFERENCES Models(ModelId) Not Null,
[Status] Varchar(11) Not Null Default 'Pending' Check(Status in ('Pending','In Progress','Finished')),
ClientId INT FOREIGN KEY REFERENCES Clients(ClientId)  Not Null,
MechanicId INT FOREIGN KEY REFERENCES Mechanics(MechanicId),
IssueDate Date Not Null,
FinishDate Date
)


Create Table Orders
(
OrderId INT Primary Key Identity,
JobId INT FOREIGN KEY REFERENCES Jobs(JobId) Not Null,
IssueDate Date,
Delivered BIT Default 0
)

Create Table Vendors
(
VendorId INT Primary Key Identity,
[Name] Varchar(50) Unique Not Null,
)

Create Table Parts
(
PartId INT Primary Key Identity,
SerialNumber  Varchar(50) Unique Not Null,
[Description] Varchar(255),
Price Decimal(15,2) Check(Price > 0 And Price < 9999.99) Not Null,
VendorId INT FOREIGN KEY REFERENCES Vendors(VendorId) Not Null,
StockQty INT Default 0 Check(StockQty >=0)
)

Create Table OrderParts
(
OrderId INT FOREIGN KEY REFERENCES Orders(OrderId) Not Null,
PartId INT FOREIGN KEY REFERENCES Parts(PartId) Not Null,
Quantity INT Default 1 Check(Quantity > 0) Not Null

Constraint PK_OrdersParts primary Key (OrderId,PartId)
)

Create Table PartsNeeded
(
JobId INT FOREIGN KEY REFERENCES Jobs(JobId) Not Null,
PartId INT FOREIGN KEY REFERENCES Parts(PartId) Not Null,
Quantity INT Default 1 Check(Quantity > 0) Not Null

Constraint PK_JobssParts primary Key (JobId,PartId)
)

--ex2
Insert Into Clients(FirstName,LastName,Phone) Values
('Teri', 'Ennaco','570-889-5187'),
('Merlyn', 'Lawler','201-588-7810'),
('Georgene', 'Montezuma','925-615-5185'),
('Jettie', 'Mconnell','908-802-3564'),
('Lemuel', 'Latzke','631-748-6479'),
('Melodie', 'Knipp','805-690-1682'),
('Candida', 'Corbley','908-275-8357')

Insert Into Parts(SerialNumber,Description,Price,VendorId) Values
('WP8182119','Door Boot Seal',117.86,2),
('W10780048','Suspension Rod',42.81,1),
('W10841140','Silicone Adhesive',6.77,4),
('WPY055980','High Temperature Adhesive',13.94,3)

--ex3
Update  Jobs
Set MechanicId =3, [Status] = 'In Progress'
Where  Status = 'Pending'

--ex4
Delete From OrderParts Where OrderId = 19
Delete From Orders Where OrderId = 19

--ex5
Select m.FirstName + ' ' + m.LastName as [Full Name], j.Status,j.IssueDate 
From Mechanics as m
Join Jobs as j on m.MechanicId = j.MechanicId
Order by m.MechanicId, IssueDate, jobId 

--ex6
Select c.FirstName + ' ' + c.LastName as [Client], DATEDIFF(day,IssueDate,'2017-04-24') as [Days going],j.Status
From Clients as c
Join Jobs as j on c.ClientId = j.ClientId
Where [Status] != 'Finished'
Order by [Days going] desc, c.ClientId

--ex7
Select m.FirstName + ' ' + m.LastName as [Mechanic], AVG(DATEDIFF(day,IssueDate,FinishDate)) as [Average Days]
From Mechanics as m 
Join Jobs as j on m.MechanicId = j.MechanicId
Group By j.MechanicId,  (m.FirstName + ' ' + m.LastName)
Order by j.MechanicId

--ex8
Select m.FirstName + ' ' + m.LastName as [Mechanic]
From Mechanics as m 
Left Join Jobs as j on m.MechanicId = j.MechanicId
Where j.JobId is null or (Select COUNT(JobId) From Jobs 
Where Status <> 'Finished' And MechanicId = m.MechanicId Group By MechanicId,Status) Is Null 
Group By m.MechanicId,  (m.FirstName + ' ' + m.LastName)
Order By m.MechanicId

--ex 9
Select j.JobId, ISNULL(Sum(p.Price * op.Quantity),0) as [Total]
From Jobs as j
LEFT Join Orders as o on j.JobId =o.JobId
LEFT Join OrderParts as op On o.OrderId = op.OrderId
LEFT Join Parts as p on op.PartId = p.PartId
Where Status = 'Finished'
Group By j.JobId
Order By [Total] desc, j.JobId

--ex10
Select p.PartId,
p.Description,
pn.Quantity AS [Required],
p.StockQty AS [In Stock],
IIF(o.Delivered=0, op.Quantity,0) as [Ordered]
From Parts as p
LEFT Join PartsNeeded as pn ON p.PartId=pn.PartId
LEFT Join OrderParts AS op ON op.PartId =p.PartId
LEFT Join Jobs as j ON pn.JobId =j.JobId
Left Join Orders AS o On o.JobId =j.JobId
Where j.Status != 'Finished' And p.StockQty+IIF(o.Delivered=0, op.Quantity,0) < pn.Quantity
Order By PartId

--ex11
Create PROC usp_PlaceOrder
(
@JobId Int,
@serialNumber Varchar(50),
@qty Int
)
AS
Declare @status varchar(10) = (Select Status From Jobs Where JobId=@JobId)
Declare @partId varchar(10) = (Select PartId From Parts Where SerialNumber=@serialNumber)

if  (@qty <=0)
  Throw 50012, 'Part quantity must be more than zero!',1
Else if (@serialNumber is Null)
  Throw 50013, 'Job not found!',1
Else If (@status='Finished')
  Throw 50011, 'This job is not active!',1
Else If (@partId Is Null)
  Throw 50014,'Part not found!',1

Declare @orderId Int = (Select o.OrderId 
                        From Orders as o
						Where JobId=@JobId and o.IssueDate is Null)

If(@orderId is Null)
Begin
  Insert Into Orders(JobId,IssueDate) Values
(@JobId,Null)
End

  Set @orderId=(Select OrderId 
  From Orders 
  Where JobId=@JobId and IssueDate Is null)
  Declare @orderPartExist INT =(Select OrderId From OrderParts Where OrderId =@orderId and PartId=@partId)

  IF(@orderPartExist is null)
  begin
  Insert Into OrderParts(OrderId,PartId,Quantity) Values
(@orderId,@partId,@qty)
End

Else 
Begin
Update OrderParts
     Set Quantity+=@qty
     Where OrderId =@orderId  and PartId = @partId
End

--ex12
Create Function udf_GetCost (@jobId INT)
Returns decimal(15,2)
AS
Begin
Declare @result Decimal(15,2);
Set @result=(Select Sum(p.Price*op.Quantity) as TotalSum
From Jobs AS j
Join Orders AS o ON o.JobId = j.JobId
Join OrderParts AS op ON op.OrderId = o.OrderId
Join Parts AS p ON p.PartId =op.PartId
Where j.JobId = @jobId
Group by j.JobId)
If (@result Is Null)
Set @result=0;

Return @result
End

SELECT dbo.udf_GetCost(1)