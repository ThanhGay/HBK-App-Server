-- CREATE DATABASE UpdateCrossPlatformProject
-- USE UpdateCrossPlatformProject
-- drop DATABASE UpdateCrossPlatformProject
------------------------------------ Table ------------------------------------

-- Select rows from a Table or Account' in schema '[dbo]'

-- select * from Account
-- from Invoice 
-- INNER Join Ticket on Invoice.Invoice_Id = Ticket.Invoice_Id 
-- INNER JOIN MovieShow on Ticket.StartTime =  MovieShow.StartTime 
-- INNER JOIN Movie ON MovieShow.Movie_Id = Movie.Movie_Id
-- INNER JOIN Ticket_Seat ON Ticket.Ticket_Id = Ticket_Seat.Ticket_Id
-- where Invoice.PhoneNumber = 0372273819

-- select * from  MovieShow

-- danh sách lịch chiếu theo phim
-- select a.* , CONVERT(date,StartTime) as ShowDate, CONVERT(Time, StartTime) as ShowTime from   Movie as a INNER JOIN MovieShow as b ON a.Movie_Id = b.Movie_Id
-- select * from movieShow
-- select date('2024-04-16 07:00:00.000')

-- select * from Ticket_Seat 

-- select * from Invoice as a INNER JOIN (select Invoice_Id, count(Invoice_Id) * 50 as money from ticket group by (Invoice_Id) ) as b On a.Invoice_Id = b.invoice_Id
-- select a.* , 
--       CONVERT(date,StartTime) as ShowDate, 
--       CONVERT(Time, StartTime) as ShowTime 
--       from Movie as a INNER JOIN MovieShow as b 
--       ON a.Movie_Id = b.Movie_Id
-- select * from MovieShow INNER JOIN Ticket_Seat
-- today + 3 < ngày khởi chiếu, lịch kết thúc 
-- ngày hiện tại < 
-- startTime , 





-------------------------------------------------

CREATE TABLE Category
(
    Category_Id varchar(6),
    Category_Name nvarchar(30),
    PRIMARY Key (Category_Id)
);



-- Create Table Movie    --- xong
CREATE TABLE Movie
(
    Movie_Id varchar(6),
    Movie_Name nvarchar(200),
    Duration int,
    Censorship tinyint,
    Language nvarchar(30),
    Release Date,
    Expiration Date,
    Description nvarchar(3000),
    Poster varchar(200),
    -- link drive image
    PRIMARY Key(Movie_Id),
);



-- Create Table Movie_Category   --- xong
Create Table Movie_Category
(
    Category_Id varchar(6),
    Movie_Id varchar(6),
    PRIMARY KEY (Category_Id, Movie_Id),
    FOREIGN KEY (Category_Id) REFERENCES Category(Category_Id),
    FOREIGN KEY (Movie_Id) REFERENCES Movie(Movie_Id)
);



-- Create Table Room  --- xong
Create Table Room
(
    Room_Id varchar(3),
    Room_Name nvarchar(30),
    PRIMARY KEY (Room_Id)
);



-- Create Table Seat  --- xong
Create Table Seat
(
    Seat_Id varchar(3),
    row tinyint,
    col tinyint,
    Room_Id varchar(3),
    PRIMARY KEY (Seat_Id, Room_Id),
    FOREIGN KEY (Room_Id) REFERENCES Room(Room_Id),
);



-- Create Table MovieShow   --- xong
Create Table MovieShow
(
    StartTime dateTime,
    Movie_Id varchar(6),
    Room_Id varchar(3),
    TypeShow varchar(2),
    Surcharge money,
    PRIMARY KEY (StartTime),
    FOREIGN KEY (Movie_Id) REFERENCES Movie(Movie_Id),
    FOREIGN KEY (Room_Id) REFERENCES Room(Room_Id),
);



Create Table Person
(
    Person_Id varchar(7),
    Person_Name nvarchar(200),
    image varchar(500),
    PRIMARY KEY (Person_Id),
);



