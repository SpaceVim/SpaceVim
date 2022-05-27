"=============================================================================
" lsp.vim --- language server protocol wallpaper
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Seong Yong-ju < @sei40kr >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

if exists('s:NVIM_VERSION')
  finish
endif


let s:NVIM_VERSION = SpaceVim#api#import('neovim#version')
let s:box = SpaceVim#api#import('unicode#box')

if (has('nvim-0.5.0') && s:NVIM_VERSION.is_release_version()) || has('nvim-0.6.0')
  " use neovim built-in lsp
  call SpaceVim#logger#info('lsp client: nvim built-in lsp')
  function! SpaceVim#lsp#reg_server(ft, cmds) abort
    lua require("spacevim.lsp").register(
          \ require("spacevim").eval("a:ft"),
          \ require("spacevim").eval("a:cmds")
          \ )
  endfunction
  function! SpaceVim#lsp#show_doc() abort
    lua vim.lsp.buf.hover()
  endfunction
  function! SpaceVim#lsp#go_to_def() abort
    lua vim.lsp.buf.definition()
  endfunction
  function! SpaceVim#lsp#go_to_declaration() abort
    lua vim.lsp.buf.declaration()
  endfunction
  function! SpaceVim#lsp#rename() abort
    " @todo add float prompt api
    " lua vim.lsp.buf.rename(require('spacevim.api.input').float_prompt())
    lua vim.lsp.buf.rename()
  endfunction
  function! SpaceVim#lsp#references() abort
    lua vim.lsp.buf.references()
  endfunction
  function! SpaceVim#lsp#go_to_typedef() abort
  endfunction
  function! SpaceVim#lsp#refactor() abort
  endfunction
  function! SpaceVim#lsp#go_to_impl() abort
    lua vim.lsp.buf.implementation()
  endfunction
  function! SpaceVim#lsp#show_line_diagnostics() abort
    lua require('spacevim.diagnostic').open_float()
  endfunction
  function! SpaceVim#lsp#list_workspace_folder() abort
    let workspace = luaeval('vim.lsp.buf.list_workspace_folders()')
    let bw = max(map(deepcopy(workspace), 'strwidth(v:val)')) + 5
    let box = s:box.drawing_box(workspace, 1, 1, bw, {'align' : 'left'})
    echo join(box, "\n")
  endfunction
  function! SpaceVim#lsp#add_workspace_folder() abort
    lua vim.lsp.buf.add_workspace_folder()
  endfunction
  function! SpaceVim#lsp#remove_workspace_folder() abort
    lua vim.lsp.buf.remove_workspace_folder()
  endfunction
  function! SpaceVim#lsp#buf_server_ready() abort
    return v:lua.vim.lsp.buf.server_ready()
  endfunction
  function! SpaceVim#lsp#diagnostic_set_loclist() abort
    lua require('spacevim.diagnostic').set_loclist()
  endfunction
  function! SpaceVim#lsp#diagnostic_goto_next() abort
    lua require("spacevim.diagnostic").goto_next()
  endfunction
  function! SpaceVim#lsp#diagnostic_goto_prev() abort
    lua require("spacevim.diagnostic").goto_prev()
  endfunction
  function! SpaceVim#lsp#diagnostic_clear() abort
    lua require("spacevim.diagnostic").hide()
  endfunction
elseif SpaceVim#layers#isLoaded('autocomplete') && get(g:, 'spacevim_autocomplete_method') ==# 'coc'
  " use coc.nvim
  call SpaceVim#logger#info('lsp client: coc.nvim')
  let s:coc_language_servers = {}
  let s:coc_language_servers_key_id_map = {}
  function! SpaceVim#lsp#buf_server_ready() abort
  endfunction
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
elseif has('nvim-0.4.3') && $ENABLE_NVIM043LSP
  call SpaceVim#logger#info('lsp client: nvim-lspext')
  function! SpaceVim#lsp#buf_server_ready() abort
  endfunction
  function! SpaceVim#lsp#show_doc() abort
    lua require('lsp.plugin')
          \ .client.request('textDocument/hover',
          \ {}, require('spacevim.lsp').hover_callback)
  endfunction
  function! SpaceVim#lsp#go_to_def() abort
    lua require('lsp.plugin')
          \ .client.request('textDocument/hover',
          \ {}, require('spacevim.lsp').hover_callback)
  endfunction

  function! SpaceVim#lsp#go_to_typedef() abort
    call LanguageClient_textDocument_typeDefinition()
  endfunction

  function! SpaceVim#lsp#go_to_impl() abort
    call LanguageClient_textDocument_implementation()
  endfunction

  function! SpaceVim#lsp#rename() abort
    call LanguageClient_textDocument_rename()
  endfunction

  function! SpaceVim#lsp#references() abort
    call LanguageClient_textDocument_references()
  endfunction

  function! SpaceVim#lsp#go_to_declaration() abort
    call LanguageClient_textDocument_declaration()
  endfunction

  function! SpaceVim#lsp#documentSymbol() abort
    call LanguageClient_textDocument_documentSymbol()
  endfunction

  function! SpaceVim#lsp#refactor() abort
    " @todo languageclient do not support refactor
  endfunction
elseif has('nvim')
  " use LanguageClient-neovim
  call SpaceVim#logger#info('lsp client: LanguageClient-neovim')
  function! SpaceVim#lsp#reg_server(ft, cmds) abort
    let g:LanguageClient_serverCommands[a:ft] = copy(a:cmds)
  endfunction

  function! SpaceVim#lsp#show_doc() abort
    call LanguageClient_textDocument_hover()
  endfunction

  function! SpaceVim#lsp#go_to_def() abort
    call LanguageClient_textDocument_definition()
  endfunction

  function! SpaceVim#lsp#go_to_typedef() abort
    call LanguageClient_textDocument_typeDefinition()
  endfunction

  function! SpaceVim#lsp#go_to_impl() abort
    call LanguageClient_textDocument_implementation()
  endfunction

  function! SpaceVim#lsp#rename() abort
    call LanguageClient_textDocument_rename()
  endfunction

  function! SpaceVim#lsp#references() abort
    call LanguageClient_textDocument_references()
  endfunction

  function! SpaceVim#lsp#go_to_declaration() abort
    call LanguageClient_textDocument_declaration()
  endfunction

  function! SpaceVim#lsp#documentSymbol()
    call LanguageClient_textDocument_documentSymbol()
  endfunction

  function! SpaceVim#lsp#refactor() abort
    " @todo languageclient do not support refactor
  endfunction
  function! SpaceVim#lsp#buf_server_ready() abort
  endfunction
else
  " use vim-lsp
  call SpaceVim#logger#info('lsp client: vim-lsp')
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
  function! SpaceVim#lsp#go_to_declaration() abort
    LspDeclaration
  endfunction
  function! SpaceVim#lsp#rename() abort
    LspRename
  endfunction
  function! SpaceVim#lsp#references() abort
    LspReferences
  endfunction
  function! SpaceVim#lsp#go_to_typedef() abort
    LspPeekTypeDefinition
  endfunction
  function! SpaceVim#lsp#refactor() abort
    LspCodeAction refactor
  endfunction
  function! SpaceVim#lsp#go_to_impl() abort
    LspImplementation
  endfunction
  function! SpaceVim#lsp#show_line_diagnostics() abort
  endfunction
  function! SpaceVim#lsp#list_workspace_folder() abort
  endfunction
  function! SpaceVim#lsp#add_workspace_folder() abort
  endfunction
  function! SpaceVim#lsp#remove_workspace_folder() abort
  endfunction
  function! SpaceVim#lsp#buf_server_ready() abort
  endfunction
  function! SpaceVim#lsp#diagnostic_set_loclist() abort
  endfunction
  function! SpaceVim#lsp#diagnostic_goto_next() abort
    LspNextDiagnostic
  endfunction
  function! SpaceVim#lsp#diagnostic_goto_prev() abort
    LspPreviousDiagnostic
  endfunction
  function! SpaceVim#lsp#diagnostic_clear() abort
  endfunction
endif

" vi: et sw=2 cc=80
