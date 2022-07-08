#!/usr/bin/env sage

# Vesta curve: y^2 = x^3 + 5  over GF(0x40000000000000000000000000000000224698fc0994a8dd8c46eb2100000001)
# The order of the Vesta group is 0x40000000000000000000000000000000224698fc094cf91b992d30ed00000001
# More info: https://electriccoin.co/blog/the-pasta-curves-for-halo-2-and-beyond/

num_rounds = 110
prime = 0x40000000000000000000000000000000224698fc0994a8dd8c46eb2100000001
n = len(format(prime, 'b'))
F = GF(prime)

# In GF(p), the MiMC round function is of the form x^s where gcd(p-1,s) = 1
# Also, s should be as small as possible while being greater than 1
# gcd(prime-1,3) = 3
# gcd(prime-1,5) = 1
# So we use s = 5

# As per Section 5.1 of https://eprint.iacr.org/2016/492.pdf, the
# suggested number of MiMC rounds is ceil(log(prime,2)/log(s,2)).
# For the Pallas curve with s=5, this is 110. 
# By convention, the first round constant is 0.
# For the algorithm used to generate the other constants, see
# the file generate_mimc_x5_vesta_constants.py in this repository.

round_constants = [
    0x0000000000000000000000000000000000000000000000000000000000000000,
    0x0ef758973a8cabb7492f4d05f39a1b93979c7383eddbad449dee819dc70a98e5,
    0x02885e3a7813b2259da69bc36657e8bc0433608b114b9ab3985087834281d349,
    0x2399e58dcea3077e6d1c08044780913fb10bc2e026eb42a873fbf2075edb4ad9,
    0x23d273ec3d199e351a406dac488fbc7e1fad914b4e0d2ccff7e49ef85cb6928d,
    0x3a14e37902fca6e97c891080d2e5da41ef472ea88285bb2944f0fb91d4798bd9,
    0x07398333d08c0d67b82b09f3bae043e1eb6d4969c036f985e39731f6675a631a,
    0x09219c213265f3b58b4952f83d333b8db89577b814c5627df756e76c22534be5,
    0x392c4e4b3997f23536d9a245812da66d0ed85e2921eb75bc99534dd0fb5607fc,
    0x160ae58d7e5dbe13abc47d4410e2a18821c113b1f4e53e5b23dece400a747512,
    0x1b605f2a033bbd5f4ae9034a44b14b0fe2b456a8344f9f4234c5ac371b50f56f,
    0x2d013c59b0bb60afc36ff4919346f24b762473f40e8307114c12a0bdac02c673,
    0x2bed8c2bdcd52f2cae73f1a1329f55a8e995d41f443e900cfd5238cea0666ba5,
    0x05d1e0ac576d1ec814b621516339ae1a291c7df36b5fd6cf0b4e3c9cd25e3072,
    0x3849e751322c2535825f4f50ecf9d117911ce8e29a13ac2e9c72875c090bc510,
    0x196309f1d170d741ab1ce90c39772017fb7cdec78c37882b98a6b56956c13def,
    0x23a8fc6f690aa0b9a85e54650210244f3d07b5c2c327a53947d713c0f1e9e4f6,
    0x3cc814ea4149bd8c15f067c1129cdc5aad84802fb7147aa4165f10b3129826f6,
    0x38bd64ba20de36cd8b1acbbc153e92fd680bdd180bf486db6592630722c53e9c,
    0x1470b297263c701dbd3de0a18b97cd27ce965e1a3f5baa0204dabb3851cebba6,
    0x2bd4cdc962e3da62cb3c96f7c428a9b0d518bfa7ce26f8fce7a6af769afb6540,
    0x361abedd23809ec1edbd0a25cb6740b27c0b88818ad3cd0402e78a36ecabfe59,
    0x1e719f9e471c9c5c5525e61c5fd9122523e6a17241798dd7e283d14b0e3c7d16,
    0x18053e9f0d45f9eefbda135bfd39329e34837e633565c314fb9030b9db7381bb,
    0x275ce5dfe5a86c3b7a5239e30b7081c8e12d1234b4c755a082d32d3b0f9c5a9f,
    0x399472814762e714c63982b48395476c35c928bdebe276e77a08900d542b715b,
    0x3aadfd9e9f435085887aaf5afc9d05b849a428c353da84c04ac6d69dce88a1b7,
    0x03279d5e9bd83cf67bb96f9f76283c6477cea34be7b9055913ead2d3437b733a,
    0x32836dead1465663cf48597615479fb5a2026d73ca9bfb986ceca60d5ce5dbca,
    0x369c71c71b05b227ce508f275fb711d148d50f6edc5f7dd56d7cddb47d24a867,
    0x353e118c3601dcdd51eb0121238d143588372789d774182e2160c04e40449218,
    0x0d56329982f3df38a3f19fb814c3013f419ba0eb8403b27c0c0e75c6fe1cf468,
    0x2093294bfb03169c1d84583e4f42f7e7e8eaff39bbd1e144412aca4479692e8b,
    0x00c0a0cad932f2a819007bd28188b3b77fc02bb491fd68d9452b794743c7e7be,
    0x24a3ed3fce960bb53aaa1ef6c51abed6b1a3b749077e25c9d40466e624c6307a,
    0x02c735abd4bf56f155751f28f4159a79df4849716494d3c6db468e36906ace32,
    0x0ee68c3e38c194033994c0d4d7bde35bfafa35b22a95f915f82c5a3b0422bd9a,
    0x0faddf61946f884c4391360b671ca84c7697742f30cdb8925483ec65e77e6902,
    0x0eb87ba4b3d521a2e65ad7f845e381ff35c68770b408eb549bb4db71a58656af,
    0x3c07ed74275c56d187b25f08f6b12641aeabc03ba7adef25528eea293c5ef633,
    0x2b5144d110de00a827fed745247960d149f1142739ac2b2df6b887bddfcaf88c,
    0x1c8eebe1fef58743a240a03faf9f1ee76e7fc371b48ea1e9e4777f7bce1a50b9,
    0x3cf3250a5bf2539c8bc39817165852a56d3b3e4036c05c44c2c0bce702d68a13,
    0x1aee420145726e8dc9774a21e95a3e72f73253239d9b86f027d50c44363a8445,
    0x287dd94092802f5aa12987a330f12e218813e5d00713e693ed8629813ca87869,
    0x2cf601ee0e4e12fab3b1e75235a0051300b9399d094dd5f13ce2c42d31f9be2c,
    0x29c177f908149788df74e085786f9fea170983c9c8c96bded1ccb30be43993fc,
    0x2ce861dd4efb6af7f2121e4cead434d725ebadfae8404c63d49c5845d4efc5e6,
    0x287f07fe1d34c367abb74d2e118c6ccd22cf767cca411956871ac17a5b53f6b5,
    0x05991f171b6c36e341e0ba5381279de80c5c799377807a04fc587aef32096bd6,
    0x3b056e3b729fbd873d22ae369a44fc7b6e8b1a82a929c2ea6046e58a0bdace92,
    0x296255b5e697e517c502ba49b18aaad89514a490a02e7a878b5d559841b93fbd,
    0x18d96f4b9ee595cc96032f2dbf6b2678c4f03c17c1c5b17dd1fbdb6613da79a8,
    0x1daf4d4a883a85c0e6d51d1caab084e1224ad4bd06353c89526eff918369a597,
    0x0c72feda25fb2697df6d185100994f866ae8098940ad81122b77d91082c79ba6,
    0x379d49d6f2b88854af9de8aa37d7ac0fec30f0a90f8db7062eabfe9055d34d46,
    0x04e674d88b90b1188353106ae25c0447acace9dc6d62cfe7fec2d7993dfd7a22,
    0x1f201eb644d4d4ec8dfa30bae199819d582973b14d92d9b45c3e4f72669d7e0a,
    0x1e64449e73b48c2f6a4a89fe1beff648ef99b26483f778c1fc54eb7109e4d4ee,
    0x395130bbdf4e81f728a6df6c4e8921ee145b5a64251326e8fef583dc6ee6694e,
    0x0ce35503786afaca4c97aab5782f3625fd5da2e2620d46396c67c65f8078f571,
    0x33d3f7c6ec7eaf05b586273db0c2924034ceb4ae54c294f5b7e938826fbbcb8a,
    0x23dd8b576fa286331864d63c77fd82fa61da717533821b9382617ebd54abeb46,
    0x27cc17e6f4f00d6bb6090ab547f5304d342906745537c3dca84ae93d43aacbfc,
    0x2f98269e5b461f1e0a4edc75d574a2b4c106392104a6d21a50591e0115ceb0a1,
    0x0f5210b2efc2241ebeaa55aeca7fb11428765effa985bddc3b224474781de1c9,
    0x3df156c9f66b66b3f02b185ce503ea304bc876a019d20b0d26ce0a6c8308bb6e,
    0x389a0dccf9b67ee59d33dae6bdd67349b4104c4706518c44fe15ceef56977a45,
    0x2ab5fff302ec18001ad491b218c47bf0bcf53d59c8b0a63881cfd297926f6b00,
    0x1bb7d0071f06646588a9ea2afcf4546e74f6eb9270728fc5954f4b6ade69701e,
    0x22a2d1cf4a4ca616d98c8dbfec806979e5a7a070207b17b16c74e0323bd52b3c,
    0x1baa026275eb4def033cf764cc8618f79cbd29722bc4b6b39328092459b89f24,
    0x375657d6ad46103ce00bbf79004bd37bf2344f54e94799807d56723514059f21,
    0x0e61a6ea081de44f1e3b8db283b5cc633aa3a5798b84e0dcfeaf15f960aa4014,
    0x04dedebeae494420270dbb6942a8ed64060baf74b2c50f46576c24460edf3924,
    0x212aae4aab14ba9ad2137997aedc5260aced3d8e109cfe00a868752b416e1167,
    0x08d869cee1f54bb7f88ec9d7868d6c7c03c5e37d6584b237d6db8444708499b9,
    0x2edb0a063b7dc1f03f8e93988defce652a66c0b4bf5098e9c2a9b54b0c868d0c,
    0x1abe0556f1b6cdc01e64bece12030795fa6606acaed8aca5e994a0a6c826cde9,
    0x3b4020e0625af3c0a94f42cb68d2793c8ed844daea9352fa6fdb5fe8bc35d9b2,
    0x29fe58498866232db2fea6c0a41cc03f101269f9e97ccbf4b1cc309aeff344b3,
    0x3069a5c1ab448edfc3a9cb07b2224957d9d5139759dd034998ba6b520c9b8078,
    0x2f13c2492208c1a3f33cc9f02f461279d60f3588f4e34d050950a73a6131f194,
    0x2542243d3d82547243f858bf2bfb2a2796bbc3afd4d6d9e13aed5b428df7103a,
    0x3bfbc0cb7f9206e17f81022078150aae370623a1183b070d3c67ca4155dad040,
    0x14f0568cb0a7bb6f6b20bcf4dec92b0a855417391cb2fd60c9de8a1d5b3cc34e,
    0x083a9a75f05ad6c5c2501ae048d483e1287bb93bddfea18e6d9ec4f9bb9254e7,
    0x0ae189fec307b78ba87c57dbb105ed6a5fa3127f79fdaf2c04791bb73ace63d8,
    0x10ca0fd2a95bc198763d375f566182463e0c92ea122df6485f1c4e5a9769b32c,
    0x0abed979216162a193fde6b6bb882963870065d2838c6408483ece74d757db61,
    0x1fa3c38474b954d892b9d36f82c6258e576e0d3345ba1ea973c1c8b2f66b9ef6,
    0x3fa18ae835720eb38fb649eeead5230af2c60c553858678449f6b938dd9ffaca,
    0x20077c9fffcf91931a43427c1c476081d1c9b5d34753d61672641012cf6a58ec,
    0x197cf613a52bd2c9115f92ad369a968f51fa44d23868076dc21a7c7853fd3026,
    0x086a0f313a1cf0bcfe765ea5a421abd799af6e65bebb77385d45b379d2757271,
    0x095112e6392bfa527944333eb2c7ce1d392d234465d3f4b2c5aed73107967638,
    0x119f669d6bf57d682e5c19e4845d9069893f6775b3abb284e2d938bec0bc0c79,
    0x1c05fd9d60702bfe5c5488d2cf01be285ba8d02a7260be8dcd499293274eb252,
    0x09070de75b4ee80c3fb94482867ef6ff4fb82b09a8ac2ccf619c5a7ed8d7124a,
    0x2283c093b1bc68e0c89bfad567036a8df06f1f862cfd8e4b4f2b16a5a22d344e,
    0x11f93058586938f85d19667feec338315279fbd407b0a7650a3c46ecad1006e8,
    0x37420bc89109e9ff3325b1ac1d91ab1df195bfe0366e71aa4073d326568d2aba,
    0x07a4ff89d94dc7fc88cc271f20b8cbb4fcd2f73546d6dc13f0a3cb6afdccaae0,
    0x32368a4a4a78f30c3ae423955f9a86481efff1bd9ca29c418494e58b96667686,
    0x1fdef874b34bad8a36c18fdfbc84173248fc9f73018d11a4e0707a5f976759e4,
    0x2f4819c85aee94363e380b2cefaa78876b9c4207298d2e97f9293d43f9ef251f,
    0x04620a995fe98293291528495896b29133428d8acfc60e9a17d5562957ba524b,
    0x1d308ca56d5efd538233125a7250df8ac501e9bd1baacf312e13ea6d08535ef8,
    0x192a71c92b13952c0f3d4dbd927a4cc840d126ee5986d74b3447dac50463371a,
    0x25cc5e57424f0a04f73374e760345ac956b3d1eb66dcef7c04f291ffa0cce08b
]


def mimc5(input_value, secret_key):
    state_value = input_value

    for r in range(num_rounds):
            state_value = (state_value + secret_key + round_constants[r])^5
    return state_value + secret_key

# The print_hex function is modification of the one from https://github.com/daira/pasta-hadeshash
def print_hex(c):
    c = int(c)
    print("vesta::Base::from_raw([")
    for i in range(0, n, 64):
        print("    0x%04x_%04x_%04x_%04x," % tuple([(c >> j) & 0xFFFF for j in range(i+48, i-1, -16)]))
    print("])\n")


def main(args):
    secret_key = F(0) # Zero secret key gives MiMC hash function
    input_value = F(0)
    if (len(args) > 0):
        input_value = F(args[0])
    if (len(args) > 1):
        secret_key = F(args[1])

    print(input_value, secret_key)
    output_value = mimc5(input_value, secret_key)

    print("Input:", hex(input_value))
    print_hex(input_value)
    print("Key:", hex(secret_key))
    print_hex(secret_key)
    print("Output:", hex(output_value))
    print_hex(output_value)

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])
