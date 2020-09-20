"=============================================================================
" FILE: neoinclude.vim (NCM source)
" AUTHOR:  Jia Sui <jsfaint@gmail.com>
" License: MIT license
" ============================================================================

function! cm#sources#neoinclude#refresh(opt, ctx) abort
  let typed = a:ctx['typed']

  let startcol =  neoinclude#file_include#get_complete_position(typed)

  if startcol == -1
    return
  endif

  let inc = neoinclude#file_include#get_include_files(typed)

  let matches = map(inc, "{'word': v:val['word'], 'dup': 1, 'icase': 1, 'menu': 'FI: ' . v:val['kind']}")

  call cm#complete(a:opt.name, a:ctx, startcol + 1, matches)
endfunction
