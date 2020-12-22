require('dotenv').config({path: './../../.env'});
var DB = require("./../index.js");

class Exception {
  constructor(code,message) {
    this.code = code;
    this.message = message;
  } 
}

class keypair {
  constructor(public_key,private_key) {
    this.public_key = public_key;
    this.private_key = private_key
  }
  getPublic() {
    return this.public_key;
  }
  getPrivate() {
    return this.private_key;
  }
}

var root = "cryptocrit/students";

class Student {
  constructor() {}

  static async getEmailFromRollNumber(rollno) {
    var db = new DB(root);
    var student = await db.read(rollno);
    return student.email;
  }

  static async setPublicKey(rollno, public_key) {
    var db = new DB(root);
    await db.write(rollno + "/public_key", public_key);
    return true;
  }

  static async getPublicKey(rollno) {
    var db = new DB(root);
    var student = await db.read(rollno);
    if (!student) throw new Exception(400,"Student doesn't exist");
    if (student.public_key) return student.public_key;
    else throw new Exception(500,"Student hasn't signed up yet");
  }

  static async exists(rollno) {
    var db = new DB(root);
    var student = await db.read(rollno);
    return student?true:false;
  }

  static async isNew(rollno) {
    var db = new DB(root);
    var student = await db.read(rollno);
    if (student.public_key) return false;
    else return true;
  }
}

module.exports = Student;
