" Usage: Unite locationlist	"unite location list
" Usage: Unite locationlist:enc=utf-8 "iconv(getloclist(),enc,&enc)

let s:save_cpo = &cpoptions
set cpoptions&vim

function! unite#sources#locationlist#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name': 'locationlist',
      \ 'description': 'candidates from location list'
      \ }

function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort
  let arglead = matchstr(a:arglead, '[:^]\zs.\+$')
  let options=['enc=']
  return filter(options, 'stridx(v:val, arglead)>=0')
endfunction

function! s:source.gather_candidates(args, context)
  let l:enc = ''
  for l:arg in a:args
    " 		let l:match = matchlist(l:arg, '\(\k\+\)\s*=\s*\([a-zA-Z0-9.!?_ /\\-*]*\)')
    let l:match = matchlist(l:arg, '\(\k\+\)\s*=\s*\(.*\)')
    if len(l:match) > 0
      execute 'let l:' . l:match[1] . " = \'" . l:match[2] . "\'"
    endif
  endfor
  return map(getloclist(0), '{
        \ "word": bufname(v:val.bufnr) . "|" . v:val.lnum . "| " .
        \	(empty(l:enc) ? v:val.text : iconv(v:val.text,l:enc,&encoding)),
        \ "source": "locationlist",
        \ "kind": "jump_list",
        \ "action__path": bufname(v:val.bufnr),
        \ "action__line": v:val.lnum,
        \ "action__pattern": v:val.pattern,
        \ "is_multiline" : 1,
        \ }')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:
