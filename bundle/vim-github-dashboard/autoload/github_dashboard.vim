" Copyright (c) 2013 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists("g:loaded_github_dashboard")
  finish
endif
let g:loaded_github_dashboard = 1

let s:passwords  = {}
let s:more_line  = '   -- MORE --'
let s:not_loaded = ''
let s:history    = { 'received_events': {}, 'events': {} }
let s:basedir    = expand('<sfile>:p:h')

let s:is_mac =
  \ has('mac') ||
  \ has('macunix') ||
  \ executable('uname') &&
  \ index(['Darwin', 'Mac'], substitute(system('uname'), '\n', '', '')) != -1
let s:is_win = has('win32') || has('win64')

if s:is_mac
  let s:emoji_code = {
    \ "+1": [0x1f44d],
    \ "-1": [0x1f44e],
    \ "100": [0x1f4af],
    \ "1234": [0x1f522],
    \ "8ball": [0x1f3b1],
    \ "a": [0x1f170],
    \ "ab": [0x1f18e],
    \ "abc": [0x1f524],
    \ "abcd": [0x1f521],
    \ "accept": [0x1f251],
    \ "aerial_tramway": [0x1f6a1],
    \ "airplane": [0x2708],
    \ "alarm_clock": [0x23f0],
    \ "alien": [0x1f47d],
    \ "ambulance": [0x1f691],
    \ "anchor": [0x2693],
    \ "angel": [0x1f47c],
    \ "anger": [0x1f4a2],
    \ "angry": [0x1f620],
    \ "anguished": [0x1f627],
    \ "ant": [0x1f41c],
    \ "apple": [0x1f34e],
    \ "aquarius": [0x2652],
    \ "aries": [0x2648],
    \ "arrow_backward": [0x25c0],
    \ "arrow_double_down": [0x23ec],
    \ "arrow_double_up": [0x23eb],
    \ "arrow_down": [0x2b07],
    \ "arrow_down_small": [0x1f53d],
    \ "arrow_forward": [0x25b6],
    \ "arrow_heading_down": [0x2935],
    \ "arrow_heading_up": [0x2934],
    \ "arrow_left": [0x2b05],
    \ "arrow_lower_left": [0x2199],
    \ "arrow_lower_right": [0x2198],
    \ "arrow_right": [0x27a1],
    \ "arrow_right_hook": [0x21aa],
    \ "arrow_up": [0x2b06],
    \ "arrow_up_down": [0x2195],
    \ "arrow_up_small": [0x1f53c],
    \ "arrow_upper_left": [0x2196],
    \ "arrow_upper_right": [0x2197],
    \ "arrows_clockwise": [0x1f503],
    \ "arrows_counterclockwise": [0x1f504],
    \ "art": [0x1f3a8],
    \ "articulated_lorry": [0x1f69b],
    \ "astonished": [0x1f632],
    \ "athletic_shoe": [0x1f45f],
    \ "atm": [0x1f3e7],
    \ "b": [0x1f171],
    \ "baby": [0x1f476],
    \ "baby_bottle": [0x1f37c],
    \ "baby_chick": [0x1f424],
    \ "baby_symbol": [0x1f6bc],
    \ "back": [0x1f519],
    \ "baggage_claim": [0x1f6c4],
    \ "balloon": [0x1f388],
    \ "ballot_box_with_check": [0x2611],
    \ "bamboo": [0x1f38d],
    \ "banana": [0x1f34c],
    \ "bangbang": [0x203c],
    \ "bank": [0x1f3e6],
    \ "bar_chart": [0x1f4ca],
    \ "barber": [0x1f488],
    \ "baseball": [0x26be],
    \ "basketball": [0x1f3c0],
    \ "bath": [0x1f6c0],
    \ "bathtub": [0x1f6c1],
    \ "battery": [0x1f50b],
    \ "bear": [0x1f43b],
    \ "bee": [0x1f41d],
    \ "beer": [0x1f37a],
    \ "beers": [0x1f37b],
    \ "beetle": [0x1f41e],
    \ "beginner": [0x1f530],
    \ "bell": [0x1f514],
    \ "bento": [0x1f371],
    \ "bicyclist": [0x1f6b4],
    \ "bike": [0x1f6b2],
    \ "bikini": [0x1f459],
    \ "bird": [0x1f426],
    \ "birthday": [0x1f382],
    \ "black_circle": [0x26ab],
    \ "black_joker": [0x1f0cf],
    \ "black_large_square": [0x2b1b],
    \ "black_medium_small_square": [0x25fe],
    \ "black_medium_square": [0x25fc],
    \ "black_nib": [0x2712],
    \ "black_small_square": [0x25aa],
    \ "black_square_button": [0x1f532],
    \ "blossom": [0x1f33c],
    \ "blowfish": [0x1f421],
    \ "blue_book": [0x1f4d8],
    \ "blue_car": [0x1f699],
    \ "blue_heart": [0x1f499],
    \ "blush": [0x1f60a],
    \ "boar": [0x1f417],
    \ "boat": [0x26f5],
    \ "bomb": [0x1f4a3],
    \ "book": [0x1f4d6],
    \ "bookmark": [0x1f516],
    \ "bookmark_tabs": [0x1f4d1],
    \ "books": [0x1f4da],
    \ "boom": [0x1f4a5],
    \ "boot": [0x1f462],
    \ "bouquet": [0x1f490],
    \ "bow": [0x1f647],
    \ "bowling": [0x1f3b3],
    \ "boy": [0x1f466],
    \ "bread": [0x1f35e],
    \ "bride_with_veil": [0x1f470],
    \ "bridge_at_night": [0x1f309],
    \ "briefcase": [0x1f4bc],
    \ "broken_heart": [0x1f494],
    \ "bug": [0x1f41b],
    \ "bulb": [0x1f4a1],
    \ "bullettrain_front": [0x1f685],
    \ "bullettrain_side": [0x1f684],
    \ "bus": [0x1f68c],
    \ "busstop": [0x1f68f],
    \ "bust_in_silhouette": [0x1f464],
    \ "busts_in_silhouette": [0x1f465],
    \ "cactus": [0x1f335],
    \ "cake": [0x1f370],
    \ "calendar": [0x1f4c6],
    \ "calling": [0x1f4f2],
    \ "camel": [0x1f42b],
    \ "camera": [0x1f4f7],
    \ "cancer": [0x264b],
    \ "candy": [0x1f36c],
    \ "capital_abcd": [0x1f520],
    \ "capricorn": [0x2651],
    \ "car": [0x1f697],
    \ "card_index": [0x1f4c7],
    \ "carousel_horse": [0x1f3a0],
    \ "cat": [0x1f431],
    \ "cat2": [0x1f408],
    \ "cd": [0x1f4bf],
    \ "chart": [0x1f4b9],
    \ "chart_with_downwards_trend": [0x1f4c9],
    \ "chart_with_upwards_trend": [0x1f4c8],
    \ "checkered_flag": [0x1f3c1],
    \ "cherries": [0x1f352],
    \ "cherry_blossom": [0x1f338],
    \ "chestnut": [0x1f330],
    \ "chicken": [0x1f414],
    \ "children_crossing": [0x1f6b8],
    \ "chocolate_bar": [0x1f36b],
    \ "christmas_tree": [0x1f384],
    \ "church": [0x26ea],
    \ "cinema": [0x1f3a6],
    \ "circus_tent": [0x1f3aa],
    \ "city_sunrise": [0x1f307],
    \ "city_sunset": [0x1f306],
    \ "cl": [0x1f191],
    \ "clap": [0x1f44f],
    \ "clapper": [0x1f3ac],
    \ "clipboard": [0x1f4cb],
    \ "clock1": [0x1f550],
    \ "clock10": [0x1f559],
    \ "clock1030": [0x1f565],
    \ "clock11": [0x1f55a],
    \ "clock1130": [0x1f566],
    \ "clock12": [0x1f55b],
    \ "clock1230": [0x1f567],
    \ "clock130": [0x1f55c],
    \ "clock2": [0x1f551],
    \ "clock230": [0x1f55d],
    \ "clock3": [0x1f552],
    \ "clock330": [0x1f55e],
    \ "clock4": [0x1f553],
    \ "clock430": [0x1f55f],
    \ "clock5": [0x1f554],
    \ "clock530": [0x1f560],
    \ "clock6": [0x1f555],
    \ "clock630": [0x1f561],
    \ "clock7": [0x1f556],
    \ "clock730": [0x1f562],
    \ "clock8": [0x1f557],
    \ "clock830": [0x1f563],
    \ "clock9": [0x1f558],
    \ "clock930": [0x1f564],
    \ "closed_book": [0x1f4d5],
    \ "closed_lock_with_key": [0x1f510],
    \ "closed_umbrella": [0x1f302],
    \ "cloud": [0x2601],
    \ "clubs": [0x2663],
    \ "cn": [0x1f1e8, 0x1f1f3],
    \ "cocktail": [0x1f378],
    \ "coffee": [0x2615],
    \ "cold_sweat": [0x1f630],
    \ "collision": [0x1f4a5],
    \ "computer": [0x1f4bb],
    \ "confetti_ball": [0x1f38a],
    \ "confounded": [0x1f616],
    \ "confused": [0x1f615],
    \ "congratulations": [0x3297],
    \ "construction": [0x1f6a7],
    \ "construction_worker": [0x1f477],
    \ "convenience_store": [0x1f3ea],
    \ "cookie": [0x1f36a],
    \ "cool": [0x1f192],
    \ "cop": [0x1f46e],
    \ "copyright": [0x00a9],
    \ "corn": [0x1f33d],
    \ "couple": [0x1f46b],
    \ "couple_with_heart": [0x1f491],
    \ "couplekiss": [0x1f48f],
    \ "cow": [0x1f42e],
    \ "cow2": [0x1f404],
    \ "credit_card": [0x1f4b3],
    \ "crescent_moon": [0x1f319],
    \ "crocodile": [0x1f40a],
    \ "crossed_flags": [0x1f38c],
    \ "crown": [0x1f451],
    \ "cry": [0x1f622],
    \ "crying_cat_face": [0x1f63f],
    \ "crystal_ball": [0x1f52e],
    \ "cupid": [0x1f498],
    \ "curly_loop": [0x27b0],
    \ "currency_exchange": [0x1f4b1],
    \ "curry": [0x1f35b],
    \ "custard": [0x1f36e],
    \ "customs": [0x1f6c3],
    \ "cyclone": [0x1f300],
    \ "dancer": [0x1f483],
    \ "dancers": [0x1f46f],
    \ "dango": [0x1f361],
    \ "dart": [0x1f3af],
    \ "dash": [0x1f4a8],
    \ "date": [0x1f4c5],
    \ "de": [0x1f1e9, 0x1f1ea],
    \ "deciduous_tree": [0x1f333],
    \ "department_store": [0x1f3ec],
    \ "diamond_shape_with_a_dot_inside": [0x1f4a0],
    \ "diamonds": [0x2666],
    \ "disappointed": [0x1f61e],
    \ "disappointed_relieved": [0x1f625],
    \ "dizzy": [0x1f4ab],
    \ "dizzy_face": [0x1f635],
    \ "do_not_litter": [0x1f6af],
    \ "dog": [0x1f436],
    \ "dog2": [0x1f415],
    \ "dollar": [0x1f4b5],
    \ "dolls": [0x1f38e],
    \ "dolphin": [0x1f42c],
    \ "door": [0x1f6aa],
    \ "doughnut": [0x1f369],
    \ "dragon": [0x1f409],
    \ "dragon_face": [0x1f432],
    \ "dress": [0x1f457],
    \ "dromedary_camel": [0x1f42a],
    \ "droplet": [0x1f4a7],
    \ "dvd": [0x1f4c0],
    \ "e-mail": [0x1f4e7],
    \ "ear": [0x1f442],
    \ "ear_of_rice": [0x1f33e],
    \ "earth_africa": [0x1f30d],
    \ "earth_americas": [0x1f30e],
    \ "earth_asia": [0x1f30f],
    \ "egg": [0x1f373],
    \ "eggplant": [0x1f346],
    \ "eight": [0x0038],
    \ "eight_pointed_black_star": [0x2734],
    \ "eight_spoked_asterisk": [0x2733],
    \ "electric_plug": [0x1f50c],
    \ "elephant": [0x1f418],
    \ "email": [0x2709],
    \ "end": [0x1f51a],
    \ "envelope": [0x2709],
    \ "envelope_with_arrow": [0x1f4e9],
    \ "es": [0x1f1ea, 0x1f1f8],
    \ "euro": [0x1f4b6],
    \ "european_castle": [0x1f3f0],
    \ "european_post_office": [0x1f3e4],
    \ "evergreen_tree": [0x1f332],
    \ "exclamation": [0x2757],
    \ "expressionless": [0x1f611],
    \ "eyeglasses": [0x1f453],
    \ "eyes": [0x1f440],
    \ "facepunch": [0x1f44a],
    \ "factory": [0x1f3ed],
    \ "fallen_leaf": [0x1f342],
    \ "family": [0x1f46a],
    \ "fast_forward": [0x23e9],
    \ "fax": [0x1f4e0],
    \ "fearful": [0x1f628],
    \ "feet": [0x1f43e],
    \ "ferris_wheel": [0x1f3a1],
    \ "file_folder": [0x1f4c1],
    \ "fire": [0x1f525],
    \ "fire_engine": [0x1f692],
    \ "fireworks": [0x1f386],
    \ "first_quarter_moon": [0x1f313],
    \ "first_quarter_moon_with_face": [0x1f31b],
    \ "fish": [0x1f41f],
    \ "fish_cake": [0x1f365],
    \ "fishing_pole_and_fish": [0x1f3a3],
    \ "fist": [0x270a],
    \ "five": [0x0035],
    \ "flags": [0x1f38f],
    \ "flashlight": [0x1f526],
    \ "flipper": [0x1f42c],
    \ "floppy_disk": [0x1f4be],
    \ "flower_playing_cards": [0x1f3b4],
    \ "flushed": [0x1f633],
    \ "foggy": [0x1f301],
    \ "football": [0x1f3c8],
    \ "footprints": [0x1f463],
    \ "fork_and_knife": [0x1f374],
    \ "fountain": [0x26f2],
    \ "four": [0x0034],
    \ "four_leaf_clover": [0x1f340],
    \ "fr": [0x1f1eb, 0x1f1f7],
    \ "free": [0x1f193],
    \ "fried_shrimp": [0x1f364],
    \ "fries": [0x1f35f],
    \ "frog": [0x1f438],
    \ "frowning": [0x1f626],
    \ "fuelpump": [0x26fd],
    \ "full_moon": [0x1f315],
    \ "full_moon_with_face": [0x1f31d],
    \ "game_die": [0x1f3b2],
    \ "gb": [0x1f1ec, 0x1f1e7],
    \ "gem": [0x1f48e],
    \ "gemini": [0x264a],
    \ "ghost": [0x1f47b],
    \ "gift": [0x1f381],
    \ "gift_heart": [0x1f49d],
    \ "girl": [0x1f467],
    \ "globe_with_meridians": [0x1f310],
    \ "goat": [0x1f410],
    \ "golf": [0x26f3],
    \ "grapes": [0x1f347],
    \ "green_apple": [0x1f34f],
    \ "green_book": [0x1f4d7],
    \ "green_heart": [0x1f49a],
    \ "grey_exclamation": [0x2755],
    \ "grey_question": [0x2754],
    \ "grimacing": [0x1f62c],
    \ "grin": [0x1f601],
    \ "grinning": [0x1f600],
    \ "guardsman": [0x1f482],
    \ "guitar": [0x1f3b8],
    \ "gun": [0x1f52b],
    \ "haircut": [0x1f487],
    \ "hamburger": [0x1f354],
    \ "hammer": [0x1f528],
    \ "hamster": [0x1f439],
    \ "hand": [0x270b],
    \ "handbag": [0x1f45c],
    \ "hankey": [0x1f4a9],
    \ "hash": [0x0023],
    \ "hatched_chick": [0x1f425],
    \ "hatching_chick": [0x1f423],
    \ "headphones": [0x1f3a7],
    \ "hear_no_evil": [0x1f649],
    \ "heart": [0x2764],
    \ "heart_decoration": [0x1f49f],
    \ "heart_eyes": [0x1f60d],
    \ "heart_eyes_cat": [0x1f63b],
    \ "heartbeat": [0x1f493],
    \ "heartpulse": [0x1f497],
    \ "hearts": [0x2665],
    \ "heavy_check_mark": [0x2714],
    \ "heavy_division_sign": [0x2797],
    \ "heavy_dollar_sign": [0x1f4b2],
    \ "heavy_exclamation_mark": [0x2757],
    \ "heavy_minus_sign": [0x2796],
    \ "heavy_multiplication_x": [0x2716],
    \ "heavy_plus_sign": [0x2795],
    \ "helicopter": [0x1f681],
    \ "herb": [0x1f33f],
    \ "hibiscus": [0x1f33a],
    \ "high_brightness": [0x1f506],
    \ "high_heel": [0x1f460],
    \ "hocho": [0x1f52a],
    \ "honey_pot": [0x1f36f],
    \ "honeybee": [0x1f41d],
    \ "horse": [0x1f434],
    \ "horse_racing": [0x1f3c7],
    \ "hospital": [0x1f3e5],
    \ "hotel": [0x1f3e8],
    \ "hotsprings": [0x2668],
    \ "hourglass": [0x231b],
    \ "hourglass_flowing_sand": [0x23f3],
    \ "house": [0x1f3e0],
    \ "house_with_garden": [0x1f3e1],
    \ "hushed": [0x1f62f],
    \ "ice_cream": [0x1f368],
    \ "icecream": [0x1f366],
    \ "id": [0x1f194],
    \ "ideograph_advantage": [0x1f250],
    \ "imp": [0x1f47f],
    \ "inbox_tray": [0x1f4e5],
    \ "incoming_envelope": [0x1f4e8],
    \ "information_desk_person": [0x1f481],
    \ "information_source": [0x2139],
    \ "innocent": [0x1f607],
    \ "interrobang": [0x2049],
    \ "iphone": [0x1f4f1],
    \ "it": [0x1f1ee, 0x1f1f9],
    \ "izakaya_lantern": [0x1f3ee],
    \ "jack_o_lantern": [0x1f383],
    \ "japan": [0x1f5fe],
    \ "japanese_castle": [0x1f3ef],
    \ "japanese_goblin": [0x1f47a],
    \ "japanese_ogre": [0x1f479],
    \ "jeans": [0x1f456],
    \ "joy": [0x1f602],
    \ "joy_cat": [0x1f639],
    \ "jp": [0x1f1ef, 0x1f1f5],
    \ "key": [0x1f511],
    \ "keycap_ten": [0x1f51f],
    \ "kimono": [0x1f458],
    \ "kiss": [0x1f48b],
    \ "kissing": [0x1f617],
    \ "kissing_cat": [0x1f63d],
    \ "kissing_closed_eyes": [0x1f61a],
    \ "kissing_heart": [0x1f618],
    \ "kissing_smiling_eyes": [0x1f619],
    \ "koala": [0x1f428],
    \ "koko": [0x1f201],
    \ "kr": [0x1f1f0, 0x1f1f7],
    \ "lantern": [0x1f3ee],
    \ "large_blue_circle": [0x1f535],
    \ "large_blue_diamond": [0x1f537],
    \ "large_orange_diamond": [0x1f536],
    \ "last_quarter_moon": [0x1f317],
    \ "last_quarter_moon_with_face": [0x1f31c],
    \ "laughing": [0x1f606],
    \ "leaves": [0x1f343],
    \ "ledger": [0x1f4d2],
    \ "left_luggage": [0x1f6c5],
    \ "left_right_arrow": [0x2194],
    \ "leftwards_arrow_with_hook": [0x21a9],
    \ "lemon": [0x1f34b],
    \ "leo": [0x264c],
    \ "leopard": [0x1f406],
    \ "libra": [0x264e],
    \ "light_rail": [0x1f688],
    \ "link": [0x1f517],
    \ "lips": [0x1f444],
    \ "lipstick": [0x1f484],
    \ "lock": [0x1f512],
    \ "lock_with_ink_pen": [0x1f50f],
    \ "lollipop": [0x1f36d],
    \ "loop": [0x27bf],
    \ "loudspeaker": [0x1f4e2],
    \ "love_hotel": [0x1f3e9],
    \ "love_letter": [0x1f48c],
    \ "low_brightness": [0x1f505],
    \ "m": [0x24c2],
    \ "mag": [0x1f50d],
    \ "mag_right": [0x1f50e],
    \ "mahjong": [0x1f004],
    \ "mailbox": [0x1f4eb],
    \ "mailbox_closed": [0x1f4ea],
    \ "mailbox_with_mail": [0x1f4ec],
    \ "mailbox_with_no_mail": [0x1f4ed],
    \ "man": [0x1f468],
    \ "man_with_gua_pi_mao": [0x1f472],
    \ "man_with_turban": [0x1f473],
    \ "mans_shoe": [0x1f45e],
    \ "maple_leaf": [0x1f341],
    \ "mask": [0x1f637],
    \ "massage": [0x1f486],
    \ "meat_on_bone": [0x1f356],
    \ "mega": [0x1f4e3],
    \ "melon": [0x1f348],
    \ "memo": [0x1f4dd],
    \ "mens": [0x1f6b9],
    \ "metro": [0x1f687],
    \ "microphone": [0x1f3a4],
    \ "microscope": [0x1f52c],
    \ "milky_way": [0x1f30c],
    \ "minibus": [0x1f690],
    \ "minidisc": [0x1f4bd],
    \ "mobile_phone_off": [0x1f4f4],
    \ "money_with_wings": [0x1f4b8],
    \ "moneybag": [0x1f4b0],
    \ "monkey": [0x1f412],
    \ "monkey_face": [0x1f435],
    \ "monorail": [0x1f69d],
    \ "moon": [0x1f314],
    \ "mortar_board": [0x1f393],
    \ "mount_fuji": [0x1f5fb],
    \ "mountain_bicyclist": [0x1f6b5],
    \ "mountain_cableway": [0x1f6a0],
    \ "mountain_railway": [0x1f69e],
    \ "mouse": [0x1f42d],
    \ "mouse2": [0x1f401],
    \ "movie_camera": [0x1f3a5],
    \ "moyai": [0x1f5ff],
    \ "muscle": [0x1f4aa],
    \ "mushroom": [0x1f344],
    \ "musical_keyboard": [0x1f3b9],
    \ "musical_note": [0x1f3b5],
    \ "musical_score": [0x1f3bc],
    \ "mute": [0x1f507],
    \ "nail_care": [0x1f485],
    \ "name_badge": [0x1f4db],
    \ "necktie": [0x1f454],
    \ "negative_squared_cross_mark": [0x274e],
    \ "neutral_face": [0x1f610],
    \ "new": [0x1f195],
    \ "new_moon": [0x1f311],
    \ "new_moon_with_face": [0x1f31a],
    \ "newspaper": [0x1f4f0],
    \ "ng": [0x1f196],
    \ "nine": [0x0039],
    \ "no_bell": [0x1f515],
    \ "no_bicycles": [0x1f6b3],
    \ "no_entry": [0x26d4],
    \ "no_entry_sign": [0x1f6ab],
    \ "no_good": [0x1f645],
    \ "no_mobile_phones": [0x1f4f5],
    \ "no_mouth": [0x1f636],
    \ "no_pedestrians": [0x1f6b7],
    \ "no_smoking": [0x1f6ad],
    \ "non-potable_water": [0x1f6b1],
    \ "nose": [0x1f443],
    \ "notebook": [0x1f4d3],
    \ "notebook_with_decorative_cover": [0x1f4d4],
    \ "notes": [0x1f3b6],
    \ "nut_and_bolt": [0x1f529],
    \ "o": [0x2b55],
    \ "o2": [0x1f17e],
    \ "ocean": [0x1f30a],
    \ "octopus": [0x1f419],
    \ "oden": [0x1f362],
    \ "office": [0x1f3e2],
    \ "ok": [0x1f197],
    \ "ok_hand": [0x1f44c],
    \ "ok_woman": [0x1f646],
    \ "older_man": [0x1f474],
    \ "older_woman": [0x1f475],
    \ "on": [0x1f51b],
    \ "oncoming_automobile": [0x1f698],
    \ "oncoming_bus": [0x1f68d],
    \ "oncoming_police_car": [0x1f694],
    \ "oncoming_taxi": [0x1f696],
    \ "one": [0x0031],
    \ "open_book": [0x1f4d6],
    \ "open_file_folder": [0x1f4c2],
    \ "open_hands": [0x1f450],
    \ "open_mouth": [0x1f62e],
    \ "ophiuchus": [0x26ce],
    \ "orange_book": [0x1f4d9],
    \ "outbox_tray": [0x1f4e4],
    \ "ox": [0x1f402],
    \ "package": [0x1f4e6],
    \ "page_facing_up": [0x1f4c4],
    \ "page_with_curl": [0x1f4c3],
    \ "pager": [0x1f4df],
    \ "palm_tree": [0x1f334],
    \ "panda_face": [0x1f43c],
    \ "paperclip": [0x1f4ce],
    \ "parking": [0x1f17f],
    \ "part_alternation_mark": [0x303d],
    \ "partly_sunny": [0x26c5],
    \ "passport_control": [0x1f6c2],
    \ "paw_prints": [0x1f43e],
    \ "peach": [0x1f351],
    \ "pear": [0x1f350],
    \ "pencil": [0x1f4dd],
    \ "pencil2": [0x270f],
    \ "penguin": [0x1f427],
    \ "pensive": [0x1f614],
    \ "performing_arts": [0x1f3ad],
    \ "persevere": [0x1f623],
    \ "person_frowning": [0x1f64d],
    \ "person_with_blond_hair": [0x1f471],
    \ "person_with_pouting_face": [0x1f64e],
    \ "phone": [0x260e],
    \ "pig": [0x1f437],
    \ "pig2": [0x1f416],
    \ "pig_nose": [0x1f43d],
    \ "pill": [0x1f48a],
    \ "pineapple": [0x1f34d],
    \ "pisces": [0x2653],
    \ "pizza": [0x1f355],
    \ "point_down": [0x1f447],
    \ "point_left": [0x1f448],
    \ "point_right": [0x1f449],
    \ "point_up": [0x261d],
    \ "point_up_2": [0x1f446],
    \ "police_car": [0x1f693],
    \ "poodle": [0x1f429],
    \ "poop": [0x1f4a9],
    \ "post_office": [0x1f3e3],
    \ "postal_horn": [0x1f4ef],
    \ "postbox": [0x1f4ee],
    \ "potable_water": [0x1f6b0],
    \ "pouch": [0x1f45d],
    \ "poultry_leg": [0x1f357],
    \ "pound": [0x1f4b7],
    \ "pouting_cat": [0x1f63e],
    \ "pray": [0x1f64f],
    \ "princess": [0x1f478],
    \ "punch": [0x1f44a],
    \ "purple_heart": [0x1f49c],
    \ "purse": [0x1f45b],
    \ "pushpin": [0x1f4cc],
    \ "put_litter_in_its_place": [0x1f6ae],
    \ "question": [0x2753],
    \ "rabbit": [0x1f430],
    \ "rabbit2": [0x1f407],
    \ "racehorse": [0x1f40e],
    \ "radio": [0x1f4fb],
    \ "radio_button": [0x1f518],
    \ "rage": [0x1f621],
    \ "railway_car": [0x1f683],
    \ "rainbow": [0x1f308],
    \ "raised_hand": [0x270b],
    \ "raised_hands": [0x1f64c],
    \ "raising_hand": [0x1f64b],
    \ "ram": [0x1f40f],
    \ "ramen": [0x1f35c],
    \ "rat": [0x1f400],
    \ "recycle": [0x267b],
    \ "red_car": [0x1f697],
    \ "red_circle": [0x1f534],
    \ "registered": [0x00ae],
    \ "relaxed": [0x263a],
    \ "relieved": [0x1f60c],
    \ "repeat": [0x1f501],
    \ "repeat_one": [0x1f502],
    \ "restroom": [0x1f6bb],
    \ "revolving_hearts": [0x1f49e],
    \ "rewind": [0x23ea],
    \ "ribbon": [0x1f380],
    \ "rice": [0x1f35a],
    \ "rice_ball": [0x1f359],
    \ "rice_cracker": [0x1f358],
    \ "rice_scene": [0x1f391],
    \ "ring": [0x1f48d],
    \ "rocket": [0x1f680],
    \ "roller_coaster": [0x1f3a2],
    \ "rooster": [0x1f413],
    \ "rose": [0x1f339],
    \ "rotating_light": [0x1f6a8],
    \ "round_pushpin": [0x1f4cd],
    \ "rowboat": [0x1f6a3],
    \ "ru": [0x1f1f7, 0x1f1fa],
    \ "rugby_football": [0x1f3c9],
    \ "runner": [0x1f3c3],
    \ "running": [0x1f3c3],
    \ "running_shirt_with_sash": [0x1f3bd],
    \ "sa": [0x1f202],
    \ "sagittarius": [0x2650],
    \ "sailboat": [0x26f5],
    \ "sake": [0x1f376],
    \ "sandal": [0x1f461],
    \ "santa": [0x1f385],
    \ "satellite": [0x1f4e1],
    \ "satisfied": [0x1f606],
    \ "saxophone": [0x1f3b7],
    \ "school": [0x1f3eb],
    \ "school_satchel": [0x1f392],
    \ "scissors": [0x2702],
    \ "scorpius": [0x264f],
    \ "scream": [0x1f631],
    \ "scream_cat": [0x1f640],
    \ "scroll": [0x1f4dc],
    \ "seat": [0x1f4ba],
    \ "secret": [0x3299],
    \ "see_no_evil": [0x1f648],
    \ "seedling": [0x1f331],
    \ "seven": [0x0037],
    \ "shaved_ice": [0x1f367],
    \ "sheep": [0x1f411],
    \ "shell": [0x1f41a],
    \ "ship": [0x1f6a2],
    \ "shirt": [0x1f455],
    \ "shit": [0x1f4a9],
    \ "shoe": [0x1f45e],
    \ "shower": [0x1f6bf],
    \ "signal_strength": [0x1f4f6],
    \ "six": [0x0036],
    \ "six_pointed_star": [0x1f52f],
    \ "ski": [0x1f3bf],
    \ "skull": [0x1f480],
    \ "sleeping": [0x1f634],
    \ "sleepy": [0x1f62a],
    \ "slot_machine": [0x1f3b0],
    \ "small_blue_diamond": [0x1f539],
    \ "small_orange_diamond": [0x1f538],
    \ "small_red_triangle": [0x1f53a],
    \ "small_red_triangle_down": [0x1f53b],
    \ "smile": [0x1f604],
    \ "smile_cat": [0x1f638],
    \ "smiley": [0x1f603],
    \ "smiley_cat": [0x1f63a],
    \ "smiling_imp": [0x1f608],
    \ "smirk": [0x1f60f],
    \ "smirk_cat": [0x1f63c],
    \ "smoking": [0x1f6ac],
    \ "snail": [0x1f40c],
    \ "snake": [0x1f40d],
    \ "snowboarder": [0x1f3c2],
    \ "snowflake": [0x2744],
    \ "snowman": [0x26c4],
    \ "sob": [0x1f62d],
    \ "soccer": [0x26bd],
    \ "soon": [0x1f51c],
    \ "sos": [0x1f198],
    \ "sound": [0x1f509],
    \ "space_invader": [0x1f47e],
    \ "spades": [0x2660],
    \ "spaghetti": [0x1f35d],
    \ "sparkle": [0x2747],
    \ "sparkler": [0x1f387],
    \ "sparkles": [0x2728],
    \ "sparkling_heart": [0x1f496],
    \ "speak_no_evil": [0x1f64a],
    \ "speaker": [0x1f50a],
    \ "speech_balloon": [0x1f4ac],
    \ "speedboat": [0x1f6a4],
    \ "star": [0x2b50],
    \ "star2": [0x1f31f],
    \ "stars": [0x1f303],
    \ "station": [0x1f689],
    \ "statue_of_liberty": [0x1f5fd],
    \ "steam_locomotive": [0x1f682],
    \ "stew": [0x1f372],
    \ "straight_ruler": [0x1f4cf],
    \ "strawberry": [0x1f353],
    \ "stuck_out_tongue": [0x1f61b],
    \ "stuck_out_tongue_closed_eyes": [0x1f61d],
    \ "stuck_out_tongue_winking_eye": [0x1f61c],
    \ "sun_with_face": [0x1f31e],
    \ "sunflower": [0x1f33b],
    \ "sunglasses": [0x1f60e],
    \ "sunny": [0x2600],
    \ "sunrise": [0x1f305],
    \ "sunrise_over_mountains": [0x1f304],
    \ "surfer": [0x1f3c4],
    \ "sushi": [0x1f363],
    \ "suspension_railway": [0x1f69f],
    \ "sweat": [0x1f613],
    \ "sweat_drops": [0x1f4a6],
    \ "sweat_smile": [0x1f605],
    \ "sweet_potato": [0x1f360],
    \ "swimmer": [0x1f3ca],
    \ "symbols": [0x1f523],
    \ "syringe": [0x1f489],
    \ "tada": [0x1f389],
    \ "tanabata_tree": [0x1f38b],
    \ "tangerine": [0x1f34a],
    \ "taurus": [0x2649],
    \ "taxi": [0x1f695],
    \ "tea": [0x1f375],
    \ "telephone": [0x260e],
    \ "telephone_receiver": [0x1f4de],
    \ "telescope": [0x1f52d],
    \ "tennis": [0x1f3be],
    \ "tent": [0x26fa],
    \ "thought_balloon": [0x1f4ad],
    \ "three": [0x0033],
    \ "thumbsdown": [0x1f44e],
    \ "thumbsup": [0x1f44d],
    \ "ticket": [0x1f3ab],
    \ "tiger": [0x1f42f],
    \ "tiger2": [0x1f405],
    \ "tired_face": [0x1f62b],
    \ "tm": [0x2122],
    \ "toilet": [0x1f6bd],
    \ "tokyo_tower": [0x1f5fc],
    \ "tomato": [0x1f345],
    \ "tongue": [0x1f445],
    \ "top": [0x1f51d],
    \ "tophat": [0x1f3a9],
    \ "tractor": [0x1f69c],
    \ "traffic_light": [0x1f6a5],
    \ "train": [0x1f683],
    \ "train2": [0x1f686],
    \ "tram": [0x1f68a],
    \ "triangular_flag_on_post": [0x1f6a9],
    \ "triangular_ruler": [0x1f4d0],
    \ "trident": [0x1f531],
    \ "triumph": [0x1f624],
    \ "trolleybus": [0x1f68e],
    \ "trophy": [0x1f3c6],
    \ "tropical_drink": [0x1f379],
    \ "tropical_fish": [0x1f420],
    \ "truck": [0x1f69a],
    \ "trumpet": [0x1f3ba],
    \ "tshirt": [0x1f455],
    \ "tulip": [0x1f337],
    \ "turtle": [0x1f422],
    \ "tv": [0x1f4fa],
    \ "twisted_rightwards_arrows": [0x1f500],
    \ "two": [0x0032],
    \ "two_hearts": [0x1f495],
    \ "two_men_holding_hands": [0x1f46c],
    \ "two_women_holding_hands": [0x1f46d],
    \ "u5272": [0x1f239],
    \ "u5408": [0x1f234],
    \ "u55b6": [0x1f23a],
    \ "u6307": [0x1f22f],
    \ "u6708": [0x1f237],
    \ "u6709": [0x1f236],
    \ "u6e80": [0x1f235],
    \ "u7121": [0x1f21a],
    \ "u7533": [0x1f238],
    \ "u7981": [0x1f232],
    \ "u7a7a": [0x1f233],
    \ "uk": [0x1f1ec, 0x1f1e7],
    \ "umbrella": [0x2614],
    \ "unamused": [0x1f612],
    \ "underage": [0x1f51e],
    \ "unlock": [0x1f513],
    \ "up": [0x1f199],
    \ "us": [0x1f1fa, 0x1f1f8],
    \ "v": [0x270c],
    \ "vertical_traffic_light": [0x1f6a6],
    \ "vhs": [0x1f4fc],
    \ "vibration_mode": [0x1f4f3],
    \ "video_camera": [0x1f4f9],
    \ "video_game": [0x1f3ae],
    \ "violin": [0x1f3bb],
    \ "virgo": [0x264d],
    \ "volcano": [0x1f30b],
    \ "vs": [0x1f19a],
    \ "walking": [0x1f6b6],
    \ "waning_crescent_moon": [0x1f318],
    \ "waning_gibbous_moon": [0x1f316],
    \ "warning": [0x26a0],
    \ "watch": [0x231a],
    \ "water_buffalo": [0x1f403],
    \ "watermelon": [0x1f349],
    \ "wave": [0x1f44b],
    \ "wavy_dash": [0x3030],
    \ "waxing_crescent_moon": [0x1f312],
    \ "waxing_gibbous_moon": [0x1f314],
    \ "wc": [0x1f6be],
    \ "weary": [0x1f629],
    \ "wedding": [0x1f492],
    \ "whale": [0x1f433],
    \ "whale2": [0x1f40b],
    \ "wheelchair": [0x267f],
    \ "white_check_mark": [0x2705],
    \ "white_circle": [0x26aa],
    \ "white_flower": [0x1f4ae],
    \ "white_large_square": [0x2b1c],
    \ "white_medium_small_square": [0x25fd],
    \ "white_medium_square": [0x25fb],
    \ "white_small_square": [0x25ab],
    \ "white_square_button": [0x1f533],
    \ "wind_chime": [0x1f390],
    \ "wine_glass": [0x1f377],
    \ "wink": [0x1f609],
    \ "wolf": [0x1f43a],
    \ "woman": [0x1f469],
    \ "womans_clothes": [0x1f45a],
    \ "womans_hat": [0x1f452],
    \ "womens": [0x1f6ba],
    \ "worried": [0x1f61f],
    \ "wrench": [0x1f527],
    \ "x": [0x274c],
    \ "yellow_heart": [0x1f49b],
    \ "yen": [0x1f4b4],
    \ "yum": [0x1f60b],
    \ "zap": [0x26a1],
    \ "zero": [0x0030],
    \ "zzz": [0x1f4a4]
  \ }
