" ============================================================================
" File:        mundo.vim
" Description: vim global plugin to visualize your undo tree
" Maintainer:  Hyeon Kim <simnalamburt@gmail.com>
" License:     GPLv2+ -- look it up.
" Notes:       Much of this code was thiefed from Mercurial, and the rest was
"              heavily inspired by scratch.vim and histwin.vim.
"
" ============================================================================


let s:save_cpo = &cpoptions
set cpoptions&vim

"{{{ Init

" Initialise global vars
let s:auto_preview_timer = -1"{{{
let s:preview_outdated = 1
let s:has_supported_python = 0
let s:has_timers = 0
let s:init_error = 'Initialisation failed due to an unknown error. '
            \ . 'Please submit a bug report :)'

" This has to be outside of a function, otherwise it just picks up the CWD
let s:plugin_path = escape(expand('<sfile>:p:h'), '\')"}}}

" Default to placeholder functions for exposed methods
function! mundo#MundoToggle() abort "{{{
    call mundo#util#Echo('WarningMsg',
                \ 'Mundo init error: ' . s:init_error)
endfunction

function! mundo#MundoShow() abort
    call mundo#util#Echo('WarningMsg',
                \ 'Mundo init error: ' . s:init_error)
endfunction

function! mundo#MundoHide() abort
    call mundo#util#Echo('WarningMsg',
                \ 'Mundo init error: ' . s:init_error)
endfunction
"}}}

" Check vim version
if v:version <? '703'"{{{
    let s:init_error = 'Vim version 7.03+ or later is required.'
    let &cpoptions = s:save_cpo
    finish
elseif v:version >=? '800' && has('timers')
    let s:has_timers = 1
endif"}}}

" Check python version
if g:mundo_prefer_python3 && has('python3')"{{{
    let s:has_supported_python = 2
elseif has('python')"
    let s:has_supported_python = 1
elseif has('python3')"
    let s:has_supported_python = 2
endif

if !s:has_supported_python
    let s:init_error = 'A supported python version was not found.'
    let &cpoptions = s:save_cpo
    finish
endif"}}}

" Python init methods
function! s:InitPythonModule(python)"{{{
    exe a:python .' import sys'
    exe a:python .' if sys.version_info[:2] < (2, 4): '.
                \ 'vim.command("let s:has_supported_python = 0")'
endfunction"}}}

function! s:MundoSetupPythonPath()"{{{
    if g:mundo_python_path_setup == 0
        let g:mundo_python_path_setup = 1
        call s:MundoPython('sys.path.insert(1, "'. s:plugin_path .'")')
        call s:MundoPython('sys.path.insert(1, "'. s:plugin_path .'/mundo")')
    end
endfunction"}}}
"}}}

"{{{ Mundo buffer settings

function! s:MundoMakeMapping(mapping, action)
    exec 'nnoremap <script> <silent> <buffer> ' . a:mapping .' '. a:action
endfunction

function! s:MundoMapGraph()"{{{
    for key in keys(g:mundo_mappings)
        let l:value = g:mundo_mappings[key]
        if l:value == "move_older"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPython('MundoMove(1,'. v:count .')')<CR>")
        elseif l:value == "move_newer"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPython('MundoMove(-1,'. v:count .')')<CR>")
        elseif l:value == "preview"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoRenderPreview(1)<CR>:<C-u> call <sid>MundoPythonRestoreView('MundoRevert()')<CR>")
        elseif l:value == "move_older_write"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPython('MundoMove(1,'.v:count.',True,True)')<CR>")
        elseif l:value == "move_newer_write"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPython('MundoMove(-1,'.v:count.',True,True)')<CR>")
        elseif l:value == "move_top"
            call s:MundoMakeMapping(key, "gg:<C-u>call <sid>MundoPython('MundoMove(1,'.v:count.')')<CR>")
        elseif l:value == "move_bottom"
            call s:MundoMakeMapping(key, "G:<C-u>call <sid>MundoPython('MundoMove(0,0)')<CR>:<C-u>call <sid>MundoRefresh()<CR>")
        elseif l:value == "play_to"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPythonRestoreView('MundoPlayTo()')<CR>zz")
        elseif l:value == "diff"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPythonRestoreView('MundoRenderPatchdiff()')<CR>")
        elseif l:value == "toggle_inline"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPythonRestoreView('MundoRenderToggleInlineDiff()')<CR>")
        elseif l:value == "search"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPython('MundoSearch()')<CR>")
        elseif l:value == "next_match"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPython('MundoNextMatch()')<CR>")
        elseif l:value == "previous_match"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPython('MundoPrevMatch()')<CR>")
        elseif l:value == "diff_current_buffer"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPythonRestoreView('MundoRenderChangePreview()')<CR>")
        elseif l:value == "diff"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoRenderPreview(1)<CR>")
        elseif l:value == "toggle_help"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoPython('MundoToggleHelp()')<CR>")
        elseif l:value == "quit"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoClose()<CR>")
        elseif l:value == "mouse_click"
            call s:MundoMakeMapping(key, ":<C-u>call <sid>MundoMouseDoubleClick()<CR>")
        endif
    endfor

    cabbrev  <script> <silent> <buffer> q     call <sid>MundoClose()
    cabbrev  <script> <silent> <buffer> quit  call <sid>MundoClose()
