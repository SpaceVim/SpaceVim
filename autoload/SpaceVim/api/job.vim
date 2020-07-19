"=============================================================================
" job.vim --- job api
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================



""
" @section job, api-job
" @parentsection api
" provides some functions to manager job
"
" start({cmd}[, {opt}])
" 
"   spawns {cmd} as a job. {opts} is a dictionary with these keys:
"
"   on_stdout: stdout event handler (function name or Funcref)
"
"   on_stderr: stderr event handler (function name or Funcref)
"   
"   on_exit: exit event handler (function name or Funcref)
"
"   cwd: working directory of the job; defaults to current directory




function! SpaceVim#api#job#get() abort
  return deepcopy(s:self)
endfunction

" make vim and neovim use same job func.
let s:self = {}
let s:self.jobs = {}
let s:self.nvim_job = has('nvim')
let s:self.vim_job = !has('nvim') && has('job') && has('patch-8.0.0027')
let s:self.vim_co = SpaceVim#api#import('vim#compatible')
let s:self._message = []

if !s:self.nvim_job && !s:self.vim_job
  augroup SpaceVim_job
    au!
    au! User SpaceVim_job_stdout nested call call(s:self.opts.on_stdout, s:self.job_argv)
    au! User SpaceVim_job_stderr nested call call(s:self.opts.on_stderr, s:self.job_argv)
    au! User SpaceVim_job_exit nested call call(s:self.opts.on_exit, s:self.job_argv)
  augroup END
endif

function! s:self.warn(...) abort
  if len(a:000) == 0
    echohl WarningMsg | echom 'Current version do not support job feature, fallback to sync system()' | echohl None
  elseif len(a:000) == 1 && type(a:1) == type('')
    echohl WarningMsg | echom a:1| echohl None
  else
  endif
endfunction
function! s:self.warp(argv, opts) abort
  let obj = {}
  let obj._argv = a:argv
  let obj._opts = a:opts
  let obj.in_io = get(a:opts, 'in_io', 'pipe')
  " @vimlint(EVL103, 1, a:job_id)
  function! obj._out_cb(job_id, data) abort
    if has_key(self._opts, 'on_stdout')
      call self._opts.on_stdout(self._opts.jobpid, [a:data], 'stdout')
    endif
  endfunction

  function! obj._err_cb(job_id, data) abort
    if has_key(self._opts, 'on_stderr')
      call self._opts.on_stderr(self._opts.jobpid, [a:data], 'stderr')
    endif
  endfunction

  function! obj._exit_cb(job_id, data) abort
    if has_key(self._opts, 'on_exit')
      call self._opts.on_exit(self._opts.jobpid, a:data, 'exit')
    endif
  endfunction
  " @vimlint(EVL103, 0, a:job_id)

  let obj = {
        \ 'argv': a:argv,
        \ 'opts': {
        \ 'mode': 'nl',
        \ 'in_io' : obj.in_io,
        \ 'out_cb': obj._out_cb,
        \ 'err_cb': obj._err_cb,
        \ 'exit_cb': obj._exit_cb,
        \ }
        \ }
  if has_key(a:opts, 'cwd')
    call extend(obj.opts, {'cwd' : a:opts.cwd})
  endif
  return obj
endfunction

function! s:self.warp_nvim(argv, opts) abort
  let obj = {}
  let obj._argv = a:argv
  let obj._opts = a:opts
  " @vimlint(EVL103, 1, a:job_id)
  function! obj.__on_stdout(id, data, event) abort
    if has_key(self._opts, 'on_stdout')
      if a:data[-1] == ''
        call self._opts.on_stdout(a:id, [self._eof . a:data[0]] + a:data[1:], 'stdout')
        let self._eof = ''
      else
        call self._opts.on_stdout(a:id, [self._eof . a:data[0]] + a:data[1:-2], 'stdout')
        let self._eof = a:data[-1]
      endif
    endif
  endfunction

  function! obj.__on_stderr(id, data, event) abort
    if has_key(self._opts, 'on_stderr')
      if a:data[-1] == ''
        call self._opts.on_stderr(a:id, [self._eof . a:data[0]] + a:data[1:], 'stderr')
        let self._eof = ''
      else
        call self._opts.on_stderr(a:id, [self._eof . a:data[0]] + a:data[1:-2], 'stderr')
        let self._eof = a:data[-1]
      endif
    endif
  endfunction

  function! obj.__on_exit(id, data, event) abort
    if has_key(self._opts, 'on_exit')
      call self._opts.on_exit(a:id, a:data, 'exit')
    endif
  endfunction
  " @vimlint(EVL103, 0, a:job_id)

  let obj = {
        \ 'argv': a:argv,
        \ 'opts': {
        \ '_opts': obj._opts,
        \ '_eof': '',
        \ 'on_stdout': obj.__on_stdout,
        \ 'on_stderr': obj.__on_stderr,
        \ 'on_exit': obj.__on_exit,
        \ }
        \ }
  if has_key(a:opts, 'cwd')
    call extend(obj.opts, {'cwd' : a:opts.cwd})
  endif
  return obj
endfunction

