""
" @section lang#java, layer-lang-java
" @parentsection layers
" This layer is for Java development. 
"
" @subsection Mappings
" >
"   Import mappings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    <F4>          import class under cursor
"   insert    <F4>          import class under cursor
"   normal    <leader>jI    import missing classes
"   normal    <leader>jR    remove unused imports
"   normal    <leader>ji    smart import class under cursor
"   normal    <leader>jii   same as <F4>
"   insert    <c-j>I        import missing imports
"   insert    <c-j>R        remove unused imports
"   insert    <c-j>i        smart import class under cursor
"   insert    <c-j>ii       add import for class under cursor
"
"   Generate mappings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    <leader>jA    generate accessors
"   normal    <leader>js    generate setter accessor
"   normal    <leader>jg    generate getter accessor
"   normal    <leader>ja    generate setter and getter accessor
"   normal    <leader>jts   generate toString function
"   normal    <leader>jeq   generate equals and hashcode function
"   normal    <leader>jc    generate constructor
"   normal    <leader>jcc   generate default constructor
"   insert    <c-j>s        generate setter accessor
"   insert    <c-j>g        generate getter accessor
"   insert    <c-j>a        generate getter and setter accessor
"   visual    <leader>js    generate setter accessor
"   visual    <leader>jg    generate getter accessor
"   visual    <leader>ja    generate setter and getter accessor
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
    nmap <silent><buffer> <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
    nmap <silent><buffer> <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
    nmap <silent><buffer> <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
    nmap <silent><buffer> <leader>jii <Plug>(JavaComplete-Imports-Add)

    imap <silent><buffer> <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
    imap <silent><buffer> <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
    imap <silent><buffer> <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
    imap <silent><buffer> <C-j>ii <Plug>(JavaComplete-Imports-Add)

    nmap <silent><buffer> <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)

    imap <silent><buffer> <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','M'], '<Plug>(JavaComplete-Generate-AbstractMethods)', 'Generate abstract methods', 0)

    nmap <silent><buffer> <leader>jA <Plug>(JavaComplete-Generate-Accessors)
    nmap <silent><buffer> <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
    nmap <silent><buffer> <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
    nmap <silent><buffer> <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
    nmap <silent><buffer> <leader>jts <Plug>(JavaComplete-Generate-ToString)
    nmap <silent><buffer> <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
    nmap <silent><buffer> <leader>jc <Plug>(JavaComplete-Generate-Constructor)
    nmap <silent><buffer> <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)

    imap <silent><buffer> <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
    imap <silent><buffer> <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
    imap <silent><buffer> <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

    vmap <silent><buffer> <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
    vmap <silent><buffer> <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
    vmap <silent><buffer> <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
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
  augroup SpaceVim_lang_java
    au!
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType java call s:java_mappings()
    set tags +=~/others/openjdksrc/java/tags
    set tags +=~/others/openjdksrc/javax/tags
  augroup END
endfunction

" vim:set et sw=2 cc=80:
