
let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#gtags_completion#define()
  return s:kind
endfunction

let s:kind = {
      \ 'name' : 'gtags_completion',
      \ 'default_action' : 'list_refereces',
      \ 'action_table': {},
      \}

" Actions
let s:kind.action_table.list_refereces = {
      \ 'description' : 'Unite gtags/ref',
      \ 'is_selectable' : 0,
      \ }

function! s:kind.action_table.list_refereces.func(candidate)
  execute 'Unite gtags/ref:'. a:candidate.word
endfunction

let s:kind.action_table.list_definitions = {
      \ 'description' : 'Unite gtags/def',
      \ 'is_selectable' : 0,
      \ }

function! s:kind.action_table.list_definitions.func(candidate)
  execute 'Unite gtags/def:'. a:candidate.word . ' -immediately'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

