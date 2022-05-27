" ============================================================================
" File:        autoload/git_status/util.vim
" Description: utils
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
if exists('g:loaded_nerdtree_git_status_util')
    finish
endif
let g:loaded_nerdtree_git_status_util = 1

" FUNCTION: gitstatus#utilFormatPath
" This function is used to format nerdtree.Path.
" For Windows, returns in format 'C:/path/to/file'
"
" ARGS:
" path: nerdtree.Path
"
" RETURNS:
" absolute path
if gitstatus#isWin()
    if exists('+shellslash')
        function! gitstatus#util#FormatPath(path) abort
            let l:sslbak = &shellslash
            try
                set shellslash
                return a:path.str()
            finally
                let &shellslash = l:sslbak
            endtry
        endfunction
    else
        function! gitstatus#util#FormatPath(path) abort
            let l:pathStr = a:path.str()
            let l:pathStr = a:path.WinToUnixPath(l:pathStr)
            let l:pathStr = a:path.drive . l:pathStr
            return l:pathStr
        endfunction
    endif
else
    function! gitstatus#util#FormatPath(path) abort
        return a:path.str()
    endfunction
endif

function! gitstatus#util#BuildGitWorkdirCommand(root, opts) abort
    return [
                \ get(a:opts, 'NERDTreeGitStatusGitBinPath', 'git'),
                \ '-C', a:root,
                \ 'rev-parse',
                \ '--show-toplevel',
                \ ]
endfunction

