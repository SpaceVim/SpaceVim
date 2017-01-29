""
" @section Layer_lang_java, layer_lang_java
" @parentsection layers
" This layer is for java development. 
" >
"   import-mappings:
"   mode      key           function
"   normal    <F4>          import class under corsor.
"   insert    <F4>          import class under corsor.
"   normal    <leader>jI    import missing classes.
"   normal    <leader>jR    remove unused imports.
"   normal    <leader>ji    smart import class under corsor.
"   normal    <leader>jii   same as <F4>
"   insert    <c-j>I        import missing imports.
"   insert    <c-j>R        remove unused imports.
"   insert    <c-j>i        smart import class under corsor.
"   insert    <c-j>ii       add import for class under corsor.
"
"   generate-mappings:
"   mode      key           function
"   normal    <leader>jA    generate accessors.
"   normal    <leader>js    generate setter accessor.
"   normal    <leader>jg    generate getter accessor.
"   normal    <leader>ja    generate setter and getter accessor.
"   normal    <leader>jts   generate toString function.
"   normal    <leader>jeq   generate equals and hashcode function.
"   normal    <leader>jc    generate constructor.
"   normal    <leader>jcc   generate default constructor.
"   insert    <c-j>s        generate setter accessor.
"   insert    <c-j>g        generate getter accessor.
"   insert    <c-j>a        generate getter and setter accessor.
"   visual    <leader>js    generate setter accessor.
"   visual    <leader>jg    generate getter accessor.
"   visual    <leader>ja    generate setter and getter acctssor.
" <
"


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
        inoremap <silent> <buffer> <leader>UU <esc>bgUwea
        inoremap <silent> <buffer> <leader>uu <esc>bguwea
        inoremap <silent> <buffer> <leader>ua <esc>bgulea
        inoremap <silent> <buffer> <leader>Ua <esc>bgUlea
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
    endfunction
    augroup SpaceVim_lang_java
        au!
        autocmd FileType java setlocal omnifunc=javacomplete#Complete
        autocmd FileType java call s:java_mappings()
        set tags +=~/others/openjdksrc/java/tags
        set tags +=~/others/openjdksrc/javax/tags
    augroup END
endfunction
