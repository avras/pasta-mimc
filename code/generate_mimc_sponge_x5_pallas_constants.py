from numpy import zeros
from sage.all import *
from Crypto.Hash import keccak


# For MiMC-Sponge, circomlib uses the following algorithm to generate 218
# round constants
# See https://github.com/iden3/circomlibjs/blob/main/src/mimcsponge.js
#
# prime = 21888242871839275222246405745257275088548364400416034343698204186575808495617
# num_rounds = 2*ceil(log(prime,2)/log(5,2))
#
# SEED = "mimcsponge"
# hash_val = keccak256(SEED)
#
# round_constants[0] = 0
# round_constants[num_rounds-1] = 0
# F = GF(prime)
#
# for i in range(1, num_rounds-1):
#       hash_val = keccak256(hash_val)
#       round_constants[i] = F(hash_val)


# For MiMC over the Pallas curve, we use the same constant generation algorithm with 
# prime value equal to the order of the underlying field. The number of round constants
# is 110.
#
# Pallas curve: y^2 = x^3 + 5  over GF(0x40000000000000000000000000000000224698fc094cf91b992d30ed00000001)
# The order of the Pallas group is 0x40000000000000000000000000000000224698fc0994a8dd8c46eb2100000001
# More info: https://electriccoin.co/blog/the-pasta-curves-for-halo-2-and-beyond/

prime = 0x40000000000000000000000000000000224698fc094cf91b992d30ed00000001
num_rounds = 2*ceil(log(prime,2)/log(5,2))
print('Number of rounds =', num_rounds)

F = GF(prime)
round_constants = [F(0)]

seed_value = b'mimcsponge';
keccak_hash = keccak.new(data=seed_value, digest_bits=256)
hash_val = keccak_hash.digest()

for i in range(1,num_rounds-1):
    keccak_hash = keccak.new(data=hash_val, digest_bits=256)
    hash_val = keccak_hash.digest()
    hash_val_in_hex = keccak_hash.hexdigest()

    field_element = F('0x'+hash_val_in_hex)
    round_constants.append(field_element)
round_constants.append(F(0))

print ('round_constants = [')
for i in range(num_rounds):
    print('   ', hex(round_constants[i])+',')
print(']')