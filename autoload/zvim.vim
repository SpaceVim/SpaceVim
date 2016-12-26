function! zvim#tab() abort
    if getline('.')[col('.')-2] ==# '{'&& pumvisible()
        return "\<C-n>"
    endif
    if neosnippet#expandable() && getline('.')[col('.')-2] ==# '(' && !pumvisible()
        return "\<Plug>(neosnippet_expand)"
    elseif neosnippet#jumpable() && getline('.')[col('.')-2] ==# '(' && !pumvisible() && !neosnippet#expandable()
        return "\<plug>(neosnippet_jump)"
    elseif neosnippet#expandable_or_jumpable() && getline('.')[col('.')-2] !=#'('
        return "\<plug>(neosnippet_expand_or_jump)"
    elseif pumvisible()
        return "\<C-n>"
    else
        return "\<tab>"
    endif
endfunction

function! zvim#enter() abort
    if pumvisible()
        if getline('.')[col('.') - 2]==# '{'
            return "\<Enter>"
        elseif g:settings.autocomplete_method ==# 'neocomplete'||g:settings.autocomplete_method ==# 'deoplete'
            return "\<C-y>"
        else
            return "\<esc>a"
        endif
    elseif getline('.')[col('.') - 2]==#'{'&&getline('.')[col('.')-1]==#'}'
        return "\<Enter>\<esc>ko"
    else
        return "\<Enter>"
    endif
endfunction

function! zvim#format() abort
    let save_cursor = getcurpos()
    normal! gg=G
    call setpos('.', save_cursor)
endfunction
