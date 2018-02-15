"=============================================================================
" lsp.vim --- language server protocol wallpaper
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Seong Yong-ju < @sei40kr >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

if has('nvim')
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
else
  " use vim-lsp
  function! SpaceVim#lsp#reg_server(ft, cmds) abort
   exe "au User lsp_setup call lsp#register_server({"
          \ . "'name': 'LSP',"
          \ . "'cmd': {server_info -> " . string(a:cmds) . "},"
          \ . "'whitelist': ['" .  a:ft . "' ],"
          \ . "})"
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

endif

" vi: et sw=2 cc=80
