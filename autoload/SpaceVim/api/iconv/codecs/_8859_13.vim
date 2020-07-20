let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:lib
endfunction

let s:tablebase = {s:nsiconv}codecs#tablebase#import()

let s:lib = {}

let s:lib.Codec = {}
call extend(s:lib.Codec, s:tablebase.Codec)
let s:lib.Codec.encoding = "8859_13"

let s:lib.Codec.decoding_table_maxlen = 1
let s:lib.Codec.encoding_table_maxlen = 1

let s:lib.Codec.decoding_table = {}
let s:lib.Codec.decoding_table["0"] = [0]
let s:lib.Codec.decoding_table["1"] = [1]
let s:lib.Codec.decoding_table["2"] = [2]
let s:lib.Codec.decoding_table["3"] = [3]
let s:lib.Codec.decoding_table["4"] = [4]
let s:lib.Codec.decoding_table["5"] = [5]
let s:lib.Codec.decoding_table["6"] = [6]
let s:lib.Codec.decoding_table["7"] = [7]
let s:lib.Codec.decoding_table["8"] = [8]
let s:lib.Codec.decoding_table["9"] = [9]
let s:lib.Codec.decoding_table["10"] = [10]
let s:lib.Codec.decoding_table["11"] = [11]
let s:lib.Codec.decoding_table["12"] = [12]
let s:lib.Codec.decoding_table["13"] = [13]
let s:lib.Codec.decoding_table["14"] = [14]
let s:lib.Codec.decoding_table["15"] = [15]
let s:lib.Codec.decoding_table["16"] = [16]
let s:lib.Codec.decoding_table["17"] = [17]
let s:lib.Codec.decoding_table["18"] = [18]
let s:lib.Codec.decoding_table["19"] = [19]
let s:lib.Codec.decoding_table["20"] = [20]
let s:lib.Codec.decoding_table["21"] = [21]
let s:lib.Codec.decoding_table["22"] = [22]
let s:lib.Codec.decoding_table["23"] = [23]
let s:lib.Codec.decoding_table["24"] = [24]
let s:lib.Codec.decoding_table["25"] = [25]
let s:lib.Codec.decoding_table["26"] = [26]
let s:lib.Codec.decoding_table["27"] = [27]
let s:lib.Codec.decoding_table["28"] = [28]
let s:lib.Codec.decoding_table["29"] = [29]
let s:lib.Codec.decoding_table["30"] = [30]
let s:lib.Codec.decoding_table["31"] = [31]
let s:lib.Codec.decoding_table["32"] = [32]
let s:lib.Codec.decoding_table["33"] = [33]
let s:lib.Codec.decoding_table["34"] = [34]
let s:lib.Codec.decoding_table["35"] = [35]
let s:lib.Codec.decoding_table["36"] = [36]
let s:lib.Codec.decoding_table["37"] = [37]
let s:lib.Codec.decoding_table["38"] = [38]
let s:lib.Codec.decoding_table["39"] = [39]
let s:lib.Codec.decoding_table["40"] = [40]
let s:lib.Codec.decoding_table["41"] = [41]
let s:lib.Codec.decoding_table["42"] = [42]
let s:lib.Codec.decoding_table["43"] = [43]
let s:lib.Codec.decoding_table["44"] = [44]
let s:lib.Codec.decoding_table["45"] = [45]
let s:lib.Codec.decoding_table["46"] = [46]
let s:lib.Codec.decoding_table["47"] = [47]
let s:lib.Codec.decoding_table["48"] = [48]
let s:lib.Codec.decoding_table["49"] = [49]
let s:lib.Codec.decoding_table["50"] = [50]
let s:lib.Codec.decoding_table["51"] = [51]
let s:lib.Codec.decoding_table["52"] = [52]
let s:lib.Codec.decoding_table["53"] = [53]
let s:lib.Codec.decoding_table["54"] = [54]
let s:lib.Codec.decoding_table["55"] = [55]
let s:lib.Codec.decoding_table["56"] = [56]
let s:lib.Codec.decoding_table["57"] = [57]
let s:lib.Codec.decoding_table["58"] = [58]
let s:lib.Codec.decoding_table["59"] = [59]
let s:lib.Codec.decoding_table["60"] = [60]
let s:lib.Codec.decoding_table["61"] = [61]
let s:lib.Codec.decoding_table["62"] = [62]
let s:lib.Codec.decoding_table["63"] = [63]
let s:lib.Codec.decoding_table["64"] = [64]
let s:lib.Codec.decoding_table["65"] = [65]
let s:lib.Codec.decoding_table["66"] = [66]
let s:lib.Codec.decoding_table["67"] = [67]
let s:lib.Codec.decoding_table["68"] = [68]
let s:lib.Codec.decoding_table["69"] = [69]
let s:lib.Codec.decoding_table["70"] = [70]
let s:lib.Codec.decoding_table["71"] = [71]
let s:lib.Codec.decoding_table["72"] = [72]
let s:lib.Codec.decoding_table["73"] = [73]
let s:lib.Codec.decoding_table["74"] = [74]
let s:lib.Codec.decoding_table["75"] = [75]
let s:lib.Codec.decoding_table["76"] = [76]
let s:lib.Codec.decoding_table["77"] = [77]
let s:lib.Codec.decoding_table["78"] = [78]
let s:lib.Codec.decoding_table["79"] = [79]
let s:lib.Codec.decoding_table["80"] = [80]
let s:lib.Codec.decoding_table["81"] = [81]
let s:lib.Codec.decoding_table["82"] = [82]
let s:lib.Codec.decoding_table["83"] = [83]
let s:lib.Codec.decoding_table["84"] = [84]
let s:lib.Codec.decoding_table["85"] = [85]
let s:lib.Codec.decoding_table["86"] = [86]
let s:lib.Codec.decoding_table["87"] = [87]
let s:lib.Codec.decoding_table["88"] = [88]
let s:lib.Codec.decoding_table["89"] = [89]
let s:lib.Codec.decoding_table["90"] = [90]
let s:lib.Codec.decoding_table["91"] = [91]
let s:lib.Codec.decoding_table["92"] = [92]
let s:lib.Codec.decoding_table["93"] = [93]
let s:lib.Codec.decoding_table["94"] = [94]
let s:lib.Codec.decoding_table["95"] = [95]
let s:lib.Codec.decoding_table["96"] = [96]
let s:lib.Codec.decoding_table["97"] = [97]
let s:lib.Codec.decoding_table["98"] = [98]
let s:lib.Codec.decoding_table["99"] = [99]
let s:lib.Codec.decoding_table["100"] = [100]
let s:lib.Codec.decoding_table["101"] = [101]
let s:lib.Codec.decoding_table["102"] = [102]
let s:lib.Codec.decoding_table["103"] = [103]
let s:lib.Codec.decoding_table["104"] = [104]
let s:lib.Codec.decoding_table["105"] = [105]
let s:lib.Codec.decoding_table["106"] = [106]
let s:lib.Codec.decoding_table["107"] = [107]
let s:lib.Codec.decoding_table["108"] = [108]
let s:lib.Codec.decoding_table["109"] = [109]
let s:lib.Codec.decoding_table["110"] = [110]
let s:lib.Codec.decoding_table["111"] = [111]
let s:lib.Codec.decoding_table["112"] = [112]
let s:lib.Codec.decoding_table["113"] = [113]
let s:lib.Codec.decoding_table["114"] = [114]
let s:lib.Codec.decoding_table["115"] = [115]
let s:lib.Codec.decoding_table["116"] = [116]
let s:lib.Codec.decoding_table["117"] = [117]
let s:lib.Codec.decoding_table["118"] = [118]
let s:lib.Codec.decoding_table["119"] = [119]
let s:lib.Codec.decoding_table["120"] = [120]
let s:lib.Codec.decoding_table["121"] = [121]
let s:lib.Codec.decoding_table["122"] = [122]
let s:lib.Codec.decoding_table["123"] = [123]
let s:lib.Codec.decoding_table["124"] = [124]
let s:lib.Codec.decoding_table["125"] = [125]
let s:lib.Codec.decoding_table["126"] = [126]
let s:lib.Codec.decoding_table["127"] = [127]
let s:lib.Codec.decoding_table["128"] = [128]
let s:lib.Codec.decoding_table["129"] = [129]
let s:lib.Codec.decoding_table["130"] = [130]
let s:lib.Codec.decoding_table["131"] = [131]
let s:lib.Codec.decoding_table["132"] = [132]
let s:lib.Codec.decoding_table["133"] = [133]
let s:lib.Codec.decoding_table["134"] = [134]
let s:lib.Codec.decoding_table["135"] = [135]
let s:lib.Codec.decoding_table["136"] = [136]
let s:lib.Codec.decoding_table["137"] = [137]
let s:lib.Codec.decoding_table["138"] = [138]
let s:lib.Codec.decoding_table["139"] = [139]
let s:lib.Codec.decoding_table["140"] = [140]
let s:lib.Codec.decoding_table["141"] = [141]
let s:lib.Codec.decoding_table["142"] = [142]
let s:lib.Codec.decoding_table["143"] = [143]
let s:lib.Codec.decoding_table["144"] = [144]
let s:lib.Codec.decoding_table["145"] = [145]
let s:lib.Codec.decoding_table["146"] = [146]
let s:lib.Codec.decoding_table["147"] = [147]
let s:lib.Codec.decoding_table["148"] = [148]
let s:lib.Codec.decoding_table["149"] = [149]
let s:lib.Codec.decoding_table["150"] = [150]
let s:lib.Codec.decoding_table["151"] = [151]
let s:lib.Codec.decoding_table["152"] = [152]
let s:lib.Codec.decoding_table["153"] = [153]
let s:lib.Codec.decoding_table["154"] = [154]
let s:lib.Codec.decoding_table["155"] = [155]
let s:lib.Codec.decoding_table["156"] = [156]
let s:lib.Codec.decoding_table["157"] = [157]
let s:lib.Codec.decoding_table["158"] = [158]
let s:lib.Codec.decoding_table["159"] = [159]
let s:lib.Codec.decoding_table["160"] = [160]
let s:lib.Codec.decoding_table["161"] = [8221]
let s:lib.Codec.decoding_table["162"] = [162]
let s:lib.Codec.decoding_table["163"] = [163]
let s:lib.Codec.decoding_table["164"] = [164]
let s:lib.Codec.decoding_table["165"] = [8222]
let s:lib.Codec.decoding_table["166"] = [166]
let s:lib.Codec.decoding_table["167"] = [167]
let s:lib.Codec.decoding_table["168"] = [216]
let s:lib.Codec.decoding_table["169"] = [169]
let s:lib.Codec.decoding_table["170"] = [342]
let s:lib.Codec.decoding_table["171"] = [171]
let s:lib.Codec.decoding_table["172"] = [172]
let s:lib.Codec.decoding_table["173"] = [173]
let s:lib.Codec.decoding_table["174"] = [174]
let s:lib.Codec.decoding_table["175"] = [198]
let s:lib.Codec.decoding_table["176"] = [176]
let s:lib.Codec.decoding_table["177"] = [177]
let s:lib.Codec.decoding_table["178"] = [178]
let s:lib.Codec.decoding_table["179"] = [179]
let s:lib.Codec.decoding_table["180"] = [8220]
let s:lib.Codec.decoding_table["181"] = [181]
let s:lib.Codec.decoding_table["182"] = [182]
let s:lib.Codec.decoding_table["183"] = [183]
let s:lib.Codec.decoding_table["184"] = [248]
let s:lib.Codec.decoding_table["185"] = [185]
let s:lib.Codec.decoding_table["186"] = [343]
let s:lib.Codec.decoding_table["187"] = [187]
let s:lib.Codec.decoding_table["188"] = [188]
let s:lib.Codec.decoding_table["189"] = [189]
let s:lib.Codec.decoding_table["190"] = [190]
let s:lib.Codec.decoding_table["191"] = [230]
let s:lib.Codec.decoding_table["192"] = [260]
let s:lib.Codec.decoding_table["193"] = [302]
let s:lib.Codec.decoding_table["194"] = [256]
let s:lib.Codec.decoding_table["195"] = [262]
let s:lib.Codec.decoding_table["196"] = [196]
let s:lib.Codec.decoding_table["197"] = [197]
let s:lib.Codec.decoding_table["198"] = [280]
let s:lib.Codec.decoding_table["199"] = [274]
let s:lib.Codec.decoding_table["200"] = [268]
let s:lib.Codec.decoding_table["201"] = [201]
let s:lib.Codec.decoding_table["202"] = [377]
let s:lib.Codec.decoding_table["203"] = [278]
let s:lib.Codec.decoding_table["204"] = [290]
let s:lib.Codec.decoding_table["205"] = [310]
let s:lib.Codec.decoding_table["206"] = [298]
let s:lib.Codec.decoding_table["207"] = [315]
let s:lib.Codec.decoding_table["208"] = [352]
let s:lib.Codec.decoding_table["209"] = [323]
let s:lib.Codec.decoding_table["210"] = [325]
let s:lib.Codec.decoding_table["211"] = [211]
let s:lib.Codec.decoding_table["212"] = [332]
let s:lib.Codec.decoding_table["213"] = [213]
let s:lib.Codec.decoding_table["214"] = [214]
let s:lib.Codec.decoding_table["215"] = [215]
let s:lib.Codec.decoding_table["216"] = [370]
let s:lib.Codec.decoding_table["217"] = [321]
let s:lib.Codec.decoding_table["218"] = [346]
let s:lib.Codec.decoding_table["219"] = [362]
let s:lib.Codec.decoding_table["220"] = [220]
let s:lib.Codec.decoding_table["221"] = [379]
let s:lib.Codec.decoding_table["222"] = [381]
let s:lib.Codec.decoding_table["223"] = [223]
let s:lib.Codec.decoding_table["224"] = [261]
let s:lib.Codec.decoding_table["225"] = [303]
let s:lib.Codec.decoding_table["226"] = [257]
let s:lib.Codec.decoding_table["227"] = [263]
let s:lib.Codec.decoding_table["228"] = [228]
let s:lib.Codec.decoding_table["229"] = [229]
let s:lib.Codec.decoding_table["230"] = [281]
let s:lib.Codec.decoding_table["231"] = [275]
let s:lib.Codec.decoding_table["232"] = [269]
let s:lib.Codec.decoding_table["233"] = [233]
let s:lib.Codec.decoding_table["234"] = [378]
let s:lib.Codec.decoding_table["235"] = [279]
let s:lib.Codec.decoding_table["236"] = [291]
let s:lib.Codec.decoding_table["237"] = [311]
let s:lib.Codec.decoding_table["238"] = [299]
let s:lib.Codec.decoding_table["239"] = [316]
let s:lib.Codec.decoding_table["240"] = [353]
let s:lib.Codec.decoding_table["241"] = [324]
let s:lib.Codec.decoding_table["242"] = [326]
let s:lib.Codec.decoding_table["243"] = [243]
let s:lib.Codec.decoding_table["244"] = [333]
let s:lib.Codec.decoding_table["245"] = [245]
let s:lib.Codec.decoding_table["246"] = [246]
let s:lib.Codec.decoding_table["247"] = [247]
let s:lib.Codec.decoding_table["248"] = [371]
let s:lib.Codec.decoding_table["249"] = [322]
let s:lib.Codec.decoding_table["250"] = [347]
let s:lib.Codec.decoding_table["251"] = [363]
let s:lib.Codec.decoding_table["252"] = [252]
let s:lib.Codec.decoding_table["253"] = [380]
let s:lib.Codec.decoding_table["254"] = [382]
let s:lib.Codec.decoding_table["255"] = [8217]

let s:lib.Codec.encoding_table = {}
let s:lib.Codec.encoding_table["0"] = [0]
let s:lib.Codec.encoding_table["1"] = [1]
let s:lib.Codec.encoding_table["2"] = [2]
let s:lib.Codec.encoding_table["3"] = [3]
let s:lib.Codec.encoding_table["4"] = [4]
let s:lib.Codec.encoding_table["5"] = [5]
let s:lib.Codec.encoding_table["6"] = [6]
let s:lib.Codec.encoding_table["7"] = [7]
let s:lib.Codec.encoding_table["8"] = [8]
let s:lib.Codec.encoding_table["9"] = [9]
let s:lib.Codec.encoding_table["10"] = [10]
let s:lib.Codec.encoding_table["11"] = [11]
let s:lib.Codec.encoding_table["12"] = [12]
let s:lib.Codec.encoding_table["13"] = [13]
let s:lib.Codec.encoding_table["14"] = [14]
let s:lib.Codec.encoding_table["15"] = [15]
let s:lib.Codec.encoding_table["16"] = [16]
let s:lib.Codec.encoding_table["17"] = [17]
let s:lib.Codec.encoding_table["18"] = [18]
let s:lib.Codec.encoding_table["19"] = [19]
let s:lib.Codec.encoding_table["20"] = [20]
let s:lib.Codec.encoding_table["21"] = [21]
let s:lib.Codec.encoding_table["22"] = [22]
let s:lib.Codec.encoding_table["23"] = [23]
let s:lib.Codec.encoding_table["24"] = [24]
let s:lib.Codec.encoding_table["25"] = [25]
let s:lib.Codec.encoding_table["26"] = [26]
let s:lib.Codec.encoding_table["27"] = [27]
let s:lib.Codec.encoding_table["28"] = [28]
let s:lib.Codec.encoding_table["29"] = [29]
let s:lib.Codec.encoding_table["30"] = [30]
let s:lib.Codec.encoding_table["31"] = [31]
let s:lib.Codec.encoding_table["32"] = [32]
let s:lib.Codec.encoding_table["33"] = [33]
let s:lib.Codec.encoding_table["34"] = [34]
let s:lib.Codec.encoding_table["35"] = [35]
let s:lib.Codec.encoding_table["36"] = [36]
let s:lib.Codec.encoding_table["37"] = [37]
let s:lib.Codec.encoding_table["38"] = [38]
let s:lib.Codec.encoding_table["39"] = [39]
let s:lib.Codec.encoding_table["40"] = [40]
let s:lib.Codec.encoding_table["41"] = [41]
let s:lib.Codec.encoding_table["42"] = [42]
let s:lib.Codec.encoding_table["43"] = [43]
let s:lib.Codec.encoding_table["44"] = [44]
let s:lib.Codec.encoding_table["45"] = [45]
let s:lib.Codec.encoding_table["46"] = [46]
let s:lib.Codec.encoding_table["47"] = [47]
let s:lib.Codec.encoding_table["48"] = [48]
let s:lib.Codec.encoding_table["49"] = [49]
let s:lib.Codec.encoding_table["50"] = [50]
let s:lib.Codec.encoding_table["51"] = [51]
let s:lib.Codec.encoding_table["52"] = [52]
let s:lib.Codec.encoding_table["53"] = [53]
let s:lib.Codec.encoding_table["54"] = [54]
let s:lib.Codec.encoding_table["55"] = [55]
let s:lib.Codec.encoding_table["56"] = [56]
let s:lib.Codec.encoding_table["57"] = [57]
let s:lib.Codec.encoding_table["58"] = [58]
let s:lib.Codec.encoding_table["59"] = [59]
let s:lib.Codec.encoding_table["60"] = [60]
let s:lib.Codec.encoding_table["61"] = [61]
let s:lib.Codec.encoding_table["62"] = [62]
let s:lib.Codec.encoding_table["63"] = [63]
let s:lib.Codec.encoding_table["64"] = [64]
let s:lib.Codec.encoding_table["65"] = [65]
let s:lib.Codec.encoding_table["66"] = [66]
let s:lib.Codec.encoding_table["67"] = [67]
let s:lib.Codec.encoding_table["68"] = [68]
let s:lib.Codec.encoding_table["69"] = [69]
let s:lib.Codec.encoding_table["70"] = [70]
let s:lib.Codec.encoding_table["71"] = [71]
let s:lib.Codec.encoding_table["72"] = [72]
let s:lib.Codec.encoding_table["73"] = [73]
let s:lib.Codec.encoding_table["74"] = [74]
let s:lib.Codec.encoding_table["75"] = [75]
let s:lib.Codec.encoding_table["76"] = [76]
let s:lib.Codec.encoding_table["77"] = [77]
let s:lib.Codec.encoding_table["78"] = [78]
let s:lib.Codec.encoding_table["79"] = [79]
let s:lib.Codec.encoding_table["80"] = [80]
let s:lib.Codec.encoding_table["81"] = [81]
let s:lib.Codec.encoding_table["82"] = [82]
let s:lib.Codec.encoding_table["83"] = [83]
let s:lib.Codec.encoding_table["84"] = [84]
let s:lib.Codec.encoding_table["85"] = [85]
let s:lib.Codec.encoding_table["86"] = [86]
let s:lib.Codec.encoding_table["87"] = [87]
let s:lib.Codec.encoding_table["88"] = [88]
let s:lib.Codec.encoding_table["89"] = [89]
let s:lib.Codec.encoding_table["90"] = [90]
let s:lib.Codec.encoding_table["91"] = [91]
let s:lib.Codec.encoding_table["92"] = [92]
let s:lib.Codec.encoding_table["93"] = [93]
let s:lib.Codec.encoding_table["94"] = [94]
let s:lib.Codec.encoding_table["95"] = [95]
let s:lib.Codec.encoding_table["96"] = [96]
let s:lib.Codec.encoding_table["97"] = [97]
let s:lib.Codec.encoding_table["98"] = [98]
let s:lib.Codec.encoding_table["99"] = [99]
let s:lib.Codec.encoding_table["100"] = [100]
let s:lib.Codec.encoding_table["101"] = [101]
let s:lib.Codec.encoding_table["102"] = [102]
let s:lib.Codec.encoding_table["103"] = [103]
let s:lib.Codec.encoding_table["104"] = [104]
let s:lib.Codec.encoding_table["105"] = [105]
let s:lib.Codec.encoding_table["106"] = [106]
let s:lib.Codec.encoding_table["107"] = [107]
let s:lib.Codec.encoding_table["108"] = [108]
let s:lib.Codec.encoding_table["109"] = [109]
let s:lib.Codec.encoding_table["110"] = [110]
let s:lib.Codec.encoding_table["111"] = [111]
let s:lib.Codec.encoding_table["112"] = [112]
let s:lib.Codec.encoding_table["113"] = [113]
let s:lib.Codec.encoding_table["114"] = [114]
let s:lib.Codec.encoding_table["115"] = [115]
let s:lib.Codec.encoding_table["116"] = [116]
let s:lib.Codec.encoding_table["117"] = [117]
let s:lib.Codec.encoding_table["118"] = [118]
let s:lib.Codec.encoding_table["119"] = [119]
let s:lib.Codec.encoding_table["120"] = [120]
let s:lib.Codec.encoding_table["121"] = [121]
let s:lib.Codec.encoding_table["122"] = [122]
let s:lib.Codec.encoding_table["123"] = [123]
let s:lib.Codec.encoding_table["124"] = [124]
let s:lib.Codec.encoding_table["125"] = [125]
let s:lib.Codec.encoding_table["126"] = [126]
let s:lib.Codec.encoding_table["127"] = [127]
let s:lib.Codec.encoding_table["128"] = [128]
let s:lib.Codec.encoding_table["129"] = [129]
let s:lib.Codec.encoding_table["130"] = [130]
let s:lib.Codec.encoding_table["131"] = [131]
let s:lib.Codec.encoding_table["132"] = [132]
let s:lib.Codec.encoding_table["133"] = [133]
let s:lib.Codec.encoding_table["134"] = [134]
let s:lib.Codec.encoding_table["135"] = [135]
let s:lib.Codec.encoding_table["136"] = [136]
let s:lib.Codec.encoding_table["137"] = [137]
let s:lib.Codec.encoding_table["138"] = [138]
let s:lib.Codec.encoding_table["139"] = [139]
let s:lib.Codec.encoding_table["140"] = [140]
let s:lib.Codec.encoding_table["141"] = [141]
let s:lib.Codec.encoding_table["142"] = [142]
let s:lib.Codec.encoding_table["143"] = [143]
let s:lib.Codec.encoding_table["144"] = [144]
let s:lib.Codec.encoding_table["145"] = [145]
let s:lib.Codec.encoding_table["146"] = [146]
let s:lib.Codec.encoding_table["147"] = [147]
let s:lib.Codec.encoding_table["148"] = [148]
let s:lib.Codec.encoding_table["149"] = [149]
let s:lib.Codec.encoding_table["150"] = [150]
let s:lib.Codec.encoding_table["151"] = [151]
let s:lib.Codec.encoding_table["152"] = [152]
let s:lib.Codec.encoding_table["153"] = [153]
let s:lib.Codec.encoding_table["154"] = [154]
let s:lib.Codec.encoding_table["155"] = [155]
let s:lib.Codec.encoding_table["156"] = [156]
let s:lib.Codec.encoding_table["157"] = [157]
let s:lib.Codec.encoding_table["158"] = [158]
let s:lib.Codec.encoding_table["159"] = [159]
let s:lib.Codec.encoding_table["160"] = [160]
let s:lib.Codec.encoding_table["8221"] = [161]
let s:lib.Codec.encoding_table["162"] = [162]
let s:lib.Codec.encoding_table["163"] = [163]
let s:lib.Codec.encoding_table["164"] = [164]
let s:lib.Codec.encoding_table["8222"] = [165]
let s:lib.Codec.encoding_table["166"] = [166]
let s:lib.Codec.encoding_table["167"] = [167]
let s:lib.Codec.encoding_table["216"] = [168]
let s:lib.Codec.encoding_table["169"] = [169]
let s:lib.Codec.encoding_table["342"] = [170]
let s:lib.Codec.encoding_table["171"] = [171]
let s:lib.Codec.encoding_table["172"] = [172]
let s:lib.Codec.encoding_table["173"] = [173]
let s:lib.Codec.encoding_table["174"] = [174]
let s:lib.Codec.encoding_table["198"] = [175]
let s:lib.Codec.encoding_table["176"] = [176]
let s:lib.Codec.encoding_table["177"] = [177]
let s:lib.Codec.encoding_table["178"] = [178]
let s:lib.Codec.encoding_table["179"] = [179]
let s:lib.Codec.encoding_table["8220"] = [180]
let s:lib.Codec.encoding_table["181"] = [181]
let s:lib.Codec.encoding_table["182"] = [182]
let s:lib.Codec.encoding_table["183"] = [183]
let s:lib.Codec.encoding_table["248"] = [184]
let s:lib.Codec.encoding_table["185"] = [185]
let s:lib.Codec.encoding_table["343"] = [186]
let s:lib.Codec.encoding_table["187"] = [187]
let s:lib.Codec.encoding_table["188"] = [188]
let s:lib.Codec.encoding_table["189"] = [189]
let s:lib.Codec.encoding_table["190"] = [190]
let s:lib.Codec.encoding_table["230"] = [191]
let s:lib.Codec.encoding_table["260"] = [192]
let s:lib.Codec.encoding_table["302"] = [193]
let s:lib.Codec.encoding_table["256"] = [194]
let s:lib.Codec.encoding_table["262"] = [195]
let s:lib.Codec.encoding_table["196"] = [196]
let s:lib.Codec.encoding_table["197"] = [197]
let s:lib.Codec.encoding_table["280"] = [198]
let s:lib.Codec.encoding_table["274"] = [199]
let s:lib.Codec.encoding_table["268"] = [200]
let s:lib.Codec.encoding_table["201"] = [201]
let s:lib.Codec.encoding_table["377"] = [202]
let s:lib.Codec.encoding_table["278"] = [203]
let s:lib.Codec.encoding_table["290"] = [204]
let s:lib.Codec.encoding_table["310"] = [205]
let s:lib.Codec.encoding_table["298"] = [206]
let s:lib.Codec.encoding_table["315"] = [207]
let s:lib.Codec.encoding_table["352"] = [208]
let s:lib.Codec.encoding_table["323"] = [209]
let s:lib.Codec.encoding_table["325"] = [210]
let s:lib.Codec.encoding_table["211"] = [211]
let s:lib.Codec.encoding_table["332"] = [212]
let s:lib.Codec.encoding_table["213"] = [213]
let s:lib.Codec.encoding_table["214"] = [214]
let s:lib.Codec.encoding_table["215"] = [215]
let s:lib.Codec.encoding_table["370"] = [216]
let s:lib.Codec.encoding_table["321"] = [217]
let s:lib.Codec.encoding_table["346"] = [218]
let s:lib.Codec.encoding_table["362"] = [219]
let s:lib.Codec.encoding_table["220"] = [220]
let s:lib.Codec.encoding_table["379"] = [221]
let s:lib.Codec.encoding_table["381"] = [222]
let s:lib.Codec.encoding_table["223"] = [223]
let s:lib.Codec.encoding_table["261"] = [224]
let s:lib.Codec.encoding_table["303"] = [225]
let s:lib.Codec.encoding_table["257"] = [226]
let s:lib.Codec.encoding_table["263"] = [227]
let s:lib.Codec.encoding_table["228"] = [228]
let s:lib.Codec.encoding_table["229"] = [229]
let s:lib.Codec.encoding_table["281"] = [230]
let s:lib.Codec.encoding_table["275"] = [231]
let s:lib.Codec.encoding_table["269"] = [232]
let s:lib.Codec.encoding_table["233"] = [233]
let s:lib.Codec.encoding_table["378"] = [234]
let s:lib.Codec.encoding_table["279"] = [235]
let s:lib.Codec.encoding_table["291"] = [236]
let s:lib.Codec.encoding_table["311"] = [237]
let s:lib.Codec.encoding_table["299"] = [238]
let s:lib.Codec.encoding_table["316"] = [239]
let s:lib.Codec.encoding_table["353"] = [240]
let s:lib.Codec.encoding_table["324"] = [241]
let s:lib.Codec.encoding_table["326"] = [242]
let s:lib.Codec.encoding_table["243"] = [243]
let s:lib.Codec.encoding_table["333"] = [244]
let s:lib.Codec.encoding_table["245"] = [245]
let s:lib.Codec.encoding_table["246"] = [246]
let s:lib.Codec.encoding_table["247"] = [247]
let s:lib.Codec.encoding_table["371"] = [248]
let s:lib.Codec.encoding_table["322"] = [249]
let s:lib.Codec.encoding_table["347"] = [250]
let s:lib.Codec.encoding_table["363"] = [251]
let s:lib.Codec.encoding_table["252"] = [252]
let s:lib.Codec.encoding_table["380"] = [253]
let s:lib.Codec.encoding_table["382"] = [254]
let s:lib.Codec.encoding_table["8217"] = [255]
