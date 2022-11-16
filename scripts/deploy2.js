// const {ethers} = require("hardhat");

async function main() {
    // Not Necessary, but just to see the account deployement
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contract with the account " + deployer.address);

    const balance = await deployer.getBalance();
    console.log("Account Balance: " + balance.toString());
    //Main Stuff
    const Token = await ethers.getContractFactory("Token")
    const token = await Token.deploy();

    console.log("Deployment Address: " + token.address);
}
main()
.then(() =>process.exit[0])
.catch((e) => {
    console.log(e);
    process.exit(1);
}
);