else
  let s:emoji_code = {}
endif

let s:emoji_map = {
\  'CommitCommentEvent':            'speech_balloon',
\  'CreateEvent':                   'sparkles',
\  'DeleteEvent':                   'x',
\  'DownloadEvent':                 'paperclip',
\  'FollowEvent':                   'green_heart',
\  'ForkEvent':                     'fork_and_knife',
\  'ForkApplyEvent':                'fork_and_knife',
\  'GistEvent':                     'pencil',
\  'GollumEvent':                   'pencil',
\  'IssueCommentEvent':             'speech_balloon',
\  'IssuesEvent':                   'exclamation',
\  'MemberEvent':                   'busts_in_silhouette',
\  'PublicEvent':                   'tada',
\  'PullRequestEvent':              'angel',
\  'PullRequestReviewCommentEvent': 'speech_balloon',
\  'PullRequestReviewEvent':        'hand',
\  'PushEvent':                     'dango',
\  'ReleaseEvent':                  'bookmark',
\  'TeamAddEvent':                  'busts_in_silhouette',
\  'WatchEvent':                    'star',
\  'user_dashboard':                'herb',
\  'user_activity':                 'cherry_blossom',
\  'repo_activity':                 'hibiscus'
\}

function! s:emoji(name, ...)
  if b:github_emoji && has_key(s:emoji_code, tolower(a:name))
    let e = s:emoji_code[tolower(a:name)]
    return join(map(copy(e), 'nr2char(v:val)'), '') . repeat(' ', 1 + (a:0 > 0 ? a:1 : 0))
  else
    return ''
  endif
endfunction

function! s:emoji_for(type, pad)
  let custom_map = s:option('emoji_map', {})
  if !empty(custom_map)
    " TODO inefficient
    let emoji_map = extend(copy(s:emoji_map), custom_map)
    return s:emoji(get(emoji_map, a:type, ''), a:pad)
  else
    return s:emoji(get(s:emoji_map, a:type, ''), a:pad)
  endif
endfunction

let s:original_statusline = &statusline

function! s:password(profile, username)
  let fromopt = s:option(a:profile, 'password', '')
  return empty(fromopt) ? get(s:passwords, a:profile.'/'.a:username, '') : fromopt
endfunction

function! s:remember_password(profile, username, password)
  let s:passwords[a:profile.'/'.a:username] = a:password
endfunction

function! s:forget_password(profile, username)
  silent! call remove(s:passwords, a:profile.'/'.a:username)
endfunction

function! s:option(...)
  if a:0 == 2
    let profile = get(b:, 'github_profile', '')
    let [key, default] = a:000
  elseif a:0 == 3
    let [profile, key, default] = a:000
  endif

  let options = get(g:, 'github_dashboard' . (empty(profile) ? '' : ('#' . profile)), {})
  return get(options, key, default)
endfunction

function! s:init_tab(...)
  let b:github_index = 0
  let b:github_error = 0
  let b:github_links = {}
  let b:github_emoji = s:is_mac && ((!has('gui_running') && s:option('emoji', 2) != 0) || s:option('emoji', 2) == 1)
  let b:github_indent = repeat(' ', b:github_emoji ? 11 : 8)
  let b:github_api_endpoint = s:option('api_endpoint', 'https://api.github.com')
  let b:github_web_endpoint = s:option('web_endpoint', 'https://github.com')

  if a:0 == 2
    setlocal buftype=nofile noswapfile nowrap nonu cursorline foldmethod=syntax
    call s:define_maps()
    setf github-dashboard

    let [what, type] = a:000
    let elems = len(filter(split(what, '/', 1), '!empty(v:val)'))
    if elems == 0 || elems > 2 | echoerr "Invalid username or repository" | return 0 | endif
    let path = elems == 1 ? '/users/' : '/repos/'
    let b:github_init_url = b:github_api_endpoint .path.what. "/" .type
    if type == 'received_events'
      if elems > 1 | echoerr "Use :GHActivity command instead" | return 0 | endif
      let b:github_statusline = ['Dashboard', what]
      let prefix = s:emoji_for('user_dashboard', 1)
    elseif type == 'events'
      let b:github_statusline = ['Activity', what]
      let prefix = s:emoji_for(elems == 1 ? 'user_activity' : 'repo_activity', 1)
    else
      echoerr "Invalid type"
      return 0
    endif

    " Assign buffer name
    let bufname_prefix = '['.prefix.split(what, '/')[-1].']'
    let bufname = bufname_prefix
    let bufidx = 2
    while buflisted(bufname)
      let bufname = bufname_prefix . '('. bufidx .')'
      let bufidx = bufidx + 1
    endwhile
    silent! execute "f ".fnameescape(bufname)
  endif
  let b:github_more_url = b:github_init_url

  if s:option('statusline', 1)
    setlocal statusline=%!github_dashboard#statusline()
  endif

  syntax clear
  syntax region githubTitle start=/^ \{0,2}[0-9]/ end="\n" oneline contains=githubNumber,Keyword,githubRepo,githubUser,githubTime,githubRef,githubCommit,githubTag,githubBranch,githubGist,githubRelease
  syntax match githubNumber /^ \{0,2}[0-9]\{-1,})/ contained
  syntax match githubTime   /(.\{-1,})$/ contained
  syntax match githubSHA    /^\s\+\[[0-9a-fA-F]\{4,}\]/
  syntax match githubEdit   /\(^\s\+Edited \)\@<=\[.\{-}\]/
  syntax match githubUser   /\[[^/\]]\{-1,}\]/ contained
  syntax match githubRepo   /\[[^/\]]\{-1,}\/[^/\]@]\{-1,}\]/ contained
  syntax match githubCommit /\[[^/\]]\{-1,}\/[^/\]@]\{-1,}@[0-9a-fA-Z]\{-1,}\]/ contained
  syntax match githubTag    /\(tag \)\@<=\[.\{-1,}\]/ contained
  syntax match githubBranch /\(branch \)\@<=\[.\{-1,}\]/ contained
  syntax match githubBranch /\(pushed to \)\@<=\[.\{-1,}\]/ contained
  syntax match githubGist   /\(a gist \)\@<=\[.\{-1,}\]/ contained
  syntax match githubRelease /\(released \)\@<=\[.\{-1,}\]/ contained

  syntax region githubFoldBlock start=/\%(\_^ \{4,}.*\n\)\{5}/ms=s+1 end=/\%(^ \{,4}\S\)\@=/ contains=githubFoldBlockLine2
  syntax region githubFoldBlockLine2 start=/^ \{4,}/ms=e+1 end=/\%(^ \{,4}\S\)\@=/ contained contains=githubFoldBlockLine3 keepend
  syntax region githubFoldBlockLine3 start=/^ \{4,}/ms=e+1 end=/\%(^ \{,4}\S\)\@=/ contained contains=githubFoldBlockLine4 keepend
  syntax region githubFoldBlockLine4 start=/^ \{4,}/ms=e+1 end=/\%(^ \{,4}\S\)\@=/ contained contains=githubFoldBlockLine5 keepend
  syntax region githubFoldBlockLine5 start=/^ \{4,}/ms=e+1 end=/\%(^ \{,4}\S\)\@=/ contained keepend fold

  hi def link githubNumber  Number
  hi def link githubUser    String
  hi def link githubRepo    Identifier
  hi def link githubRef     Special
  hi def link githubRelease Label
  hi def link githubTag     Label
  hi def link githubBranch  Label
  hi def link githubEdit    Constant
  hi def link githubTime    Comment
  hi def link githubSHA     Float
  hi def link githubCommit  Special
  hi def link githubGist    Identifier
  execute 'syntax match githubKeyword /'.s:more_line.'/'
  syntax match githubKeyword /^Loading.*/
  syntax match githubKeyword /^Reloading.*/
  syntax match githubFailure /^Failed.*/
  hi def link githubKeyword Conditional
  hi def link githubFailure Exception

  return 1
