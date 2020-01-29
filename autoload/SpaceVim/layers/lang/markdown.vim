"=============================================================================
" markdown.vim --- lang#markdown layer for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
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
  call add(plugins, ['lvht/tagbar-markdown',{'merged' : 0}])
  " check node package managers to ensure building of 2 plugins below
  if executable('npm')
    let s:node_pkgm = 'npm'
  elseif executable('yarn')
    let s:node_pkgm = 'yarn'
  else
    let s:node_pkgm = ''
    call SpaceVim#logger#error('npm or yarn is required to build iamcco/markdown-preview and neoclide/vim-node-rpc')
  endif
  call add(plugins, ['iamcco/markdown-preview.nvim',
        \ { 'on_ft' : 'markdown',
        \ 'depends': 'open-browser.vim',
        \ 'build' : 'cd app & ' . s:node_pkgm . ' install' }])
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
    " @fixme prettier do not support kramdown
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

