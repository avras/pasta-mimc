#!/usr/bin/env sage

# Pallas curve: y^2 = x^3 + 5  over GF(0x40000000000000000000000000000000224698fc094cf91b992d30ed00000001)
# The order of the Pallas group is 0x40000000000000000000000000000000224698fc0994a8dd8c46eb2100000001
# More info: https://electriccoin.co/blog/the-pasta-curves-for-halo-2-and-beyond/

num_rounds = 220
prime = 0x40000000000000000000000000000000224698fc094cf91b992d30ed00000001
n = len(format(prime, 'b'))
F = GF(prime)

# As per Section 5.1 of https://eprint.iacr.org/2016/492.pdf, the
# suggested number of MiMC Sponge rounds is 2*ceil(log(prime,2)/log(s,2)).
# For the Pallas curve with s=5, this is 220. 
# By convention, the first and last round constants are 0.
# For the algorithm used to generate the other constants, see
# the file generate_mimc_sponge_x5_pallas_constants.py in this repository.
round_constants = [
    0x0,
    0xfbe43c36a80e36d7c7c584d4f8f3759fb51f0d66065d8a227b688d12488c5d4,
    0x1c48cd3e00a6195a253fc009e60f2494126ad10789157311eeb2be3921efc1ca,
    0x27c0849dba2643077c13eb42ffb97663cdcecd669bf10f756be30bab71b86cf8,
    0x2bf76744736132e5c68f7dfdd5b792681d415098554fd8280f00d11b172b80d2,
    0x33133eb4a1a1ab45037c8bdf9adbb2999baf06f20a9c95180dc4ccdcbec58568,
    0x188bb66012356dbc9b059ef1d792b563b47aed28d491d3244b2b0ee6551e9b2f,
    0x31bc3e244e1b92911fe7f53cf523e491db295b8bcc463e86400261798c4f4c35,
    0x11808e2b039fd010c489768f78d74998d1f8f591734ba9c24c003d21b7e40bde,
    0x36978af3ded437cf41b3faa40cd6bcfcc7088ef8a27f45b7b2b469d02c4537cf,
    0xa9baee798a320b0ca5b1cf888386d1dc12c13b38e10225aa4e9f03069a099f5,
    0x379dbf6050a03b16c3ade8d77e11c7678d97e901bb237aa8682fad0f21b32c77,
    0x274bbcf5067f067faec2cce4b98d130d349a137749c579c9ae9ade9024eb8b17,
    0x2b7ab080d4c4018bda6ecc8bd67468bc018c881adfc11b71474bd7ed58c8855b,
    0x26a5b797c2bba7e9a873b37f5c41adc410921eca2e3822b3855f0f83d2268760,
    0x2270ae87cf3d82cf9c0b5f428466c429b57132e62b81d6d8003be62df006016b,
    0x1951c9f6e76d636b52f7600d979ca9f371b6adc682b7d603fef9c656321b2a64,
    0x119469e44229cc40c4ff555a2b6f6b3771a6f926ad143050a9c8392130c554f,
    0x1d795e02bbaf90ff1f384741e5f18f8b420367843ac61cb54c8697253452a0af,
    0x281e90a515e6409e9177b4f297f8049ce3d4c3659423c48b3fd64e83596ff101,
    0x24185c60a21e84970f7d32cacaa27258843eb50a55af45a73fe656df1bf3e7c,
    0x196fcbc3960614ea887da609187a5dad3c0ded35d64c1e536bca8007a1f25c06,
    0x3de84026d7c294300af18f7712fc36628d5fbcba711112875412ee484b24bcef,
    0x3a9d568575846aa6b8a890b3c237fd0447426db878e6e25333b8eb9b386195c1,
    0x15a2aa32c84a4cae196dd4094b685dd0f510ae0e32939bbdf5bd43032452aa35,
    0xbc9481380978d29ebc5b0a8d4481cd2889183f3e4a98f8871b14968d9265fa8,
    0x24e53af71ef06bacb76d3294c11223911e9d177ff09b7009febc484add0beb74,
    0x1bd44e16108225766dac3e5fe7acbe9d8e45f0c67b51230bc8b0163f58f21390,
    0x6f434863c79013bb2c202331e04bcce3b51512bdb0aa6895f72911ff6d28e4b,
    0x3490eeb39a733c0e8062d87f981ae65a8fccf25c448f4455d27db3915351b066,
    0x30b89830ff7ade3558a5361a24869130ce1fcce97211602962e34859525dac4f,
    0x29bae21b579d080a75c1694da628d0ecfd83efc9c8468704f410300062f64ca9,
    0x2326499de0476e719915dd1c661ef454a05009bace07af9f59663f41790fce41,
    0xc45208b8baa6f473821415957088c0b39e5726de1c6be679bd2c530ee2f183f,
    0x3e2ad454f451348f26ce2cc7e7914aeed7e5a39b6dbd764752403e588401c34f,
    0x929db368ef2af2d29bca38845325b0b7a820a4889e44b5829bbe1ed47fd4d52,
    0x16531d424b0cbaf9abbf2d2acde698462ea4555bf32ccf1bbd26697e905066f6,
    0x35c30d247f045ff6d05cf0dd0a49c981d7a659bcbb6ae87455ada8cff29d76f3,
    0x2eb7a3614056c230c6f171370fdd9d10267467b6c484b95683e48ced5023f485,
    0xee9c4621642a272f710908707557498d25a6fdd51866da5d9f0d205355a6189,
    0x38ca1cb1c7f6c6894d1cf94f327b87639bd09855ad63767e46997857bb5a72ef,
    0x1d24d0b1b304d05311ce0f274b0d93744801c7f153909427afb12491a7a5ee79,
    0x37423dabd1a3cddc8691438fc5891e3fb25427f7d8cdb608fe648ef11303d2f2,
    0x642e8800a48cc04c0168232c6f542396597a67cf395ad622d947e98bb68697a,
    0x1e7d3cbbc4c35b7490647d8402e56d2cd5f9e4fa1c2349007c516ab7c0e3df2,
    0xd6fb1730335204f38f85e408ac861e72a9702a2a45412328fd3b75b0bb24fdf,
    0x27d0faf5f0db32a1b60e13dc4914246b7c942e9d06679fef807d559455864419,
    0x2605b9b909ded1b04971eae979027c4e0de57f3b6a60d5ed58aba619c34749ce,
    0x1276890b2c205db85f000d1f5111ed8eb0aa5ca8925767335bf95d87846228cd,
    0x2ac5905f9450a21ef6905ed5951a91b3730e3a2e2d62b50bdeb810015d50376b,
    0x3a366839f0291ca54da674ac3f0e1e9a866feebe49ec2dafa6f94f4ce57b9679,
    0x27ab0f3466989c3dbbe209c37ec272ba6151b2aadaf8c551adfe32f6ca7270e2,
    0xe786007d0ce7e28a90e31d3263887d40c556dec88fcb8b56bc9e9c05ecc0c29,
    0xb814ed99bd00eca389b0022663dbfddfbfa15e321c19abcf1eaf9556075fb68,
    0x25c0321ba26fcee4fdc35b4999b78ceb329616a3e2e142c310616e95925c0931,
    0x2b2d2a929601f9c3520e0b14aaa6ba9ed9ec502248dc96e234afeccf70722bf2,
    0xdd2e0744d4af1a81918de69ec121289f19d6b7ee818989aaabfdf04bdf65020,
    0x34527d0c0868f2ec628086b874fa66a71236a43f884034ec0cc60d2367e8ac57,
    0x1c6bf6ac0314caead23e357bfcbbaa17d670672ae3a475f80934c716f10aca25,
    0x3c4007e286f8dc7efd5d0eeb0e95d7aa6589361d128a0cccb17b554c851a6432,
    0x2e468a86a5a7db7c763a053eb09ac19fe37c9c113fbed649cf93cfc412b0697c,
    0x1333e3d052b7c77fcac1eb366f610f6f52f7f04a9e97885085b4d9e25c8c2d1b,
    0x12ec1d675cf5353153f6b628414783ca49392801f84793866dad7c842296e394,
    0x13ceeeb301572b4991076750e11ea7e7fcbfee454d90dc1763989004a1894f93,
    0x505737e7e94939a08d8cda10b6fbbbf430def499be4b98bdd72c0665135fe62,
    0x2127db7ac5200a212092b66ec2bfc63631ae438ebd1f7ce4f6c2576558a258b4,
    0x12692a7d808f44e31d628dbcfea377eb073fb918d7beb8136ea47f8cf094c88c,
    0x260e384b1268e3a347c91d6987fd280fa0a275541a7c5be34bf126af35c962e0,
    0x188c3b01966d90e713aee8d482ceaa68be5d522f26faba59d975402d4b6dadd9,
    0x387e868affd91b078a87fa75ac9332a68a962685824819fb3080fcb7f30bf049,
    0x35ba5f8acad1a950a3bbf2201055cd3e5de324c8b2a51a156598db008dbfe907,
    0x19ca814b49e00d7b3118c53a2986ded10611b1d16adb7a426f80b5791c457f74,
    0xfc4c0bea813a223fd510c07f7bbe337badd4bcf28649a0d378970c2a15b3aa5,
    0x53f1ea6dd60e7a6db09a00be77549ff3d4ee3737be7fb42052ae1321f667c3,
    0x2b937077bb10c8fe38716d4e38edc1f980ddc16ff9180d0d1c62328f7baa4a01,
    0x3acb14c0f1508d828f7fd048d716b804065f4d17a1f493afe564f153b9725205,
    0xca0abb8beb7cff572a0c1e6f58e080df96baad88e56ee299f16f95855ad40bd,
    0x1a9eefd411e590d7e44592cce298af874bf25fafb0a4c5e4df1237c64aa551b2,
    0x153dae43cef763e7a2fc9846f09a2973b0ad9c35894c220699bcc2954501c6bd,
    0x14ed2a09375813b4fb504c7a9ba13110570489a62b4db265608e116dc090e878,
    0x63a5c4c9c12dcf4bae72c69f3a225664469503d61d9eae5d9553bfb006095b,
    0x1c8a4d35ad28e59dd3713b45985cd3b6a76401cea25b1d1c5318e6372dc9d82a,
    0x86ba219308f0c847b22fcb4449f8854f6de9dc412335e74b55490da814f483a,
    0x34d9604140a1ac9fdb204285b9fe1b303c281af2fc5fb362f6577282b423bcf3,
    0x1681959ec4bc3656911db2b2f56aa4d5035f77afe233a75ada0db70f437465a,
    0x3cd849f3b5f9e4368af75619fb27f2e2ced9f0a728b1a3c4f94bf733751ad477,
    0x35f7fc22ad64c8e7c1e005110e13f4f15fde2e04b07214bae55c2871f99554a2,
    0x29133b8a20fbae4633ec5f82cb47a38a9cfa4b1abf64c8ec65d21aa68aa53173,
    0x34827c5c7b61141cc31b75984bb3ed168683d36756fc3ebfbe2ea7ee5eaf8c0f,
    0xca361819ffefe3e50fe34c91a322c939f211aad4cdb10b73e90f0d23e32c9f1,
    0x2656088842bfc9e325a532784d3362cead61d6a071d3914fb06b05fee48ff156,
    0x129c7cd00e42ed05a37dbceb80d47b65e1d750ef2148278a54723fdf42c4cc,
    0x285b235631b786f85cd46f7768f6c71a9b777b2e684ba9a86040783a9b195886,
    0x34df65a82686be09c5b237911abf237a9887c1a418f279ac79b446d7d311f5ea,
    0x15a850c3989df9ca6231e0bdd9916fbc97a3d3459e51ceed82a0b2779f9c32b,
    0x10fb0940848a67aee83d348421fadd798cb5e12ed171f352cb631dd11bf63e7c,
    0x3ab63a16273599f8b66895461e62a19fac43d171294d7fa20bdc2fe1a89cdd8b,
    0x2931a091756e0bc709ebecfffba50386127f1ad9c7788e523dfd7b7a452db8a1,
    0x15559b8bb79db8809c46ee627f1b5ce1b6a03f9feffda06c0813466cd1ba8962,
    0x29a1a11b2979018cb155914d09f1df197372ba2c0bf13250849bc55056a44a08,
    0x383293400e7bccea4bb86dcb0d5ca57f3b72a31f898bec808794dcdd91cb0f18,
    0x37cb5742b6bc5339624d3568a33c21f2d6fa4d8b83fd334ad03347bfabf249f0,
    0x356efb400f8500b5c5bf811c65c86c7e6c159afd33337e69d8af2dff0b79f462,
    0x17c4427998d9c440f849dcd75b71579907d706c585eea16f78919e690e26eb1f,
    0xa5ed18ad53e33fdc3ae8cf353ff3f6d6c422b0c445d40222b2e81eb4ebd4cc0,
    0x1ad3e9376c97b194a0fbf43e22a361693d4a453e49dc6c75d7476e59fdf536b5,
    0x6daeff5769a06b26fe3b8fef30df07aacb36c465c2de3a099768a9959eaf547,
    0x20a78398345c6b8cf439643dab9622358b3d13c0a613debe3c1dd275c978c63,
    0x189ca65b6cf0e90653c06dddc057dc6197e1a09b3c1c0c00ff870d9918716efa,
    0x3064161f127d8c59fc73625957e2162c939aaa1d2aa4d35b1246b91f28e69b5,
    0x6d0ba662b50100b9a3af52052f68932dca584161fbe27182bc7605b893d8ba2,
    0x18dd55b4a83a53f2ee578eb3e6d26f594824d44670fc3f4de80642344d15c09a,
    0x1fb5b594f48bc58b345ab90ded705920629a1995f474fc55b6752eed2c3604b4,
    0x1901d8f4f2c8449128e00663978f2050f2eb1cd6acb60d9d09c57c5d46ee54fe,
    0x1ec56789beab24ef7ee32f594d5fc561ca1346ef8a1374ac4399cd78133a7db3,
    0x1c0b2cbe4fa9877a3d08eb67c510e8630da0a8beda94a6d9283e6f70d268bc5,
    0xb1d85acd9031a9107350eed946a25734e974799c5ba7cff13b15a5a623a25f0,
    0x204497d1d359552905a2fe655f3d6f94926ea92d12cdaa6556ec26362f239f64,
    0x2075f7edc6631a8d7ffe33019f44fc918bb258793e78a59ea25ce65472a2a5ed,
    0x243f46e353354256ab8fe0ca4e9230dfc330bc163e602dfeaf307c1d1a7264b9,
    0x1448ae5e09625fa1fcfd732fc9cd8f067def708dd4c238b9b852c42d1e9ecce8,
    0x2f312eef69a33d9fa753c08840275692a03432b3e6da67f9c59b9f9f4971cd56,
    0x1f333996af231bd5a293137da91801e16f605952abe5b3fee541693dd0efbbff,
    0x28f771e0383a832dc8e2eaa8efabda2fc4ba7ab6f3eb0886ad30e8e10abd8a60,
    0x1ff0b3d7a4643596f651b70c1963cc4f62372e20c4f51393fa04b6a425df83a7,
    0x1c373b704838325648273734dcdf962d37883d4b0cd645d4722af658c4a238b6,
    0x2a2afa02604b8afeeb570f48a0e97a5e052acb1f1d64af18349f5a0fcec8c337,
    0x28892258cd8eb43b71caa6d6837ec99579b76476e90f96ea5282cb5311f8a7be,
    0x32824f561f6f82e3c1232836b0d268f9d4478995d1ecaf0d15c8a9357ca91f46,
    0x164eda75fda2861f9d812f24e37ac938844fbe383c243b32b9f66ae2e76be719,
    0x30a6fc431f5bf0dd1cca93b8b65b3f72624b3b9fc6e0609658b382e4b31afcbd,
    0x268db66ba891ef0cd527f09ec6fff3eba352d1ffbcaab80bf5b4fd6870334b4c,
    0x3a44a5b102f7883a2b8630a3cae6e6db2e6e483bb7cfeb3492cbd91793ef598e,
    0x3939fe8ef789acb33cbf129ba8a3aa19b1ab80e0e332984b84a98d8a1c59bf0,
    0x136fe3b66dfda1bc5a7aae241b4db44240fea528af3b8789960f9099cd55d772,
    0x3490fcaa8ffa37f35dc67ae006e81352c7103945417b8e4b142afcaefa344b85,
    0xae66096cff344caca53ffe0e58aafeadfb80680d4269f6976d38dd2c0881871,
    0x7d05783a41bc14f3c9a45384b6d5e24e0f1ebae08e14616452a762b718a70a8,
    0x1ac6b9ba94040d5692b865b6677b60ef0fbb1cc608c9a0db72be6eae2528a025,
    0x2902a3d4d9ecbfb9b2c76fddf780554bb4af7b9f9faaf5cea1535774181628fe,
    0x29df91ffeeb086a4d26041c29dac6fc9b682d9dc07174960bca993ac95b98d24,
    0x62646f851d91a8840ad9ee711f12ec0f6b15d9ffd5bfd27b1e242780d57def5,
    0x30b7381c9725b9db07816baf8524943a79cea135807c84cce0833485c11e0c2e,
    0x16afc10c5cedaddbda99df79387397c979e773bcfca019cd9a5c2b740f3a989d,
    0x3543da80d10da251c548776fe907c4ef89993d62e0062ae5c0496fcb851c3661,
    0x25140fe26d8b008430fccd50a68e3e115a42726f9af1cc797534dc751d0b1b03,
    0x3efdf1872e4475e8bbb0ef6fab7f561b983e48204d7557e9093b0bfa18060c93,
    0x2bb8c9f3d57b18e002df059db1e6a5d4088ecdf54aa48b44de2237bf265093ff,
    0x1415122d50b26f4fab5784004c56cf03cee25f29a3d53dd91aa7ee87737bd972,
    0xe115c4a98efae6a3a5ecc873b0cef63ccd5b515710a3ab03ec52218f784dc9,
    0x1a7d525427bad87b88238657c2133123eea4f1828e7b55652deaa55e37a202a8,
    0x3332e8b34505b83010270dc795290a2b0888700897c48979b9a17c3f04c62f6,
    0x309ecb6033d1a065f17a61066cd737d07f3855433f29b8d2f603c4b99e62aa16,
    0x24e65c718938c2b937378e7435332174329730bde85a4185e37875824eb49859,
    0x28e41430ccd41cc5e92a9f9acd2e955bf13f20f9e44045f7a449433c484a8eb9,
    0x38fe9d0125ab8be54545276f8412747d40faa2d165b3579d91cd7f03d1ffa6,
    0x23248698612cd8e83234fcf5db9b6b225f4b0ba78d72ef13ea1edff5f0fb0298,
    0x12a9fa3d39c1ba91eefa666a1db71c6da77a707c5a3fc4c6aec6c720110cf0d1,
    0x28931ee7dfa02b62872e0d937ba3dc55f63468e57bb069df974f54205c82ef9,
    0x1cd399556445e3d7b201d6c5e56a5794e60be2cfd9a4643e7ead79bb4f60f79,
    0x2c855cc58d5fbb0dff91a79683eb0e91078e4b94f7ba1b0a35de46c583a8312d,
    0x37798af7ccf36b836705849f7dd4032858bf7b71566ec8de78e7349368171813,
    0x252a24c92d3f067bf551eeaf98c62ba4bf147d8ebbc6c2309425fb202986b2ae,
    0x3fc8682759a2bf1dd67c87a77c285467194b5150e1920efbea0de78132c9d72a,
    0x1482ac3e7e4f321627850d95a13942aea6d2923402b913046856ff7e8aaf9aff,
    0x17332b4c7aac2a07ccfe954de7ad22ccf6fcb4c5fa15c130ed22a40ae9398f47,
    0x14be0546013f84a0d1e118b37589723af20f58a4167c761a4f7bdcc43fdd8580,
    0x264ec737d31dddf939b184438ccdd3e18f59355f15bddb3569d73ef7d9b7b083,
    0xad12fbc74117cff4743d674539c865447da2678f76db474b116fc7153526d32,
    0x15a16435a2300b27a337561401f06682ba85019aa0af61b264a1177d38b5c13c,
    0x22616f306e76352293a22ab6ee15509d9b108d4136b32fa7f9ed259793f392a1,
    0x119727b25560caf00ce0d3f911bd4356d6c07d0eabcb748571356b8fcae1851d,
    0xff39e77928ce9310118d50e29bc87e790b788b9354f7806de905db202ae638f,
    0x17dead3bfa1968c744118023dead77cdbee22c5b7c2414f5a6bdf82fd94cf3ad,
    0x2bef0f8b22a1cfb90100f4a552a9d02b772130123de8144a00c4d57497e1d7f4,
    0x3f5188713fef90b31c35243f92cfa432d62344eafb8ac11e9540a01a1d152a0f,
    0x3baadd2fd92e3e12fb371be0578941dc0a108fbca0a7d81b88316fb94d6b4dfe,
    0x14f955742e20a28d38611bf9fc4a478c30e2a8b3b159e4be6ed10f28e338d9a7,
    0x3c1c3fe9a5f7ccd54ad5a51a224b3f94775266d19c3733017e4920d7391ad645,
    0x2372df6148abeed66fda5461779a9650f0c5d35654aa3a6992a061a316768a79,
    0x2d098e848fb853f95adb5a6364b5ab33a559178c6ea5d62274e8dcb2cb3ebcc4,
    0x8c5fc90f27431fabfe496dfba14bb0d982a7b22abfa311ac6a3ff36f4fe6295,
    0x3b988dfc0c4dfe53999bd34840adcb63b9321e24bac83a6bab9aa470d8cdebf2,
    0x25b068c942724c424ed5851c9575c22752c9bd25f91ebfa589de3d88ee7627f9,
    0x2d98a1931e361add218de11ff7879bd6aa790f25a666f08e8fb36ec9ce01e1a7,
    0x80b5a7d63f6c43542ad612023d3ffd65fb1033a8f9c862de2552217cf518541,
    0x22ef24bf47c5203118c6ff96657dd3c6972ba71eb9e0ad855abdcb207b4b70ca,
    0x107da812fd5a8375587e4860f87691d06448eb4d39b68ad2b2fbcc405d0fcc74,
    0x459abbc62bc6070cacdff597e97990d7e9b115db07f585ce56ee5d8ef1bad60,
    0x38d61f5e566855d70d36ef0f0f1fefcd7c829bdd60d95e0ef1fb5b98856280a4,
    0x13218626665c420d3aa2b0fa49224a3dce8e08b8b56f8851bd9cb5e25cb3042d,
    0x2f685fb152dba21b4d02422e237e246dd4f6e4751199deb7a05689f3f873e30f,
    0x1ade34719e2498dde70e4571c404744738045e0a9a7e89907f7ac957c22d1c46,
    0xa0c3dc7a496adca059cb95d9b1738125b820a5530c419674ebc7eeab5f56ac9,
    0x196bc98252f63169ed79073ee091a0e8ed0b5af51017da143940c00bdb863709,
    0x1979bf70695d93f8efb552a4137019184918d31ec3fb28a2053aea3368fad6bf,
    0x3803072d02f54d237a3c6c4cc18eda6d89fa6e44557fed1db29329136dc56d44,
    0x1efcda9d986cddcf431af4d59c6a7709d650885b7886cba70f0e7cd92b331cdc,
    0x13ca5f7859b82ac50b63da06d43aa68a0494941644528ae5f06284743f60418f,
    0x259d392c0667316ad37a06be2d51aabe59ec8bf6ed79c9d9672b02b014c7e41d,
    0x2c2f5f0d2146791b396e2bed6cf15a2077959a547a5deb1402ba4a26148dd0a5,
    0x17a993a6af068d72bc36f0e814d29fef3f97d7a72aa963889b16a8457409861a,
    0x2f1bf99686550e0396f7f4e2df6fdaa06eb52976bf7a7597910f36a4de5a07b4,
    0x234d705e1ecdc59cc6ed40749069d4b01590bf3371bc5a0c2cd49f91c072b19,
    0x2fe929a1fd6aacba5c4012c45dd727d2a5cf78995df806e7f810573fb97bc47d,
    0x2d5371215f2aba49026b2e48739c11b49472892ccab07c0a871bd688af967878,
    0x10e704566c49e1a11edc2c128b2e07f306ecfc612a9b7da632c4b592b9fa5958,
    0x263e1195090d00be1d8fb37de17ccf3b66d180645efa0d831865cfaa8797769e,
    0x265c090eebde2cfa7f9c92cf75641c761d27c38dd8bda408af14ebeb6a85029c,
    0x218971781c6855f6a9752912780bb9b6d534186f67b2715ca3d30c2a6b97a2aa,
    0x36fc1ef1bca8bec055cc66edecc5dc989c3c1c8ef5bd06cac14e92184f89e622,
    0x24e4e2838501516d3296542cb47a599d817007681e2aa501b2e7af28e37b998,
    0x3cd5a9e7353a50e454c9c1381b556b543897cc89153c3e3749f2021d82372263,
    0x34bcedbd54d0c917a315cc7ca785e3c554cd89f6a144c1b47ca865cfbf6cc83d,
    0x1f7476211105b3039cef009c51155ae93526c53a74973ecfce40754b3df10521,
    0x18aefbd978440c94b4b9fbd36e00e6e34a6813fc21c0a78a7cf003d841a5a6e2,
    0x22cd6d61be780a33c77677bc6ba40301485b3e565f46c787ccb8127c2a5a494,
    0x19ffc4fe0dc5f835c8dcdc1e60b8f0b0fcab67b3ed30681eedc272ab72b0748a,
    0x36a5268541bc4c64ad0ade8f55dda348bf30ba8655e238135e99bb10e9c20c0d,
    0x0,
]

