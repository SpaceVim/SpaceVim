let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

function! git#config#run(argvs)

    if empty(a:argvs)
        let cmd = ['git', 'config', '--list'] 
    else
        let cmd = ['git', 'config'] + a:argvs
    endif
    let s:lines = []
    call git#logger#info('git-config cmd:' . string(cmd))
    call s:JOB.start(cmd,
                \ {
                \ 'on_exit' : function('s:on_exit'),
                \ 'on_stdout' : function('s:on_stdout'),
                \ }
                \ )

endfunction

function! s:on_stdout(id, data, event) abort
    for data in a:data
        call git#logger#info('git-config stdout:' . data)
    endfor
    let s:lines += a:data
endfunction

function! s:on_exit(id, data, event) abort
    call git#logger#info('git-config exit data:' . string(a:data))
    if a:data ==# 0
        let s:bufnr = s:openConfigBuffer(len(s:lines))
        call s:BUFFER.buf_set_lines(s:bufnr, 0 , -1, 0, s:lines)
    else
        echo 'failed!'
    endif
endfunction

function! s:openConfigBuffer(height) abort
    let h = a:height > 10 ? 10 : a:height
    exe h . 'split git://config'
    normal! "_dd
    setl nobuflisted
    setl nomodifiable
    setl nonumber norelativenumber
    setl buftype=nofile
    setf git-config
    nnoremap <buffer><silent> q :bd!<CR>
    return bufnr('%')
endfunction

function! s:options() abort
    return join([
                \ '--global',
                \ '--user',
                \ ], "\n")
endfunction

function! s:keys() abort
    return [
                \ 'http.sslcainfo',
                \ 'http.sslbackend',
                \ 'diff.astextplain.textconv',
                \ 'core.autocrlf',
                \ 'core.fscache',
                \ 'core.symlinks',
                \ 'credential.helper',
                \ 'user.name',
                \ 'user.email',
                \ 'user.signingkey',
                \ 'push.default',
                \ 'merge.tool',
                \ 'diff.tool',
                \ 'commit.tool',
                \ 'difftool.prompt',
                \ 'color.ui',
                \ 'color.branch',
                \ 'color.status',
                \ 'core.editor',
                \ 'core.excludesfile',
                \ 'core.autocrlf',
                \ 'core.filemode',
                \ 'core.safecrlf',
                \ 'core.ignorecase',
                \ 'mergetool.prompt',
                \ 'mergetool.vimdiff.cmd',
                \ 'http.postbuffer',
                \ 'core.repositoryformatversion',
                \ 'core.filemode',
                \ 'core.bare',
                \ 'core.logallrefupdates',
                \ 'core.symlinks',
                \ 'core.ignorecase',
                \ 'remote.origin.url',
                \ 'remote.origin.fetch',
                \ 'branch.master.remote',
                \ 'branch.master.merge',
                \ 'branch.dev.remote',
                \ 'branch.dev.merge',
                \ 'branch.develop.remote',
                \ 'branch.develop.merge',
                \ 'branch.notiapi.remote',
                \ 'branch.notiapi.merge',
                \ 'branch.rebase.remote',
                \ 'branch.rebase.merge']
endfunction

function! git#config#complete(ArgLead, CmdLine, CursorPos)
    if a:ArgLead =~# '^-'
        return s:options()
    endif
    let str = a:CmdLine[:a:CursorPos-1]
    if str =~# '^Git\s\+config\s\+[^ ]*$' ||
                \ str =~# '^Git\s\+config\s\+--global\s\+[^ ]*$' ||
                \ str =~# '^Git\s\+config\s\+--user\s\+[^ ]*$'
        return join(s:keys(), "\n")
    else
        return ''
    endif

endfunction

