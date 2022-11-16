pragma solidity >=0.5.1 < 0.9.0;

contract solidity_tutorial{

    // Creating a own data type using struct
    struct Person {
        uint _id;
        string _fName;
        string _lName;
    }

    uint256 public peopleCount;

    // Creating a Arrays to store the Persons.
    // Person[] public people;

    // Mapping
    mapping(uint256=>Person) public people;

    // Function to add the Persons
    function addPersons(string memory _firstName, string memory _lastName) public{
        // people.push(Person(_firstName,_lastName));
        people[peopleCount]= Person(peopleCount,_firstName,_lastName);
        peopleCount+=1;

    }


    // string value; //state variable that persist data to the blockchain
    
    // Enums 
    // enum State {Waiting, Ready, Active, Non_Active}
    // State public state;

    // // Function to read value varible from the storage
    // function get() public view returns(string memory){
    //     return value;
    // }

    // // updating state value by local variable
    // function set(string memory _value) public {
    //     value=_value;
    // }

    // setting the default value to state variable using constructor
    constructor() public{
        // value= "Sunny Pajji..!!";
        // state = State.Waiting;
        peopleCount=0;
    }

    // // Function to activate state
    // function Activate()  public {
    //     state = State.Active;
    // }

    // // Function to check the active or not
    // function isActive() public view returns(bool){
    //     return state == State.Active;
    // }

}