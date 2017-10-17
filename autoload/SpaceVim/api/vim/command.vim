let s:self = {}

let s:self.options = {}

" let s:options = {
"       \ '-f' : {
"       \ 'description' : '',
"       \ 'complete' : ['text'],
"       \ },
"       \ '-d' : {
"       \ 'description' : 'Root directory for sources',
"       \ 'complete' : 'file',
"       \ },
"       \ }

let s:self._message = []

function! s:self._complete_opt(part, opt) abort
  let complete = self.options[a:opt].complete
  if type(complete) == type([])
    return join(complete, "\n")
  else
    return join(getcompletion(a:part, complete), "\n")
  endif
endfunction

function! s:self.complete(ArgLead, CmdLine, CursorPos) abort
  let argvs = split(a:CmdLine)
  let last_argv = split(a:CmdLine)[-1]
  let msg = 'ArgLead: ' . a:ArgLead . ' CmdLine: ' . a:CmdLine . ' CursorPos: '
        \ . a:CursorPos . ' LastArgv: ' . last_argv
  call add(self._message, msg)
  if a:ArgLead == '' && index(keys(self.options), last_argv) == -1
    return join(keys(self.options), "\n")
  elseif a:ArgLead == '' && index(keys(self.options), last_argv) != -1
    return self._complete_opt(a:ArgLead, last_argv)
  elseif !empty(a:ArgLead) && len(argvs) >= 3
        \ && index(keys(self.options), argvs[-2]) != -1
    return self._complete_opt(a:ArgLead, argvs[-2])
  elseif !empty(a:ArgLead) && (
        \ (len(argvs) >= 3 && index(keys(self.options), argvs[-2]) == -1) 
        \ || 
        \ (len(argvs) ==2 )
        \ )
    return join(keys(self.options), "\n")
  endif

endfunction

function! s:self.debug() abort
  echo join(self._message, "\n")
endfunction


function! SpaceVim#api#vim#command#get()
  return deepcopy(s:self)
endfunction


" vim:set et sw=2 cc=80:
