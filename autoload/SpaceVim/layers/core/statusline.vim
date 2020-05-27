"=============================================================================
" statusline.vim --- SpaceVim statusline
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section core#statusline, layer-core-statusline
" @parentsection layers
" This layer provides default statusline for SpaceVim
" If you want to use airline's statusline, just disable this layer
" >
"   [[layers]]
"     name = "core#statusline"
"     enable = false
" <

scriptencoding utf-8
let g:_spacevim_statusline_loaded = 1
" APIs
let s:MESSLETTERS = SpaceVim#api#import('messletters')
let s:TIME = SpaceVim#api#import('time')
let s:HI = SpaceVim#api#import('vim#highlight')
let s:STATUSLINE = SpaceVim#api#import('vim#statusline')
let s:VIMCOMP = SpaceVim#api#import('vim#compatible')
let s:SYSTEM = SpaceVim#api#import('system')
let s:ICON = SpaceVim#api#import('unicode#icon')

" init
let s:separators = {
      \ 'arrow' : ["\ue0b0", "\ue0b2"],
      \ 'curve' : ["\ue0b4", "\ue0b6"],
      \ 'slant' : ["\ue0b8", "\ue0ba"],
      \ 'brace' : ["\ue0d2", "\ue0d4"],
      \ 'fire' : ["\ue0c0", "\ue0c2"],
      \ 'nil' : ['', ''],
      \ }
let s:i_separators = {
      \ 'arrow' : ["\ue0b1", "\ue0b3"],
      \ 'bar' : ['|', '|'],
      \ 'nil' : ['', ''],
      \ }
let s:loaded_modes = []
let s:modes = {
      \ 'center-cursor': {
      \ 'icon' : '⊝',
      \ 'icon_asc' : '-',
      \ 'desc' : 'centered-cursor mode',
      \ },
      \ 'hi-characters-for-long-lines' :{
      \ 'icon' : '⑧',
      \ 'icon_asc' : '8',
      \ 'desc' : 'toggle highlight of characters for long lines',
      \ },
      \ 'fill-column-indicator' :{
      \ 'icon' : s:MESSLETTERS.circled_letter('f'),
      \ 'icon_asc' : 'f',
      \ 'desc' : 'fill-column-indicator mode',
      \ },
      \ 'syntax-checking' :{
      \ 'icon' : s:MESSLETTERS.circled_letter('s'),
      \ 'icon_asc' : 's',
      \ 'desc' : 'syntax-checking mode',
      \ },
      \ 'spell-checking' :{
      \ 'icon' : s:MESSLETTERS.circled_letter('S'),
      \ 'icon_asc' : 'S',
      \ 'desc' : 'spell-checking mode',
      \ },
      \ 'paste-mode' :{
      \ 'icon' : s:MESSLETTERS.circled_letter('p'),
      \ 'icon_asc' : 'p',
      \ 'desc' : 'paste mode',
      \ },
      \ 'whitespace' :{
      \ 'icon' : s:MESSLETTERS.circled_letter('w'),
      \ 'icon_asc' : 'w',
      \ 'desc' : 'whitespace mode',
      \ },
      \ }

"  TODO This can not be deleted, it is used for toggle section
let s:loaded_sections = ['syntax checking', 'major mode', 'minor mode lighters', 'version control info', 'cursorpos']

let s:loaded_sections_r = g:spacevim_statusline_right_sections
let s:loaded_sections_l = g:spacevim_statusline_left_sections

let [s:lsep , s:rsep] = get(s:separators, g:spacevim_statusline_separator, s:separators['arrow'])
let [s:ilsep , s:irsep] = get(s:i_separators, g:spacevim_statusline_iseparator, s:i_separators['arrow'])

if SpaceVim#layers#isLoaded('checkers')
  call add(s:loaded_modes, 'syntax-checking')
endif
if &spell
  call add(s:loaded_modes, 'spell-checking')
endif
if &cc ==# '80'
  call add(s:loaded_modes, 'fill-column-indicator')
endif
if index(s:loaded_sections_r, 'whitespace') != -1
  call add(s:loaded_modes, 'whitespace')
endif
" build in sections for SpaceVim statusline
function! s:winnr(...) abort
  if a:0 >= 1
    if g:spacevim_windows_index_type == 3
      return ' %{ get(w:, "winid", winnr()) } '
    else
      return ' %{ SpaceVim#layers#core#statusline#winnr(get(w:, "winid", winnr())) } '
    endif
  else
    if g:spacevim_enable_statusline_mode == 1
      return '%{SpaceVim#layers#core#statusline#mode(mode())} %{SpaceVim#layers#core#statusline#mode_text(mode())} %{ SpaceVim#layers#core#statusline#winnr(get(w:, "winid", winnr())) } '
    elseif g:spacevim_windows_index_type == 3
      return '%{SpaceVim#layers#core#statusline#mode(mode())} %{ get(w:, "winid", winnr()) } '
    else
      return '%{SpaceVim#layers#core#statusline#mode(mode())} %{ SpaceVim#layers#core#statusline#winnr(get(w:, "winid", winnr())) } '
    endif
  endif
endfunction

function! SpaceVim#layers#core#statusline#winnr(id) abort
  return s:MESSLETTERS.circled_num(a:id, g:spacevim_windows_index_type)
endfunction

function! s:filename() abort
  let name = fnamemodify(bufname('%'), ':t')
  if empty(name)
    let name = 'No Name'
  endif
  return "%{ &modified ? ' * ' : ' - '}" . s:filesize() . name . ' '
endfunction

function! s:fileformat() abort
  if g:spacevim_statusline_unicode_symbols == 1
    let g:_spacevim_statusline_fileformat = s:SYSTEM.fileformat()
  else
    let g:_spacevim_statusline_fileformat = &ff
  endif
  return '%{" " . g:_spacevim_statusline_fileformat . " | " . (&fenc!=""?&fenc:&enc) . " "}'
endfunction

function! s:major_mode() abort
  return '%{empty(&ft)? "" : " " . &ft . " "}'
endfunction

function! s:modes() abort
  if g:spacevim_statusline_unicode_symbols
    let m = ' ❖ '
  else
    let m = ' # '
  endif
  for mode in s:loaded_modes
    if g:spacevim_statusline_unicode_symbols
      let m .= s:modes[mode].icon . ' '
    else
      let m .= s:modes[mode].icon_asc . ' '
    endif
  endfor
  return m . ' '
endfunction


function! s:percentage() abort
  return ' %P '
endfunction

function! s:cursorpos() abort
  return ' %l:%c '
endfunction

function! s:time() abort
  return ' ' . s:TIME.current_time() . ' '
endfunction

function! s:date() abort

  return ' ' . s:TIME.current_date() . ' '

endfunction

function! s:whitespace() abort
  let ln = search('\s\+$', 'nw')
  if ln != 0
    return ' trailing[' . ln . '] '
  else
    return ''
  endif
endfunction

function! s:battery_status() abort
  if executable('acpi')
    let battery = split(system('acpi'))[-1][:-2]
    if g:spacevim_statusline_unicode_symbols
      return ' ' . s:ICON.battery_status(battery) . '  '
    else
      return ' ⚡' . battery . ' '
    endif
  elseif executable('pmset')
    let battery = matchstr(system('pmset -g batt'), '\d\+%')[:-2]
    if g:spacevim_statusline_unicode_symbols
      return ' ' . s:ICON.battery_status(battery) . '  '
    else
      return ' ⚡' . battery . ' '
    endif

  else
    return ''
  endif
endfunction

function! s:input_method() abort
  " use fcitx-remote get current method
  if executable('fcitx-remote')
    if system('fcitx-remote') == 1
      return ' cn '
    else
      return ' en '
    endif
  endif
  return ''
endfunction


if g:spacevim_enable_neomake
  function! s:syntax_checking() abort
    if !exists('g:loaded_neomake')
      return ''
    endif
    let counts = neomake#statusline#LoclistCounts()
    let warnings = get(counts, 'W', 0)
    let errors = get(counts, 'E', 0)
    let l =  warnings ? '%#SpaceVim_statusline_warn# ● ' . warnings . ' ' : ''
    let l .=  errors ? (warnings ? '' : ' ') . '%#SpaceVim_statusline_error#● ' . errors  . ' ' : ''
    return l
  endfunction
elseif g:spacevim_enable_ale
  function! s:syntax_checking() abort
    if !exists('g:ale_enabled')
      return ''
    endif
    let counts = ale#statusline#Count(bufnr(''))
    let warnings = counts.warning + counts.style_warning
    let errors = counts.error + counts.style_error
    let l =  warnings ? '%#SpaceVim_statusline_warn# ● ' . warnings . ' ' : ''
    let l .=  errors ? (warnings ? '' : ' ') . '%#SpaceVim_statusline_error#● ' . errors  . ' ' : ''
    return l
  endfunction
else
  function! s:syntax_checking() abort
    if !exists(':SyntasticCheck')
      return ''
    endif
    let l = SyntasticStatuslineFlag()
    if strlen(l) > 0
      return l
    else
      return ''
    endif
  endfunction
endif

function! s:search_status() abort
  let save_cursor = getpos('.')
  let ct = 0
  let tt = 0
  let ctl = split(s:VIMCOMP.execute('keeppatterns .,$s/' . @/ . '//gn', 'silent!'), "\n")
  if !empty(ctl)
    let ct = split(ctl[0])[0]
  endif
  let ttl = split(s:VIMCOMP.execute('keeppatterns %s/' . @/ . '//gn', 'silent!'), "\n")
  if !empty(ctl)
    let tt = split(ttl[0])[0]
  endif
  keepjumps call setpos('.', save_cursor)
  return ' ' . (str2nr(tt) - str2nr(ct) + 1) . '/' . tt . ' '
endfunction


function! s:search_count() abort
  return SpaceVim#plugins#searcher#count()
endfunction

let s:registed_sections = {
      \ 'winnr' : function('s:winnr'),
      \ 'syntax checking' : function('s:syntax_checking'),
      \ 'filename' : function('s:filename'),
      \ 'fileformat' : function('s:fileformat'),
      \ 'major mode' : function('s:major_mode'),
      \ 'minor mode lighters' : function('s:modes'),
      \ 'cursorpos' : function('s:cursorpos'),
      \ 'percentage' : function('s:percentage'),
      \ 'time' : function('s:time'),
      \ 'date' : function('s:date'),
      \ 'whitespace' : function('s:whitespace'),
      \ 'battery status' : function('s:battery_status'),
      \ 'input method' : function('s:input_method'),
      \ 'search status' : function('s:search_status'),
      \ 'search count' : function('s:search_count'),
      \ }


function! s:check_mode() abort
  if mode() ==# 'n'
    return 'n'
  elseif mode() ==# 'i'
    return 'i'
  elseif mode() =~# 'v'
    return 'v'
  elseif mode() =~# 'R'
    return 'R'
  endif
endfunction

" only when there are more than two buffers have same name.
" show buffer name all the time need
" enable_statusline_bfpath true
function! s:buffer_name() abort
  if get(b:, '_spacevim_statusline_showbfname', 0) == 1 || g:spacevim_enable_statusline_bfpath
    return  ' ' . bufname('%')
  else
    return ''
  endif
endfunction

function! s:current_tag() abort
  return '%{SpaceVim#layers#core#statusline#_current_tag()}'
endfunction

function! SpaceVim#layers#core#statusline#_current_tag() abort
  let tag = ''
  try
    let tag =tagbar#currenttag('%s ', '') 
  catch
  endtry
  return tag
endfunction

function! s:filesize() abort
  let l:size = getfsize(bufname('%'))
  if l:size == 0 || l:size == -1 || l:size == -2
    return ''
  endif
  if l:size < 1024
    return l:size.' bytes '
  elseif l:size < 1024*1024
    return printf('%.1f', l:size/1024.0).'k '
  elseif l:size < 1024*1024*1024
    return printf('%.1f', l:size/1024.0/1024.0) . 'm '
  else
    return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g '
  endif
endfunction

