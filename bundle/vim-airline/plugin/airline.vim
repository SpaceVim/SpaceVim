" MIT License. Copyright (c) 2013-2020 Bailey Ling, Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

if &cp || v:version < 702 || (exists('g:loaded_airline') && g:loaded_airline)
  finish
endif
let g:loaded_airline = 1

let s:airline_initialized = 0
function! s:init()
  if s:airline_initialized
    return
  endif
  let s:airline_initialized = 1

  call airline#extensions#load()
  call airline#init#sections()

  let s:theme_in_vimrc = exists('g:airline_theme')
  if s:theme_in_vimrc
    try
      if g:airline_theme is# 'random'
        let g:airline_theme=s:random_theme()
      endif
      let palette = g:airline#themes#{g:airline_theme}#palette
    catch
      call airline#util#warning(printf('Could not resolve airline theme "%s". Themes have been migrated to github.com/vim-airline/vim-airline-themes.', g:airline_theme))
      let g:airline_theme = 'dark'
    endtry
    try
      silent call airline#switch_theme(g:airline_theme)
    catch
      call airline#util#warning(printf('Could not find airline theme "%s".', g:airline_theme))
      let g:airline_theme = 'dark'
      silent call airline#switch_theme(g:airline_theme)
    endtry
  else
    let g:airline_theme = 'dark'
    silent call s:on_colorscheme_changed()
  endif

  call airline#util#doautocmd('AirlineAfterInit')
endfunction

function! s:do_vim_enter()
  " Needed for the Vista extension #2009
  if get(g:, 'airline#extensions#vista#enabled', 1) && exists(':Vista')
    call vista#RunForNearestMethodOrFunction()
  endif
  call <sid>on_window_changed('VimEnter')
endfunction

let s:active_winnr = -1
function! s:on_window_changed(event)
  " don't trigger for Vim popup windows
  if &buftype is# 'popup'
    return
  endif

  if pumvisible() && (!&previewwindow || g:airline_exclude_preview)
    " do not trigger for previewwindows
    return
  endif
  let s:active_winnr = winnr()
  " Handle each window only once, since we might come here several times for
  " different autocommands.
  let l:key = [bufnr('%'), s:active_winnr, winnr('$'), tabpagenr(), &ft]
  if get(g:, 'airline_last_window_changed', []) == l:key
        \ && &stl is# '%!airline#statusline('.s:active_winnr.')'
        \ && &ft !~? 'gitcommit'
    " fugitive is special, it changes names and filetypes several times,
    " make sure the caching does not get into its way
    return
  endif
  let g:airline_last_window_changed = l:key
  call s:init()
  call airline#update_statusline()
endfunction

function! s:on_focus_gained()
  if airline#util#try_focusgained()
    unlet! w:airline_lastmode | :call <sid>airline_refresh(1)
  endif
endfunction

function! s:on_cursor_moved()
  if winnr() != s:active_winnr || !exists('w:airline_active')
    call s:on_window_changed('CursorMoved')
  endif
  call airline#update_tabline()
endfunction

function! s:on_colorscheme_changed()
  call s:init()
  unlet! g:airline#highlighter#normal_fg_hi
  call airline#highlighter#reset_hlcache()
  let g:airline_gui_mode = airline#init#gui_mode()
  if !s:theme_in_vimrc
    call airline#switch_matching_theme()
  endif

  " couldn't find a match, or theme was defined, just refresh
  call airline#load_theme()
endfunction

function! airline#cmdwinenter(...)
  call airline#extensions#apply_left_override('Command Line', '')
endfunction

function! s:airline_toggle()
  if exists("#airline")
    augroup airline
      au!
    augroup END
    augroup! airline

    if exists("s:stl")
      let &stl = s:stl
    endif
    if exists("s:tal")
      let [&tal, &showtabline] = s:tal
    endif
    call airline#highlighter#reset_hlcache()

    call airline#util#doautocmd('AirlineToggledOff')
  else
    let s:stl = &statusline
    let s:tal = [&tabline, &showtabline]
    augroup airline
      autocmd!

      autocmd CmdwinEnter *
            \ call airline#add_statusline_func('airline#cmdwinenter')
            \ | call <sid>on_window_changed('CmdwinEnter')
      autocmd CmdwinLeave * call airline#remove_statusline_func('airline#cmdwinenter')

      autocmd GUIEnter,ColorScheme * call <sid>on_colorscheme_changed()
      if exists("##OptionSet")
        " Make sure that g_airline_gui_mode is refreshed
        autocmd OptionSet termguicolors call <sid>on_colorscheme_changed()
      endif
      " Set all statuslines to inactive
      autocmd FocusLost * call airline#update_statusline_focuslost()
      " Refresh airline for :syntax off
      autocmd SourcePre */syntax/syntax.vim
            \ call airline#extensions#tabline#buffers#invalidate()
      autocmd VimEnter * call <sid>do_vim_enter()
      autocmd WinEnter * call <sid>on_window_changed('WinEnter')
      autocmd FileType * call <sid>on_window_changed('FileType')
      autocmd BufWinEnter * call <sid>on_window_changed('BufWinEnter')
      autocmd BufUnload * call <sid>on_window_changed('BufUnload')
      if exists('##CompleteDone')
        autocmd CompleteDone * call <sid>on_window_changed('CompleteDone')
      endif
      " non-trivial number of external plugins use eventignore=all, so we need to account for that
      autocmd CursorMoved * call <sid>on_cursor_moved()

      autocmd VimResized * call <sid>on_focus_gained()
      if exists('*timer_start') && exists('*funcref')
        " do not trigger FocusGained on startup, it might erase the intro screen (see #1817)
        " needs funcref() (needs 7.4.2137) and timers (7.4.1578)
        let Handler=funcref('<sid>FocusGainedHandler')
        let s:timer=timer_start(5000, Handler)
      else
        autocmd FocusGained * call <sid>on_focus_gained()
      endif

      if exists("##TerminalOpen")
        " Using the same function with the TermOpen autocommand
        " breaks for Neovim see #1828, looks like a neovim bug.
        autocmd TerminalOpen * :call airline#load_theme() " reload current theme for Terminal, forces the terminal extension to be loaded
      endif
      autocmd TabEnter * :unlet! w:airline_lastmode | let w:airline_active=1
      autocmd BufWritePost */autoload/airline/themes/*.vim
            \ exec 'source '.split(globpath(&rtp, 'autoload/airline/themes/'.g:airline_theme.'.vim', 1), "\n")[0]
            \ | call airline#load_theme()
      autocmd User AirlineModeChanged nested call airline#mode_changed()

      if get(g:, 'airline_statusline_ontop', 0)
        " Force update of tabline more often
        autocmd InsertEnter,InsertLeave,CursorMovedI * :call airline#update_tabline()
      endif
    augroup END

    if !airline#util#stl_disabled(winnr())
      if &laststatus < 2
        set laststatus=2
      endif
    endif
    if s:airline_initialized
      call s:on_window_changed('Init')
    endif

    call airline#util#doautocmd('AirlineToggledOn')
  endif
endfunction

function! s:get_airline_themes(a, l, p)
  return airline#util#themes(a:a)
endfunction

function! s:airline_theme(...)
  if a:0
    try
      let theme = a:1
      if  theme is# 'random'
        let theme = s:random_theme()
      endif
      call airline#switch_theme(theme)
    catch " discard error
    endtry
    if a:1 is# 'random'
      echo g:airline_theme
    endif
  else
    echo g:airline_theme
  endif
endfunction

function! s:airline_refresh(...)
  " a:1, fast refresh, do not reload the theme
  let fast=!empty(get(a:000, 0, 0))
  if !exists("#airline")
    " disabled
    return
  endif
  call airline#util#doautocmd('AirlineBeforeRefresh')
  call airline#highlighter#reset_hlcache()
  if !fast
    call airline#load_theme()
  endif
  call airline#update_statusline()
  call airline#update_tabline()
endfunction

function! s:FocusGainedHandler(timer)
  if exists("s:timer") && a:timer == s:timer
    augroup airline
      au FocusGained * call s:on_focus_gained()
    augroup END
  endif
endfu

function! s:airline_extensions()
  let loaded = airline#extensions#get_loaded_extensions()
  let files = split(globpath(&rtp, "autoload/airline/extensions/*.vim"), "\n")
  call map(files, 'fnamemodify(v:val, ":t:r")')
  if empty(files)
    echo "No extensions loaded"
    return
  endif
  echohl Title
  echo printf("%-15s\t%s\t%s", "Extension", "Extern", "Status")
  echohl Normal
  let set=[]
  for ext in sort(files)
    if index(set, ext) > -1
      continue
    endif
    let indx=match(loaded, '^'.ext.'\*\?$')
    let external = (indx > -1 && loaded[indx] =~ '\*$')
    echo printf("%-15s\t%s\t%sloaded", ext, external, indx == -1 ? 'not ' : '')
    call add(set, ext)
  endfor
endfunction

function! s:rand(max) abort
  if exists("*rand")
    " Needs Vim 8.1.2342
    let number=rand()
  elseif has("reltime")
    let timerstr=reltimestr(reltime())
    let number=split(timerstr, '\.')[1]+0
  elseif has("win32") && &shell =~ 'cmd'
    let number=system("echo %random%")+0
  else
    " best effort, bash and zsh provide $RANDOM
    " cmd.exe on windows provides %random%, but expand()
    " does not seem to be able to expand this correctly.
    " In the worst case, this always returns zero
    let number=expand("$RANDOM")+0
  endif
  return number % a:max
endfunction

function! s:random_theme() abort
  let themes=airline#util#themes('')
  return themes[s:rand(len(themes))]
endfunction

command! -bar -nargs=? -complete=customlist,<sid>get_airline_themes AirlineTheme call <sid>airline_theme(<f-args>)
command! -bar AirlineToggleWhitespace call airline#extensions#whitespace#toggle()
command! -bar AirlineToggle  call s:airline_toggle()
command! -bar -bang AirlineRefresh call s:airline_refresh(<q-bang>)
command! AirlineExtensions   call s:airline_extensions()

call airline#init#bootstrap()
call s:airline_toggle()
if exists("v:vim_did_enter") && v:vim_did_enter
  call <sid>on_window_changed('VimEnter')
endif

let &cpo = s:save_cpo
unlet s:save_cpo
