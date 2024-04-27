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
set @Const = 1
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

            Select * from Invoice

            SELECT * from Account