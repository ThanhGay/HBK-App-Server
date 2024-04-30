const { json } = require('body-parser');
const moment = require('moment');

// const now = moment(); // Lấy thời gian hiện tại
const connection = require('../config/database');

// const { connect } = require("mssql");
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
    Values (@PhoneNumber, @Password, @FullName, @Email,'male', @DateOfBirth, 0, 'Bronze')`;
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
  putData: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Update Account
    Set Password = @NewPassword
    Where PhoneNumber = @PhoneNumber and Password = @Password`;
      for (const key in data) {
        request.input(key, data[key]);
      }
      const result = await request.query(query);

      return result.rowsAffected > 0;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  deleteData: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Delete from Account
      where PhoneNumber = @PhoneNumber`;
      request.input('PhoneNumber', data.PhoneNumber);
      const result = await request.query(query);
      return result.rowsAffected > 0;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  forgotPassword: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Update Account
      Set Password = @Password
      Where PhoneNumber = @PhoneNumber`;
      for (key in data) {
        request.input(key, data[key]);
      }
      const result = await request.query(query);
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  EditProfile: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `;
      Update Account
      Set FullName = @FullName, 
      DateOfBirth = @DateOfBirth, 
      Email = @Email
      Where PhoneNumber = @PhoneNumber`;
      for (key in data) {
        request.input(key, data[key]);
      }
      const result = await request.query(query);
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  Profile: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Select FullName, DateOfBirth, PhoneNumber, Email 
    From Account
    Where PhoneNumber = @PhoneNumber`;
      request.input('PhoneNumber', data.PhoneNumber);
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
};
module.exports = getDBAccount;
