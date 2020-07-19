"=============================================================================
" csharp.vim --- SpaceVim lang#csharp layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: VyronLee < lwz_jz # hotmail.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#csharp, layer-lang-csharp
" @parentsection layers
" @subsection Intro
"
" This layer includes utilities and language-specific mappings for csharp development.
" By default it is disabled, to enable this layer:
" >
"   [layers]
"     name = "lang#csharp"
" <
"
" @subsection Key Mappings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l b         compile the project
"   normal          SPC l f         format current file
"   normal          SPC l d         show doc
"   normal          SPC l e         rename symbol under cursor
"   normal          SPC l g g       go to definition
"   normal          SPC l g i       find implementations
"   normal          SPC l g t       find type
"   normal          SPC l g s       find symbols
"   normal          SPC l g u       find usages of symbol under cursor
"   normal          SPC l g m       find members in the current buffer
"   normal          SPC l s r       reload the solution
"   normal          SPC l s s       start the OmniSharp server
"   normal          SPC l s S       stop the OmniSharp server
" <

function! SpaceVim#layers#lang#csharp#plugins() abort
  let plugins = []
  call add(plugins, ['OmniSharp/omnisharp-vim', { 'on_ft' : 'cs' } ])
  return plugins
endfunction

function! SpaceVim#layers#lang#csharp#set_variable(var) abort
  if has_key(a:var, 'highlight_types')
    let g:OmniSharp_highlight_types = a:var.highlight_types
  endif
endfunction

function! SpaceVim#layers#lang#csharp#config() abort
  " Get Code Issues and syntax errors
  let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

  augroup spacevim_lang_csharp
    autocmd!
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
  augroup END

  call SpaceVim#mapping#space#regesit_lang_mappings('cs', function('s:language_specified_mappings'))
endfunction

" Add language specific mappings
function! s:language_specified_mappings() abort
  " Suggested bindings
  call SpaceVim#mapping#space#langSPC('nmap', ['l','b'], 
        \ 'OmniSharpBuildAsync', 
        \ 'compile the project', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','f'], 
        \ 'OmniSharpCodeFormat', 
        \ 'format current file', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d'], 
        \ 'OmniSharpDocumentation', 
        \ 'show doc', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'], 
        \ 'OmniSharpRename', 
        \ 'rename symbol under cursor', 1)

  " Navigation
  let g:_spacevim_mappings_space.l.g = {'name' : '+Navigation'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g', 'g'],
        \ 'OmniSharpGotoDefinition',
        \ 'go to definition', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g', 'i'],
        \ 'OmniSharpFindImplementations',
        \ 'find implementations', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g', 't'],
        \ 'OmniSharpFindType',
        \ 'find type', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g', 's'],
        \ 'OmniSharpFindSymbol',
        \ 'find symbols', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g', 'u'],
        \ 'OmniSharpFindUsages',
        \ 'find usages of symbol under cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g', 'm'],
        \ 'OmniSharpFindMembers',
        \ 'find members in the current buffer', 1)

  " Code action
  let g:_spacevim_mappings_space.l.c = {'name' : '+Code action'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 'f'],
        \ 'OmniSharpFixUsings',
        \ 'Fix using', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 'a'],
        \ 'OmniSharpGetCodeActions',
        \ 'Contextual code actions', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 'c'],
        \ 'OmniSharpGlobalCodeCheck',
        \ 'Find all code errors/warnings for the current solution', 1)

  " Server interaction
  let g:_spacevim_mappings_space.l.s = {'name' : '+Server interaction'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'r'],
        \ 'OmniSharpReloadSolution',
        \ 'Reload the solution', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'OmniSharpStartServer',
        \ 'Start the OmniSharp server', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'S'],
        \ 'OmniSharpStopServer',
        \ 'Stop the OmniSharp server', 1)

endfunction
