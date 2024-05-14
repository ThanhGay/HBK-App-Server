const express = require('express');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const routerTicket = express.Router();
const sql = require('mssql');
const { processTrue, processFalse } = require('../processData/processDataInfo');
const getDBTicket = require('../controller/TicketController');
const rollbackOrCommit = require('../controller/TicketController');
const middlewareController = require('../controller/middlewareController');
const Token = require('../controller/TokenController');

// bấm booking truyền token
routerTicket.post(
  '/create-invoice',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const postdata = { PhoneNumber: req.PhoneNumber };
      const data = await getDBTicket.createInvoice(postdata);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

//  selectseat  "StartTime": "2024-04-16 07:00:00.000"
routerTicket.post('/seats', async (req, res) => {
  try {
    const postData = req.body;
    const data = await getDBTicket.Seats(postData);
    res.json(processTrue(data));
  } catch (error) {
    res.status(500).json(processFalse(error.message));
  }
});

// truyền token bấm confirm
routerTicket.post(
  '/book-tickets',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const postData = req.body;
      const data = await getDBTicket.bookTickets(postData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

// hiển thị giá tiền
routerTicket.get(
  '/detail-ticket=:Invoice_Id',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const postData = req.params.Invoice_Id;
      const data = await getDBTicket.DetailInvoice(postData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

// Xoá vé theo mã hoá đơn (Lúc back chọn lại ghế sẽ xoá mã hoá đơn Id này là Invoice_Id)
routerTicket.get(
  '/delete-ticket=:Invoice_Id',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const getData = req.params.Invoice_Id;
      const data = await getDBTicket.delTicket(getData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

// Xoá hoá đơn theo mã hoá đơn
routerTicket.get(
  '/delete-invoice=:Invoice_Id',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const getData = req.params.Invoice_Id;
      const data = await getDBTicket.delInvoice(getData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

// Lưu hoá đơn vào db
routerTicket.post(
  '/save-invoice',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const postData = req.body;
      postData.PhoneNumber = req.PhoneNumber;
      const data = await getDBTicket.saveInvoice(postData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

routerTicket.get(
  '/my-tickets',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const PhoneNumber = { PhoneNumber: req.PhoneNumber };
      const data = await getDBTicket.MyTicket(PhoneNumber);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

// Transaction
let activeTransaction = null;

routerTicket.post(
  '/transaction-invoice',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const data = req.body;
      data.PhoneNumber = req.PhoneNumber;

      // Begin transaction
      const transaction = new sql.Transaction();
      await transaction.begin();
      const request = transaction.request();
      const query = `
        INSERT INTO Invoice 
        VALUES (GETDATE(), 0, @PhoneNumber);
        SELECT SCOPE_IDENTITY() AS NewInvoiceId;
     
        `;
      request.input('PhoneNumber', data.PhoneNumber);

      // Execute the query
      const result1 = await request.query(query);
      const Scope = result1.recordset[0].NewInvoiceId;
      console.log(Scope);

      const query2 = [];
      for (index in data.Seat_Id) {
        query2.push(
          `INSERT INTO Ticket 
          VALUES (50000, ${Scope}, '${data.StartTime}', '${data.Seat_Id[index]}', '${data.Room_Id}');`,
        );
      }
      console.log(query2);

      for (q in query2) {
        console.log(query2[q]);

        const result = await request.query(query2[q]);
      }
      const query3 = `Select * 
    From Invoice
    Where Invoice_Id = ${Scope}`;
      const result3 = await request.query(query3);

      activeTransaction = transaction;
      res.status(200).json(processTrue(result3.recordset[0]));
    } catch (error) {
      // Handle errors
      console.error('Error occurred:', error);
      res.status(500).json(processFalse('Internal Server Error'));
    }
  },
);

routerTicket.post('/active-transaction', async (req, res) => {
  try {
    const decision = req.body.decision;

    console.log(activeTransaction);

    if (!activeTransaction) {
      res.status(400).json(processFalse('Transaction not found.'));
      return;
    }
    if (decision === 1) {
      await activeTransaction.commit();
      res.status(200).json(processTrue('Transaction committed successfully.'));
    } else if (decision === 0) {
      await activeTransaction.rollback();

      res
        .status(200)
        .json(processTrue('Transaction rolled back successfully.'));
    } else {
      await activeTransaction.rollback();
      res.status(400).json(processFalse('Invalid decision.'));
    }
    // activeTransaction = null;
  } catch (error) {
    await activeTransaction.rollback();
    console.error('Error occurred:', error);
    res.status(500).json(processFalse('Internal Server Error'));
  }
});

module.exports = routerTicket;
