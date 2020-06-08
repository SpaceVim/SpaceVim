function! CharacterwiseSelectA()
  if empty(getline('.'))
    return 0
  endif

  normal! 0
  let head_pos = getpos('.')

  normal! $
  let tail_pos = getpos('.')

  return ['v', head_pos, tail_pos]
endfunction

function! CharacterwiseSelectI()
  if empty(getline('.'))
    return 0
  endif

  normal! ^
  let head_pos = getpos('.')

  normal! g_
  let tail_pos = getpos('.')

  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction

function! LinewiseSelectA()
  let head_pos = getpos('.')
  normal! j
  let tail_pos = getpos('.')
  return ['V', head_pos, tail_pos]
endfunction

call textobj#user#plugin('custom', {
\      'characterwise': {
\        'select-a': 'ac', '*select-a-function*': 'CharacterwiseSelectA',
\        'select': 'iC', 'pattern': '^\s*\zs.*\S\ze\s*$',
\      },
\      'linewise': {
\        'select-a': 'al', '*select-a-function*': 'LinewiseSelectA',
\      },
\      'pair': {
\        'pattern': ['\V(*', '\V*)'],
\        'select-a': 'ap',
\        'select-i': 'ip',
\      },
\    })
" Note that pattern-based text objects are always characterwsise.

describe 'Custom text object'
  before
    new
    put ='abc def ghi'
    put ='  jkl mno pqr  '
    put ='foo \'
    put ='  bar'
    put ='    baz \'
    put ='  qux \'
    put ='xyz'
    put ='aaa (* bbb ccc *) ddd'
    put ='eee (* fff'
    put ='ggg *) hhh'
    1 delete _

    function! b:.test(selection)
      let &selection = a:selection

      let cases = [
      \   [1, 1, 'ac', 'abc def ghi'],
      \   [2, 1, 'ac', '  jkl mno pqr  '],
      \   [1, 1, 'iC', 'abc def ghi'],
      \   [2, 1, 'iC', 'jkl mno pqr'],
      \   [3, 1, 'al', "foo \\\n  bar\n"],
      \   [4, 1, 'al', "  bar\n    baz \\\n"],
      \   [5, 1, 'al', "    baz \\\n  qux \\\n"],
      \   [8, 5, 'ap', "(* bbb ccc *)"],
      \   [9, 5, 'ap', "(* fff\nggg *)"],
      \   [8, 5, 'ip', " bbb ccc "],
      \   [9, 5, 'ip', " fff\nggg "],
      \ ]

      for c in cases
        let [ln, cn, object, result] = c
        call cursor(ln, cn)
        execute 'normal' 'y' . object
        Expect [ln, object, strtrans(@0)] ==# [ln, object, strtrans(result)]
      endfor
    endfunction
  end

  after
    close!
    set selection&
  end

  it 'works if &selection is inclusive'
    call b:.test('inclusive')
  end

  it 'works if &selection is exclusive'
    call b:.test('exclusive')
  end
end
