require('dotenv').config({path: './../../.env'});

var DB = require("./../index.js");
var Block = require("./../../blockchain/block.js");

var root = "cryptocrit/blockchain"

class Blocks {
  constructor() {}  // TODO create interface to store blocks in firebase database

   static async getLastBlock() {
     var db = new DB(root);
     var block = await db.getLast();
     var { index, timestamp, data, prevHash, hash, nonce, difficulty } = Object.values(block)[0];
     return new Block(index, timestamp, data || "", prevHash, hash, nonce, difficulty);
   } 

   static async add(data) {
     var last_block = await Blocks.getLastBlock();
     var block = Block.mineBlock(last_block,data);
     var db = new DB(root);
     await db.push({
       index: block.index,
       timestamp: block.timestamp,
       data: block.data,
       prevHash: block.prevHash,
       hash: block.hash,
       nonce: block.nonce,
       difficulty: block.difficulty
     });
     return true;
   }

   static async getBlockchain() {
     var block_root = "cryptocrit/blockchain";
     var db = new DB(block_root);
     var blockchain = await db.read("");
     return Object.values(blockchain);
   }

   static async getBalanceFromAddress(public_key) {
     var balance = 0;
     var blockchain = await Blocks.getBlockchain();
     for (var block of blockchain) {
     	console.log(block);
       if (!block.data) continue;
       if (block.data.from_address == public_key) balance -= block.data.amount;
       if (block.data.to_address == public_key) balance += block.data.amount;
     }
     return balance;
   }
}

module.exports = Blocks;
