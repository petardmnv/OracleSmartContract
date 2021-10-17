from pycoingecko import CoinGeckoAPI
from web3 import Web3
import json

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))
cg = CoinGeckoAPI()

coin = 'bitcoin'
currency = 'usd'
address = '0xAE9c3fAD07115f7cc0ca53CEEA4f137e6e923729'
contract_address = '0xe3Efec6CDD038c94e54801Ad6eC21672EBe33662'#'0x5ceFc6737a6B3637E88D26B2B9d6dDa69A2f5cd2'
#w3.toWei('1', "ether")

coin_price = cg.get_price(ids=coin, vs_currencies=currency)
print(coin_price)

abi = None
with open('abi.json') as json_file:
        abi = json.load(json_file)

contract = w3.eth.contract(address=contract_address, abi=abi)

'''w3.eth.send_transaction({
  'to': contract_address,
  'from': address,
  'value': w3.toWei('1', "ether"),
  'data': f'{coin_price[coin][currency]}'
})'''

value = contract.functions.getOraclePrice({coin_price[coin][currency]}).buildTransaction()

print(value)