endfunction

function! s:refresh()
  call s:init_tab()
  setlocal modifiable
  normal! gg"_dG
  setlocal nomodifiable

  try
    call s:call_ruby('Reloading GitHub event stream ...')
  catch
    let b:github_error = 1
  endtry
  if b:github_error
    call setline(line('$'), 'Failed to load events. Press R to reload.')
    setlocal nomodifiable
    return
  endif
endfunction

function! s:open(profile, what, type)
  let pos = s:option('position', 'tab')
  if pos ==? 'tab'
    tabnew
  elseif pos ==? 'top'
    topleft new
  elseif pos ==? 'bottom'
    botright new
  elseif pos ==? 'above'
    aboveleft new
  elseif pos ==? 'below'
    belowright new
  elseif pos ==? 'left'
    vertical new
  elseif pos ==? 'right'
    vertical rightbelow new
  else
    echoerr "Invalid position: ". pos
    tabnew
    return 0
  endif

  let b:github_profile = a:profile
  return s:init_tab(a:what, a:type)
endfunction

function! s:call_ruby(msg)
  if !empty(s:not_loaded)
    echoerr s:not_loaded
    return
  endif

  setlocal modifiable
  call setline(line('$'), a:msg)
  redraw!
  ruby GitHubDashboard.more
  if !b:github_error
    setlocal nomodifiable
  end
  syntax sync minlines=0
