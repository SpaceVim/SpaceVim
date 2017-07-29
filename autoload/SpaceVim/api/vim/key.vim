let s:self = {}

let s:specified_keys = {
            \ "\<F1>" : 'F1',
            \ "\<F2>" : 'F2',
            \ "\<Space>" : 'SPC',
            \ }

function! s:self.nr2name(nr) abort
    if type(a:nr) == 0
        if a:nr == 32
            return 'SPC'
        else
            return nr2char(a:nr)
        endif
    else
        return get(s:specified_keys, a:nr, '')
    endif
endfunction


function! SpaceVim#api#vim#key#get()
    return deepcopy(s:self)
endfunction
