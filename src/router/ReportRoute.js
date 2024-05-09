const express = require('express');
const routerReport = express.Router();
const getDBReport = require('../controller/ReportController');
const { processTrue, processFalse } = require('../processData/processDataInfo');
const middlewareController = require('../controller/middlewareController');

routerReport.post(
  '/report-by-time',
  // middlewareController.verifyToken,
  // middlewareController.authorization,
  async (req, res) => {
    try {
      // truyen minDate, maxDate
      const postData = req.body;
      const data = await getDBReport.reportByTime(postData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

routerReport.get(
  '/report-by-movie',
  // middlewareController.verifyToken,
  // middlewareController.authorization,
  async (req, res) => {
    try {
      // khong truyen
      const data = await getDBReport.reportByMovie();
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

routerReport.post(
  '/report-by-quarter',
  // middlewareController.verifyToken,
  middlewareController.authorization,
  async (req, res) => {
    try {
      // truyen year muon bao cao
      const postData = req.body;
      const data = await getDBReport.reportByQuarter(postData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

routerReport.post(
  '/report-by-customer',
  // middlewareController.verifyToken,
  // middlewareController.authorization,
  async (req, res) => {
    // truyen minDate, maxDate
    try {
      const postData = req.body;
      const data = await getDBReport.reportByCustomer(postData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(data));
    }
  },
);

module.exports = routerReport;
