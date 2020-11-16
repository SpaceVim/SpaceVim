"=============================================================================
" java.vim --- SpaceVim lang#java layer
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#java, layer-lang-java
" @parentsection layers
" This layer is for java development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#java'
" <
" @subsection Layer options
"
" 1. `format_on_save`: Enable/disabled code formatting when saving current file.
"   Disabled by default.
" 2. `java_fomatter_jar`: Set the full path of google's java formatter jar.
" 3. `java_file_head`: The default file header for new java file.
"   by default it is: 
" >
"   [[layers]]
"     name = 'lang#java'
"     java_file_head = [
"       '/**',
"       ' * @author : `fnamemodify(expand("~"), ":t")`',
"       ' * @created : `strftime("%Y-%m-%d")`',
"       '**/',
"       ''
"     ]
" <
" @subsection Mappings
" >
"   Import key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
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
"   normal    SPC l g A     generate accessors
"   normal    SPC l g s     generate setter accessor
"   normal    SPC l g g     generate getter accessor
"   normal    SPC l g a     generate setter and getter accessor
"   normal    SPC l g t     generate toString function
"   normal    SPC l g e     generate equals and hashcode function
"   normal    SPC l g c     generate constructor
"   normal    SPC l g C     generate default constructor
"   insert    <c-j>s        generate setter accessor
"   insert    <c-j>g        generate getter accessor
"   insert    <c-j>a        generate getter and setter accessor
"   visual    SPC l g s     generate setter accessor
"   visual    SPC l g g     generate getter accessor
"   visual    SPC l g a     generate setter and getter accessor
"
"   Maven key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l m i     run maven clean install
"   normal    SPC l m I     run maven install
"   normal    SPC l m p     run one already goal from list
"   normal    SPC l m r     run maven goals
"   normal    SPC l m R     run one maven goal
"   normal    SPC l m t     run maven test
"
"   Gradle key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l g r     run gradle run 
"   normal    SPC l g b     run gradle build
"   normal    SPC l g B     run gradle clean build
"   normal    SPC l g t     run gradle test
"
"   Jump key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l j a     jump to alternate file
"
"   REPL key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l s i     start a jshell inferior REPL process
"   normal    SPC l s b     send buffer and keep code buffer focused
"   normal    SPC l s l     send line and keep code buffer focused
"   normal    SPC l s s     send selection text and keep code buffer focused
" <
" @subsection Code formatting
" To make neoformat support java file, you should install uncrustify.
" or download google's formater jar from:
" https://github.com/google/google-java-format
"
" and set 'g:spacevim_layer_lang_java_formatter' to the path of the jar.



if exists('s:java_fomatter_jar')
  finish
endif


let s:java_fomatter_jar = ''
let s:format_on_save = 0
let s:java_file_head = [
      \ '/**',
      \ ' * @author : `fnamemodify(expand("~"), ":t")`',
      \ ' * @created : `strftime("%Y-%m-%d")`',
      \ '**/',
      \ ''
      \ ]
let s:enabled_linters = []
let s:java_interpreter = 'java'

function! SpaceVim#layers#lang#java#plugins() abort
  let plugins = [
        \ ['wsdjeg/vim-dict',               { 'on_ft' : 'java'}],
        \ ['wsdjeg/java_getset.vim',        { 'on_ft' : 'java', 'loadconf' : 1}],
        \ ['wsdjeg/JavaUnit.vim',           { 'on_ft' : 'java'}],
        \ ['vim-jp/vim-java',               { 'on_ft' : 'java'}],
        \ ['artur-shaik/vim-javacomplete2', { 'on_ft' : ['java','jsp'], 'loadconf' : 1}],
        \ ]
  return plugins
endfunction

