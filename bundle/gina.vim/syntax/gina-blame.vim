scriptencoding utf-8

if exists('b:current_syntax')
  finish
endif

" Ref: https://github.com/w0ng/vim-hybrid
let s:GUI_COLORS = [
      \ '#282A2E', '#A54242', '#8C9440', '#DE935F',
      \ '#5F819D', '#85678F', '#5E8D87', '#707880',
      \ '#373B41', '#CC6666', '#B5BD68', '#F0C674',
      \ '#81A2BE', '#B294BB', '#8ABEB7', '#C5C8C6',
      \]
let s:TERM_COLORS = [
      \ 0, 1, 2, 3, 4, 5, 6, 7,
      \ 8, 9, 10, 11, 12, 13, 14, 15,
      \]

syntax match GinaBlameBase /.*/ display
syntax match GinaBlameSummary /^.*\ze\<on .\{-}/ containedin=GinaBlameBase

execute printf(
      \ 'syn match GinaBlameRev /\%%(%s\|%s\)[0-9A-F]\+$/ containedin=GinaBlameBase',
      \ g:gina#command#blame#formatter#current_mark,
      \ repeat(' ', len(g:gina#command#blame#formatter#current_mark))
      \)
execute printf(
      \ 'syn match GinaBlameIndicator /%s/ containedin=GinaBlameRev',
      \ g:gina#command#blame#formatter#current_mark,
      \)
syntax match GinaBlameRevColor0  /0/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor1  /1/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor2  /2/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor3  /3/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor4  /4/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor5  /5/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor6  /6/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor7  /7/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor8  /8/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor9  /9/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor10 /A/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor11 /B/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor12 /C/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor13 /D/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor14 /E/ contained containedin=GinaBlameRev
syntax match GinaBlameRevColor15 /F/ contained containedin=GinaBlameRev

function! s:define_highlights() abort
  highlight default link GinaBlameBase Comment
  highlight default link GinaBlameSummary Statement
  highlight default link GinaBlameIndicator ErrorMsg
  for i in range(16)
    execute printf(
          \ 'highlight default %s ctermfg=%d ctermbg=%d guifg=%s guibg=%s',
          \ 'GinaBlameRevColor' . i,
          \ s:TERM_COLORS[i], s:TERM_COLORS[i],
          \ s:GUI_COLORS[i], s:GUI_COLORS[i],
          \)
  endfor
endfunction

augroup gina_syntax_blame_internal
  autocmd! * <buffer>
  autocmd ColorScheme * call s:define_highlights()
augroup END

call s:define_highlights()
let b:current_syntax = 'gina-blame'
