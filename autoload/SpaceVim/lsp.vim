"=============================================================================
" lsp.vim --- language server protocol wallpaper
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Seong Yong-ju < @sei40kr >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8


if SpaceVim#layers#isLoaded('autocomplete') && get(g:, 'spacevim_autocomplete_method') ==# 'coc'
  " use coc.nvim
  let s:coc_language_servers = {}
  let s:coc_language_servers_key_id_map = {}
  function! SpaceVim#lsp#reg_server(ft, cmds) abort
    " coc.nvim doesn't support key values containing dots
    " See https://github.com/neoclide/coc.nvim/issues/323
    " Since a:cmds[0], i.e. the language server command can be a full path,
    " which can potentially contain dots, we just take it's last part, if any
    " dots are present.
    " 
    " Clearly, with this implementation, an edge case could be the following
    "
    " [layers.override_cmd]
    "   c = ['/home/user/.local/.bin/ccls', '--log-file=/tmp/ccls.log']
    "   cpp = ['/home/user/local/.bin/ccls', '--log-file=/tmp/ccls.log']
    "
    " the last part `bin/ccls` is the same, whereas the commands are not
    " actually the same.
    " We need to keep an id to distinguish among conflicting keys.
    
    if stridx(a:cmds[0], '.') >= 0 
      let l:key = split(a:cmds[0], "\\.")[-1]
    else
      let l:key = a:cmds[0]
    endif

    for id in range(get(s:coc_language_servers_key_id_map, l:key, 0))
      if has_key(s:coc_language_servers, l:key . id) && s:coc_language_servers[l:key . id].command ==# a:cmds[0]
        call add(s:coc_language_servers[l:key . id].filetypes, a:ft)
        return
      endif
    endfor

    let s:coc_language_servers_key_id_map[l:key] = get(s:coc_language_servers_key_id_map, l:key, 0)
    let s:coc_language_servers[l:key . s:coc_language_servers_key_id_map[l:key]] = {
          \'command': a:cmds[0],
          \'args': a:cmds[1:],
          \'filetypes': [a:ft]
          \}

    let s:coc_language_servers_key_id_map[l:key] = s:coc_language_servers_key_id_map[l:key] + 1

    augroup spacevim_lsp_layer
      autocmd!
      autocmd! User CocNvimInit :call coc#config("languageserver", s:coc_language_servers)
    augroup END
  endfunction

  function! SpaceVim#lsp#show_doc() abort
    call CocActionAsync('doHover')
  endfunction

  function! SpaceVim#lsp#go_to_def() abort
    call CocAction('jumpDefinition')
  endfunction

  function! SpaceVim#lsp#go_to_declaration() abort
    call CocAction('jumpDeclaration')
  endfunction

  function! SpaceVim#lsp#go_to_typedef() abort
    call CocAction('jumpTypeDefinition')
  endfunction

  function! SpaceVim#lsp#go_to_impl() abort
    call CocAction('jumpImplementation')
  endfunction

  function! SpaceVim#lsp#refactor() abort
    call CocActionAsync('refactor')
  endfunction

  function! SpaceVim#lsp#rename() abort
    call CocActionAsync('rename')
  endfunction

  function! SpaceVim#lsp#references() abort
    call CocAction('jumpReferences')
  endfunction
elseif has('nvim')
  " use LanguageClient-neovim
  function! SpaceVim#lsp#reg_server(ft, cmds) abort
    let g:LanguageClient_serverCommands[a:ft] = copy(a:cmds)
  endfunction

  function! SpaceVim#lsp#show_doc() abort
    call LanguageClient_textDocument_hover()
  endfunction

  function! SpaceVim#lsp#go_to_def() abort
    call LanguageClient_textDocument_definition()
  endfunction

  function! SpaceVim#lsp#rename() abort
    call LanguageClient_textDocument_rename()
  endfunction

  function! SpaceVim#lsp#references() abort
    call LanguageClient_textDocument_references()
  endfunction
else
  " use vim-lsp
  function! SpaceVim#lsp#reg_server(ft, cmds) abort
    exe 'au User lsp_setup call lsp#register_server({'
          \ . "'name': '" . a:ft . "-lsp',"
          \ . "'cmd': {server_info -> " . string(a:cmds) . '},'
          \ . "'whitelist': ['" .  a:ft . "' ],"
          \ . '})'
    exe 'autocmd FileType ' . a:ft . ' setlocal omnifunc=lsp#complete'
  endfunction

  function! SpaceVim#lsp#show_doc() abort
    LspHover
  endfunction

  function! SpaceVim#lsp#go_to_def() abort
    LspDefinition
  endfunction

  function! SpaceVim#lsp#rename() abort
    LspRename
  endfunction

  function! SpaceVim#lsp#references() abort
    LspReferences
  endfunction
endif

" vi: et sw=2 cc=80
