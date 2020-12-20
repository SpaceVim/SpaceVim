" Copyright (c) 2015 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists("g:loaded_vim_emoji")
  finish
endif
let g:loaded_vim_emoji = 1

if exists("*strwidth")
  function! s:strwidth(str)
    return strwidth(a:str)
  endfunction
else
  function! s:strwidth(str)
    return len(split(a:str, '\zs'))
  endfunction
endif

" Deprecated
function! emoji#available()
  return 1
endfunction

function! emoji#list()
  return keys(emoji#data#dict())
endfunction

function! emoji#for(name, ...)
  let emoji = get(emoji#data#dict(), tolower(a:name), '')
  if empty(emoji)
    return a:0 > 0 ? a:1 : emoji
  endif

  let echar = type(emoji) == 0 ? nr2char(emoji) :
        \ join(map(copy(emoji), 'nr2char(v:val)'), '')
  let pad = get(a:, 2, 1)
  if pad
    return echar . repeat(' ', 1 + pad - s:strwidth(echar))
  else
    return echar
  endif
endfunction

let s:max_score = 1000
function! s:score(haystack, needle)
  let idx = stridx(a:haystack, a:needle)
  if idx < 0  | return idx             | endif
  if idx == 0 | return s:max_score * 2 | endif
  let bonus = (a:haystack[idx - 1] =~ '[^0-9a-zA-Z]') * s:max_score
  return bonus + s:max_score - idx
endfunction

function! emoji#complete(findstart, base)
  if !exists('s:emojis')
    let s:emojis = map(sort(keys(emoji#data#dict())),
          \ emoji#available() ?
          \ '{ "word": ":".v:val.":", "kind": emoji#for(v:val) }' :
          \ '{ "word": ":".v:val.":" }')
  endif

  if a:findstart
    return match(getline('.')[0:col('.') - 1], ':[^: \t]*$')
  elseif empty(a:base)
    return s:emojis
  else
    augroup emoji_complete_redraw
      autocmd!
      autocmd CursorMoved,CursorMovedI,InsertLeave * redraw!
            \| augroup emoji_complete_redraw
            \|   execute 'autocmd!'
            \| augroup END
            \| augroup! emoji_complete_redraw
    augroup END

    let matches = filter(map(copy(s:emojis), '[s:score(v:val.word, a:base[1:]), v:val]'), 'v:val[0] >= 0')
    function! EmojiSort(t1, t2)
      if a:t1[0] == a:t2[0]
        return a:t1[1].word <= a:t2[1].word ? -1 : 1
      endif
      return a:t1[0] >= a:t2[0] ? -1 : 1
    endfunction
    let matches = sort(matches, 'EmojiSort')
    delfunction EmojiSort
    return map(matches, 'v:val[1]')
  endif
endfunction

