function! SpaceVim#layers#lang#javascript#plugins() abort
  let plugins = [
     \ ['MaxMEllon/vim-jsx-pretty', { 'on_ft': 'javascript' }],
     \ ['Galooshi/vim-import-js', {
     \ 'on_ft': 'javascript', 'build' : 'npm install -g import-js' }],
     \ ['maksimr/vim-jsbeautify', { 'on_ft': 'javascript' }],
     \ ['mmalecki/vim-node.js', { 'on_ft': 'javascript' }],
     \ ['moll/vim-node', { 'on_ft': 'javascript' }],
     \ ['othree/es.next.syntax.vim', { 'on_ft': 'javascript' }],
     \ ['othree/javascript-libraries-syntax.vim', {
     \ 'on_ft': ['javascript', 'coffee', 'ls', 'typescript'] }],
     \ ['othree/yajs.vim', { 'on_ft': 'javascript' }],
     \ ['pangloss/vim-javascript', { 'on_ft': 'javascript' }],
     \ ]

  if !SpaceVim#layers#lsp#check_filetype('javascript')
    call add(plugins, ['ternjs/tern_for_vim', {
          \ 'on_ft': 'javascript', 'build' : 'npm install' }])
    call add(plugins, ['carlitux/deoplete-ternjs', { 'on_ft': [
          \ 'javascript'], 'if': has('nvim') }])
  endif

  return plugins
endfunction

let s:auto_fix = 0

function! SpaceVim#layers#lang#javascript#set_variable(var) abort
  let s:auto_fix = get(a:var, 'auto_fix', 0)
endfunction

function! SpaceVim#layers#lang#javascript#config() abort
  " pangloss/vim-javascript {{{
  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_flow = 1
  " }}}

  " MaxMEllon/vim-jsx-pretty {{{
  let g:vim_jsx_pretty_colorful_config = 1
  " }}}

  call SpaceVim#plugins#runner#reg_runner('javascript', 'node %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('javascript',
        \ funcref('s:on_ft'))

  if SpaceVim#layers#lsp#check_filetype('javascript')
    call SpaceVim#mapping#gd#add('javascript',
          \ function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('javascript', function('s:tern_go_to_def'))
  endif

  if s:auto_fix
    " Only use eslint
    let g:neomake_javascript_enabled_makers = ['eslint']
    " Use the fix option of eslint
    let g:neomake_javascript_eslint_args = ['-f', 'compact', '--fix']

    augroup Spacevim_lang_javascript
      autocmd!
      autocmd User NeomakeFinished checktime
      autocmd FocusGained * checktime
    augroup END
  endif
endfunction

function! s:on_ft() abort
  " Galooshi/vim-import-js {{{
  nnoremap <silent><buffer> <F4> :ImportJSWord<CR>
  nnoremap <silent><buffer> <Leader>ji :ImportJSWord<CR>
  nnoremap <silent><buffer> <Leader>jf :ImportJSFix<CR>
  nnoremap <silent><buffer> <Leader>jg :ImportJSGoto<CR>

  inoremap <silent><buffer> <F4> <Esc>:ImportJSWord<CR>a
  inoremap <silent><buffer> <C-j>i <Esc>:ImportJSWord<CR>a
  inoremap <silent><buffer> <C-j>f <Esc>:ImportJSFix<CR>a
  inoremap <silent><buffer> <C-j>g <Esc>:ImportJSGoto<CR>a
  " }}}

  if SpaceVim#layers#lsp#check_filetype('javascript')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  else
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'], 'TernDoc',
          \ 'show document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'], 'TernRename',
          \ 'rename symbol', 1)
  endif

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'],
        \ 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction

function! s:tern_go_to_def() abort
  if exists(':TernDef')
    TernDef
  endif
endfunction

" vi: et sw=2 cc=80
