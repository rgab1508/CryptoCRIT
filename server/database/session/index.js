require('dotenv').config({path: './../../.env'});
var DB = require("./../index.js");

// TODO create interface to manage sessions

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
    return await db.read(token);
  }

  static async destroy(token) {
    var db = new DB(root);
    await db.remove(token);
    return true;
  }
}

module.exports = Session;
