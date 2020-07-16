"=============================================================================
" autocmd.vim --- main autocmd group for spacevim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:SYS = SpaceVim#api#import('system')
let s:JOB = SpaceVim#api#import('job')


"autocmds
function! SpaceVim#autocmds#init() abort
  augroup SpaceVim_core
    au!
    autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
          \   q :cclose<cr>:lclose<cr>
    autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
          \   bd|
          \   q | endif
    autocmd QuitPre * call SpaceVim#plugins#windowsmanager#UpdateRestoreWinInfo()
    autocmd WinEnter * call SpaceVim#plugins#windowsmanager#MarkBaseWin()
    if g:spacevim_relativenumber
      autocmd BufEnter,WinEnter * if &nu | set rnu   | endif
      autocmd BufLeave,WinLeave * if &nu | set nornu | endif
    endif
    autocmd BufRead,BufNewFile *.pp setfiletype puppet
    if g:spacevim_enable_cursorline == 1
      autocmd BufEnter,WinEnter,InsertLeave * call s:enable_cursorline()
      autocmd BufLeave,WinLeave,InsertEnter * call s:disable_cursorline()
    endif
    if g:spacevim_enable_cursorcolumn == 1
      autocmd BufEnter,WinEnter,InsertLeave * setl cursorcolumn
      autocmd BufLeave,WinLeave,InsertEnter * setl nocursorcolumn
    endif
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif
    autocmd BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
    autocmd BufWinLeave * let b:_winview = winsaveview()
    autocmd BufWinEnter * if(exists('b:_winview')) | call winrestview(b:_winview) | endif
    autocmd BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
    autocmd BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.
    autocmd FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
    autocmd FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,:///,://
    autocmd FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",:\"
    autocmd Filetype qf setlocal nobuflisted
    autocmd FileType python,coffee call SpaceVim#util#check_if_expand_tab()
    au StdinReadPost * call s:disable_welcome()
    autocmd InsertEnter * call s:fixindentline()
    autocmd BufEnter,FileType * call SpaceVim#mapping#space#refrashLSPC()
    if executable('synclient') && g:spacevim_auto_disable_touchpad
      let s:touchpadoff = 0
      autocmd InsertEnter * call s:disable_touchpad()
      autocmd InsertLeave * call s:enable_touchpad()
      autocmd FocusLost * call system('synclient touchpadoff=0')
      autocmd FocusGained * call s:reload_touchpad_status()
    endif
    autocmd BufWritePre * call SpaceVim#plugins#mkdir#CreateCurrent()
    autocmd BufWritePost *.vim call s:generate_doc()
    autocmd ColorScheme * call SpaceVim#api#import('vim#highlight').hide_in_normal('EndOfBuffer')
    autocmd ColorScheme gruvbox,jellybeans,nord,srcery,NeoSolarized call s:fix_colorschem_in_SpaceVim()
    autocmd VimEnter * call SpaceVim#autocmds#VimEnter()
    autocmd BufEnter * let b:_spacevim_project_name = get(g:, '_spacevim_project_name', '')
    autocmd SessionLoadPost * let g:_spacevim_session_loaded = 1
    autocmd VimLeavePre * call SpaceVim#plugins#manager#terminal()
  augroup END
endfunction

let g:_spacevim_cursorline_flag = -1
function! s:enable_cursorline() abort
  if g:_spacevim_cursorline_flag == -1
    setl cursorline
  endif
endfunction

function! s:disable_cursorline() abort
  if &filetype ==# 'denite'
  else
    setl nocursorline
  endif
endfunction

function! s:reload_touchpad_status() abort
  if s:touchpadoff
    call s:disable_touchpad()
  endif
endf
function! s:disable_touchpad() abort
  let s:touchpadoff = 1
  call system('synclient touchpadoff=1')
endfunction
function! s:enable_touchpad() abort
  let s:touchpadoff = 0
  call system('synclient touchpadoff=0')
