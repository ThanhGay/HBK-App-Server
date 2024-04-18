// import
const express = require('express');
const app = express();

require('dotenv').config()
//config
const Port = process.env.PORT || 3000



//App
app.get('/', function (req, res) {
  res.send(process.env);
});
app.listen(Port, function () {
  console.log(`Example app listening on port ${Port}!`);
});
