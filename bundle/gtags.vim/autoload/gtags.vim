scriptencoding utf-8

if !executable('gtags')
    echohl WarningMsg
    echom 'you need to install gnu global!'
    echohl NONE
    finish
else
    let s:version = split(matchstr(split(system('gtags --version'), '\n')[0], '[0-9]\+\.[0-9]\+'), '\.')
endif

if exists('g:loaded_gtags')
    finish
endif
let g:loaded_gtags = 1


" SpaceVim's API

let s:JOB = SpaceVim#api#import('job')
let s:FILE = SpaceVim#api#import('file')


""
" Set the global command name. If it is not set, will use $GTAGSGLOBAL, and if
" $GTAGSGLOBAL still is an empty string, then will use 'global'.
let g:gtags_global_command = get(g:, 'gtags_global_command',
            \ empty($GTAGSGLOBAL) ? 'global' : $GTAGSGLOBAL
            \ )

""
" Enable/Disable default mappings. By default it is disabled.
let g:gtags_auto_map = get(g:, 'gtags_auto_map', 0)

""
" This setting will open the |quickfix| list when adding entries. A value of 2 will
" preserve the cursor position when the |quickfix| window is
" opened. Defaults to 2.
let g:gtags_open_list = get(g:, 'gtags_open_list', 2)

" -- ctags-x format
" let Gtags_Result = "ctags-x"
" let Gtags_Efm = "%*\\S%*\\s%l%\\s%f%\\s%m"
"
" -- ctags format
" let Gtags_Result = "ctags"
" let Gtags_Efm = "%m\t%f\t%l"
"
" Gtags_Use_Tags_Format is obsoleted.
if exists('g:Gtags_Use_Tags_Format')
    let g:Gtags_Result = 'ctags'
    let g:Gtags_Efm = "%m\t%f\t%l"
endif
if !exists('g:Gtags_Result')
    let g:Gtags_Result = 'ctags-x'
endif
if !exists('g:Gtags_Efm')
    let g:Gtags_Efm = "%*\\S%*\\s%l%\\s%f%\\s%m"
endif
" Character to use to quote patterns and file names before passing to global.
" (This code was drived from 'grep.vim'.)
if !exists('g:Gtags_Shell_Quote_Char')
    if has('win32') || has('win16') || has('win95')
        let g:Gtags_Shell_Quote_Char = '"'
    else
        let g:Gtags_Shell_Quote_Char = "'"
    endif
endif
if !exists('g:Gtags_Single_Quote_Char')
    if has('win32') || has('win16') || has('win95')
        let g:Gtags_Single_Quote_Char = "'"
        let g:Gtags_Double_Quote_Char = '\"'
    else
        let s:sq = "'"
        let s:dq = '"'
        let g:Gtags_Single_Quote_Char = s:sq . s:dq . s:sq . s:dq . s:sq
        let g:Gtags_Double_Quote_Char = '"'
    endif
endif

"
" Stack Object.
"
function! s:Stack() abort
    let l:this = {}
    let l:this.container = []

    function! l:this.push(item) abort
        call add(self.container, a:item)
    endfunction

    function! l:this.pop() abort
        if len(self.container) <= 0
            throw 'Stack Empty'
        endif

        let l:item = self.container[-1]
        unlet self.container[-1]

        return l:item
    endfunction

    return l:this
endfunction

function! s:Memorize() abort
    let l:data = {
                \'file': expand('%'),
                \'position': getpos('.'),
                \}
    call s:crumbs.push(l:data)
endfunction

function! gtags#remind() abort
    try
        let l:data = s:crumbs.pop()
    catch
        call s:Error(v:exception)
        return
    endtry

    execute 'e ' . l:data.file
    call setpos('.', l:data.position)
endfunction

if ! exists('s:crumbs')
    let s:crumbs = s:Stack()
endif

"
" Display error message.
"
function! s:Error(msg) abort
    echohl WarningMsg |
                \ echomsg 'Error: ' . a:msg |
                \ echohl None
endfunction
"
" Extract pattern or option string.
"
function! s:Extract(line, target) abort
    let l:option = ''
    let l:pattern = ''
    let l:force_pattern = 0
    let l:length = strlen(a:line)
    let l:i = 0

    " skip command name.
    if a:line =~# '^Gtags'
        let l:i = 5
    endif
    while l:i < l:length && a:line[l:i] ==# ' '
        let l:i = l:i + 1
    endwhile
    while l:i < l:length
        if a:line[l:i] ==# '-' && l:force_pattern == 0
            let l:i = l:i + 1
            " Ignore long name option like --help.
            if l:i < l:length && a:line[l:i] ==# '-'
                while l:i < l:length && a:line[l:i] !=# ' '
                    let l:i = l:i + 1
                endwhile
            else
                let l:c = ''
                while l:i < l:length && a:line[l:i] !=# ' '
                    let l:c = a:line[l:i]
                    let l:option = l:option . l:c
                    let l:i = l:i + 1
                endwhile
                if l:c ==# 'e'
                    let l:force_pattern = 1
                endif
            endif
        else
            let l:pattern = ''
            " allow pattern includes blanks.
            while l:i < l:length
                if a:line[l:i] ==# "'"
                    let l:pattern = l:pattern . g:Gtags_Single_Quote_Char
                elseif a:line[l:i] ==# '"'
                    let l:pattern = l:pattern . g:Gtags_Double_Quote_Char
                else
                    let l:pattern = l:pattern . a:line[l:i]
                endif
                let l:i = l:i + 1
            endwhile
            if a:target ==# 'pattern'
                return l:pattern
            endif
        endif
        " Skip blanks.
        while l:i < l:length && a:line[l:i] ==# ' '
            let l:i = l:i + 1
        endwhile
    endwhile
    if a:target ==# 'option'
        return l:option
    endif
    return ''
endfunction

"
" Trim options to avoid errors.
"
function! s:TrimOption(option) abort
    let l:option = ''
    let l:length = strlen(a:option)
    let l:i = 0

    while l:i < l:length
        let l:c = a:option[l:i]
        if l:c !~# '[cenpquv]'
            let l:option = l:option . l:c
        endif
        let l:i = l:i + 1
    endwhile
    return l:option
endfunction

"
" Execute global and load the result into quickfix window.
"
function! s:ExecLoad(option, long_option, pattern) abort
    " Execute global(1) command and write the result to a temporary file.
    let l:isfile = 0
    let l:option = ''
    let l:result = ''

    if a:option =~# 'f'
        let l:isfile = 1
        if filereadable(a:pattern) == 0
            call s:Error('File ' . a:pattern . ' not found.')
            return
        endif
    endif
    if a:long_option !=# ''
        let l:option = a:long_option . ' '
    endif
    " if s:version[0] > 6 || (s:version[0] == 6 && s:version[1] >= 5)
        " let l:option = l:option . '--nearness=' . expand('%:p:h') . ' '
    " endif
    let l:option = l:option . '--result=' . g:Gtags_Result . ' -q'
    let l:option = l:option . s:TrimOption(a:option)
    if l:isfile == 1
        let l:cmd = g:gtags_global_command . ' ' . l:option . ' ' . g:Gtags_Shell_Quote_Char . a:pattern . g:Gtags_Shell_Quote_Char
    else
        let l:cmd = g:gtags_global_command . ' ' . l:option . 'e ' . g:Gtags_Shell_Quote_Char . a:pattern . g:Gtags_Shell_Quote_Char
    endif

    let l:restore_gtagsroot = 0
    if empty($GTAGSROOT)
      let $GTAGSROOT = SpaceVim#plugins#projectmanager#current_root()
      let l:restore_gtagsroot = 1
    endif

    let l:restore_gtagsdbpath = 0
    if empty($GTAGSDBPATH)
      let $GTAGSDBPATH = s:FILE.unify_path(g:gtags_cache_dir) . s:FILE.path_to_fname($GTAGSROOT)
      let l:restore_gtagsdbpath = 1
    endif

    let l:result = system(l:cmd)

    " restore $GTAGSROOT and $GTAGSDBPATH to make it possible to switch
    " between multiple projects or parent/child projects
    if l:restore_gtagsroot
      let $GTAGSROOT = ''
    endif

    if l:restore_gtagsdbpath
      let $GTAGSDBPATH = ''
    endif

    e
    if v:shell_error != 0
        if v:shell_error == 2
            call s:Error('invalid arguments. (gtags.vim requires GLOBAL 5.7 or later)')
        elseif v:shell_error == 3
            call s:Error('GTAGS not found.')
        else
            call s:Error('global command failed. command line: ' . l:cmd)
        endif
        return
    endif
    if l:result ==# ''
        if a:option =~# 'f'
            call s:Error('No tags found in ' . a:pattern)
        elseif a:option =~# 'P'
            call s:Error('No path matches found for ' . a:pattern)
        elseif a:option =~# 'g'
            call s:Error('No line matches found for ' . a:pattern)
        else
            call s:Error('No tag matches found for ' . g:Gtags_Shell_Quote_Char . a:pattern . g:Gtags_Shell_Quote_Char)
        endif
        return
    endif

    call s:Memorize()

    " Open the quickfix window
    if g:gtags_open_list == 1
        botright copen
    elseif g:gtags_open_list == 2
        call s:save_prev_windows()
        botright copen
        call s:restore_prev_windows()
    endif
    " Parse the output of 'global -x or -t' and show in the quickfix window.
    let l:efm_org = &efm
    let &efm = g:Gtags_Efm
    cexpr! l:result
    let &efm = l:efm_org
endfunction

let s:prev_windows = []
function! s:save_prev_windows() abort
    let aw = winnr('#')
    let pw = winnr()
    if exists('*win_getid')
        let aw_id = win_getid(aw)
        let pw_id = win_getid(pw)
    else
        let aw_id = 0
        let pw_id = 0
    endif
    call add(s:prev_windows, [aw, pw, aw_id, pw_id])
endfunction

function! s:restore_prev_windows() abort
    let [aw, pw, aw_id, pw_id] = remove(s:prev_windows, 0)
    if winnr() != pw
        " Go back, maintaining the '#' window (CTRL-W_p).
        if pw_id
            let aw = win_id2win(aw_id)
            let pw = win_id2win(pw_id)
        endif
        if pw
            if aw
                exec aw . 'wincmd w'
            endif
            exec pw . 'wincmd w'
        endif
    endif
endfunction

"
" RunGlobal()
"
function! gtags#global(line) abort
    call gtags#logger#log('info', a:line)
    let l:pattern = s:Extract(a:line, 'pattern')

    if l:pattern ==# '%'
        let l:pattern = expand('%')
    elseif l:pattern ==# '#'
        let l:pattern = expand('#')
    endif
    let l:option = s:Extract(a:line, 'option')
    " If no pattern supplied then get it from user.
    if l:pattern ==# '' && l:option !=# 'P'
        let s:option = l:option
        if l:option =~# 'f'
            let l:line = input('Gtags for file: ', expand('%'), 'file')
        else
            let l:line = input('Gtags for pattern: ', expand('<cword>'), 'custom,GtagsCandidateCore')
        endif
        let l:pattern = s:Extract(l:line, 'pattern')
        if l:pattern ==# ''
            call s:Error('Pattern not specified.')
            return
        endif
    endif
    call s:ExecLoad(l:option, '', l:pattern)
endfunction

"
" Execute RunGlobal() depending on the current position.
"
function! gtags#cursor() abort
    let l:pattern = expand('<cword>')
    let l:option = "--from-here=\"" . line('.') . ':' . expand('%') . "\""
    call s:ExecLoad('', l:option, l:pattern)
endfunction

"
" Core Gtags function
"
function! gtags#func(type, pattern) abort
    let l:option = ''
    if a:type ==# 'g'
        let l:option .= ' -x '
    elseif a:type ==# 'r'
        let l:option .= ' -x -r '
    elseif a:type ==# 's'
        let l:option .= ' -x -s '
    elseif a:type ==# 'e'
        let l:option .= ' -x -g '
    elseif a:type ==# 'f'
        let l:option .= ' -x -P '
    endif
    call s:ExecLoad('', l:option, a:pattern)
endfunction

"
" Show the current position on mozilla.
" (You need to execute htags(1) in your source directory.)
"
function! gtags#gozilla() abort
    let l:lineno = line('.')
    let l:filename = expand('%')
    call system('gozilla +' . l:lineno . ' ' . l:filename)
endfunction

"
" Custom completion.
"
function! gtags#complete(lead, line, pos) abort
    let s:option = s:Extract(a:line, 'option')
    return s:GtagsCandidateCore(a:lead, a:line, a:pos)
endfunction

function! s:GtagsCandidateCore(lead, ...) abort
    if s:option ==# 'g'
        return ''
    elseif s:option ==# 'f'
        if isdirectory(a:lead)
            if a:lead =~# '/$'
                let l:pattern = a:lead . '*'
            else
                let l:pattern = a:lead . '/*'
            endif
        else
            let l:pattern = a:lead . '*'
        endif
        return glob(l:pattern)
    else
        let l:cands = system(g:gtags_global_command . ' ' . '-c' . s:option . ' ' . a:lead)
        if v:shell_error == 0
            return l:cands
        endif
        return ''
    endif
endfunction

function! gtags#show_lib_path() abort
    echo $GTAGSLIBPATH
endfunction

function! gtags#add_lib(path) abort
    let $GTAGSLIBPATH .= ':'.a:path
    echo $GTAGSLIBPATH
endfunction

let s:progress = 0

function! gtags#update(single_update) abort
    let dir = s:FILE.unify_path(g:gtags_cache_dir) 
                \ . s:FILE.path_to_fname(SpaceVim#plugins#projectmanager#current_root())
    let cmd = ['gtags']
    if !empty(g:gtags_gtagslabel)
        let cmd += ['--gtagslabel=' . g:gtags_gtagslabel]
    endif
    if a:single_update && filereadable(dir . '/GTAGS')
        let cmd += ['--single-update', expand('%:p')]
    else
        let cmd += ['--skip-unreadable']
    endif
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
    let cmd += ['-O', dir]
    let s:progress = s:JOB.start(cmd, {'on_exit' : funcref('s:on_update_exit')})
endfunction

function! s:on_update_exit(...) abort
    let s:progress = 0
    if str2nr(a:2) > 0 && !g:gtags_silent
        echohl WarningMsg
        echo 'failed to update gtags, exit data: ' . a:2
        echohl None
    endif
endfunction