function! SpaceVim#layers#core#statusline#get(...) abort
  for nr in range(1, winnr('$'))
    call setwinvar(nr, 'winwidth', winwidth(nr))
    call setwinvar(nr, 'winid', nr)
  endfor
  if &filetype ==# 'vimfiler'
    return '%#SpaceVim_statusline_ia#' 
          \ . s:winnr(1)
          \ . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b#'
          \ . ' vimfiler %#SpaceVim_statusline_b_SpaceVim_statusline_c#'
          \ . s:lsep
  elseif &filetype ==# 'qf'
    return '%#SpaceVim_statusline_ia#' 
          \ . s:winnr(1)
          \ . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b#'
          \ . ' QuickFix %#SpaceVim_statusline_b_SpaceVim_statusline_c#'
          \ . s:lsep
          \ . ( has('patch-8.0.1384') ? ((getqflist({'title' : 0}).title ==# ':setqflist()') ? '' : 
          \ '%#SpaceVim_statusline_c#'
          \ . getqflist({'title' : 0}).title . '%#SpaceVim_statusline_c_SpaceVim_statusline_z#' . s:lsep
          \ ) : '')
  elseif &filetype ==# 'defx'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# defx %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'Fuzzy'
    return '%#SpaceVim_statusline_a_bold# Fuzzy %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# %{fuzzy#statusline()} %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep 
  elseif &filetype ==# 'SpaceVimFindArgv'
    return '%#SpaceVim_statusline_a_bold# Find %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
  elseif &filetype ==# 'gista-list'
    return '%#SpaceVim_statusline_ia#'
          \ . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#'
          \ . s:lsep
          \ . '%#SpaceVim_statusline_b# Gista %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &buftype ==# 'terminal'
    let st =  '%#SpaceVim_statusline_ia#'
          \ . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#'
          \ . s:lsep
          \ . '%#SpaceVim_statusline_b# Terminal %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep
    if !empty(get(b:, '_spacevim_shell', ''))
      let st .= '%#SpaceVim_statusline_c# %{b:_spacevim_shell} %#SpaceVim_statusline_c_SpaceVim_statusline_z#' . s:lsep
    endif
    return st
  elseif &filetype ==# 'git-status'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Git status %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'git-commit'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Git commit %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'git-diff'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Git diff %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'git-blame'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Git blame %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'git-config'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Git config %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'git-log'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Git log %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'gina-status'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Gina status %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'gina-commit'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Gina commit %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'diff' && bufname('%') =~# '^gina://'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Gina diff %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'nerdtree'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Nerdtree %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'Mundo'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Mundo %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'MundoDiff'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# MundoDiff %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'SpaceVimMessageBuffer'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# Message %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'startify'
    try
      call fugitive#detect(getcwd())
    catch
    endtry
    let st = '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# startify %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
    if index(g:spacevim_statusline_left_sections, 'vcs') != -1
      let st .= '%#SpaceVim_statusline_c#' .  call(s:registed_sections['vcs'], [])
            \ . '%#SpaceVim_statusline_c_SpaceVim_statusline_z#' . s:lsep
    endif
    return st
  elseif &buftype ==# 'nofile' && bufname('%') ==# '__LanguageClient__'
    return '%#SpaceVim_statusline_a# LanguageClient %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# ' . &filetype . ' %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep
  elseif &filetype ==# 'SpaceVimLayerManager'
    return '%#SpaceVim_statusline_a#' . s:winnr(1) . '%#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# LayerManager %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep
  elseif &filetype ==# 'SpaceVimGitLogPopup'
    return '%#SpaceVim_statusline_a# Git log popup %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
  elseif &filetype ==# 'respones.idris'
    return '%#SpaceVim_statusline_a# Idris Response %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
  elseif &filetype ==# 'SpaceVimWinDiskManager'
    return '%#SpaceVim_statusline_a# WinDisk %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
  elseif &filetype ==# 'SpaceVimTodoManager'
    return '%#SpaceVim_statusline_a# TODO manager %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
  elseif &filetype ==# 'SpaceVimGitBranchManager'
    return '%#SpaceVim_statusline_a# Branch manager %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
  elseif &filetype ==# 'SpaceVimPlugManager'
    return '%#SpaceVim_statusline_a#' . s:winnr(1) . '%#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# PlugManager %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep
  elseif &filetype ==# 'SpaceVimTabsManager'
    return '%#SpaceVim_statusline_a#' . s:winnr(1) . '%#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# TabsManager %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
  elseif &filetype ==# 'fzf'
    return '%#SpaceVim_statusline_a_bold# FZF %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# %{SpaceVim#layers#fzf#sources()} %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep
  elseif &filetype ==# 'denite'
    return '%#SpaceVim_statusline_a_bold# %{SpaceVim#layers#core#statusline#denite_mode()} '
          \ . '%#SpaceVim_statusline_a_bold_SpaceVim_statusline_b#' . s:lsep . ' '
          \ . '%#SpaceVim_statusline_b#%{SpaceVim#layers#core#statusline#denite_status("sources")} %#SpaceVim_statusline_b_SpaceVim_statusline_z#' . s:lsep . ' '
          \ . '%#SpaceVim_statusline_z#%=%#SpaceVim_statusline_c_SpaceVim_statusline_z#' . s:rsep
          \ . '%#SpaceVim_statusline_c# %{SpaceVim#layers#core#statusline#denite_status("path") . SpaceVim#layers#core#statusline#denite_status("linenr")}'
  elseif &filetype ==# 'denite-filter'
    return '%#SpaceVim_statusline_a_bold# Filter %#SpaceVim_statusline_a_SpaceVim_statusline_b#'
  elseif &filetype ==# 'unite'
    return '%#SpaceVim_statusline_a_bold#%{SpaceVim#layers#core#statusline#unite_mode()} Unite '
          \ . '%#SpaceVim_statusline_a_bold_SpaceVim_statusline_b#' . s:lsep . ' %{get(unite#get_context(), "buffer_name", "")} '
          \ . '%#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep . ' '
          \ . '%#SpaceVim_statusline_c# %{unite#get_status_string()} '
  elseif &filetype ==# 'SpaceVimFlyGrep'
    return '%#SpaceVim_statusline_a_bold# FlyGrep %#SpaceVim_statusline_a_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# %{SpaceVim#plugins#flygrep#mode()} %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep
          \ . '%#SpaceVim_statusline_c# %{getcwd()} %#SpaceVim_statusline_c_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# %{SpaceVim#plugins#flygrep#lineNr()} %#SpaceVim_statusline_b_SpaceVim_statusline_z#' . s:lsep . ' '
  elseif &filetype ==# 'TransientState'
    return '%#SpaceVim_statusline_a# Transient State %#SpaceVim_statusline_a_SpaceVim_statusline_b#'
  elseif &filetype ==# 'vimcalc'
    return '%#SpaceVim_statusline_a#' . s:winnr() . ' VimCalc %#SpaceVim_statusline_a_SpaceVim_statusline_b#'
  elseif &filetype ==# 'HelpDescribe'
    return '%#SpaceVim_statusline_a# HelpDescribe %#SpaceVim_statusline_a_SpaceVim_statusline_b#'
  elseif &filetype ==# 'SpaceVimRunner'
    return '%#SpaceVim_statusline_a# Runner %#SpaceVim_statusline_a_SpaceVim_statusline_b# %{SpaceVim#plugins#runner#status()}'
  elseif &filetype ==# 'SpaceVimREPL'
    return '%#SpaceVim_statusline_a# REPL %#SpaceVim_statusline_a_SpaceVim_statusline_b# %{SpaceVim#plugins#repl#status()}'
  elseif &filetype ==# 'VimMailClient'
    return '%#SpaceVim_statusline_a# VimMail %#SpaceVim_statusline_a_SpaceVim_statusline_b# %{mail#client#win#status().dir}'
  elseif &filetype ==# 'SpaceVimQuickFix'
    return '%#SpaceVim_statusline_a# SpaceVimQuickFix %#SpaceVim_statusline_a_SpaceVim_statusline_b#'
  elseif &filetype ==# 'VebuggerShell'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# VebuggerShell %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep
  elseif &filetype ==# 'VebuggerTerminal'
    return '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep
          \ . '%#SpaceVim_statusline_b# VebuggerTerminal %#SpaceVim_statusline_b_SpaceVim_statusline_c#' . s:lsep
  endif
  if a:0 > 0
    return s:active()
  else
    return s:inactive()
  endif
endfunction

function! s:active() abort
  let lsec = []
  for section in s:loaded_sections_l
    if has_key(s:registed_sections, section)
      call add(lsec, call(s:registed_sections[section], []))
    endif
  endfor
  let rsec = []
  for section in s:loaded_sections_r
    if has_key(s:registed_sections, section)
      call add(rsec, call(s:registed_sections[section], []))
    endif
  endfor
  let fname = s:buffer_name()
  let tag = s:current_tag()
  return s:STATUSLINE.build(lsec, rsec, s:lsep, s:rsep, fname, tag,
        \ 'SpaceVim_statusline_a', 'SpaceVim_statusline_b', 'SpaceVim_statusline_c', 'SpaceVim_statusline_z', winwidth(winnr()))
endfunction

function! s:inactive() abort
  let l = '%#SpaceVim_statusline_ia#' . s:winnr(1) . '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' . s:lsep . '%#SpaceVim_statusline_b#'
  let secs = [s:filename(), ' ' . &filetype, s:modes()]
  let base = 10
  for sec in secs
    let len = s:STATUSLINE.len(sec)
    let base += len
    let l .= '%{ get(w:, "winwidth", 150) < ' . base . ' ? "" : (" ' . s:STATUSLINE.eval(sec) . ' ' . s:ilsep . '")}'
  endfor
  if get(w:, 'winwidth', 150) > base + 10
    let l .= join(['%=', '%{" " . &ff . "|" . (&fenc!=""?&fenc:&enc) . " "}', ' %P '], s:irsep)
  endif
  return l
endfunction


function! s:gitgutter() abort
  if exists('b:gitgutter_summary')
    let l:summary = get(b:, 'gitgutter_summary')
    if l:summary[0] != 0 || l:summary[1] != 0 || l:summary[2] != 0
      return ' +'.l:summary[0].' ~'.l:summary[1].' -'.l:summary[2].' '
    endif
  endif
  return ''
endfunction

function! SpaceVim#layers#core#statusline#init() abort
  augroup SpaceVim_statusline
    autocmd!
    autocmd BufWinEnter,WinEnter,FileType,BufWritePost
          \ * let &l:statusline = SpaceVim#layers#core#statusline#get(1)
    autocmd WinLeave * call SpaceVim#layers#core#statusline#remove_section('search status')
    autocmd BufWinLeave,WinLeave * let &l:statusline = SpaceVim#layers#core#statusline#get()
    autocmd ColorScheme * call SpaceVim#layers#core#statusline#def_colors()
  augroup END
endfunction

let s:colors_template = SpaceVim#mapping#guide#theme#gruvbox#palette()

function! SpaceVim#layers#core#statusline#def_colors() abort
  if !empty(g:spacevim_custom_color_palette)
    let t = g:spacevim_custom_color_palette
  else
    let name = get(g:, 'colors_name', 'gruvbox')
    try
      let t = SpaceVim#mapping#guide#theme#{name}#palette()
    catch /^Vim\%((\a\+)\)\=:E117/
      let t = SpaceVim#mapping#guide#theme#gruvbox#palette()
    endtry
  endif
  let s:colors_template = t
  exe 'hi! SpaceVim_statusline_a ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
  exe 'hi! SpaceVim_statusline_a_bold cterm=bold gui=bold ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
  exe 'hi! SpaceVim_statusline_ia gui=bold cterm=bold ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
  exe 'hi! SpaceVim_statusline_b ctermbg=' . t[1][2] . ' ctermfg=' . t[1][3] . ' guibg=' . t[1][1] . ' guifg=' . t[1][0]
  exe 'hi! SpaceVim_statusline_c ctermbg=' . t[2][2] . ' ctermfg=' . t[2][3] . ' guibg=' . t[2][1] . ' guifg=' . t[2][0]
  exe 'hi! SpaceVim_statusline_z ctermbg=' . t[3][1] . ' ctermfg=' . t[2][2] . ' guibg=' . t[3][0] . ' guifg=' . t[2][0]
  hi! SpaceVim_statusline_error ctermbg=003 ctermfg=Black guibg=#504945 guifg=#fb4934 gui=bold
  hi! SpaceVim_statusline_warn ctermbg=003 ctermfg=Black guibg=#504945 guifg=#fabd2f gui=bold
  call s:HI.hi_separator('SpaceVim_statusline_a', 'SpaceVim_statusline_b')
  call s:HI.hi_separator('SpaceVim_statusline_a_bold', 'SpaceVim_statusline_b')
  call s:HI.hi_separator('SpaceVim_statusline_ia', 'SpaceVim_statusline_b')
  call s:HI.hi_separator('SpaceVim_statusline_b', 'SpaceVim_statusline_c')
  call s:HI.hi_separator('SpaceVim_statusline_b', 'SpaceVim_statusline_z')
  call s:HI.hi_separator('SpaceVim_statusline_c', 'SpaceVim_statusline_z')
endfunction

function! SpaceVim#layers#core#statusline#toggle_mode(name) abort
  if index(s:loaded_modes, a:name) != -1
    call remove(s:loaded_modes, index(s:loaded_modes, a:name))
  else
    call add(s:loaded_modes, a:name)
  endif
  let &l:statusline = SpaceVim#layers#core#statusline#get(1)
endfunction

let s:section_old_pos = {
      \ }

function! SpaceVim#layers#core#statusline#toggle_section(name) abort
  if index(s:loaded_sections_l, a:name) == -1
        \ && index(s:loaded_sections_r, a:name) == -1
        \ && !has_key(s:section_old_pos, a:name)
    if a:name ==# 'search status'
      call insert(s:loaded_sections_l, a:name, 2)
    else
      call add(s:loaded_sections_r, a:name)
    endif
  elseif index(s:loaded_sections_r, a:name) != -1
    let s:section_old_pos[a:name] = ['r', index(s:loaded_sections_r, a:name)]
    call remove(s:loaded_sections_r, index(s:loaded_sections_r, a:name))
  elseif index(s:loaded_sections_l, a:name) != -1
    let s:section_old_pos[a:name] = ['l', index(s:loaded_sections_l, a:name)]
    call remove(s:loaded_sections_l, index(s:loaded_sections_l, a:name))
  elseif has_key(s:section_old_pos, a:name)
    if s:section_old_pos[a:name][0] ==# 'r'
      call insert(s:loaded_sections_r, a:name, s:section_old_pos[a:name][1])
    else
      call insert(s:loaded_sections_l, a:name, s:section_old_pos[a:name][1])
    endif
  endif
  let &l:statusline = SpaceVim#layers#core#statusline#get(1)
endfunction

function! SpaceVim#layers#core#statusline#rsep() abort
  return get(s:separators, g:spacevim_statusline_separator, s:separators['arrow'])
endfunction

function! SpaceVim#layers#core#statusline#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'm'], 'call SpaceVim#layers#core#statusline#toggle_section("minor mode lighters")',
        \ 'toggle the minor mode lighters', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'M'], 'call SpaceVim#layers#core#statusline#toggle_section("major mode")',
        \ 'toggle the major mode', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'b'], 'call SpaceVim#layers#core#statusline#toggle_section("battery status")',
        \ 'toggle the battery status', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'd'], 'call SpaceVim#layers#core#statusline#toggle_section("date")',
        \ 'toggle the date', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'i'], 'call SpaceVim#layers#core#statusline#toggle_section("input method")',
        \ 'toggle the input method', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 't'], 'call SpaceVim#layers#core#statusline#toggle_section("time")',
        \ 'toggle the time', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'p'], 'call SpaceVim#layers#core#statusline#toggle_section("cursorpos")',
        \ 'toggle the cursor position', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'm', 'T'], 'if &laststatus == 2 | let &laststatus = 0 | else | let &laststatus = 2 | endif',
        \ 'toggle the statusline itself', 1)
  function! TagbarStatusline(...) abort
    let name = (strwidth(a:3) > (g:spacevim_sidebar_width - 15)) ? a:3[:g:spacevim_sidebar_width - 20] . '..' : a:3
    return s:STATUSLINE.build([s:winnr(1),' Tagbar ', ' ' . name . ' '], [], s:lsep, s:rsep, '', '',
          \ 'SpaceVim_statusline_ia', 'SpaceVim_statusline_b', 'SpaceVim_statusline_c', 'SpaceVim_statusline_z', g:spacevim_sidebar_width)
  endfunction
  let g:tagbar_status_func = 'TagbarStatusline'
  let g:unite_force_overwrite_statusline = 0
  let g:ctrlp_status_func = {
        \ 'main': 'SpaceVim#layers#core#statusline#ctrlp',
        \ 'prog': 'SpaceVim#layers#core#statusline#ctrlp_status',
        \ }
