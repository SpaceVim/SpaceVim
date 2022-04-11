if exists('*strchars')
    function! clever_f#compat#strchars(str) abort
        return strchars(a:str)
    endfunction
else
    function! clever_f#compat#strchars(str) abort
        return strlen(substitute(a:str, '.', 'x', 'g'))
    endfunction
endif

if exists('*xor')
    function! clever_f#compat#xor(a, b) abort
        return xor(a:a, a:b)
    endfunction
else
    function! clever_f#compat#xor(a, b) abort
        return a:a && !a:b || !a:a && a:b
    endfunction
endif

if exists('*reg_executing')
    function! clever_f#compat#reg_executing() abort
        return reg_executing()
    endfunction
else
    " reg_executing() was introduced at Vim 8.2.0020 and Neovim 0.4.0
    function! clever_f#compat#reg_executing() abort
        return ''
    endfunction
endif
