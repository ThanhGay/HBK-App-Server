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
routerTicket.get('/detail-ticket=:Invoice_Id', middlewareController.verifyToken ,async(req, res) => {
    try {
        const postData = req.params.Invoice_Id;
        const data = await getDBTicket.DetailInvoice(postData);
        res.json(processDataInfo(data));
    } catch (error) {
        res.status(500).json(error)
    }
   
})

// Xoá vé theo mã hoá đơn (Lúc back chọn lại ghế sẽ xoá mã hoá đơn Id này là Invoice_Id)
routerTicket.get('/delete-ticket=:Invoice_Id', 
middlewareController.verifyToken, 
async (req, res) => {
    try {
        const getData = req.params.Invoice_Id;
        const data = await getDBTicket.delTicket(getData);
        res.json(processDataInfo(data));
    } catch (error) {
        res.status(500).json({error : error.message});
    }
})

// Xoá hoá đơn theo mã hoá đơn
routerTicket.get('/delete-invoice=:Invoice_Id', 
middlewareController.verifyToken, 
async (req, res) => {
    try {
        const getData = req.params.Invoice_Id;
        const data = await getDBTicket.delInvoice(getData);
        res.json(processDataInfo(data));
    } catch (error) {
        res.status(500).json({error : error.message});
    }
})

// Lưu hoá đơn vào db
routerTicket.post('/save-invoice', 
middlewareController.verifyToken,
async (req, res) => {
    try {
        const postData = req.body;
        const data = await getDBTicket.saveInvoice(postData);
        res.json(data)
    } catch (error) {   
        res.status(500).json({error : error.message})
    }
}
)

routerTicket.get('/my-tickets', 
middlewareController.verifyToken, 
async(req, res) => {
    try {
        const PhoneNumber = {PhoneNumber : req.PhoneNumber};
        const data = await getDBTicket.MyTicket(PhoneNumber);
        res.json(processDataInfo(data))
    } catch (error) {
        res.status(500).json(error)
    }
})


module.exports = routerTicket;
