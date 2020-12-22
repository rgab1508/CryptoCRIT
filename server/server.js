require('dotenv').config({path: './.env'});

var express = require("express");
var cors = require('cors');
var bodyParser = require('body-parser')
var crypto = require('crypto');

var Student = require("./database/rollno");
var OTP = require("./auth/OTP");
var keygen = require("./auth/keygen");
var Session = require("./database/session");

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
    var userExists = await Student.exists(rollno);  // check if roll number is valid
    if (!userExists) throw new Exception(401,"Invalid roll number"); // Invalid roll number
    var otp = new OTP(rollno);
    var token = await otp.send();
    res.json({
      token: token
    });
  }
  catch (e) {
    if (e instanceof Exception) res.status(e.code).end(e.message);
    else res.json(e);
  }
});

app.post('/verify', async function(req,res) {
  try {
    if (!req.body.token) throw new Exception(400,"parameter missing: token");  // token missing
    if (!req.body.otp) throw new Exception(400,"parameter missing: otp");  // OTP missing
    var student = await OTP.verify(req.body.token,req.body.otp);  // verifies OTP, if unauthorised, throws Exception
    if (await Student.isNew(student.rollno)) await Student.setKeyPair(student.rollno, keygen.generateKeyPair()); // if student is new, generate keypair for them
    var token = crypto.randomBytes(8).toString('hex');
    var session = new Session(token);
    session.set("rollno",student.rollno);
    session.set("type","login");
    await session.create();
    res.json({
      token: token
    });
  }
  catch (e) {
    res.status(e.code).end(e.message);
  }
});

app.post('/transaction', async function(req,res) {

});

app.get('/balance', async function(req,res) {

});

app.get('/blockchain', async function(req,res) {

});

app.post('/*', function(req,res) {
  res.status(404).end("Not Found");
});

app.get('/*', function(req,res) {
  res.status(404).end("Not Found");
});

app.listen(process.env.PORT || 8080);
