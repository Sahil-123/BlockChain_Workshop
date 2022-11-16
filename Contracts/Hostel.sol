pragma solidity >=0.5.1 < 0.9.0;

contract Hostel{
    address tenant;
    address landord;

    // create unsigned integers of type public for noOfRooms, noOfAgreement, noOfRent
    uint256 public no_of_rooms = 0;
    uint256 public no_of_agreement = 0;
    uint256 public no_of_rent = 0;

    // Creating a structure for the hostel room
    struct Room{
        // defining the attributes
        uint256 roomid;
        uint256 agreementid;
        string roomname;
        string roomaddress;
        uint256 rent_per_month;
        uint256 security_deposite;
        uint256 timestamp;
        bool vacant;
        address payable landlord;
        address payable currentTenant;
    }

    // map the structure with the id
    mapping(uint256=>Room) public RoomsByNumber;


    // Creating the structure for the agreements
    struct RoomAgreement{
        // defining the attributes
        uint256 roomid;
        uint256 agreementid;
        string roomname;
        string roomaddress;
        uint256 rent_per_month;
        uint256 security_deposite;
        uint256 locking_period;
        uint256 timestamp;
        address payable landordAddress;
        address payable tenantAddress;
    }

    // Creating the map room agreement by number
    mapping(uint256=>RoomAgreement) public RagreementNo;

    // Creating the strtructure for the room rent
     struct Rent{
        // defining the attributes
        uint256 rentNo;
        uint256 roomid;
        uint256 agreementid;
        string roomname;
        string roomaddress;
        uint256 rent_per_month;
        uint256 timestamp;
        address payable landordAddress;
        address payable tenantAddress;
    }

    // Creating the map to structure with id
    mapping(uint256 => Rent) public RentByNo;


    // Lets create a modfier that will verify few condtions
    modifier onlyLandlord(uint256 _index){

        require(msg.sender == RoomsByNumber[ _index].landlord,"Only Landlord can access this");
        _;
    }


    // check for the not landlord
    modifier notLandLord(uint256 _index){
        
         require(msg.sender != RoomsByNumber[ _index].landlord,"Only Tenant can access this");
         _;
    }

    // Check room is vacant 
    modifier onlyWhileVacant(uint256 _index){
         require(RoomsByNumber[_index].vacant == true,"Room is Current Occupied");
         _;
    }

    // Checking the tenant wheather the tenant have enough rent to pay
    modifier enoughRent(uint256 _index){
        require(msg.value >= uint256(RoomsByNumber[_index].rent_per_month),"Not Enough ethers in your wallete");
        _;
    }

    // Check whether the tenant has enough balance to pay on-time security deposite
    modifier enoughAgreementFee(uint256 _index){
        require(msg.value >= uint256(RoomsByNumber[_index].rent_per_month) + uint256(RoomsByNumber[_index].security_deposite),"Not Enough Ether in your Wallete to pay agreement Fee!");
        _;
    }

    // Checking the address of the tenant who has signed the agreement is same of not
    modifier sameTenant(uint256 _index){
        require(msg.sender == RoomsByNumber[_index].currentTenant,"No Previous agreement found with you and landlord");
        _;
    }
    
    // check whether any Time Left for the agreement 
    modifier agreementTimeLeft(uint256 _index){
        uint256 agreementNo = RoomsByNumber[_index].agreementid;
        uint256 time = RagreementNo[agreementNo].locking_period;

        require(block.timestamp < time,"Agreement already ended");
        _;
    }

    // Check whether agreement period lapsed
    modifier AgreementTimeLapsed(uint256 _index){
        uint256 agreementNo = RoomsByNumber[_index].agreementid;
        uint256 time = RagreementNo[agreementNo].locking_period;

        require(block.timestamp > time,"Agreement has not yet lapsed!");
        _;
    }

    // Lets check foe the new month
     modifier RentTimeUp(uint256 _index){
        uint256 time = RoomsByNumber[_index].timestamp + 30 days;
        require(block.timestamp >= time,"Agreement has not yet lapsed!");
        _;
    }

    // Lets write some Functions

    // Function to add Rooms
    function addRoom(string memory _roomname,string memory _roomaddress, uint256 _rentcost, uint256 _securitydeposite) public {
        require(msg.sender != address(0));
        no_of_rooms ++;
        bool _vacancy = true;
        RoomsByNumber[no_of_rooms] = Room( no_of_rooms, 0, _roomname,_roomaddress,_rentcost,_securitydeposite, 0, _vacancy, msg.sender, address(0));

    }

    // Function to sign rental agreement
    function signAgreement(uint256 _index) public payable notLandLord(_index) enoughAgreementFee(_index) onlyWhileVacant(_index){
        require(msg.sender != address(0));
        address payable _landlord = RoomsByNumber[_index].landlord;
        uint256 totalFee = RoomsByNumber[_index].rent_per_month +RoomsByNumber[_index].security_deposite;
        _landlord.transfer(totalFee);

        no_of_agreement++;
        RoomsByNumber[_index].currentTenant = msg.sender;
        RoomsByNumber[_index].vacant = false;
        RoomsByNumber[_index].timestamp = block.timestamp;
        RoomsByNumber[_index].agreementid = no_of_agreement;
        RagreementNo[no_of_agreement] = RoomAgreement(_index,no_of_agreement,
                                        RoomsByNumber[_index].roomname,
                                        RoomsByNumber[_index].roomaddress,
                                        RoomsByNumber[_index].rent_per_month,
                                        RoomsByNumber[_index].security_deposite,
                                        365 days,
                                        block.timestamp,
                                        msg.sender,
                                        _landlord
                                        );
        no_of_rent++;
        RentByNo[no_of_rent] = Rent(
                                    no_of_rent,
                                    _index,
                                    no_of_agreement,
                                    RoomsByNumber[_index].roomname,
                                    RoomsByNumber[_index].roomaddress,
                                    RoomsByNumber[_index].rent_per_month,
                                    block.timestamp,
                                    msg.sender,
                                    _landlord

        );
    }


    // Function to pay rent
    function payRent(uint256 _index) public payable sameTenant(_index) 
                                                    RentTimeUp(_index)
                                                    enoughRent(_index)
    {
        require(msg.sender != address(0));
        address payable _landlord = RoomsByNumber[_index].landlord;

        uint256 _rent = RoomsByNumber[_index].rent_per_month;

        _landlord.transfer(_rent);

        RoomsByNumber[_index].currentTenant = msg.sender;
        RoomsByNumber[_index].vacant = false;
        no_of_rent++;

        RentByNo[no_of_rent] = Rent(
                                    
                                    no_of_rent,
                                    _index,
                                    RoomsByNumber[_index].agreementid,
                                    RoomsByNumber[_index].roomname,
                                    RoomsByNumber[_index].roomaddress,
                                    _rent,
                                    block.timestamp,
                                    msg.sender,
                                    RoomsByNumber[_index].landlord
        );


    }


    // Function to mark agreement as complete
    function agreementCompleted(uint256 _index) public payable onlyLandlord(_index) 
                                                               AgreementTimeLapsed(_index)
                                                               {

        require(msg.sender != address(0));
        require(RoomsByNumber[_index].vacant == false, " Room is Currently Occupied");

        RoomsByNumber[_index].vacant = true;
        address payable _tenant = RoomsByNumber[_index].currentTenant;
        uint256 _securitydeposite = RoomsByNumber[_index].security_deposite;
        _tenant.transfer(_securitydeposite);    
    }

    // Function to Terminate the agreement
    function agreementTerminated(uint256 _index) public
        onlyLandlord(_index)
        agreementTimeLeft(_index)
        {
            require(msg.sender != address(0));
            RoomsByNumber[_index].vacant = true;
        }


}