"=============================================================================
" html.vim --- SpaceVim lang#html layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#html, layers-lang-html
" @parentsection layers
" This layer is for html development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [layers]
"     name = "lang#html"
" <
" 
" @subsection Options
"
" - `emmet_leader_key`: change the default leader key for emmet
" - `emmet_filetyps`: Set the filetypes for enabling emmet
" >
"   [layers]
"     name = "lang#html"
"     emmet_leader_key = "<C-e>"
"     emmet_filetyps = ['html']
" <
"
" @subsection Key bindings
"
" >
"     Key Binding       description
"     <C-e>             emmet leader key
" <
"

if exists('s:emmet_leader_key')
  finish

endif

let s:emmet_leader_key = '<C-e>'
let s:emmet_filetyps = ['']


function! SpaceVim#layers#lang#html#plugins() abort
  let plugins = [
        \ ['groenewege/vim-less',                    { 'on_ft' : ['less']}],
        \ ['cakebaker/scss-syntax.vim',              { 'on_ft' : ['scss','sass']}],
        \ ['hail2u/vim-css3-syntax',                 { 'on_ft' : ['css','scss','sass']}],
        \ ['ap/vim-css-color',                       { 'on_ft' : ['css','scss','sass','less','styl']}],
        \ ['othree/html5.vim',                       { 'on_ft' : ['html']}],
        \ ['wavded/vim-stylus',                      { 'on_ft' : ['stylus']}],
        \ ['mattn/emmet-vim',                        { 'on_cmd' : 'EmmetInstall'}],
        \ ] 
  return plugins
endfunction

function! SpaceVim#layers#lang#html#config() abort
  let g:user_emmet_leader_key = s:emmet_leader_key
  augroup spacevim_lang_html
    autocmd!
    exe printf('autocmd FileType %s call s:install_emmet()', join(s:emmet_filetyps, ','))
    autocmd Filetype html setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  augroup END
endfunction

function! SpaceVim#layers#lang#html#set_variable(var) abort
  let s:emmet_leader_key = get(a:var, 'emmet_leader_key', get(a:var, 'user_emmet_leader_key', s:emmet_leader_key))
  let s:emmet_filetyps = get(a:var, 'emmet_filetyps', s:emmet_filetyps)
endfunction


function! s:install_emmet() abort
  try
    EmmetInstall
  catch
    
  endtry
endfunction

function! SpaceVim#layers#lang#html#health() abort
  call SpaceVim#layers#lang#html#plugins()
  call SpaceVim#layers#lang#html#config()
  return 1
endfunction


function! SpaceVim#layers#lang#html#get_options() abort

  return ['emmet_filetyps',
        \ 'emmet_leader_key']

endfunction
