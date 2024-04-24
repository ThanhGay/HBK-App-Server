const express = require("express");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const routerTicket = express.Router();
const processDataInfo = require('../processData/processDataInfo')
const getDBTicket = require("../controller/TicketController");
const middlewareController = require("../controller/middlewareController");
const Token = require("../controller/TokenController");

// bấm bôking truyền token 
routerTicket.post('/create-invoice',
middlewareController.verifyToken, 
async(req, res) => {
    try{
    postdata = {PhoneNumber: req.PhoneNumber}
    const data = await getDBTicket.createInvoice(postdata)
    res.json(processDataInfo(data))
    }
    catch(error) {
        res.status(500).json(error)
    }
});


//  selectseat  "StartTime": "2024-04-16 07:00:00.000"

routerTicket.post('/seats', async(req, res) => {
    const postData = req.body;
    const data = await getDBTicket.Seats(postData)
    res.json(processDataInfo(data))
});


// truyền token bấm confirm
routerTicket.post('/book-tickets', 
middlewareController.verifyToken, 
async(req,res) => {
    try {
         const postData =  req.body;
    const data = await getDBTicket.bookTickets(postData);
    res.json(data)
    } catch (error) {
        res.json({error : error.message})

    }
   
});
// routerTicket.get('/my-tickets', middlewareController.verifyToken, async(req, res))


module.exports = routerTicket;
