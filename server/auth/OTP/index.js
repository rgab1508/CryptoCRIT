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

  static async verify(token,otp) {
    var session = await Session.get(token); // TODO Need to work here
    console.log(Date.now() - session.timestamp);
    if (session.otp != otp) throw new Exception(401, "Incorrect OTP");
    if (Date.now() - session.timestamp > 600000) throw new Exception(401, "OTP Expired");
    await Session.destroy(token);
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
    session.set("type","verify");
    await session.create();
    var email = new Email(process.env.email,process.env.password);
    email.sendTo(email_id);
    email.setSubject("OTP verification for CryptoCRIT");
    email.setBody(`<h3>Your OTP for CryptoCRIT is:</h3><h2>${code}</h2>`);
    await email.send();
    return token;
  }
}

module.exports = OTP;
