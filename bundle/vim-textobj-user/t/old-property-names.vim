function! Target()
  let start_position = getpos('.')
  normal! e
  let end_position = getpos('.')
  return ['v', start_position, end_position]
endfunction

function! s:target()
  let start_position = getpos('.')
  normal! w
  let end_position = getpos('.')
  return ['v', start_position, end_position]
endfunction

call textobj#user#plugin('newstyle', {
\   'select-pattern': {
\     'pattern': 'pat*ern',
\     'select': ['ansp', 'insp'],
\   },
\   'select-function-global': {
\     'select-function': 'Target',
\     'select': ['ansfg', 'insfg'],
\   },
\   'select-function-local': {
\     'sfile': expand('<sfile>:p'),
\     'select-function': 's:target',
\     'select': ['ansfs', 'insfs'],
\   },
\ })

call textobj#user#plugin('oldstyle', {
\   'select-pattern': {
\     '*pattern*': 'pat*ern',
\     'select': ['aosp', 'iosp'],
\   },
\   'select-function-global': {
\     '*select-function*': 'Target',
\     'select': ['aosfg', 'iosfg'],
\   },
\   'select-function-local': {
\     '*sfile*': expand('<sfile>:p'),
\     '*select-function*': 's:target',
\     'select': ['aosfs', 'iosfs'],
\   },
\ })

describe '"*pattern*"'
  before
    new
    call setline(1, 'pat patttttern put')
  end

  after
    close!
  end

  it 'is treated as same as "pattern"'
    let @0 = ''
    normal! gg0
    normal yaosp
    let old_result = @0

    let @0 = ''
    normal! gg0
    normal yansp
    let new_result = @0

    Expect old_result ==# new_result
    Expect old_result ==# 'patttttern'
  end
end

describe '"*{property}-function*"'
  before
    new
    call setline(1, 'pat patttttern put')
  end

  after
    close!
  end

  it 'is treated as same as "{property}-function"'
    let @0 = ''
    normal! gg0
    normal yaosfg
    let old_result = @0

    let @0 = ''
    normal! gg0
    normal yansfg
    let new_result = @0

    Expect old_result ==# new_result
    Expect old_result ==# 'pat'
  end
end

describe '"*sfile*"'
  before
    new
    call setline(1, 'pat patttttern put')
  end

  after
    close!
  end

  it 'is treated as same as "sfile"'
    let @0 = ''
    normal! gg0
    normal yaosfs
    let old_result = @0

    let @0 = ''
    normal! gg0
    normal yansfs
    let new_result = @0

    Expect old_result ==# new_result
    Expect old_result ==# 'pat p'
  end
end
