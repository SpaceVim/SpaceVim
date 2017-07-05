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
    call s:MPT._build_prompt()
    if a:expr ==# ''
        redrawstatus
        return
    endif
    try 
        syn clear FileNames
    catch
    endtr
    exe 'syn match FileNames /' . substitute(a:expr, '\([/\\]\)', '\\\1', 'g') . '/'
    hi def link FileNames MoreMsg
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
    if s:grepid != 0
        call s:JOB.stop(s:grepid)
    endif
    normal! "_ggdG
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
    redrawstatus
    let s:grepid = 0
endfunction


function! s:get_search_cmd(exe, expr) abort
    if a:exe == 'grep'
        return ['grep', '-inHR', '--exclude-dir', '.git', a:expr, '.']
    elseif a:exe == 'rg'
        return ['rg', '-n', '-i', a:expr]
    else
        return [a:exe, a:expr]
    endif
endfunction

function! s:next_item() abort
    if line('.') == line('$')
        normal! gg
    else
        normal! j
    endif
    redrawstatus
    call s:MPT._build_prompt()
endfunction

function! s:previous_item() abort
    if line('.') == 1
        normal! G
    else
        normal! k
    endif
    redrawstatus
    call s:MPT._build_prompt()
endfunction

function! s:open_item() abort
    if line('.') != ''
        if s:grepid != 0
            call s:JOB.stop(s:grepid)
        endif
        call s:MPT._clear_prompt()
        let s:MPT._quit = 1
        normal! gF
        let nr = bufnr('%')
        q
        exe 'silent b' . nr
        normal! :
    endif
endfunction

let s:MPT._function_key = {
            \ "\<Tab>" : function('s:next_item'),
            \ "\<S-tab>" : function('s:previous_item'),
            \ "\<Return>" : function('s:open_item'),
            \ }

" statusline api
function! SpaceVim#plugins#flygrep#lineNr()
    if getline(1) == ''
        return ''
    else
        return line('.') . '/' . line('$')
    endif
endfunction
