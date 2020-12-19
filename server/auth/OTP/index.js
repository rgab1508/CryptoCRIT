// module to handle OTP logic

var crypto = require('crypto');

var Email = require("./email");
var Student = require("./../../database/rollno");
var OTPbase = require("./../../database/otp");

class Exception {
  constructor(code,message) {
    this.code = code;
    this.message = message;
  } 
}

class OTP {
  constructor(rollno) {
    this.rollno = rollno;
  }

  async getOTP() {
    var digits = '0123456789'; 
    let otp = ''; 
    for (let i = 0; i < 4; i++ ) otp += digits[Math.floor(Math.random() * 10)];
    var token = crypto.randomBytes(8).toString('hex');
    OTPbase.setToken(token,this.rollno,otp);
    return otp;
  }

  async verify(token,otp) {
    var session = await OTPbase.getToken(token);
    if (session.otp != otp) return false;
    if (Date.now() - session.timestamp > 600000) throw new Exception(401, "OTP Expired");
    await OTPbase.revoke(token);
    return {
      rollno: session.rollno
    }
  }

  async send() {
    var email_id = await Student.getEmailFromRollNumber(this.rollno);
    var code = await this.getOTP();
    var email = new Email();
    email.sendTo(email_id);
    email.setSubject("OTP verification for CryptoCRIT");
    email.setBody("Your OTP is" + code);
    email.send();
  }
}

module.exports = OTP;