endfunction

function! github_dashboard#open(auth, type, ...)
  if !empty(s:not_loaded)
    echoerr s:not_loaded
    return
  endif

  let profile = substitute(get(filter(copy(a:000), 'stridx(v:val, "-") == 0'), -1, ''), '^-*', '', '')
  if !empty(profile) && !exists('g:github_dashboard#'.profile)
    echoerr 'Profile not defined: '. profile
    return
  endif

  let args = filter(copy(a:000), 'stridx(v:val, "-") != 0')
  let username = s:option(profile, 'username', '')
  if a:auth
    if empty(username)
      call inputsave()
      let username = input('Enter GitHub username: ')
      call inputrestore()
      if empty(username) | echo "Empty username" | return | endif
    endif

    let password = s:password(profile, username)
    if empty(password)
      call inputsave()
      let password = inputsecret('Enter GitHub password: ')
      call inputrestore()
      if empty(password) | echo "Empty password" | return | endif
      call s:remember_password(profile, username, password)
    endif
  else
    let password = ''
  endif

  let who = get(args, 0, username)
  if empty(who) | echo "Username not given" | return | endif

  if !s:open(profile, who, a:type)
    bd
    return
  endif

  let b:github_username = username
  let b:github_password = password

  try
    call s:call_ruby('Loading GitHub event stream ...')
  catch /^Vim:Interrupt$/
    bd
    return
  catch
    bd
    throw 'Error: '.v:exception
  endtry

  let s:history[a:type][who] = 1
