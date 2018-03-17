"=============================================================================
" tools.vim --- SpaceVim tools layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#tools#plugins() abort
  let plugins = [
        \ ['tpope/vim-scriptease'],
        \ ['mbbill/fencview',                 { 'on_cmd' : 'FencAutoDetect'}],
        \ ['wsdjeg/vim-cheat',                { 'on_cmd' : 'Cheat'}],
        \ ['wsdjeg/SourceCounter.vim',        { 'on_cmd' : 'SourceCounter'}],
        \ ['junegunn/goyo.vim',               { 'on_cmd' : 'Goyo',
        \ 'loadconf' : 1}],
        \ ['junegunn/limelight.vim',          { 'on_cmd' : 'Limelight'}],
        \ ['MattesGroeger/vim-bookmarks',     { 'on_map' : '<Plug>Bookmark',
        \ 'on_cmd' : 'BookmarkShowAll',
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
        \ ['itchyny/calendar.vim',        { 'on_cmd' : 'Calendar'}],
        \ ['wsdjeg/Mysql.vim',            { 'on_cmd' : 'SQLGetConnection'}],
        \ ['wsdjeg/job.vim',              { 'merged' : 0}],
        \ ['ianva/vim-youdao-translater', { 'on_cmd' : ['Ydv','Ydc','Yde']}],
        \ ['vim-scripts/TaskList.vim',                { 'on_cmd' : 'TaskList'}],
        \ ['MarcWeber/vim-addon-mw-utils'],
        \ ['vim-scripts/taglist.vim',         { 'on_cmd' : 'TlistToggle', 'loadconf' : 1}],
        \ ['Xuyuanp/nerdtree-git-plugin'],
        \ ['lymslive/vimloo', {'merged' : 0}],
        \ ['lymslive/vnote', {'depends' : 'vimloo',
        \ 'on_cmd' : ['NoteBook','NoteNew','NoteEdit', 'NoteList', 'NoteConfig', 'NoteIndex', 'NoteImport']}],
        \ ]

  let s:CMP = SpaceVim#api#import('vim#compatible')
  if s:CMP.has('python')
    call add(plugins, ['gregsexton/VimCalc', {'on_cmd' : 'Calc'}])
  elseif s:CMP.has('python3')
    call add(plugins, ['fedorenchik/VimCalc3', {'on_cmd' : 'Calc'}])
  endif

  return plugins
endfunction

function! SpaceVim#layers#tools#config() abort
  let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'leaderGuide']
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'l'], 'Calendar', 'vim calendar', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'a'], 'FencAutoDetect',
        \ 'Auto detect the file encoding', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'c'], 'Calc', 'vim calculator', 1)
  nmap mm <Plug>BookmarkToggle
  nmap mi <Plug>BookmarkAnnotate
  nmap ma <Plug>BookmarkShowAll
  nmap mn <Plug>BookmarkNext
  nmap mp <Plug>BookmarkPrev
  nnoremap <silent> <F7> :MundoToggle<CR>
  augroup rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme,java RainbowParentheses
    autocmd FileType vimcalc setlocal nonu nornu nofoldenable | inoremap <silent> <buffer> <c-d> <c-[>:q<cr>
          \ | nnoremap <silent> <buffer> q :bdelete<cr>
  augroup END
  let g:rainbow#max_level = 16
  let g:rainbow#pairs = [['(', ')'], ['[', ']'],['{','}']]
  " List of colors that you do not want. ANSI code or #RRGGBB
  let g:rainbow#blacklist = [233, 234]
  if maparg('<C-_>', 'v') ==# ''
    vnoremap <silent> <C-_> <Esc>:Ydv<CR>
  endif
  if maparg('<C-_>', 'n') ==# ''
    nnoremap <silent> <C-_> <Esc>:Ydc<CR>
  endif
  noremap <silent> <F8> :TlistToggle<CR>
  if g:spacevim_filemanager ==# 'nerdtree'
    noremap <silent> <F3> :NERDTreeToggle<CR>
  endif
endfunction

" vim:set et sw=2 cc=80:
