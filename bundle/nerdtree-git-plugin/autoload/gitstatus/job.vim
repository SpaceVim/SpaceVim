" ============================================================================
" File:        autoload/gitstatus/job.vim
" Description: async-jobs
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
if exists('g:loaded_nerdtree_git_status_job')
    finish
endif
let g:loaded_nerdtree_git_status_job = 1

" stolen from vim-plug
let s:nvim = has('nvim-0.2') || (has('nvim') && exists('*jobwait'))
let s:vim8 = has('patch-8.0.0039') && exists('*job_start')

let s:Job = {
        \ 'running': 0,
        \ 'failed': 0,
        \ 'chunks': [''],
        \ 'err_chunks': [''],
        \ }

" disabled ProhibitImplicitScopeVariable because we will use lots of `self`
" disabled ProhibitUnusedVariable because lambda
" vint: -ProhibitImplicitScopeVariable -ProhibitUnusedVariable
function! s:newJob(name, opts) abort
    return extend(deepcopy(s:Job), {
        \ 'name': a:name,
        \ 'opts': a:opts
        \ })
endfunction

function! s:Job.onStdoutCB(data) abort
    let self.chunks[-1] .= a:data[0]
    call extend(self.chunks, a:data[1:])
endfunction

function! s:Job.onStderrCB(data) abort
    let self.failed = self.failed || !s:isEOF(a:data)
    let self.err_chunks[-1] .= a:data[0]
    call extend(self.err_chunks, a:data[1:])
endfunction

function! s:Job.onExitCB() abort
    let self.running = 0
    if self.failed
        call self.onFailed()
    else
        call self.onSuccess()
    endif
endfunction

function! s:Job.onFailed() abort
    if has_key(self.opts, 'on_failed_cb')
        call call(self.opts.on_failed_cb, [self])
    endif
endfunction

function! s:Job.onSuccess() abort
    if has_key(self.opts, 'on_success_cb')
        call call(self.opts.on_success_cb, [self])
    endif
endfunction

if s:nvim
    function! s:Job.run(cmd) abort
        let jid = jobstart(a:cmd, {
                    \ 'on_stdout': {_job_id, data, _event  -> self.onStdoutCB(data)},
                    \ 'on_stderr': {_job_id, data, _event  -> self.onStderrCB(data)},
                    \ 'on_exit':   {_job_id, _data, _event -> self.onExitCB()},
                    \ 'env':       {'GIT_OPTIONAL_LOCKS': '0'},
                    \ })
        let self.id = jid
        let self.running = jid > 0
        if jid <= 0
            let self.failed = 1
            let self.err_chunks = jid == 0 ?
                        \ ['invalid arguments'] :
                        \ ['command is not executable']
            call self.onExitCB()
        endif
    endfunction
elseif s:vim8
    function! s:Job.run(cmd) abort
        let options = {
                    \ 'out_cb':   { _ch, data -> self.onStdoutCB([data]) },
                    \ 'err_cb':   { _ch, data -> self.onStderrCB([data]) },
                    \ 'close_cb': { _ch -> self.onExitCB() },
                    \ 'out_mode': 'nl',
                    \ 'err_mode': 'nl',
                    \ 'env':      {'GIT_OPTIONAL_LOCKS': '0'},
                    \ }
        if has('patch-8.1.350')
            let options['noblock'] = 1
        endif
        let jid = job_start(a:cmd, options)
        if job_status(jid) ==# 'run'
            let self.id = jid
            let self.running = 1
        else
            let self.running = 0
            let self.failed = 1
            let self.err_chunks = ['failed to start job']
            call self.onExitCB()
        endif
    endfunction
else
    function! s:Job.run(cmd) abort
        let bak = $GIT_OPTIONAL_LOCKS
        let $GIT_OPTIONAL_LOCKS = 0
        let output = substitute(system(join(a:cmd, ' ')), "\<C-A>", "\n", 'g')
        let $GIT_OPTIONAL_LOCKS = bak
        let self.failed = v:shell_error isnot# 0
        if self.failed
            let self.err_chunks = [output]
        else
            let self.chunks = [output]
        endif
        call self.onExitCB()
    endfunction
endif
" vint: +ProhibitImplicitScopeVariable +ProhibitUnusedVariable

function! s:isEOF(data) abort
    return len(a:data) == 1 && a:data[0] is# ''
endfunction

function! gitstatus#job#Spawn(name, cmd, opts) abort
    let l:job = s:newJob(a:name, a:opts)
    call l:job.run(a:cmd)
    return l:job
endfunction
