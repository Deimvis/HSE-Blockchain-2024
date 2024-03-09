from Crypto.Hash import keccak
from web3 import Web3

HACKER_ADDR = '0xADB99998d6eD41b6a09C3155085463f54DE888D2'
MAX_KEY_DATA = 100000

w3 = Web3()
for i in range(MAX_KEY_DATA+1):
    key = keccak.new(data=i.to_bytes(length=32), digest_bits=256)
    addr = w3.eth.account.from_key(key.hexdigest()).address
    # print(addr.lower(), 'vs', HACKER_ADDR.lower())
    if addr.strip().lower() == HACKER_ADDR.strip().lower():
        print(key.hexdigest())
        break

    if i % 1000 == 0:
        print(f'{i} / {MAX_KEY_DATA}')
