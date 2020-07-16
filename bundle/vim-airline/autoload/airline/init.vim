" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! s:check_defined(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction

let s:loaded = 0
function! airline#init#bootstrap()
  if s:loaded
    return
  endif
  let s:loaded = 1

  let g:airline#init#bootstrapping = 1

  let g:airline#init#vim_async = (v:version >= 800 && has('job'))
  let g:airline#init#is_windows = has('win32') || has('win64')

  call s:check_defined('g:airline_detect_modified', 1)
  call s:check_defined('g:airline_detect_paste', 1)
  call s:check_defined('g:airline_detect_crypt', 1)
  call s:check_defined('g:airline_detect_spell', 1)
  call s:check_defined('g:airline_detect_spelllang', 1)
  call s:check_defined('g:airline_detect_iminsert', 0)
  call s:check_defined('g:airline_inactive_collapse', 1)
  call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
  call s:check_defined('g:airline_exclude_filetypes', [])
  call s:check_defined('g:airline_exclude_preview', 0)
  call s:check_defined('g:airline_gui_mode', airline#init#gui_mode())

  call s:check_defined('g:airline_mode_map', {})
  call extend(g:airline_mode_map, {
        \ '__' : '------',
        \ 'c'  : 'COMMAND',
        \ 'i'  : 'INSERT',
        \ 'ic' : 'INSERT COMPL',
        \ 'ix' : 'INSERT COMPL',
        \ 'multi' : 'MULTI',
        \ 'n'  : 'NORMAL',
        \ 'ni' : '(INSERT)',
        \ 'no' : 'OP PENDING',
        \ 'R'  : 'REPLACE',
        \ 'Rv' : 'V REPLACE',
        \ 's'  : 'SELECT',
        \ 'S'  : 'S-LINE',
        \ '' : 'S-BLOCK',
        \ 't'  : 'TERMINAL',
        \ 'v'  : 'VISUAL',
        \ 'V'  : 'V-LINE',
        \ '' : 'V-BLOCK',
        \ }, 'keep')

  call s:check_defined('g:airline_theme_map', {})
  call extend(g:airline_theme_map, {
        \ 'default': 'dark',
        \ '\CTomorrow': 'tomorrow',
        \ 'base16': 'base16',
        \ 'mo[l|n]okai': 'molokai',
        \ 'wombat': 'wombat',
        \ 'zenburn': 'zenburn',
        \ 'solarized': 'solarized',
        \ 'flattened': 'solarized',
        \ '\CNeoSolarized': 'solarized',
        \ }, 'keep')

  call s:check_defined('g:airline_symbols', {})
  " First define the symbols,
  " that are common in Powerline/Unicode/ASCII mode,
  " then add specific symbols for either mode
  call extend(g:airline_symbols, {
          \ 'paste': 'PASTE',
          \ 'spell': 'SPELL',
          \ 'modified': '+',
          \ 'space': ' ',
          \ 'keymap': 'Keymap:',
          \ 'ellipsis': '...'
          \  }, 'keep')

  if get(g:, 'airline_powerline_fonts', 0)
    " Symbols for Powerline terminals
    call s:check_defined('g:airline_left_sep', "\ue0b0")      " 
    call s:check_defined('g:airline_left_alt_sep', "\ue0b1")  " 
    call s:check_defined('g:airline_right_sep', "\ue0b2")     " 
    call s:check_defined('g:airline_right_alt_sep', "\ue0b3") " 
    " ro=, ws=☲, lnr=☰, mlnr=, br=, nx=Ɇ, crypt=🔒, dirty=⚡
    call extend(g:airline_symbols, {
          \ 'readonly': "\ue0a2",
          \ 'whitespace': "\u2632",
          \ 'linenr': "\u2630 ",
          \ 'maxlinenr': " \ue0a1",
          \ 'branch': "\ue0a0",
          \ 'notexists': "\u0246",
          \ 'dirty': "\u26a1",
          \ 'crypt': nr2char(0x1F512),
          \ }, 'keep')
  elseif &encoding==?'utf-8' && !get(g:, "airline_symbols_ascii", 0)
    " Symbols for Unicode terminals
    call s:check_defined('g:airline_left_sep', "")
    call s:check_defined('g:airline_left_alt_sep', "")
    call s:check_defined('g:airline_right_sep', "")
    call s:check_defined('g:airline_right_alt_sep', "")
    " ro=⊝, ws=☲, lnr=☰, mlnr=㏑, br=ᚠ, nx=Ɇ, crypt=🔒
    call extend(g:airline_symbols, {
          \ 'readonly': "\u229D",
          \ 'whitespace': "\u2632",
          \ 'linenr': "\u2630 ",
          \ 'maxlinenr': " \u33D1",
          \ 'branch': "\u16A0",
          \ 'notexists': "\u0246",
          \ 'crypt': nr2char(0x1F512),
          \ 'dirty': '!',
          \ }, 'keep')
  else
    " Symbols for ASCII terminals
    call s:check_defined('g:airline_left_sep', "")
    call s:check_defined('g:airline_left_alt_sep', "")
    call s:check_defined('g:airline_right_sep', "")
    call s:check_defined('g:airline_right_alt_sep', "")
    call extend(g:airline_symbols, {
          \ 'readonly': 'RO',
          \ 'whitespace': '!',
          \ 'linenr': 'ln ',
          \ 'maxlinenr': ' :',
          \ 'branch': '',
          \ 'notexists': '?',
          \ 'crypt': 'cr',
          \ 'dirty': '!',
          \ }, 'keep')
  endif

  call airline#parts#define('mode', {
        \ 'function': 'airline#parts#mode',
        \ 'accent': 'bold',
        \ })
  call airline#parts#define_function('iminsert', 'airline#parts#iminsert')
  call airline#parts#define_function('paste', 'airline#parts#paste')
  call airline#parts#define_function('crypt', 'airline#parts#crypt')
  call airline#parts#define_function('spell', 'airline#parts#spell')
  call airline#parts#define_function('filetype', 'airline#parts#filetype')
  call airline#parts#define('readonly', {
        \ 'function': 'airline#parts#readonly',
        \ 'accent': 'red',
        \ })
  call airline#parts#define_raw('file', '%f%m')
  call airline#parts#define_raw('path', '%F%m')
  call airline#parts#define('linenr', {
        \ 'raw': '%{g:airline_symbols.linenr}%4l',
        \ 'accent': 'bold'})
  call airline#parts#define('maxlinenr', {
        \ 'raw': '/%L%{g:airline_symbols.maxlinenr}',
        \ 'accent': 'bold'})
  call airline#parts#define_function('ffenc', 'airline#parts#ffenc')
  call airline#parts#define('hunks', {
        \ 'raw': '',
        \ 'minwidth': 100})
  call airline#parts#define('branch', {
        \ 'raw': '',
        \ 'minwidth': 80})
  call airline#parts#define('coc_status', {
        \ 'raw': '',
        \ 'accent': 'bold'
        \ })
  call airline#parts#define_empty(['obsession', 'tagbar', 'syntastic-warn',
        \ 'syntastic-err', 'eclim', 'whitespace','windowswap',
        \ 'ycm_error_count', 'ycm_warning_count', 'neomake_error_count',
        \ 'neomake_warning_count', 'ale_error_count', 'ale_warning_count',
        \ 'lsp_error_count', 'lsp_warning_count',
        \ 'languageclient_error_count', 'languageclient_warning_count',
        \ 'coc_warning_count', 'coc_error_count', 'vista'])
  call airline#parts#define_text('bookmark', '')
  call airline#parts#define_text('capslock', '')
  call airline#parts#define_text('gutentags', '')
  call airline#parts#define_text('grepper', '')
  call airline#parts#define_text('xkblayout', '')
  call airline#parts#define_text('keymap', '')

  unlet g:airline#init#bootstrapping
