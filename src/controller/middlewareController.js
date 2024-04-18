// const express = require('express');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const middlewareController = {
    verifyToken : (req, res, next) => {
        const token = req.body.token;
        if (token){
            const accessToken = token.split(" ")[1];
            jwt.verify(accessToken, process.env.JWT_ACCESS_KEY, (err, user)=> {
                if (err){
                    res.status(404).json("Token is not valid");
                }
                req.user = user;
                next();
            });
            
        }else{
            res.status(401).json({ error: "Token is missing" });
        }
    }
}
  module.exports = middlewareController;