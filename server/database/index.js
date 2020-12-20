// TODO create interface for databae operations

require('dotenv').config({path: './../.env'});
const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.cert(JSON.parse(process.env.db)),
    databaseURL: process.env.db_url
});

class DB {
  constructor(path) {
    this.path = path;
    this.db = admin.database();
  }

  async read(key) {
    var ref = this.db.ref(this.path+'/'+key);
    return new Promise((resolve,reject) => {
      ref.once("value", (snapshot) => {
        resolve(snapshot.val());
      });
    });
  }

  async write(key,data) {
    var ref = this.db.ref(this.path+'/'+key);
    return new Promise((resolve,reject) => {
      ref.set(data, (error) => {
        if (error) reject(error);
	else resolve();
      });
    });
  }
}

module.exports = DB;
