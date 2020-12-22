const EC = require('elliptic').ec;
const ec = new EC('secp256k1');
const Blocks = require('./../database/blocks');

class Exception {
  constructor(code,message) {
    this.code = code;
    this.message = message;
  }
}

class Transaction {
  constructor(from_adress, to_address, amount, signature) {
    this.from_adress = from_address;
    this.to_address = to_address;
    this.amount = amount;
    this.signature = signature;
  }

  isValid() {
    var publicKey = ec.keyFromPublic(this.from_address,'hex');
    if (!publicKey.verify()) throw new Exception(401,"Invalid Signature");
    if (!Number.isInteger(this.amount)) throw new Exception(400,"Amount should be an Integer");
    //var balance = Blocks.getBalanceFromAddress(this.from_address);
    //if (amount > balance) throw new Exception(400,"Transaction amount is greater than balance");
  }
}

module.exports = Transaction;