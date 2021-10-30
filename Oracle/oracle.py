from pycoingecko import CoinGeckoAPI
from web3 import Web3
import json

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))
cg = CoinGeckoAPI()

coin = 'bitcoin'
currency = 'usd'
address = '0x1FA6408a3B2c810aDfD85a0028cDa79288EDdc66'
contract_address = '0x324DB92d73D688e928500B0b07b8cDEb61fC7E16'
abi_path = '/home/petar/Desktop/OracleSmartContract/build/contracts/Oracle.json'

coin_price = cg.get_price(ids=coin, vs_currencies=currency)
price = coin_price[coin][currency]

abi = None
with open(abi_path) as json_file:
        oracle_json = json.load(json_file)
        abi = oracle_json['abi']

contract = w3.eth.contract(address=contract_address, abi=abi)

value = contract.functions.getOraclePrice(price).transact({'from': address})

new_price = contract.functions.getCurrentOraclePrice().call()
print(new_price)
