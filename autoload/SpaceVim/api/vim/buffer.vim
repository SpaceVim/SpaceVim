let s:self = {}

fu! SpaceVim#api#vim#buffer#get()
   return deepcopy(s:self)
endf


if exists('*getcmdwintype')
  function! s:self.is_cmdwin() abort
    return getcmdwintype() !=# ''
  endfunction
else
  function! s:self.is_cmdwin() abort
    return bufname('%') ==# '[Command Line]'
  endfunction
endif

function! s:self.open(opts) abort
    let buf = get(a:opts, 'bufname', '')
    let mode = get(a:opts, 'mode', 'vertical topleft split')
    let bufopt = get(a:opts, 'cmdargs', '')
    if empty(buf)
        exe mode bufopt
    else
        exe mode buf
    endif
endfunction
