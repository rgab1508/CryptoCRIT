require('dotenv').config({path: './.env'});

var express = require("express");
var cors = require('cors');
var bodyParser = require('body-parser')

var Student = require("./database/rollno");
var OTP = require("./auth/OTP");

var app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true})); 

class Exception {
  constructor(code,message) {
    this.code = code;
    this.message = message;
  } 
}

app.post('/login', async function(req,res) {
  try {
    if (!req.body.rollno) throw new Exception(400,"parameter missing: rollno");  // roll number missing
    var rollno = req.body.rollno;
    var userExists = await Student.exists(rollno);
    if (!userExists) throw new Exception(401,"Invalid roll number"); // Invalid roll number
    var otp = new OTP(rollno);
    var token = await otp.send();
    res.json({
      token: token
    });
  }
  catch (e) {
    res.json(e);
    //res.status(e.code).end(e.message);
  }
});

app.post('/verify', async function(req,res) {
  try {
    if (!req.body.token) throw new Exception(400,"parameter missing: token");  // token missing
    if (!req.body.otp) throw new Exception(400,"parameter missing: otp");  // OTP missing
    var verified = await OTP.verify(req.body.token,req.body.otp);
    if (verified) {
      var newUser = await Student.isNew(verified.rollno);
      // TODO continue from here
    }
    else {
      throw new Exception(401,"Incorrect OTP"); // Incorrect OTP
    }
  }
  catch (e) {
    res.status(e.code).end(e.message);
  }
});

app.get('/blockchain', async function(req,res) {

});

app.listen(process.env.PORT || 8080);
