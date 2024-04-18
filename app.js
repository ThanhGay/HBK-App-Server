const express = require('express');
require('dotenv').config();
const bodyParser = require('body-parser');
const routerAccount = require('./src/router/AccountRoute')
const middlewareController = require('./src/controller/middlewareController')
const routerToken = require('./src/router/TokenRoute')
const cookieParser = require('cookie-parser');

const app = express();
const port = process.env.PORT||3000;

// Sử dụng middleware để parse JSON từ request body
app.use(express.json())
app.use(cookieParser());


// xem danh sách phim
app.get('/movies',middlewareController.verifyToken ,(req, res) => {

  res.json({ movies: ['Movie 1', 'Movie 2', 'Movie 3'] });
});
// Route đăng nhập
app.use('/Account', routerAccount)

// Refresh Token
app.use('/Refresh', routerToken)

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

