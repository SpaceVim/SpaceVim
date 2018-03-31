"=============================================================================
" markdown.vim --- lang#markdown layer for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:md_listItemIndent = 1
let s:md_enableWcwidth = 0
let s:md_listItemChar = '-'
let g:vmt_list_indent_text = '  '
function! SpaceVim#layers#lang#markdown#set_variable(var) abort
  let s:md_listItemIndent = get(a:var, 'listItemIndent', s:md_listItemIndent)
  let s:md_enableWcwidth = get(a:var, 'enableWcwidth', s:md_enableWcwidth)
  let s:md_listItemChar = get(a:var, 'listItemChar', s:md_listItemChar)
endfunction

function! SpaceVim#layers#lang#markdown#plugins() abort
  let plugins = []
  call add(plugins, ['SpaceVim/vim-markdown',{ 'on_ft' : 'markdown'}])
  call add(plugins, ['joker1007/vim-markdown-quote-syntax',{ 'on_ft' : 'markdown'}])
  call add(plugins, ['mzlogin/vim-markdown-toc',{ 'on_ft' : 'markdown'}])
  call add(plugins, ['iamcco/mathjax-support-for-mkdp',{ 'on_ft' : 'markdown'}])
  call add(plugins, ['iamcco/markdown-preview.vim', { 'depends' : 'open-browser.vim', 'on_ft' : 'markdown' }])
  return plugins
endfunction

function! SpaceVim#layers#lang#markdown#config() abort
  let g:vmt_list_item_char = s:md_listItemChar
  let g:markdown_minlines = 100
  let g:markdown_syntax_conceal = 0
  let g:markdown_enable_mappings = 0
  let g:markdown_enable_insert_mode_leader_mappings = 0
  let g:markdown_enable_spell_checking = 0
  let g:markdown_quote_syntax_filetypes = {
        \ "vim" : {
        \   "start" : "\\%(vim\\|viml\\)",
        \},
        \}
  let remarkrc = s:generate_remarkrc()
  let g:neoformat_enabled_markdown = ['remark']
  let g:neoformat_markdown_remark = {
        \ 'exe': 'remark',
        \ 'args': ['--no-color', '--silent'] + (empty(remarkrc) ?  [] : ['-r', remarkrc]),
        \ 'stdin': 1,
        \ }

  " iamcco/markdown-preview.vim {{{
  let g:mkdp_browserfunc = 'openbrowser#open'
  " }}}
  call SpaceVim#mapping#space#regesit_lang_mappings('markdown', function('s:mappings'))
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
  call SpaceVim#mapping#space#langSPC('nmap', ['l','ft'], "Tabularize /|", 'Format table under cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','p'], "MarkdownPreview", 'Real-time markdown preview', 1)
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


