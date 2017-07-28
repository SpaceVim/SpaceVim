let s:MPT = SpaceVim#api#import('prompt')
let s:JOB = SpaceVim#api#import('job')
let s:SYS = SpaceVim#api#import('system')
let s:grepid = 0


function! SpaceVim#plugins#flygrep#open() abort
    rightbelow split __flygrep__
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
    let save_tve = &t_ve
    setlocal t_ve=
    " setlocal nomodifiable
    setf SpaceVimFlyGrep
    redraw!
    call s:MPT.open()
    let &t_ve = save_tve
endfunction

let s:grep_expr = ''
let s:grep_exe = SpaceVim#mapping#search#default_tool()
let s:grep_timer_id = 0

" @vimlint(EVL103, 1, a:timer)
function! s:grep_timer(timer) abort
    let s:grepid =  s:JOB.start(s:get_search_cmd(s:grep_exe, s:grep_expr), {
                \ 'on_stdout' : function('s:grep_stdout'),
                \ 'in_io' : 'null',
                \ 'on_exit' : function('s:grep_exit'),
                \ })
endfunction
" @vimlint(EVL103, 0, a:timer)

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
    let s:grep_expr = a:expr
    let s:grep_timer_id = timer_start(500, funcref('s:grep_timer'), {'repeat' : 1})
endfunction

let s:MPT._handle_fly = function('s:flygrep')

function! s:close_buffer() abort
    if s:grepid != 0
        call s:JOB.stop(s:grepid)
    endif
    if s:grep_timer_id != 0
        call timer_stop(s:grep_timer_id)
    endif
    q
endfunction

let s:MPT._onclose = function('s:close_buffer')


function! s:close_grep_job() abort
    if s:grepid != 0
        call s:JOB.stop(s:grepid)
    endif
    if s:grep_timer_id != 0
        call timer_stop(s:grep_timer_id)
    endif
    normal! "_ggdG
endfunction

let s:MPT._oninputpro = function('s:close_grep_job')

" @vimlint(EVL103, 1, a:data)
" @vimlint(EVL103, 1, a:id)
" @vimlint(EVL103, 1, a:event)
function! s:grep_stdout(id, data, event) abort
    let datas =filter(a:data, '!empty(v:val)')
    if getline(1) ==# ''
        call setline(1, datas)
    else
        call append('$', datas)
    endif
    call s:MPT._build_prompt()
endfunction

function! s:grep_exit(id, data, event) abort
    redrawstatus
    let s:grepid = 0
endfunction

" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:id)
" @vimlint(EVL103, 0, a:event)

function! s:get_search_cmd(exe, expr) abort
    if a:exe ==# 'grep'
        return ['grep', '-inHR', '--exclude-dir', '.git', a:expr, '.']
    elseif a:exe ==# 'rg'
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
    if getline('.') !=# ''
        if s:grepid != 0
            call s:JOB.stop(s:grepid)
        endif
        call s:MPT._clear_prompt()
        let s:MPT._quit = 1
        let line = getline('.')
        let filename = fnameescape(split(line, ':\d\+:')[0])
        let linenr = matchstr(line, ':\d\+:')[1:-2]
        q
        exe 'e ' . filename
        exe linenr
    endif
endfunction

function! s:double_click() abort
    if line('.') !=# ''
        if s:grepid != 0
            call s:JOB.stop(s:grepid)
        endif
        call s:MPT._clear_prompt()
        let s:MPT._quit = 1
        let isfname = &isfname
        if s:SYS.isWindows
            set isfname-=:
        endif
        normal! gF
        let nr = bufnr('%')
        q
        exe 'silent b' . nr
        normal! :
        let &isfname = isfname
    endif
endfunction

function! s:move_cursor() abort
    if v:mouse_win == winnr()
        let cl = line('.')
        if cl < v:mouse_lnum
            exe 'normal! ' . (v:mouse_lnum - cl) . 'j'
        elseif cl > v:mouse_lnum
            exe 'normal! ' . (cl - v:mouse_lnum) . 'k'
        endif
    endif
    call s:MPT._build_prompt()
endfunction

let s:MPT._function_key = {
            \ "\<Tab>" : function('s:next_item'),
            \ "\<ScrollWheelDown>" : function('s:next_item'),
            \ "\<S-tab>" : function('s:previous_item'),
            \ "\<ScrollWheelUp>" : function('s:previous_item'),
            \ "\<Return>" : function('s:open_item'),
            \ "\<LeftMouse>" : function('s:move_cursor'),
            \ "\<2-LeftMouse>" : function('s:double_click'),
            \ }

" statusline api
function! SpaceVim#plugins#flygrep#lineNr() abort
    if getline(1) ==# ''
        return ''
    else
        return line('.') . '/' . line('$')
    endif
endfunction
