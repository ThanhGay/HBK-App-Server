// import 
const sql = require('mssql')
require('dotenv').config()

//config
const sqlConfig = {
    user : process.env.USER_NAME,
    password : process.env.PASSWORD,
    database : process.env.DATABASE,
    server : "localhost",
    pool : {
        max : 10,
        min : 0,
        idleTimeoutMillis: 30000,
    },
    options: {
        encrypt : true,
        trustServerCertificate: true,
    },
}
console.log('Connect SQL: ', sql.connect(sqlConfig))

module.exports = sql.connect(sqlConfig)