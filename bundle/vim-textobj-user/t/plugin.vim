call textobj#user#plugin('fruit', {
\   'apple': {
\     '*pattern*': '\<\d\{4}\>',
\     'select': ['aa', 'ia'],
\     'move-n': 'ja',
\     'move-p': 'ka',
\   },
\   'banana': {
\     '*pattern*': ['<<', '>>'],
\     'select-a': 'ab',
\     'select-i': 'ib',
\   },
\   '-': {
\     '*select-function*': 'SelectCherry',
\     'select': ['ac', 'ic'],
\   },
\ })

function! RhsesOf(lhs)
  return map(['n', 'x', 's', 'o', 'i', 'c', 'l'],
  \          'maparg(' . string(a:lhs) . ', v:val)')
endfunction
function! StatusOf(lhs)
  return map(RhsesOf(a:lhs), 'v:val != ""')
endfunction

describe 'textobj#user#plugin'
  it 'defines default UI key mappings'
    let x = ''

    let o = '<Plug>(textobj-fruit-apple)'
    Expect RhsesOf('aa') ==# [x, o, x, o, x, x, x]
    Expect RhsesOf('ia') ==# [x, o, x, o, x, x, x]
    let o = '<Plug>(textobj-fruit-apple-n)'
    Expect RhsesOf('ja') ==# [o, o, x, o, x, x, x]
    let o = '<Plug>(textobj-fruit-apple-p)'
    Expect RhsesOf('ka') ==# [o, o, x, o, x, x, x]

    let o = '<Plug>(textobj-fruit-banana-a)'
    Expect RhsesOf('ab') ==# [x, o, x, o, x, x, x]
    let o = '<Plug>(textobj-fruit-banana-i)'
    Expect RhsesOf('ib') ==# [x, o, x, o, x, x, x]

    let o = '<Plug>(textobj-fruit)'
    Expect RhsesOf('ac') ==# [x, o, x, o, x, x, x]
    Expect RhsesOf('ic') ==# [x, o, x, o, x, x, x]
  end

  it 'defines named key mappings'
    Expect StatusOf('<Plug>(textobj-fruit-apple)') ==# [0, 1, 1, 1, 0, 0, 0]
    Expect StatusOf('<Plug>(textobj-fruit-apple-n)') ==# [1, 1, 1, 1, 0, 0, 0]
    Expect StatusOf('<Plug>(textobj-fruit-apple-p)') ==# [1, 1, 1, 1, 0, 0, 0]
    Expect StatusOf('<Plug>(textobj-fruit-banana-a)') ==# [0, 1, 1, 1, 0, 0, 0]
    Expect StatusOf('<Plug>(textobj-fruit-banana-i)') ==# [0, 1, 1, 1, 0, 0, 0]
    Expect StatusOf('<Plug>(textobj-fruit)') ==# [0, 1, 1, 1, 0, 0, 0]
  end

  it 'defines an Ex command to define default UI key mappings'
    TODO
  end

  it 'works'
    TODO
  end
end
