" ============================================================================
" File:        git_status.vim
" Description: plugin for NERD Tree that provides git status support
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
scriptencoding utf-8

if exists('g:loaded_nerdtree_git_status')
    finish
endif
let g:loaded_nerdtree_git_status = 1

let s:is_win = gitstatus#isWin()

" stolen from nerdtree
"Function: s:initVariable() function {{{2
"This function is used to initialise a given variable to a given value. The
"variable is only initialised if it does not exist prior
"
"Args:
"var: the name of the var to be initialised
"value: the value to initialise var to
"
"Returns:
"1 if the var is set, 0 otherwise
function! s:initVariable(var, value) abort
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . "'" . substitute(a:value, "'", "''", 'g') . "'"
        return 1
    endif
    return 0
endfunction

let s:default_vals = {
            \ 'g:NERDTreeGitStatusEnable':             1,
            \ 'g:NERDTreeGitStatusUpdateOnWrite':      1,
            \ 'g:NERDTreeGitStatusUpdateOnCursorHold': 1,
            \ 'g:NERDTreeGitStatusShowIgnored':        0,
            \ 'g:NERDTreeGitStatusUseNerdFonts':       0,
            \ 'g:NERDTreeGitStatusDirDirtyOnly':       1,
            \ 'g:NERDTreeGitStatusConcealBrackets':    0,
            \ 'g:NERDTreeGitStatusAlignIfConceal':     1,
            \ 'g:NERDTreeGitStatusShowClean':          0,
            \ 'g:NERDTreeGitStatusLogLevel':           2,
            \ 'g:NERDTreeGitStatusPorcelainVersion':   2,
            \ 'g:NERDTreeGitStatusCwdOnly':            0,
            \ 'g:NERDTreeGitStatusMapNextHunk':        ']c',
            \ 'g:NERDTreeGitStatusMapPrevHunk':        '[c',
            \ 'g:NERDTreeGitStatusUntrackedFilesMode': 'normal',
            \ 'g:NERDTreeGitStatusGitBinPath':         'git',
            \ }

for [s:var, s:value] in items(s:default_vals)
    call s:initVariable(s:var, s:value)
endfor

let s:logger = gitstatus#log#NewLogger(g:NERDTreeGitStatusLogLevel)

function! s:deprecated(oldv, newv) abort
    call s:logger.warning(printf("option '%s' is deprecated, please use '%s'", a:oldv, a:newv))
endfunction

function! s:migrateVariable(oldv, newv) abort
    if exists(a:oldv)
        call s:deprecated(a:oldv, a:newv)
        exec 'let ' . a:newv . ' = ' . a:oldv
        return 1
    endif
    return 0
endfunction

let s:need_migrate_vals = {
            \ 'g:NERDTreeShowGitStatus':      'g:NERDTreeGitStatusEnable',
            \ 'g:NERDTreeUpdateOnWrite':      'g:NERDTreeGitStatusUpdateOnWrite',
            \ 'g:NERDTreeMapNextHunk':        'g:NERDTreeGitStatusMapNextHunk',
            \ 'g:NERDTreeMapPrevHunk':        'g:NERDTreeGitStatusMapPrevHunk',
            \ 'g:NERDTreeShowIgnoredStatus':  'g:NERDTreeGitStatusShowIgnored',
            \ 'g:NERDTreeIndicatorMapCustom': 'g:NERDTreeGitStatusIndicatorMapCustom',
            \ }

for [s:oldv, s:newv] in items(s:need_migrate_vals)
    call s:migrateVariable(s:oldv, s:newv)
endfor

if !g:NERDTreeGitStatusEnable
    finish
endif

if !executable(g:NERDTreeGitStatusGitBinPath)
    call s:logger.error('git command not found')
    finish
endif

" FUNCTION: path2str
" This function is used to format nerdtree.Path.
" For Windows, returns in format 'C:/path/to/file'
"
" ARGS:
" path: nerdtree.Path
"
" RETURNS:
" absolute path
function! s:path2str(path) abort
    return gitstatus#util#FormatPath(a:path)
endfunction

" disable ProhibitUnusedVariable because these three functions used to callback
" vint: -ProhibitUnusedVariable
function! s:onGitWorkdirSuccessCB(job) abort
    let g:NTGitWorkdir = split(join(a:job.chunks, ''), "\n")[0]
    call s:logger.debug(printf("'%s' is in a git repo: '%s'", a:job.opts.cwd, g:NTGitWorkdir))
    call s:enableLiveUpdate()

    call s:refreshGitStatus('init', g:NTGitWorkdir)
endfunction

function! s:onGitWorkdirFailedCB(job) abort
    let l:errormsg = join(a:job.err_chunks, '')
    if l:errormsg =~# 'fatal: Not a git repository'
        call s:logger.debug(printf("'%s' is not in a git repo", a:job.opts.cwd))
    endif
    call s:disableLiveUpdate()
    unlet! g:NTGitWorkdir
endfunction

function! s:getGitWorkdir(ntRoot) abort
    call gitstatus#job#Spawn('git-workdir',
                \ s:buildGitWorkdirCommand(a:ntRoot),
                \ {
                \ 'on_success_cb': function('s:onGitWorkdirSuccessCB'),
                \ 'on_failed_cb': function('s:onGitWorkdirFailedCB'),
                \ 'cwd': a:ntRoot,
                \ })
endfunction
" vint: +ProhibitUnusedVariable

function! s:buildGitWorkdirCommand(root) abort
    return gitstatus#util#BuildGitWorkdirCommand(a:root, g:)
endfunction

function! s:buildGitStatusCommand(workdir) abort
    return gitstatus#util#BuildGitStatusCommand(a:workdir, g:)
endfunction

function! s:refreshGitStatus(name, workdir) abort
    let l:opts =  {
                \ 'on_failed_cb': function('s:onGitStatusFailedCB'),
                \ 'on_success_cb': function('s:onGitStatusSuccessCB'),
                \ 'cwd': a:workdir
                \ }
    let l:job = gitstatus#job#Spawn(a:name, s:buildGitStatusCommand(a:workdir), l:opts)
    return l:job
endfunction

" vint: -ProhibitUnusedVariable
function! s:onGitStatusSuccessCB(job) abort
    if !exists('g:NTGitWorkdir') || g:NTGitWorkdir !=# a:job.opts.cwd
        call s:logger.debug(printf("git workdir has changed: '%s' -> '%s'", a:job.opts.cwd, get(g:, 'NTGitWorkdir', '')))
        return
    endif
    let l:output = join(a:job.chunks, '')
    let l:lines = split(l:output, "\n")
    let l:cache = gitstatus#util#ParseGitStatusLines(a:job.opts.cwd, l:lines, g:)

    try
        call s:listener.SetNext(l:cache)
        call s:listener.TryUpdateNERDTreeUI()
    catch
    endtry
endfunction

function! s:onGitStatusFailedCB(job) abort
    let l:errormsg = join(a:job.err_chunks, '')
    if l:errormsg =~# "error: option `porcelain' takes no value"
        call s:logger.error(printf("'git status' command failed, please upgrade your git binary('v2.11.0' or higher) or set option 'g:NERDTreeGitStatusPorcelainVersion' to 1 in vimrc"))
        call s:disableLiveUpdate()
        unlet! g:NTGitWorkdir
    elseif l:errormsg =~# '^warning: could not open .* Permission denied'
        call s:onGitStatusSuccessCB(a:job)
    else
        call s:logger.error(printf('job[%s] failed: %s', a:job.name, l:errormsg))
    endif
endfunction

" FUNCTION: s:onCursorHold(fname) {{{2
function! s:onCursorHold(fname)
    " Do not update when a special buffer is selected
    if !empty(&l:buftype)
        return
    endif
    let l:fname = s:is_win ?
                \ substitute(a:fname, '\', '/', 'g') :
                \ a:fname

    if !exists('g:NTGitWorkdir') || !s:hasPrefix(l:fname, g:NTGitWorkdir)
        return
    endif

    let l:job = s:refreshGitStatus('cursor-hold', g:NTGitWorkdir)
    call s:logger.debug('run cursor-hold job: ' . l:job.id)
endfunction

" FUNCTION: s:onFileUpdate(fname) {{{2
function! s:onFileUpdate(fname)
    let l:fname = s:is_win ?
                \ substitute(a:fname, '\', '/', 'g') :
                \ a:fname
    if !exists('g:NTGitWorkdir') || !s:hasPrefix(l:fname, g:NTGitWorkdir)
        return
    endif
    let l:job = s:refreshGitStatus('file-update', g:NTGitWorkdir)
    call s:logger.debug('run file-update job: ' . l:job.id)
endfunction
" vint: +ProhibitUnusedVariable

function! s:hasPrefix(text, prefix) abort
    return len(a:text) >= len(a:prefix) && a:text[:len(a:prefix)-1] ==# a:prefix
endfunction

function! s:setupNERDTreeListeners(listener) abort
    call g:NERDTreePathNotifier.AddListener('init', a:listener.OnInit)
    call g:NERDTreePathNotifier.AddListener('refresh', a:listener.OnRefresh)
    call g:NERDTreePathNotifier.AddListener('refreshFlags', a:listener.OnRefreshFlags)
endfunction

" FUNCTION: s:findHunk(node, direction)
" Args:
" node: the current node
" direction: next(>0) or prev(<0)
"
" Returns:
" lineNum if the hunk found, -1 otherwise
function! s:findHunk(node, direction) abort
    let l:ui = b:NERDTree.ui
    let l:rootLn = l:ui.getRootLineNum()
    let l:totalLn = line('$')
    let l:currLn = l:ui.getLineNum(a:node)
    let l:currLn = l:currLn <= l:rootLn ? l:rootLn+1 : l:currLn
    let l:step = a:direction > 0 ? 1 : -1
    let l:lines = a:direction > 0 ?
                \ range(l:currLn+1, l:totalLn, l:step) + range(l:rootLn+1, l:currLn-1, l:step) :
                \ range(l:currLn-1, l:rootLn+1, l:step) + range(l:totalLn, l:currLn+1, l:step)
    for l:ln in l:lines
        let l:path = s:path2str(l:ui.getPath(l:ln))
        if s:listener.HasPath(l:path)
            return l:ln
        endif
    endfor
    return -1
endfunction

" vint: -ProhibitUnusedVariable
" FUNCTION: s:jumpToNextHunk(node) {{{2
function! s:jumpToNextHunk(node)
    let l:ln = s:findHunk(a:node, 1)
    if l:ln > 0
        exec '' . l:ln
        call s:logger.info('Jump to next hunk')
    endif
endfunction

" FUNCTION: s:jumpToPrevHunk(node) {{{2
function! s:jumpToPrevHunk(node)
    let l:ln = s:findHunk(a:node, -1)
    if l:ln > 0
        exec '' . l:ln
        call s:logger.info('Jump to prev hunk')
    endif
endfunction
" vint: +ProhibitUnusedVariable

" Function: s:SID()   {{{2
function s:SID()
    if !exists('s:sid')
        let s:sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
    endif
    return s:sid
endfun

" FUNCTION: s:setupNERDTreeKeyMappings {{{2
function! s:setupNERDTreeKeyMappings()
    let l:s = '<SNR>' . s:SID() . '_'

    call NERDTreeAddKeyMap({
                \ 'key': g:NERDTreeGitStatusMapNextHunk,
                \ 'scope': 'Node',
                \ 'callback': l:s.'jumpToNextHunk',
                \ 'quickhelpText': 'Jump to next git hunk' })

    call NERDTreeAddKeyMap({
                \ 'key': g:NERDTreeGitStatusMapPrevHunk,
                \ 'scope': 'Node',
                \ 'callback': l:s.'jumpToPrevHunk',
                \ 'quickhelpText': 'Jump to prev git hunk' })
endfunction


" I don't know why, but vint said they are unused.
" vint: -ProhibitUnusedVariable
function! s:onNERDTreeDirChanged(path) abort
    call s:getGitWorkdir(a:path)
endfunction

function! s:onNERDTreeInit(path) abort
    call s:getGitWorkdir(a:path)
endfunction
" vint: +ProhibitUnusedVariable

function! s:enableLiveUpdate() abort
    augroup nerdtreegitplugin_liveupdate
        autocmd!
        if g:NERDTreeGitStatusUpdateOnWrite
            autocmd BufWritePost * silent! call s:onFileUpdate(expand('%:p'))
        endif

        if g:NERDTreeGitStatusUpdateOnCursorHold
            autocmd CursorHold * silent! call s:onCursorHold(expand('%:p'))
        endif

        " TODO: is it necessary to pass the buffer name?
        autocmd User FugitiveChanged silent! call s:onFileUpdate(expand('%:p'))

        autocmd BufEnter NERD_tree_* if exists('b:NERDTree') |
                    \ call s:onNERDTreeInit(s:path2str(b:NERDTree.root.path)) | endif
    augroup end
endfunction

function! s:disableLiveUpdate() abort
    augroup nerdtreegitplugin_liveupdate
        autocmd!
    augroup end
endfunction

augroup nerdtreegitplugin
    autocmd!
    autocmd User NERDTreeInit call s:onNERDTreeInit(s:path2str(b:NERDTree.root.path))
    autocmd User NERDTreeNewRoot call s:onNERDTreeDirChanged(s:path2str(b:NERDTree.root.path))
augroup end

call s:setupNERDTreeKeyMappings()

let s:listener = gitstatus#listener#New(g:)
call s:setupNERDTreeListeners(s:listener)
