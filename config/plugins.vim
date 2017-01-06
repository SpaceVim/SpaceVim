scriptencoding utf-8
let s:plugins = {}

let s:plugins.core = [
            \ ['Shougo/vimproc.vim', {'build' : 'make'}],
            \ ]

let s:plugins.chinese = [
            \ ['vimcn/vimcdoc'],
            \ ]

let s:plugins.colorscheme = [
            \ ['morhetz/gruvbox', {'loadconf' : 1}],
            \ ['kristijanhusak/vim-hybrid-material'],
            \ ['altercation/vim-colors-solarized'],
            \ ['nanotech/jellybeans.vim'],
            \ ['mhartington/oceanic-next'],
            \ ['mhinz/vim-janah'],
            \ ['tomasr/molokai'],
            \ ['kabbamine/yowish.vim'],
            \ ['vim-scripts/wombat256.vim'],
            \ ['vim-scripts/twilight256.vim'],
            \ ['junegunn/seoul256.vim'],
            \ ['vim-scripts/rdark-terminal2.vim'],
            \ ['vim-scripts/pyte'],
            \ ['joshdick/onedark.vim'],
            \ ['fmoralesc/molokayo'],
            \ ['jonathanfilip/vim-lucius'],
            \ ['wimstefan/Lightning'],
            \ ['w0ng/vim-hybrid'],
            \ ['scheakur/vim-scheakur'],
            \ ['keith/parsec.vim'],
            \ ['NLKNguyen/papercolor-theme'],
            \ ['romainl/flattened'],
            \ ['MaxSt/FlatColor'],
            \ ['chase/focuspoint-vim'],
            \ ['chriskempson/base16-vim'],
            \ ['gregsexton/Atom'],
            \ ['gilgigilgil/anderson.vim'],
            \ ['romainl/Apprentice'],
            \ ]

