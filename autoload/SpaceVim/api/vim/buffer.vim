let s:self = {}


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
    let Initfunc = get(a:opts, 'initfunc', '')
    let cmd = get(a:opts, 'cmd', '')
    if empty(buf)
        exe mode | enew
    else
        exe mode buf
    endif
    if !empty(Initfunc)
        call call(Initfunc, [])
    endif

    if !empty(cmd)
        exe cmd
    endif
endfunction


func! s:self.resize(size, ...) abort
	let cmd = get(a:000, 0, 'vertical')
	exe cmd 'resize' a:size
endf

function! s:self.listed_buffers() abort
    return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction

fu! SpaceVim#api#vim#buffer#get() abort
   return deepcopy(s:self)
endf
