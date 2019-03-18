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
"   normal    SPC l i       show candidates for importing of cursor symbol
"   normal    SPC l I       prompt for a qualified import
"   normal    SPC l o       organize imports of current file
"   normal    SPC l S       sort imports of current file
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
"   normal    SPC l b d     sbt show project dependencies tree
"   normal    SPC l b l     sbt reload project configuration
"   normal    SPC l b u     sbt update project dependencies
"   normal    SPC l b e     run sbt to generate .ensime config file
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
"   normal    SPC l h       show Documentation of cursor symbol
"   normal    SPC l t       show Type of expression of cursor symbol
"   normal    SPC l p       show Hierarchical view of a package
"   normal    SPC l g       find Definition of cursor symbol
"   normal    SPC l u       find Usages of cursor symbol
"   normal    SPC l Q       setup when first-time-use
" <
" @subsection Code formatting
" To make neoformat support scala file, you should install scalariform.
" [`scalariform`](https://github.com/scala-ide/scalariform)
"
" and set 'g:spacevim_layer_lang_scala_formatter' to the path of the jar.

function! SpaceVim#layers#lang#scala#plugins() abort
  let plugins = [ 
        \ ['ensime/ensime-vim'   , {'merged': 0 ,'on_ft': 'scala'}],
        \ ['derekwyatt/vim-scala', {'merged': 0 ,'on_ft': 'scala'}],
        \ ]
  return plugins
endfunction


" NOTE: ensime-vim
" Armed with your build tool plugin, generate the `.ensime` config from your
" project directory, e.g. for sbt use `sbt ensimeConfig`, or `./gradlew ensime`
" for Gradle.
"
" To trigger an update of ENSIME server, nuke the bootstrap project: >
" $ rm -rf ~/.config/ensime-vim/<your Scala version>
" Restart Vim and run |:EnInstall|.
"
" The server will fail to start if any of these files still exist in the
" `.ensime_cache` directory: `http`, `port`, `server.pid`. If you don’t see ENSIME
" running but those files are present, delete them and you should be all set.
function! SpaceVim#layers#lang#scala#config() abort
  let g:scala_use_default_keymappings = 0
  call SpaceVim#mapping#space#regesit_lang_mappings('scala', function('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('scala', 'scala')
  call add(g:spacevim_project_rooter_patterns, 'build.sbt')
  augroup SpaceVim_lang_scala
    auto!
    if !SpaceVim#layers#lsp#check_filetype('scala')
      " omnifunc will be used only when no scala lsp support
      " no omnifunc for scala
      " autocmd FileType scala setlocal omnifunc=scalacomplete#Complete
      call SpaceVim#mapping#gd#add('scala', function('s:go_to_def'))
    endif
    " ftdetect/sbt.vim
    autocmd BufRead,BufNewFile *.sbt set filetype=scala
    autocmd BufWritePost *.scala silent :EnTypeCheck
  augroup END
  let g:neoformat_enabled_scala = ['scalariform']
  let g:neoformat_scala_googlefmt = {
        \ 'exe': 'scala',
        \ 'args': ['-jar', get(g:,'spacevim_layer_lang_scala_formatter', ''), '-'],
        \ 'stdin': 1,
        \ }

endfunction


function! s:language_specified_mappings() abort
  " nnoremap <silent><buffer> gd :EnDeclarationSplit v<CR>
  nnoremap <silent><buffer> <F4>   :EnSuggestImport<CR>
  inoremap <silent><buffer> <F4>   <esc>:EnSuggestImport<CR>
  nnoremap <silent><buffer> <c-j>i :EnAddImport<CR>
  nnoremap <silent><buffer> <c-j>o :EnOrganizeImports<CR>
  nnoremap <silent><buffer> K      :EnDocBrowse<CR>

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','h'],
        \ 'EnDocBrowse',
        \ 'show Documentation of cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','Q'],
        \ 'EnInstall',
        \ 'setup when first-time-use', 1)
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
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','u'],
        \ 'EnUsages',
        \ 'find Usages of cursor symbol', 1)

  " debug
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

  " import
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','i'],
        \ 'EnSuggestImport',
        \ 'Show candidates for importing of cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','I'],
        \ 'EnAddImport',
        \ 'Prompt for a qualified import', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','o'],
        \ 'EnOrganizeImports',
        \ 'Organize imports of current file', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','r'],
        \ 'EnInline',
        \ 'Inline local refactoring of cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','R'],
        \ 'EnRename',
        \ 'Rename cursor symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','S'],
        \ 'SortScalaImports',
        \ 'sort imports', 1)

  " Sbt
  let g:_spacevim_mappings_space.l.b = {'name' : '+Sbt'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'e'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt ensimeConfig"])',
        \ 'run sbt to generate .ensime config file', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'c'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt clean compile"])',
        \ 'run sbt clean compile', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'r'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt run"])',
        \ 'run sbt run', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 't'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt test"])',
        \ 'run sbt test', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'd'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt inspect tree compile:sources"])',
        \ 'run sbt to show project dependencies tree', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'l'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt reload"])',
        \ 'run sbt to reload project configuration', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'u'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt update"])',
        \ 'run sbt to update project dependencies', 1)

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
  call unite#start([['output/shellcmd', a:cmd]], {'log': 1, 'wrap': 1,'start_insert':0})
endfunction

" vim:set et sw=2 cc=80:
