from pycoingecko import CoinGeckoAPI
from web3 import Web3
import json

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))
cg = CoinGeckoAPI()

coin = 'bitcoin'
currency = 'usd'
address = '0xa82C55dBb7AE4BFb3C4053C88D2A57a37775f39C'
contract_address = '0x92f0D6A6e4ff3295a173082d95bC4648b45a3619'#'0x5ceFc6737a6B3637E88D26B2B9d6dDa69A2f5cd2'
#w3.toWei('1', "ether")

coin_price = cg.get_price(ids=coin, vs_currencies=currency)
print(coin_price)

abi = None
with open('/home/petar/Desktop/OracleSmartContract/build/contracts/Oracle.json') as json_file:
        oracle_json = json.load(json_file)
        abi = oracle_json['abi']

contract = w3.eth.contract(address=contract_address, abi=abi)

'''w3.eth.send_transaction({
  'to': contract_address,
  'from': address,
  'value': w3.toWei('1', "ether"),
  'data': f'{coin_price[coin][currency]}'
})'''
price = str(coin_price[coin][currency])
print(type(price))

value = contract.functions.getOraclePrice(price).call()
print(value)
new_price = contract.functions.getCurrentOraclePrice().call()

print(new_price)
