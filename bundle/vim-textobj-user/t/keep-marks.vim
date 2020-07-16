call textobj#user#plugin('line', {
\      '-': {
\        'select-a': 'al',
\        'select-a-function': 'SelectA',
\        'select': 'il',
\        'pattern': '^\s*\zs.\{-}\ze\s*$',
\      },
\    })

function! SelectA()
  if empty(getline('.'))
    return 0
  endif

  normal! 0
  let head_pos = getpos('.')

  normal! $
  let tail_pos = getpos('.')

  return ['v', head_pos, tail_pos]
endfunction

describe 'Custom text object'
  before
    new

    silent 1 put! =[
    \   'if (!foo) {',
    \   '  bar = ''baz''',
    \   '  qux()',
    \   '}',
    \ ]
    silent $ delete _
    let @" = '*nothing changed*'
    execute 'normal!' "1G2|vj\<Esc>"
  end

  after
    close!
  end

  context 'defined by a function'
    it 'keeps ''< and ''> marks'
      TODO

      Expect @0 ==# '*nothing changed*'
      Expect [line("'<"), col("'<")] == [1, 2]
      Expect [line("'>"), col("'>")] == [2, 2]

      normal 3Gyal

      Expect @0 ==# '  qux()'
      Expect [line("'<"), col("'<")] == [1, 2]
      Expect [line("'>"), col("'>")] == [2, 2]
    end
  end

  context 'defined by a pattern'
    it 'keeps ''< and ''> marks'
      TODO

      Expect @0 ==# '*nothing changed*'
      Expect [line("'<"), col("'<")] == [1, 2]
      Expect [line("'>"), col("'>")] == [2, 2]

      normal 3Gyil

      Expect @0 ==# 'qux()'
      Expect [line("'<"), col("'<")] == [1, 2]
      Expect [line("'>"), col("'>")] == [2, 2]
    end
  end

  context 'combined with operator c'
    it 'also works fine'
      TODO

      Expect @" ==# '*nothing changed*'
      Expect [line("'<"), col("'<")] == [1, 2]
      Expect [line("'>"), col("'>")] == [2, 2]

      normal 3Gcilxyzzy

      Expect @" ==# 'qux()'
      Expect getline(1, '$') ==# [
      \   'if (!foo) {',
      \   '  bar = ''baz''',
      \   '  xyzzy',
      \   '}',
      \ ]
      Expect [line("'<"), col("'<")] == [1, 2]
      Expect [line("'>"), col("'>")] == [2, 2]
    end
  end
end

" __END__  "{{{1
" vim: foldmethod=marker
