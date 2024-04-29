create Table TestIdenity(
    Id INT IDENTITY,
    Name varchar(10),
    PRIMARY KEY(Id)
)
insert into TestIdenity
VALUES
('2')



BEGIN TRANSACTION Booking1;

insert into TestIdenity
VALUES
('2')

DECLARE @Const Int
set @Const = SELECT SCOPE_IDENTITY() as Cop
IF @Const = 1 
BEGIN
    ROLLBACK TRANSACTION Booking1;
    PRINT 'Rollback thành công';
END
ELSE
BEGIN
    COMMIT TRANSACTION Booking1;
    PRINT 'Commit thành công';
END;
select * from TestIdenity

set @Const = 2







SELECT 
            M.Movie_Id, 
            M.Movie_Name, 
            M.Poster, 
            (SELECT STRING_AGG(C.Category_Name, ', ') 
             FROM Movie_Category AS MC 
             INNER JOIN Category AS C ON MC.Category_Id = C.Category_Id 
             WHERE MC.Movie_Id = M.Movie_Id) AS Categories, 
            M.Duration,
            Language,
            Censorship, 
            Release, 
            Description,
            Person_Name, 
            character,
            image
            FROM Movie AS M 
            inner join Person_Movie as PM on M.Movie_Id = PM.Movie_Id 
            inner join Person as P on PM.Person_Id = p.Person_Id
            WHERE M.Movie_Id = 'MV0001' 

            Select * from MyTicket

            SELECT * from Invoice

            select * From MovieShow
            select getDate() from Invoice

-- 1) Báo cáo doanh số bán hàng theo khoảng thời gian
    -- 1.1) Bán theo được số ghế
    SELECT *,
    (SELECT COUNT(*) FROM STRING_SPLIT(Seat_Id, ',')) AS NumberOfSeats
    FROM MyTicket
    Where CONVERT(date, InvoiceDate) BETWEEN '2024/04/30' and '2024/06/01'

select *
from MyTicket

Insert Into MyTicket 
Values
(1,'Date a Live', 120, 'Action, Romance', '2024-04-30 17:00:00.000', '2024-04-29 18:00:00.000', 'R01', 'A01, A02', 100000.00, '1'),
(2,'Date a Live', 120, 'Action, Romance', '2024-04-30 17:00:00.000', '2024-04-29 18:00:00.000', 'R01', 'A01, A02', 50000.00, '1'),
(3,'Bí mật nơi góc tối', 120, 'Action, Romance', '2024-05-30 17:00:00.000', '2024-04-29 18:00:00.000', 'R01', 'A01, A02', 50000.00, '1'),
(4,'Bí mật nơi góc tối', 120, 'Action, Romance', '2024-06-30 17:00:00.000', '2024-04-29 18:00:00.000', 'R01', 'A01, A02', 100000.00, '1'),
(5,'Bí mật nơi góc tối', 120, 'Action, Romance', '2024-06-30 17:00:00.000', '2024-6-01 18:00:00.000', 'R01', 'A01, A02', 100000.00, '1');