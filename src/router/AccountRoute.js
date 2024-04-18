const express = require('express');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const routerAccount = express.Router();
const getDBAccount = require('../controller/AccountController');


// đăng nhập

routerAccount.post('/SignIn', async (req, res) => {
    try {
        const postAccount = req.body
        const data = await getDBAccount.getData(postAccount);
        const status = !! data.length;
        const msg = status ? "Success" : "Failure";
        const token = status ? jwt.sign({ phoneNumber: postAccount.PhoneNumber}, process.env.JWT_ACCESS_KEY, { expiresIn: '1h' }): null; 
        res.json({status : status, data : data, token: token, msg: msg})
    } catch (error) {
        res.status(500).json({error: error.message});

    }
});

// đăng ký
routerAccount.post('/SignUp', async (req, res) => {
    try {
        const postAccount = req.body;
        const data = await getDBAccount.postData(postAccount);
        const status = true;
        const msg = status ? "Success" : "Failure";
        const token = status ? jwt.sign({ phoneNumber: postAccount.PhoneNumber}, process.env.JWT_ACCESS_KEY, { expiresIn: '1h' }): null; 
        res.json({ status : true, data : data, token: token, msg: msg})


    } catch (error) {
        res.status(500).json({error: error.message});

    }
})
module.exports = routerAccount