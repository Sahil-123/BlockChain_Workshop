Block.py is my first blockchain file

npm install --save-dev @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers eth


to run deploy file
npx hardhat run script/deploy.js --network mainnet 



/** @type import('hardhat/config').HardhatUserConfig */

require('nomiclabs/hardhat-waffle');
const API_URL='https://mainnet.infura.io/v3/8983abc6574c459499df3ecfe8d693b5';
const PRIVATE_KEY = "0x8B8979B6580F1c0797c6B9AFE6cAA22DF8417460";

module.exports = {
  solidity: "0.8.17",
  networks : {
    mainnet : {
      url : API_URL,
      account : [`0x${PRIVATE_KEY}`]
    }
  }
};

