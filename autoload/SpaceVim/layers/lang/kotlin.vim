"=============================================================================
" kotlin.vim --- SpaceVim lang#kotlin layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#kotlin, layers-lang-kotlin
" @parentsection layers
" This layer is for kotlin development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#kotlin'
" <
" If you want to use lsp layer for kotlin, you need to install the
" kotlin_language_server.
"
" https://github.com/fwcd/kotlin-language-server
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for kotlin, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
" If the lsp layer is enabled for kotlin, the following key bindings can
" be used:
" >
"   key binding     Description
"   g D             jump to type definition
"   SPC l e         rename symbol
"   SPC l x         show references
"   SPC l h         show line diagnostics
"   SPC l d         show document
"   K               show document
"   SPC l w l       list workspace folder
"   SPC l w a       add workspace folder
"   SPC l w r       remove workspace folder
" <
"


" Load SpaceVim APIs:
let s:SYS = SpaceVim#api#import('system')

" Default Options:
if exists('s:enable_native_support')
  finish
else
  let s:enable_native_support = 0
endif


function! SpaceVim#layers#lang#kotlin#plugins() abort
  let plugins = []
  call add(plugins, ['udalov/kotlin-vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#kotlin#config() abort
  if g:spacevim_lint_engine ==# 'neomake'
    " neomake support:
    let g:neomake_kotlin_kotlinc_maker = {
          \ 'args': ['-cp', s:classpath(), '-d', s:outputdir()],
          \ 'errorformat':
          \ '%E%f:%l:%c: error: %m,' .
          \ '%W%f:%l:%c: warning: %m,' .
          \ '%Eerror: %m,' .
          \ '%Wwarning: %m,' .
          \ '%Iinfo: %m,'
          \ }
    let g:neomake_kotlin_ktlint_maker = {
          \ 'errorformat': '%E%f:%l:%c: %m',
          \ }
    let g:neomake_kotlin_enabled_makers = ['ktlint']
    let g:neomake_kotlin_kotlinc_remove_invalid_entries = 1
    let g:neomake_kotlin_ktlint_remove_invalid_entries = 1
  endif
  call SpaceVim#mapping#space#regesit_lang_mappings('kotlin', function('s:language_specified_mappings'))
  if s:enable_native_support
    let runner = {
          \ 'exe' : 'kotlinc-native'. (s:SYS.isWindows ? '.CMD' : ''),
          \ 'targetopt' : '-o',
          \ 'opt' : [],
          \ 'usestdin' : 0,
          \ }
    call SpaceVim#plugins#runner#reg_runner('kotlin', [runner, '#TEMP#'])
  else
    let runner = {
          \ 'exe' : 'kotlinc-jvm'. (s:SYS.isWindows ? '.CMD' : ''),
          \ 'opt' : ['-script'],
          \ 'usestdin' : 0,
          \ }
    call SpaceVim#plugins#runner#reg_runner('kotlin', runner)
  endif
  call SpaceVim#plugins#repl#reg('kotlin', ['kotlinc-jvm'. (s:SYS.isWindows ? '.CMD' : '')])
endfunction

function! s:language_specified_mappings() abort
  if SpaceVim#layers#lsp#check_filetype('kotlin')
        \ || SpaceVim#layers#lsp#check_server('kotlin_language_server')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call SpaceVim#lsp#go_to_typedef()<Cr>

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
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("kotlin")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction
func! s:classpath() abort

endf

func! s:outputdir() abort

endf

function! SpaceVim#layers#lang#kotlin#set_variable(var) abort
  let s:enable_native_support = get(a:var,
        \ 'enable-native-support',
        \ 'nil')
endfunction

function! SpaceVim#layers#lang#kotlin#health() abort
  call SpaceVim#layers#lang#kotlin#plugins()
  call SpaceVim#layers#lang#kotlin#config()
  return 1
endfunction
