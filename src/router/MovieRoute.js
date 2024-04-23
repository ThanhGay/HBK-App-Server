const express = require("express");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const routerMovie = express.Router();
const getDBMovie = require("../controller/MovieController");
const middlewareController = require("../controller/middlewareController");
const Token = require("../controller/TokenController");

// danh sách phim đang chiếu
routerMovie.get("/NowPlaying", async (req, res) => {
    try {
        const data = await getDBMovie.NowPlaying();
        res.json(data);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// danh sách phim đang chiếu
routerMovie.get("/ComingSoon", async (req, res) => {
    try {
        const data = await getDBMovie.ComingSoon();
        res.json(data);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// danh sách danh sách lịch chiếu theo phim
routerMovie.get("/movieScheduleList", async (req, res) => {
    try {
        const data = await getDBMovie.movieScheduleList();
        res.json(data);
    } catch (error) {}
});

module.exports = routerMovie;
