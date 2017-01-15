function! SpaceVim#layers#lang#plugins() abort
    let plugins = [
                \ ['Shougo/neosnippet.vim',                  { 'on_i'  : 1 , 'on_ft' : 'neosnippet', 'loadconf' : 1}],
                \ ['m2mdas/phpcomplete-extended',            { 'on_ft' : 'php'}],
                \ ['groenewege/vim-less',                    { 'on_ft' : ['less']}],
                \ ['cakebaker/scss-syntax.vim',              { 'on_ft' : ['scss','sass']}],
                \ ['hail2u/vim-css3-syntax',                 { 'on_ft' : ['css','scss','sass']}],
                \ ['ap/vim-css-color',                       { 'on_ft' : ['css','scss','sass','less','styl']}],
                \ ['othree/html5.vim',                       { 'on_ft' : ['html']}],
                \ ['wavded/vim-stylus',                      { 'on_ft' : ['styl']}],
                \ ['digitaltoad/vim-jade',                   { 'on_ft' : ['jade']}],
                \ ['juvenn/mustache.vim',                    { 'on_ft' : ['mustache']}],
                \ ['Valloric/MatchTagAlways',                { 'on_ft' : ['html' , 'xhtml' , 'xml' , 'jinja']}],
                \ ['pangloss/vim-javascript',                { 'on_ft' : ['javascript']}],
                \ ['maksimr/vim-jsbeautify',                 { 'on_ft' : ['javascript']}],
                \ ['leafgarland/typescript-vim',             { 'on_ft' : ['typescript']}],
                \ ['kchmck/vim-coffee-script',               { 'on_ft' : ['coffee']}],
                \ ['mmalecki/vim-node.js',                   { 'on_ft' : ['javascript']}],
                \ ['leshill/vim-json',                       { 'on_ft' : ['javascript','json']}],
                \ ['othree/javascript-libraries-syntax.vim', { 'on_ft' : ['javascript','coffee','ls','typescript']}],
                \ ['syngan/vim-vimlint',                     { 'on_ft' : 'vim'}],
                \ ['ynkdir/vim-vimlparser',                  { 'on_ft' : 'vim'}],
                \ ['todesking/vint-syntastic',               { 'on_ft' : 'vim'}],
                \ ['plasticboy/vim-markdown',                { 'on_ft' : 'markdown'}],
                \ ['elixir-lang/vim-elixir',                 { 'on_ft' : 'elixir'}],
                \ ['racer-rust/vim-racer',                   { 'on_ft' : 'rust'}],
                \ ['PotatoesMaster/i3-vim-syntax',           { 'on_ft' : 'i3'}],
                \ ['isundil/vim-irssi-syntax',               { 'on_ft' : 'irssi'}],
                \ ['lervag/vimtex',                          { 'on_ft' : 'tex'}],
                \ ['vimperator/vimperator.vim',              { 'on_ft' : 'vimperator'}],
                \ ['fatih/vim-go',                           { 'on_ft' : 'go', 'loadconf_before' : 1}],
                \ ['rust-lang/rust.vim',            {'merged' : 1}],
                \ ] 
    " python
    if has('nvim')
        call add(plugins, ['zchee/deoplete-jedi',                    { 'on_ft' : 'python'}])
    else
        call add(plugins, ['davidhalter/jedi-vim',                   { 'on_ft' : 'python'}])
    endif
    return plugins
endfunction

function! SpaceVim#layers#lang#config() abort
    let g:racer_cmd = $HOME.'/.cargo/bin/racer'
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_folding_disabled = 1
endfunction
