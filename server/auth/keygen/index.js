// module to generate key pairs

var elliptic = require("elliptic");

const EC = require('elliptic').ec;
const ec = new EC('secp256k1');  // using elliptic library

// keypair class that holds key pairs

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

// keygen class to generate key pair

class keygen {
  constructor() {}

  static generateKeyPair() {
    const key = ec.genKeyPair();
    var public_key = key.getPublic('hex');  // hex encoded public key
    var private_key = key.getPrivate('hex');  // hex encoded private key
    return new keypair(public_key,private_key);  // return new keypair
  }
}

module.exports = keygen;  // keygen class exported
