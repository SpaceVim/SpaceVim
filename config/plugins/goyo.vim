function! s:goyo_enter()
    silent !tmux set status off
    set noshowmode
    set noshowcmd
    set scrolloff=999
    Limelight
endfunction

function! s:goyo_leave()
    silent !tmux set status on
    set showmode
    set showcmd
    set scrolloff=5
endfunction
augroup goyo_map
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END