Create Table Person_Movie
(
    Person_Id varchar(7),
    character nvarchar(15),
    Movie_Id varchar(6),
    PRIMARY KEY (Movie_Id, Person_Id),
    FOREIGN KEY (Person_Id) REFERENCES Person(Person_Id),
    FOREIGN KEY (Movie_Id) REFERENCES Movie(Movie_Id),
);



-- Create Table ProductGroups
Create Table ProductGroups
(
    ProductGroups_Id varchar(6),
    ProductGroups_Name nvarchar(30),
    PRIMARY KEY (ProductGroups_Id)
);



-- Create Table Product
Create Table Product
(
    Product_Id varchar(6),
    Product_Name nvarchar(30),
    Size varchar(6),
    Price money,
    ProductGroups_Id varchar(6),
    PRIMARY KEY (Product_Id),
    FOREIGN KEY (ProductGroups_Id) REFERENCES ProductGroups(ProductGroups_Id)
);



-- Create Table Account
Create Table Account
(
    PhoneNumber char(10) unique,
    PassWord varchar(30),
    FullName nvarchar(30),
    Email varchar(200),
    Gender nvarchar(6),
    DateOfBirth date,
    Point int,
    CardClass varchar(8),
    PRIMARY KEY (PhoneNumber)
);



-- Create Table Invoice
Create Table Invoice
(
    Invoice_Id Int IDENTITY(1,1),
    InvoiceDate datetime,
    TotalAmount money,
    PhoneNumber char(10),
    PRIMARY KEY (Invoice_Id),
    FOREIGN KEY (PhoneNumber) REFERENCES Account(PhoneNumber)
);



-- Create Table Product_Invoice
Create Table Product_Invoice
(
    Product_Id varchar(6),
    Invoice_Id INT,
    Quantity int,
    PRIMARY KEY (Product_Id, Invoice_Id),
    FOREIGN KEY (Product_Id) REFERENCES Product(Product_Id),
    FOREIGN KEY (Invoice_Id) REFERENCES Invoice(Invoice_Id)
);



-- Create Table Ticket
Create Table Ticket
(
    Ticket_Id Int IDENTITY(1,1),
    Cost money ,
    Invoice_Id int,
    StartTime datetime,
    Seat_Id varchar(3),
    Room_Id varchar(3),
    PRIMARY KEY (Ticket_Id),
    FOREIGN KEY (Invoice_Id) REFERENCES Invoice(Invoice_Id),
    FOREIGN KEY (StartTime) REFERENCES MovieShow(StartTime),
    FOREIGN KEY (Seat_Id, Room_Id) REFERENCES Seat(Seat_Id, Room_Id),

);





------------------------------------ Data ------------------------------------
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('ACT001', N'Action'),
    ('ANM002', N'Animation'),
    ('COM003', N'Comedy'),
    ('CRM004', N'Crime'),
    ('DOC005', N'Documentary'),
    ('ACT006', N'Adventure'),
    ('BIO007', N'Biography'),
    ('DRA008', N'Drama'),
    ('FAM009', N'Family'),
    ('FAN010', N'Fantasy'),
    ('HIS011', N'History'),
    ('HOR012', N'Horror'),
    ('MUS013', N'Musical'),
    ('MYST01', N'Mystery'),
    ('ROM015', N'Romance'),
    ('SCI016', N'Sci-Fi'),
    ('SHO017', N'Short Film'),
    ('THR018', N'Thriller'),
    ('WAR019', N'War'),
    ('WES020', N'Western');

INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type01', 'Action')
-- Hành động
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type02', 'Adventure')
-- Phiêu lưu
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type03', 'Comedy')
-- Hài hước
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type04', 'Cartoon')
-- Hoạt hình
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type05', 'Crime & Gangster')
-- Hình sự
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type06', 'Drama')
-- Tâm lý
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type07', 'Historical')
-- Chiến tranh / lịch sử
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type08', 'Horror')
-- Kinh dị
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type09', 'Musicals')
-- Âm nhạc
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type10', 'Sci-fi')
-- Khoa học viễn tưởng
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type11', 'Romance')
-- Tình cảm, lãng mạn
INSERT INTO Category
    (Category_Id, Category_Name)