let s:plugins.checkers = []
if g:spacevim_enable_neomake
    call add(s:plugins.checkers, ['neomake/neomake',{'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}])
else
    call add(s:plugins.checkers, ['wsdjeg/syntastic', {'on_event': 'WinEnter', 'loadconf' : 1, 'merged' : 0}])
endif


let s:plugins.unite = [
            \ ['Shougo/unite.vim',{ 'merged' : 0 , 'loadconf' : 1}],
            \ ['Shougo/neoyank.vim'],
            \ ['soh335/unite-qflist'],
            \ ['ujihisa/unite-equery'],
            \ ['m2mdas/unite-file-vcs'],
            \ ['Shougo/neomru.vim'],
            \ ['kmnk/vim-unite-svn'],
            \ ['basyura/unite-rails'],
            \ ['nobeans/unite-grails'],
            \ ['choplin/unite-vim_hacks'],
            \ ['mattn/webapi-vim'],
            \ ['mattn/gist-vim', {'loadconf' : 1}],
            \ ['gist-vim'],
            \ ['henices/unite-stock'],
            \ ['mattn/wwwrenderer-vim'],
            \ ['thinca/vim-openbuf'],
            \ ['ujihisa/unite-haskellimport'],
            \ ['oppara/vim-unite-cake'],
            \ ['thinca/vim-ref', {'loadconf' : 1}],
            \ ['heavenshell/unite-zf'],
            \ ['heavenshell/unite-sf2'],
            \ ['osyo-manga/unite-vimpatches'],
            \ ['Shougo/unite-outline'],
            \ ['hewes/unite-gtags' ,{'loadconf' : 1}],
            \ ['rafi/vim-unite-issue'],
            \ ['joker1007/unite-pull-request'],
            \ ['tsukkee/unite-tag'],
            \ ['ujihisa/unite-launch'],
            \ ['ujihisa/unite-gem'],
            \ ['osyo-manga/unite-filetype'],
            \ ['thinca/vim-unite-history'],
            \ ['Shougo/neobundle-vim-recipes'],
            \ ['Shougo/unite-help'],
            \ ['ujihisa/unite-locate'],
            \ ['kmnk/vim-unite-giti'],
            \ ['ujihisa/unite-font'],
            \ ['t9md/vim-unite-ack'],
            \ ['mileszs/ack.vim',{'on_cmd' : 'Ack'}],
            \ ['albfan/ag.vim',{'on_cmd' : 'Ag' , 'loadconf' : 1}],
            \ ['dyng/ctrlsf.vim',{'on_cmd' : 'CtrlSF', 'on_map' : '<Plug>CtrlSF', 'loadconf' : 1 , 'loadconf_before' : 1}],
            \ ['daisuzu/unite-adb'],
            \ ['osyo-manga/unite-airline_themes'],
            \ ['mattn/unite-vim_advent-calendar'],
            \ ['mattn/unite-remotefile'],
            \ ['sgur/unite-everything'],
            \ ['kannokanno/unite-dwm'],
            \ ['raw1z/unite-projects'],
            \ ['voi/unite-ctags'],
            \ ['Shougo/unite-session'],
            \ ['osyo-manga/unite-quickfix'],
            \ ['Shougo/vimfiler.vim',{'on_cmd' : 'VimFiler', 'loadconf' : 1 , 'loadconf_before' : 1}],
            \ ['ujihisa/unite-colorscheme'],
            \ ['mattn/unite-gist'],
            \ ['tacroe/unite-mark'],
            \ ['tacroe/unite-alias'],
            \ ['tex/vim-unite-id'],
            \ ['sgur/unite-qf'],
            \ ['lambdalisue/vim-gista-unite'],
            \ ['wsdjeg/unite-radio.vim', {'loadconf' : 1}],
            \ ['lambdalisue/unite-grep-vcs', {
            \ 'autoload': {
            \    'unite_sources': ['grep/git', 'grep/hg'],
            \ }}],
            \ ['lambdalisue/vim-gista', {
            \ 'on_cmd': 'Gista'
            \ }],
            \ ]

if g:spacevim_enable_googlesuggest
    call add(s:plugins.unite, ['mopp/googlesuggest-source.vim'])
    call add(s:plugins.unite, ['mattn/googlesuggest-complete-vim'])
endif
"call add(s:plugins.unite, ['ujihisa/quicklearn'])
let s:plugins.lang = [
            \ ['zchee/deoplete-jedi',                    { 'on_ft' : 'python'}],
            \ ['Shougo/neosnippet.vim',                  { 'on_i'  : 1 , 'on_ft' : 'neosnippet', 'loadconf' : 1}],
            \ ['davidhalter/jedi-vim',                   { 'on_ft' : 'python'}],
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
            \ ['wsdjeg/vim-dict',                        { 'on_ft' : 'java'}],
            \ ['wsdjeg/java_getset.vim',                 { 'on_ft' : 'java'}],
            \ ['wsdjeg/JavaUnit.vim',                    { 'on_ft' : 'java'}],
            \ ['vim-jp/vim-java',                        { 'on_ft' : 'java'}],
            \ ['syngan/vim-vimlint',                     { 'on_ft' : 'vim'}],
            \ ['ynkdir/vim-vimlparser',                  { 'on_ft' : 'vim'}],
            \ ['todesking/vint-syntastic',               { 'on_ft' : 'vim'}],
            \ ['plasticboy/vim-markdown',                { 'on_ft' : 'markdown'}],
            \ ['elixir-lang/vim-elixir',                 { 'on_ft' : 'elixir'}],
            \ ['racer-rust/vim-racer',                   { 'on_ft' : 'rust'}],
            \ ['PotatoesMaster/i3-vim-syntax',           { 'on_ft' : 'i3'}],
            \ ['isundil/vim-irssi-syntax',               { 'on_ft' : 'irssi'}],
            \ ['vimperator/vimperator.vim',              { 'on_ft' : 'vimperator'}],
            \ ]
if g:spacevim_enable_javacomplete2_py
    call add(s:plugins.lang , ['wsdjeg/vim-javacomplete2',               { 'on_ft' : ['java','jsp'], 'loadconf' : 1}])
else
    call add(s:plugins.lang , ['artur-shaik/vim-javacomplete2',          { 'on_ft' : ['java','jsp'], 'loadconf' : 1}])
endif
let s:plugins.chat = [
            \ ['wsdjeg/vim-chat',                        { 'merged' : 0}],
            \ ]

let s:plugins.denite = [
            \ ['Shougo/denite.nvim',{ 'merged' : 0, 'loadconf' : 1}],
            \ ]

let s:plugins.ctrlp = [
            \ ['ctrlpvim/ctrlp.vim', {'loadconf' : 1}],
            \ ['voronkovich/ctrlp-nerdtree.vim', { 'on_cmd' : 'CtrlPNerdTree'}],
            \ ['h14i/vim-ctrlp-buftab',          { 'on_cmd' : 'CtrlPBufTab'}],
            \ ['vim-scripts/ctrlp-cmdpalette',   { 'on_cmd' : 'CtrlPCmdPalette'}],
            \ ['mattn/ctrlp-windowselector',     { 'on_cmd' : 'CtrlPWindowSelector'}],
            \ ['the9ball/ctrlp-gtags',           { 'on_cmd' : ['CtrlPGtagsX','CtrlPGtagsF','CtrlPGtagsR']}],
            \ ['thiderman/ctrlp-project',        { 'on_cmd' : 'CtrlPProject'}],
            \ ['mattn/ctrlp-google',             { 'on_cmd' : 'CtrlPGoogle'}],
            \ ['ompugao/ctrlp-history',          { 'on_cmd' : ['CtrlPCmdHistory','CtrlPSearchHistory']}],
            \ ['pielgrzym/ctrlp-sessions',       { 'on_cmd' : ['CtrlPSessions','MkS']}],
            \ ['tacahiroy/ctrlp-funky',          { 'on_cmd' : 'CtrlPFunky'}],
            \ ['mattn/ctrlp-launcher',           { 'on_cmd' : 'CtrlPLauncher'}],
            \ ['sgur/ctrlp-extensions.vim',      { 'on_cmd' : ['CtrlPCmdline','CtrlPMenu','CtrlPYankring']}],
            \ ['FelikZ/ctrlp-py-matcher'],
            \ ['lambdalisue/vim-gista-ctrlp',    { 'on_cmd' : 'CtrlPGista'}],
            \ ['elentok/ctrlp-objects.vim',      { 'on_cmd' : [
            \'CtrlPModels',
            \'CtrlPViews',
            \'CtrlPControllers',
            \'CtrlPTemplates',
            \'CtrlPPresenters']}],
            \ ]
if !has('nvim')
    call add(s:plugins.ctrlp, ['wsdjeg/ctrlp-unity3d-docs',  { 'on_cmd' : 'CtrlPUnity3DDocs'}])
endif

function! s:load_plugins() abort
    for group in g:spacevim_plugin_groups
        for plugin in get(s:plugins, group, [])
            if len(plugin) == 2
                call zvim#plug#add(plugin[0], plugin[1])
                if zvim#plug#tap(split(plugin[0], '/')[-1]) && get(plugin[1], 'loadconf', 0 )
                    call zvim#plug#defind_hooks(split(plugin[0], '/')[-1])
                    if get(plugin[1], 'loadconf_before', 0 )
                        call zvim#plug#loadPluginBefore(split(plugin[0], '/')[-1])
                    endif
                endif
            else
                call zvim#plug#add(plugin[0])
            endif
        endfor
    endfor
endfunction

function! s:disable_plugins(plugin_list) abort
    for name in a:plugin_list
        call dein#disable(name)
    endfor
endfunction

if zvim#plug#enable_plug()
    call zvim#plug#begin(g:spacevim_plugin_bundle_dir)
    call zvim#plug#fetch()
    call s:load_plugins()

    if count(g:spacevim_plugin_groups, 'autocomplete') "{{{
        call zvim#plug#add('honza/vim-snippets',{'on_i' : 1})
        imap <silent><expr><TAB> zvim#tab()
        smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
        inoremap <silent><expr><CR> zvim#enter()
        inoremap <silent> <Leader><Tab> <C-r>=MyLeaderTabfunc()<CR>
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
        inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
        imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
        smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
        if g:spacevim_autocomplete_method ==# 'ycm' "{{{
            call zvim#plug#add('SirVer/ultisnips')
            let g:UltiSnipsExpandTrigger='<tab>'
            let g:UltiSnipsJumpForwardTrigger='<tab>'
            let g:UltiSnipsJumpBackwardTrigger='<S-tab>'
            let g:UltiSnipsSnippetsDir='~/DotFiles/snippets'
            call zvim#plug#add('ervandew/supertab')
            let g:SuperTabContextDefaultCompletionType = '<c-n>'
            let g:SuperTabDefaultCompletionType = '<C-n>'
            "autocmd InsertLeave * if pumvisible() ==# 0|pclose|endif
            let g:neobundle#install_process_timeout = 1500
            call zvim#plug#add('Valloric/YouCompleteMe')
            "let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
            "let g:ycm_confirm_extra_conf = 0
            let g:ycm_collect_identifiers_from_tags_files = 1
            let g:ycm_collect_identifiers_from_comments_and_strings = 1
            let g:ycm_key_list_select_completion = ['<C-TAB>', '<Down>']
            let g:ycm_key_list_previous_completion = ['<C-S-TAB>','<Up>']
            let g:ycm_seed_identifiers_with_syntax = 1
            let g:ycm_key_invoke_completion = '<leader><tab>'
            let g:ycm_semantic_triggers =  {
                        \   'c' : ['->', '.'],
                        \   'objc' : ['->', '.'],
                        \   'ocaml' : ['.', '#'],
                        \   'cpp,objcpp' : ['->', '.', '::'],
                        \   'perl' : ['->'],
                        \   'php' : ['->', '::'],
                        \   'cs,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
                        \   'java,jsp' : ['.'],
                        \   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
                        \   'ruby' : ['.', '::'],
                        \   'lua' : ['.', ':'],
                        \   'erlang' : [':'],
                        \ }
        elseif g:spacevim_autocomplete_method ==# 'neocomplete' "{{{
            call zvim#plug#add('Shougo/neocomplete', {
                        \ 'on_i' : 1,
                        \ })
            if zvim#plug#tap('neocomplete')
                call zvim#plug#defind_hooks('neocomplete.vim')
            endif
        elseif g:spacevim_autocomplete_method ==# 'neocomplcache' "{{{
            call zvim#plug#add('Shougo/neocomplcache.vim', {
                        \ 'on_i' : 1,
                        \ })
            if zvim#plug#tap('neocomplcache.vim')
                call zvim#plug#defind_hooks('neocomplcache.vim')
            endif
        elseif g:spacevim_autocomplete_method ==# 'deoplete'
            call zvim#plug#add('Shougo/deoplete.nvim', {
                        \ 'on_i' : 1,
                        \ })
            if zvim#plug#tap('deoplete.nvim')
                call zvim#plug#defind_hooks('deoplete.nvim')
            endif
        endif "}}}
        call zvim#plug#add('Shougo/neco-syntax',           { 'on_i' : 1})
        call zvim#plug#add('ujihisa/neco-look',            { 'on_i' : 1})
        call zvim#plug#add('Shougo/neco-vim',              { 'on_i' : 1})
        if !exists('g:necovim#complete_functions')
            let g:necovim#complete_functions = {}
        endif
        let g:necovim#complete_functions.Ref =
                    \ 'ref#complete'
        call zvim#plug#add('Shougo/context_filetype.vim',  { 'on_i' : 1})
        call zvim#plug#add('Shougo/neoinclude.vim',        { 'on_i' : 1})
        call zvim#plug#add('Shougo/neosnippet-snippets',   { 'merged' : 0})
        call zvim#plug#add('Shougo/neopairs.vim',          { 'on_i' : 1})
    endif "}}}


    if count(g:spacevim_plugin_groups, 'github') "{{{
        call zvim#plug#add('junegunn/vim-github-dashboard',      { 'on_cmd':['GHD','GHA','GHActivity','GHDashboard']})
    endif

    if count(g:spacevim_plugin_groups, 'vim') "{{{
        call zvim#plug#add('Shougo/vimshell.vim',                { 'on_cmd':['VimShell']})
        call zvim#plug#add('mattn/vim-terminal',                 { 'on_cmd':['Terminal']})
    endif
    call zvim#plug#add('tpope/vim-scriptease')
    call zvim#plug#add('tpope/vim-fugitive')
    call zvim#plug#add('cohama/agit.vim',                        { 'on_cmd':['Agit','AgitFile']})
    call zvim#plug#add('gregsexton/gitv',                        { 'on_cmd':['Gitv']})
    call zvim#plug#add('tpope/vim-surround')
    call zvim#plug#add('terryma/vim-multiple-cursors')
    let g:multi_cursor_next_key='<C-j>'
    let g:multi_cursor_prev_key='<C-k>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'

    "web plugins

    call zvim#plug#add('wsdjeg/SourceCounter.vim',               { 'on_cmd' : 'SourceCounter'})
    if zvim#plug#tap('java_getset.vim')
        call zvim#plug#defind_hooks('java_getset.vim')
    endif
    call zvim#plug#add('jaxbot/github-issues.vim',               { 'on_cmd' : 'Gissues'})
    call zvim#plug#add('wsdjeg/Mysql.vim',                       { 'on_cmd' : 'SQLGetConnection'})
    call zvim#plug#add('wsdjeg/vim-cheat',                       { 'on_cmd' : 'Cheat'})
    call zvim#plug#add('wsdjeg/job.vim',                        { 'merged' : 0})
    call zvim#plug#add('wsdjeg/GitHub-api.vim')
    call zvim#plug#add('vim-airline/vim-airline',                { 'merged' : 0})
    call zvim#plug#add('vim-airline/vim-airline-themes',         { 'merged' : 0})
    if zvim#plug#tap('vim-airline')
        call zvim#plug#defind_hooks('vim-airline')
    endif
    call zvim#plug#add('mattn/emmet-vim',                        { 'on_cmd' : 'EmmetInstall'})
    let g:user_emmet_install_global = 0
    let g:user_emmet_leader_key='<C-e>'
    let g:user_emmet_mode='a'
    let g:user_emmet_settings = {
                \  'jsp' : {
                \      'extends' : 'html',
                \  },
                \}
    " use this two command to find how long the plugin take!
    "profile start vim-javacomplete2.log
    "profile! file */vim-javacomplete2/*
    call zvim#plug#add('gcmt/wildfire.vim',{'on_map' : '<Plug>(wildfire-'})
    noremap <SPACE> <Plug>(wildfire-fuel)
    vnoremap <C-SPACE> <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it']

    call zvim#plug#add('scrooloose/nerdcommenter')
    call zvim#plug#add('easymotion/vim-easymotion',{'on_map' : '<Plug>(easymotion-prefix)'})
    if zvim#plug#tap('vim-easymotion')
        map <Leader><Leader> <Plug>(easymotion-prefix)
    endif

    call zvim#plug#add('MarcWeber/vim-addon-mw-utils')
    call zvim#plug#add('mhinz/vim-startify')
    if zvim#plug#tap('vim-startify')
        call zvim#plug#defind_hooks('vim-startify')
    endif
    call zvim#plug#add('mhinz/vim-signify')
    let g:signify_disable_by_default = 0
    let g:signify_line_highlight = 0
    call zvim#plug#add('mhinz/vim-grepper' , { 'on_cmd' : 'Grepper' } )
    if zvim#plug#tap('vim-grepper')
        call zvim#plug#defind_hooks('vim-grepper')
    endif
    call zvim#plug#add('airblade/vim-rooter')
    let g:rooter_silent_chdir = 1
    call zvim#plug#add('Yggdroot/indentLine')
    let g:indentLine_color_term = 239
    let g:indentLine_color_gui = '#09AA08'
    let g:indentLine_char = '¦'
    let g:indentLine_concealcursor = 'niv' " (default 'inc')
    let g:indentLine_conceallevel = 2  " (default 2)
    let g:indentLine_fileTypeExclude = ['help']
    call zvim#plug#add('godlygeek/tabular',         { 'on_cmd': 'Tabularize'})
    call zvim#plug#add('benizi/vim-automkdir')
    "[c  ]c  jump between prev or next hunk
    call zvim#plug#add('airblade/vim-gitgutter',{'on_cmd' : 'GitGutterEnable'})
    call zvim#plug#add('itchyny/calendar.vim',      { 'on_cmd' : 'Calendar'})
    call zvim#plug#add('lilydjwg/fcitx.vim',        { 'on_i' : 1})
    call zvim#plug#add('junegunn/goyo.vim',         { 'on_cmd' : 'Goyo'})
    if zvim#plug#tap('goyo.vim')
        call zvim#plug#defind_hooks('goyo.vim')
    endif
    "vim Wimdows config
    call zvim#plug#add('scrooloose/nerdtree',{'on_cmd':'NERDTreeToggle'})
    if zvim#plug#tap('nerdtree')
        call zvim#plug#defind_hooks('nerdtree')
        function! OpenOrCloseNERDTree()
            exec 'normal! A'
        endfunction
        noremap <silent> <F9> :NERDTreeToggle<CR>
        let g:NERDTreeWinPos='right'
        let g:NERDTreeWinSize=31
        let g:NERDTreeChDirMode=1
        autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
        augroup nerdtree_zvim
            autocmd!
            autocmd FileType nerdtree nnoremap <silent><buffer><Space> :call OpenOrCloseNERDTree()<cr>
        augroup END
    endif
    call zvim#plug#add('tpope/vim-projectionist',{'on_cmd':['A','AS','AV','AT','AD','Cd','Lcd','ProjectDo']})
    call zvim#plug#add('Xuyuanp/nerdtree-git-plugin')
    call zvim#plug#add('taglist.vim',{'on_cmd' : 'TlistToggle'})
    if zvim#plug#tap('taglist.vim')
        call zvim#plug#defind_hooks('taglist.vim')
        noremap <silent> <F8> :TlistToggle<CR>
    endif
    call zvim#plug#add('ntpeters/vim-better-whitespace',{'on_cmd' : 'StripWhitespace'})
    call zvim#plug#add('junegunn/rainbow_parentheses.vim',{'on_cmd' : 'RainbowParentheses'})
    augroup rainbow_lisp
        autocmd!
        autocmd FileType lisp,clojure,scheme,java RainbowParentheses
    augroup END
    let g:rainbow#max_level = 16
    let g:rainbow#pairs = [['(', ')'], ['[', ']'],['{','}']]
    " List of colors that you do not want. ANSI code or #RRGGBB
    let g:rainbow#blacklist = [233, 234]
    call zvim#plug#add('majutsushi/tagbar')
    if zvim#plug#tap('tagbar')
        call zvim#plug#defind_hooks('tagbar')
        noremap <silent> <F2> :TagbarToggle<CR>
    endif
    "}}}

    call zvim#plug#add('floobits/floobits-neovim',      { 'on_cmd' : ['FlooJoinWorkspace','FlooShareDirPublic','FlooShareDirPrivate']})
    call zvim#plug#add('wsdjeg/MarkDown.pl',            { 'on_cmd' : 'MarkDownPreview'})
    "call zvim#plug#add('plasticboy/vim-markdown',       { 'on_ft' : 'markdown'})
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_folding_disabled = 1
    call zvim#plug#add('simnalamburt/vim-mundo',        { 'on_cmd' : 'MundoToggle'})
    nnoremap <silent> <F7> :MundoToggle<CR>
    call zvim#plug#add('TaskList.vim',                  { 'on_cmd' : 'TaskList'})
    map <unique> <Leader>td <Plug>TaskList
    call zvim#plug#add('ianva/vim-youdao-translater',   { 'on_cmd' : ['Ydv','Ydc','Yde']})
    vnoremap <silent> <C-l> <Esc>:Ydv<CR>
    nnoremap <silent> <C-l> <Esc>:Ydc<CR>
    call zvim#plug#add('editorconfig/editorconfig-vim', { 'on_cmd' : 'EditorConfigReload'})
    call zvim#plug#add('junegunn/fzf',                  { 'on_cmd' : 'FZF'})
    nnoremap <Leader>fz :FZF<CR>
    call zvim#plug#add('junegunn/gv.vim',               { 'on_cmd' : 'GV'})
    call zvim#plug#add('tyru/open-browser.vim',         {
                \'on_cmd' : ['OpenBrowserSmartSearch','OpenBrowser','OpenBrowserSearch'],
                \'on_map' : '<Plug>(openbrowser-',
                \})
    if zvim#plug#tap('open-brower.vim')
        call zvim#plug#defind_hooks('open-brower.vim')
    endif
    "call zvim#plug#add('racer-rust/vim-racer',          {'on_ft' : 'rust'})
    let g:racer_cmd = $HOME.'/.cargo/bin/racer'
    call zvim#plug#add('rust-lang/rust.vim')
    call zvim#plug#add('lambdalisue/vim-gita',          {'on_cmd': 'Gita'})
    call zvim#plug#add('tweekmonster/helpful.vim',      {'on_cmd': 'HelpfulVersion'})
    " google plugins
    call zvim#plug#add('google/vim-searchindex')
    call zvim#plug#add('Yggdroot/LeaderF', {'merged' : 0})

    call s:disable_plugins(g:spacevim_disabled_plugins)

    call zvim#plug#end()
endif
