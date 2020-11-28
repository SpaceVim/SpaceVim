if !empty(g:_spacevim_key_sequence)
      \ && g:_spacevim_key_sequence !=# 'nil'
      \ && g:spacevim_escape_key_binding !=# g:_spacevim_key_sequence
exe printf('imap <silent>%s <C-r>=coc#refresh()<CR>', g:_spacevim_key_sequence)
endif
