call textobj#user#plugin('alwaysfail', {
\   'pattern1': {
\     'pattern': 'no such pattern',
\     'select': '[p]',
\   },
\   'pattern2': {
\     'pattern': ['no such', 'pattern'],
\     'select-a': '[pa]',
\     'select-i': '[pi]',
\   },
\   'function': {
\     'select': '[sf]',
\     'select-function': 'CannotSelect',
\     'select-a': '[saf]',
\     'select-a-function': 'CannotSelect',
\     'select-i': '[sif]',
\     'select-i-function': 'CannotSelect',
\   },
\ })

function! CannotSelect()
  return 0
endfunction

describe 'textobj-user'
  before
    new
    put ='1'
    put ='22'
    put ='333'
    put ='4444'
    put ='55555'
    put ='666666'
    1 delete _
  end

  after
    close!
  end

  it 'operates on nothing if a proper text object is not found'
    for obj in ['p', 'pa', 'pi', 'sf', 'saf', 'sif']
      call cursor(3, 2)
      execute 'normal' printf('y[%s]', obj)
      Expect @0 == ''
      Expect [obj, line("'["), col("'["), line("']"), col("']")]
      \ == [obj, 3, 2, 3, 2]
      Expect [obj, line("'<"), col("'<"), line("'>"), col("'>")]
      \ == [obj, 0, 0, 0, 0]
    endfor
  end

  it 'keeps the current selection if a proper text object is not found'
    for obj in ['p', 'pa', 'pi', 'sf', 'saf', 'sif']
      call cursor(3, 2)
      execute 'normal' printf('vjjl[%s]y', obj)
      Expect [obj, line("'["), col("'["), line("']"), col("']")]
      \ == [obj, 3, 2, 5, 3]
      Expect [obj, line("'<"), col("'<"), line("'>"), col("'>")]
      \ == [obj, 3, 2, 5, 3]
    endfor
  end
end
