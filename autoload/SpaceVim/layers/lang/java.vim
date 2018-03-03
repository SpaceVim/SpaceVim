"=============================================================================
" java.vim --- SpaceVim lang#java layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#java, layer-lang-java
" @parentsection layers
" This layer is for Java development. 
"
" @subsection Mappings
" >
"   Import key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    <F4>          import class under cursor
"   insert    <F4>          import class under cursor
"   normal    SPC l I       import missing classes
"   normal    SPC l R       remove unused imports
"   normal    SPC l i       smart import class under cursor
"   insert    <c-j>I        import missing imports
"   insert    <c-j>R        remove unused imports
"   insert    <c-j>i        smart import class under cursor
"
"   Generate key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l g A    generate accessors
"   normal    SPC l g s    generate setter accessor
"   normal    SPC l g g    generate getter accessor
"   normal    SPC l g a    generate setter and getter accessor
"   normal    SPC l g t    generate toString function
"   normal    SPC l g e    generate equals and hashcode function
"   normal    SPC l g c    generate constructor
"   normal    SPC l g C    generate default constructor
"   insert    <c-j>s       generate setter accessor
"   insert    <c-j>g       generate getter accessor
"   insert    <c-j>a       generate getter and setter accessor
"   visual    SPC l g s    generate setter accessor
"   visual    SPC l g g    generate getter accessor
"   visual    SPC l g a    generate setter and getter accessor
"
"   Maven key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l m i   	Run maven clean install
"   normal    SPC l m I	    Run maven install
"   normal    SPC l m p	    Run one already goal from list
"   normal    SPC l m r	    Run maven goals
"   normal    SPC l m R	    Run one maven goal
"   normal    SPC l m t	    Run maven test
"
"   Jump key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l j a   	jump to alternate file
"
"   REPL key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l s i	    start a jshell inferior REPL process
"   normal    SPC l s b	    send buffer and keep code buffer focused
"   normal    SPC l s l	    send line and keep code buffer focused
"   normal    SPC l s s	    send selection text and keep code buffer focused
" <
" @subsection Code formatting
" To make neoformat support java file, you should install uncrustify.
" or download google's formater jar from:
" https://github.com/google/google-java-format
"
" and set 'g:spacevim_layer_lang_java_formatter' to the path of the jar.


function! SpaceVim#layers#lang#java#plugins() abort
  let plugins = [
        \ ['wsdjeg/vim-dict',                        { 'on_ft' : 'java'}],
        \ ['wsdjeg/java_getset.vim',                 { 'on_ft' : 'java', 'loadconf' : 1}],
        \ ['wsdjeg/JavaUnit.vim',                    { 'on_ft' : 'java'}],
        \ ['vim-jp/vim-java',                        { 'on_ft' : 'java'}],
        \ ['artur-shaik/vim-javacomplete2',          { 'on_ft' : ['java','jsp'], 'loadconf' : 1}],
        \ ]
  return plugins
endfunction

function! SpaceVim#layers#lang#java#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('java', function('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('java', 'jshell')
  call add(g:spacevim_project_rooter_patterns, 'pom.xml')
  augroup SpaceVim_lang_java
    au!
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType java call s:java_mappings()
  augroup END
  set tags +=~/others/openjdksrc/java/tags
  set tags +=~/others/openjdksrc/javax/tags
  let g:neoformat_enabled_java = ['googlefmt']
  let g:neoformat_java_googlefmt = {
        \ 'exe': 'java',
        \ 'args': ['-jar', get(g:,'spacevim_layer_lang_java_formatter', '')],
        \ 'replace': 0,
        \ 'stdin': 0,
        \ 'no_append': 0,
        \ }
  try
    let g:neoformat_enabled_java += neoformat#formatters#java#enabled()
  catch
  endtry
endfunction

function! s:language_specified_mappings() abort

  " Import key bindings
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I'],
        \ '<Plug>(JavaComplete-Imports-AddMissing)',
        \ 'Import missing classes', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','R'],
        \ '<Plug>(JavaComplete-Imports-RemoveUnused)',
        \ 'Remove unused classes', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i'],
        \ '<Plug>(JavaComplete-Imports-AddSmart)',
        \ 'Smart import class under cursor', 0)

  " Generate key bindings
  let g:_spacevim_mappings_space.l.g = {'name' : '+Generate'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 'A'],
        \ '<Plug>(JavaComplete-Generate-Accessors)',
        \ 'generate setter accessor', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 's'],
        \ '<Plug>(JavaComplete-Generate-AccessorSetter)',
        \ 'generate setter accessor', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 'g'],
        \ '<Plug>(JavaComplete-Generate-AccessorGetter)',
        \ 'generate getter accessor', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 'a'],
        \ '<Plug>(JavaComplete-Generate-AccessorSetterGetter)',
        \ 'generate setter and getter accessor', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 'M'],
        \ '<Plug>(JavaComplete-Generate-AbstractMethods)',
        \ 'Generate abstract methods', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 'c'],
        \ '<Plug>(JavaComplete-Generate-Constructor)',
        \ 'Generate constructor', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 'C'],
        \ '<Plug>(JavaComplete-Generate-DefaultConstructor)',
        \ 'Generate default constructor', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 'e'],
        \ '<Plug>(JavaComplete-Generate-EqualsAndHashCode)',
        \ 'Generate equals functions', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 't'],
        \ '<Plug>(JavaComplete-Generate-ToString)',
        \ 'Generate toString function', 0)

  " Jump
  let g:_spacevim_mappings_space.l.j = {'name' : '+Jump'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','j', 'a'], 'call call('
        \ . string(function('s:jump_to_alternate')) . ', [])',
        \ 'jump to alternate file', 1)

  " execute
  let g:_spacevim_mappings_space.l.r = {'name' : '+Run'}
  " run main methon
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'm'], 'JavaUnitTestMain', 'Run main method', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'c'], 'JavaUnitExec', 'Run current method', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'a'], 'JavaUnitTestAll', 'Run all test methods', 1)

  " debug
  let g:_spacevim_mappings_space.l.d = {'name' : '+Debug'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d', 's'], ':VBGstartJDB', 'start jdb', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d', 't'], 'VBGtoggleBreakpointThisLine', 'toggle breakpoint at this line', 1)

  " maven
  let g:_spacevim_mappings_space.l.m = {'name' : '+Maven'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','m', 'i'], 'call call('
        \ . string(function('s:execCMD')) . ', ["mvn clean install"])',
        \ 'Run maven clean install', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','m', 'I'], 'call call('
        \ . string(function('s:execCMD')) . ', ["mvn install"])',
        \ 'Run maven install', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','m', 't'], 'call call('
        \ . string(function('s:execCMD')) . ', ["mvn test"])',
        \ 'Run maven test', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("java")',
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

function! s:java_mappings() abort
  let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
  if g:spacevim_enable_insert_leader
    inoremap <silent> <buffer> <leader>UU <esc>bgUwea
    inoremap <silent> <buffer> <leader>uu <esc>bguwea
    inoremap <silent> <buffer> <leader>ua <esc>bgulea
    inoremap <silent> <buffer> <leader>Ua <esc>bgUlea
  endif
  nmap <silent><buffer> <F4> <Plug>(JavaComplete-Imports-Add)
  imap <silent><buffer> <F4> <Plug>(JavaComplete-Imports-Add)

  imap <silent><buffer> <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
  imap <silent><buffer> <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
  imap <silent><buffer> <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
  imap <silent><buffer> <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
  imap <silent><buffer> <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
  imap <silent><buffer> <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)
  imap <silent><buffer> <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)

endfunction

function! s:execCMD(cmd) abort
  call unite#start([['output/shellcmd', a:cmd]], {'log': 1, 'wrap': 1,'start_insert':0})
endfunction

function! s:jump_to_alternate() abort
  try
    A
  catch /^Vim\%((\a\+)\)\=:E464/
    echom 'no alternate file'
  endtry
endfunction

" vim:set et sw=2 cc=80:
