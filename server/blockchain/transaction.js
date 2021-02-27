const SHA256 = require("crypto-js/sha256");
const EC = require('elliptic').ec;
const ec = new EC('secp256k1');
const ecc = require('eosjs-ecc');

class Exception {
  constructor(code,message) {
    this.code = code;
    this.message = message;
  }
}

class Transaction {
  constructor(timestamp, from_address, to_address, amount, signature) {
    this.timestamp = timestamp;
    this.from_address = from_address;
    this.to_address = to_address;
    this.amount = amount;
    this.signature = signature;
  }

  calculateHash() {
    console.log(this.timestamp + this.to_address + this.amount);
    return SHA256(this.timestamp + this.to_address + this.amount).toString();
  }

  isValid() {
  	try {
  	  if (!ecc.verify(this.signature,this.calculateHash(),this.from_address)) throw new Exception(401,"Invalid Signature");
  	  if (!Number.isInteger(this.amount)) throw new Exception(400,"Amount should be an Integer");
  	}
  	catch (e) {
  	  throw new Exception(401,"Invalid Signature");
  	}
  }
}

module.exports = Transaction;