endfunction
function! s:fixindentline() abort
  if !exists('s:done') && has('conceal')
    " The indentLine plugin need conceal feature
    if exists(':IndentLinesToggle') == 2
      IndentLinesToggle
      IndentLinesToggle
    else
      echohl WarningMsg
      echom 'plugin : indentLines has not been installed,
            \ please use `:call dein#install(["indentLine"])` to install this plugin,'
      echohl None
    endif
    let s:done = 1
  endif
endfunction
function! s:generate_doc() abort
  " neovim in windows executable function is broken
  " https://github.com/neovim/neovim/issues/9391
  if filereadable('./addon-info.json') && executable('vimdoc') && !s:SYS.isWindows
    call s:JOB.start(['vimdoc', '.'])
  elseif filereadable('./addon-info.json') && executable('python')
    call s:JOB.start(['python', '-m', 'vimdoc', '.'])
  endif
endfunction

function! s:fix_colorschem_in_SpaceVim() abort
  if &background ==# 'dark'
    if g:colors_name ==# 'gruvbox'
      hi VertSplit guibg=#282828 guifg=#181A1F
    elseif g:colors_name ==# 'jellybeans'
      hi VertSplit guibg=#151515 guifg=#080808
    elseif g:colors_name ==# 'nord'
      hi VertSplit guibg=#2E3440 guifg=#262626
    elseif g:colors_name ==# 'srcery'
      hi VertSplit guibg=#1C1B19 guifg=#262626
      hi clear Visual
      hi Visual guibg=#303030
    elseif g:colors_name ==# 'NeoSolarized'
      hi VertSplit guibg=#002b36 guifg=#181a1f
      hi clear Pmenu
      hi Pmenu guifg=#839496 guibg=#073642
    endif
  else
    if g:colors_name ==# 'gruvbox'
      hi VertSplit guibg=#fbf1c7 guifg=#e7e9e1
    endif
  endif
  hi SpaceVimLeaderGuiderGroupName cterm=bold ctermfg=175 gui=bold guifg=#d3869b
endfunction

function! SpaceVim#autocmds#VimEnter() abort
  call SpaceVim#api#import('vim#highlight').hide_in_normal('EndOfBuffer')
  for argv in g:_spacevim_mappings_space_custom_group_name
    if len(argv[0]) == 1
      if !has_key(g:_spacevim_mappings_space, argv[0][0])
        let g:_spacevim_mappings_space[argv[0][0]] = {'name' : argv[1]}
      endif
    elseif len(argv[0]) == 2
      if !has_key(g:_spacevim_mappings_space, argv[0][0])
        let g:_spacevim_mappings_space[argv[0][0]] = {'name' : '+Unnamed',
              \ argv[0][1] : { 'name' : argv[1]},
              \ }
      else
        if !has_key(g:_spacevim_mappings_space[argv[0][0]], argv[0][1])
          let g:_spacevim_mappings_space[argv[0][0]][argv[0][1]] = {'name' : argv[1]}
        endif
      endif
    endif
  endfor
  for argv in g:_spacevim_mappings_space_custom
    call call('SpaceVim#mapping#space#def', argv)
  endfor
  if SpaceVim#layers#isLoaded('core#statusline')
    set laststatus=2
    call SpaceVim#layers#core#statusline#def_colors()
    setlocal statusline=%!SpaceVim#layers#core#statusline#get(1)
  endif
  if SpaceVim#layers#isLoaded('core#tabline')
    call SpaceVim#layers#core#tabline#def_colors()
    set showtabline=2
  endif
  call SpaceVim#plugins#projectmanager#RootchandgeCallback()
  if !empty(get(g:, '_spacevim_bootstrap_after', ''))
    try
      call call(g:_spacevim_bootstrap_after, [])
    catch
      call SpaceVim#logger#error('failed to call bootstrap_after function: ' . g:_spacevim_bootstrap_after)
      call SpaceVim#logger#error('       exception: ' . v:exception)
      call SpaceVim#logger#error('       throwpoint: ' . v:throwpoint)
    endtry
  endif
endfunction

function! s:disable_welcome() abort
  augroup SPwelcome
    au!
  augroup END
endfunction


" vim:set et sw=2:
