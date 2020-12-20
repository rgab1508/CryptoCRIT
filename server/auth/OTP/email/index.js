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
    var transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: this.email,
        pass: this.password
      }
    });
    const mailOptions = {
      from: process.env.email,
      to: this.to,
      subject: this.subject,
      html: this.body
    };
    return new Promise((resolve,reject)=>{
      transporter.sendMail(mailOptions, function (err, info) {
        if(err) reject(err);
        else resolve(info);
      });
    });
  }
}

module.exports = Email;
