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
    res.json(processData(data));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// danh sách phim sắp chiếu
routerMovie.get('/coming-soon', async (req, res) => {
  try {
    const data = await getDBMovie.ComingSoon();
    res.json(processData(data));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// danh sách lịch chiếu của phim
routerMovie.post('/showtimes', async (req, res) => {
  try {
    const postData = req.body;
    const data = await getDBMovie.movieScheduleList(postData);
    res.json(processData(data));
  } catch (error) {}
});

// thông tin chi tiết phim
routerMovie.get('/:Id', async (req, res) => {
  try {
    const postData = req.params.Id;
    const data = await getDBMovie.movieInfo(postData);

    res.json(processData(data));
  } catch (error) {
    res.json(error);
  }
});

module.exports = routerMovie;
