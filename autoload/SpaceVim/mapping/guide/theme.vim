function! SpaceVim#mapping#guide#theme#hi() abort
    let name = get(g:, 'colors_name', 'gruvbox')
    try
        let t = SpaceVim#mapping#guide#theme#{name}#palette()
    catch /^Vim\%((\a\+)\)\=:E117/
        let t = SpaceVim#mapping#guide#theme#gruvbox#palette()
    endtry
    call s:hi(t)
endfunction

function! s:hi(t) abort
    exe 'hi! LeaderGuiderPrompt cterm=bold gui=bold guifg=' . a:t[0][0] . ' guibg=' . a:t[0][1]
    exe 'hi! LeaderGuiderSep1 cterm=bold gui=bold guifg=' . a:t[0][1] . ' guibg=' . a:t[1][1]
    exe 'hi! LeaderGuiderName cterm=bold gui=bold guifg=' . a:t[1][0] . ' guibg=' . a:t[1][1]
    exe 'hi! LeaderGuiderSep2 cterm=bold gui=bold guifg=' . a:t[1][1] . ' guibg=' . a:t[2][1]
    exe 'hi! LeaderGuiderFill guifg=' . a:t[2][0] . ' guibg=' . a:t[2][1]
endfunction