# Implementation below follows the one in circomlibjs
# https://github.com/iden3/circomlibjs/blob/2e18e63b75e4eeffe1d54c95b2e71ee5a8709af9/src/mimcsponge.js#L44
def mimc5_sponge(xL, xR, secret_key):
    # Round 1 to num_rounds-1
    for r in range(num_rounds-1):
        xL, xR = xR + (xL + secret_key + round_constants[r])^5, xL

    # Last round has no swap and round constant is zero
    xR = xR + (xL + secret_key)^5
    return (xL, xR)

# The print_hex function is modification of the one from https://github.com/daira/pasta-hadeshash
def print_hex(c):
    c = int(c)
    print("pallas::Base::from_raw([")
    for i in range(0, n, 64):
        print("    0x%04x_%04x_%04x_%04x," % tuple([(c >> j) & 0xFFFF for j in range(i+48, i-1, -16)]))
    print("])\n")

def main(args):
    secret_key = F(0) # Zero secret key gives MiMC-Feistel hash function
    xL = F(0)
    xR = F(0)
    if (len(args) > 0):
        xL = F(args[0])
    if (len(args) > 1):
        xR = F(args[1])
    if (len(args) > 2):
        secret_key = F(args[2])


    xL_out, xR_out = mimc5_sponge(xL, xR, secret_key)

    print("Inputs:", hex(xL), hex(xR))
    print_hex(xL)
    print_hex(xR)
    print("Key:", hex(secret_key))
    print_hex(secret_key)
    print("Outputs:", hex(xL_out), hex(xR_out))
    print_hex(xL_out)
    print_hex(xR_out)

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])