VALUES
    ('Type12', 'Tragegy')
-- Bi kịch


INSERT INTO Movie
    (Movie_Id, Movie_Name, Duration, Price, Censorship, Language,Release, Expiration, Description, Poster)
VALUES
    ('MV001', N'The Shawshank Redemption', 142, 100000, 13, N'English','2024/04/21','2024/04/28' ,N'A story of hope and friendship in a prison setting.', 'https://.../shawshank.jpg'),
    ('MV002', N'Spirited Away', 125, 80000, 0, N'Japanese','2024/04/21','2024/04/28', N'A coming-of-age story about a girl in the spirit world.', 'https://.../spiritedaway.jpg'),
    ('MV003', N'The Dark Knight', 152, 120000, 16, N'English','2024/04/21','2024/04/28', N'A superhero movie exploring themes of good and evil.', 'https://.../darknight.jpg'),
    ('MV004', N'The Lord of the Rings: The Fellowship of the Ring', 178, 150000, 13, N'English','2024/04/21','2024/04/28', N'An epic fantasy adventure about a hobbit and his friends on a quest to destroy the One Ring.', 'https://.../lotr1.jpg'),
    ('MV005', N'The Godfather', 175, 120000, 18, N'English','2024/04/21','2024/04/28', N'A classic gangster film about the Corleone family.', 'https://.../godfather.jpg'),
    ('MV006', N'The Dark Knight Rises', 165, 130000, 16, N'English','2024/04/21','2024/04/28', N'The final installment in Christopher Nolans Batman trilogy.', 'https://.../darkknightrises.jpg'),
    ('MV007', N'Inception', 148, 110000, 13, N'English','2024/04/21','2024/04/28', N'A science fiction thriller about a team of thieves who steal corporate secrets by entering people dreams.', 'https://.../inception.jpg'),
    ('MV008', N'The Matrix', 136, 100000, 16, N'English','2024/04/21','2024/04/28', N'A science fiction action film about a computer hacker who learns that the world he lives in is actually a computer simulation.', 'https://.../matrix.jpg'),
    ('MV009', N'Interstellar', 169, 140000, 13, N'English','2024/04/21','2024/04/28', N'A science fiction adventure film about a team of astronauts who travel through a wormhole in search of a new home for humanity.', 'https://.../interstellar.jpg'),
    ('MV010', N'The Shawshank Redemption', 142, 100000, 13, N'English','2024/04/21','2024/04/28', N'A story of hope and friendship in a prison setting.', 'https://.../shawshank.jpg'),
    ('MV011', N'The Godfather: Part II', 200, 120000, 18, N'English','2024/04/21','2024/04/28', N'The sequel to The Godfather, following the Corleone family in the 1950s.', 'https://.../godfather2.jpg'),
    ('MV012', N'The Dark Knight', 152, 120000, 16, N'English','2024/04/21','2024/04/28', N'A superhero movie exploring themes of good and evil.', 'https://.../darknight.jpg'),
    ('MV013', N'Pulp Fiction', 154, 100000, 18, N'English','2024/04/21','2024/04/28', N'A neo-noir crime film with a highly stylized and nonlinear plot.', 'https://.../pulpfiction.jpg'),
    ('MV014', N'The Lord of the Rings: The Two Towers', 179, 150000, 13, N'English','2024/04/21','2024/04/28', N'The second installment in The Lord of the Rings trilogy.', 'https://.../lotr2.jpg');
    

INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0001', N'Đào, Phở và Piano', 100, 15, 'Vietnamese','2024/04/21','2024/04/28', 45000, N'Bộ phim kể về trận chiến đông xuân kéo dài 60 ngày đêm tại thủ đô Hà Nội, và dõi theo cuộc sống của chàng dân quân mang tên Văn Dân và mối tình đầy mê hoặc với cô tiểu thư đam mê đàn dương cầm tên Thục Hương. Trong những trận đánh cuối trước lúc quân ta chuẩn bị rút lui khỏi thủ đô để chuẩn bị cho cuộc kháng chiến lâu dài, một số người quyết định ở lại trong mảnh đất đã tan hoang này vì bom đạn, không màng đến những nguy hiểm đang chờ đợi phía trước. Họ, dù có tên hay không, cùng nhau viết nên câu chuyện đầy bi kịch nhưng cũng không kém phần lãng mạn về tinh thần của Hà Nội trong ngày Tết và khói lửa của chiến tranh. Một người lính đã rất dũng cảm vượt qua bom đạn để mang về một nhánh hoa xuân nhằm mang niềm vui Tết cùng đồng đội. Anh ta cũng có một lễ cưới đầy tính cảm với cô tiểu thư xinh đẹp giữa bối cảnh Hà Nội vỡ nát. Trong đám cưới có một người họa sĩ già, người ở lại để nhớ về những người đã anh dũng hy sinh, cùng một vị linh mục với mong muốn sự yên ổn và không chiến tranh, họ cùng nhau thưởng thức một bát phở, trò chuyện và uống rượu để chào đón một ngày mới, ngày của sự hy sinh.', 'https://drive.google.com/file/d/1HVV6SGUENAWyowPeKIiO6UiKSCriqMQd/view?usp=sharing')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0002', N'Godzilla x Kong: The New Emprise', 115, 13, 'English','2024/04/21','2024/04/28', 45000, N'Kong và Godzilla - hai sinh vật vĩ đại huyền thoại, hai kẻ thủ truyền kiếp sẽ cùng bắt tay thực thi một sứ mệnh chung mang tính sống còn để bảo vệ nhân loại, và trận chiến gắn kết chúng với loài người mãi mãi sẽ bắt đầu.', 'https://drive.google.com/file/d/1AiGX5nUZ-GYAu5VaKeOuIcjUkpS2E0lf/view?usp=sharing')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0003', N'Avengers: Infinity War', 165, 15, 'English','2024/04/21','2024/04/28', 55000, N'Mô tả chi tiết phim Biệt đội báo thù', 'chua co')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0004', N'Batman VS Superman', 110, 15, 'English','2024/04/21','2024/04/28', 55000, N'Mô tả chi tiết phim Người dơi với siêu anh hùng', 'chua co')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0005', N'Thiên long bát bộ', 130, 15, 'Tailwand','2024/04/21','2024/04/28', 55000, N'Mô tả chi tiết phim Thiên long bát bộ', 'chua co')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0006', N'Blue Wolf', 85, 11, 'Korean','2024/04/21','2024/04/28', 45000, N'Mô tả chi tiết phim Sói xanh', 'chua co')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0007', N'Toy Stories 4', 125, 15, 'English','2024/04/21','2024/04/28', 35000, N'Mô tả chi tiết phim Câu chuyện đồ chơi 4', 'chua co')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0008', N'Doraemon & Dog Cat Empriror', 125, 15, 'Japanese','2024/04/21','2024/04/28', 40000, N'Mô tả chi tiết phim Doraemon ở Vương quốc chó mèo', 'chua co')

-- Test
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0009', N'Date a live', 125, 15, 'Japanese','2024/04/28','2024/05/01', 40000, N'Mô tả chi tiết phim Date a live', 'chua co')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration,  Price, Description, Poster)
VALUES
    ('MV0010', N'Bí mật nơi góc tối', 125, 15, 'Chinese','2024/04/28','2024/05/15', 40000, N'Mô tả chi tiết phim Bí mật nơi góc tối', 'chua co')


INSERT INTO Movie_Category
    (Category_Id, Movie_Id)
