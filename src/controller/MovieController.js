const { json } = require("body-parser");
const connection = require("../config/database");


const getDBMovie = {
    NowPlaying: async () => {
        try {
            const pool = await connection;
            const request = pool.request();
            const query = 
            `SELECT 
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

    ComingSoon: async () => {
        try {
            const pool = await connection;
            const request = pool.request();
            const query = 
            `SELECT 
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
            request.input('Movie_Id', data.Movie_Id)
            const result = await request.query(query);
            return result.recordset;
        } catch (error) {
            console.error(error);
            throw error;
        }
    },
    movieInfo : async (data) => {
        try {
            const pool = await connection;
            const request = pool.request();
            console.log(data);
            const query = 
            `SELECT 
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
            WHERE M.Movie_Id = @Movie_Id `;
            request.input('Movie_Id', data)
            const result = await request.query(query);
            return result.recordset;
        } catch (error) {
            
        }
    }
};

module.exports = getDBMovie;
