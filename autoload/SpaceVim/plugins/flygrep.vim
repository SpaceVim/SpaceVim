let s:MPT = SpaceVim#api#import('prompt')
let s:JOB = SpaceVim#api#import('job')


function! SpaceVim#plugins#flygrep#open()
    rightbelow split __flygrep__
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
    " setlocal nomodifiable
    redraw!
    call s:MPT.open()
endfunction

function! s:flygrep(expr) abort
    normal! "_ggdG
    call s:JOB.start(s:get_search_cmd('ag', a:expr), {
                \ 'on_stdout' : function('s:grep_stdout'),
                \ 'in_io' : 'null',
                \ 'on_exit' : function('s:grep_exit'),
                \ })
endfunction

let s:MPT._handle_fly = function('s:flygrep')

function! s:grep_stdout(id, data, event) abort
    for data in a:data
        call append('$', data)
    endfor
endfunction

function! s:grep_exit(id, data, event) abort
    
endfunction


function! s:get_search_cmd(exe, expr) abort
    if a:exe == 'grep'
        return ['grep', '-inHR', '--exclude-dir', '.git', a:expr, '.']
    elseif a:exe == 'rg'
        return ['rg', '-n', a:expr]
    else
        return [a:exe, a:expr]
    endif
endfunction
