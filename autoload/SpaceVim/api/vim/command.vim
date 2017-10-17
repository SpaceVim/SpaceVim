let s:self = {}

let s:self.options = {}

function! s:self.complete(ArgLead, CmdLine, CursorPos) abort
  return join(keys(self.options), "\n")
endfunction


function! SpaceVim#api#vim#command#get()
    return deepcopy(s:self)
endfunction
