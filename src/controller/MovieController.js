const { json } = require('body-parser');
const connection = require('../config/database');

const getDBMovie = {
  NowPlaying: async () => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `SELECT 
            M.Movie_Id, 
            M.Movie_Name, 
            M.Poster, 
            (SELECT STRING_AGG(C.Category_Name, ', ') 
             FROM Movie_Category AS MC 
             INNER JOIN Category AS C ON MC.Category_Id = C.Category_Id 
             WHERE MC.Movie_Id = M.Movie_Id) AS Categories, 
            M.Duration 
            FROM Movie AS M 
            WHERE GETDATE() BETWEEN M.Release AND M.Expiration;`;
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  NowPlayingPage: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `SELECT
        M.Movie_Id,
        M.Movie_Name,
        M.Poster,
        (SELECT STRING_AGG(C.Category_Name, ', ')
         FROM Movie_Category AS MC
         INNER JOIN Category AS C ON MC.Category_Id = C.Category_Id
         WHERE MC.Movie_Id = M.Movie_Id) AS Categories,
        M.Duration
        FROM Movie AS M
        WHERE GETDATE() BETWEEN M.Release AND M.Expiration
        ORDER BY M.Movie_Id 
	      OFFSET (@page-1)*@limit ROWS
	      FETCH NEXT @limit ROWS ONLY;`;
      request.input('limit', parseInt(data.limit));
      request.input('page', parseInt(data.page));
      const result = await request.query(query);

      return result.recordset;
      // console.log(data);
    } catch (error) {}
  },

  ComingSoon: async () => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `SELECT 
            M.Movie_Id, 
            M.Movie_Name, 
            M.Poster, 
            (SELECT STRING_AGG(C.Category_Name, ', ') 
             FROM Movie_Category AS MC 
             INNER JOIN Category AS C ON MC.Category_Id = C.Category_Id 
             WHERE MC.Movie_Id = M.Movie_Id) AS Categories, 
            M.Release 
            FROM Movie AS M 
        WHERE GETDATE() < Release`;
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // xong
  movieScheduleList: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `select a.* , b.StartTime 
            from Movie as a INNER JOIN MovieShow as b 
            ON a.Movie_Id = b.Movie_Id
            Where a.Movie_Id = @Movie_Id and GETDATE() <= Convert(Date,b.StartTime)  `;
      request.input('Movie_Id', data.Movie_Id);
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  movieInfo: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      console.log(data);
      const query = `
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
                  (select CONCAT('[', STRING_AGG(CONCAT('"', p.Person_Name, '"'), ', '), ']') from Person_Movie as PM INNER JOIN Person as P
      on PM.Person_Id = p.Person_Id
      where PM.Movie_Id = @Movie_Id and PM.character = 'Actor') as Actor,
      (select CONCAT('[', STRING_AGG(CONCAT('"', p.Person_Name, '"'), ', '), ']') from Person_Movie as PM INNER JOIN Person as P
      on PM.Person_Id = p.Person_Id
      where PM.Movie_Id = @Movie_Id and PM.character = 'Director') as Director
                  FROM Movie AS M 
                  WHERE M.Movie_Id = @Movie_Id ;`;
      request.input('Movie_Id', data);
      const result = await request.query(query);
      console.log(result);

      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // ------------------------------------------Update------------------------------------------

  // get category
  getCategory: async () => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = 'select * from Category';
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // add movie
  addMovie: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Insert Into Movie
        Values(@Movie_Id, @Movie_Name, @Duration, @Censorship, @Language, @Release, @Expiration, @Description, @Poster)`;
      // for (key in data) {
      //   request.input(key, data[key]);
      // }

      request.input('Movie_Id', data.Movie_Id);
      request.input('Movie_Name', data.Movie_Name);
      request.input('Duration', data.Duration);
      request.input('Censorship', data.Censorship);
      request.input('Language', data.Language);
      request.input('Release', data.Release);
      request.input('Expiration', data.Expiration);
      request.input('Description', data.Description);
      request.input('Poster', data.Poster);
      await request.query(query);

      const query2 = [];
      for (index in data.Category_Id) {
        query2.push(`Insert Into Movie_Category
        Values ('${data.Category_Id[index]}', @Movie_Id)`);
      }
      console.log(query2);
      for (q in query2) {
        await request.query(query2[q]);
      }
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // sửa thông tin phim (Khi sửa thì sẽ điền giá trị và nhập thêm Thể loại)
  putMovie: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();

      const query1 = `Update Movie
      set Movie_Name = @Movie_Name, Duration= @Duration, 
      Censorship = @Censorship, Language= @Language, 
      Release= @Release, Expiration=  @Expiration, 
      Description= @Description, Poster= @Poster
      Where Movie_Id = @Movie_Id`;
      // for (key in data) {
      //   request.input(key, data[key]);
      // }
      request.input('Movie_Id', data.Movie_Id);

      request.input('Movie_Name', data.Movie_Name);
      request.input('Duration', data.Duration);
      request.input('Censorship', data.Censorship);
      request.input('Language', data.Language);
      request.input('Release', data.Release);
      request.input('Expiration', data.Expiration);
      request.input('Description', data.Description);
      request.input('Poster', data.Poster);

      await request.query(query1);
      const query2 = `Delete From Movie_Category
      Where Movie_Id = @Movie_Id`;

      await request.query(query2);
      const query3 = [];

      for (index in data.Category_Id) {
        query3.push(`Insert Into Movie_Category
        Values('${data.Category_Id[index]}', @Movie_Id)`);
      }
      console.log(query3);
      for (const q of query3) {
        console.log(q);

        await request.query(q);
      }
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // addMovieShow
  addMovieShow: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();

      for (let i = 0; i < data.length; i++) {
        const item = data[i];

        for (const key in item) {
          if (Object.hasOwnProperty.call(item, key)) {
            const value = item[key];
            request.input(`${key}_${i}`, value);
          }
        }

        const query = `
          INSERT INTO Movieshow 
          VALUES (@StartTime_${i}, @Movie_Id_${i}, @Room_Id_${i}, @TypeShow_${i}, 0)
        `;

        await request.query(query);
      }

      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // add category
  addCategory: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Insert Into Category
      Values(@Category_Id, @Category_Name)`;
      request.input('Category_Id', data.Category_Id);
      request.input('Category_Name', data.Category_Name);
      const result = await request.query(query);
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // Edit Category
  editCategory: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `
      Update Category
      set Category_Name = @Category_Name
      Where Category_Id = @Category_Id
      `;
      request.input('Category_Id', data.Category_Id),
        request.input('Category_Name', data.Category_Name);
      const result = await request.query(query);
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // delete category
  deleteCategory: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `
    Delete from Movie_Category
    where Category_Id = @Category_Id
    Delete from Category
    Where Category_Id = @Category
    `;
      const result = request.query(query);
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  searchMovie: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `
      Select * from Movie
      Where Movie_Name like '%${data}%'
      `;
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
};

module.exports = getDBMovie;
