"=============================================================================
" scala.vim --- SpaceVim lang#scala layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8


""
" @section lang#scala, layer-lang-scala
" @parentsection layers
" This layer is for Scala development.
"
" @subsection Mappings
" >
"   Import key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    <F4>          show candidates for importing of cursor symbol
"   insert    <F4>          show candidates for importing of cursor symbol
"   normal    SPC l i c     show candidates for importing of cursor symbol
"   normal    SPC l i q     prompt for a qualified import
"   normal    SPC l i o     organize imports of current file
"   normal    SPC l i s     sort imports of current file
"   insert    <c-j>i        prompt for a qualified import
"   insert    <c-j>o        organize imports of current file
"   insert    <c-j>s        sort imports of current file
"
"   Debug key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l d t     show debug stack trace of current frame
"   normal    SPC l d c     continue the execution
"   normal    SPC l d b     set a breakpoint for the current line
"   normal    SPC l d B     clear all breakpoints
"   normal    SPC l d l     launching debugger
"   normal    SPC l d i     step into next statement
"   normal    SPC l d o     step over next statement
"   normal    SPC l d O     step out of current function
"
"   Sbt key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l b c     sbt clean compile
"   normal    SPC l b r     sbt run
"   normal    SPC l b t     sbt test
"   normal    SPC l b p     sbt package
"   normal    SPC l b d     sbt show project dependencies tree
"   normal    SPC l b l     sbt reload project build definition
"   normal    SPC l b u     sbt update external dependencies
"   normal    SPC l b e     run sbt to generate .ensime config file
"
"   Execute key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l r m     run main class
"
"   REPL key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l s i     start a scala inferior REPL process
"   normal    SPC l s b     send buffer and keep code buffer focused
"   normal    SPC l s l     send line and keep code buffer focused
"   normal    SPC l s s     send selection text and keep code buffer focused
"
"   Other key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l Q       bootstrap server when first-time-use
"   normal    SPC l h       show Documentation of cursor symbol
"   normal    SPC l R       inline local refactoring of cursor symbol
"   normal    SPC l e       rename cursor symbol
"   normal    SPC l g       find Definition of cursor symbol
"   normal    SPC l t       show Type of expression of cursor symbol
"   normal    SPC l p       show Hierarchical view of a package
"   normal    SPC l r       find Usages of cursor symbol
"
" <
" @subsection Code formatting
" To make neoformat support scala file, you should install scalariform.
" [`scalariform`](https://github.com/scala-ide/scalariform)
" and set 'g:spacevim_layer_lang_scala_formatter' to the path of the jar.
"
" @subsection Ensime-vim setup steps
" The following is quick install steps, if you want to see complete details,
" please see: [`ensime`](http://ensime.github.io/editors/vim/install/)
"
" 1. Install vim`s plugin and its dependencies as following.
"      `pip install websocket-client sexpdata`,
"      `pip install pynvim` (neovim only).
" 2. Integration ENSIME with your build tools, here we use sbt.
"    > add (sbt-ensime) as global plugin for sbt:
"      Put code `addSbtPlugin("org.ensime" % "sbt-ensime" % "2.6.1")` in file 
"      '~/.sbt/plugins/plugins.sbt' (create if not exists).
"    > Armed with your build tool plugin, generate the `.ensime` config file from
"      your project directory in command line, e.g. for sbt use `sbt ensimeConfig`,
"      or `./gradlew ensime` for Gradle. the first time will take several minutes.
" 3. The first time you use ensime-vim (per Scala version), it will `bootstrap` the
"    ENSIME server installation when opening a Scala file you will be prompted to
"    run |:EnInstall|. Do that and give it a minute or two to run.
"    After this, you should see reports in Vim's message area that ENSIME is coming
"    up, and the indexer and analyzer are ready.
"    Going forward, ensime-vim will automatically start the ENSIME server when you
"    edit Scala files in a project with an `.ensime` config present.


