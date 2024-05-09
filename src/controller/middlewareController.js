// const express = require('express');
const jwt = require('jsonwebtoken');
const { processTrue, processFalse } = require('../processData/processDataInfo');
require('dotenv').config();
// all
const middlewareController = {
  verifyToken: (req, res, next) => {
    const token = req.headers.authorization;
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

  // admin
  authorization: (req, res, next) => {
    const token = req.headers.authorization;
    if (token) {
      const accessToken = token.split(' ')[1];
      jwt.verify(accessToken, process.env.JWT_ACCESS_KEY, (err, user) => {
        if (err) {
          res.status(404).json('Token is not valid');
        } else {
          if (!user.Role_Id) {
            // next();
            res.status(401).json({ error: 'Khong phai admin' });
          }
          req.user = user;
          req.PhoneNumber = user.PhoneNumber;
          req.Role_Id = user.Role_Id;
          console.log(req);
          next();
        }
      });
    } else {
      res.status(401).json({ error: 'Token is missing' });
    }
  },
};
module.exports = middlewareController;
