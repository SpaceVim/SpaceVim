"=============================================================================
" banner.vim --- SpaceVim core#banner layer
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
function! SpaceVim#layers#core#banner#config() abort
  let vr = g:spacevim_version
  let g:_spacevim_welcome_banners = [
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '        /######                                     /##    /##/##              ',
        \ '       /##__  ##                                   | ##   | #|__/              ',
        \ '      | ##  \__/ /######  /######  /####### /######| ##   | ##/##/######/####  ',
        \ '      |  ###### /##__  ##|____  ##/##_____//##__  #|  ## / ##| #| ##_  ##_  ## ',
        \ '       \____  #| ##  \ ## /######| ##     | ########\  ## ##/| #| ## \ ## \ ## ',
        \ '       /##  \ #| ##  | ##/##__  #| ##     | ##_____/ \  ###/ | #| ## | ## | ## ',
        \ '      |  ######| #######|  ######|  ######|  #######  \  #/  | #| ## | ## | ## ',
        \ '       \______/| ##____/ \_______/\_______/\_______/   \_/   |__|__/ |__/ |__/ ',
        \ '               | ##                                                            ',
        \ '               | ##                                                            ',
        \ '               |__/                                                            ',
        \ '                      version : '.vr.'   by : spacevim.org                     ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '        $$$$$$\                                    $$\    $$\$$\               ',
        \ '       $$  __$$\                                   $$ |   $$ \__|              ',
        \ '       $$ /  \__|$$$$$$\  $$$$$$\  $$$$$$$\ $$$$$$\$$ |   $$ $$\$$$$$$\$$$$\   ',
        \ '       \$$$$$$\ $$  __$$\ \____$$\$$  _____$$  __$$\$$\  $$  $$ $$  _$$  _$$\  ',
        \ '        \____$$\$$ /  $$ |$$$$$$$ $$ /     $$$$$$$$ \$$\$$  /$$ $$ / $$ / $$ | ',
        \ '       $$\   $$ $$ |  $$ $$  __$$ $$ |     $$   ____|\$$$  / $$ $$ | $$ | $$ | ',
        \ '       \$$$$$$  $$$$$$$  \$$$$$$$ \$$$$$$$\\$$$$$$$\  \$  /  $$ $$ | $$ | $$ | ',
        \ '        \______/$$  ____/ \_______|\_______|\_______|  \_/   \__\__| \__| \__| ',
        \ '                $$ |                                                           ',
        \ '                $$ |                                                           ',
        \ '                \__|                                                           ',
        \ '                      version : '.vr.'   by : spacevim.org                     ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '     ┏━━━┓                                                                     ',
        \ '     ┃┏━┓┃ Welcome to                                                          ',
        \ '     ┃┗━━┓╋╋╋╋┏━━┓╋╋╋╋┏━━┓╋╋╋╋┏━━┓╋╋╋╋┏━━┓╋╋╋╋┏┓┏┓╋╋╋╋┏━┓╋╋╋╋┏┓┏┓              ',
        \ '     ┗━━┓┃┏━━┓┃┏┓┃┏━━┓┃┏┓┃┏━━┓┃┏━┛┏━━┓┃┃━┫┏━━┓┃┃┃┃┏━━┓┃ ┃┏━━┓┃┗┛┃              ',
        \ '     ┃┗━┛┃┗━━┛┃┗┛┃┗━━┛┃┏┓┃┗━━┛┃┗━┓┗━━┛┃┃━┫┗━━┛┃┗┛┃┗━━┛┃ ┃┗━━┛┃┃┃┃              ',
        \ '     ┗━━━┛╋╋╋╋┃┏━┛╋╋╋╋┗┛┗┛╋╋╋╋┗━━┛╋╋╋╋┗━━┛╋╋╋╋┗━━┛╋╋╋╋┗━┛╋╋╋╋┗┻┻┛              ',
        \ '     ╋╋╋╋╋╋╋╋╋┃┃                                                               ',
        \ '     ╋╋╋╋╋╋╋╋╋┗┛                                                               ',
        \ '                 version : '.vr.'   by : spacevim.org                          ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '      .d8888b.                                888     888d8b                   ', 
        \ '     d88P  Y88b                               888     888Y8P                   ', 
        \ '     Y88b.                                    888     888                      ', 
        \ '      "Y888b.  88888b.  8888b.  .d8888b .d88b.Y88b   d88P88888888b.d88b.       ', 
        \ '         "Y88b.888 "88b    "88bd88P"   d8P  Y8bY88b d88P 888888 "888 "88b      ', 
        \ '           "888888  888.d888888888     88888888 Y88o88P  888888  888  888      ', 
        \ '     Y88b  d88P888 d88P888  888Y88b.   Y8b.      Y888P   888888  888  888      ', 
        \ '      "Y8888P" 88888P" "Y888888 "Y8888P "Y8888    Y8P    888888  888  888      ',
        \ '               888                                                             ', 
        \ '               888                                                             ', 
        \ '               888     version : '.vr.'   by : spacevim.org                    ', 
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '      ██████  ██▓███   ▄▄▄       ▄████▄  ▓█████ ██▒   █▓ ██▓ ███▄ ▄███▓        ', 
        \ '    ▒██    ▒ ▓██░  ██▒▒████▄    ▒██▀ ▀█  ▓█   ▀▓██░   █▒▓██▒▓██▒▀█▀ ██▒        ',
        \ '    ░ ▓██▄   ▓██░ ██▓▒▒██  ▀█▄  ▒▓█    ▄ ▒███   ▓██  █▒░▒██▒▓██    ▓██░        ',
        \ '      ▒   ██▒▒██▄█▓▒ ▒░██▄▄▄▄██ ▒▓▓▄ ▄██▒▒▓█  ▄  ▒██ █░░░██░▒██    ▒██         ',
        \ '    ▒██████▒▒▒██▒ ░  ░ ▓█   ▓██▒▒ ▓███▀ ░░▒████▒  ▒▀█░  ░██░▒██▒   ░██▒        ',
        \ '    ▒ ▒▓▒ ▒ ░▒▓▒░ ░  ░ ▒▒   ▓▒█░░ ░▒ ▒  ░░░ ▒░ ░  ░ ▐░  ░▓  ░ ▒░   ░  ░        ',
        \ '    ░ ░▒  ░ ░░▒ ░       ▒   ▒▒ ░  ░  ▒    ░ ░  ░  ░ ░░   ▒ ░░  ░      ░        ',
        \ '    ░  ░  ░  ░░         ░   ▒   ░           ░       ░░   ▒ ░░      ░           ',
        \ '          ░                 ░  ░░ ░         ░  ░     ░   ░         ░           ',
        \ '                                ░                   ░                          ',
        \ '                                                                               ', 
        \ '                     version : '.vr.'   by : spacevim.org                      ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '      .▄▄ ·  ▄▄▄· ▄▄▄·  ▄▄· ▄▄▄ . ▌ ▐·▪  • ▌ ▄ ·                               ',
        \ '      ▐█ ▀. ▐█ ▄█▐█ ▀█ ▐█ ▌▪▀▄.▀·▪█·█▌██ ·██ ▐███▪                             ',
        \ '      ▄▀▀▀█▄ ██▀·▄█▀▀█ ██ ▄▄▐▀▀▪▄▐█▐█•▐█·▐█ ▌▐▌▐█·                             ',
        \ '      ▐█▄▪▐█▐█▪·•▐█ ▪▐▌▐███▌▐█▄▄▌ ███ ▐█▌██ ██▌▐█▌                             ',
        \ '       ▀▀▀▀ .▀    ▀  ▀ ·▀▀▀  ▀▀▀ . ▀  ▀▀▀▀▀  █▪▀▀▀                             ',
        \ '                                                                               ',
        \ '         version : '.vr.'   by : spacevim.org                                  ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '        ▄▄▄▄▄   █ ▄▄  ██   ▄█▄    ▄███▄      ▄   ▄█ █▀▄▀█                      ', 
        \ '       █     ▀▄ █   █ █ █  █▀ ▀▄  █▀   ▀      █  ██ █ █ █                      ', 
        \ '     ▄  ▀▀▀▀▄   █▀▀▀  █▄▄█ █   ▀  ██▄▄   █     █ ██ █ ▄ █                      ', 
        \ '      ▀▄▄▄▄▀    █     █  █ █▄  ▄▀ █▄   ▄▀ █    █ ▐█ █   █                      ', 
        \ '                 █       █ ▀███▀  ▀███▀    █  █   ▐    █                       ', 
        \ '                  ▀     █                   █▐        ▀                        ', 
        \ '                       ▀                    ▐                                  ', 
        \ '                                                                               ',
        \ '         version : '.vr.'   by : spacevim.org                                  ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '     ________                              ___    _______                      ',
        \ '     __  ___/________ ______ _____________ __ |  / /___(_)_______ ___          ',
        \ '     _____ \ ___  __ \_  __ `/_  ___/_  _ \__ | / / __  / __  __ `__ \         ',
        \ '     ____/ / __  /_/ // /_/ / / /__  /  __/__ |/ /  _  /  _  / / / / /         ',
        \ '     /____/  _  .___/ \__,_/  \___/  \___/ _____/   /_/   /_/ /_/ /_/          ',
        \ '             /_/                                                               ',
        \ '                                                                               ',
        \ '            version : '.vr.'   by : spacevim.org                               ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '     ______                                                                    ',
        \ '     \  ___)                                                                   ',
        \ '      \ \   ______  __  ____   __ ___  ____  _   _   _                         ',
        \ '       > > (  __  )/  \/ /\ \ / // __)/ ___)| | | | | |                        ',
        \ '      / /__ | || |( ()  <  \ v / > _)( (__  | | | |_| |                        ',
        \ '     /_____)|_||_| \__/\_\  > <  \___)\__ \  \_)| ._,_|                        ',
        \ '                           / ^ \        _) )    | |                            ',
        \ '                          /_/ \_\      (__/     |_|                            ',
        \ '                                                                               ',
        \ '            version : '.vr.'   by : spacevim.org                               ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '    .................................................................          ',
        \ '    .................................................................          ',
        \ '    ..%%%%...%%%%%....%%%%....%%%%...%%%%%%..%%..%%..%%%%%%..%%...%%.          ',
        \ '    .%%......%%..%%..%%..%%..%%..%%..%%......%%..%%....%%....%%%.%%%.          ',
        \ '    ..%%%%...%%%%%...%%%%%%..%%......%%%%....%%..%%....%%....%%.%.%%.          ',
        \ '    .....%%..%%......%%..%%..%%..%%..%%.......%%%%.....%%....%%...%%.          ',
        \ '    ..%%%%...%%......%%..%%...%%%%...%%%%%%....%%....%%%%%%..%%...%%.          ',
        \ '    .................................................................          ',
        \ '                                                                               ',
        \ '            version : '.vr.'   by : spacevim.org                               ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '          _____                   __      ___                                  ',
        \ '         / ____|                  \ \    / (_)                                 ',
        \ '        | (___  _ __   __ _  ___ __\ \  / / _ _ __ ___                         ',
        \ '         \___ \| \`_ \ / _` |/ __/ _ \ \/ / | | `_ ` _ \                       ',
        \ '         ____) | |_) | (_| | (_|  __/\  /  | | | | | | |                       ',
        \ '        |_____/| .__/ \__,_|\___\___| \/   |_|_| |_| |_|                       ',
        \ '               | |                                                             ',
        \ '               |_|                                                             ',
        \ '                                                                               ',
        \ '         version : '.vr.'   by : spacevim.org                                  ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '      #     # ### #     #    ###  #####     ######  #######  #####  #######    ',
        \ '      #     #  #  ##   ##     #  #     #    #     # #       #     #    #       ',
        \ '      #     #  #  # # # #     #  #          #     # #       #          #       ',
        \ '      #     #  #  #  #  #     #   #####     ######  #####    #####     #       ',
        \ '       #   #   #  #     #     #        #    #     # #             #    #       ',
        \ '        # #    #  #     #     #  #     #    #     # #       #     #    #       ',
        \ '         #    ### #     #    ###  #####     ######  #######  #####     #       ',
        \ '                                                                               ',
        \ '            version : '.vr.'   by : spacevim.org                               ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '',
        \ '',
        \ '     _    _ _____ ______     _____    _       ______  _______    _    ______  ',
        \ '  | |  | (_____)  ___ \   (_____)  | |     (____  \(_______)  | |  (_______)  ',
        \ '  | |  | |  _  | | _ | |     _      \ \     ____)  )_____      \ \  _         ',
        \ '   \ \/ /  | | | || || |    | |      \ \   |  __  (|  ___)      \ \| |        ',
        \ '    \  /  _| |_| || || |   _| |_ _____) )  | |__)  ) |_____ _____) ) |_____   ',
        \ '     \/  (_____)_||_||_|  (_____|______/   |______/|_______|______/ \______)  ',
        \ '',
        \ '                    version : '.vr.'   by : spacevim.org',
        \ '',
        \ ],
        \ [
        \ '',
        \ '',
        \ '.##.....##.####.........########.##.....##.########.########..########...#### ',
        \ '.##.....##..##.............##....##.....##.##.......##.....##.##.........#### ',
        \ '.##.....##..##.............##....##.....##.##.......##.....##.##.........#### ',
        \ '.#########..##...####......##....#########.######...########..######......##. ',
        \ '.##.....##..##...####......##....##.....##.##.......##...##...##............. ',
        \ '.##.....##..##....##.......##....##.....##.##.......##....##..##.........#### ',
        \ '.##.....##.####..##........##....##.....##.########.##.....##.########...#### ',
        \ '',
        \ '                 version : '.vr.'   by : spacevim.org',
        \ '',
        \ ],
        \ [
        \ '                                                                               ',
        \ '                                                                               ',
        \ '   .       .--.--.    .    .--. --.--.---..---.  .    ..---.                   ',
        \ '    \     /   |  |\  /|    |   )  |    |  |      |\  /||                       ',
        \ '     \   /    |  | \/ | o  |--:   |    |  |---   | \/ ||---                    ',
        \ '      \ /     |  |    |    |   )  |    |  |      |    ||                       ',
        \ '       `    --`--`    ` o  `--` --`--  `  `---`  `    ``---`                   ',
        \ '                                                                               ',
        \ '               version : '.vr.'   by : spacevim.org                            ',
        \ '                                                                               ',
        \ ],
        \ [
        \ '                                                                               ',
        \ '_______________________________________________________                        ',
        \ '=========(_)===(_) (_______)==(_______|_______|_)(_)(_)                        ',
        \ '=================| |===================================                        ',
        \ '=========| |===| | | ||_|| |==|  ___)====| |==| || || |                        ',
        \ '========= \ \=/ /| | |===| |==| |========| |==| || || |                        ',
        \ '========== \___/=|_|_|===|_|==|_|========|_|===\_____/                         ',
        \ '                                                                               ',
        \ '               version : '.vr.'   by : spacevim.org                            ',
        \ '                                                                               ',
        \ ]
        \ ]
endfunction

function! SpaceVim#layers#core#banner#health() abort
  call SpaceVim#layers#core#banner#config()
  return 1
endfunction

" vim:set et sw=2:
