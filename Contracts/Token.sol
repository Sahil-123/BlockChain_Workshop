pragma solidity ^0.8.7;


contract Token {

    string public name="Azmat Bagwan";
    address public owner;
    uint public totalSupply = 1000000;
    mapping(address=>uint) balance;

    // Constructor
    constructor(){
        owner = msg.sender;
        balance[msg.sender] = totalSupply;
    }

    function transfer(address to,uint amount) external {
        require(balance[msg.sender] >= amount,"Not enough funds to transfer");
        balance[msg.sender] -= amount;
        balance[to] +=amount;
    }

    // Function to print balance of the account
    function balanceOf(address account) external view returns(uint){
        return balance[account];
    }





}