const express = require('express');
const token = require('../controller/TokenController');
const routerToken = express.Router();

routerToken.post('/', token.requestRefreshToken);

module.exports = routerToken;