endfunction

function! airline#init#gui_mode()
  return has('gui_running') || (has("termguicolors") && &termguicolors == 1) ?  'gui' : 'cterm'
endfunction

function! airline#init#sections()
  let spc = g:airline_symbols.space
  if !exists('g:airline_section_a')
    let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'keymap', 'spell', 'capslock', 'xkblayout', 'iminsert'])
  endif
  if !exists('g:airline_section_b')
    let g:airline_section_b = airline#section#create(['hunks', 'branch'])
  endif
  if !exists('g:airline_section_c')
    if exists("+autochdir") && &autochdir == 1
      let g:airline_section_c = airline#section#create(['%<', 'path', spc, 'readonly'])
    else
      let g:airline_section_c = airline#section#create(['%<', 'file', spc, 'readonly', 'coc_status'])
    endif
  endif
  if !exists('g:airline_section_gutter')
    let g:airline_section_gutter = airline#section#create(['%='])
  endif
  if !exists('g:airline_section_x')
    let g:airline_section_x = airline#section#create_right(['bookmark', 'tagbar', 'vista', 'gutentags', 'grepper', 'filetype'])
  endif
  if !exists('g:airline_section_y')
    let g:airline_section_y = airline#section#create_right(['ffenc'])
  endif
  if !exists('g:airline_section_z')
    if airline#util#winwidth() > 79
      let g:airline_section_z = airline#section#create(['windowswap', 'obsession', '%3p%%'.spc, 'linenr', 'maxlinenr', spc.':%3v'])
    else
      let g:airline_section_z = airline#section#create(['%3p%%'.spc, 'linenr',  ':%3v'])
    endif
  endif
  if !exists('g:airline_section_error')
    let g:airline_section_error = airline#section#create(['ycm_error_count', 'syntastic-err', 'eclim', 'neomake_error_count', 'ale_error_count', 'lsp_error_count', 'languageclient_error_count', 'coc_error_count'])
  endif
  if !exists('g:airline_section_warning')
    let g:airline_section_warning = airline#section#create(['ycm_warning_count',  'syntastic-warn', 'neomake_warning_count', 'ale_warning_count', 'lsp_warning_count', 'languageclient_warning_count', 'whitespace', 'coc_warning_count'])
  endif
endfunction
