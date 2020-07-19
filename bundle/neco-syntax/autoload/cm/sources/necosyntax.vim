"=============================================================================
" FILE: necosyntax.vim (NCM source)
" AUTHOR:  Jia Sui <jsfaint@gmail.com>
" License: MIT license
"=============================================================================

let s:initialized = 0

function! cm#sources#necosyntax#refresh(opt, ctx)
  if !s:initialized
    call necosyntax#initialize()
    let s:initialized = 1
  endif

  let col = a:ctx['col']
  let typed = a:ctx['typed']

  let kw = matchstr(typed, '\w\+$')
  let kwlen = len(kw)

  let matches = necosyntax#gather_candidates()
  let startcol = col - kwlen

  call cm#complete(a:opt.name, a:ctx, startcol, matches)
endfunction
