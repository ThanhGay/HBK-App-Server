const { json } = require("body-parser");
const connection = require("../config/database");

const getDBMovie = {
    NowPlaying: async () => {
        try {
            const pool = await connection;
            const request = pool.request();
            const query = `select * from Movie
      where GETDATE() BETWEEN  Release and Expiration`;
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
            const query = `select * from Movie
      where GETDATE() < Release`;
            const result = await request.query(query);
            return result.recordset;
        } catch (error) {
            console.error(error);
            throw error;
        }
    },
    movieScheduleList: async () => {
        try {
            const pool = await connection;
            const request = pool.request();
            const query = `select a.* , 
      CONVERT(date,StartTime) as ShowDate, 
      CONVERT(Time, StartTime) as ShowTime 
      from Movie as a INNER JOIN MovieShow as b 
      ON a.Movie_Id = b.Movie_Id`;
            const result = await request.query(query);
            return result.recordset;
        } catch (error) {
            console.error(error);
            throw error;
        }
    },
};

module.exports = getDBMovie;
