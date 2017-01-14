function! SpaceVim#layers#tools#plugins() abort
    return [
                \ ['tpope/vim-scriptease'],
                \ ['wsdjeg/vim-cheat',                       { 'on_cmd' : 'Cheat'}],
                \ ['wsdjeg/SourceCounter.vim',               { 'on_cmd' : 'SourceCounter'}],
                \ ['junegunn/goyo.vim',         { 'on_cmd' : 'Goyo', 'loadconf' : 1}],
                \ ['Yggdroot/LeaderF', {'merged' : 0}],
                \ ['google/vim-searchindex'],
                \ ['tweekmonster/helpful.vim',      {'on_cmd': 'HelpfulVersion'}],
                \ ['simnalamburt/vim-mundo',        { 'on_cmd' : 'MundoToggle'}],
                \ ['wsdjeg/MarkDown.pl',            { 'on_cmd' : 'MarkDownPreview'}],
                \ ['mhinz/vim-grepper' , { 'on_cmd' : 'Grepper', 'loadconf' : 1} ],
                \ ['tpope/vim-projectionist',{'on_cmd':['A','AS','AV','AT','AD','Cd','Lcd','ProjectDo']}],
                \ ['ntpeters/vim-better-whitespace',{'on_cmd' : 'StripWhitespace'}],
                \ ['junegunn/rainbow_parentheses.vim',{'on_cmd' : 'RainbowParentheses'}],
                \ ['tyru/open-browser.vim',         {
                \'on_cmd' : ['OpenBrowserSmartSearch','OpenBrowser','OpenBrowserSearch'],
                \'on_map' : '<Plug>(openbrowser-',
                \ 'loadconf' : 1,
                \}],
                \ ['godlygeek/tabular',         { 'on_cmd': 'Tabularize'}],
                \ ['airblade/vim-gitgutter',{'on_cmd' : 'GitGutterEnable'}],
                \ ['itchyny/calendar.vim',      { 'on_cmd' : 'Calendar'}],
                \ ['wsdjeg/Mysql.vim',                       { 'on_cmd' : 'SQLGetConnection'}],
                \ ['wsdjeg/job.vim',                        { 'merged' : 0}],
                \ ]
endfunction

function! SpaceVim#layers#tools#config() abort
    nnoremap <silent> <F7> :MundoToggle<CR>
    augroup rainbow_lisp
        autocmd!
        autocmd FileType lisp,clojure,scheme,java RainbowParentheses
    augroup END
    let g:rainbow#max_level = 16
    let g:rainbow#pairs = [['(', ')'], ['[', ']'],['{','}']]
    " List of colors that you do not want. ANSI code or #RRGGBB
    let g:rainbow#blacklist = [233, 234]
endfunction
