"=============================================================================
" FILE: autoload/incsearch/config.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:TRUE = !0
let s:FALSE = 0
lockvar s:TRUE s:FALSE

let s:U = incsearch#util#import()

"" incsearch config
" TODO: more detail documentation
" @command is equivalent with base_key TODO: fix this inconsistence
" @count default: v:count secret
" @mode default: mode(1) secret
let s:config = {
\   'command': '/',
\   'is_stay': s:FALSE,
\   'is_expr': s:FALSE,
\   'pattern': '',
\   'mode': 'n',
\   'count': 0,
\   'prompt': '',
\   'modules': [],
\   'converters': [],
\   'keymap': {}
\ }

" @return config for lazy value
function! s:lazy_config() abort
  let m = mode(1)
  return {
  \   'count': v:count,
  \   'mode': m,
  \   'is_expr': (m is# 'no'),
  \   'keymap': s:keymap()
  \ }
endfunction

" @return config with default value
function! incsearch#config#make(additional) abort
  let default = extend(deepcopy(s:config), s:lazy_config())
  let c = s:U.deepextend(default, a:additional)
  if c.prompt is# ''
    let c.prompt = c.command
  endif
  return c
endfunction

let s:default_keymappings = {
\   "\<Tab>"   : {
\       'key' : '<Over>(incsearch-next)',
\       'noremap' : 1,
\   },
\   "\<S-Tab>"   : {
\       'key' : '<Over>(incsearch-prev)',
\       'noremap' : 1,
\   },
\   "\<C-j>"   : {
\       'key' : '<Over>(incsearch-scroll-f)',
\       'noremap' : 1,
\   },
\   "\<C-k>"   : {
\       'key' : '<Over>(incsearch-scroll-b)',
\       'noremap' : 1,
\   },
\   "\<C-l>"   : {
\       'key' : '<Over>(buffer-complete)',
\       'noremap' : 1,
\   },
\   "\<CR>"   : {
\       'key': "\<CR>",
\       'noremap': 1
\   },
\ }

" https://github.com/haya14busa/incsearch.vim/issues/35
if has('mac')
  call extend(s:default_keymappings, {
  \   '"+gP'   : {
  \       'key': "\<C-r>+",
  \       'noremap': 1
  \   },
  \ })
endif

function! s:keymap() abort
  return extend(copy(s:default_keymappings), g:incsearch_cli_key_mappings)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
