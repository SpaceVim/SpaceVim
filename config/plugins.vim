scriptencoding utf-8

if zvim#plug#enable_plug()
    call zvim#plug#begin(g:settings.plugin_bundle_dir)
    call zvim#plug#fetch()
    if count(g:settings.plugin_groups, 'core') "{{{
        call zvim#plug#add('Shougo/vimproc.vim', {'build': 'make'})
    endif
    if count(g:settings.plugin_groups, 'denite')
        call zvim#plug#add('Shougo/denite.nvim',{ 'merged' : 0})
        if zvim#plug#tap('denite.nvim')
            call zvim#plug#defind_hooks('denite.nvim')
        endif
    endif
    if count(g:settings.plugin_groups, 'unite') "{{{
        call zvim#plug#add('Shougo/unite.vim',{ 'merged' : 0})
        if zvim#plug#tap('unite.vim')
            call zvim#plug#defind_hooks('unite.vim')
        endif
        call zvim#plug#add('Shougo/neoyank.vim')
        call zvim#plug#add('soh335/unite-qflist')
        call zvim#plug#add('ujihisa/unite-equery')
        call zvim#plug#add('m2mdas/unite-file-vcs')
        call zvim#plug#add('Shougo/neomru.vim')
        call zvim#plug#add('kmnk/vim-unite-svn')
        call zvim#plug#add('basyura/unite-rails')
        call zvim#plug#add('nobeans/unite-grails')
        call zvim#plug#add('choplin/unite-vim_hacks')
        call zvim#plug#add('mattn/webapi-vim')
        call zvim#plug#add('mattn/gist-vim')
        if zvim#plug#tap('gist-vim')
            call zvim#plug#defind_hooks('gist-vim')
        endif
        call zvim#plug#add('henices/unite-stock')
        call zvim#plug#add('mattn/wwwrenderer-vim')
        call zvim#plug#add('thinca/vim-openbuf')
        call zvim#plug#add('ujihisa/unite-haskellimport')
        call zvim#plug#add('oppara/vim-unite-cake')
        call zvim#plug#add('thinca/vim-ref')
        if zvim#plug#tap('vim-ref')
            call zvim#plug#defind_hooks('vim-ref')
        endif
        call zvim#plug#add('heavenshell/unite-zf')
        call zvim#plug#add('heavenshell/unite-sf2')
        call zvim#plug#add('osyo-manga/unite-vimpatches')
        call zvim#plug#add('Shougo/unite-outline')
        call zvim#plug#add('hewes/unite-gtags')
        if zvim#plug#tap('unite-gtags')
            call zvim#plug#defind_hooks('unite-gtags')
        endif
        call zvim#plug#add('rafi/vim-unite-issue')
        call zvim#plug#add('joker1007/unite-pull-request')
        call zvim#plug#add('tsukkee/unite-tag')
        call zvim#plug#add('ujihisa/unite-launch')
        call zvim#plug#add('ujihisa/unite-gem')
        call zvim#plug#add('osyo-manga/unite-filetype')
        call zvim#plug#add('thinca/vim-unite-history')
        call zvim#plug#add('Shougo/neobundle-vim-recipes')
        call zvim#plug#add('Shougo/unite-help')
        call zvim#plug#add('ujihisa/unite-locate')
        call zvim#plug#add('kmnk/vim-unite-giti')
        call zvim#plug#add('ujihisa/unite-font')
        call zvim#plug#add('t9md/vim-unite-ack')
        call zvim#plug#add('mileszs/ack.vim',{'on_cmd' : 'Ack'})
        call zvim#plug#add('albfan/ag.vim',{'on_cmd' : 'Ag'})
        let g:ag_prg='ag  --vimgrep'
        let g:ag_working_path_mode='r'
        call zvim#plug#add('dyng/ctrlsf.vim',{'on_cmd' : 'CtrlSF', 'on_map' : '<Plug>CtrlSF'})
        if zvim#plug#tap('ctrlsf.vim')
            call zvim#plug#defind_hooks('ctrlsf.vim')
            nmap <silent><leader>sn <Plug>CtrlSFCwordExec
        endif
        call zvim#plug#add('daisuzu/unite-adb')
        call zvim#plug#add('osyo-manga/unite-airline_themes')
        call zvim#plug#add('mattn/unite-vim_advent-calendar')
        call zvim#plug#add('mattn/unite-remotefile')
        call zvim#plug#add('sgur/unite-everything')
        call zvim#plug#add('kannokanno/unite-dwm')
        call zvim#plug#add('raw1z/unite-projects')
        call zvim#plug#add('voi/unite-ctags')
        call zvim#plug#add('Shougo/unite-session')
        call zvim#plug#add('osyo-manga/unite-quickfix')
        call zvim#plug#add('Shougo/vimfiler.vim',{'on_cmd' : 'VimFiler'})
        if zvim#plug#tap('vimfiler.vim')
            call zvim#plug#defind_hooks('vimfiler.vim')
            noremap <silent> <F3> :call zvim#util#OpenVimfiler()<CR>
        endif
        if g:settings.enable_googlesuggest
            call zvim#plug#add('mopp/googlesuggest-source.vim')
            call zvim#plug#add('mattn/googlesuggest-complete-vim')
        endif
        call zvim#plug#add('ujihisa/unite-colorscheme')
        call zvim#plug#add('mattn/unite-gist')
        call zvim#plug#add('tacroe/unite-mark')
        call zvim#plug#add('tacroe/unite-alias')
        call zvim#plug#add('tex/vim-unite-id')
        call zvim#plug#add('sgur/unite-qf')
        call zvim#plug#add('lambdalisue/unite-grep-vcs', {
                    \ 'autoload': {
                    \    'unite_sources': ['grep/git', 'grep/hg'],
                    \}})
        call zvim#plug#add('lambdalisue/vim-gista', {
                    \ 'on_cmd': 'Gista'
                    \})
        call zvim#plug#add('lambdalisue/vim-gista-unite')
        call zvim#plug#add('wsdjeg/unite-radio.vim')
        let g:unite_source_radio_play_cmd='mpv'
        "call zvim#plug#add('ujihisa/quicklearn')
    endif "}}}


    "{{{ctrlpvim settings
    if count(g:settings.plugin_groups, 'ctrlp') "{{{
        call zvim#plug#add('ctrlpvim/ctrlp.vim')
        if zvim#plug#tap('ctrlp.vim')
            call zvim#plug#defind_hooks('ctrlp.vim')
        endif
        if !has('nvim')
            call zvim#plug#add('wsdjeg/ctrlp-unity3d-docs',  { 'on_cmd' : 'CtrlPUnity3DDocs'})
        endif
        call zvim#plug#add('voronkovich/ctrlp-nerdtree.vim', { 'on_cmd' : 'CtrlPNerdTree'})
        call zvim#plug#add('elentok/ctrlp-objects.vim',      { 'on_cmd' : [
                    \'CtrlPModels',
                    \'CtrlPViews',
                    \'CtrlPControllers',
                    \'CtrlPTemplates',
                    \'CtrlPPresenters']})
        call zvim#plug#add('h14i/vim-ctrlp-buftab',          { 'on_cmd' : 'CtrlPBufTab'})
        call zvim#plug#add('vim-scripts/ctrlp-cmdpalette',   { 'on_cmd' : 'CtrlPCmdPalette'})
        call zvim#plug#add('mattn/ctrlp-windowselector',     { 'on_cmd' : 'CtrlPWindowSelector'})
        call zvim#plug#add('the9ball/ctrlp-gtags',           { 'on_cmd' : ['CtrlPGtagsX','CtrlPGtagsF','CtrlPGtagsR']})
        call zvim#plug#add('thiderman/ctrlp-project',        { 'on_cmd' : 'CtrlPProject'})
        call zvim#plug#add('mattn/ctrlp-google',             { 'on_cmd' : 'CtrlPGoogle'})
        call zvim#plug#add('ompugao/ctrlp-history',          { 'on_cmd' : ['CtrlPCmdHistory','CtrlPSearchHistory']})
        call zvim#plug#add('pielgrzym/ctrlp-sessions',       { 'on_cmd' : ['CtrlPSessions','MkS']})
        call zvim#plug#add('tacahiroy/ctrlp-funky',          { 'on_cmd' : 'CtrlPFunky'})
        call zvim#plug#add('mattn/ctrlp-launcher',           { 'on_cmd' : 'CtrlPLauncher'})
        call zvim#plug#add('sgur/ctrlp-extensions.vim',      { 'on_cmd' : ['CtrlPCmdline','CtrlPMenu','CtrlPYankring']})
        call zvim#plug#add('FelikZ/ctrlp-py-matcher')
        call zvim#plug#add('lambdalisue/vim-gista-ctrlp',    { 'on_cmd' : 'CtrlPGista'})
    endif "}}}


    if count(g:settings.plugin_groups, 'autocomplete') "{{{
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
        if g:settings.autocomplete_method ==# 'ycm' "{{{
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
        elseif g:settings.autocomplete_method ==# 'neocomplete' "{{{
            call zvim#plug#add('Shougo/neocomplete', {
                        \ 'on_i' : 1,
                        \ })
            if zvim#plug#tap('neocomplete')
                call zvim#plug#defind_hooks('neocomplete.vim')
            endif
        elseif g:settings.autocomplete_method ==# 'neocomplcache' "{{{
            call zvim#plug#add('Shougo/neocomplcache.vim', {
                        \ 'on_i' : 1,
                        \ })
            if zvim#plug#tap('neocomplcache.vim')
                call zvim#plug#defind_hooks('neocomplcache.vim')
            endif
        elseif g:settings.autocomplete_method ==# 'deoplete'
            call zvim#plug#add('Shougo/deoplete.nvim', {
                        \ 'on_i' : 1,
                        \ })
            if zvim#plug#tap('deoplete.nvim')
                call zvim#plug#defind_hooks('deoplete.nvim')
            endif
            call zvim#plug#add('zchee/deoplete-jedi',      { 'on_ft' : 'python'})
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
        call zvim#plug#add('Shougo/neosnippet.vim',        { 'on_i' : 1 , 'on_ft' : 'neosnippet'})
        if zvim#plug#tap('neosnippet.vim')
            call zvim#plug#defind_hooks('neosnippet.vim')
        endif
        call zvim#plug#add('Shougo/neopairs.vim',          { 'on_i' : 1})
    endif "}}}

    if count(g:settings.plugin_groups, 'colorscheme') "{{{
        "colorscheme
        call zvim#plug#add('morhetz/gruvbox')
        if zvim#plug#tap('gruvbox')
            call zvim#plug#defind_hooks('gruvbox')
        endif
        call zvim#plug#add('kabbamine/yowish.vim')
        call zvim#plug#add('tomasr/molokai')
        call zvim#plug#add('mhinz/vim-janah')
        call zvim#plug#add('mhartington/oceanic-next')
        call zvim#plug#add('nanotech/jellybeans.vim')
        call zvim#plug#add('altercation/vim-colors-solarized')
        call zvim#plug#add('kristijanhusak/vim-hybrid-material')
    endif

    if count(g:settings.plugin_groups, 'chinese') "{{{
        call zvim#plug#add('vimcn/vimcdoc')
    endif

    call zvim#plug#add('junegunn/vim-github-dashboard',      { 'on_cmd':['GHD','GHA','GHActivity','GHDashboard']})
    if count(g:settings.plugin_groups, 'vim') "{{{
        call zvim#plug#add('Shougo/vimshell.vim',                { 'on_cmd':['VimShell']})
        call zvim#plug#add('mattn/vim-terminal',                 { 'on_cmd':['Terminal']})
        call zvim#plug#add('davidhalter/jedi-vim',     { 'on_ft' : 'python'})
        if zvim#plug#tap('jedi-vim')
            call zvim#plug#defind_hooks('jedi-vim')
        endif
    endif
    if count(g:settings.plugin_groups, 'nvim') "{{{
        call zvim#plug#add('m2mdas/phpcomplete-extended',            { 'on_ft' : 'php'})
        if zvim#plug#tap('phpcomplete-extended')
            call zvim#plug#defind_hooks('phpcomplete-extended')
        endif
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

    call zvim#plug#add('groenewege/vim-less',                    { 'on_ft':['less']})
    call zvim#plug#add('cakebaker/scss-syntax.vim',              { 'on_ft':['scss','sass']})
    call zvim#plug#add('hail2u/vim-css3-syntax',                 { 'on_ft':['css','scss','sass']})
    call zvim#plug#add('ap/vim-css-color',                       { 'on_ft':['css','scss','sass','less','styl']})
    call zvim#plug#add('othree/html5.vim',                       { 'on_ft':['html']})
    call zvim#plug#add('wavded/vim-stylus',                      { 'on_ft':['styl']})
    call zvim#plug#add('digitaltoad/vim-jade',                   { 'on_ft':['jade']})
    call zvim#plug#add('juvenn/mustache.vim',                    { 'on_ft':['mustache']})
    call zvim#plug#add('Valloric/MatchTagAlways',                { 'on_ft':['html' , 'xhtml' , 'xml' , 'jinja']})
    call zvim#plug#add('pangloss/vim-javascript',                { 'on_ft':['javascript']})
    call zvim#plug#add('maksimr/vim-jsbeautify',                 { 'on_ft':['javascript']})
    call zvim#plug#add('leafgarland/typescript-vim',             { 'on_ft':['typescript']})
    call zvim#plug#add('kchmck/vim-coffee-script',               { 'on_ft':['coffee']})
    call zvim#plug#add('mmalecki/vim-node.js',                   { 'on_ft':['javascript']})
    call zvim#plug#add('leshill/vim-json',                       { 'on_ft':['javascript','json']})
    call zvim#plug#add('othree/javascript-libraries-syntax.vim', { 'on_ft':['javascript','coffee','ls','typescript']})
    if g:settings.enable_javacomplete2_py
        call zvim#plug#add('wsdjeg/vim-javacomplete2',          { 'on_ft' : ['java','jsp']})
    else
        call zvim#plug#add('artur-shaik/vim-javacomplete2',          { 'on_ft' : ['java','jsp']})
    endif
    let g:JavaComplete_UseFQN = 1
    let g:JavaComplete_ServerAutoShutdownTime = 300
    let g:JavaComplete_MavenRepositoryDisable = 0
    call zvim#plug#add('wsdjeg/vim-dict',                        { 'on_ft' : 'java'})
    call zvim#plug#add('wsdjeg/SourceCounter.vim',               { 'on_cmd' : 'SourceCounter'})
    call zvim#plug#add('wsdjeg/java_getset.vim',                 { 'on_ft' : 'java'})
    if zvim#plug#tap('java_getset.vim')
        call zvim#plug#defind_hooks('java_getset.vim')
    endif
    call zvim#plug#add('wsdjeg/JavaUnit.vim',                    { 'on_ft' : 'java'})
    call zvim#plug#add('jaxbot/github-issues.vim',               { 'on_cmd' : 'Gissues'})
    call zvim#plug#add('wsdjeg/Mysql.vim',                       { 'on_cmd' : 'SQLGetConnection'})
    call zvim#plug#add('wsdjeg/vim-cheat',                       { 'on_cmd' : 'Cheat'})
    call zvim#plug#add('wsdjeg/vim-chat',                        { 'merged' : 0})
    call zvim#plug#add('wsdjeg/job.vim',                        { 'merged' : 0})
    call zvim#plug#add('wsdjeg/GitHub-api.vim')
    call zvim#plug#add('vim-jp/vim-java',                        { 'on_ft' : 'java'})
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
    if g:settings.enable_neomake
        call zvim#plug#add('neomake/neomake',{'merged' : 0})
        if zvim#plug#tap('neomake')
            call zvim#plug#defind_hooks('neomake')
            augroup Neomake_wsd
                au!
                autocmd! BufWritePost * Neomake
            augroup END
        endif
    else
        call zvim#plug#add('wsdjeg/syntastic', {'on_event': 'WinEnter'})
        if zvim#plug#tap('syntastic')
            call zvim#plug#defind_hooks('syntastic')
        endif
    endif
    call zvim#plug#add('syngan/vim-vimlint',{'on_ft' : 'vim'})
    let g:syntastic_vimlint_options = {
                \'EVL102': 1 ,
                \'EVL103': 1 ,
                \'EVL205': 1 ,
                \'EVL105': 1 ,
                \}
    call zvim#plug#add('ynkdir/vim-vimlparser',{'on_ft' : 'vim'})
    call zvim#plug#add('todesking/vint-syntastic',{'on_ft' : 'vim'})
    "let g:syntastic_vim_checkers = ['vint']
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
    call zvim#plug#add('plasticboy/vim-markdown',       { 'on_ft' : 'markdown'})
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_folding_disabled = 1
    call zvim#plug#add('simnalamburt/vim-mundo',        { 'on_cmd' : 'MundoToggle'})
    nnoremap <silent> <F7> :MundoToggle<CR>
    call zvim#plug#add('TaskList.vim',                  { 'on_cmd' : 'TaskList'})
    map <unique> <Leader>td <Plug>TaskList
    call zvim#plug#add('ianva/vim-youdao-translater',   { 'on_cmd' : ['Ydv','Ydc','Yde']})
    vnoremap <silent> <C-l> <Esc>:Ydv<CR>
    nnoremap <silent> <C-l> <Esc>:Ydc<CR>
    call zvim#plug#add('elixir-lang/vim-elixir',        { 'on_ft' : 'elixir'})
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
    call zvim#plug#add('racer-rust/vim-racer',          {'on_ft' : 'rust'})
    let g:racer_cmd = $HOME.'/.cargo/bin/racer'
    call zvim#plug#add('rust-lang/rust.vim')
    call zvim#plug#add('PotatoesMaster/i3-vim-syntax',  {'on_ft' : 'i3'})
    call zvim#plug#add('isundil/vim-irssi-syntax',  {'on_ft' : 'irssi'})
    call zvim#plug#add('vimperator/vimperator.vim',     {'on_ft' : 'vimperator'})
    call zvim#plug#add('lambdalisue/vim-gita',          {'on_cmd': 'Gita'})
    call zvim#plug#add('tweekmonster/helpful.vim',      {'on_cmd': 'HelpfulVersion'})
    " google plugins
    call zvim#plug#add('google/vim-searchindex')
    call zvim#plug#end()
endif
