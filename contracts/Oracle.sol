// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import {SafeMath} from "./SafeMath.sol";
contract Oracle {
	using SafeMath for uint256;
	uint64 private id = 0;
	// uint256 win = bet + ((bet/your_team_bets) * other_team_bets);
	address private owner;
	uint256 minimumBet = 1000000000000000000;


	struct Team{
		uint64 id;
		bytes32 name;
		uint256 betAmount;
		bytes32 betRuleDescription;
		uint256 priceTarget;
	}
	struct Player { 
		uint256 bet;
		uint64 teamId;
	}


	Team[] public teams;
	address[] public players;
	mapping(address => Player) public playerInfo;


	uint256 public currentOraclePrice = 110;

	constructor() {
		owner = msg.sender;
	}
	function getCurrentOraclePrice() public view returns(uint256) { return currentOraclePrice; }

	modifier ownable() {
        require(owner == msg.sender);
        _;
    }
	function createTeam(bytes32 _name, bytes32 _description, uint256 _target) public ownable returns(bool){
		teams.push(Team(id, _name, 0, _description, _target));
		id +=1;
		return true;
	}
	function getOraclePrice(string memory _price) public pure returns(string memory){
		//currentOraclePrice = _price;
		return _price;
	}
	function bet() public payable returns(bool){
		return true;
	}
}