function! SpaceVim#layers#lang#scala#plugins() abort
  let plugins = [ 
        \ ['derekwyatt/vim-scala', {'on_ft': 'scala'}],
        \ ]
  if has('python3') || has('python')
    call add(plugins, ['ensime/ensime-vim', {'on_ft': 'scala'}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#lang#scala#config() abort
  let g:scala_use_default_keymappings = 0
  call SpaceVim#mapping#space#regesit_lang_mappings('scala', function('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('scala', 'scala')
  call add(g:spacevim_project_rooter_patterns, 'build.sbt')
  augroup SpaceVim_lang_scala
    auto!
    if !SpaceVim#layers#lsp#check_filetype('scala')
      " no omnifunc for scala
      " autocmd FileType scala setlocal omnifunc=scalacomplete#Complete
      call SpaceVim#mapping#gd#add('scala', function('s:go_to_def'))
    endif
    " ftdetect/sbt.vim
    autocmd BufRead,BufNewFile *.sbt set filetype=scala
    autocmd BufWritePost *.scala silent :EnTypeCheck
  augroup END
  let g:neoformat_enabled_scala = neoformat#formatters#scala#enabled()
  let g:neoformat_scala_scalariform = {
        \ 'exe': 'java',
        \ 'args': ['-jar', get(g:,'spacevim_layer_lang_scala_formatter', ''), '-'],
        \ 'stdin': 1,
        \ }
endfunction


function! s:language_specified_mappings() abort
  " ensime-vim {{{
  " nnoremap <silent><buffer> gd :EnDeclarationSplit v<CR>
  nmap <silent><buffer> <F4>   :EnSuggestImport<CR>
  imap <silent><buffer> <F4>   <esc>:EnSuggestImport<CR>
  imap <silent><buffer> <c-j>i <esc>:EnAddImport<CR>
  imap <silent><buffer> <c-j>o <esc>:EnOrganizeImports<CR>
  imap <silent><buffer> <c-j>s <esc>:SortScalaImports<CR>
  nmap <silent><buffer> K      :EnDocBrowse<CR>

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','Q'],
        \ 'EnInstall',
        \ 'bootstrap server when first-time-use', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','h'],
        \ 'EnDocBrowse',
        \ 'show Documentation of cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','R'],
        \ 'EnInline',
        \ 'Inline local refactoring of cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','e'],
        \ 'EnRename',
        \ 'Rename cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','g'],
        \ 'EnDeclarationSplit v',
        \ 'find Definition of cursor symbol', 1)
  xnoremap <silent><buffer> <space>lt :EnType selection<CR>
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','t'],
        \ 'EnType',
        \ 'show Type of expression of cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','p'],
        \ 'EnShowPackage',
        \ 'show Hierarchical view of a package', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','r'],
        \ 'EnUsages',
        \ 'find Usages of cursor symbol', 1)

  " debug {{{
  let g:_spacevim_mappings_space.l.d = {'name' : '+Debug'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d','t'],
        \ 'EnDebugBacktrace',
        \ 'show debug stack trace of current frame', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d','c'],
        \ 'EnDebugContinue',
        \ 'continue the execution', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d','b'],
        \ 'EnDebugSetBreak',
        \ 'set a breakpoint for the current line', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d','B'],
        \ 'EnDebugClearBreaks',
        \ 'clear all breakpoints', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d','l'],
        \ 'EnDebugStart',
        \ 'launching debugger', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d','i'],
        \ 'EnDebugStep',
        \ 'step into next statement', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d','o'],
        \ 'EnDebugNext',
        \ 'step over next statement', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d','O'],
        \ 'EnDebugNext',
        \ 'step out of current function', 1)
  "}}}

  " import {{{
  let g:_spacevim_mappings_space.l.i = {'name' : '+Import'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','i','c'],
        \ 'EnSuggestImport',
        \ 'Show candidates for importing of cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','i','q'],
        \ 'EnAddImport',
        \ 'Prompt for a qualified import', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','i','o'],
        \ 'EnOrganizeImports',
        \ 'Organize imports of current file', 1) " }}}
  " }}}
  " import vim-scala
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','i','s'],
        \ 'SortScalaImports',
        \ 'sort imports', 1)

  " Execute
  let g:_spacevim_mappings_space.l.r = {'name' : '+Run'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','r', 'm'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt run"])',
        \ 'Run main class', 1)

  " Sbt
  let g:_spacevim_mappings_space.l.b = {'name' : '+Sbt'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'e'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt ensimeConfig"])',
        \ 'Run sbt to generate .ensime file', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'c'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt ~compile"])',
        \ 'Run sbt continuous compile', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'C'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt clean compile"])',
        \ 'Run sbt clean compile', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 't'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt test"])',
        \ 'Run sbt test', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'p'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt package"])',
        \ 'Run sbt to package jar', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'd'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt inspect tree compile:sources"])',
        \ 'Run sbt to show project dependencies tree', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'l'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt reload"])',
        \ 'Run sbt to reload build definition', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'u'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt update"])',
        \ 'Run sbt to update external dependencies', 1)

  " REPL
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("scala")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction


function! s:go_to_def() abort
  EnDeclarationSplit v
endfunction

function! s:execCMD(cmd) abort
  try
    call unite#start([['output/shellcmd', a:cmd]], {'log': 1, 'wrap': 1,'start_insert':0})
  catch
    exec '!'.a:cmd
  endtry
endfunction

" vim:set et sw=2 cc=80:
