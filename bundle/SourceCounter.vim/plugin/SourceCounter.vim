
""
" @section Introduction, intro
" Sources counter for vim and neovim.
"
" USAGE:
" >
"   :SourceCounter! vim md java html
" <

let s:save_cpo = &cpoptions
set cpoptions&vim

""
" List lines count for specific [filetypes], or all supported filetypes.
"
" [!] forces desplay result in new tab.
command! -bang -nargs=* SourceCounter call SourceCounter#View('!' ==# '<bang>', <f-args>)

if !exists('g:source_counter_sort')
    ""
    " specific the sort type of result, 'lines'  or 'files', default is
    " 'files'.
    let g:source_counter_sort = 'files'
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo
