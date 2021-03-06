// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Auction {
  constructor() public {
   owner = msg.sender;
   startTime = block.timestamp;
   endTime = block.timestamp + 1 hours;
   newHouse.houseColor = '#FFFFFF';
   newHouse.houseLocation = 'Lagos, Nigeria';
   newHouse.houseType = 'Duplex';
 
  }

address private owner; 
uint256 public startTime;
uint256 public endTime;
mapping(address => uint) public bids;

struct House {
  string houseType;
  string houseColor;
  string houseLocation;

}

struct HighestBid {
  uint256 bidAmount;
  address bidder;
}

House public newHouse;
HighestBid public highestBid;


//modifers - request access to functions
modifier isOngoing() {
  require(block.timestamp < endTime, 'This auction has closed.');
  _;
}
modifier notOngoing() {
  require(block.timestamp >= endTime, 'This auction is still open.');
  _;
}

modifier isOwner() {
  require(msg.sender == owner, 'Only owner can perform task');
  _;
}

modifier notOwner() {
  require(msg.sender != owner, 'This auction has closed, you are an owner.');
  _;
}

//Events -  Will emitt to the blockchain with contact changes.. this will allow our front end to attach callbacks that would be triggered when the contact state changes

event LogBid(address indexed _highestBidder, uint256 _highestBid);
event LogWithdrawal(address indexed _withdrawer, uint256 amount);




 function makeBid() public payable isOngoing() notOwner() returns (bool) {
   uint256 bidAmount = bids[msg.sender] + msg.value;
   require(bidAmount > highestBid.bidAmount, 'Bid error: Make a higher Bid.');
   

   highestBid.bidder = msg.sender;
   highestBid.bidAmount = bidAmount;
   bids[msg.sender] = bidAmount;
   emit LogBid(msg.sender, bidAmount);
   return true;
 }

 function withdraw() public notOngoing() isOwner() returns (bool) {
   uint256 amount = highestBid.bidAmount;
   bids[highestBid.bidder] = 0;
   highestBid.bidder = address(0);
   highestBid.bidAmount = 0;
 

   (bool success, ) = payable(owner).call{ value: amount }("");
   require(success, 'Withdrawal failed.');
   emit LogWithdrawal(msg.sender, amount);
   return true;
 }

 function fetchHighestBid() public view returns (HighestBid memory) {
   HighestBid memory _highestBid = highestBid;
   return _highestBid;
 }

 function getOwner() public view returns (address) {
   return owner;
 
 }
 
}
  


