const express = require('express');
const routerAccount = express.Router();
const getDBAccount = require('../controller/AccountController');
//

routerAccount.post('/SignIn', async (req, res) => {
    try {
        const postAccount = req.body
        const data = await getDBAccount.getData(postAccount);
        const status = !! data.length
        const msg = status ? "Success" : "Failure";

        res.json({status : status, data : data, msg: msg})
    } catch (error) {
        res.status(500).json({error: error.message});

    }
});
routerAccount.post('/SignUp', async (req, res) => {
    try {
        const postAccount = req.body;
        const data = await getDBAccount.postData(postAccount);
        res.json({data : data})


    } catch (error) {
        res.status(500).json({error: error.message});

    }
})
module.exports = routerAccount