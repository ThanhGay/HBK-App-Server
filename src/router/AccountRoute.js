const express = require('express');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const routerAccount = express.Router();
const getDBAccount = require('../controller/AccountController');
const middlewareController = require('../controller/middlewareController');
const Token = require('../controller/TokenController');
const { processTrue, processFalse } = require('../processData/processDataInfo');

// đăng nhập
routerAccount.post('/sign-in', async (req, res) => {
  try {
    const postAccount = req.body;
    console.log(postAccount);
    const data = await getDBAccount.getData(postAccount);
    const status = !!data.length;
    const msg = status ? 'Đăng nhập thành công' : 'Đăng nhập thất bại';
    let token = null;
    let refreshToken = null;

    if (status) {
      token = Token.generateAccessToken(postAccount.PhoneNumber);
      refreshToken = Token.generateRefreshToken(postAccount.PhoneNumber);
      res.cookie('refreshToken', refreshToken, {
        httpOnly: true,
        secure: true,
        path: '/',
        sameSite: 'strict',
      });
    }

    res.json({
      status: status,
      data: {
        data_user: data[0],
        accesToken: token,
        refreshToken: refreshToken,
      },
      msg: msg,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// đăng ký
routerAccount.post('/sign-up', async (req, res) => {
  try {
    const postAccount = req.body;
    const data = await getDBAccount.postData(postAccount);
    const status = true;
    const msg = status ? 'Đăng ký thành công' : 'Đăng ký thất bại';
    let token = null;
    let refreshToken = null;
    if (status) {
      token = Token.generateAccessToken(postAccount.PhoneNumber);
      refreshToken = Token.generateRefreshToken(postAccount.PhoneNumber);
      res.cookie('refreshToken', refreshToken, {
        httpOnly: true,
        secure: true,
        path: '/',
        sameSite: 'strict',
      });
    }

    res.json({
      status: status,
      data: {
        data_user: data,
        accesToken: token,
        refreshToken: refreshToken,
      },
      msg: msg,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// đổi mật khẩu (Profile)
routerAccount.put(
  '/change-password',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const putAccount = req.body;
      putAccount.PhoneNumber = req.PhoneNumber;
      console.log(putAccount);
      const data = await getDBAccount.putData(putAccount);
      if (!data || putAccount.Password === putAccount.NewPassword) {
        res.json(processFalse(data));
      } else {
        res.json(processTrue(data));
      }
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

// đăng xuất tài khoản
routerAccount.post('/sign-out', (req, res) => {
  try {
    res.clearCookie('refreshToken');
    res.json(processTrue());
  } catch (error) {
    res.status(500).json(processFalse());
  }
});

// xoá tài khoản
routerAccount.delete(
  '/delete-account',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const delData = { PhoneNumber: req.PhoneNumber };
      const data = await getDBAccount.deleteData(delData);
      if (data) {
        res.json(processTrue(data));
      } else {
        res.json(processFalse(data));
      }
    } catch (error) {
      console.error('Error decoding token:', error);
      res.status(500).json({ error: 'Error decoding token' });
    }
  },
);

// đặt lại mật khẩu
routerAccount.put('/forgot-password', async (req, res) => {
  try {
    const putAccount = req.body;
    if (putAccount.Password == putAccount.ConfirmPassword) {
      const data = await getDBAccount.forgotPassword(putAccount);
      res.json(processTrue(data));
    } else {
      res.json(processFalse(data));
    }
  } catch (error) {
    res.status(500).json(processFalse(error.message));
  }
});

// Sửa thông tin my account
routerAccount.put(
  '/edit-profile',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const putAccount = req.body;
      putAccount.PhoneNumber = req.PhoneNumber;
      const data = await getDBAccount.EditProfile(putAccount);
      res.json(processTrue(data));
    } catch (error) {
      if (error.message.includes('Violation of PRIMARY KEY')) {
        res.status(400).json({
          status: false,
          data: null,
          msg: 'Cannot edit information: Duplicate phone number.',
        });
      } else if (
        error.message.includes(
          'Conversion failed when converting date and/or time from character string.',
        )
      ) {
        // Xử lý lỗi không định dạng được ngày tháng
        res.status(400).json({
          status: false,
          data: null,
          msg: 'Invalid date format error: Please enter a valid date.',
        });
      } else {
        res.status(500).json({
          status: false,
          data: null,
          msg: 'Internal server error.',
        });
      }
    }
  },
);

// Thông tin chi tiết
routerAccount.post(
  '/detail-profile',
  middlewareController.verifyToken,
  async (req, res) => {
    try {
      const getAccount = { PhoneNumber: req.PhoneNumber };

      const data = await getDBAccount.Profile(getAccount);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);

module.exports = routerAccount;
