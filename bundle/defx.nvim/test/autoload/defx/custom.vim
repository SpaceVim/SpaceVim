" set verbose=1

let s:suite = themis#suite('custom')
let s:assert = themis#helper('assert')

function! s:suite.before_each() abort
  call defx#custom#_init()
endfunction

function! s:suite.custom_column() abort
  let custom = defx#custom#_get().column
  call defx#custom#column(
        \ 'mark', 'selected_icon', 'O')
  call s:assert.equals(custom.mark.selected_icon, 'O')
endfunction

function! s:suite.custom_option() abort
  let custom = defx#custom#_get().option

  call defx#custom#option('default', 'columns', 'mark')
  call s:assert.equals(custom.default.columns, 'mark')
endfunction

function! s:suite.custom_source() abort
  let custom = defx#custom#_get().source

  call defx#custom#source('file', 'root', 'mark')
  call s:assert.equals(custom.file.root, 'mark')
endfunction
