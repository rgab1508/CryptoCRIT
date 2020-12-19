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
            'genesis_difficulty'
        )
    }

    getLatestBlock(){
        return this.chain[this.chain.length - 1]
    }

    addBlock(newBlock){
        newBlock.prev_hash = this.getLatestBlock().hash
        newBlock.hash = newBlock.calculateHash()
        this.chain.push(newBlock) 
    }

    isChainValid(){
        for(let i=1;i<this.chain.length;i++){
            const currentBlock = this.chain[i]
            const previousBlock = this.chain[i-1]

            if(currentBlock.hash !== currentBlock.calculateHash()){
                return false
            }

            if(currentBlock.prev_hash !== previousBlock.hash){
                return false;
            }
        }
        return true
    }
}

let critCoin = new Blockchain()
critCoin.addBlock(new Block(1,"18/12/2020",{"amount":4},0,0))
critCoin.addBlock(new Block(2,"18/12/2020",{"amount":10},0,0))

console.log("Is chain valid? "+ critCoin.isChainValid())

console.log(JSON.stringify(critCoin, null, 4))

