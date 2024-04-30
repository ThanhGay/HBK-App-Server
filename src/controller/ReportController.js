const connection = require('../config/database');

// Báo cáo theo khoảng thời gian
const getDBReport = {
  reportByTime: async (data) => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `SELECT Sum(Cost) as Total
            FROM Myticket
            Where CONVERT(date, InvoiceDate) BETWEEN @minDate and @maxDate`;
      request.input('minDate', data.minDate);
      request.input('maxDate', data.maxDate);
      const require = await request.query(query);
      return require.recordset;
    } catch (error) {
      console.log(error);
      throw error;
    }
  },
  reportByMovie: async () => {
    try {
      const pool = await connection;
      const request = pool.request();
      const query = `select Movie_Name, Sum(price) as Total
        from MyTicket
        GROUP BY Movie_Name`;
      const result = await request.query(query);
      return result.recordset;
    } catch (error) {
      console.log(error);
      throw error;
    }
  },
  reportByQuarter: async (data) => {
    const pool = await connection;
    const request = pool.request();
    const query = `SELECT 
    YEAR(InvoiceDate) AS Year,
    CASE 
        WHEN MONTH(InvoiceDate) / 4 < 1 THEN 'Q1'
        WHEN MONTH(InvoiceDate) / 4 < 2 THEN 'Q2'
        WHEN MONTH(InvoiceDate) / 4 < 3 THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter,
    SUM(Price) AS Revenue
    FROM 
    MyTicket
    Where YEAR(InvoiceDate) = @Year
    GROUP BY 
    YEAR(InvoiceDate),
    CASE 
        WHEN MONTH(InvoiceDate) / 4 < 1 THEN 'Q1'
        WHEN MONTH(InvoiceDate) / 4 < 2 THEN 'Q2'
        WHEN MONTH(InvoiceDate) / 4 < 3 THEN 'Q3'
        ELSE 'Q4'
    END
    ORDER BY 
    Year, 
    Quarter;`;
    request.input('Year', data.year);
    const result = await request.query(query);
    return result.recordset;
  },
  reportByCustomer: async (data) => {
    const pool = await connection;
    const request = pool.request();
    const query = `SELECT 
    PhoneNumber,
    SUM(Price) as Total,
    SUM(NumberOfSeat) as NumberOfSeats,
    Count(*) as NumberOfInvoice
    FROM (
    SELECT 
        PhoneNumber,
        Price,
        (SELECT COUNT(*) FROM STRING_SPLIT(Seat_Id, ',')) AS NumberOfSeat
    FROM 
        MyTicket 
    WHERE 
        CONVERT(DATE, InvoiceDate) BETWEEN @minDate AND @maxDate
    ) AS Subquery
    GROUP BY 
    PhoneNumber;`;
    request.input('minDate', data.minDate);
    request.input('maxDate', data.maxDate);
    const result = await request.query(query);
    return result.recordset;
  },
};
module.exports = getDBReport;
