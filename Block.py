# Time stamp for the block is required so import datetime
import datetime

# To keep track the hash value we use the hashlib 
import hashlib

class Block:
    blockNo = 0  # Block number which represent the number ID
    data = None  
    next = None
    hash = None
    nonce = 0
    previous_Hash = 0x0
    timestamp = datetime.datetime.now()

    # Initializing the block with given paremeters
    def __init__(self,data):  
        self.data=data
    
    # Generating the hashing value to the block which in 256 bit long
    def hash(self):
        h = hashlib.sha256()

        # creating or updating the hashvalue with given data like given below
        h.update(
            str(self.nonce).encode('utf-8')+
            str(self.data).encode('utf-8')+
            str(self.previous_Hash).encode('utf-8')+
            str(self.timestamp).encode('utf-8')+
            str(self.blockNo).encode('utf-8')
        )

        # returning the generated hash value
        return h.hexdigest()

    # Displaying the data in the form of the steing
    def __str__(self):
        return ("***************************\n "+
        "Block hash : "+str(self.hash())+ 
        "\n Block No :" + str(self.blockNo)+ 
        "\n Data :"  + str(self.data)+ 
        "\n Nonce :"+str(self.nonce)+
        "\n********************************* \n "
        )



class BlockChain:

    diff =20
    maxNonce = 2**32
    target = 2**(256-diff)

    block = Block("Genesis")
    dummy = head = block

    # Blocks insertion Function
    def add( self, block):
        block.previous_Hash= self.block.hash()
        block.blockNo=self.block.blockNo+1
        self.block.next = block
        self.block = self.block.next

    # Block Mining function to mine a block
    def mine(self, block):

        # checking and creating the nonce value for the block to add into the chain
        for n in range(self.maxNonce):
            if(int(block.hash(),16) <= self.target):
                self.add(block)
                print(block)
                break

            else:
                block.nonce +=1



# ----------------------------------Main-----------------------------------------

# Initializing the blockchain
blockchain = BlockChain()

# Adding 10 dummy data
for i in range(2**5):
    blockchain.mine(Block("Block "+str(i+1)))

# Printing the each block data
while(blockchain.head != None):
    print(blockchain.head)
    blockchain.head = blockchain.head.next




