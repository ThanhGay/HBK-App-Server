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

//http://localhost:8888/movie/now-playing1/?limit=2&page=4
routerMovie.get('/now-playing1', async (req, res) => {
  try {
    const getParams = req.query;
    console.log(getParams);
    const data = await getDBMovie.NowPlayingPage(getParams);
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
routerMovie.get('/detail-movie/:Id', async (req, res) => {
  try {
    const postData = req.params.Id;
    console.log(postData);
    const data = await getDBMovie.movieInfo(postData);

    res.json(processTrue(data));
  } catch (error) {
    res.json(processFalse(error.message));
  }
});

// ---------------------------------Update---------------------------------

// category (truyeenf token va "Role_Id" o body)
routerMovie.get('/category', async (req, res) => {
  try {
    const data = await getDBMovie.getCategory();
    res.json(processTrue(data));
  } catch (error) {
    res.status(500).json(processFalse(error.message));
  }
});

routerMovie.post('/add-movie', async (req, res) => {
  try {
    const postData = req.body;
    const data = await getDBMovie.addMovie(postData);
    res.json(processTrue(data));
  } catch (error) {
    res.json(processFalse(error));
  }
});

// edit info movie (truyen thong tin phim va "Category_Id" : [Id1, Id2,...])
routerMovie.put(
  '/put-movie',
  // middlewareController.verifyToken,
  // middlewareController.authorization,
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

routerMovie.post('/add-movieshow', async (req, res) => {
  try {
    const postData = req.body;
    const data = await getDBMovie.addMovieShow(postData);
    res.json(processTrue(data));
  } catch (error) {
    res.json(processFalse(error.message));
  }
});

// Create category
routerMovie.post('/add-category', async (req, res) => {
  try {
    const postData = req.body;
    console.log(postData);

    const data = await getDBMovie.addCategory(postData);
    res.json(processTrue(data));
  } catch (error) {
    res.status(500).json(processFalse(error.message));
  }
});

// Edit category truyen category_Id, Category_name muon doi

routerMovie.put('/edit-category', async (req, res) => {
  try {
    const putData = req.body;
    const data = await getDBMovie.editCategory(putData);
    res.json(processTrue(data));
  } catch (error) {
    res.json(processFalse(error.message));
  }
});

// Delete category truyen category_Id muon xoa
routerMovie.post('/delete-category', async (req, res) => {
  try {
    const delData = req.body;
    const data = await getDBMovie.deleteCategory(delData);
    res.json(processTrue(data));
  } catch (error) {
    res.json(processFalse(error.message));
  }
});

// Thêm đạo diễn, diễn viên

// thanh search theo tên phim truyen params name de search
routerMovie.get('/search-movie/:name', async (req, res) => {
  try {
    const getData = req.params.name;
    const data = await getDBMovie.searchMovie(getData);
    res.json(processTrue(data));
  } catch (error) {
    res.json(processFalse(error.message));
  }
});

module.exports = routerMovie;