endfunction

function! s:define_maps()
  nnoremap <silent> <buffer> <Plug>(ghd-quit)     :<C-u>bd<cr>
  nnoremap <silent> <buffer> <Plug>(ghd-refresh)  :<C-u>call <SID>refresh()<cr>
  nnoremap <silent> <buffer> <Plug>(ghd-action)   :<C-u>call <SID>action()<cr>
  nnoremap <silent> <buffer> <Plug>(ghd-action)   :<C-u>call <SID>action()<cr>
  nnoremap <silent> <buffer> <Plug>(ghd-action)   :<C-u>call <SID>action()<cr>
  nnoremap <silent> <buffer> <Plug>(ghd-next)     :<C-u>silent! call <SID>next_item('')<cr>
  nnoremap <silent> <buffer> <Plug>(ghd-prev)     :<C-u>silent! call <SID>next_item('b')<cr>
  nmap <silent> <buffer> q             <Plug>(ghd-quit)
  nmap <silent> <buffer> R             <Plug>(ghd-refresh)
  nmap <silent> <buffer> <cr>          <Plug>(ghd-action)
  nmap <silent> <buffer> o             <Plug>(ghd-action)
  nmap <silent> <buffer> <2-LeftMouse> <Plug>(ghd-action)
  nmap <silent> <buffer> <c-n>         <Plug>(ghd-next)
  nmap <silent> <buffer> <c-p>         <Plug>(ghd-prev)
