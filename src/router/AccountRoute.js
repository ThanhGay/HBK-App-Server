const express = require("express");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const routerAccount = express.Router();
const getDBAccount = require("../controller/AccountController");
const middlewareController = require("../controller/middlewareController");
const Token = require('../controller/TokenController')

// đăng nhập

routerAccount.post("/SignIn", async (req, res) => {
  try {
    const postAccount = req.body;
    console.log(postAccount);
    const data = await getDBAccount.getData(postAccount);
    const status = !!data.length;
    const msg = status ? "Success" : "Failure";
    let token = null;
    let refreshToken = null;

    if (status) {
      token = Token.generateAccessToken(postAccount.PhoneNumber);
      refreshToken = Token.generateRefreshToken(postAccount.PhoneNumber);
      res.cookie("refreshToken", refreshToken, {
        httpOnly: true,
        secure: true,
        path: '/',
        sameSite: 'strict'
      })
    }

    res.json({ status: status, data: { data_user: data[0], accesToken: token, refreshToken: refreshToken }, msg: msg });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// đăng ký
routerAccount.post("/SignUp", async (req, res) => {
  try {
    const postAccount = req.body;
    const data = await getDBAccount.postData(postAccount);
    const status = true;
    const msg = status ? "Success" : "Failure";
    let token = null;
    let refreshToken = null;
    if (status) {
      token = Token.generateAccessToken(postAccount.PhoneNumber);
      refreshToken = Token.generateRefreshToken(postAccount.PhoneNumber);
      res.cookie("refreshToken", refreshToken, {
        httpOnly: true,
        secure: true,
        path: '/',
        sameSite: 'strict'
      })
    }

    res.json({ status: status, data: { items: data, accesToken: token, refreshToken: refreshToken }, msg: msg });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// đổi mật khẩu bên
routerAccount.put(
  "/ChangePassword",
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const putAccount = req.body;
      const data = await getDBAccount.putData(putAccount);
      const status = !!data;
      const msg = status ? "Success" : "Failure";
      res.json({ msg });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// đăng xuất tài khoản
routerAccount.post('/SignOut', (req, res) => {
  res.clearCookie('refreshToken')
  res.json({ message: "Sign out successful" });
})

// xoá tài khoản 
routerAccount.delete('/DeleteAccount', async (req, res) => {
  const token = req.body.token; // Giả sử token được gửi dưới dạng thuộc tính 'token' trong body

  try {
    const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_KEY);
    const phoneNumber = decodedToken.PhoneNumber;
    const dataToken = { PhoneNumber: phoneNumber };
    const data = await getDBAccount.deleteData(dataToken);
    const msg = !!data ? "Success" : "Failure"
    res.json({ msg })
  } catch (error) {
    console.error('Error decoding token:', error);
    res.status(500).json({ error: 'Error decoding token' });
  }
});
module.exports = routerAccount;