function! gitstatus#util#BuildGitStatusCommand(root, opts) abort
    let l:cmd = [
                \ get(a:opts, 'NERDTreeGitStatusGitBinPath', 'git'),
                \ '-C', a:root,
                \ 'status',
                \ '--porcelain' . (get(a:opts, 'NERDTreeGitStatusPorcelainVersion', 2) ==# 2 ? '=v2' : ''),
                \ '-z'
                \ ]
    if has_key(a:opts, 'NERDTreeGitStatusUntrackedFilesMode')
        let l:cmd += ['--untracked-files=' . a:opts['NERDTreeGitStatusUntrackedFilesMode']]
    endif

    if get(a:opts, 'NERDTreeGitStatusShowIgnored', 0)
        let l:cmd += ['--ignored=traditional']
    endif

    if has_key(a:opts, 'NERDTreeGitStatusIgnoreSubmodules')
        let l:cmd += ['--ignore-submodules=' . a:opts['NERDTreeGitStatusIgnoreSubmodules']]
    endif

    if has_key(a:opts, 'NERDTreeGitStatusCwdOnly')
        let l:cmd += ['.']
    endif

    return l:cmd
endfunction

function! gitstatus#util#ParseGitStatusLines(root, statusLines, opts) abort
    let l:result = {}
    let l:is_rename = 0
    for l:line in a:statusLines
        if l:is_rename
            call gitstatus#util#UpdateParentDirsStatus(l:result, a:root, a:root . '/' . l:line, 'Dirty', a:opts)
            let l:is_rename = 0
            continue
        endif
        let [l:pathStr, l:statusKey] = gitstatus#util#ParseGitStatusLine(l:line, a:opts)

        let l:pathStr = a:root . '/' . l:pathStr
        if l:pathStr[-1:-1] is# '/'
            let l:pathStr = l:pathStr[:-2]
        endif
        let l:is_rename = l:statusKey is# 'Renamed'
        let l:result[l:pathStr] = l:statusKey

        call gitstatus#util#UpdateParentDirsStatus(l:result, a:root, l:pathStr, l:statusKey, a:opts)
    endfor
    return l:result
endfunction

let s:unmerged_status = {
            \ 'DD': 1,
            \ 'AU': 1,
            \ 'UD': 1,
            \ 'UA': 1,
            \ 'DU': 1,
            \ 'AA': 1,
            \ 'UU': 1,
            \ }

" Function: s:getStatusKey() function {{{2
" This function is used to get git status key
"
" Args:
" x: index tree
" y: work tree
"
"Returns:
" status key
"
" man git-status
" X          Y     Meaning
" -------------------------------------------------
"           [MD]   not updated
" M        [ MD]   updated in index
" A        [ MD]   added to index
" D         [ M]   deleted from index
" R        [ MD]   renamed in index
" C        [ MD]   copied in index
" [MARC]           index and work tree matches
" [ MARC]     M    work tree changed since index
" [ MARC]     D    deleted in work tree
" -------------------------------------------------
" D           D    unmerged, both deleted
" A           U    unmerged, added by us
" U           D    unmerged, deleted by them
" U           A    unmerged, added by them
" D           U    unmerged, deleted by us
" A           A    unmerged, both added
" U           U    unmerged, both modified
" -------------------------------------------------
" ?           ?    untracked
" !           !    ignored
" -------------------------------------------------
function! s:getStatusKey(x, y) abort
    let l:xy = a:x . a:y
    if get(s:unmerged_status, l:xy, 0)
        return 'Unmerged'
    elseif l:xy ==# '??'
        return 'Untracked'
    elseif l:xy ==# '!!'
        return 'Ignored'
    elseif a:y ==# 'M'
        return 'Modified'
    elseif a:y ==# 'D'
        return 'Deleted'
    elseif a:y =~# '[RC]'
        return 'Renamed'
    elseif a:x ==# 'D'
        return 'Deleted'
    elseif a:x =~# '[MA]'
        return 'Staged'
    elseif a:x =~# '[RC]'
        return 'Renamed'
    else
        return 'Unknown'
    endif
endfunction

function! gitstatus#util#ParseGitStatusLine(statusLine, opts) abort
    if get(a:opts, 'NERDTreeGitStatusPorcelainVersion', 2) ==# 2
        if a:statusLine[0] ==# '1'
            let l:statusKey = s:getStatusKey(a:statusLine[2], a:statusLine[3])
            let l:pathStr = a:statusLine[113:]
        elseif a:statusLine[0] ==# '2'
            let l:statusKey = 'Renamed'
            let l:pathStr = a:statusLine[113:]
            let l:pathStr = l:pathStr[stridx(l:pathStr, ' ')+1:]
        elseif a:statusLine[0] ==# 'u'
            let l:statusKey = 'Unmerged'
            let l:pathStr = a:statusLine[161:]
        elseif a:statusLine[0] ==# '?'
            let l:statusKey = 'Untracked'
            let l:pathStr = a:statusLine[2:]
        elseif a:statusLine[0] ==# '!'
            let l:statusKey = 'Ignored'
            let l:pathStr = a:statusLine[2:]
        else
            throw '[nerdtree_git_status] unknown status: ' . a:statusLine
        endif
        return [l:pathStr, l:statusKey]
    else
        let l:pathStr = a:statusLine[3:]
        let l:statusKey = s:getStatusKey(a:statusLine[0], a:statusLine[1])
        return [l:pathStr, l:statusKey]
    endif
endfunction

function! gitstatus#util#UpdateParentDirsStatus(cache, root, pathStr, statusKey, opts) abort
    if get(a:cache, a:pathStr, '') ==# 'Ignored'
        return
    endif
    let l:dirtyPath = fnamemodify(a:pathStr, ':h')
    let l:dir_dirty_only = get(a:opts, 'NERDTreeGitStatusDirDirtyOnly', 1)
    while l:dirtyPath !=# a:root
        let l:key = get(a:cache, l:dirtyPath, '')
        if l:dir_dirty_only
            if l:key ==# ''
                let a:cache[l:dirtyPath] = 'Dirty'
            else
                return
            endif
        else
            if l:key ==# ''
                let a:cache[l:dirtyPath] = a:statusKey
            elseif l:key ==# 'Dirty' || l:key ==# a:statusKey
                return
            else
                let a:cache[l:dirtyPath] = 'Dirty'
            endif
        endif
        let l:dirtyPath = fnamemodify(l:dirtyPath, ':h')
    endwhile
endfunction
