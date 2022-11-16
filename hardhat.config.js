require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */

// require('nomiclabs/hardhat-waffle');

const API_URL='HTTP://127.0.0.1:7545';
const PRIVATE_KEY = '8cde02c3f978bce872279fd4eb919c6cd966c24bc21a1073c23f0d463c1d9e48';

module.exports = {
  solidity: "0.8.17",
  networks : {
    testnet : {
      url : API_URL,
      account : [`${PRIVATE_KEY}`]
    }
  }
};
