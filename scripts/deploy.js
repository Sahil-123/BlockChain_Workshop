// const { ethers } = require("hardhat");

async function main(){

    // not necessary but just to see the account deploying from
    const [deployer] = await ethers.getSigners()
    console.log("Deploying contract with the account "+deployer.address);
    
    // Main Stuff
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
    

    const balance = await deployer.getBalance();
    console.log("Account Balance : "+balance.toString());

    console.log("Deployement Address: "+token.address);
    
}

main()
.then(()=>process.exit(0))
.catch((e)=>{
    console.log(e);
    process.exit(1);
})