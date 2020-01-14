scriptencoding utf-8

"
" nerd-commenter plugin settings
"

" Add extra space around delimiters when commenting, remove them when
" uncommenting
let g:NERDSpaceDelims = 1
let g:NERDCreateDefaultMappings = 0

" Always remove the extra spaces when uncommenting regardless of whether
" NERDSpaceDelims is set
let g:NERDRemoveExtraSpaces = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code
" indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a
" region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Always use alternative delimiter
let g:NERD_c_alt_style = 1
let g:NERDCustomDelimiters = {'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' }}
let g:ft = ''
fu! NERDCommenter_before()
  if &ft ==# 'markdown'
    let g:ft = 'markdown'
    let cf = context_filetype#get()
    if cf.filetype !=# 'markdown'
      exe 'setf ' . cf.filetype
    endif
  endif
endfu
fu! NERDCommenter_after()
  if g:ft ==# 'markdown'
    setf markdown
    let g:ft = ''
  endif
endfu
