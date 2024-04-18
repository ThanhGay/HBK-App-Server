const express = require('express');
require('dotenv').config();
const bodyParser = require('body-parser');
const routerAccount = require('./src/router/AccountRoute')
const middlewareController = require('./src/controller/middlewareController')

const app = express();
const port = process.env.PORT||3000;

// Sử dụng middleware để parse JSON từ request body
app.use(express.json())
// Mock database

// Route đăng nhập
app.get('/movies', middlewareController.verifyToken, (req, res) => {

  res.json({ movies: ['Movie 1', 'Movie 2', 'Movie 3'] });
});
app.use('/Account', routerAccount)

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

