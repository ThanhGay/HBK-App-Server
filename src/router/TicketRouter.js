const express = require("express");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const routerTicket = express.Router();
const processDataInfo = require('../processData/processDataInfo')
const getDBTicket = require("../controller/TicketController");
const rollbackOrCommit =  require("../controller/TicketController");
const middlewareController = require("../controller/middlewareController");
const Token = require("../controller/TokenController");

// bấm booking truyền token 
routerTicket.post('/create-invoice',
middlewareController.verifyToken, 
async(req, res) => {
    try{    
    postdata =  req.PhoneNumber
    const data = await getDBTicket.createInvoice(postdata)
    res.json((data))
    }
    catch(error) {
        res.status(500).json({error: error.message})
    }
});


// bấm quay lại ở màn selectseat
routerTicket.post('/rollback-create-invoice', async(req,res) => {
    try {
        const dataroll = req.body
        const data = await test(dataroll);
        res.json(processDataInfo(data))
    } catch (error) {
        res.status(500).json(error)
        
    }
})

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

// hiển thị chi tiết hoá đơn
routerTicket.post('/detail-ticket', middlewareController.verifyToken ,async(req, res) => {
    try {
        const postData = req.body;
        const data = await getDBTicket.DetailInvoice(postData);
        res.json(processDataInfo(data));
    } catch (error) {
        res.status(500).json(error)
    }
   
})
routerTicket.get('/my-tickets', middlewareController.verifyToken, async(req, res) => {
    try {
        const data = await getDBTicket.MyTicket();
        res.json(processDataInfo(data))
    } catch (error) {
        res.status(500).json(error)
    }
})


module.exports = routerTicket;
