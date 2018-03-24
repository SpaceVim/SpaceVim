"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 
      \ get(g:, 'ycm_collect_identifiers_from_tags_files', 1)
let g:ycm_collect_identifiers_from_comments_and_strings = 
      \ get(g:, 'ycm_collect_identifiers_from_comments_and_strings', 1)
let g:ycm_key_list_select_completion =
      \ get(g:, 'ycm_key_list_select_completion', ['<C-TAB>', '<Down>'])
let g:ycm_key_list_previous_completion =
      \ get(g:, 'ycm_key_list_previous_completion', ['<C-S-TAB>','<Up>'])
let g:ycm_seed_identifiers_with_syntax =
      \ get(g:, 'ycm_seed_identifiers_with_syntax', 1)
let g:ycm_key_invoke_completion =
      \ get(g:, 'ycm_key_invoke_completion', '<leader><tab>')

let g:ycm_semantic_triggers = get(g:, 'ycm_semantic_triggers', {})

function! s:set_ft_triggers(ft, expr, override) abort
  if a:override
    let g:ycm_semantic_triggers[a:ft] = a:expr
  elseif !has_key(g:ycm_semantic_triggers, a:ft)
    let g:ycm_semantic_triggers[a:ft] = a:expr
  endif
endfunction

call s:set_ft_triggers('c', ['->', '.'], 0)
call s:set_ft_triggers('objc', ['->', '.'], 0)
call s:set_ft_triggers('ocaml', ['.', '#'], 0)
call s:set_ft_triggers('cpp,objcpp', ['->', '.', '::'], 0)
call s:set_ft_triggers('perl', ['->'], 0)
call s:set_ft_triggers('php', ['->', '::'], 0)
call s:set_ft_triggers('cs,javascript,d,python,perl6,scala,vb,elixir,go', ['.'], 0)
call s:set_ft_triggers('java,jsp', ['.'], 0)
call s:set_ft_triggers('vim', ['re![_a-zA-Z]+[_\w]*\.'], 0)
call s:set_ft_triggers('ruby', ['.', '::'], 0)
call s:set_ft_triggers('lua', ['.', ':'], 0)
call s:set_ft_triggers('erlang', [':'], 0)
call s:set_ft_triggers('sh', ['re![\w-]{2}', '/', '-'], 0)
call s:set_ft_triggers('zsh', ['re![\w-]{2}', '/', '-'], 0)
