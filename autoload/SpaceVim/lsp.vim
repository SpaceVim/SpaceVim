scriptencoding utf-8

" lsp.vim
" author: Seong Yong-ju ( @sei40kr )

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

" vi: et sw=2 cc=80