endfunction"}}}

function! s:MundoMapPreview()"{{{
    nnoremap <script> <silent> <buffer> q     :<C-u>call <sid>MundoClose()<CR>
    cabbrev  <script> <silent> <buffer> q     call <sid>MundoClose()
    cabbrev  <script> <silent> <buffer> quit  call <sid>MundoClose()
endfunction"}}}

function! s:MundoSettingsGraph()"{{{
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal filetype=Mundo
    setlocal nolist
    setlocal nonumber
    setlocal norelativenumber
    setlocal nowrap
    call s:MundoSyntaxGraph()
    call s:MundoMapGraph()
endfunction"}}}

function! s:MundoSettingsPreview()"{{{
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal filetype=MundoDiff
    setlocal syntax=diff
    setlocal nonumber
    setlocal norelativenumber
    setlocal nowrap
    setlocal foldlevel=20
    setlocal foldmethod=diff
    call s:MundoMapPreview()
endfunction"}}}

function! s:MundoSyntaxGraph()"{{{
    let b:current_syntax = 'mundo'
    syn match MundoCurrentLocation '@'
    syn match MundoHelp '\v^".*$'
    syn match MundoNumberField '\v\[[0-9]+\]'
    syn match MundoNumber '\v[0-9]+' contained containedin=MundoNumberField
    syn region MundoDiff start=/\v<ago> / end=/$/
    syn match MundoDiffAdd '\v\+[^+-]+\+' contained containedin=MundoDiff
    syn match MundoDiffDelete '\v-[^+-]+-' contained containedin=MundoDiff
    hi def link MundoCurrentLocation Keyword
    hi def link MundoHelp Comment
    hi def link MundoNumberField Comment
    hi def link MundoNumber Identifier
    hi def link MundoDiffAdd DiffAdd
    hi def link MundoDiffDelete DiffDelete
endfunction"}}}

"}}}

"{{{ Mundo buffer/window management

function! s:MundoResizeBuffers(backto)"{{{
    call mundo#util#GoToBuffer('__Mundo__')
    exe "vertical resize " . g:mundo_width

    call mundo#util#GoToBuffer('__Mundo_Preview__')
    exe "resize " . g:mundo_preview_height

    exe a:backto . "wincmd w"
endfunction"}}}

" Open the graph window. Assumes that the preview window is open.
function! s:MundoOpenGraph()"{{{
    if !mundo#util#GoToBuffer("__Mundo__")
        call assert_true(mundo#util#GoToBuffer('__Mundo_Preview__'))
        let existing_mundo_buffer = bufnr("__Mundo__")

        if existing_mundo_buffer == -1
            " Create buffer
            silent new __Mundo__

            if g:mundo_preview_bottom
                execute 'wincmd ' . (g:mundo_right ? 'L' : 'H')
            endif
        else
            " Open a window for existing buffer
            if g:mundo_preview_bottom
                let pos = (g:mundo_right ? 'botright' : 'topleft')
                silent execute pos.' vsplit +buffer' . existing_mundo_buffer
            else
                silent execute 'split +buffer' . existing_mundo_buffer
            endif
        endif

        call s:MundoResizeBuffers(winnr())
    endif

    if exists("g:mundo_tree_statusline")
        let &l:statusline = g:mundo_tree_statusline
    endif
endfunction"}}}

function! s:MundoOpenPreview()"{{{
    if !mundo#util#GoToBuffer("__Mundo_Preview__")
        let existing_preview_buffer = bufnr("__Mundo_Preview__")

        if existing_preview_buffer == -1
            " Create buffer
            if g:mundo_preview_bottom
                silent botright keepalt new __Mundo_Preview__
            else
                let pos = (g:mundo_right ? 'botright' : 'topleft')
                silent execute pos.' keepalt vnew __Mundo_Preview__'
            endif
        else
            " Open a window for existing buffer
            if g:mundo_preview_bottom
                silent execute 'botright keepalt split +buffer' .
                            \ existing_preview_buffer
            else
                let pos = (g:mundo_right ? 'botright' : 'topleft')
                silent execute pos.' keepalt vsplit +buffer' .
                            \ existing_preview_buffer
            endif
        endif
    endif

    if exists("g:mundo_preview_statusline")
        let &l:statusline = g:mundo_preview_statusline
    endif
endfunction"}}}

" Quits *all* open Mundo graph and preview windows.
function! s:MundoClose() abort
    let [l:tabid, l:winid] = win_id2tabwin(win_getid())

    " Close all graph and preview windows
    while mundo#util#GoToBufferGlobal('__Mundo__') ||
                \ mundo#util#GoToBufferGlobal('__Mundo_Preview__')
        quit
    endwhile

    " Attempt to return to previous window / tab or target buffer
    if win_gotoid(l:winid)
        return
    elseif l:tabid != 0 && l:tabid <= tabpagenr('$')
        execute 'normal! ' . l:tabid . 'gt'
    endif

    call mundo#util#GoToBuffer(get(g:, 'mundo_target_n', -1))
endfunction

" Returns 1 if the current buffer is a valid target buffer for Mundo, or a
" (falsy) string indicating the reason if otherwise.
function! s:MundoValidateBuffer()"{{{
    if !&modifiable
        let reason = 'is not modifiable'
    elseif &previewwindow
        let reason = 'is a preview window'
    elseif &buftype == 'help' || &buftype == 'quickfix' || &buftype == 'terminal'
        let reason = 'is a '.&buftype.' window'
    else
        return 1
    endif

    call mundo#util#Echo('None', 'Current buffer ('.bufnr('').') is not a '
                \ .'valid target for Mundo (Reason: '.reason.')')
    return 0
endfunction "}}}

" Returns True if the graph or preview windows are open in the current tab.
function! s:MundoIsVisible()"{{{
    return bufwinnr(bufnr("__Mundo__")) != -1 ||
                \ bufwinnr(bufnr("__Mundo_Preview__")) != -1
endfunction"}}}

" Open/reopen Mundo for the current buffer, initialising the python module if
" necessary.
function! s:MundoOpen() abort "{{{
    " Validate current buffer
    if !s:MundoValidateBuffer()
        return
    endif

    let g:mundo_target_n = bufnr('')
    call s:MundoClose()

    " Initialise python module if necessary
    if !exists('g:mundo_py_loaded')
        call s:MundoSetupPythonPath()

        if s:has_supported_python == 2
            exe 'py3file ' . escape(s:plugin_path, ' ') . '/mundo.py'
            call s:InitPythonModule('python3')
        else
            exe 'pyfile ' . escape(s:plugin_path, ' ') . '/mundo.py'
            call s:InitPythonModule('python')
        endif

        let g:mundo_py_loaded = 1
    endif

    " Save and reset `splitbelow` to avoid window positioning problems
    let saved_splitbelow = &splitbelow
    let &splitbelow = 0

    " Temporarily disable automatic previews until Mundo is opened
    let saved_auto_preview = g:mundo_auto_preview
    let g:mundo_auto_preview = 0

    " Create / open graph and preview windows
    call s:MundoOpenPreview()
    call mundo#util#GoToBuffer(g:mundo_target_n)
    call s:MundoOpenGraph()

    " Render the graph and preview, ensure the cursor is on a graph node
    call s:MundoPythonRestoreView('MundoRenderGraph(True)')
    call s:MundoRenderPreview()
    call s:MundoPython('MundoMove(0,0)')

    " Restore `splitbelow` and automatic preview option
    let &splitbelow = saved_splitbelow
    let g:mundo_auto_preview = saved_auto_preview
endfunction"}}}

function! s:MundoToggle()"{{{
    if s:MundoIsVisible()
        call s:MundoClose()
    else
        call s:MundoOpen()
    endif
endfunction"}}}

function! s:MundoShow()"{{{
    if !s:MundoIsVisible()
        call s:MundoOpen()
    endif
endfunction"}}}

function! s:MundoHide()"{{{
    call s:MundoSetupPythonPath()
    if s:MundoIsVisible()
        call s:MundoClose()
    endif
endfunction"}}}

"}}}

"{{{ Mundo mouse handling

function! s:MundoMouseDoubleClick()"{{{
    let start_line = getline('.')

    if stridx(start_line, '[') == -1
        return
    else
        call <sid>MundoPythonRestoreView('MundoRevert()')
    endif
endfunction"}}}

"}}}

"{{{ Mundo rendering

function! s:MundoPython(fn)"{{{
    exec "python".(s:has_supported_python == 2 ? '3' : '')." ". a:fn
endfunction"}}}

" Wrapper for MundoPython() that restores the window state and prevents other
" Mundo autocommands (with the exception of BufNewFile) from triggering.
function! s:MundoPythonRestoreView(fn)"{{{
    " Store view data, mode, window and 'evntignore' value
    let currentmode = mode()
    let currentWin = winnr()
    let winView = winsaveview()
    let eventignoreBack = &eventignore
    set eventignore=BufLeave,BufEnter,CursorHold,CursorMoved,TextChanged
                \,InsertLeave

    " Call python function
    call s:MundoPython(a:fn)

    " Restore view data
    execute currentWin .'wincmd w'
    call winrestview(winView)
    exec 'set eventignore='.eventignoreBack

    " Re-select visual selection
    if currentmode == 'v' || currentmode == 'V' || currentmode == ''
        execute 'normal! gv'
    endif
endfunction"}}}

" Accepts an optional integer that forces rendering if nonzero.
function! s:MundoRenderPreview(...)"{{{
    if !s:preview_outdated && (a:0 < 1 || !a:1)
        return
    endif

    call s:MundoPythonRestoreView('MundoRenderPreview()')
endfunction"}}}

"}}}

"{{{ Misc

" automatically reload Mundo buffer if open
function! s:MundoRefresh()"{{{
    " abort if Mundo is closed or cursor is in the preview window
    let mundoWin    = bufwinnr('__Mundo__')
    let mundoPreWin = bufwinnr('__Mundo_Preview__')
    let currentWin  = bufwinnr('%')

    if mundoWin == -1 || mundoPreWin == -1 || mundoPreWin == currentWin
        return
    endif

    " Disable the automatic preview delay if vim lacks support for timers
    if g:mundo_auto_preview_delay > 0 && !s:has_timers
        let g:mundo_auto_preview_delay = 0
        call mundo#util#Echo('WarningMsg',
                    \ 'The "g:mundo_auto_preview_delay" option requires'
                    \ .' support for timers. Please upgrade to either vim 8.0+'
                    \ .' (with +timers) or neovim to use this feature. Press '
                    \ .'any key to continue.')

        " Prevent the warning being cleared
        call getchar()
    endif

    " Handle normal refresh
    if g:mundo_auto_preview_delay <= 0
        call s:MundoPythonRestoreView('MundoRenderGraph()')

        if g:mundo_auto_preview && currentWin == mundoWin && mode() == 'n'
            call s:MundoRenderPreview()
        endif
        return
    endif

    " Handle delayed refresh
    call s:MundoRestartRefreshTimer()
endfunction"}}}

function! s:MundoRestartRefreshTimer()"{{{
    call s:MundoStopRefreshTimer()
    let s:auto_preview_timer = timer_start(
                \ get(g:, 'mundo_auto_preview_delay', 0),
                    \ function('s:MundoRefreshDelayed')
                \ )
endfunction"}}}

function! s:MundoStopRefreshTimer()"{{{
    if s:auto_preview_timer != -1
        call timer_stop(s:auto_preview_timer)
        let s:auto_preview_timer = -1
    endif
endfunction"}}}

function! s:MundoRefreshDelayed(...)"{{{
    " abort if Mundo is closed or cursor is in the preview window
    let mundoWin    = bufwinnr('__Mundo__')
    let mundoPreWin = bufwinnr('__Mundo_Preview__')
    let currentWin  = bufwinnr('%')

    if mundoWin == -1 || mundoPreWin == -1 || mundoPreWin == currentWin
        return
    endif

    " Update graph
    call s:MundoPythonRestoreView('MundoRenderGraph()')

    " Update preview
    if currentWin != mundoWin || !g:mundo_auto_preview
        return
    endif

    if mode() != 'n'
        call s:MundoRestartRefreshTimer()
        return
    endif

    call s:MundoRenderPreview()
endfunction"}}}

" Mark the preview as being up-to-date (0) or outdated (1)
function! mundo#MundoPreviewOutdated(outdated)"{{{
    if s:preview_outdated && !a:outdated
        call s:MundoStopRefreshTimer()
    endif

    let s:preview_outdated = a:outdated
endfunction"}}}

augroup MundoAug
    autocmd!
    autocmd BufEnter __Mundo__ call mundo#MundoPreviewOutdated(1)
    autocmd BufLeave __Mundo__
                \ if g:mundo_auto_preview |
                    \ call s:MundoRenderPreview() |
                    \ call s:MundoStopRefreshTimer() |
                \ endif |
    autocmd BufEnter __Mundo__ call s:MundoSettingsGraph()
    autocmd BufEnter __Mundo_Preview__ call s:MundoSettingsPreview()
    autocmd CursorHold,CursorMoved,TextChanged,InsertLeave *
                \ call s:MundoRefresh()
augroup END

"}}}

" Exposed functions{{{

function! mundo#MundoToggle()"{{{
    call s:MundoToggle()
endfunction"}}}

function! mundo#MundoShow()"{{{
    call s:MundoShow()
endfunction"}}}

function! mundo#MundoHide()"{{{
    call s:MundoHide()
endfunction"}}}

"}}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
