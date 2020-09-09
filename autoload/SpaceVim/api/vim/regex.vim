"=============================================================================
" regex.vim --- regex parser for vim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
let s:self = {}

function! s:self.parser(regex, is_perl) abort
  let vim_regex = a:regex

  " matchadd function needs \ before [%@&]
  let vim_regex = substitute(vim_regex, '\([%@&]\)', '\\\1', 'g')

  " non-greedy pattern
  " replace from what to what?
  " let vim_regex = substitute(vim_regex, '(?<!\\)\*\?', '{-}', 'g')
  " let vim_regex = substitute(vim_regex, '(?<!\\)\+\?', '{-1,}', 'g')
  " let vim_regex = substitute(vim_regex, '(?<!\\)\?\?', '{-0,1}', 'g')
  " let vim_regex = substitute(vim_regex, '(?<!\\)\{(.*?)\}\?', '{-\1}', 'g')

  if a:is_perl
    " *+, ++, ?+, {m,n}+ => *, +, ?, {m,n}
    let vim_regex = substitute(vim_regex, '(?<!\\)([*+?}])\+', '\1', 'g')
    " remove (?#....)
    let vim_regex = substitute(vim_regex, '\(\?#.*?\)', '', 'g')
    " (?=atom) => atom\@=
    let vim_regex = substitute(vim_regex, '\(\?=(.+?)\)', '(\1)@=', 'g')
    " (?!atom) => atom\@!
    let vim_regex = substitute(vim_regex, '\(\?!(.+?)\)', '(\1)@!', 'g')
    " (?<=atom) => atom\@<=
    let vim_regex = substitute(vim_regex, '\(\?<=(.+?)\)', '(\1)@<=', 'g')
    " (?<!atom) => atom\@<!
    let vim_regex = substitute(vim_regex, '\(\?<!(.+?)\)', '(\1)@<!', 'g')
    " (?>atom) => atom\@>
    let vim_regex = substitute(vim_regex, '\(\?>(.+?)\)', '(\1)@>', 'g')
  endif

  " this won't hurt although they are not the same
  let vim_regex = substitute(vim_regex, '\\A', '^', 'g')
  let vim_regex = substitute(vim_regex, '\\z', '$', 'g')
  let vim_regex = substitute(vim_regex, '\\B', '', 'g')

  " word boundary
  " \bword\b => <word>
  let vim_regex = substitute(vim_regex, '\\b\(\w\+\)\\b', '\\<\1\\>', 'g')

  " case-insensitive
  " (?i)abc => \cabc
  " (?-i)abc => \Cabc
  let vim_regex = substitute(vim_regex, '(?i)', '\\c', 'g')
  let vim_regex = substitute(vim_regex, '(?-i)', '\\C', 'g')

  " (?P<name>exp) => (exp)
  let vim_regex = substitute(vim_regex, '(?P<\w\+>\([^)]\+\))', '(\1)', 'g')

  " (?:exp) => %(exp)
  let vim_regex =  substitute(vim_regex, '(?:\([^)]\+\))', '%(\1)', 'g')

  " \a          bell (\x07)
  " \f          form feed (\x0C)
  " \v          vertical tab (\x0B)
  let vim_regex = substitute(vim_regex, '\\a', '%x07', 'g')
  let vim_regex = substitute(vim_regex, '\\f', '%x0C', 'g')
  let vim_regex = substitute(vim_regex, '\\v', '%x0B', 'g')

  " \123        octal character code (up to three digits) (when enabled)
  " \x7F        hex character code (exactly two digits)
  " let vim_regex = substitute(vim_regex, '\\(x[0-9A-Fa-f][0-9A-Fa-f])', '%\1', 'g')
  " \x{10FFFF}  any hex character code corresponding to a Unicode code point
  " \u007F      hex character code (exactly four digits)
  " \u{7F}      any hex character code corresponding to a Unicode code point
  " \U0000007F  hex character code (exactly eight digits)
  " \U{7F}      any hex character code corresponding to a Unicode code point
  " let vim_regex = substitute(vim_regex, '\\([uU])', '%\1', 'g')

  let vim_regex = substitute(vim_regex, '\[:ascii:\]', '[\\x00-\\x7F]', 'g')
  let vim_regex = substitute(vim_regex, '\[:word:\]', '[0-9A-Za-z_]', 'g')

  let vim_regex = substitute(vim_regex, '\[:alnum:\]', '[^0-9A-Za-z]', 'g')
  let vim_regex = substitute(vim_regex, '\[:alpha:\]', '[^A-Za-z]', 'g')
  let vim_regex = substitute(vim_regex, '\[:ascii:\]', '[^\x00-\x7F]', 'g')
  let vim_regex = substitute(vim_regex, '\[:blank:\]', '[^\t ]', 'g')
  let vim_regex = substitute(vim_regex, '\[:cntrl:\]', '[^\x00-\x1F\x7F]', 'g')
  let vim_regex = substitute(vim_regex, '\[:digit:\]', '[^0-9]', 'g')
  let vim_regex = substitute(vim_regex, '\[:graph:\]', '[^!-~]', 'g')
  let vim_regex = substitute(vim_regex, '\[:lower:\]', '[^a-z]', 'g')
  let vim_regex = substitute(vim_regex, '\[:print:\]', '[^ -~]', 'g')
  let vim_regex = substitute(vim_regex, '\[:punct:\]', '[^!-/:-@\[-`{-~]', 'g')
  let vim_regex = substitute(vim_regex, '\[:space:\]', '[^\t\n\r ]', 'g')
  let vim_regex = substitute(vim_regex, '\[:upper:\]', '[^A-Z]', 'g')
  let vim_regex = substitute(vim_regex, '\[:word:\]', '[^0-9A-Za-z_]', 'g')
  let vim_regex = substitute(vim_regex, '\[:xdigit:\]', '[^0-9A-Fa-f]', 'g')

  return '\v' . vim_regex

endfunction

function! SpaceVim#api#vim#regex#get() abort

  return deepcopy(s:self)

endfunction


" NOTE:
" This idea of self.parser is from:
" https://github.com/Yggdroot/LeaderF/blob/bc1ed5291191663fa3136f29bb07b8874d1226c3/autoload/leaderf/python/leaderf/rgExpl.py#L300-L380
