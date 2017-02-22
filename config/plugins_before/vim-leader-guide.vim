if g:spacevim_realtime_leader_guide
    nnoremap <silent><nowait> <leader> :<c-u>LeaderGuide get(g:, 'mapleader', '\')<CR>
    vnoremap <silent> <leader> :<c-u>LeaderGuideVisual get(g:, 'mapleader', '\')<CR>
endif
