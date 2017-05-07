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
    let mode = get(a:opts, 'mode', 'vertical topleft split')
    let buf = get(a:opts, 'bufname', '')
    let cmd = get(a:opts, 'cmd', '')
    if empty(buf)
        exe mode buf cmd
    else
        exe mode buf
    endif
    exe cmd
endfunction


func! s:self.resize(size, ...) abort
    let cmd = get(a:000, 0, 'vertical')
    exe cmd 'resize' a:size
endf

let s:self._buffer_handle_funcs = {}

function! s:self.def_handle_func(ft, func) abort
    let self._buffer_handle_funcs[a:ft] = a:func
endf

function! s:self.handle() abort
if index(keys(self._buffer_handle_funcs), &filetype) != -1
    call call(self._buffer_handle_funcs[&filetype], [])
endif
endfunction

fu! SpaceVim#api#vim#buffer#get()
    return deepcopy(s:self)
endf
