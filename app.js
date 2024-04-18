const express = require('express');
require('dotenv').config();
const bodyParser = require('body-parser');
const routerAccount = require('./src/router/AccountRoute')

const app = express();
const port = process.env.PORT||3000;

// Sử dụng middleware để parse JSON từ request body
app.use(express.json())

// Mock database

// Route đăng nhập
app.use('/Account', routerAccount)


app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

