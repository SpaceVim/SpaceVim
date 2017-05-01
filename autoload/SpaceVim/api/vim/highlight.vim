let s:self = {}

function! s:self.group2dict(name) abort
    let id = index(map(range(999), 'synIDattr(v:val, "name")'), a:name)
    if id == -1
        return {}
    endif
    let rst = {
                \ 'name' : synIDattr(id, 'name'),
                \ 'ctermbg' : synIDattr(id, 'bg'),
                \ 'ctermfg' : synIDattr(id, 'fg'),
                \ 'bold' : synIDattr(id, 'bold'),
                \ 'italic' : synIDattr(id, 'italic'),
                \ 'underline' : synIDattr(id, 'underline'),
                \ 'guibg' :synIDattr(id, 'bg#'),
                \ 'guifg' : synIDattr(id, 'fg#'),
                \ }
    return rst
endfunction

function! SpaceVim#api#vim#highlight#get() abort
    return deepcopy(s:self)
endfunction
