// module to handle OTP logic

var Email = require("./email");

class OTP {
  constructor(email_id) {
    this.email_id = email_id;
  }

  async getOTP() {
    // TODO write logic to generate OTP and store it in database
  }

  async send() {
    var code = this.getOTP();
    var email = new Email();
    email.sendT0(email_id);
    email.setSubject("OTP verification for CryptoCRIT");
    email.setBody("Your OTP is" + code);
    email.send();
  }
}
