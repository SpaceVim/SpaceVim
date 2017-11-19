scriptencoding utf-8
let s:self = {}

function! s:self.battery_status(v) abort
  if a:v >= 90
    return ''
  elseif a:v >= 75
    return ''
  elseif a:v >= 50
    return ''
  elseif a:v >= 25
    return ''
  else
    return ''
  endif
endfunction

function! SpaceVim#api#unicode#icon#get()

  return deepcopy(s:self)

endfunction
