const jwt = require('jsonwebtoken');
require('dotenv').config();

const Token = {
  generateAccessToken: (PhoneNumber, Role_Id) => {
    const token = jwt.sign(
      { PhoneNumber, Role_Id },
      process.env.JWT_ACCESS_KEY,
      {
        expiresIn: '7d',
      },
    );
    return token;
  },
  generateRefreshToken: (PhoneNumber) => {
    return jwt.sign({ PhoneNumber }, process.env.JWT_REFRESH_KEY, {
      expiresIn: '7d',
    });
  },

  requestRefreshToken: async (req, res) => {
    const refreshToken = req.cookies.refreshToken;
    if (!refreshToken) {
      return res.status(401).json("You're not authenticated");
    }
    jwt.verify(refreshToken, process.env.JWT_REFRESH_KEY, (err, user) => {
      if (err) {
        console.log(err);
      }
      const newAccessToken = generateAccessToken(user);
      const newRefreshToken = generateRefreshToken(user);
      res.cookie('refreshToken', newRefreshToken, {
        httpOnly: true,
        secure: true,
        path: '/',
        sameSite: 'strict',
      });
      res.status(200).json({ accessToken: newAccessToken });
    });
  },
};

module.exports = Token;