endfunction

" Arguments:
" |
" +- a:focus   : The focus of the prompt: "prt" or "win".
" |
" +- a:byfname : In filename mode or in full path mode: "file" or "path".
" |
" +- a:regex   : In regex mode: 1 or 0.
" |
" +- a:prev    : The previous search mode.
" |
" +- a:item    : The current search mode.
" |
" +- a:next    : The next search mode.
" |
" +- a:marked  : The number of marked files, or a comma separated list of
"                the marked filenames.

" @vimlint(EVL103, 1, a:regex)
" @vimlint(EVL103, 1, a:marked)
function! SpaceVim#layers#core#statusline#ctrlp(focus, byfname, regex, prev, item, next, marked) abort
  return s:STATUSLINE.build([' Ctrlp ', ' ' . a:prev . ' ', ' ' . a:item . ' ', ' ' . a:next . ' '],
        \ [' ' . a:focus . ' ', ' ' . a:byfname . ' ', ' ' . getcwd() . ' '], s:lsep, s:rsep, '', '',
        \ 'SpaceVim_statusline_a_bold', 'SpaceVim_statusline_b', 'SpaceVim_statusline_c', 'SpaceVim_statusline_z', winwidth(winnr()))
endfunction
" @vimlint(EVL103, 0, a:regex)
" @vimlint(EVL103, 0, a:marked)

