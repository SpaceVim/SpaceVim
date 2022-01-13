" $Id: test-command.vim 156 2010-05-07 00:54:36Z luc.hermitte $
" Tests for lh-vim-lib . lh#command

" FindFilter(filter):                            Helper {{{3
function! s:FindFilter(filter)
  let filter = a:filter . '.vim'
  let result =globpath(&rtp, "compiler/BTW-".filter) . "\n" .
	\ globpath(&rtp, "compiler/BTW_".filter). "\n" .
	\ globpath(&rtp, "compiler/BTW/".filter)
  let result = substitute(result, '\n\n', '\n', 'g')
  let result = substitute(result, '^\n', '', 'g')
  return result
endfunction

function! s:ComplFilter(filter)
  let files = s:FindFilter('*')
  let files = substitute(files,
	\ '\(^\|\n\).\{-}compiler[\\/]BTW[-_\\/]\(.\{-}\)\.vim\>\ze\%(\n\|$\)',
	\ '\1\2', 'g')
  return files
endfunction

function! s:Add()
endfunction

let s:v1 = 'v1'
let s:v2 = 2

function! s:Foo(i)
  return a:i*a:i
endfunction

function! s:echo(params)
  echo s:{join(a:params, '')}
endfunction

function! Echo(params)
  " echo "Echo(".string(a:params).')'
  let expr = 's:'.join(a:params, '')
  " echo expr
  exe 'echo '.expr
endfunction

let TBTWcommand = {
      \ "name"      : "TBT",
      \ "arg_type"  : "sub_commands",
      \ "arguments" :
      \     [
      \       { "name"      : "echo",
      \		"arg_type"  : "function",
      \         "arguments" : "v1,v2",
      \         "action": function("\<sid>echo") },
      \       { "name"      : "Echo",
      \		"arg_type"  : "function",
      \         "arguments" : "v1,v2",
      \         "action": function("Echo") },
      \       { "name"  : "help" },
      \       { "name"  : "add",
      \         "arguments": function("s:ComplFilter"),
      \         "action" : function("s:Add") }
      \     ]
      \ }

call lh#command#new(TBTWcommand)

nnoremap µ :call lh#command#new(TBTWcommand)<cr>

"=============================================================================
" vim600: set fdm=marker:
