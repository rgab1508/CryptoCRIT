// module to handle OTP logic

require('dotenv').config({path: './../../.env'});
var crypto = require('crypto');

var Email = require("./email");
var Student = require("./../../database/rollno");
var Session = require("./../../database/session");

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

  getOTP() {
    var digits = '0123456789'; 
    let code = ''; 
    for (let i = 0; i < 4; i++ ) code += digits[Math.floor(Math.random() * 10)];
    return code;
  }

  async verify(token,otp) {
    var session = await Session.get(token); // TODO Need to work here
    if (session.otp != otp) return false;
    if (Date.now() - session.timestamp > 600000) throw new Exception(401, "OTP Expired");
    await OTPbase.revoke(token);
    return {
      rollno: session.rollno
    }
  }

  async send() {
    var email_id = await Student.getEmailFromRollNumber(this.rollno);
    var code = this.getOTP();
    var token = crypto.randomBytes(8).toString('hex');
    var session = new Session(token);
    session.set("rollno",this.rollno);
    session.set("otp",code);
    await session.create();
    var email = new Email(process.env.email,process.env.password);
    email.sendTo(email_id);
    email.setSubject("OTP verification for CryptoCRIT");
    email.setBody("Your OTP is " + code);
    await email.send();
    return token;
  }
}

module.exports = OTP;
