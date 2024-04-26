const express = require('express');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const routerTicket = express.Router();
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

module.exports = routerTicket;
