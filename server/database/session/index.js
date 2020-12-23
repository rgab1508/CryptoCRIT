require('dotenv').config({path: './../../.env'});
var DB = require("./../index.js");

// TODO create interface to manage sessions

class Exception {
  constructor(code,message) {
    this.code = code;
    this.message = message;
  } 
}

var root = "cryptocrit/session";

class Session {
  constructor(token) {
    this.token = token;
    this.data = {};
  }

  set(key,value) {
    this.data[key] = value;
  }

  async create() {
    this.set("timestamp", Date.now());
    var db = new DB(root);
    await db.write(this.token,this.data)
    return true;
  }

  static async get(token) {
    var db = new DB(root);
    var data = await db.read(token);
    if (data) return data;
    else throw new Exception(401, "Invalid Token");
  }

  static async destroy(token) {
    var db = new DB(root);
    await db.remove(token);
    return true;
  }

  static async isLoggedIn(token) {
  	var session = await Session.get(token);
  	if (session.type != "login") throw new Exception(401, "Incorrect Token");
  }
}

module.exports = Session;
