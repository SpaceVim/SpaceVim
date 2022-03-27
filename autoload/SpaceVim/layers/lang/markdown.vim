"=============================================================================
" markdown.vim --- lang#markdown layer for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#markdown, layers-lang-markdown
" @parentsection layers
" This layer adds markdown support to SpaceVim. It is disabled by default,
" to enable this layer, add following snippet to your SpaceVim configuration
" file.
" >
"   [[layers]]
"     name = 'lang#markdown'
" <
" @subsection Layer options
"
" The following layer options are supported in this layer:
"
" 1. `enabled_formater`: Set the enabled formater, by default it is 
" `['remark']`. To use `prettier`, you need to install `prettier` via:
" >
"   npm install --global prettier
" <
" 2. `enableWcwidth`: Enable/disabled wcwidth option, it is disabled by
"    default.
" 3. `listItemChar`: Set the default list item char, it is `-` by default.
" 4. `listItemIndent`: Set the default indent of list item. It is `1` by
"    default.
" Here is an example for loading `lang#markdown` layer:
" >
"   [[layers]]
"       name = 'lang#markdown'
"       enableWcwidth = 1
"       listItemIndent = 1
"       enabled_formater = ['prettier']
" <
" @subsection key bindings
"
" This layer brings following key bindings to markdown file:
" >
"   Key binding         Description
"   Ctrl-b              insert code block
"   SPC l r             run code in code block
" <

if exists('s:md_listItemIndent')
  finish
endif

let s:SYS = SpaceVim#api#import('system')


let s:md_listItemIndent = 1
let s:md_enableWcwidth = 0
let s:md_listItemChar = '-'
let g:vmt_list_indent_text = '  '
let s:md_enabled_formater = ['remark']
function! SpaceVim#layers#lang#markdown#set_variable(var) abort
  let s:md_listItemIndent = get(a:var, 'listItemIndent', s:md_listItemIndent)
  let s:md_enableWcwidth = get(a:var, 'enableWcwidth', s:md_enableWcwidth)
  let s:md_listItemChar = get(a:var, 'listItemChar', s:md_listItemChar)
  let s:md_enabled_formater = get(a:var, 'enabled_formater', s:md_enabled_formater)
endfunction

function! SpaceVim#layers#lang#markdown#plugins() abort
  let plugins = []
  call add(plugins, ['SpaceVim/vim-markdown',{ 'on_ft' : 'markdown'}])
  call add(plugins, ['joker1007/vim-markdown-quote-syntax',{ 'on_ft' : 'markdown'}])
  call add(plugins, ['mzlogin/vim-markdown-toc',{ 'on_ft' : 'markdown'}])
  call add(plugins, ['iamcco/mathjax-support-for-mkdp',{ 'on_ft' : 'markdown'}])
  call add(plugins, ['lvht/tagbar-markdown',{'merged' : 0}])
  " check node package managers to ensure building of 2 plugins below
  if executable('yarn')
    let s:node_pkgm = 'yarn'
  elseif executable('npm')
    let s:node_pkgm = 'npm'
  else
    let s:node_pkgm = ''
    call SpaceVim#logger#error('npm or yarn is required to build iamcco/markdown-preview and neoclide/vim-node-rpc')
  endif
  call add(plugins, ['iamcco/markdown-preview.nvim',
        \ { 'on_cmd' : 'MarkdownPreview',
        \ 'depends': 'open-browser.vim',
        \ 'build' : 'cd app & ' . s:node_pkgm . ' install --force' }])
  if !has('nvim')
    call add(plugins, ['neoclide/vim-node-rpc',  {'merged': 0, 'build' : s:node_pkgm . ' install'}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#lang#markdown#config() abort
  " do not highlight markdown error
  let g:markdown_hi_error = 0
  " the fenced languages based on loaded language layer
  let g:markdown_fenced_languages = []
  let g:markdown_nested_languages = map(filter(SpaceVim#layers#get(),
        \ 'v:val =~# "^lang#" && v:val !=# "lang#markdown" && v:val !=# "lang#ipynb" && v:val !=# "lang#vim"'), 'v:val[5:]')
  if index(g:markdown_nested_languages, 'latex') !=# -1
    call remove(g:markdown_nested_languages, index(g:markdown_nested_languages, 'latex'))
    call add(g:markdown_nested_languages, 'tex')
  endif
  let g:vmt_list_item_char = s:md_listItemChar
  let g:markdown_minlines = 100
  let g:markdown_syntax_conceal = 0
  let g:markdown_enable_mappings = 0
  let g:markdown_enable_insert_mode_leader_mappings = 0
  let g:markdown_enable_spell_checking = 0
  let g:markdown_quote_syntax_filetypes = {
        \ 'vim' : {
        \   'start' : "\\%(vim\\|viml\\)",
        \},
        \}
  let remarkrc = s:generate_remarkrc()
  let g:neoformat_enabled_markdown = s:md_enabled_formater
  let g:neoformat_markdown_remark = {
        \ 'exe': 'remark',
        \ 'args': ['--no-color', '--silent'] + (empty(remarkrc) ?  [] : ['-r', remarkrc]),
        \ 'stdin': 1,
        \ }

  " iamcco/markdown-preview.vim {{{
  " let g:mkdp_browserfunc = 'openbrowser#open'
  " }}}
  call SpaceVim#mapping#space#regesit_lang_mappings('markdown', function('s:mappings'))
  nnoremap <silent> <plug>(markdown-insert-link) :call <SID>markdown_insert_link(0, 0)<Cr>
  xnoremap <silent> <plug>(markdown-insert-link) :<C-u> call <SID>markdown_insert_link(1, 0)<Cr>
  nnoremap <silent> <plug>(markdown-insert-picture) :call <SID>markdown_insert_link(0, 1)<Cr>
  xnoremap <silent> <plug>(markdown-insert-picture) :<C-u> call <SID>markdown_insert_link(1, 1)<Cr>
  augroup spacevim_layer_lang_markdown
    autocmd!
    autocmd FileType markdown setlocal omnifunc=htmlcomplete#CompleteTags
  augroup END
endfunction

function! s:mappings() abort
  if !exists('g:_spacevim_mappings_space')
    let g:_spacevim_mappings_space = {}
  endif
  let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','p'], 'MarkdownPreview', 'Real-time markdown preview', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','k'], '<plug>(markdown-insert-link)', 'add link url', 0, 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','K'], '<plug>(markdown-insert-picture)', 'add link picture', 0, 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 
        \ 'call call('
        \ . string(function('s:run_code_in_block'))
        \ . ', [])', 'run code in block', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c'], 'GenTocGFM', 'create content at cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','C'], 'RemoveToc', 'remove content', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','u'], 'UpdateToc', 'update content', 1)
endfunction

function! s:generate_remarkrc() abort
  let conf = [
        \ 'module.exports = {',
        \ '  settings: {',
        \ ]
  " TODO add settings
  call add(conf, "    listItemIndent: '" . s:md_listItemIndent . "',")
  if s:md_enableWcwidth
    call add(conf, "    stringLength: require('wcwidth'),")
  endif
  call add(conf, '  },')
  call add(conf, '  plugins: [')
  " TODO add plugins
  call add(conf, "    require('remark-frontmatter'),")
  call add(conf, '  ]')
  call add(conf, '};')
  let f  = tempname() . '.js'
  call writefile(conf, f)
  return f
endfunction

function! s:markdown_insert_link(isVisual, isPicture) abort
  if !empty(@+)
    let l:save_register_unnamed = @"
    let l:save_edge_left = getpos("'<")
    let l:save_edge_right = getpos("'>")
    if !a:isVisual
      execute "normal! viw\<esc>"
    endif
    let l:paste = (col("'>") == col('$') - 1 ? 'p' : 'P')
    normal! gvx
    let @" = '[' . @" . '](' . @+ . ')'
    if a:isPicture
      let @" = '!' . @"
    endif
    execute 'normal! ' . l:paste
    let @" = l:save_register_unnamed
    if a:isVisual
      let l:save_edge_left[2] += 1
      if l:save_edge_left[1] == l:save_edge_right[1]
        let l:save_edge_right[2] += 1
      endif
    endif
    call setpos("'<", l:save_edge_left)
    call setpos("'>", l:save_edge_right)
  endif
endfunction

" this function need context_filetype.vim
function! s:run_code_in_block() abort
  let cf = context_filetype#get()
  if cf.filetype !=# 'markdown'
    let runner = SpaceVim#plugins#runner#get(cf.filetype)
    if type(runner) ==# 4
      let runner['usestdin'] = 1
      let runner['range'] = [cf['range'][0][0], cf['range'][1][0]]
      call SpaceVim#plugins#runner#open(runner)
    elseif type(runner) ==# 3 && type(runner[0]) == 4
      let runner[0]['usestdin'] = 1
      let runner[0]['range'] = [cf['range'][0][0], cf['range'][1][0]]
      call SpaceVim#plugins#runner#open(runner)
    endif
  endif
endfunction


function! SpaceVim#layers#lang#markdown#health() abort
  call SpaceVim#layers#lang#markdown#plugins()
  call SpaceVim#layers#lang#markdown#config()
  return 1
endfunction
