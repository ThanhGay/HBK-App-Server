// const express = require('express');
const jwt = require('jsonwebtoken');
const { processTrue, processFalse } = require('../processData/processDataInfo');
require('dotenv').config();

const middlewareController = {
  verifyToken: (req, res, next) => {
    const token = req.headers.authorization;
    // console.log(token);
    if (token) {
      const accessToken = token.split(' ')[1];
      jwt.verify(accessToken, process.env.JWT_ACCESS_KEY, (err, user) => {
        if (err) {
          res.status(404).json('Token is not valid');
        }
        req.user = user;
        req.PhoneNumber = user.PhoneNumber;
        console.log(user);
        next();
      });
    } else {
      res.status(401).json({ error: 'Token is missing' });
    }
  },
  authorization: (req, res, next) => {
    const auth = req.body.Role_Id;
    console.log(auth);
    if (auth) {
      next();
    } else {
      const logData = 'You are not an administrator';
      res.status(401).json(processFalse(logData));
    }
  },
};
module.exports = middlewareController;
