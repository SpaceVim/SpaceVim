scriptencoding utf-8

" lsp.vim
" author: Seong Yong-ju ( @sei40kr )

function! SpaceVim#lsp#reg_server(ft, cmds) abort
  let g:LanguageClient_serverCommands[a:ft] = copy(a:cmds)
endfunction

" vi: et sw=2 cc=80
