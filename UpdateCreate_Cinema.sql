-- CREATE DATABASE UpdateCrossPlatformProject
-- USE UpdateCrossPlatformProject
-- drop DATABASE UpdateCrossPlatformProject

------------------------------------ Table -----------------------------------
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
    Role_Id BIT DEFAULT 0,
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


Create TABLE MyTicket(
    Invoice_Id INT ,
    Movie_Name Nvarchar(200),
    Duration INT,
    CategoryList Nvarchar(500),
    Poster Varchar(200),
    StartTime DateTime,
    InvoiceDate Datetime,
    Room_Id Varchar(3), 
    Seat_Id Varchar(100),
    Price Money, 
    PhoneNumber Char(10)
    PRIMARY KEY (Invoice_Id)
)

--------------------------------Trigger--------------------------------
CREATE TRIGGER UpdatePriceInInvoice 
ON Ticket
FOR INSERT 
AS
BEGIN 
    DECLARE @InvoiceId INT;
    SELECT @InvoiceId = Invoice_Id FROM inserted;
    
    UPDATE Invoice
    SET TotalAmount = (
        SELECT SUM(Cost)
        FROM Ticket
        WHERE Invoice_Id = @InvoiceId        
        group by Invoice_Id
    )
    WHERE Invoice_Id = @InvoiceId;
END;


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
    (Movie_Id, Movie_Name, Duration, Censorship, Language,Release, Expiration, Description, Poster)
VALUES
    ('MV001', N'The Shawshank Redemption', 142,  13, N'English','2024/04/21','2024/04/28' ,N'A story of hope and friendship in a prison setting.', 'https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_.jpg'),
    ('MV002', N'Spirited Away', 125, 0, N'Japanese','2024/04/21','2024/04/28', N'A coming-of-age story about a girl in the spirit world.', 'https://kenh14cdn.com/203336854389633024/2021/11/13/mv5bmjlmzmi5mdctnde2ys00ywe0lwe5zwitzdbhywq0ntcxnwrhxkeyxkfqcgdeqxvymtmxodk2otuv1-1636778149864183874398.jpg'),
    ('MV003', N'The Dark Knight', 152, 16, N'English','2024/04/21','2024/04/28', N'A superhero movie exploring themes of good and evil.', 'https://upload.wikimedia.org/wikipedia/vi/2/2d/Poster_phim_K%E1%BB%B5_s%C4%A9_b%C3%B3ng_%C4%91%C3%AAm_2008.jpg'),
    ('MV004', N'The Lord of the Rings: The Fellowship of the Ring', 178, 13, N'English','2024/04/21','2024/04/28', N'An epic fantasy adventure about a hobbit and his friends on a quest to destroy the One Ring.', 'https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg'),
    ('MV005', N'The Godfather', 175, 18, N'English','2024/04/21','2024/04/28', N'A classic gangster film about the Corleone family.', 'https://play-lh.googleusercontent.com/ZucjGxDqQ-cHIN-8YA1HgZx7dFhXkfnz73SrdRPmOOHEax08sngqZMR_jMKq0sZuv5P7-T2Z2aHJ1uGQiys'),
    ('MV006', N'The Dark Knight Rises', 165, 16, N'English','2024/04/21','2024/04/28', N'The final installment in Christopher Nolans Batman trilogy.', 'https://upload.wikimedia.org/wikipedia/vi/8/83/Dark_knight_rises_poster.jpg'),
    ('MV007', N'Inception', 148, 13, N'English','2024/04/21','2024/04/28', N'A science fiction thriller about a team of thieves who steal corporate secrets by entering people dreams.', 'https://iguov8nhvyobj.vcdn.cloud/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/i/n/inception.jpg'),
    ('MV008', N'The Matrix', 136, 16, N'English','2024/04/21','2024/04/28', N'A science fiction action film about a computer hacker who learns that the world he lives in is actually a computer simulation.', 'https://play-lh.googleusercontent.com/zL8ya3uEa7Q-oDqc7McTIAaRvwKZNN4HMICMwHHL2eKsbE9Hms_2Dj6SWwNGI555CyauvPVjCPUzYBm2TJ8'),
    ('MV009', N'Interstellar', 169, 13, N'English','2024/04/21','2024/04/28', N'A science fiction adventure film about a team of astronauts who travel through a wormhole in search of a new home for humanity.', 'https://upload.wikimedia.org/wikipedia/vi/4/46/Interstellar_poster.jpg'),
    ('MV010', N'The Shawshank Redemption', 142, 13, N'English','2024/04/21','2024/04/28', N'A story of hope and friendship in a prison setting.', 'https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_.jpg'),
    ('MV011', N'The Godfather: Part II', 200, 18, N'English','2024/04/21','2024/04/28', N'The sequel to The Godfather, following the Corleone family in the 1950s.', 'https://m.media-amazon.com/images/M/MV5BMWMwMGQzZTItY2JlNC00OWZiLWIyMDctNDk2ZDQ2YjRjMWQ0XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg'),
    ('MV012', N'The Dark Knight', 152, 16, N'English','2024/04/21','2024/04/28', N'A superhero movie exploring themes of good and evil.', 'https://www.galaxycine.vn/media/2022/11/28/hdmmdc-02-a19_1669618098652.jpg'),
    ('MV013', N'Pulp Fiction', 154, 18, N'English','2024/04/21','2024/04/28', N'A neo-noir crime film with a highly stylized and nonlinear plot.', 'https://m.media-amazon.com/images/S/pv-target-images/dbb9aff6fc5fcd726e2c19c07f165d40aa7716d1dee8974aae8a0dad9128d392.jpg'),
    ('MV014', N'The Lord of the Rings: The Two Towers', 179, 13, N'English','2024/04/21','2024/04/28', N'The second installment in The Lord of the Rings trilogy.', 'https://play-lh.googleusercontent.com/lf33Su-WHqbOmwMxikmTzJk69A1Kny0Z2KseCQiWM6jDOVLnJF9Iy6kpqGEWjch1DMOCHrU97BTmxl7bDybr');
    

INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0001', N'Đào, Phở và Piano', 100, 15, 'Vietnamese','2024/04/01','2024/05/28', N'Bộ phim kể về trận chiến đông xuân kéo dài 60 ngày đêm tại thủ đô Hà Nội, và dõi theo cuộc sống của chàng dân quân mang tên Văn Dân và mối tình đầy mê hoặc với cô tiểu thư đam mê đàn dương cầm tên Thục Hương. Trong những trận đánh cuối trước lúc quân ta chuẩn bị rút lui khỏi thủ đô để chuẩn bị cho cuộc kháng chiến lâu dài, một số người quyết định ở lại trong mảnh đất đã tan hoang này vì bom đạn, không màng đến những nguy hiểm đang chờ đợi phía trước. Họ, dù có tên hay không, cùng nhau viết nên câu chuyện đầy bi kịch nhưng cũng không kém phần lãng mạn về tinh thần của Hà Nội trong ngày Tết và khói lửa của chiến tranh. Một người lính đã rất dũng cảm vượt qua bom đạn để mang về một nhánh hoa xuân nhằm mang niềm vui Tết cùng đồng đội. Anh ta cũng có một lễ cưới đầy tính cảm với cô tiểu thư xinh đẹp giữa bối cảnh Hà Nội vỡ nát. Trong đám cưới có một người họa sĩ già, người ở lại để nhớ về những người đã anh dũng hy sinh, cùng một vị linh mục với mong muốn sự yên ổn và không chiến tranh, họ cùng nhau thưởng thức một bát phở, trò chuyện và uống rượu để chào đón một ngày mới, ngày của sự hy sinh.', 'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRc7TGWYAV3m63jS5t78TFJ-k6zvYEuELmmlgtX_pXHT3_hyi-x')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0002', N'Godzilla x Kong: The New Emprise', 115, 13, 'English','2024/04/21','2024/06/01', N'Kong và Godzilla - hai sinh vật vĩ đại huyền thoại, hai kẻ thủ truyền kiếp sẽ cùng bắt tay thực thi một sứ mệnh chung mang tính sống còn để bảo vệ nhân loại, và trận chiến gắn kết chúng với loài người mãi mãi sẽ bắt đầu.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvB00vPWjxpIVSH3AegshsjFkOHs9tF6rN42MIbDQHX_k3Mmca')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0003', N'Avengers: Infinity War', 165, 15, 'English','2024/04/21','2024/04/28', N'Mô tả chi tiết phim Biệt đội báo thù', 'https://upload.wikimedia.org/wikipedia/vi/e/e8/Avengers-Infinity_War-Official-Poster.jpg')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0004', N'Batman VS Superman', 110, 15, 'English','2024/04/21','2024/04/28', N'Mô tả chi tiết phim Người dơi với siêu anh hùng', 'https://thanhnien.mediacdn.vn/uploaded/ngocthanh/2016_04_03/doi2_UYXJ.jpg?width=500')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0005', N'Thiên long bát bộ', 130, 15, 'Tailwand','2024/04/21','2024/04/28', N'Mô tả chi tiết phim Thiên long bát bộ', 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1630546779i/22470055.jpg')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0006', N'Blue Wolf', 85, 11, 'Korean','2024/04/21','2024/04/28', N'Mô tả chi tiết phim Sói xanh', 'https://ih1.redbubble.net/image.1189606581.2997/flat,750x,075,f-pad,750x1000,f8f8f8.jpg')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0007', N'Toy Stories 4', 125, 15, 'English','2024/04/01','2024/06/01', N'Mô tả chi tiết phim Câu chuyện đồ chơi 4', 'https://thanhnien.mediacdn.vn/Uploaded/vananh/2019_06_22/mv5bmtyzmdm4nzkxov5bml5banbnxkftztgwnzm1mzg2nzm40_v1__QCYQ.jpg?width=500')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0008', N'Doraemon & Dog Cat Empriror', 125, 15, 'Japanese','2024/04/21','2024/04/28', N'Mô tả chi tiết phim Doraemon ở Vương quốc chó mèo', 'https://upload.wikimedia.org/wikipedia/vi/a/ad/N%C3%B4bita_%E1%BB%9F_v%C6%B0%C6%A1ng_qu%E1%BB%91c_ch%C3%B3_m%C3%A8o.jpg')

-- Test
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0009', N'Date a live', 125, 15, 'Japanese','2024/04/28','2024/05/01', N'Mô tả chi tiết phim Date a live', 'https://static.wikia.nocookie.net/date-a-live/images/0/01/Tohka_Normal.png/revision/latest?cb=20200410032241&path-prefix=vi')
INSERT INTO Movie
    (Movie_Id, Movie_Name,Duration,Censorship,Language ,Release, Expiration, Description, Poster)
VALUES
    ('MV0010', N'Bí mật nơi góc tối', 125, 15, 'Chinese','2024/04/28','2024/05/15', N'Mô tả chi tiết phim Bí mật nơi góc tối', 'https://i.imgur.com/olixDew.jpg')


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

INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0009', 'Type11'),
    ('MV0009', 'Type03'),
    ('MV0009', 'Type04')    
  
    
INSERT INTO Movie_Category
    (Movie_Id, Category_Id)
VALUES
    ('MV0010', 'Type11'),
    ('MV0010', 'Type03')    
        



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
    ('A1', 1, 1, 'R01'),
    ('A2', 1, 2, 'R01'),
    ('A3', 1, 3, 'R01'),
    ('A4', 1, 4, 'R01'),
    ('A5', 1, 5, 'R01'),
    ('A6', 1, 6, 'R01'),
    ('B1', 2, 1, 'R01'),
    ('B2', 2, 2, 'R01'),
    ('B3', 2, 3, 'R01'),
    ('B4', 2, 4, 'R01'),
    ('B5', 2, 5, 'R01'),
    ('B6', 2, 6, 'R01'),
    ('C1', 3, 1, 'R01'),
    ('C2', 3, 2, 'R01'),
    ('C3', 3, 3, 'R01'),
    ('C4', 3, 4, 'R01'),
    ('C5', 3, 5, 'R01'),
    ('C6', 3, 6, 'R01'),
    ('D1', 4, 1, 'R01'),
    ('D2', 4, 2, 'R01'),
    ('D3', 4, 3, 'R01'),
    ('D4', 4, 4, 'R01'),
    ('D5', 4, 5, 'R01'),
    ('D6', 4, 6, 'R01');

-- Data in Room 2
INSERT INTO Seat
    (Seat_Id, row, col, Room_Id)
VALUES
    ('A1', 1, 1, 'R02'),
    ('A2', 1, 2, 'R02'),
    ('A3', 1, 3, 'R02'),
    ('A4', 1, 4, 'R02'),
    ('A5', 1, 5, 'R02'),
    ('A6', 1, 6, 'R02'),
    ('B1', 2, 1, 'R02'),
    ('B2', 2, 2, 'R02'),
    ('B3', 2, 3, 'R02'),
    ('B4', 2, 4, 'R02'),
    ('B5', 2, 5, 'R02'),
    ('B6', 2, 6, 'R02'),
    ('C1', 3, 1, 'R02'),
    ('C2', 3, 2, 'R02'),
    ('C3', 3, 3, 'R02'),
    ('C4', 3, 4, 'R02'),
    ('C5', 3, 5, 'R02'),
    ('C6', 3, 6, 'R02'),
    ('D1', 4, 1, 'R02'),
    ('D2', 4, 2, 'R02'),
    ('D3', 4, 3, 'R02'),
    ('D4', 4, 4, 'R02'),
    ('D5', 4, 5, 'R02'),
    ('D6', 4, 6, 'R02');

-- Data in Room 3
INSERT INTO Seat
    (Seat_Id, row, col, Room_Id)
VALUES
    ('A1', 1, 1, 'R03'),
    ('A2', 1, 2, 'R03'),
    ('A3', 1, 3, 'R03'),
    ('A4', 1, 4, 'R03'),
    ('A5', 1, 5, 'R03'),
    ('A6', 1, 6, 'R03'),
    ('B1', 2, 1, 'R03'),
    ('B2', 2, 2, 'R03'),
    ('B3', 2, 3, 'R03'),
    ('B4', 2, 4, 'R03'),
    ('B5', 2, 5, 'R03'),
    ('B6', 2, 6, 'R03'),
    ('C1', 3, 1, 'R03'),
    ('C2', 3, 2, 'R03'),
    ('C3', 3, 3, 'R03'),
    ('C4', 3, 4, 'R03'),
    ('C5', 3, 5, 'R03'),
    ('C6', 3, 6, 'R03'),
    ('D1', 4, 1, 'R03'),
    ('D2', 4, 2, 'R03'),
    ('D3', 4, 3, 'R03'),
    ('D4', 4, 4, 'R03'),
    ('D5', 4, 5, 'R03'),
    ('D6', 4, 6, 'R03');

-- Data in Room 4
INSERT INTO Seat
    (Seat_Id, row, col, Room_Id)
VALUES
    ('A1', 1, 1, 'R04'),
    ('A2', 1, 2, 'R04'),
    ('A3', 1, 3, 'R04'),
    ('A4', 1, 4, 'R04'),
    ('A5', 1, 5, 'R04'),
    ('A6', 1, 6, 'R04'),
    ('B1', 2, 1, 'R04'),
    ('B2', 2, 2, 'R04'),
    ('B3', 2, 3, 'R04'),
    ('B4', 2, 4, 'R04'),
    ('B5', 2, 5, 'R04'),
    ('B6', 2, 6, 'R04'),
    ('C1', 3, 1, 'R04'),
    ('C2', 3, 2, 'R04'),
    ('C3', 3, 3, 'R04'),
    ('C4', 3, 4, 'R04'),
    ('C5', 3, 5, 'R04'),
    ('C6', 3, 6, 'R04'),
    ('D1', 4, 1, 'R04'),
    ('D2', 4, 2, 'R04'),
    ('D3', 4, 3, 'R04'),
    ('D4', 4, 4, 'R04'),
    ('D5', 4, 5, 'R04'),
    ('D6', 4, 6, 'R04');




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
INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/05/01 07:00', 'MV0007', 'R04', N'2D', 0)
INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/05/01 12:00', 'MV0001', 'R02', N'3D', 10000)
INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/05/01 17:00', 'MV0007', 'R02', N'2D', 0)
INSERT INTO MovieShow
    (StartTime, Movie_Id, Room_Id, TypeShow, Surcharge)
VALUES
    ('2024/05/02 08:00', 'MV0002', 'R02', N'2D', 0)

INSERT INTO Invoice
    (InvoiceDate, PhoneNumber)
VALUES
    ('2024/04/16', '0372273819')
INSERT INTO Invoice
    (InvoiceDate, PhoneNumber)
VALUES
    ('2024/04/15', '0988321861')
INSERT INTO Invoice
    (InvoiceDate, PhoneNumber)
VALUES
    ('2024/04/18', '0999999999')
INSERT INTO Invoice
    (InvoiceDate, PhoneNumber)
VALUES
    ('2024/04/17', '0999999999')
INSERT INTO Invoice
    (InvoiceDate, PhoneNumber)
VALUES
    ('2024/04/14', '0988321861')
INSERT INTO Invoice
    (InvoiceDate, PhoneNumber)
VALUES
    ('2024/04/13', '0372273819')
INSERT INTO Invoice
    (InvoiceDate, PhoneNumber)
VALUES
    ('2024/04/13', '0988321861')
