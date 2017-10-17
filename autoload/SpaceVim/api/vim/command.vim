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

function! s:self.complete(ArgLead, CmdLine, CursorPos) abort
  let last_argv = split(a:CmdLine)[-1]
  let msg = 'ArgLead: ' . a:ArgLead . ' CmdLine: ' . a:CmdLine . ' CursorPos: ' . a:CursorPos . ' LastArgv: ' . last_argv
  call add(self._message, msg)
  if a:ArgLead == '' && index(keys(self.options), last_argv) == -1
    return join(keys(self.options), "\n")
  elseif a:ArgLead == '' && index(keys(self.options), last_argv) != -1
    let complete = self.options[last_argv].complete
    if type(complete) == type([])
      return join(complete, "\n")
    else
      return join(getcompletion(a:ArgLead, complete), "\n")
    endif
  endif
endfunction

function! s:self.debug() abort
  echo join(self._message, "\n")
endfunction


function! SpaceVim#api#vim#command#get()
    return deepcopy(s:self)
endfunction
