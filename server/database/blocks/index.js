require('dotenv').config({path: './../../.env'});

const config = require("./../../config.json");
var DB = require("./../index.js");
var Block = require("./../../blockchain/block.js");

var root = config.blockchain_db;

class Blocks {
  constructor() {}  // TODO create interface to store blocks in firebase database

   static async getLastBlock() {
     var db = new DB(root);
     var block = await db.getLast();
     var { index, timestamp, data, prevHash, hash, nonce, difficulty } = Object.values(block)[0];
     return new Block(index, timestamp, data || "", prevHash, hash, nonce, difficulty);
   } 

   static async add(tdata) {
   	 var db = new DB(root);
   	 await db.transaction((blockchain) => {
   	 	var { index, timestamp, data, prevHash, hash, nonce, difficulty } = Object.values(blockchain).slice(-1)[0];
   	 	var last_block = new Block(index, timestamp, data || "", prevHash, hash, nonce, difficulty);
   	 	var block = Block.mineBlock(last_block,tdata);
   	 	blockchain[block.index] = {
          index: block.index,
          timestamp: block.timestamp,
          data: block.data,
          prevHash: block.prevHash,
          hash: block.hash,
          nonce: block.nonce,
          difficulty: block.difficulty
      }
      return blockchain;
   	})
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
       if (!block.data) continue;
       if (block.data.from_address == public_key) balance -= block.data.amount;
       if (block.data.to_address == public_key) balance += block.data.amount;
     }
     return balance;
   }

   static async getHistoryFromAddress(public_key) {
     var history = [];
     var blockchain = await Blocks.getBlockchain();
     for (var block of blockchain) {
       if (!block.data) continue;
       if (block.data.from_address == public_key) {
         var { to_roll_no, to_address, amount, timestamp } = block.data;
         var type = "send";
         history.push({ type, to_address, amount, timestamp });
       }
       if (block.data.to_address == public_key)  {
         var { from_roll_no, from_address, amount, timestamp } = block.data;
         var type = "receive";
         history.push({ type, from_address, amount, timestamp });
       }
     }
     return history;
   }
}

module.exports = Blocks;