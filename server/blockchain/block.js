// TODO port block class here
const SHA256 = require('crypto-js/sha256')

class Block {
    constructor(index, timestamp, data, prev_hash='', nonce, difficulty){
        this.index = index
        this.timestamp = timestamp
        this.data = data
        this.prev_hash = prev_hash
        this.hash = this.calculateHash()
        this.nonce = nonce 
        this.difficulty = difficulty
    }

    calculateHash(){
        return SHA256(
            this.index +
            this.timestamp +
            JSON.stringify(this.data) + 
            this.prev_hash +
            this.nonce +
            this.difficulty
            ).toString()
    }
}

module.exports = Block

//let block1 = new Block(0,"19/12/2020",{"amount":10},"genesis_hash",0,0)

//console.log(JSON.stringify(block1,null,4))