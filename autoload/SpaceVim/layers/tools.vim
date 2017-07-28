function! SpaceVim#layers#tools#plugins() abort
  return [
        \ ['tpope/vim-scriptease'],
        \ ['mbbill/fencview',                 { 'on_cmd' : 'FencAutoDetect'}],
        \ ['SpaceVim/cscope.vim'],
        \ ['wsdjeg/vim-cheat',                { 'on_cmd' : 'Cheat'}],
        \ ['wsdjeg/SourceCounter.vim',        { 'on_cmd' : 'SourceCounter'}],
        \ ['junegunn/goyo.vim',               { 'on_cmd' : 'Goyo',
        \ 'loadconf' : 1}],
        \ ['junegunn/limelight.vim',          { 'on_cmd' : 'Limelight'}],
        \ ['Yggdroot/LeaderF',                { 'on_cmd' : 'LeaderfFile',
        \ 'loadconf' : 1,
        \ 'merged' : 0}],
        \ ['MattesGroeger/vim-bookmarks',     { 'on_map' : '<Plug>Bookmark',
        \ 'loadconf_before' : 1}],
        \ ['simnalamburt/vim-mundo',          { 'on_cmd' : 'MundoToggle'}],
        \ ['mhinz/vim-grepper' ,              { 'on_cmd' : 'Grepper',
        \ 'loadconf' : 1} ],
        \ ['tpope/vim-projectionist',         { 'on_cmd' : ['A', 'AS', 'AV',
        \ 'AT', 'AD', 'Cd', 'Lcd', 'ProjectDo']}],
        \ ['ntpeters/vim-better-whitespace',  { 'on_cmd' : 'StripWhitespace'}],
        \ ['junegunn/rainbow_parentheses.vim',
        \ { 'on_cmd' : 'RainbowParentheses'}],
        \ ['tyru/open-browser.vim', {
        \'on_cmd' : ['OpenBrowserSmartSearch', 'OpenBrowser',
        \ 'OpenBrowserSearch'],
        \'on_map' : '<Plug>(openbrowser-',
        \ 'loadconf' : 1,
        \}],
        \ ['godlygeek/tabular',           { 'on_cmd' : 'Tabularize'}],
        \ ['airblade/vim-gitgutter',      { 'on_cmd' : 'GitGutterEnable'}],
        \ ['itchyny/calendar.vim',        { 'on_cmd' : 'Calendar'}],
        \ ['wsdjeg/Mysql.vim',            { 'on_cmd' : 'SQLGetConnection'}],
        \ ['wsdjeg/job.vim',              { 'merged' : 0}],
        \ ['junegunn/fzf',                { 'on_cmd' : 'FZF'}],
        \ ['ianva/vim-youdao-translater', { 'on_cmd' : ['Ydv','Ydc','Yde']}],
        \ ['vim-scripts/TaskList.vim',                { 'on_cmd' : 'TaskList'}],
        \ ['MarcWeber/vim-addon-mw-utils'],
        \ ['vim-scripts/taglist.vim',         { 'on_cmd' : 'TlistToggle', 'loadconf' : 1}],
        \ ['scrooloose/nerdtree', { 'on_cmd' : 'NERDTreeToggle',
        \ 'loadconf' : 1}],
        \ ['Xuyuanp/nerdtree-git-plugin'],
        \ ['lymslive/vimloo', {'merged' : 0}],
        \ ['lymslive/vnote', {'depends' : 'vimloo',
        \ 'on_cmd' : ['NoteBook','NoteNew','NoteEdit', 'NoteList', 'NoteConfig', 'NoteIndex', 'NoteImport']}],
        \ ]
endfunction

function! SpaceVim#layers#tools#config() abort
  let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'leaderGuide']
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'c'], 'Calendar', 'vim calendar', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'a'], 'FencAutoDetect',
        \ 'Auto detect the file encoding', 1)
  nmap mm <Plug>BookmarkToggle
  nmap mi <Plug>BookmarkAnnotate
  nmap ma <Plug>BookmarkShowAll
  nmap mn <Plug>BookmarkNext
  nmap mp <Plug>BookmarkPrev
  nnoremap <silent> <F7> :MundoToggle<CR>
  augroup rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme,java RainbowParentheses
  augroup END
  let g:rainbow#max_level = 16
  let g:rainbow#pairs = [['(', ')'], ['[', ']'],['{','}']]
  " List of colors that you do not want. ANSI code or #RRGGBB
  let g:rainbow#blacklist = [233, 234]
  nnoremap <Leader>fz :FZF<CR>
  if maparg('<C-l>', 'v') ==# ''
    vnoremap <silent> <C-l> <Esc>:Ydv<CR>
  endif
  if maparg('<C-l>', 'n') ==# ''
    nnoremap <silent> <C-l> <Esc>:Ydc<CR>
  endif
  map <Leader>td <Plug>TaskList
  noremap <silent> <F8> :TlistToggle<CR>
  function! OpenOrCloseNERDTree() abort
    exec 'normal! A'
  endfunction
  if g:spacevim_filemanager ==# 'nerdtree'
    noremap <silent> <F3> :NERDTreeToggle<CR>
  endif
  let g:NERDTreeWinPos=get(g:,'NERDTreeWinPos','right')
  let g:NERDTreeWinSize=get(g:,'NERDTreeWinSize',31)
  let g:NERDTreeChDirMode=get(g:,'NERDTreeChDirMode',1)
  augroup nerdtree_zvim
    autocmd!
    autocmd bufenter *
          \ if (winnr('$') == 1 && exists('b:NERDTree')
          \ && b:NERDTree.isTabTree())
          \|   q
          \| endif
    autocmd FileType nerdtree nnoremap <silent><buffer><Space>
          \ :call OpenOrCloseNERDTree()<cr>
  augroup END
endfunction

" vim:set et sw=2 cc=80:
