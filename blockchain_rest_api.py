
import datetime
import hashlib
import json
from flask import Flask, jsonify



# Class for blockchain
class Blockchain:

    # initilization of blockchain 
    def __init__(self):
        self.chain = []
        self.createBlock(proof=1,prev_hash='0')


    # function to create block 
    def createBlock(self,proof,prev_hash):
        block = {
                 'index' : len(self.chain)+1,
                 'timestamp' : str(datetime.datetime.now()),
                 'proof' : proof,
                 'previous_hash' : prev_hash
                }

        # Appending the block to chain
        self.chain.append(block)
        return block
    
    
    # function to get last block in chain
    def get_prev_block(self):

        return self.chain[-1]

    # function to find the POW(proof of work) for miner
    def proof_of_work(self,prev_proof):
        new_proof = 1
        check_proof = False

        # now iterate each proof to check until it is false
        while(check_proof is False):
            hash_operation = hashlib.sha256(str(new_proof**2 - prev_proof).encode()).hexdigest()

            # defining the condition for minar to check the 
            # intial four digit are 0

            if(hash_operation[:4] == '0000'):
                check_proof = True
            else:
                new_proof += 1
        
        return new_proof


    # defining the function to generate the blocks
    def hash(self, block):
        encode_block = json.dumps(block,sort_keys=True).encode()

        return(hashlib.sha256(encode_block).hexdigest())

    # checkin the valid blocks
    def is_chain_valid(self, chain):
        prev_block = chain[0]

        block_index= 1
        while   block_index < len(chain):
            block = chain[block_index]
            
            if(block['prev_hash'] != self.hash(prev_block)):
                return False
            
            prev_proof = prev_block['proof']
            proof = block['proof']

            # calculating the hash value
            hash_operation = hashlib.sha256(str(proof**2 - prev_proof**2).encode()).hexdigest()

            if(hash_operation[:4] != '0000'):
                return False
            
            prev_block = block
            block_index +=1

        return True

# Mining the blockchain
# Creating the web based flask application

app = Flask(__name__)

# Next we creating the a instance of the blockchain
blockchain = Blockchain()

# Mining a new block
@app.route('/mine_block',methods=['GET','POST'])


def mine_block():
    prev_block = blockchain.get_prev_block()
    prev_proof = prev_block['proof']
    proof = blockchain.proof_of_work(prev_proof)
    prev_hash = blockchain.hash(prev_block)
    block = blockchain.createBlock(proof,prev_hash)

    response = {
        'message' : 'Congratulation! you just mined new block ',
        'index' : block['index'],
        'timestamp' :block['timestamp'],
        'proof' : block['proof'],
        'prev_hash' : block['previous_hash']
    }

    return (jsonify(response),200)


# Printing the entire bockchain
@app.route('/get_chain',methods=['GET'])
def get_chain():

    response = {
        'chain' : blockchain.chain,
        'length' : len(blockchain.chain)
    }

    return(jsonify(response),200)

# Running the app
app.run(host='127.0.0.1',port=5000)
