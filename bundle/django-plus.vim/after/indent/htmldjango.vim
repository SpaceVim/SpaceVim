" HTML is tricky as hell.  Any number of plugins could want involvement in the
" indentation.  From what I've seen, they chain the previous indentexpr making
" the b:did_indent check a little pointless.  Since running as an
" 'after/indent' script, do not unlet b:did_indent before including
" indent/html.vim since it should already be loaded by now.
runtime! indent/html.vim
let b:did_indent = 1

if &l:indentexpr == ''
  if &l:cindent
    let &l:indentexpr = 'cindent(v:lnum)'
  else
    let &l:indentexpr = 'indent(prevnonblank(v:lnum-1))'
  endif
endif

let b:djangoplus_indentexpr = &l:indentexpr

setlocal indentexpr=djangoplus#htmldjango_indent()
setlocal indentkeys=o,O,*<Return>,{,},o,O,!^F,<>>