VALUES
    ('ACT001', 'MV004'),
    ('ACT001', 'MV006'),
    ('ACT006', 'MV009'),
    ('ANM002', 'MV005'),
    ('COM003', 'MV013'),
    ('DRA008', 'MV005'),
    ('DRA008', 'MV011'),
    ('FAM009', 'MV010'),
    ('FAN010', 'MV004'),
    ('FAN010', 'MV007'),
    ('HIS011', 'MV005'),
    ('HOR012', 'MV014'),
    ('MUS013', 'MV008'),
    ('MYST01', 'MV007'),
    ('ROM015', 'MV010'),
    ('SCI016', 'MV007'),
    ('SCI016', 'MV008'),
    ('SCI016', 'MV009'),
    ('SHO017', 'MV012'),
    ('THR018', 'MV006'),
    ('WAR019', 'MV005'),
    ('WES020', 'MV010');


INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0001', 'CRM004')
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0001', 'HIS011')
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0002', 'ACT001')
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0003', 'ACT001')
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0004', 'ROM015')
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0005', 'WES020')
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0006', 'ROM015')
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0007', 'THR018')
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0008', 'ACT001')



INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char001', N'Phi Tiến Sơn', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char002', N'Cao Thị Thùy Linh', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char003', N'Trần Lực', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char004', N'Trung Hiếu', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char005', N'Doãn Quốc Đam', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char006', N'Tuấn Hưng', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char007', N'Nguyệt Hằng', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char008', N'Anh Tuấn', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char009', N'Adam Wingard', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char010', N'Rebecca Hall', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char011', N'Brian Tyree Henry', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char012', N'Kaylee Hottle', NULL)
INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('Char013', N'Alex Ferns', NULL)


INSERT INTO Person
    (Person_Id, Person_Name, image)
VALUES
    ('P001', N'John Doe', 'https://.../johndoe.jpg'),
    ('P002', N'Jane Doe', 'https://.../janedoe.jpg'),
    ('P003', N'Peter Jones', 'https://.../peterjones.jpg'),
    ('P004', N'Mary Smith', 'https://.../marysmith.jpg'),
    ('P005', N'David Williams', 'https://.../davidwilliams.jpg'),
    ('P006', N'Elizabeth Brown', 'https://.../elizabethbrown.jpg'),
    ('P007', N'Michael Johnson', 'https://.../michaeljohnson.jpg'),
    ('P008', N'Sarah Miller', 'https://.../sarahmiller.jpg'),
    ('P009', N'Robert Thompson', 'https://.../robertthompson.jpg'),
    ('P010', N'Helen Davis', 'https://.../helendavis.jpg'),
    ('P011', N'Richard Wilson', 'https://.../richardwilson.jpg'),
    ('P012', N'Linda Taylor', 'https://.../lindataylor.jpg'),
    ('P013', N'Mark Evans', 'https://.../markevans.jpg'),
    ('P014', N'Susan Parker', 'https://.../susanparker.jpg'),
    ('P015', N'Thomas Walker', 'https://.../thomaswalker.jpg'),
    ('P016', N'Margaret Cooper', 'https://.../margaretcooper.jpg'),
    ('P017', N'Stephen Moore', 'https://.../stephenmoore.jpg'),
    ('P018', N'Barbara Lewis', 'https://.../barbaralewis.jpg'),
    ('P019', N'Andrew Miller', 'https://.../andrewmiller.jpg'),
    ('P020', N'Karen Lee', 'https://.../karenlee.jpg');



INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('P001', N'Director', 'MV004'),
    ('P002', N'Actor', 'MV004'),
    ('P003', N'Director', 'MV004'),
    ('P004', N'Actor', 'MV004'),
    ('P005', N'Actor', 'MV004'),
    ('P006', N'Actor', 'MV005'),
    ('P007', N'Actor', 'MV005'),
    ('P008', N'Actor', 'MV005'),
    ('P009', N'Director', 'MV005'),
    ('P010', N'Actor', 'MV005'),
    ('P011', N'Actor', 'MV012'),
    ('P012', N'Actor', 'MV012'),
    ('P013', N'Director', 'MV012'),
    ('P014', N'Actor', 'MV012'),
    ('P015', N'Actor', 'MV012'),
    ('P016', N'Director', 'MV007'),
    ('P017', N'Actor', 'MV007'),
    ('P018', N'Actor', 'MV007'),
    ('P019', N'Director', 'MV007'),
    ('P020', N'Actor', 'MV007');


INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char001', 'Director', 'MV0001')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char002', 'Actor', 'MV0001')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char003', 'Actor', 'MV0001')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char004', 'Actor', 'MV0001')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char005', 'Actor', 'MV0001')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char006', 'Actor', 'MV0001')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char007', 'Actor', 'MV0001')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char008', 'Actor', 'MV0001')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char009', 'Director', 'MV0002')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char010', 'Actor', 'MV0002')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char011', 'Actor', 'MV0002')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char012', 'Actor', 'MV0002')
INSERT INTO Person_Movie
    (Person_Id, character, Movie_Id)
VALUES
    ('Char013', 'Actor', 'MV0002')



INSERT INTO Room
    (Room_Id, Room_Name)
VALUES
    ('R01', N'Room 1')
INSERT INTO Room
    (Room_Id, Room_Name)
VALUES
    ('R02', N'Room 2')
INSERT INTO Room
    (Room_Id, Room_Name)
VALUES
    ('R03', N'Room 3')
INSERT INTO Room
    (Room_Id, Room_Name)
VALUES
    ('R04', N'Room 4')



INSERT INTO Account
    (PhoneNumber, Password, Email, Gender, Fullname, DateOfBirth, Point, CardClass)
VALUES
    ('0372273819', 'ducthanhAa@', 'ducthanh@gmail.com', N'Nam', N'Đức Thành', '2003/04/25', 150, 'Bronze')
INSERT INTO Account
    (PhoneNumber, Password, Email, Gender, Fullname, DateOfBirth, Point, CardClass)
VALUES
    ('0999999999', '123456', 'admin@gmail.com', N'Nam', N'King', '2000/04/25', 15000, 'Emerald')
INSERT INTO Account
    (PhoneNumber, Password, Email, Gender, Fullname, DateOfBirth, Point, CardClass)
VALUES
    ('0372135465', 'ducthinhAa@', 'ducduy@gmail.com', N'Nam', N'Đức Thỉnh', '2003/04/25', 150, 'Bronze')
INSERT INTO Account
    (PhoneNumber, Password, Email, Gender, Fullname, DateOfBirth, Point, CardClass)
VALUES
    ('0981312312', 'QutyetTrinh@', 'trinhquyet@gmail.com', N'Nam', N'Quyết Trịnh', '2003/04/25', 150, 'Bronze')
INSERT INTO Account
    (PhoneNumber, Password, Email, Gender, Fullname, DateOfBirth, Point, CardClass)
VALUES
    ('0988321861', 'dasbclkjd@', 'taixiu@gmail.com', N'Nam', N'Tài xỉu', '2003/04/25', 150, 'Bronze')
INSERT INTO Account
    (PhoneNumber, Password, Email, Gender, Fullname, DateOfBirth, Point, CardClass)
VALUES
    ('0373543125', 'dsdlviasdl@', 'xxxxxx@gmail.com', N'Nữ', N'Đức Trính', '2003/04/25', 150, 'Bronze')


-- Data in Room 1
INSERT INTO Seat
    (Seat_Id, row, col, Room_Id)
VALUES
    ('A01', 1, 1, 'R01'),
    ('A02', 1, 2, 'R01'),
    ('A03', 1, 3, 'R01'),
    ('A04', 1, 4, 'R01'),
    ('A05', 1, 5, 'R01'),
    ('A06', 1, 6, 'R01'),
    ('B01', 2, 1, 'R01'),
    ('B02', 2, 2, 'R01'),
    ('B03', 2, 3, 'R01'),
    ('B04', 2, 4, 'R01'),
    ('B05', 2, 5, 'R01'),
    ('B06', 2, 6, 'R01'),
    ('C01', 3, 1, 'R01'),
    ('C02', 3, 2, 'R01'),
    ('C03', 3, 3, 'R01'),
    ('C04', 3, 4, 'R01'),
    ('C05', 3, 5, 'R01'),
    ('C06', 3, 6, 'R01'),
    ('D01', 4, 1, 'R01'),
    ('D02', 4, 2, 'R01'),
    ('D03', 4, 3, 'R01'),
    ('D04', 4, 4, 'R01'),
    ('D05', 4, 5, 'R01'),
    ('D06', 4, 6, 'R01');

-- Data in Room 2
INSERT INTO Seat
    (Seat_Id, row, col, Room_Id)
VALUES
    ('A01', 1, 1, 'R02'),
    ('A02', 1, 2, 'R02'),
    ('A03', 1, 3, 'R02'),
    ('A04', 1, 4, 'R02'),
    ('A05', 1, 5, 'R02'),
    ('A06', 1, 6, 'R02'),
    ('B01', 2, 1, 'R02'),
    ('B02', 2, 2, 'R02'),
    ('B03', 2, 3, 'R02'),
    ('B04', 2, 4, 'R02'),
    ('B05', 2, 5, 'R02'),
    ('B06', 2, 6, 'R02'),
    ('C01', 3, 1, 'R02'),
    ('C02', 3, 2, 'R02'),
    ('C03', 3, 3, 'R02'),
    ('C04', 3, 4, 'R02'),
    ('C05', 3, 5, 'R02'),
    ('C06', 3, 6, 'R02'),
    ('D01', 4, 1, 'R02'),
    ('D02', 4, 2, 'R02'),
    ('D03', 4, 3, 'R02'),
    ('D04', 4, 4, 'R02'),
    ('D05', 4, 5, 'R02'),
    ('D06', 4, 6, 'R02');

-- Data in Room 3
INSERT INTO Seat
    (Seat_Id, row, col, Room_Id)
VALUES
    ('A01', 1, 1, 'R03'),
    ('A02', 1, 2, 'R03'),
    ('A03', 1, 3, 'R03'),
    ('A04', 1, 4, 'R03'),
    ('A05', 1, 5, 'R03'),
    ('A06', 1, 6, 'R03'),
    ('B01', 2, 1, 'R03'),
    ('B02', 2, 2, 'R03'),
    ('B03', 2, 3, 'R03'),
    ('B04', 2, 4, 'R03'),
    ('B05', 2, 5, 'R03'),
    ('B06', 2, 6, 'R03'),
    ('C01', 3, 1, 'R03'),
    ('C02', 3, 2, 'R03'),
    ('C03', 3, 3, 'R03'),
    ('C04', 3, 4, 'R03'),
    ('C05', 3, 5, 'R03'),
    ('C06', 3, 6, 'R03'),
    ('D01', 4, 1, 'R03'),
    ('D02', 4, 2, 'R03'),
    ('D03', 4, 3, 'R03'),
    ('D04', 4, 4, 'R03'),
    ('D05', 4, 5, 'R03'),
    ('D06', 4, 6, 'R03');

-- Data in Room 4
INSERT INTO Seat
    (Seat_Id, row, col, Room_Id)
VALUES
    ('A01', 1, 1, 'R04'),
    ('A02', 1, 2, 'R04'),
    ('A03', 1, 3, 'R04'),
    ('A04', 1, 4, 'R04'),
    ('A05', 1, 5, 'R04'),
    ('A06', 1, 6, 'R04'),
    ('B01', 2, 1, 'R04'),
    ('B02', 2, 2, 'R04'),
    ('B03', 2, 3, 'R04'),
    ('B04', 2, 4, 'R04'),
    ('B05', 2, 5, 'R04'),
    ('B06', 2, 6, 'R04'),
    ('C01', 3, 1, 'R04'),
    ('C02', 3, 2, 'R04'),
    ('C03', 3, 3, 'R04'),
    ('C04', 3, 4, 'R04'),
    ('C05', 3, 5, 'R04'),
    ('C06', 3, 6, 'R04'),
    ('D01', 4, 1, 'R04'),
    ('D02', 4, 2, 'R04'),
    ('D03', 4, 3, 'R04'),
    ('D04', 4, 4, 'R04'),
    ('D05', 4, 5, 'R04'),
    ('D06', 4, 6, 'R04');




INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/04/16 07:00', 'MV0001', 'R01', N'2D', 0)
INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/04/16 10:00', 'MV0002', 'R02', N'3D', 10000)
INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/04/24 17:00', 'MV0003', 'R04', N'2D', 0)

INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/04/16 17:00', 'MV0004', 'R04', N'2D', 0)
INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/04/25 17:00', 'MV0004', 'R04', N'2D', 0)



INSERT INTO Invoice
    (Invoice_Id, InvoiceDate, TotalAmount, PhoneNumber)
VALUES
    ('HD001', '2024/04/16', 45000, '0372273819')
INSERT INTO Invoice
    (Invoice_Id, InvoiceDate, TotalAmount, PhoneNumber)
VALUES
    ('HD002', '2024/04/15', 55000, '0988321861')
INSERT INTO Invoice
    (Invoice_Id, InvoiceDate, TotalAmount, PhoneNumber)
VALUES
    ('HD003', '2024/04/18', 40000, '0999999999')
INSERT INTO Invoice
    (Invoice_Id, InvoiceDate, TotalAmount, PhoneNumber)
VALUES
    ('HD004', '2024/04/17', 40000, '0999999999')
INSERT INTO Invoice
    (Invoice_Id, InvoiceDate, TotalAmount, PhoneNumber)
VALUES
    ('HD005', '2024/04/14', 45000, '0988321861')
INSERT INTO Invoice
    (Invoice_Id, InvoiceDate, TotalAmount, PhoneNumber)
VALUES
    ('HD006', '2024/04/13', 55000, '0372273819')
INSERT INTO Invoice
    (Invoice_Id, InvoiceDate, TotalAmount, PhoneNumber)
VALUES
    ('HD007', '2024/04/13', 45000, '0988321861')


INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000001', 'HD001', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000002', 'HD001', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000003', 'HD002', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000004', 'HD005', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000005', 'HD007', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000006', 'HD006', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000007', 'HD004', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000008', 'HD006', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000009', 'HD002', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000010', 'HD001', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000011', 'HD001', 45000, '2024/04/16 10:00' )
INSERT INTO Ticket
    (Ticket_Id, Invoice_Id, Cost, StartTime)
VALUES
    ('000012', 'HD001', 45000, '2024/04/16 10:00' )


INSERT INTO Ticket_Seat
    (Ticket_Id, Seat_Id, Room_Id)
VALUES
    ('000001', 'A02', 'R01')
INSERT INTO Ticket_Seat
    (Ticket_Id, Seat_Id, Room_Id)
VALUES
    ('000001', 'A03', 'R01')
INSERT INTO Ticket_Seat
    (Ticket_Id, Seat_Id, Room_Id)
VALUES
    ('000002', 'A02', 'R01')
INSERT INTO Ticket_Seat
    (Ticket_Id, Seat_Id, Room_Id)
VALUES
    ('000003', 'A02', 'R01')
INSERT INTO Ticket_Seat
    (Ticket_Id, Seat_Id, Room_Id)
VALUES
    ('000005', 'A02', 'R01')
INSERT INTO Ticket_Seat
    (Ticket_Id, Seat_Id, Room_Id)
VALUES
    ('000004', 'A02', 'R01')
INSERT INTO Ticket_Seat
    (Ticket_Id, Seat_Id, Room_Id)
VALUES
    ('000012', 'A02', 'R01')
INSERT INTO Ticket_Seat
    (Ticket_Id, Seat_Id, Room_Id)
VALUES
    ('000010', 'A02', 'R01')

