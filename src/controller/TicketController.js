const { json } = require("body-parser");
const connection = require("../config/database");
const e = require("express");

const getDBTicket = {
  
    //Tao 1 ticket mới
    createInvoice : async(data) => {
        try {
            const pool = await connection;
            const request = pool.request()
            const query =
            `Insert into Invoice
            Values (GetDate(), 0, @PhoneNumber)
            SELECT SCOPE_IDENTITY() AS NewInvoiceId;`
            request.input('PhoneNumber', data.PhoneNumber)
            const result = await request.query(query)
            return result.recordset
        } catch (error) {
            console.error(error);
            throw error;
        }
    },  
    //Thông tin danh sách ghế đã đặt theo lịch chiếu
    Seats : async(data) => {
        try {
            const pool = await connection;
            const request = pool.request()
            const query = 
            `Select * 
            From Ticket
            where StartTime = @StartTime`;
            request.input('StartTime', data.StartTime);
            const result = await request.query(query);
            return result.recordset

        } catch (error) {
            console.error(error);
            throw error
            
        }
    },
    // Đặt vé
    bookTickets : async (data) => {
        try {
            const pool = await connection;
            const request = pool.request();
            const query = []
            for (index in data.Seat_Id){

                query.push(`INSERT INTO Ticket VALUES (50000, ${data.Invoice_Id}, '${data.StartTime}', '${data.Seat_Id[index]}', '${data.Room_Id}');`);
            }
            console.log(query)
            for (q in query){                
                console.log(query[q]);

                const result = await request.query(query[q]);
                console.log(result);
            }


            return(query)

        } catch (error) {
            console.error(error);
            throw error
            
        }
    }
};

module.exports = getDBTicket;
