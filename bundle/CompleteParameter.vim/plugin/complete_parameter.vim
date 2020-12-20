"==============================================================
"    file: complete_parameter.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-06-07 20:27:49
"==============================================================

if (!has('nvim')&&version < 704) || 
      \(!has('nvim')&&version==704&&!has('patch774')) || 
      \&compatible || 
      \exists('g:complete_parameter_version') 
  finish
endif
let g:complete_parameter_version = "0.8.2"
lockvar g:complete_parameter_version

let save_cpo = &cpo
set cpo&vim

call cmp#init()

nnoremap <silent> <Plug>(complete_parameter#goto_next_parameter) <ESC>:call cmp#goto_next_param(1)<cr>
snoremap <silent> <Plug>(complete_parameter#goto_next_parameter) <ESC>:call cmp#goto_next_param(1)<cr>
inoremap <silent> <Plug>(complete_parameter#goto_next_parameter) <ESC>:call cmp#goto_next_param(1)<cr>

nnoremap <silent> <Plug>(complete_parameter#goto_previous_parameter) <ESC>:call cmp#goto_next_param(0)<cr>
snoremap <silent> <Plug>(complete_parameter#goto_previous_parameter) <ESC>:call cmp#goto_next_param(0)<cr>
inoremap <silent> <Plug>(complete_parameter#goto_previous_parameter) <ESC>:call cmp#goto_next_param(0)<cr>

nnoremap <silent> <Plug>(complete_parameter#overload_down) <ESC>:call cmp#overload_next(1)<cr>
snoremap <silent> <Plug>(complete_parameter#overload_down) <ESC>:call cmp#overload_next(1)<cr>
inoremap <silent> <Plug>(complete_parameter#overload_down) <ESC>:call cmp#overload_next(1)<cr>

nnoremap <silent> <Plug>(complete_parameter#overload_up) <ESC>:call cmp#overload_next(0)<cr>
snoremap <silent> <Plug>(complete_parameter#overload_up) <ESC>:call cmp#overload_next(0)<cr>
inoremap <silent> <Plug>(complete_parameter#overload_up) <ESC>:call cmp#overload_next(0)<cr>

let &cpo = save_cpo
