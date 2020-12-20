# vim-textobj-user - Create your own text objects

[![Build Status](https://travis-ci.org/kana/vim-textobj-user.png)](https://travis-ci.org/kana/vim-textobj-user)

vim-textobj-user is a Vim plugin to create your own text objects without pain.
It is hard to create text objects, because there are many pitfalls to deal
with.  This plugin hides such details and provides a declarative way to define
text objects.  You can use regular expressions to define simple text objects,
or use functions to define complex ones.




## Examples

### Simple text objects defined by a pattern

Define `ad`/`id` to select a date such as `2013-03-16`, and
define `at`/`it` to select a time such as `22:04:21`:

```vim
call textobj#user#plugin('datetime', {
\   'date': {
\     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
\     'select': ['ad', 'id'],
\   },
\   'time': {
\     'pattern': '\<\d\d:\d\d:\d\d\>',
\     'select': ['at', 'it'],
\   },
\ })
```


### Simple text objects surrounded by a pair of patterns

Define `aA` to select text from `<<` to the matching `>>`, and
define `iA` to select text inside `<<` and `>>`:

```vim
call textobj#user#plugin('braces', {
\   'angle': {
\     'pattern': ['<<', '>>'],
\     'select-a': 'aA',
\     'select-i': 'iA',
\   },
\ })
```


### Complex text objects defined by functions

Define `al` to select the current line, and
define `il` to select the current line without indentation:

```vim
call textobj#user#plugin('line', {
\   '-': {
\     'select-a-function': 'CurrentLineA',
\     'select-a': 'al',
\     'select-i-function': 'CurrentLineI',
\     'select-i': 'il',
\   },
\ })

function! CurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! CurrentLineI()
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
```


### Text objects for a specific filetype

Define `a(` to select text from `\left(` to the matching `\right)`, and
define `i(` to select text inside `\left(` to the matching `\right)`,
but *only for tex files*:

```vim
call textobj#user#plugin('tex', {
\   'paren-math': {
\     'pattern': ['\\left(', '\\right)'],
\     'select-a': [],
\     'select-i': [],
\   },
\ })

augroup tex_textobjs
  autocmd!
  autocmd FileType tex call textobj#user#map('tex', {
  \   'paren-math': {
  \     'select-a': '<buffer> a(',
  \     'select-i': '<buffer> i(',
  \   },
  \ })
augroup END
```




## Further reading

You can define your own text objects like the above examples.  See also
[the reference manual](https://github.com/kana/vim-textobj-user/blob/master/doc/textobj-user.txt)
for more details.

There are many text objects written with vim-textobj-user.
If you want to find useful ones, or to know how they are implemented,
see [a list of text objects implemented with
vim-textobj-user](https://github.com/kana/vim-textobj-user/wiki).




<!-- vim: set expandtab shiftwidth=4 softtabstop=4 textwidth=78 : -->
