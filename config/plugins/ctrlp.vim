let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = 'pom.xml'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:15'
let g:ctrlp_show_hidden = 1
"for caching
let g:ctrlp_use_caching = 500
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
"let g:ctrlp_map = ',,'
"let g:ctrlp_open_multiple_files = 'v'
"if you have install ag, the g:ctrlp_custom_ignore will not work
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$|target',
      \ 'file': '\v\.(exe|so|dll|ttf|png)$|\-rplugin\~',
      \ 'link': 'some_bad_symbolic_links',
      \ }
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --no-ignore --hidden --files -g "" '
        \ . join(zvim#util#Generate_ignore(g:spacevim_wildignore,'rg'))
elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s --hidden -i  -g "" ' . join(zvim#util#Generate_ignore(g:spacevim_wildignore,'ag'))
endif
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch'  }
"nnoremap <Leader>kk :CtrlPMixed<Cr>
" comment for ctrlp-funky {{{
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
let g:ctrlp_funky_syntax_highlight = 1
" }}}
"for ctrlp_nerdtree {{{
let g:ctrlp_nerdtree_show_hidden = 1
"}}}
"for ctrlp_sessions{{{
let g:ctrlp_extensions = ['funky', 'sessions' , 'k' , 'tag', 'mixed', 'quickfix', 'undo', 'line', 'changes', 'cmdline', 'menu']
"}}}
"for k.vim {{{
nnoremap <silent> <leader>qe :CtrlPK<CR>
"}}}
" for ctrlp-launcher {{{
nnoremap <Leader>pl :<c-u>CtrlPLauncher<cr>
"}}}
""for ctrlp-cmatcher {{{
"let g:ctrlp_max_files = 0
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
""}}}

augroup Fix_command_in_help_buffer
  au!
  autocmd FileType help exec 'nnoremap <buffer><silent><c-p> :<c-u>CtrlP ' . getcwd() .'<cr>'
  au FileType help exec "nnoremap <silent><buffer> q :q<CR>"
augroup END

" vim:set et sw=2:
