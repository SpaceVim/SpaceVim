call textobj#user#plugin('single', {
\   'default': {
\     'pattern': 'foo\_.*bar',
\     'select': 'asd',
\   },
\   'char': {
\     'pattern': 'foo\_.*bar',
\     'region-type': 'v',
\     'select': 'asc',
\   },
\   'line': {
\     'pattern': 'foo\_.*bar',
\     'region-type': 'V',
\     'select': 'asl',
\   },
\   'block': {
\     'pattern': 'foo\_.*bar',
\     'region-type': "\<C-v>",
\     'select': 'asb',
\   },
\ })

call textobj#user#plugin('paired', {
\   'default': {
\     'pattern': ['foo', 'bar'],
\     'select-a': 'apd',
\     'select-i': 'ipd',
\   },
\   'char': {
\     'pattern': ['foo', 'bar'],
\     'region-type': 'v',
\     'select-a': 'apc',
\     'select-i': 'ipc',
\   },
\   'line': {
\     'pattern': ['^.*foo.*\n', '^.*bar.*\n'],
\     'region-type': 'V',
\     'select-a': 'apl',
\     'select-i': 'ipl',
\   },
\   'block': {
\     'pattern': ['foo', 'bar'],
\     'region-type': "\<C-v>",
\     'select-a': 'apb',
\     'select-i': 'ipb',
\   },
\ })

function! TheLastRegion()
  return [visualmode(), [line("'<"), col("'<")], [line("'>"), col("'>")]]
endfunction

describe 'Single-pattern text object'
  before
    new
    0 put =[
    \   '___foo___',
    \   '_________',
    \   '___bar___',
    \ ]
  end

  after
    close!
  end

  it 'is characterwise by default'
    execute 'normal' "2Gvasd\<Esc>"
    Expect TheLastRegion() ==# ['v', [1, 4], [3, 6]]
  end

  it 'can be customized to be characterwise'
    execute 'normal' "2Gvasc\<Esc>"
    Expect TheLastRegion() ==# ['v', [1, 4], [3, 6]]
  end

  it 'can be customized to be linewise'
    execute 'normal' "2Gvasl\<Esc>"
    Expect TheLastRegion() ==# ['V', [1, 1], [3, 10]]
  end

  it 'can be customized to be blockwise'
    execute 'normal' "2Gvasb\<Esc>"
    Expect TheLastRegion() ==# ["\<C-v>", [1, 4], [3, 6]]
  end
end

describe 'Paired-pattern text object'
  before
    new
    0 put =[
    \   '___foo___',
    \   '_________',
    \   '___bar___',
    \ ]
  end

  after
    close!
  end

  it 'is characterwise by default'
    execute 'normal' "2Gvapd\<Esc>"
    Expect TheLastRegion() ==# ['v', [1, 4], [3, 6]]

    execute 'normal' "2Gvipd\<Esc>"
    Expect TheLastRegion() ==# ['v', [1, 7], [3, 3]]
  end

  it 'can be customized to be characterwise'
    execute 'normal' "2Gvapc\<Esc>"
    Expect TheLastRegion() ==# ['v', [1, 4], [3, 6]]

    execute 'normal' "2Gvipc\<Esc>"
    Expect TheLastRegion() ==# ['v', [1, 7], [3, 3]]
  end

  it 'can be customized to be linewise'
    execute 'normal' "2Gvapl\<Esc>"
    Expect TheLastRegion() ==# ['V', [1, 1], [3, 10]]

    execute 'normal' "2Gvipl\<Esc>"
    Expect TheLastRegion() ==# ['V', [2, 1], [2, 10]]
  end

  it 'can be customized to be blockwise'
    execute 'normal' "2Gvapb\<Esc>"
    Expect TheLastRegion() ==# ["\<C-v>", [1, 4], [3, 6]]

    execute 'normal' "2Gvipb\<Esc>"
    Expect TheLastRegion() ==# ["\<C-v>", [1, 7], [3, 3]]
  end
end
