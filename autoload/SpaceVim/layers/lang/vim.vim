function! SpaceVim#layers#lang#vim#plugins() abort
  let plugins = [
        \ ['syngan/vim-vimlint',                     { 'on_ft' : 'vim'}],
        \ ['ynkdir/vim-vimlparser',                  { 'on_ft' : 'vim'}],
        \ ['todesking/vint-syntastic',               { 'on_ft' : 'vim'}],
        \ ]
  call add(plugins,['tweekmonster/exception.vim'])
  call add(plugins,['mhinz/vim-lookup'])
  call add(plugins,['Shougo/neco-vim',              { 'on_event' : 'InsertEnter', 'loadconf_before' : 1}])
  if g:spacevim_autocomplete_method == 'asyncomplete'
    call add(plugins, ['prabirshrestha/asyncomplete-necovim.vim', {
          \ 'loadconf' : 1,
          \ 'merged' : 0,
          \ }])
  endif
  call add(plugins,['tweekmonster/helpful.vim',      {'on_cmd': 'HelpfulVersion'}])
  return plugins
endfunction

function! SpaceVim#layers#lang#vim#config() abort
  call SpaceVim#mapping#gd#add('vim','lookup#lookup')
  call SpaceVim#mapping#space#regesit_lang_mappings('vim', funcref('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'],  'call call('
        \ . string(function('s:eval_cursor')) . ', [])',
        \ 'echo eval under cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],  'call call('
        \ . string(function('s:helpversion_cursor')) . ', [])',
        \ 'echo helpversion under cursor', 1)
endfunction

function! s:eval_cursor() abort
  let is_keyword = &iskeyword
  set iskeyword+=:
  echo expand('<cword>') 'is' eval(expand('<cword>'))
  let &iskeyword = is_keyword
endfunction

function! s:helpversion_cursor() abort
  exe 'HelpfulVersion' expand('<cword>')
endfunction
