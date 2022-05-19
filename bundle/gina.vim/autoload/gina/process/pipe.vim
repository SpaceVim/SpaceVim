let s:Guard = vital#gina#import('Vim.Guard')
let s:String = vital#gina#import('Data.String')

function! s:extend_content(content, data) abort
  unlockvar 1 a:content
  let a:content[-1] .= a:data[0]
  call extend(a:content, a:data[1:])
  lockvar 1 a:content
endfunction


" Default pipe -------------------------------------------------------------
function! gina#process#pipe#default() abort
  let pipe = deepcopy(s:default_pipe)
  return pipe
endfunction

function! s:_default_pipe_on_start() abort dict
  call gina#process#register(self)
endfunction

function! s:_default_pipe_on_exit(exitval) abort dict
  call gina#process#unregister(self)
endfunction

let s:default_pipe = {
      \ 'on_start': function('s:_default_pipe_on_start'),
      \ 'on_exit': function('s:_default_pipe_on_exit'),
      \}


" Store pipe ---------------------------------------------------------------
function! gina#process#pipe#store() abort
  let pipe = deepcopy(s:store_pipe)
  let pipe.stdout = ['']
  let pipe.stderr = ['']
  let pipe.content = ['']
  lockvar 1 pipe.stdout
  lockvar 1 pipe.stderr
  lockvar 1 pipe.content
  return pipe
endfunction

function! s:_store_pipe_on_receive(event, data) abort dict
  call map(a:data, 'v:val[-1:] ==# "\r" ? v:val[:-2] : v:val')
  call s:extend_content(self[a:event], a:data)
  call s:extend_content(self.content, a:data)
endfunction

function! s:_store_pipe_on_exit(exitval) abort dict
  " Content may has an extra empty line (POSIX text) so remove it
  if has_key(self, 'stdout') && empty(self.stdout[-1])
    unlockvar 1 self.stdout
    call remove(self.stdout, -1)
    lockvar 1 self.stdout
  endif
  if has_key(self, 'stderr') && empty(self.stderr[-1])
    unlockvar 1 self.stderr
    call remove(self.stderr, -1)
    lockvar 1 self.stderr
  endif
  if has_key(self, 'content') && empty(self.content[-1])
    unlockvar 1 self.content
    call remove(self.content, -1)
    lockvar 1 self.content
  endif
  call call('s:_default_pipe_on_exit', [a:exitval], self)
endfunction

let s:store_pipe = {
      \ 'on_start': function('s:_default_pipe_on_start'),
      \ 'on_stdout': function('s:_store_pipe_on_receive', ['stdout']),
      \ 'on_stderr': function('s:_store_pipe_on_receive', ['stderr']),
      \ 'on_exit': function('s:_store_pipe_on_exit'),
      \}


" Echo pipe ----------------------------------------------------------------
function! gina#process#pipe#echo() abort
  let pipe = deepcopy(s:echo_pipe)
  let pipe.stdout = ['']
  let pipe.stderr = ['']
  let pipe.content = ['']
  lockvar 1 pipe.stdout
  lockvar 1 pipe.stderr
  lockvar 1 pipe.content
  return pipe
endfunction

function! s:_echo_pipe_on_exit(exitval) abort dict
  if len(self.content)
    call gina#core#console#message(
          \ s:String.remove_ansi_sequences(join(self.content, "\n")),
          \)
  endif
  call call('s:_store_pipe_on_exit', [a:exitval], self)
endfunction

let s:echo_pipe = {
      \ 'on_start': function('s:_default_pipe_on_start'),
      \ 'on_stdout': function('s:_store_pipe_on_receive', ['stdout']),
      \ 'on_stderr': function('s:_store_pipe_on_receive', ['stderr']),
      \ 'on_exit': function('s:_echo_pipe_on_exit'),
      \}


" Stream pipe --------------------------------------------------------------
function! gina#process#pipe#stream(...) abort
  let pipe = deepcopy(s:stream_pipe)
  let pipe.writer = gina#core#writer#new(a:0 ? a:1 : s:stream_pipe_writer)
  let pipe.stderr = ['']
  let pipe.content = ['']
  lockvar 1 pipe.stderr
  lockvar 1 pipe.content
  return pipe
endfunction

function! s:_stream_pipe_on_start() abort dict
  call call('s:_default_pipe_on_start', [], self)
  let self.writer._job = self
  call self.writer.start()
endfunction

function! s:_stream_pipe_on_receive(data) abort dict
  call map(a:data, 'v:val[-1:] ==# "\r" ? v:val[:-2] : v:val')
  call self.writer.write(a:data)
endfunction

function! s:_stream_pipe_on_exit(data) abort dict
  call self.writer.stop()
  call call('s:_echo_pipe_on_exit', [a:data], self)
endfunction

let s:stream_pipe = {
      \ 'on_start': function('s:_stream_pipe_on_start'),
      \ 'on_stdout': function('s:_stream_pipe_on_receive'),
      \ 'on_stderr': function('s:_store_pipe_on_receive', ['stderr']),
      \ 'on_exit': function('s:_stream_pipe_on_exit'),
      \}

" Stream pipe writer -------------------------------------------------------
function! gina#process#pipe#stream_writer() abort
  return deepcopy(s:stream_pipe_writer)
endfunction

function! s:_discard_winview() abort
  augroup gina_process_pipe_stream_pipe_writer_internal
    autocmd! * <buffer=abuf>
    autocmd CursorMoved <buffer=abuf>
          \ silent! unlet! b:gina_winview |
          \ autocmd! gina_process_pipe_stream_pipe_writer_internal * <buffer=abuf>
  augroup END
endfunction

function! s:_stream_pipe_writer_on_start() abort dict
  let self._spinner = gina#core#spinner#start(self.bufnr)
  call gina#process#register('writer:' . self.bufnr, 1)
  call gina#core#emitter#emit('writer:started', self.bufnr)
  " When user moves cursor, remove 'b:gina_winview' to prevent unwilling
  " cursor change after completion
  augroup gina_process_pipe_stream_pipe_writer_internal
    execute printf('autocmd! * <buffer=%d>', self.bufnr)
    execute printf(
          \ 'autocmd CursorMoved <buffer=%d> call s:_discard_winview()',
          \ self.bufnr
          \)
  augroup END
endfunction

function! s:_stream_pipe_writer_on_exit() abort dict
  call self._job.stop()
  call self._spinner.stop()

  let focus = gina#core#buffer#focus(self.bufnr)
  if empty(focus) || bufnr('%') != self.bufnr
    call gina#core#emitter#emit('writer:stopped', self.bufnr)
    call gina#process#unregister('writer:' . self.bufnr, 1)
    return
  endif
  try
    if exists('b:gina_winview')
      silent! call winrestview(b:gina_winview)
    endif
  finally
    call focus.restore()
    call gina#core#emitter#emit('writer:stopped', self.bufnr)
    call gina#process#unregister('writer:' . self.bufnr, 1)
  endtry
endfunction

let s:stream_pipe_writer = {
      \ 'on_start': function('s:_stream_pipe_writer_on_start'),
      \ 'on_exit': function('s:_stream_pipe_writer_on_exit'),
      \}


" Save winview on BufUnload while winsaveview() returns unwilling value
" on BufReadCmd
augroup gina_process_pipe_internal
  autocmd! *
  autocmd BufUnload gina://* let b:gina_winview = winsaveview()
augroup END
