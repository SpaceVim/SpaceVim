function! Normal(s)
  execute 'silent!' 'normal' a:s
endfunction

describe 'textobj#user#map'
  before
    new
  end

  after
    close!
  end

  it 'defines key mappings to use text objects'
    call textobj#user#map('datetime', {
    \   'time1': {
    \     'select': ['<buffer> aT', '<buffer> iT', '<buffer> <C-x>y'],
    \     'move-n': '<buffer> j',
    \   }
    \ })
    Expect maparg('aT', 'n') ==# ''
    Expect maparg('aT', 'o') ==# '<Plug>(textobj-datetime-time1)'
    Expect maparg('aT', 's') ==# ''
    Expect maparg('aT', 'x') ==# '<Plug>(textobj-datetime-time1)'
    Expect maparg('iT', 'n') ==# ''
    Expect maparg('iT', 'o') ==# '<Plug>(textobj-datetime-time1)'
    Expect maparg('iT', 's') ==# ''
    Expect maparg('iT', 'x') ==# '<Plug>(textobj-datetime-time1)'
    Expect maparg('<C-x>y', 'n') ==# ''
    Expect maparg('<C-x>y', 'o') ==# '<Plug>(textobj-datetime-time1)'
    Expect maparg('<C-x>y', 's') ==# '<Plug>(textobj-datetime-time1)'
    Expect maparg('<C-x>y', 'x') ==# '<Plug>(textobj-datetime-time1)'
    Expect maparg('j', 'n') ==# '<Plug>(textobj-datetime-time1-n)'
    Expect maparg('j', 'o') ==# '<Plug>(textobj-datetime-time1-n)'
    Expect maparg('j', 's') ==# ''
    Expect maparg('j', 'x') ==# '<Plug>(textobj-datetime-time1-n)'
  end

  it 'defines failsafe key mappings for unexisting text objects'
    Expect maparg('<Plug>(textobj-datetime-time2)', 'o') == ''
    Expect maparg('<Plug>(textobj-datetime-time2)', 's') == ''
    Expect maparg('<Plug>(textobj-datetime-time2)', 'x') == ''

    call textobj#user#map('datetime', {
    \   'time2': {
    \     'select': ['<buffer> aT', '<buffer> iT'],
    \   }
    \ })

    Expect maparg('<Plug>(textobj-datetime-time2)', 'o') != ''
    Expect maparg('<Plug>(textobj-datetime-time2)', 's') != ''
    Expect maparg('<Plug>(textobj-datetime-time2)', 'x') != ''

    Expect expr { Normal("vaT\<Esc>") } to_throw 'Text object.*not defined'
    Expect expr { Normal("daT") } to_throw 'Text object.*not defined'

    noremap <buffer> <Plug>(textobj-datetime-time2)  <Nop>

    Expect expr { Normal("vaT\<Esc>") } not to_throw
    Expect expr { Normal("daT") } not to_throw
  end

  it 'does not define failsafe key mappings for existing text objects'
    noremap <buffer> <Plug>(textobj-datetime-time3)  <Nop>

    call textobj#user#map('datetime', {
    \   'time3': {
    \     'select': ['<buffer> aT', '<buffer> iT'],
    \   }
    \ })

    Expect expr { Normal("vaT\<Esc>") } not to_throw
    Expect expr { Normal("daT") } not to_throw
  end
end
