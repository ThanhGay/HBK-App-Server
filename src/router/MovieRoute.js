const express = require("express");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const routerMovie = express.Router();
const getDBMovie = require("../controller/MovieController");
const middlewareController = require("../controller/middlewareController");
const Token = require("../controller/TokenController");

// danh sách phim đang chiếu
routerMovie.get("/now-playing", async (req, res) => {
    try {
        const data = await getDBMovie.NowPlaying();
        res.json(data);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// danh sách phim đang chiếu
routerMovie.get("/coming-soon", async (req, res) => {
    try {
        const data = await getDBMovie.ComingSoon();
        res.json(data);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// danh sách danh sách lịch chiếu theo phim  ??? đang sai
// truyền id của phim lên và trả về danh sách lịch chiếu của phim đó

routerMovie.get("/showtimes", async (req, res) => {
    try {
        const data = await getDBMovie.movieScheduleList();
        res.json(data);
    } catch (error) {}
});

module.exports = routerMovie;
