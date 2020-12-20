let s:suite = themis#suite('parser')
let s:assert = themis#helper('assert')

function! s:suite.escape() abort
  call s:assert.equals(
        \ vimproc#parser#split_args('echo "\""'),
        \ ['echo', '"'])
  call s:assert.equals(
        \ vimproc#parser#split_args('echo "\`test\`"'),
        \ ['echo', '`test`'])
  call s:assert.equals(vimproc#shellescape('hoge'), "'hoge'")
  call s:assert.equals(vimproc#shellescape('ho''ge'), "'ho''ge'")
endfunction

function! s:suite.comment() abort
  call s:assert.equals(
        \ vimproc#parser#split_args('echo file#1.txt'),
        \ ['echo', 'file#1.txt'])
  call s:assert.equals(
        \ vimproc#parser#split_args('echo file #1.txt'),
        \ ['echo', 'file'])
endfunction

function! s:suite.quote() abort
  let is_catched = 0
  try
    call vimproc#parser#split_args('echo "\"')
  catch /^Exception: Quote/
    let is_catched = 1
  endtry
  call s:assert.equals(is_catched, 1)
endfunction

function! s:suite.join() abort
  let is_catched = 0
  try
    call vimproc#parser#split_args('echo \')
  catch /^Exception: Join to next line/
    let is_catched = 1
  endtry
  call s:assert.equals(is_catched, 1)
endfunction

function! s:suite.parse_statements() abort
  let statements =
        \ vimproc#parser#split_statements(
        \ '"/usr/bin/clang++" --std=c++0x `pkg-config'.
        \ ' --libs opencv` "/home/me/opencv/capture.cpp"'.
        \ ' -o "/home/me/opencv/capture" && "/home/me/opencv/capture"')
  call s:assert.equals(statements,
        \ ['"/usr/bin/clang++" --std=c++0x `pkg-config'.
        \ ' --libs opencv` "/home/me/opencv/capture.cpp"'.
        \ ' -o "/home/me/opencv/capture" ', ' "/home/me/opencv/capture"'
        \ ])
endfunction

function! s:suite.backquote() abort
  call s:assert.equals(
        \ vimproc#parser#split_args('echo `echo "hoge" "piyo" "hogera"`'),
        \ [ 'echo', 'hoge', 'piyo', 'hogera' ])
  call s:assert.equals(
        \ vimproc#parser#split_args(
        \ 'echo "`curl -fs https://gist.github.com/raw/4349265/sudden-vim.py`"'),
        \ [ 'echo', system('curl -fs https://gist.github.com/raw/4349265/sudden-vim.py')])
endfunction

function! s:suite.slash_convertion() abort
  " For Vital.DateTime
  call s:assert.equals(vimproc#parser#split_args(
        \ printf('reg query "%s" /v Bias',
        \ 'HKLM\System\CurrentControlSet\Control\TimeZoneInformation')),
        \ ['reg', 'query',
        \  'HKLM\System\CurrentControlSet\Control\TimeZoneInformation',
        \  '/v', 'Bias'])
endfunction

function! s:suite.block_convertion() abort
  call s:assert.equals(vimproc#parser#parse_pipe(
        \ 'grep -inH --exclude-dir={foo} -R vim .')[0].args,
        \ ['grep', '-inH',
        \  '--exclude-dir=f', '--exclude-dir=o',
        \  '-R', 'vim', '.'])
  call s:assert.equals(vimproc#parser#parse_pipe(
        \ 'grep -inH --exclude-dir={foo,bar,baz} -R vim .')[0].args,
        \ ['grep', '-inH',
        \  '--exclude-dir=foo', '--exclude-dir=bar', '--exclude-dir=baz',
        \  '-R', 'vim', '.'])
endfunction

function! s:suite.parse_redirection() abort
  call s:assert.equals(vimproc#parser#parse_pipe(
        \ 'echo "foo" > hoge\piyo'),
        \ [{ 'args' : ['echo', 'foo'], 'fd' :
        \  { 'stdin' : '', 'stdout' : 'hogepiyo', 'stderr' : '' }}])
endfunction

" vim:foldmethod=marker:fen:
