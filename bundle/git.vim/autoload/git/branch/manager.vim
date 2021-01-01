let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

function! git#branch#manager#open()
    call s:open_win()   
endfunction

let s:bufnr = 0
function! s:open_win() abort
    if s:bufnr != 0 && bufexists(s:bufnr)
        exe 'bd ' . s:bufnr
    endif
    topleft vsplit __git_branch_manager__
    " @todo add win_getid api
    let s:winid = win_getid(winnr('#'))
    let lines = &columns * 30 / 100
    exe 'vertical resize ' . lines
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
    set filetype=SpaceVimGitBranchManager
    let s:bufnr = bufnr('%')
    call s:update()
    augroup git_branch_manager
        autocmd! * <buffer>
        autocmd WinEnter <buffer> call s:WinEnter()
    augroup END
    nnoremap <buffer><silent> <Enter> :call <SID>checkout_branch()<cr>
endfunction
function! s:WinEnter() abort
    let s:winid = win_getid(winnr('#'))
endfunction
function! s:checkout_branch() abort
    let line = getline('.')
    if line =~# '^\s\+\S\+'
        let branch = split(line)[0]
        exe 'Git checkout ' . branch
    endif
endfunction

function! s:update() abort
    let s:branchs = []
    let cmd = ['git', 'branch', '--all']
    call git#logger#info('git-branch cmd:' . string(cmd))
    call s:JOB.start(cmd,
                \ {
                \ 'on_stderr' : function('s:on_stderr'),
                \ 'on_stdout' : function('s:on_stdout'),
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )
endfunction

function! s:update_buffer_context() abort
    let lines = []
    call add(lines, 'local')
    let remote = ''
    for branch in s:branchs
        if branch.remote != remote
            call add(lines, 'r:' . branch.remote)
            let remote = branch.remote
        endif
        call add(lines, '  ' . branch.name)
    endfor
    
  call s:BUFFER.buf_set_lines(s:bufnr, 0 , -1, 0, lines)
endfunction

function! s:on_stdout(id, data, event) abort
    for line in filter(a:data, '!empty(v:val)')
        call SpaceVim#logger#info('>>' . line)
        if stridx(line, 'remotes/') == -1
            let branch = {
            \ 'name': trim(line),
            \ 'remote': '',
            \ 'islocal': 1,
            \  }
        else
            let branch = {
            \ 'name': line[stridx(line, '/', 10) + 1 :],
            \ 'remote': split(line, '/')[1],
            \ 'islocal': 0,
            \  }
        endif
        call add(s:branchs, branch)
    endfor
endfunction

function! s:on_stderr(id, data, event) abort
    for line in filter(a:data, '!empty(v:val)')
        exe 'Echoerr ' . line
    endfor
endfunction
function! s:on_exit(id, data, event) abort
    call git#logger#info('git-branch exit data:' . string(a:data))
    if a:data ==# 0
        call s:update_buffer_context()
    endif
endfunction
