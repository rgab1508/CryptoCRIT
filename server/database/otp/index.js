var firebase = require("firebase-admin");

class OTPbase {
  constructor() {}
  
  static async setToken(token,rollno,otp) {
    // TODO write logic to store token data along with timestamp
    // token: {otp, timestamp, rollno}
  }

  static async getToken(token) {
    // TODO write logic to fetch data associated with this token
    // {otp,timestamp,rollno}
  }

  static async revoke(token) {
    // TODO write logic to revoke token if OTP is verified
  }
}

module.exports = OTPbase;