" a:str : Either the number of files scanned so far, or a string indicating
"         the current directory is being scanned with a user_command.
function! SpaceVim#layers#core#statusline#ctrlp_status(str) abort
  return s:STATUSLINE.build([' Ctrlp ', ' ' . a:str . ' '],
        \ [' ' . getcwd() . ' '], s:lsep, s:rsep, '', '',
        \ 'SpaceVim_statusline_a', 'SpaceVim_statusline_b', 'SpaceVim_statusline_c', 'SpaceVim_statusline_z', winwidth(winnr()))
endfunction

function! SpaceVim#layers#core#statusline#jump(i) abort
  if winnr('$') >= a:i
    exe a:i . 'wincmd w'
  endif
endfunction

function! SpaceVim#layers#core#statusline#mode(mode) abort
  let t = s:colors_template
  let iedit_mode = get(w:, 'spacevim_iedit_mode', '')
  let mode = get(w:, 'spacevim_statusline_mode', '')
  if  mode != a:mode
    if a:mode ==# 'n'
      if !empty(iedit_mode)
        if iedit_mode ==# 'n'
          exe 'hi! SpaceVim_statusline_a gui=bold cterm=bold ctermbg=' . t[8][3] . ' ctermfg=' . t[8][2] . ' guibg=' . t[8][1] . ' guifg=' . t[8][0]
        elseif iedit_mode ==# 'i'
          exe 'hi! SpaceVim_statusline_a gui=bold cterm=bold ctermbg=' . t[7][3] . ' ctermfg=' . t[7][2] . ' guibg=' . t[7][1] . ' guifg=' . t[7][0]
        else
          exe 'hi! SpaceVim_statusline_a gui=bold cterm=bold ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
        endif
      else
        exe 'hi! SpaceVim_statusline_a gui=bold cterm=bold ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
      endif
    elseif a:mode ==# 'i'
      exe 'hi! SpaceVim_statusline_a gui=bold cterm=bold ctermbg=' . t[4][3] . ' ctermfg=' . t[4][2] . ' guibg=' . t[4][1] . ' guifg=' . t[4][0]
    elseif a:mode ==# 'R'
      exe 'hi! SpaceVim_statusline_a gui=bold cterm=bold ctermbg=' . t[6][3] . ' ctermfg=' . t[6][2] . ' guibg=' . t[6][1] . ' guifg=' . t[6][0]
    elseif a:mode ==# 'v' || a:mode ==# 'V' || a:mode ==# '' || a:mode ==# 's' || a:mode ==# 'S' || a:mode ==# ''
      exe 'hi! SpaceVim_statusline_a gui=bold cterm=bold ctermbg=' . t[5][3] . ' ctermfg=' . t[5][2] . ' guibg=' . t[5][1] . ' guifg=' . t[5][0]
    endif
    call s:HI.hi_separator('SpaceVim_statusline_a', 'SpaceVim_statusline_b')
    let w:spacevim_statusline_mode = a:mode
  endif
  return ''
