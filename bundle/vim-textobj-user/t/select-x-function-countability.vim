call textobj#user#plugin('nthline', {
\   '-': {
\     'select': '[sf]',
\     'select-function': 'SelectNthLine',
\     'select-a': '[saf]',
\     'select-a-function': 'SelectNthLine',
\     'select-i': '[sif]',
\     'select-i-function': 'SelectNthLine',
\   }
\ })

function! SelectNthLine()
  execute 'normal!' v:count1.'gg'
  normal! 0
  let b = getpos('.')
  normal! $
  let e = getpos('.')
  return ['V', b, e]
endfunction

describe 'textobj-user'
  before
    new
    put ='1'
    put ='22'
    put ='333'
    put ='4444'
    put ='55555'
    1 delete _

    function! b:.test_countability_in_operator_pending_mode(obj)
      let cases = [
      \   ['', 1, 1, 1, 2],
      \   [1, 1, 1, 1, 2],
      \   [2, 2, 1, 2, 3],
      \   [3, 3, 1, 3, 4],
      \   [4, 4, 1, 4, 5],
      \   [5, 5, 1, 5, 6],
      \   [100, 5, 1, 5, 6],
      \ ]
      for [c, ebl, ebc, eel, eec] in cases
        normal! gg
        execute 'normal' c.'y'.a:obj
        Expect [a:obj, c, line("'["), col("'["), line("']"), col("']")]
        \  ==# [a:obj, c, ebl, ebc, eel, eec]
      endfor
    endfunction

    function! b:.test_countability_in_visual_mode(obj)
      let cases = [
      \   ['', 1, 1, 1, 2],
      \   [1, 1, 1, 1, 2],
      \   [2, 2, 1, 2, 3],
      \   [3, 3, 1, 3, 4],
      \   [4, 4, 1, 4, 5],
      \   [5, 5, 1, 5, 6],
      \   [100, 5, 1, 5, 6],
      \ ]
      for [c, ebl, ebc, eel, eec] in cases
        normal! gg
        execute 'normal' 'vj'.c.a:obj.'y'
        Expect [a:obj, c, line("'["), col("'["), line("']"), col("']")]
        \  ==# [a:obj, c, ebl, ebc, eel, eec]
      endfor
    endfunction
  end

  after
    close!
  end

  describe 'select-function'
    it 'can use a count given in Operator-pending mode'
      call b:.test_countability_in_operator_pending_mode('[sf]')
    end

    it 'can use a count given in Visual mode'
      call b:.test_countability_in_visual_mode('[sf]')
    end
  end

  describe 'select-a-function'
    it 'can use a count given in Operator-pending mode'
      call b:.test_countability_in_operator_pending_mode('[saf]')
    end

    it 'can use a count given in Visual mode'
      call b:.test_countability_in_visual_mode('[saf]')
    end
  end

  describe 'select-i-function'
    it 'can use a count given in Operator-pending mode'
      call b:.test_countability_in_operator_pending_mode('[sif]')
    end

    it 'can use a count given in Visual mode'
      call b:.test_countability_in_visual_mode('[sif]')
    end
  end
end
