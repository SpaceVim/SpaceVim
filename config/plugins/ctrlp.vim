"=============================================================================
" ctrlp.vim --- ctrlp config
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:SYS = SpaceVim#api#import('system')

let g:ctrlp_map = get(g:,'ctrlp_map', '<c-p>')
let g:ctrlp_cmd = get(g:, 'ctrlp_cmd', 'CtrlP')
let g:ctrlp_working_path_mode = get(g:, 'ctrlp_working_path_mode', 'ra')
let g:ctrlp_root_markers = get(g:, 'ctrlp_root_markers', ['pom.xml'])
let g:ctrlp_match_window = get(g:, 'ctrlp_match_window', 'bottom,order:btt,min:1,max:15,results:15')
let g:ctrlp_show_hidden = get(g:, 'ctrlp_show_hidden', 1)
"for caching
let g:ctrlp_use_caching = get(g:, 'ctrlp_use_caching', 500)
let g:ctrlp_clear_cache_on_exit = get(g:, 'ctrlp_clear_cache_on_exit', 1)
let g:ctrlp_cache_dir = get(g:, 'ctrlp_cache_dir', g:spacevim_data_dir.'/ctrlp')
"let g:ctrlp_map = ',,'
"let g:ctrlp_open_multiple_files = 'v'
"if you have install ag, the g:ctrlp_custom_ignore will not work
let g:ctrlp_custom_ignore = get(g:, 'ctrlp_custom_ignore', {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$|target|node_modules|te?mp$|logs?$|public$|dist$',
      \ 'file': '\v\.(exe|so|dll|ttf|png|gif|jpe?g|bpm)$|\-rplugin\~',
      \ 'link': 'some_bad_symbolic_links',
      \ })
if executable('rg') && !exists('g:ctrlp_user_command')
  let g:ctrlp_user_command = 'rg %s --hidden --files -g "" '
        \ . join(SpaceVim#util#Generate_ignore(get(g:, 'spacevim_wildignore', ''),'rg', SpaceVim#api#import('system').isWindows ? 0 : 1))
elseif executable('ag') && !exists('g:ctrlp_user_command')
  let g:ctrlp_user_command = 'ag --hidden -i  -g "" ' . join(SpaceVim#util#Generate_ignore(g:spacevim_wildignore,'ag')) . ' %s'
elseif s:SYS.isWindows
  let g:ctrlp_user_command =
    \ 'dir %s /-n /b /s /a-d | findstr /v /l ".jpg \\tmp\\"' " Windows
else
  let g:ctrlp_user_command =
    \ 'find %s -type f | grep -v -P "\.jpg$|/tmp/"'          " MacOSX/Linux
endif
if !exists('g:ctrlp_match_func') && (has('python') || has('python3'))
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch'  }
endif

let g:ctrlp_funky_syntax_highlight = get(g:, 'ctrlp_funky_syntax_highlight', 1)
" }}}
"for ctrlp_nerdtree {{{
let g:ctrlp_nerdtree_show_hidden = get(g:, 'ctrlp_nerdtree_show_hidden', 1)
"}}}
"for ctrlp_sessions{{{
let g:ctrlp_extensions = ['funky', 'sessions' , 'k' , 'tag', 'mixed', 'quickfix', 'undo', 'line', 'changes', 'cmdline', 'menu']
"}}}

""for ctrlp-cmatcher {{{
"let g:ctrlp_max_files = 0
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
""}}}

augroup Fix_command_in_help_buffer
  au!
  autocmd FileType help exec 'nnoremap <buffer><silent><c-p> :<c-u>CtrlP ' . getcwd() .'<cr>'
augroup END

" vim:set et sw=2:
