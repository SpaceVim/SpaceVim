"=============================================================================
" markdown.vim --- lang#markdown layer for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:SYS = SpaceVim#api#import('system')


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
  call add(plugins, ['lvht/tagbar-markdown',{'merged' : 0}])
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
        \ 'vim' : {
        \   'start' : "\\%(vim\\|viml\\)",
        \},
        \}
  let remarkrc = s:generate_remarkrc()
  if s:SYS.isWindows
    let g:neoformat_enabled_markdown = ['prettier']
  else
    let g:neoformat_enabled_markdown = ['remark']
  endif
  let g:neoformat_markdown_remark = {
        \ 'exe': 'remark',
        \ 'args': ['--no-color', '--silent'] + (empty(remarkrc) ?  [] : ['-r', remarkrc]),
        \ 'stdin': 1,
        \ }

  " iamcco/markdown-preview.vim {{{
  let g:mkdp_browserfunc = 'openbrowser#open'
  " }}}
  call SpaceVim#mapping#space#regesit_lang_mappings('markdown', function('s:mappings'))
  nnoremap <silent> <plug>(markdown-insert-link) :call <SID>markdown_insert_url()<Cr>
  xnoremap <silent> <plug>(markdown-insert-link) :call <SID>markdown_insert_url()<Cr>
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
  call SpaceVim#mapping#space#langSPC('nmap', ['l','ft'], 'Tabularize /|', 'Format table under cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','p'], 'MarkdownPreview', 'Real-time markdown preview', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','k'], '<plug>(markdown-insert-link)', 'add link url', 0, 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 
        \ 'call call('
        \ . string(function('s:run_code_in_block'))
        \ . ', [])', 'run code in block', 1)
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

function! s:markdown_insert_url() abort
  let pos1 = getpos("'<")
  let pos2 = getpos("'>")
  let scope = sort([pos1[2], pos2[2]], 'n')
  "FIXME: list scope is not same as string scope index.
  let url = @+
  if !empty(url)
    let line = getline(pos1[1])
    let splits = [line[:scope[0]], line[scope[0] : scope[1]], line[scope[1]:]]
    let result = splits[0] . '[' . splits[1] . '](' . url . ')' . splits[2]
    call setline(pos1[1], result)
  endif
  keepjumps call cursor(pos1[1], scope[0])
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

