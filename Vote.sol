//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Vote {
    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    // model a voter
    struct Voter{
        bool voted;
        uint targetid;
        uint256 amount;
        address delegator;
    }
    // model a board
    struct Board{
        uint256 totalVotes;
        string name;
    }

    // hoster
    address public host;
    // voter set
    mapping(address => Voter) public voters;
    // board set
    Board[] public board;

    // initialize 
    constructor(string [] memory nameList){
        host = msg.sender;
        voters[host].amount = 1;
        for(uint i = 0; i < nameList.length; i++){
            board.push(Board({
                totalVotes: 0,
                name: nameList[i]
            }));
        }
    }

    function getBoardInfo() public view returns(Board[] memory){
        return board;
    }

    // voting right
    function mandate(address[] calldata addressList) public {
        // only hoster can call this function
        require(msg.sender == host, "Only host has permission");
        for (uint256 i = 0; i < addressList.length; i++){
            if (voters[addressList[i]].voted == false)
                voters[addressList[i]].amount = 1;
        }
    }

    // voting
    function vote(uint256 targetid) public {
        // check if the voter has voted
        require(voters[msg.sender].voted == false, "You have already voted");
        // check if the targetid is valid
        require(targetid < board.length, "Invalid target id");
        // check if the voter has enough votes
        require(voters[msg.sender].amount > 0, "You don't have enough votes");
        // record the vote
        voters[msg.sender].voted = true;
        voters[msg.sender].targetid = targetid;
        // update the vote count
        board[targetid].totalVotes += voters[msg.sender].amount;
        emit voteSuccessfully("Vote successfully");
    }
    
    //delegate
    function delegate(address to) public {
        // check if the voter has voted
        require(voters[msg.sender].voted == false, "You have already voted");
        
        // check if the voter has enough votes
        require(voters[msg.sender].amount > 0, "You don't have enough votes");
        // check if the voter is not delegating to himself
        require(to != msg.sender, "You can't delegate to yourself"); 
        // check if the voter is delegating to the target whose target is the voter
        while (voters[to].delegator != address(0)){
            to = voters[to].delegator;
            require(to != msg.sender, "You can't delegate to the target whose target is you");
            
        }
         // record the vote
        voters[msg.sender].voted = true;
        voters[msg.sender].delegator = to;
        // update the vote count
        if (voters[to].voted == true){
            board[voters[to].targetid].totalVotes += voters[msg.sender].amount;
        }else{
            voters[to].amount += voters[msg.sender].amount;
        }
        emit voteSuccessfully("Delegate successfully");
    }
    event voteSuccessfully(string);
}

// address:
/*
    0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
    ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]
    ["11","22","33"]
*/