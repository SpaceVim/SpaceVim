
let s:self = {
            \ 'name' : '',
            \ 'silent' : 1,
            \ 'file' : '',
            \ }

function! SpaceVim#api#logger#get() abort
    return deepcopy(s:self)
endfunction


function! s:self.error(msg) abort
  let time = strftime('%H:%M:%S')
  let log = '[ ' . self.name . ' ] [' . time . '] [ Error ] ' . a:msg
  if !self.silent
      echoerr log
  endif
  call self.write(log)
endfunction

function! s:self.write(msg) abort
  if !isdirectory(fnamemodify(self.file, ':p:h'))
    call mkdir(expand(fnamemodify(self.file, ':p:h')), 'p')
  endif
  let flags = filewritable(self.file) ? 'a' : ''
  call writefile([a:msg], self.file, flags)
endfunction

function! s:self.warn(msg) abort
  let time = strftime('%H:%M:%S')
  let log = '[ ' . self.name . ' ] [' . time . '] [ Warn ] ' . a:msg
  if !self.silent
      echohl WarningMsg
      echom log
      echohl None
  endif
  call self.write(log)
endfunction

function! s:self.info(msg) abort
  let time = strftime('%H:%M:%S')
  let log = '[ ' . self.name . ' ] [' . time . '] [ Info ] ' . a:msg
  if !self.silent
      echom log
  endif
  call self.write(log)
endfunction

function! s:self.set_name(name) abort
    let self.name = a:name
endfunction

function! s:self.get_name() abort
    return self.name
endfunction

function! s:self.set_file(file) abort
    let self.file = a:file
endfunction