function! SpaceVim#layers#lang#java#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('java', function('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('java', 'jshell')
  call add(g:spacevim_project_rooter_patterns, 'pom.xml')

  if SpaceVim#layers#lsp#check_filetype('java')
    call SpaceVim#mapping#gd#add('java', function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('java', function('s:go_to_def'))
  endif
  augroup SpaceVim_lang_java
    au!
    if !SpaceVim#layers#lsp#check_filetype('java')
      " omnifunc will be used only when no java lsp support
      autocmd FileType java setlocal omnifunc=javacomplete#Complete
    endif
    autocmd FileType jsp call <SID>JspFileTypeInit()
  augroup END
  let g:neoformat_enabled_java = get(g:, 'neoformat_enabled_java', ['googlefmt'])
  let g:neoformat_java_googlefmt = {
        \ 'exe': 'java',
        \ 'args': ['-jar', s:java_fomatter_jar, '-'],
        \ 'stdin': 1,
        \ }
  try
    let g:neoformat_enabled_java += neoformat#formatters#java#enabled()
  catch
  endtry

  " Format on save
  if s:format_on_save
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'java',
          \ 'enable' : 1,
          \ })
  endif
  call SpaceVim#layers#edit#add_ft_head_tamplate('java', s:java_file_head)
endfunction

function! s:JspFileTypeInit() abort
  setlocal omnifunc=javacomplete#Complete
  inoremap . <c-r>=OnmiConfigForJsp()<cr>
endfunction

function! s:language_specified_mappings() abort

  let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
  " we have removed all insert key bindings which use leader as prefix.
  " because when use leader in insert mode key bindings. vim will wait for
  " next key after insert \ in insert mode.
  " if g:spacevim_enable_insert_leader
    " inoremap <silent> <buffer> <leader>UU <esc>bgUwea
    " inoremap <silent> <buffer> <leader>uu <esc>bguwea
    " inoremap <silent> <buffer> <leader>ua <esc>bgulea
    " inoremap <silent> <buffer> <leader>Ua <esc>bgUlea
  " endif
  imap <silent><buffer> <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
  imap <silent><buffer> <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
  imap <silent><buffer> <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
  imap <silent><buffer> <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
  imap <silent><buffer> <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
  imap <silent><buffer> <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)
  imap <silent><buffer> <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)
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
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g', 'n'],
        \ '<Plug>(JavaComplete-Generate-NewClass)',
        \ 'Generate NewClass in current Package', 0)

  " execute
  let g:_spacevim_mappings_space.l.r = {'name' : '+Run'}
  " run main method
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'm'], 'JavaUnitTestMain', 'Run main method', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'c'], 'JavaUnitExec', 'Run current method', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'a'], 'JavaUnitTestAll', 'Run all test methods', 1)

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
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','m', 'c'], 'call call('
        \ . string(function('s:execCMD')) . ', ["mvn compile"])',
        \ 'Run maven compile', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','m', 'r'], 'call call('
        \ . string(function('s:execCMD')) . ', ["mvn run"])',
        \ 'Run maven run', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','m', 'p'], 'call call('
        \ . string(function('s:execCMD')) . ', ["mvn package"])',
        \ 'Run maven package', 1)

  " Gradle
  let g:_spacevim_mappings_space.l.g = {'name' : '+Gradle'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','g', 'B'], 'call call('
        \ . string(function('s:execCMD')) . ', ["gradle clean build"])',
        \ 'Run gradle clean build', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','g', 'b'], 'call call('
        \ . string(function('s:execCMD')) . ', ["gradle build"])',
        \ 'Run gradle build', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','g', 't'], 'call call('
        \ . string(function('s:execCMD')) . ', ["gradle test"])',
        \ 'Run gradle test', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','g', 'r'], 'call call('
        \ . string(function('s:execCMD')) . ', ["gradle run"])',
        \ 'Run gradle run', 1)

  " REPL
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

  if SpaceVim#layers#lsp#check_filetype('java')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction

function! s:java_mappings() abort

endfunction

function! s:go_to_def() abort
  exe 'normal! gd'
endfunction

function! s:execCMD(cmd) abort
  call javaunit#util#ExecCMD(a:cmd)
endfunction

function! SpaceVim#layers#lang#java#set_variable(var) abort
  let s:format_on_save = get(a:var,
        \ 'format_on_save',
        \ s:format_on_save)
  let s:java_file_head = get(a:var,
        \ 'java_file_head',
        \ s:java_file_head)
  let s:enabled_linters = get(a:var,
        \ 'enabled_linters',
        \ s:enabled_linters
        \ )
  let s:java_interpreter = get(a:var,
        \ 'java_interpreter',
        \ s:java_interpreter
        \ )
endfunction

" vim:set et sw=2 cc=80:
