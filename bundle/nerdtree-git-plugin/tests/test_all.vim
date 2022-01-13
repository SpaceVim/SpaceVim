let s:suite = themis#suite('Test for nerdtree-git-plugin')
let s:assert = themis#helper('assert')
call themis#helper('command').with(s:)

function! s:suite.Initializing() abort
    NERDTreeFocus
    call s:assert.exists('g:NERDTree')
    call s:assert.exists('g:loaded_nerdtree_git_status')
    call g:NERDTree.CursorToTreeWin()
    call s:assert.exists('b:NERDTree')
endfunction

function! s:suite.BuildGitWorkdirCommand() abort
    let l:cmd = gitstatus#util#BuildGitWorkdirCommand('/workdir', {})
    call s:assert.equal(l:cmd, ['git', '-C', '/workdir', 'rev-parse', '--show-toplevel'])

    let l:cmd = gitstatus#util#BuildGitWorkdirCommand('/workdir', {'NERDTreeGitStatusGitBinPath': '/path/to/git'})
    call s:assert.equal(l:cmd, ['/path/to/git', '-C', '/workdir', 'rev-parse', '--show-toplevel'])
endfunction

function! s:suite.BuildGitStatusCommand() abort
    let l:cmd = gitstatus#util#BuildGitStatusCommand('/workdir', {})
    call s:assert.equal(l:cmd, ['git', '-C', '/workdir', 'status', '--porcelain=v2', '-z'])

    let l:cmd = gitstatus#util#BuildGitStatusCommand('/workdir', {
                \ 'NERDTreeGitStatusPorcelainVersion': 1
                \ })
    call s:assert.equal(l:cmd, ['git', '-C', '/workdir', 'status', '--porcelain', '-z'])

    let l:cmd = gitstatus#util#BuildGitStatusCommand('/workdir', {
                \ 'NERDTreeGitStatusUntrackedFilesMode': 'all'
                \ })
    call s:assert.equal(l:cmd, ['git', '-C', '/workdir', 'status', '--porcelain=v2', '-z', '--untracked-files=all'])

    let l:cmd = gitstatus#util#BuildGitStatusCommand('/workdir', {
                \ 'NERDTreeGitStatusShowIgnored': 1
                \ })
    call s:assert.equal(l:cmd, ['git', '-C', '/workdir', 'status', '--porcelain=v2', '-z', '--ignored=traditional'])

    let l:cmd = gitstatus#util#BuildGitStatusCommand('/workdir', {
                \ 'NERDTreeGitStatusShowIgnored': 0
                \ })
    call s:assert.equal(l:cmd, ['git', '-C', '/workdir', 'status', '--porcelain=v2', '-z'])

    let l:cmd = gitstatus#util#BuildGitStatusCommand('/workdir', {
                \ 'NERDTreeGitStatusIgnoreSubmodules': 'dirty'
                \ })
    call s:assert.equal(l:cmd, ['git', '-C', '/workdir', 'status', '--porcelain=v2', '-z', '--ignore-submodules=dirty'])

    let l:cmd = gitstatus#util#BuildGitStatusCommand('/workdir', {
                \ 'NERDTreeGitStatusPorcelainVersion': 1,
                \ 'NERDTreeGitStatusUntrackedFilesMode': 'all',
                \ 'NERDTreeGitStatusShowIgnored': 1,
                \ 'NERDTreeGitStatusIgnoreSubmodules': 'dirty'
                \ })
    call s:assert.equal(l:cmd, ['git', '-C', '/workdir', 'status', '--porcelain', '-z',
                \ '--untracked-files=all',
                \ '--ignored=traditional',
                \ '--ignore-submodules=dirty'])
endfunction

function! s:suite.Logger() abort
    let l:logger = gitstatus#log#NewLogger(1) " info
    let l:messages = execute('messages')

    call l:logger.debug('debug')
    call s:assert.equal(execute('messages'), l:messages)

    call l:logger.error('error')
    call s:assert.equal(execute('messages'), l:messages . "\n[nerdtree-git-status] error")
endfunction

function! s:suite.CustomIndicator() abort
    let g:NERDTreeGitStatusIndicatorMapCustom = {'Untracked': '~'}

    let l:staged = gitstatus#getIndicator('Staged')

    call s:assert.equal(gitstatus#getIndicator('Staged'), l:staged)
    call s:assert.equal(gitstatus#getIndicator('Untracked'), '~')

    " Vim(return):E716: Key not present in Dictionary
    Throws /E716/ gitstatus#getIndicator('no such status')
endfunction

function! s:suite.UpdateParentDirsStatus() abort
    let l:opts = {'NERDTreeGitStatusDirDirtyOnly': 1}
    let l:root = '/root'
    let l:cache = {}
    let l:pathStr = '/root/dir1/dir2/dir3'
    let l:cache[l:pathStr] = 'Untracked'
    call gitstatus#util#UpdateParentDirsStatus(l:cache, l:root, l:pathStr, 'Untracked', l:opts)
    call s:assert.equal({'/root/dir1': 'Dirty', '/root/dir1/dir2': 'Dirty', '/root/dir1/dir2/dir3': 'Untracked'}, l:cache)

    let l:pathStr = '/root/dir1/dir2/file0'
    let l:cache[l:pathStr] = 'Staged'
    call gitstatus#util#UpdateParentDirsStatus(l:cache, l:root, l:pathStr, 'Staged', l:opts)
    call s:assert.equal({'/root/dir1': 'Dirty', '/root/dir1/dir2': 'Dirty', '/root/dir1/dir2/dir3': 'Untracked', '/root/dir1/dir2/file0': 'Staged'}, l:cache)

    let l:opts = {'NERDTreeGitStatusDirDirtyOnly': 0}
    let l:cache = {}
    let l:pathStr = '/root/dir1/dir2/dir3'
    let l:cache[l:pathStr] = 'Untracked'
    call gitstatus#util#UpdateParentDirsStatus(l:cache, l:root, l:pathStr, 'Untracked', l:opts)
    call s:assert.equal({'/root/dir1': 'Untracked', '/root/dir1/dir2': 'Untracked', '/root/dir1/dir2/dir3': 'Untracked'}, l:cache)

    let l:cache['/root/dir1/file1'] = 'Staged'
    call gitstatus#util#UpdateParentDirsStatus(l:cache, l:root, '/root/dir1/file1', 'Staged', l:opts)
    call s:assert.equal({'/root/dir1': 'Dirty','/root/dir1/file1': 'Staged', '/root/dir1/dir2': 'Untracked', '/root/dir1/dir2/dir3': 'Untracked'}, l:cache)
endfunction
