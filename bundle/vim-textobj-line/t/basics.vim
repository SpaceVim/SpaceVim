runtime! plugin/textobj/line.vim

function! s:check(move_cmd, op_cmd, expected_value)
  let @0 = '*nothing yanked*'
  execute 'normal!' a:move_cmd
  execute 'normal' a:op_cmd
  Expect @0 ==# a:expected_value
endfunction




describe '<Plug>(textobj-line-select-a)'
  before
    new
  end

  after
    close!
  end

  it 'selects all characters in the current line but the end of line'
    silent 1 put! =['', '   foo bar baz   ', '', 'x', '', '   ', '', '', '']

    call s:check('2gg0', 'valy', '   foo bar baz   ')
    call s:check('2gg0', 'yal', '   foo bar baz   ')
    call s:check('2gg0ww', 'valy', '   foo bar baz   ')
    call s:check('2gg0ww', 'yal', '   foo bar baz   ')
    call s:check('4gg0', 'valy', 'x')
    call s:check('4gg0', 'yal', 'x')
    call s:check('6gg2|', 'valy', '   ')
    call s:check('6gg2|', 'yal', '   ')
    call s:check('8gg0', 'valy', "\n")  " NB: Cannot select empty text in Visual mode.
    call s:check('8gg0', 'yal', '')
  end
end




describe '<Plug>(textobj-line-select-i)'
  before
    new
  end

  after
    close!
  end

  it 'selects all characters in the current line but surrounding spaces'
    silent 1 put! =['', '   foo bar baz   ', '', 'x', '', '   ', '', '', '']

    call s:check('2gg0', 'vily', 'foo bar baz')
    call s:check('2gg0', 'yil', 'foo bar baz')
    call s:check('2gg0ww', 'vily', 'foo bar baz')
    call s:check('2gg0ww', 'yil', 'foo bar baz')
    call s:check('4gg0', 'vily', 'x')
    call s:check('4gg0', 'yil', 'x')
    call s:check('6gg2|', 'vily', ' ')  " NB: Cannot select empty text in Visual mode.
    call s:check('6gg2|', 'yil', '')
    call s:check('8gg0', 'vily', "\n")  " NB: Cannot select empty text in Visual mode.
    call s:check('8gg0', 'yil', '')
  end
end
