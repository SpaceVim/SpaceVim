call vspec#hint({'sid': 'textobj#user#_sid()'})

let s:counter = [0]
function! s:increment()
  let s:counter[0] += 1
  return 0
endfunction

call textobj#user#plugin('dummy', {
\   '-': {
\     '*sfile*': expand('<sfile>:p'),
\     '*select-function*': 's:increment',
\     'select': ['ad', 'id'],
\   },
\ })

describe '*sfile*'
  it 'can call a script-local function'
    let c = s:counter

    Expect c[0] == 0

    execute 'normal' "vid\<Esc>"
    Expect c[0] == 1

    execute 'normal' "vad\<Esc>"
    Expect c[0] == 2
  end
end

describe 's:normalize_path'
  it 'normalizes a backslashed path into a forwardslashed path'
    Expect Call(
    \   's:normalize_path',
    \   '/c/Users/who\vimfiles\plugin\textobj\foo.vim'
    \ ) ==# '/c/Users/who/vimfiles/plugin/textobj/foo.vim'
  end
end
