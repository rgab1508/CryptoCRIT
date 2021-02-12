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

  async getLast() {
  	var ref = this.db.ref(this.path).limitToLast(1);
    return new Promise((resolve,reject) => {
      ref.once("value", (snapshot) => {
        resolve(snapshot.val());
      });
    });
  }

  async transaction(handler) {
    var ref = this.db.ref(this.path);
    return new Promise((resolve,reject) => {
      ref.transaction((val) => {
        if (val != null) {
          resolve();
          return handler(val)
        }
        else return 0;
      }, (err) => {
        console.log(err);
      }, true);
    });
  }

  async push(data) {
    var ref = this.db.ref(this.path);
    await ref.push(data);
    return true;
  }

  async remove(key) {
    var ref = this.db.ref(this.path+'/'+key);
    await ref.remove();
    return true;
  }
}

module.exports = DB;
