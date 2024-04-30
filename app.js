const express = require('express');
require('dotenv').config();
const routerAccount = require('./src/router/AccountRoute');
const routerToken = require('./src/router/TokenRoute');
const routerMovie = require('./src/router/MovieRoute');
const routerTicket = require('./src/router/TicketRouter');
const routerReport = require('./src/router/ReportRoute');
const cookieParser = require('cookie-parser');

const app = express();
const port = process.env.PORT || 3000;

// Sử dụng middleware để parse JSON từ request body
app.use(express.json());
app.use(cookieParser());

// Route đăng nhập
app.use('/account', routerAccount);

// Refresh Token
app.use('/refresh', routerToken);

// Route phim
app.use('/movie', routerMovie);

// Route vé
app.use('/ticket', routerTicket);

app.use('/report', routerReport);

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
