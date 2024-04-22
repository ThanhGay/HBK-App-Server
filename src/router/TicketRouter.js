const express = require("express");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const routerTicket = express.Router();
const getDBTicket = require("../controller/TicketController");
const middlewareController = require("../controller/middlewareController");
const Token = require("../controller/TokenController");

module.exports = routerTicket;
