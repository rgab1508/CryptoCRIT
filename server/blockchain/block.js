// TODO port block class here
const SHA256 = require('crypto-js/sha256')

const config = require("./../config.json");

//TODO put this in config file
// const MILLISEC = 1;
// const SEC = 1000 * MILLISEC;
// const MINE_RATE = 4 * SEC;

const MINE_RATE = config.mine_rate;

function hexToBin(hexStr){
  
  //TODO move hexToBin in utils
  const HEX_TO_BIN_CONVERSION_TABLE = {
    '0':'0000',
    '1':'0001',
    '2':'0010',
    '3':'0011',
    '4':'0100',
    '5':'0101',
    '6':'0110',
    '7':'0111',
    '8':'1000',
    '9':'1001',
    'a':'1010',
    'b':'1011',
    'c':'1100',
    'd':'1101',
    'e':'1110',
    'f':'1111',
  }
  
  let binStr = "";
  for(let i=0;i<hexStr.length;i++){
    binStr += HEX_TO_BIN_CONVERSION_TABLE[hexStr[i]];  
  }

  return binStr;
}

class Block {
    constructor(index, timestamp, data, prevHash, hash, nonce, difficulty){
        this.index = index
        this.timestamp = timestamp;
        this.data = data;
        this.prevHash = prevHash;
        this.hash = hash;
        this.nonce = nonce;
        this.difficulty = difficulty;
    }

    static calculateHash(index, timestamp, data, prevHash, nonce, difficulty){
        return SHA256(
            index +
            timestamp +
            JSON.stringify(data) +
            prevHash +
            nonce +
            difficulty
          ).toString();
    }

    static genesis(){
      let index = 0;
      let timestamp = 1;
      let prevHash = "genesis_last_hash";
      let hash = "genesis_hash";
      let data = [];
      let difficulty = 3;
      let nonce = "genesis_nonce";
      return new Block(index, timestamp, data, prevHash, hash,  nonce, difficulty);
    } 

    static mineBlock(lastBlock, data){
      let index = lastBlock.index + 1;
      let timestamp = new Date().getTime();
      let prevHash = lastBlock.hash;
      let difficulty = Block.adjustDiff(lastBlock, timestamp);
      let nonce = 0;
      let hash = Block.calculateHash(index, timestamp, data, prevHash, nonce, difficulty);

      while (hexToBin(hash).slice(0, difficulty) != "0".repeat(difficulty)){
        nonce += 1;
        timestamp = new Date().getTime();
        difficulty = Block.adjustDiff(lastBlock, timestamp);
        hash = Block.calculateHash(index, timestamp, data, prevHash, nonce, difficulty);
      }

      return new Block(index, timestamp, data, prevHash, hash,nonce, difficulty);
    }
    
    static adjustDiff(lastBlock, new_timestamp){
      if((new_timestamp - lastBlock.timestamp) < MINE_RATE){
        return lastBlock.difficulty + 1;
      }
      else if((lastBlock.difficulty - 1) > 0) {
        return lastBlock.difficulty - 1;
      }
      else {
        return 1;
      }
    }

    static isBlockValid(lastBlock, block){
      let reHash = Block.calculateHash(block.index, block.timestamp, block.data, block.prevHash, block.nonce, block.difficulty);
      console.log(block);
      if(block.prevHash != lastBlock.hash){
        console.log("PrevHas not equal to lastblocks's hash");
        return false;
      }else if(hexToBin(block.hash).slice(0, block.difficulty) != "0".repeat(block.difficulty)){
        console.log("PoW not meet")
        return false;
      }else if(Math.abs(lastBlock.difficulty - block.difficulty) > 1){
        console.log("difference in difficulty more than 1")
        return false;
      }
      else if(reHash != block.hash){
        console.log("Block Hash is different");
        return false;
      }

      return true;
    }
}

module.exports = Block

function test(){
  let gen_block = Block.genesis();
  console.log(gen_block);
  let g_block = Block.mineBlock(gen_block, "bruhhhh")
  //console.log(g_block);
  //uncomment next line to make block invalid
  //g_block.data = "nobruhh";
  if(Block.isBlockValid(gen_block, g_block)){
    console.log("valid");
  }else{
    console.log("not valid")
  }
}

//uncomment the next line to Test
//test();
