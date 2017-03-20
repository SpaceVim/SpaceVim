function! SpaceVim#api#data#list#get() abort
    return map({'pop' : '',
                \ 'push' : '',
                \ 'shift' : '',
                \ 'unshift' : '',
                \ 'uniq' : '',
                \ 'uniq_by' : '',
                \ 'char_range' : '',
                \ 'has' : '',
                \ 'has_index' : '',
                \ },
                \ "function('s:' . v:key)"
                \ )
endfunction

function! s:pop(list) abort
    return remove(a:list, -1)
endfunction

function! s:push(list, val) abort
  call add(a:list, a:val)
  return a:list
endfunction

function! s:shift(list) abort
    return remove(a:list, 0)
endfunction

function! s:unshift(list, val) abort
    return insert(a:list, a:val)
endfunction

function! s:uniq(list) abort
    return s:uniq_by(a:list, 'v:val')
endfunction

function! s:uniq_by(list, f) abort
    let list = map(copy(a:list), printf('[v:val, %s]', a:f))
    let i = 0
    let seen = {}
    while i < len(list)
        let key = string(list[i][1])
        if has_key(seen, key)
            call remove(list, i)
        else
            let seen[key] = 1
            let i += 1
        endif
    endwhile
    return map(list, 'v:val[0]')
endfunction

function! s:clear(list) abort
  if !empty(a:list)
    unlet! a:list[0 : len(a:list) - 1]
  endif
  return a:list
endfunction

function! s:char_range(from, to) abort
  return map(
  \   range(char2nr(a:from), char2nr(a:to)),
  \   'nr2char(v:val)'
  \)
endfunction

function! s:has(list, val) abort
    return index(a:list, a:val) != -1
endfunction

function! s:has_index(list, index) abort
    return 0 <= a:index && a:index < len(a:list)
endfunction

" vim:set et sw=2 cc=80:
