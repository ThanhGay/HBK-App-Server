const { json } = require('body-parser');
const connection = require('../config/database');
const sql = require('mssql');

const e = require('express');

const getDBTicket = {
  //Tao 1 ticket mới
  createInvoice: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();

      const query =
        // `Begin Transaction Booking
        // Insert into Invoice
        // Values (GetDate(), 0, @PhoneNumber)
        // DECLARE @Const Int
        // set @Const = @rollBack
        // IF @Const = 0
        // BEGIN
        //     ROLLBACK TRANSACTION Booking;
        //     PRINT 'rollBack thành công';
        // END
        // ELSE
        // BEGIN
        //     COMMIT TRANSACTION Booking;
        //     PRINT 'Commit thành công';
        // END;
        // SELECT SCOPE_IDENTITY() AS NewInvoiceId;
        // Select * from Invoice`
        `Insert into Invoice
            Values (GetDate(), 0, @PhoneNumber)
            SELECT SCOPE_IDENTITY() AS NewInvoiceId;`;

      request.input('PhoneNumber', data.PhoneNumber);
      // request.input('rollBack',  action)
      const result = await request.query(query);

      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  //Thông tin danh sách ghế đã đặt theo lịch chiếu
  Seats: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Select * 
            From Ticket
            where StartTime = @StartTime`;
      request.input('StartTime', data.StartTime);
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  // Đặt vé
  bookTickets: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = [];
      for (index in data.Seat_Id) {
        query.push(
          `INSERT INTO Ticket VALUES (50000, ${data.Invoice_Id}, '${data.StartTime}', '${data.Seat_Id[index]}', '${data.Room_Id}');`,
        );
      }
      console.log(query);
      for (q in query) {
        console.log(query[q]);

        const result = await request.query(query[q]);
        console.log(result);
      }

      return query;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  // Chi tiết Hoá Đơn (check lại)
  DetailInvoice: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Select * from Invoice
            Where Invoice_Id = @Invoice_Id`;
      request.input('Invoice_Id', data);
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // Xoá vé theo hoá đơn đang dùng
  delTicket: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Delete from Ticket
            Where Invoice_Id = @Invoice_Id`;
      request.input('Invoice_Id', data);
      const result = await request.query(query);
      return result;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // Xoá hoá đơn
  delInvoice: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Delete from Invoice
            Where Invoice_Id = @Invoice_Id`;
      request.input('Invoice_Id', data);
      const result = await request.query(query);
      console.log(data);
      return result;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // Lưu hoá đơn (chưa xong)
  saveInvoice: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Insert into MyTicket
        Values (@Invoice_Id, @Movie_Name, @Duration, @CategoryList, @Poster, @StartTime, @Room_Id, @Seat_Id, @Price, @PhoneNumber)`;
      for (key in data) {
        request.input(key, data[key]);
      }
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },

  // vé của tôi (My ticket)
  MyTicket: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `Select * 
            From MyTicket
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

module.exports = getDBTicket;
