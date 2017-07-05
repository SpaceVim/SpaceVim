let s:MPT = SpaceVim#api#import('prompt')
let s:JOB = SpaceVim#api#import('job')
let s:grepid = 0


function! SpaceVim#plugins#flygrep#open()
    rightbelow split __flygrep__
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
    " setlocal nomodifiable
    setf SpaceVimFlyGrep
    redraw!
    call s:MPT.open()
endfunction

function! s:flygrep(expr) abort
    if a:expr ==# ''
        return
    endif
    let exe = SpaceVim#mapping#search#default_tool()
    let s:grepid =  s:JOB.start(s:get_search_cmd(exe, a:expr), {
                \ 'on_stdout' : function('s:grep_stdout'),
                \ 'in_io' : 'null',
                \ 'on_exit' : function('s:grep_exit'),
                \ })
endfunction

let s:MPT._handle_fly = function('s:flygrep')

function! s:close_buffer() abort
    q
endfunction

let s:MPT._onclose = function('s:close_buffer')


function! s:close_grep_job() abort
    normal! "_ggdG
    if s:grepid != 0
        call s:JOB.stop(s:grepid)
    endif
endfunction

let s:MPT._oninputpro = function('s:close_grep_job')

function! s:grep_stdout(id, data, event) abort
    for data in filter(a:data, '!empty(v:val)')
        if getline(1) == ''
            call setline(1, data)
        else
            call append('$', data)
        endif
    endfor
    call s:MPT._build_prompt()
endfunction

function! s:grep_exit(id, data, event) abort
    let s:grepid = 0
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
