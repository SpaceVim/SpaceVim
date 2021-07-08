
function! indent_blankline#helper#GetListChar(key, fallback)
    let l:list_chars = {}

    for l:char in split(&listchars, ',')
        let l:split = split(l:char, ':')
        let l:list_chars[l:split[0]] = l:split[1]
    endfor

    return get(l:list_chars, a:key, a:fallback)
endfunction