endfunction

function! SpaceVim#layers#core#statusline#mode_text(mode) abort
  let iedit_mode = get(w:, 'spacevim_iedit_mode', '')
  if a:mode ==# 'n'
    if !empty(iedit_mode)
      if iedit_mode ==# 'n'
        return 'IEDIT-NORMAL'
      else
        return 'IEDIT-INSERT'
      endif
    endif
    return 'NORMAL'
  elseif a:mode ==# 'i'
    return 'INSERT'
  elseif a:mode ==# 'R'
    return 'REPLACE'
  elseif a:mode ==# 'v'
    return 'VISUAL'
  elseif a:mode ==# 'V'
    return 'V-LINE'
  elseif a:mode ==# ''
    return 'V-BLOCK'
  elseif a:mode ==# 'c'
    return 'COMMAND'
  elseif a:mode ==# 't'
    return 'TERMINAL'
  elseif a:mode ==# 'v' || a:mode ==# 'V' || a:mode ==# '^V' || a:mode ==# 's' || a:mode ==# 'S' || a:mode ==# '^S'
    return 'VISUAL'
  endif
  return ' '
endfunction


function! SpaceVim#layers#core#statusline#denite_status(argv) abort
  if exists('*denite#get_status_mode')
    let denite_ver = 2
  else
    let denite_ver = 3
  endif
  if denite_ver == 3
    return denite#get_status(a:argv)
  else
    return denite#get_status_{a:argv}()
  endif
