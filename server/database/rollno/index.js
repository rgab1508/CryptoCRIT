require('dotenv').config({path: './../../.env'});
var DB = require("./../index.js");

var root = "cryptocrit/students";

class Student {
  constructor() {}

  static async getEmailFromRollNumber(rollno) {
    var db = new DB(root);
    var student = await db.read(rollno);
    return student.email;
  }

  static async setKeyPair(rollno, keyPair) {
    var db = new DB(root);
    await db.write(rollno + "/public_key", keyPair.getPublic());
    await db.write(rollno + "/private_key", keyPair.getPrivate());
    return true;
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
