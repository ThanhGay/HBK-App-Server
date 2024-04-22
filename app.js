const express = require("express");
require("dotenv").config();
const routerAccount = require("./src/router/AccountRoute");
const routerToken = require("./src/router/TokenRoute");
const routerMovie = require("./src/router/MovieRoute");
const routerTicket = require("./src/router/TicketRouter");
const cookieParser = require("cookie-parser");

const app = express();
const port = process.env.PORT || 3000;

// Sử dụng middleware để parse JSON từ request body
app.use(express.json());
app.use(cookieParser());

// Route đăng nhập
app.use("/Account", routerAccount);

// Refresh Token
app.use("/Refresh", routerToken);

// Route phim
app.use("/Movie", routerMovie);

// Route vé
app.use("/Ticket", routerTicket);

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
