// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import {SafeMath} from "./SafeMath.sol";
contract Oracle {
	using SafeMath for uint256;
	uint256 private id = 0;
	address payable private owner;
	address private oracleAddress = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;//0x1FA6408a3B2c810aDfD85a0028cDa79288EDdc66;

	uint256 private constant minimumBet = 10 ** 18;
	uint256 private allBetsAmount = 0;

	enum TeamState{
		STARTED,
		ENDED
	}
	struct Team{
		uint256 id;
		string name;
		uint256 betAmount;
		string betRuleDescription;
		uint256 priceTarget;
		TeamState teamState;
	}
	struct Player { 
		uint256 bet;
		uint256 teamId;
	}

	Team[] private teams;
	address payable [] private players;
	mapping(address => Player) private playerInfo;

	uint256 private currentOraclePrice;

	constructor() {
		owner = payable(msg.sender);
	}
	
	event Transfer(address payable _address, uint256 _amount);
	
	function getOraclePrice() public view returns(uint256) { return currentOraclePrice; }
    function getAllBetsAmount() public view returns(uint256) { return allBetsAmount; }

	modifier ownable() {
        require(owner == msg.sender);
        _;
    }

	modifier oracleable() {
        require(oracleAddress == msg.sender);
        _;
    }
	function createTeam(string memory _name, string memory _description, uint256 _target) public ownable returns(bool){
		teams.push(Team(id, _name, 0, _description, _target, TeamState.STARTED));
		id +=1;
		return true;
	}
	function setOraclePrice(uint256 _price) public payable oracleable returns(uint){
		currentOraclePrice = _price;
		return currentOraclePrice;
	}
	
	function transferToAddress(address payable _address, uint256 _amount) external payable{
        _address.transfer(_amount);
	}
	
	//#TODO Business logic will be great to implement
	//For now you could fund conrtact with 1-2 ether so everythink could work properly
	function fundContract() public payable{
	    
	}
	
	function bet(uint256 _teamId) public payable returns(bool){
		require(msg.value >= minimumBet);
		players.push(payable(msg.sender));
		playerInfo[msg.sender] = Player(msg.value, _teamId);
		teams[_teamId].betAmount = teams[_teamId].betAmount.add(msg.value);
		allBetsAmount = allBetsAmount.add(msg.value);
		return true;
	}
	function calculateProfit(uint256 _bet, uint256 _teamBets, uint256 _allBetsAmount) private pure returns(uint256){
		uint256 otherTeamsBet = _allBetsAmount.sub(_teamBets);
		uint256 playerProfit = otherTeamsBet.div(_teamBets).mul(_bet);
		uint256 win = _bet.add(playerProfit);
		return uint256(win);
	}
	function getWinId(uint256 _price) private view returns(uint256){
	    uint256 minDiff = 1000000000000000000;
		uint256 winID = 10 ** 20;
		for(uint i = 0; i < id; i++){
			if(teams[i].teamState == TeamState.STARTED){
				teams[i].teamState == TeamState.ENDED;
				if(teams[i].priceTarget <= _price){
					uint256 newDiff = _price.sub(teams[i].priceTarget);
					if (minDiff > newDiff){
						winID = i;
						minDiff = newDiff; 
					}
				}
			}
		}
		return winID;
	}
	function executeBets() public ownable payable{
	    uint _price = getOraclePrice();
	    uint256 winID = getWinId(_price);
		for(uint i = 0; i < players.length; i++){
			if(playerInfo[players[i]].teamId == winID){
				uint256 playerProfit = calculateProfit(playerInfo[players[i]].bet, teams[winID].betAmount, allBetsAmount);
				//#TODO Warning If your try to send ether when the amount is equal or bigger than contract address balance you will get revert  
				bool sent = sendFromContractEther(players[i], playerProfit);
				if(sent){
				    emit Transfer(players[i], playerProfit);
				}
			}
			delete playerInfo[players[i]];
			delete players[i];
 		}
		allBetsAmount = 0;
	}
	
	function getTeamBetAmount(uint256 _teamId) public view returns(uint){
		return teams[_teamId].betAmount;
	}
	function sendFromContractEther(address payable _address, uint _amount) private returns(bool){
	    require(_amount <= address(this).balance);
        bool sent = _address.send(_amount);
        require(sent, "Failed to send Ether");
        return sent;
	}
}
