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

// Test transaction
let activeTransaction = null;

routerTicket.post('/a', middlewareController.verifyToken, async (req, res) => {
  try {
    // Connect to the SQL database

    // Extract phone number from request
    const data = { PhoneNumber: req.PhoneNumber };

    // Begin transaction
    const transaction = new sql.Transaction();
    await transaction.begin();
    const request = transaction.request();
    // Create request object from transaction

    // SQL query to insert data into Invoice table
    const query = `
        INSERT INTO Invoice 
        VALUES (GETDATE(), 0, @PhoneNumber);
        SELECT SCOPE_IDENTITY() AS NewInvoiceId;
        declare @newInvoiceId int;
        set @newInvoiceId = (SELECT SCOPE_IDENTITY() as scope);
        
        INSERT INTO Ticket
        VALUES (50000,	@newInvoiceId,	"2024-04-30 17:00:00.000",	"D02",	"R01");

       
        `;

    const queryGPT = `INSERT INTO Invoice 
        OUTPUT INSERTED.Invoice_Id
        VALUES (GETDATE(), 0, @PhoneNumber);

        INSERT INTO Ticket
        VALUES (50000, SCOPE_IDENTITY(), '2024-04-30 17:00:00.000', 'D02', 'R01');
        `;

    // Declare input parameter for PhoneNumber
    request.input('PhoneNumber', data.PhoneNumber);

    // Execute the query
    const result = await request.query(query);

    activeTransaction = transaction;
    // console.log(transaction.id);

    // // Store the transaction in the session for later use
    // // const serializedTransaction = JSON.stringify(req.cookies.trans); // Serialize the transaction object

    // console.log(result.recordset);
    // res.cookie('transaction', transaction, {
    //   httpOnly: true,
    //   secure: true,
    //   path: '/',
    //   sameSite: 'strict',
    // });
    // Send success response
    res.status(200).json(result.recordset);
  } catch (error) {
    // Handle errors
    console.error('Error occurred:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Màn hình thứ hai: Xử lý commit hoặc rollback khi nhấn nút "continue" hoặc "back"
routerTicket.post('/b', async (req, res) => {
  try {
    const decision = req.body;

    console.log(activeTransaction);

    if (!activeTransaction) {
      res.status(400).send('Transaction not found.');
      return;
    }
    console.log(decision.decision);
    if (decision.decision === 1) {
      await activeTransaction.commit();
      res.status(200).send('Transaction committed successfully.');
    } else if (decision.decision === 0) {
      await activeTransaction.rollback();

      res.status(200).send('Transaction rolled back successfully.');
    } else {
      res.status(400).send('Invalid decision.');
    }
    activeTransaction = null;
  } catch (error) {
    console.error('Error occurred:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = routerTicket;