endfunction

function! s:find_url()
  let line = getline(line('.'))
  let nth   = 0
  let start = 0
  let col   = col('.') - 1
  while 1
    let idx = match(line, '\[.\{-}\]', start)
    if idx == -1 || idx > col | return '' | endif

    let eidx = match(line, '\[.\{-}\zs\]', start)
    if col >= idx && col <= eidx && has_key(b:github_links, line('.'))
      return get(b:github_links[line('.')], nth, '')
    endif

    let start = eidx + 1
    let nth   = nth + 1
  endwhile
  return ''
endfunction

function! s:open_url(url)
  let cmd = s:option('open_command', '')
  if empty(cmd)
    if s:is_mac
      let cmd = 'open'
    elseif s:is_win
      execute ':silent !start rundll32 url.dll,FileProtocolHandler'
            \ shellescape(fnameescape(a:url))
      return
    elseif executable('xdg-open')
      let cmd = 'xdg-open'
    else
      echo "Cannot determine command to open: ". a:url
      return
    endif
    silent! call system(cmd . ' ' . shellescape(a:url))
    return
  endif
  execute ':silent !' . cmd . ' ' . shellescape(fnameescape(a:url))
  redraw!
endfunction

function! github_dashboard#status()
  if exists('b:github_statusline')
    let [type, what] = b:github_statusline
    return { 'type': type, 'what': what, 'url': s:find_url() }
  else
    return {}
  end
endfunction

function! github_dashboard#statusline()
  if exists('b:github_statusline')
    let prefix = '[GitHub '.join(b:github_statusline, ': ').']'
    let url = s:find_url()
    if empty(url)
      return prefix
    else
      return prefix .' '. url
    endif
  endif
  return s:original_statusline
endfunction

function! github_dashboard#autocomplete(arg, cmd, cur)
  let type = (a:cmd =~ '^GHA') ? 'events' : 'received_events'
  return filter(keys(s:history[type]), 'v:val =~ "^'. escape(a:arg, '"') .'"')
endfunction

function! s:action()
  let line = getline(line('.'))
  if line == s:more_line
    try
      call s:call_ruby('Loading ...')
    catch /^Vim:Interrupt$/
      let b:github_error = 1
    endtry

    if b:github_error
      call setline(line('$'), s:more_line)
      setlocal nomodifiable
    endif
    return
  endif

  let url = s:find_url()
  if !empty(url)
    call s:open_url(url)
  endif
endfunction

function! s:next_item(flags)
  call search(
             \ '\(^ *-- \zsMORE\)\|' .
             \ '\(^ *\[\zs[0-9a-fA-F]\{4,}\]\)\|' .
             \ '\(^ *Edited \[\zs\)\|' .
             \ '\(\(^ \{0,2}[0-9].\{-}\)\@<=\[\zs\)', a:flags)
endfunction

" {{{
ruby << EOF
require 'rubygems' rescue nil # 1.9.1
begin
  require 'json/pure'
rescue LoadError
  begin
    require 'json'
  rescue LoadError
    VIM::command("let s:not_loaded = 'JSON gem is not installed. try: sudo gem install json_pure'")
  end
end

require 'net/https'
require 'time'

module GitHubDashboard
  class << self
    def fetch uri, username, password
      tried = false
      begin
        req = Net::HTTP::Get.new(uri.request_uri, 'User-Agent' => 'vim')
        req.basic_auth username, password unless password.empty?

        api_endpoint = URI(VIM::evaluate('b:github_api_endpoint'))
        http = Net::HTTP.new(api_endpoint.host, uri.port)
        http.use_ssl = api_endpoint.scheme == 'https'
        http.ca_file = ENV['SSL_CERT_FILE'] if ENV['SSL_CERT_FILE']
        ot = VIM::evaluate("s:option('api_open_timeout', 10)").to_i
        rt = VIM::evaluate("s:option('api_read_timeout', 20)").to_i
        http.open_timeout = ot
        http.read_timeout = rt

        http.request req
      rescue OpenSSL::SSL::SSLError
        unless tried
          # https://gist.github.com/pweldon/767249
          tried = true
          certpath = File.join(VIM::evaluate("s:basedir"), 'cacert.pem')
          unless File.exists?(certpath)
            File.open(certpath, 'w') { |f|
              Net::HTTP.start('curl.haxx.se', 80) do |http|
                http.open_timeout = ot
                http.read_timeout = rt
                res = http.get '/ca/cacert.pem'
                f << res.body
              end
            }
          end
          ENV['SSL_CERT_FILE'] = certpath
          retry
        end
        raise
      end
    end

    def more
      if 0 == VIM::evaluate('has("nvim")')
        main = Thread.current
        watcher = Thread.new {
          while VIM::evaluate('getchar(1)')
            sleep 0.1
          end
          main.kill
        }
      end
      overbose = $VERBOSE
      $VERBOSE = nil
      username = VIM::evaluate('b:github_username')
      password = VIM::evaluate('b:github_password')
      uri      = URI(VIM::evaluate('b:github_more_url'))
      prefix   = VIM::evaluate('b:github_web_endpoint')

      res = fetch uri, username, password
      if res.code !~ /^2/
        if %w[401 403].include? res.code
          # Invalidate credentials
          VIM::command(%[call s:forget_password(b:github_profile, b:github_username)])
          VIM::command(%[let b:github_username = ''])
          VIM::command(%[let b:github_password = ''])
        end
        error "#{JSON.parse(res.body)['message']} (#{res.code})"
        return
      end

      # Doesn't work on 1.8.7
      # more = res.header['Link'].scan(/(?<=<).*?(?=>; rel=\"next)/)[0]
      more = res.header['Link'] && res.header['Link'].scan(/<[^<>]*?>; rel=\"next/)[0]
      more = more && more.split('>; rel')[0][1..-1]

      VIM::command(%[normal! G"_d$])
      if more
        VIM::command(%[let b:github_more_url = '#{more}'])
      else
        VIM::command(%[unlet b:github_more_url])
      end

      bfr = VIM::Buffer.current
      result = JSON.parse(res.body)
      result.each do |event|
        VIM::command('let b:github_index = b:github_index + 1')
        index = VIM::evaluate('b:github_index')
        lines = process(prefix, event, index)
        lines.each_with_index do |line, idx|
          line, *links = line
          links = links.map { |l| l.start_with?('/') ? prefix + l : l }

          if idx == 0
            emoji = to_utf8 VIM::evaluate("s:emoji_for('#{event['type']}', 1)")
            line = emoji + line
            bfr.append bfr.count - 1,
              "#{index.to_s.rjust(3)}) #{line} (#{format_time event['created_at']})"
          else
            bfr.append bfr.count - 1, VIM::evaluate('b:github_indent') + line
          end
          VIM::command(%[let b:github_links[#{bfr.count - 1}] = [#{links.map { |e| vstr e }.join(', ')}]])
        end
      end
      bfr[bfr.count] = (more && !result.empty?) ? VIM::evaluate('s:more_line') : ''
      VIM::command(%[normal! ^zz])
    rescue Exception => e
      error e
    ensure
      watcher && watcher.kill
      $VERBOSE = overbose
    end

  private
    def process endpoint, event, idx
      who    = event['actor']['login']
      type   = event['type']
      data   = event['payload']
      where  = event['url']
      action = data['action']
      repo   = event['repo'] && event['repo']['name']

      who_url  = "#{endpoint}/#{who}"
      repo_url = "#{endpoint}/#{repo}"

      case type
      when 'CommitCommentEvent'
        [[ "[#{who}] commented on commit [#{repo}@#{data['comment']['commit_id'][0, 10]}]",
            who_url, data['comment']['html_url'] ]] +
        wrap(data['comment']['body']).map { |e| [e] }
      when 'CreateEvent'
        if data['ref']
          ref_url = repo_url + "/tree/#{data['ref']}"
          [["[#{who}] created #{data['ref_type']} [#{data['ref']}] at [#{repo}]", who_url, ref_url, repo_url]]
        else
          [["[#{who}] created #{data['ref_type']} [#{repo}]", who_url, repo_url]]
        end
      when 'DeleteEvent'
        [["[#{who}] deleted #{data['ref_type']} #{data['ref']} at [#{repo}]", who_url, repo_url]]
      when 'DownloadEvent'
        # TODO
        [["#{type} from [#{who}]"], who_url]
      when 'FollowEvent'
        whom = data['target']['login']
        [["[#{who}] started following [#{whom}]", who_url, "#{endpoint}/#{whom}"]]
      when 'ForkEvent'
        [["[#{who}] forked [#{repo}] to [#{data['forkee']['full_name']}]",
            who_url, repo_url, data['forkee']['html_url']]]
      when 'ForkApplyEvent'
        # TODO
        [["#{type} from [#{who}]"], who_url]
      when 'GistEvent'
        [["[#{who}] created a gist [#{data['gist']['html_url']}]", who_url, data['gist']['html_url']]]
      when 'GollumEvent'
        [["[#{who}] edited the [#{repo}]", who_url, repo_url]] +
        data['pages'].map { |page|
          ["Edited [#{page['title']}]", page['html_url']]
        }
      when 'IssueCommentEvent'
        [["[#{who}] commented on issue [#{repo}##{data['issue']['number']}]", who_url, data['comment']['html_url']]] +
        wrap(data['comment']['body']).map { |line| [line] }
      when 'IssuesEvent'
        title = emoji data['issue']['title']
        [
         ["[#{who}] #{action} issue [#{repo}##{data['issue']['number']}]", who_url, data['issue']['html_url']],
         [title]
        ]
      when 'MemberEvent'
        [["[#{who}] #{action} [#{data['member']['login']}] to [#{repo}]", who_url, data['member']['html_url'], repo_url]]
      when 'PublicEvent'
        [["[#{who}] open-sourced [#{repo}]", who_url, repo_url]]
      when 'PullRequestEvent'
        title = emoji data['pull_request']['title']
        [
         ["[#{who}] #{action} pull request [#{repo}##{data['number']}]", who_url, data['pull_request']['html_url']],
         [title]
        ]
      when 'PullRequestReviewEvent'
        prnum = data['pull_request']['url'].scan(/[0-9]+$/).first
        [["[#{who}] requested your review on pull request [#{repo}##{prnum}]", who_url, data['pull_request']['html_url']]]
      when 'PullRequestReviewCommentEvent'
        prnum = data['comment']['pull_request_url'].scan(/[0-9]+$/).first
        [["[#{who}] commented on pull request [#{repo}##{prnum}]", who_url, data['comment']['html_url']]] +
        wrap(data['comment']['body']).map { |e| [e] }
      when 'PushEvent'
        branch = data['ref'].split('/').drop(2).join('/')
        ref_url = repo_url + "/tree/#{branch}"
        [["[#{who}] pushed to [#{branch}] at [#{repo}]", who_url, ref_url, repo_url]] +
        data['commits'].map { |commit|
          title = emoji (commit['message'].lines.first || "").chomp
          ["[#{commit['sha'][0, 7]}] #{title}", repo_url + '/commit/' + commit['sha']]
        }
      when 'ReleaseEvent'
        release_url = data['release']['html_url']
        [[ "[#{who}] released [#{data['release']['name']}] at [#{repo}]",
            who_url,
            release_url,
            repo_url ]] +
        data['release']['assets'].map { |a| a['label'] }.compact.map { |a| [a] } # No URL in API
      when 'TeamAddEvent'
        # TODO
        [["#{type} from [#{who}]", who_url]]
      when 'WatchEvent'
        [["[#{who}] starred [#{repo}]", who_url, repo_url]]
      else
        [["#{type} from [#{who}]", who_url]]
      end
    end

    def wrap str
      tw = VIM::evaluate("&textwidth").to_i
      if tw == 0
        tw = 70
      else
        tw = [tw - 10, 1].max
      end

      emoji(str).each_line.map(&:rstrip).drop_while(&:empty?).map do |line|
        line.length > tw ?
          line.gsub(/(.{1,#{tw}})(\s+|$)/, "\\1\n").each_line.map(&:rstrip) : line
      end.flatten
    end

    def error e
      VIM::command(%[let b:github_error = 1])
      VIM::command(%[echoerr #{vstr e}])
    end

    def vstr s
      %["#{s.to_s.gsub '"', '\"'}"]
    end

    def format_time at
      time = Time.parse(at)
      diff = Time.now - time
      pdenom = 1
      [
        [60,           'second'],
        [60 * 60,      'minute'],
        [60 * 60 * 24, 'hour'  ],
        [nil, 'day']
      ].each do |pair|
        denom, unit = pair
        if denom.nil? || diff < denom
          t = diff.to_i / pdenom
          return "#{t} #{unit}#{t == 1 ? '' : 's'} ago"
        end
        pdenom = denom
      end
    end

    def to_utf8 str
      if str.respond_to?(:force_encoding)
        str.force_encoding('UTF-8')
      else
        str
      end
    end

    if VIM::evaluate("s:is_mac") == 1
      def emoji str
        str.gsub(/:[-+0-9a-zA-Z_]+:/) { |m|
          e = to_utf8 VIM::evaluate("s:emoji('#{m[1..-2]}')")
          e.empty? ? m : e
        }
      end
    else
      def emoji str
        str
      end
    end
  end
end
EOF
" }}}