" start a job, and return the job_id.
function! s:self.start(argv, ...) abort
  if self.nvim_job
    try
      if len(a:000) > 0
        let opts = a:1
      else
        let opts = {}
      endif
      let wrapped = self.warp_nvim(a:argv, opts)
      let job = jobstart(wrapped.argv, wrapped.opts)
    catch /^Vim\%((\a\+)\)\=:E903/
      return -1
    endtry
    if job > 0
      let msg = ['process '. jobpid(job), ' run']
      call extend(self.jobs, {job : msg})
    else
      if job == -1
        call add(self._message, 'Failed to start job:' . (type(a:argv) == 3 ? a:argv[0] : a:argv) . ' is not executeable')
      elseif job == 0
        call add(self._message, 'Failed to start job: invalid arguments')
      endif
    endif
    return job
  elseif self.vim_job
    if len(a:000) > 0
      let opts = a:1
    else
      let opts = {}
    endif
    let id = len(self.jobs) + 1
    let opts.jobpid = id
    let wrapped = self.warp(a:argv, opts)
    if has_key(wrapped.opts, 'cwd') && !has('patch-8.0.0902')
      let old_wd = getcwd()
      let cwd = expand(wrapped.opts.cwd, 1)
      " Avoid error E475: Invalid argument: cwd
      call remove(wrapped.opts, 'cwd')
      exe 'cd' fnameescape(cwd)
    endif
    let job = job_start(wrapped.argv, wrapped.opts)
    if exists('old_wd')
      exe 'cd' fnameescape(old_wd)
    endif
    call extend(self.jobs, {id : job})
    return id
  else
    if len(a:000) > 0
      let opts = a:1
    else
      let opts = {}
    endif
    if has_key(opts, 'cwd')
      let old_wd = getcwd()
      let cwd = expand(opts.cwd, 1)
      exe 'cd' fnameescape(cwd)
    endif
    let output = self.vim_co.systemlist(a:argv)
    if exists('old_wd')
      exe 'cd' fnameescape(old_wd)
    endif
    let id = -1
    let s:self.opts = opts
    if v:shell_error
      if has_key(opts,'on_stderr')
        let s:self.job_argv = [id, output, 'stderr']
        try
          doautocmd User SpaceVim_job_stderr
        catch
          doautocmd User SpaceVim_job_stderr
        endtry
      endif
    else
      if has_key(opts,'on_stdout')
        let s:self.job_argv = [id, output, 'stdout']
        try
          doautocmd User SpaceVim_job_stdout
        catch
          doautocmd User SpaceVim_job_stdout
        endtry
      endif
    endif
    if has_key(opts,'on_exit')
      let s:self.job_argv = [id, v:shell_error, 'exit']
      try
        doautocmd User SpaceVim_job_exit
      catch 
        doautocmd User SpaceVim_job_exit
      endtry
    endif
    return id
  endif
endfunction

function! s:self.stop(id) abort
  if self.nvim_job
    if has_key(self.jobs, a:id)
      call jobstop(a:id)
      call remove(self.jobs, a:id)
    endif
  elseif self.vim_job
    if has_key(self.jobs, a:id)
      call job_stop(get(self.jobs, a:id))
      call remove(self.jobs, a:id)
    endif
  else
    call self.warn()
  endif
endfunction

function! s:self.send(id, data) abort
  if self.nvim_job
    if has_key(self.jobs, a:id)
      if type(a:data) == type('')
        call jobsend(a:id, [a:data, ''])
      else
        call jobsend(a:id, a:data)
      endif
    else
      call self.warn('[job API] Failed to send data to job: ' . a:id)
    endif
  elseif self.vim_job
    if has_key(self.jobs, a:id)
      let job = get(self.jobs, a:id)
      let chanel = job_getchannel(job)
      if type(a:data) == type('')
        call ch_sendraw(chanel, a:data . "\n")
      else
        call ch_sendraw(chanel, join(a:data, "\n"))
      endif
    else
      call self.warn('[job API] Failed to send data to job: ' . a:id)
    endif
  else
    call self.warn()
  endif
endfunction

function! s:self.status(id) abort
  if self.nvim_job
    if has_key(self.jobs, a:id)
      return get(self.jobs, a:id)[1]
    endif
  elseif self.vim_job
    if has_key(self.jobs, a:id)
      return job_status(get(self.jobs, a:id))
    endif
  else
    call self.warn('[job API] Failed to get job status: ' . a:id)
  endif
endfunction

function! s:self.list() abort
  return copy(self.jobs)
endfunction

function! s:self.info(id) abort
  let info = {}
  if self.nvim_job
    let info.status = self.status(a:id)
    let info.job_id = a:id
    return info
  elseif self.vim_job
    if has_key(self.jobs, a:id)
      return job_info(get(self.jobs, a:id))
    else
      call self.warn('[job API] Failed to get job info: ' . a:id)
    endif
  else
    call self.warn()
  endif
endfunction

function! s:self.chanclose(id, type) abort
  if self.nvim_job
    call chanclose(a:id, a:type)
  elseif self.vim_job
    if has_key(self.jobs, a:id) && a:type ==# 'stdin'
      call ch_close_in(get(self.jobs, a:id))
    endif
  endif
endfunction


function! s:self.debug() abort
  echo join(self._message, "\n")
endfunction
