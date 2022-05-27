"=============================================================================
" vim.vim --- SpaceVim vim layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#vim, layers-lang-vim
" @parentsection layers
" This layer is for vim script development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#vim'
" <
"
" The `checkers` layer provides syntax linter for vim. you need to install the
" `vint` command:
" >
"   pip install vim-vint
" <
"
" @subsection key bindings
"
" The following key bindings will be added when this layer is loaded:
" >
"   key binding     Description
"   SPC l e         eval cursor expr
"   SPC l v         run HelpfulVersion cword
"   SPC l f         open exception trace
"   g d             jump to definition
" <
"
" If the lsp layer is enabled for vim script, the following key bindings can
" be used:
" >
"   key binding     Description
"   SPC l e         rename symbol
"   SPC l x         show references
"   SPC l h         show line diagnostics
"   SPC l d         show document
"   K               show document
"   SPC l w l       list workspace folder
"   SPC l w a       add workspace folder
"   SPC l w r       remove workspace folder
" <

if exists('s:auto_generate_doc')
  finish
endif


let s:auto_generate_doc = 0

" Load SpaceVim API

let s:SID = SpaceVim#api#import('vim#sid')
let s:JOB = SpaceVim#api#import('job')
let s:SYS = SpaceVim#api#import('system')
let s:FILE = SpaceVim#api#import('file')
let s:NOTI = SpaceVim#api#import('notify')

function! SpaceVim#layers#lang#vim#plugins() abort
  let plugins = [
        \ ['syngan/vim-vimlint',                     { 'on_ft' : 'vim'}],
        \ ['ynkdir/vim-vimlparser',                  { 'on_ft' : 'vim'}],
        \ ['todesking/vint-syntastic',               { 'on_ft' : 'vim'}],
        \ ]
  call add(plugins,['tweekmonster/exception.vim', {'merged' : 0}])
  call add(plugins,[g:_spacevim_root_dir . 'bundle/vim-lookup', {'merged' : 0}])
  if !SpaceVim#layers#lsp#check_server('vimls') && !SpaceVim#layers#lsp#check_filetype('vim')
    call add(plugins,['Shougo/neco-vim',              { 'on_event' : 'InsertEnter', 'loadconf_before' : 1}])
    if g:spacevim_autocomplete_method ==# 'asyncomplete'
      call add(plugins, ['prabirshrestha/asyncomplete-necovim.vim', {
            \ 'loadconf' : 1,
            \ 'merged' : 0,
            \ }])
    elseif g:spacevim_autocomplete_method ==# 'coc'
      call add(plugins, ['neoclide/coc-neco', {'merged' : 0}])
    elseif g:spacevim_autocomplete_method ==# 'completor'
      " call add(plugins, ['kyouryuukunn/completor-necovim', {'merged' : 0}])
      " This plugin has bug in neovim-qt win 7
      " https://github.com/maralla/completor.vim/issues/250
    endif
  endif
  call add(plugins, [g:_spacevim_root_dir . 'bundle/helpful.vim', {'merged' : 0, 'on_cmd' : 'HelpfulVersion'}])
  return plugins
endfunction

function! SpaceVim#layers#lang#vim#config() abort
  let g:scriptease_iskeyword = 0
  call SpaceVim#mapping#gd#add('vim','lookup#lookup')
  call SpaceVim#mapping#space#regesit_lang_mappings('vim', function('s:language_specified_mappings'))
  call SpaceVim#plugins#highlight#reg_expr('vim', '\s*\<fu\%[nction]\>!\?\s*', '\s*\<endf\%[unction]\>\s*')
  if s:auto_generate_doc
    augroup spacevim_layer_lang_vim
      autocmd!
      autocmd BufWritePost *.vim call s:generate_doc()
      autocmd FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",:\"
      autocmd QuitPre * call s:NOTI.close_all()
    augroup END
  endif
  " if the lsp layer is enabled, we should disable default linter
  if SpaceVim#layers#lsp#check_server('vimls') || SpaceVim#layers#lsp#check_filetype('vim')
    let g:neomake_vim_enabled_makers = []
  endif
endfunction

function! s:on_exit(...) abort
  let data = get(a:000, 1)
  if data != 0
    call s:NOTI.notify('failed to generate doc!', 'WarningMsg')
  else
    call s:NOTI.notify('vim doc generated!', 'Normal')
  endif
endfunction

function! s:generate_doc() abort
  " neovim in windows executable function is broken
  " https://github.com/neovim/neovim/issues/9391
  let fd = expand('%:p')
  let addon_info = s:FILE.findfile('addon-info.json', fd)
  if !empty(addon_info)
    let dir = s:FILE.unify_path(addon_info, ':h')
    if executable('vimdoc') && !s:SYS.isWindows
      call s:JOB.start(['vimdoc', dir], 
            \ {
              \ 'on_exit' : function('s:on_exit'),
              \ }
              \ )
    elseif executable('python')
      call s:JOB.start(['python', '-m', 'vimdoc', dir], 
            \ {
              \ 'on_exit' : function('s:on_exit'),
              \ }
              \ )
    endif
  endif
endfunction

function! SpaceVim#layers#lang#vim#set_variable(var) abort

  let s:auto_generate_doc = get(a:var, 'auto_generate_doc', s:auto_generate_doc)

endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'],  'call call('
        \ . string(function('s:eval_cursor')) . ', [])',
        \ 'echo eval under cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],  'call call('
        \ . string(function('s:helpversion_cursor')) . ', [])',
        \ 'echo helpversion under cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','f'], 'call exception#trace()', 'tracing exceptions', 1)
  if SpaceVim#layers#lsp#check_server('vimls') || SpaceVim#layers#lsp#check_filetype('vim')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call SpaceVim#lsp#references()', 'show-references', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename-symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'h'],
          \ 'call SpaceVim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
          \ 'call SpaceVim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
          \ 'call SpaceVim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
          \ 'call SpaceVim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)
  endif

endfunction

function! s:eval_cursor() abort
  let is_keyword = &iskeyword
  set iskeyword+=:
  let cword = expand('<cword>')
  if exists(cword)
    echo  cword . ' is ' eval(cword)
    " if is script function
  elseif cword =~# '^s:' && cword =~# '('
    let sid = s:SID.get_sid_from_path(expand('%'))
    if sid >= 1
      let func = '<SNR>' . sid . '_' . split(cword, '(')[0][2:] . '()'
      try
        echon 'Calling func:' . func . ', result is:' . eval(func)
      catch
        echohl WarningMsg
        echo 'failed to call func: ' . func
        echohl None
      endtry
    else
      echohl WarningMsg
      echo 'can not find SID for current script'
      echohl None
    endif
  else
    echohl WarningMsg
    echon 'can not eval script val:'
    echohl None
    echon cword
  endif
  let &iskeyword = is_keyword
endfunction

function! s:helpversion_cursor() abort
  exe 'HelpfulVersion' expand('<cword>')
endfunction

function! SpaceVim#layers#lang#vim#health() abort
  call SpaceVim#layers#lang#vim#plugins()
  call SpaceVim#layers#lang#vim#config()
  return 1
endfunction
