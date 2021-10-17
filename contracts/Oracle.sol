// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import {SafeMath} from "./SafeMath.sol";
contract Oracle {
	using SafeMath for uint256;
	uint64 private id = 0;
	// uint256 win = bet + ((bet/your_team_bets) * other_team_bets);
	address private owner;
	address private oracleAddress = 0xAE9c3fAD07115f7cc0ca53CEEA4f137e6e923729;

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


	uint256 public currentOraclePrice = 0;

	constructor() {
		owner = msg.sender;
	}

	modifier ownable() {
        require(owner == msg.sender);
        _;
    }

	modifier oracleable() {
        require(oracleAddress == msg.sender);
        _;
    }
	function createTeam(bytes32 _name, bytes32 _description, uint256 _target) public ownable returns(bool){
		teams.push(Team(id, _name, 0, _description, _target));
		id +=1;
		return true;
	}
	function getOraclePrice(uint256 _price) public payable oracleable returns(bool){
		_price = uint(bytes32(msg.data));
		currentOraclePrice = _price;
		return true;
	}
	function bet() public payable returns(bool){
		return true;
	}
}
