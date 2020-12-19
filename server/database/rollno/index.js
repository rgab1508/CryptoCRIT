var firebase = require("firebase-admin");

class Student {
  constructor() {}

  static async getEmailFromRollNumber(rollno) {
    // TODO write logic to fetch student email from database
  }

  static async exists(rollno) {
  	// TODO write logic to check if student exists in the system
  }

  static async isNew(rollno) {
  	// TODO write logic to check if user already exists or not
  }
}
