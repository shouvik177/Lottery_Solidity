
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Lottery{
    address public manager;
    address payable [] public players; // too many players , array
    constructor(){
        manager=msg.sender;
    }
    function alreadyEntered()view private returns (bool){
        for(uint i=0;i<players.length;i++){
            if(players[i]==msg.sender){
                return true;
            }
            return false;
        }
    }
    function Entry()payable public{
    require(msg.sender!=manager,"Sorry Manager, You cannot enter in this game");
    require(alreadyEntered()==false,"You have already entered");
    require(msg.value>=1 ether,"Minium 1 Eather must be pay");
    players.push(payable(msg.sender)); //
    }
    function Random()view private returns(uint){
         return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
    }
    function pickWinner()public{
        require(msg.sender==manager,"Only Manager can pick winner");
        uint index=Random()%players.length;
        address contractAddress=address(this);
        players[index].transfer(contractAddress.balance);
        players=new address payable[](0); //reset
    }
    function getPlayers()view public returns(address payable[]memory){
        return players;
    }
}
