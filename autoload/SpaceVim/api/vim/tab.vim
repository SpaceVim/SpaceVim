let s:self = {}

let s:self._tree = {}

function! s:self._update() abort
    let tabnr = tabpagenr('$')
    if tabnr > 1
        for i in range(1, tabnr)
            let buffers = tabpagebuflist(i)
            let self._tree[i] = buffers
        endfor
    endif
endfunction

function! s:self._jump(tabnr, bufid) abort
    
endfunction
