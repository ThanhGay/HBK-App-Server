const express = require('express');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const routerMovie = express.Router();
const getDBMovie = require('../controller/MovieController');
const { processTrue, processFalse } = require('../processData/processDataInfo');
const middlewareController = require('../controller/middlewareController');
const Token = require('../controller/TokenController');

// danh sách phim đang chiếu
routerMovie.get('/now-playing/', async (req, res) => {
  try {
    const data = await getDBMovie.NowPlaying();
    res.json(processTrue(data));
  } catch (error) {
    res.status(500).json(processFalse(error.message));
  }
});

// danh sách phim sắp chiếu
routerMovie.get('/coming-soon', async (req, res) => {
  try {
    const data = await getDBMovie.ComingSoon();
    res.json(processTrue(data));
  } catch (error) {
    res.status(500).json(processFalse(error.message));
  }
});

// danh sách lịch chiếu của phim
routerMovie.post('/showtimes', async (req, res) => {
  try {
    const postData = req.body;
    const data = await getDBMovie.movieScheduleList(postData);
    res.json(processTrue(data));
  } catch (error) {
    res.status(500).json(processFalse(error.message));
  }
});

// thông tin chi tiết phim
routerMovie.get('/:Id', async (req, res) => {
  try {
    const postData = req.params.Id;
    const data = await getDBMovie.movieInfo(postData);

    res.json(processTrue(data));
  } catch (error) {
    res.json(processFalse(error.message));
  }
});

// ---------------------------------Update---------------------------------

// category (truyeenf token va "Role_Id" o body)
routerMovie.post(
  '/category',
  middlewareController.verifyToken,
  middlewareController.authorization,
  async (req, res) => {
    try {
      const data = await getDBMovie.getCategory();
      res.json(data);
    } catch (error) {
      res.status(500).json(processFalse(data));
    }
  },
);

// add category (Role_Id => khi co app truyen tu ngoai nhu truyen token, Category_Id, Category_Name)
routerMovie.post(
  'add-category',
  middlewareController.verifyToken,
  middlewareController.authorization,
  async (req, res) => {
    try {
      const postData = req.body;
      const data = await getDBMovie.addCategory(postData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);
// edit info movie (truyen thong tin phim va "Category_Id" : [Id1, Id2,...])
routerMovie.put(
  'put-movie',
  middlewareController.verifyToken,
  middlewareController.authorization,
  async (req, res) => {
    try {
      const putData = req.body;
      const data = await getDBMovie.putMovie(putData);
      res.json(processTrue(data));
    } catch (error) {
      res.status(500).json(processFalse(error.message));
    }
  },
);
module.exports = routerMovie;
