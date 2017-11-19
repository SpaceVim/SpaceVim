let s:self = {}

" see: man 3 strftime
function! s:self.current_time() abort
  return strftime('%I:%M %p')   
endfunction

function! s:self.current_date() abort
  return strftime('%a %b %d')
endfunction


function! SpaceVim#api#time#get() abort
    return deepcopy(s:self)
endfunction
