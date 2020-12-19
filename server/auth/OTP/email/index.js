// module to send email

var nodemailer = require("nodemailer");

class Email {
  constructor(email,password) {
    this.email = email;
    this.password = password;
  }

  sendTo(email_id) {
    this.to = email_id;
  }

  setSubject(subject) {
    this.subject = subject;
  }

  setBody(body) {
    this.body = body;
  }

  async send() {
    // TODO write email sending logic
  }
}
