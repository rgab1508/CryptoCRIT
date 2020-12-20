// TODO Port blockchain class
const Block = require('./block')

class Blockchain{
    constructor(){
        this.chain = [this.genesisBlock()]
    }

    genesisBlock(){
        return new Block(
            0,
            "01/01/2020",
            "genesis_data",
            "<no previous hash>",
            "genesis_hash",
            'genesis_nonce',
            2
        )
    }

    getLatestBlock(){
        return this.chain[this.chain.length - 1]
    }

    addBlock(newBlock){
        newBlock.prevHash = this.getLatestBlock().hash
        newBlock.hash = Block.calculateHash(newBlock.index, newBlock.timestamp, newBlock.data, newBlock.prevHash, newBlock.nonce, newBlock.difficulty);
        this.chain.push(newBlock) 
    }

    isChainValid(){
        for(let i=1;i<this.chain.length;i++){
            const currentBlock = this.chain[i]
            const previousBlock = this.chain[i-1]

            if(currentBlock.hash !== Block.calculateHash(currentBlock.index, currentBlock.timestamp, currentBlock.data, currentBlock.prevHash, currentBlock.nonce, currentBlock.difficulty)){
                return false
            }

            if(currentBlock.prevHash !== previousBlock.hash){
                return false;
            }
        }
        return true
    }
}

function test(){
  let critCoin = new Blockchain()
  critCoin.addBlock(new Block(1,"18/12/2020",{"amount":4},0,0,0))
  critCoin.addBlock(new Block(2,"18/12/2020",{"amount":10},0,0,0))

  //uncomment next line to make chain invalid
  //critCoin.chain[1].data = "bruh";
  console.log("Is chain valid? "+ critCoin.isChainValid())

  console.log(JSON.stringify(critCoin, null, 4))
}

//uncomment next line to test
//test()