endfunction

function! SpaceVim#layers#core#statusline#denite_mode() abort
  let t = s:colors_template
  if exists('*denite#get_status_mode')
    let denite_ver = 2
  else
    let denite_ver = 3
  endif

  if denite_ver == 3
    let dmode = 'Denite'
  else
    " this can not be changed, as it works in old denite
    let dmode = split(denite#get_status_mode())[1]
    if get(w:, 'spacevim_statusline_mode', '') != dmode
      if dmode ==# 'NORMAL'
        exe 'hi! SpaceVim_statusline_a_bold cterm=bold gui=bold ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
      elseif dmode ==# 'INSERT'
        exe 'hi! SpaceVim_statusline_a_bold cterm=bold gui=bold ctermbg=' . t[4][3] . ' ctermfg=' . t[4][2] . ' guibg=' . t[4][1] . ' guifg=' . t[4][0]
      endif
      call s:HI.hi_separator('SpaceVim_statusline_a_bold', 'SpaceVim_statusline_b')
      let w:spacevim_statusline_mode = dmode
    endif
  endif
  return dmode
endfunction

function! SpaceVim#layers#core#statusline#unite_mode() abort
  let t = s:colors_template
  let dmode = mode()
  if get(w:, 'spacevim_statusline_mode', '') != dmode
    if dmode ==# 'n'
      exe 'hi! SpaceVim_statusline_a_bold cterm=bold gui=bold ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
    elseif dmode ==# 'i'
      exe 'hi! SpaceVim_statusline_a_bold cterm=bold gui=bold ctermbg=' . t[4][3] . ' ctermfg=' . t[4][2] . ' guibg=' . t[4][1] . ' guifg=' . t[4][0]
    endif
    call s:HI.hi_separator('SpaceVim_statusline_a_bold', 'SpaceVim_statusline_b')
    let w:spacevim_statusline_mode = dmode
  endif
  return ''
endfunction

function! SpaceVim#layers#core#statusline#register_sections(name, func) abort

  if has_key(s:registed_sections, a:name)
    call SpaceVim#logger#info('statusline build-in section ' . a:name . ' has been changed!')
    call extend(s:registed_sections, {a:name : a:func})
  else
    call extend(s:registed_sections, {a:name : a:func})
  endif

endfunction

function! SpaceVim#layers#core#statusline#check_section(name) abort
  return (index(s:loaded_sections_l, a:name) != -1
        \ || index(s:loaded_sections_r, a:name) != -1)
endfunction

function! SpaceVim#layers#core#statusline#remove_section(name) abort
  if index(s:loaded_sections_l, a:name) != -1
    call remove(s:loaded_sections_l, index(s:loaded_sections_l, a:name))
  endif
  if index(s:loaded_sections_r, a:name) != -1
    call remove(s:loaded_sections_r, index(s:loaded_sections_l, a:name))
  endif
  let &l:statusline = SpaceVim#layers#core#statusline#get(1)
endfunction

" vim:set et sw=2 cc=80 nowrap:
