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
