const { json } = require("body-parser");
const connection = require("../config/database");
const getDBAccount = {
  getData: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();

      const query = `Select * 
      From Account
      Where PhoneNumber = @PhoneNumber and Password = @Password`;
      for (const key in data) {
        request.input(key, data[key]);
      }
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  postData: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Insert into Account
    Values (@PhoneNumber, @Password, @FullName, @Email,'male', @DataOfBirth, 0, 'Bronze')`;
      for (const key in data) {
        request.input(key, data[key]);
      }
      const result = await request.query(query);
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
};
module.exports = getDBAccount;
