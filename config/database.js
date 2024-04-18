// import 
const sql = require('mssql')
require('dotenv').config()

//config
const sqlConfig = {
    user : process.env.USER_NAME,
    password : process.env.PASSWORD,
    server : process.env.SERVER,
    pool : {
        max : 10,
        min : 0,
        idleTimeoutMillis: 30000,
    },
    option: {
        encrypt : true,
        trustServerCertificate: true,
    },
}