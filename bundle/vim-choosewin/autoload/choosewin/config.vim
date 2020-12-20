let s:default = {
      \ 'statusline_replace':      1,
      \ 'tabline_replace':         1,
      \ 'overlay_enable':          0,
      \ 'overlay_font_size':       'auto',
      \ 'overlay_shade':           0,
      \ 'overlay_shade_priority':  100,
      \ 'overlay_label_priority':  101,
      \ 'overlay_clear_multibyte': 1,
      \ 'label_align':             'center',
      \ 'label_padding':           3,
      \ 'tablabel':                '123456789',
      \ 'blink_on_land':           1,
      \ 'return_on_single_win':    0,
      \ 'label':                   'ABCDEFGHIJKLMNOPQRTUVWXYZ',
      \ 'keymap':                  {},
      \ 'hook':                    {},
      \ 'hook_enable':             0,
      \ 'hook_bypass':             [],
      \ 'land_char':               ';',
      \ 'active':                  0,
      \ 'debug':                   0,
      \ 'label_fill':              0,
      \ 'color_label':            { 'gui': ['DarkGreen', 'white', 'bold'], 'cterm': [ 22, 15,'bold'] },
      \ 'color_label_current':    { 'gui': ['LimeGreen', 'black', 'bold'], 'cterm': [ 40, 16, 'bold'] },
      \ 'color_overlay':          { 'gui': ['DarkGreen', 'DarkGreen' ], 'cterm': [ 22, 22 ] },
      \ 'color_overlay_current':  { 'gui': ['LimeGreen', 'LimeGreen' ], 'cterm': [ 40, 40 ] },
      \ 'color_other':            { 'gui': ['gray20', 'black'], 'cterm': [ 240, 0] },
      \ 'color_land':             { 'gui':[ 'LawnGreen', 'Black', 'bold,underline'], 'cterm': ['magenta', 'white'] },
      \ 'color_shade':            { 'gui':[ '', '#777777'], 'cterm': ['', 'grey'] },
      \ }

let s:keymap = {
      \ '0':     'tab_first',
      \ '[':     'tab_prev',
      \ ']':     'tab_next',
      \ '$':     'tab_last',
      \ 'x':     'tab_close',
      \ ';':     'win_land',
      \ '-':     'previous',
      \ 's':     'swap',
      \ 'S':     'swap_stay',
      \ "\<CR>": 'win_land',
      \ }

" These are variables cannot set directly via global variable.
let s:api_options = {
      \ 'swap':        0,
      \ 'swap_stay':   0,
      \ 'auto_choose': 0,
      \ 'noop':        0,
      \ }

" Config:
let s:config = {}

function! s:config.user() "{{{1
  let R = {}
  let prefix = 'choosewin_'
  for [name, default] in items(s:default)
    let R[name] = get(g:, prefix . name, default)
    unlet default
  endfor
  return R
endfunction

function! s:config.get() "{{{1
  let conf = extend(self.user(), s:api_options)
  call extend(conf['keymap'], s:keymap, 'keep')
  call filter(conf['keymap'], "v:val isnot '<NOP>'")
  return conf
endfunction
"}}}

" API:
function! choosewin#config#get() "{{{1
  return s:config.get()
endfunction
"}}}

" vim: fdm=marker:
