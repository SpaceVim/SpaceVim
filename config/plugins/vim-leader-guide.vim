let g:leaderGuide_max_size = 15
let g:leaderGuide_submode_mappings = 
            \ { '<C-C>': 'win_close', '<PageDown>': 'page_down', '<PageUp>': 'page_up'}
let g:_spacevim_mappings.g = {'name' : 'git function',
            \ 'd' : ['Gita diff', 'git diff'],
            \ }
call leaderGuide#register_prefix_descriptions("\\", 'g:_spacevim_mappings')
call leaderGuide#register_prefix_descriptions("[unite]", 'g:_spacevim_unite_mappings')
