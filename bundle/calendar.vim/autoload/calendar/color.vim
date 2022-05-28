" =============================================================================
" Filename: autoload/calendar/color.vim
" Author: itchyny
" License: MIT License
" Last Change: 2019/07/30 22:37:29.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Color utility

let s:is_gui = has('gui_running') || (has('termguicolors') && &termguicolors)
let s:is_cterm = !s:is_gui
let s:is_win32cui = has('win32') && !s:is_gui
let s:term = s:is_gui ? 'gui' : 'cterm'
let s:is_dark = -1
let s:colors_name = ''
let s:background = ''

" &background is not useful on non-GUI environment when colorscheme executes :highlight Normal ctermbg=23X.
"   ref: syntax.c /set_option_value
function! calendar#color#is_dark() abort
  if s:is_dark >= 0 && s:colors_name ==# get(g:, 'colors_name', '') && s:background ==# &background
    return s:is_dark
  endif
  let s:colors_name = get(g:, 'colors_name', '')
  let s:background = &background
  if s:is_gui
    let s:is_dark = &background ==# 'dark'
    return s:is_dark
  endif
  let bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg', s:term)
  if bg_color !=# ''
    let [r, g, b] = calendar#color#nr_rgb(bg_color)
    let s:is_dark = r + g + b < 7 || 232 <= bg_color && bg_color <= 243
    return s:is_dark
  endif
  let fg_color = synIDattr(synIDtrans(hlID('Normal')), 'fg', s:term)
  if fg_color !=# ''
    let [r, g, b] = calendar#color#nr_rgb(fg_color)
    let s:is_dark = r + g + b > 8 || 244 <= fg_color
    return s:is_dark
  endif
  let bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg', 'gui')
  if bg_color =~# '^#......$'
    let s:is_dark = s:is_dark_color(bg_color)
    return s:is_dark
  endif
  let fg_color = synIDattr(synIDtrans(hlID('Normal')), 'fg', 'gui')
  if fg_color =~# '^#......$'
    let s:is_dark = s:is_light_color(fg_color)
    return s:is_dark
  endif
  let s:is_dark = &background ==# 'dark'
  return s:is_dark
endfunction

function! calendar#color#new_syntax(id, fg, bg) abort
  if has_key(b:, 'calendar')
    if !has_key(b:calendar, 'syntaxnames')
      let b:calendar.syntaxnames = []
    endif
    let syntaxnames = b:calendar.syntaxnames
    if !has_key(b:calendar, 'syntax')
      let b:calendar.syntax = {}
    endif
    let b:calendar.syntax[a:id] = [a:id, a:fg, a:bg]
  else
    let syntaxnames = []
  endif
  let name = s:shorten(substitute(a:id, '[^a-zA-Z0-9]', '', 'g'))
  if len(name) && len(a:fg) && len(a:bg)
    if index(syntaxnames, name) >= 0
      return name
    endif
    let flg = 0
    let is_dark = calendar#color#is_dark()
    if is_dark && s:is_dark_color(a:fg) || !is_dark && s:is_light_color(a:fg)
      let flg = 1
      let [fg, bg] = [a:bg, '']
    else
      let [fg, bg] = [a:fg, a:bg]
    endif
    let cuifg = calendar#color#convert(fg)
    let cuibg = calendar#color#convert(bg)
    if flg
      let _bg = bg
      let _cuibg = cuibg
    else
      let _bg = calendar#color#whiten(bg)
      let _cuibg = calendar#color#convert(_bg)
    endif
    if cuifg >= 0
      if index(syntaxnames, name) < 0
        call add(syntaxnames, name)
      endif
      if _cuibg >= 0
        exec 'highlight Calendar' . name . ' ctermfg=' . cuifg . ' ctermbg=' . _cuibg . ' guifg=' . fg . ' guibg=' . _bg
      else
        exec 'highlight Calendar' . name . ' ctermfg=' . cuifg . ' guifg=' . fg
      endif
      let select_bg = s:select_color()
      if type(select_bg) == type('') || select_bg >= 0
        let nameselect = name . 'Select'
        if index(syntaxnames, nameselect) < 0
          call add(syntaxnames, nameselect)
        endif
        if s:is_gui
          exec 'highlight Calendar' . nameselect . ' guifg=' . fg . ' guibg=' . (flg ? select_bg : bg)
        else
          exec 'highlight Calendar' . nameselect . ' ctermfg=' . cuifg . ' ctermbg=' . (flg ? select_bg : cuibg)
        endif
      endif
    endif
    return name
  endif
  return ''
endfunction

function! calendar#color#refresh_syntax() abort
  if !has_key(b:, 'calendar') || !has_key(b:calendar, 'syntaxnames') || !has_key(b:calendar, 'syntax')
    return
  endif
  let b:calendar.syntaxnames = []
  for [id, fg, bg] in values(b:calendar.syntax)
    call calendar#color#new_syntax(id, fg, bg)
  endfor
endfunction

function! calendar#color#convert(rgb) abort
  let rgb = map(matchlist(a:rgb, '#\(..\)\(..\)\(..\)')[1:3], '0 + ("0x".v:val)')
  if len(rgb) == 0
    return -1
  endif
  if rgb[0] == 0xc0 && rgb[1] == 0xc0 && rgb[2] == 0xc0
    return 7
  elseif rgb[0] == 0x80 && rgb[1] == 0x80 && rgb[2] == 0x80
    return 8
  elseif s:is_win32cui
    if rgb[0] > 127 && rgb[1] > 127 && rgb[2] > 127
      let min = 0
      for r in rgb
        let min = min([min, r])
      endfor
      let rgb[index(rgb, min)] -= 127
    endif
    let newrgb = [rgb[0] > 0xa0 ? 4 : 0, rgb[1] > 0xa0 ? 2 : 0, rgb[2] > 0xa0 ? 1 : 0]
    return newrgb[0] + newrgb[1] + newrgb[2] + (rgb[0] > 196 || rgb[1] > 196 || rgb[2] > 196) * 8
  elseif (rgb[0] == 0x80 || rgb[0] == 0x00) && (rgb[1] == 0x80 || rgb[1] == 0x00) && (rgb[2] == 0x80 || rgb[2] == 0x00)
    return (rgb[0] / 0x80) + (rgb[1] / 0x80) * 2 + (rgb[1] / 0x80) * 4
  elseif (rgb[0]-rgb[1] >= 0 ? rgb[0]-rgb[1] : -(rgb[0]-rgb[1])) < 3
    \ && (rgb[1]-rgb[2] >= 0 ? rgb[1]-rgb[2] : -(rgb[1]-rgb[2])) < 3
    \ && (rgb[2]-rgb[0] >= 0 ? rgb[2]-rgb[0] : -(rgb[2]-rgb[0])) < 3
    return s:black((rgb[0] + rgb[1] + rgb[2]) / 3)
  else
    return 16 + ((s:nr(rgb[0]) * 6) + s:nr(rgb[1])) * 6 + s:nr(rgb[2])
  endif
endfunction

function! calendar#color#whiten(rgb) abort
  let rgb = map(matchlist(a:rgb, '#\(..\)\(..\)\(..\)')[1:3], '0 + ("0x".v:val)')
  if len(rgb) == 0
    return -1
  endif
  return printf('#%02x%02x%02x', min([rgb[0] + 0x36, 0xff]), min([rgb[1] + 0x36, 0xff]), min([rgb[2] + 0x36, 0xff]))
endfunction

function! s:black(x) abort
  if a:x < 0x04
    return 16
  elseif a:x > 0xf4
    return 231
  elseif index([0x00, 0x5f, 0x87, 0xaf, 0xdf, 0xff], a:x) >= 0
    let l = a:x / 0x30
    return ((l * 6) + l) * 6 + l + 16
  else
    return 232 + (a:x < 8 ? 0 : a:x < 0x60 ? (a:x-8)/10 : a:x < 0x76 ? (a:x-0x60)/6+9 : (a:x-8)/10)
  endif
endfunction

function! s:nr(x) abort
  return a:x < 0x2f ? 0 : a:x < 0x73 ? 1 : a:x < 0x9b ? 2 : a:x < 0xc7 ? 3 : a:x < 0xef ? 4 : 5
endfunction

function! s:is_dark_color(rgb) abort
  let rgb = map(matchlist(a:rgb, '#\(..\)\(..\)\(..\)')[1:3], '0 + ("0x".v:val)')
  return len(rgb) == 3 && rgb[0] < 0x2f && rgb[1] < 0x2f && rgb[2] < 0x2f
endfunction

function! s:is_light_color(rgb) abort
  let rgb = map(matchlist(a:rgb, '#\(..\)\(..\)\(..\)')[1:3], '0 + ("0x".v:val)')
  return len(rgb) == 3 && rgb[0] > 0xd0 && rgb[1] > 0xd0 && rgb[2] > 0xd0
endfunction

function! calendar#color#gui_color() abort
  if has_key(s:, '_gui_color') | return s:_gui_color | endif
  let s:_gui_color = {
        \ 'black'          : '#000000',
        \ 'white'          : '#ffffff',
        \
        \ 'darkestgreen'   : '#005f00',
        \ 'darkgreen'      : '#008700',
        \ 'mediumgreen'    : '#5faf00',
        \ 'brightgreen'    : '#afdf00',
        \
        \ 'darkestcyan'    : '#005f5f',
        \ 'mediumcyan'     : '#87dfff',
        \
        \ 'darkestblue'    : '#005f87',
        \ 'darkblue'       : '#0087af',
        \
        \ 'darkestred'     : '#5f0000',
        \ 'darkred'        : '#870000',
        \ 'mediumred'      : '#af0000',
        \ 'brightred'      : '#df0000',
        \ 'brightestred'   : '#ff0000',
        \
        \ 'darkestpurple'  : '#5f00af',
        \ 'mediumpurple'   : '#875fdf',
        \ 'brightpurple'   : '#dfdfff',
        \
        \ 'brightorange'   : '#ff8700',
        \ 'brightestorange': '#ffaf00',
        \
        \ 'gray0'          : '#121212',
        \ 'gray1'          : '#262626',
        \ 'gray2'          : '#303030',
        \ 'gray3'          : '#4e4e4e',
        \ 'gray4'          : '#585858',
        \ 'gray5'          : '#606060',
        \ 'gray6'          : '#808080',
        \ 'gray7'          : '#8a8a8a',
        \ 'gray8'          : '#9e9e9e',
        \ 'gray9'          : '#bcbcbc',
        \ 'gray10'         : '#d0d0d0',
        \
        \ 'yellow'         : '#b58900',
        \ 'orange'         : '#cb4b16',
        \ 'red'            : '#dc322f',
        \ 'magenta'        : '#d33682',
        \ 'violet'         : '#6c71c4',
        \ 'blue'           : '#268bd2',
        \ 'cyan'           : '#2aa198',
        \ 'green'          : '#859900',
        \ }
  return s:_gui_color
endfunction

function! calendar#color#to_256color(nr, fg) abort
  if a:nr == 0 || a:nr == 16
    return 232
  elseif a:nr == 15 || a:nr == 231
    return 255
  elseif a:nr < 16
    if a:fg
      return calendar#color#is_dark() ? 255 : 232
    else
      return calendar#color#is_dark() ? 232 : 255
    endif
  else
    return a:nr
  endif
endfunction

function! calendar#color#fg_color(syntax_name) abort
  let color = synIDattr(synIDtrans(hlID(a:syntax_name)), 'fg', s:term)
  return s:is_gui ? color : calendar#color#to_256color((len(color) == 0 ? -1 : color) + 0, 1)
endfunction

function! calendar#color#bg_color(syntax_name) abort
  let color = synIDattr(synIDtrans(hlID(a:syntax_name)), 'bg', s:term)
  return s:is_gui ? color : calendar#color#to_256color((len(color) == 0 ? -1 : color) + 0, 0)
endfunction

function! calendar#color#normal_fg_color() abort
  if s:is_win32cui
    if calendar#color#is_dark()
      return 15
    else
      return 0
    endif
  endif
  let fg_color = calendar#color#fg_color('Normal')
  if s:is_cterm && type(fg_color) == type(0) && fg_color < 0
    if calendar#color#is_dark()
      return 255
    else
      return 232
    endif
  endif
  return fg_color
endfunction

function! calendar#color#normal_bg_color() abort
  if s:is_win32cui
    if calendar#color#is_dark()
      return 0
    else
      return 15
    endif
  endif
  let bg_color = calendar#color#bg_color('Normal')
  if s:is_cterm && type(bg_color) == type(0) && bg_color < 0
    if calendar#color#is_dark()
      return 232
    else
      return 255
    endif
  endif
  return bg_color
endfunction

function! calendar#color#comment_fg_color() abort
  if s:is_win32cui
    return 7
  endif
  let fg_color = calendar#color#fg_color('Comment')
  if s:is_cterm && type(fg_color) == type(0) && fg_color < 0
    if calendar#color#is_dark()
      return 244
    else
      return 243
    endif
  endif
  return fg_color
endfunction

function! calendar#color#comment_bg_color() abort
  if s:is_win32cui
    if calendar#color#is_dark()
      return 0
    else
      return 15
    endif
  endif
  let bg_color = calendar#color#bg_color('Comment')
  if s:is_cterm && type(bg_color) == type(0) && bg_color < 0
    if calendar#color#is_dark()
      return 232
    else
      return 255
    endif
  endif
  return bg_color
endfunction

function! calendar#color#nr_rgb(nr) abort
  let x = a:nr * 1
  if x < 8
    let [b, rg] = [x / 4, x % 4]
    let [g, r] = [rg / 2, rg % 2]
    return [r * 3, g * 3, b * 3]
  elseif x == 8
    return [4, 4, 4]
  elseif x < 16
    let y = x - 8
    let [b, rg] = [y / 4, y % 4]
    let [g, r] = [rg / 2, rg % 2]
    return [r * 5, g * 5, b * 5]
  elseif x < 232
    let y = x - 16
    let [rg, b] = [y / 6, y % 6]
    let [r, g] = [rg / 6, rg % 6]
    return [r, g, b]
  else
    let k = (x - 232) * 5 / 23
    return [k, k, k]
  endif
endfunction

if s:is_win32cui

  function! calendar#color#gen_color(fg, bg, weightfg, weightbg) abort
    return a:weightfg > a:weightbg ? a:fg : a:bg
  endfunction

elseif s:is_cterm

  function! calendar#color#gen_color(fg, bg, weightfg, weightbg) abort
    let fg = a:fg < 0 ? (s:is_dark ?  255 : 232) : a:fg
    let bg = a:bg < 0 ? (s:is_dark ?  232 : 255) : a:bg
    let fg_rgb = calendar#color#nr_rgb(fg)
    let bg_rgb = calendar#color#nr_rgb(bg)
    if fg > 231 && bg > 231
      let color = (fg * a:weightfg + bg * a:weightbg) / (a:weightfg + a:weightbg)
    elseif fg < 16 || bg < 16
      let color = a:weightfg > a:weightbg ? fg : bg
    else
      let color_rgb = map([0, 1, 2], '(fg_rgb[v:val] * a:weightfg + bg_rgb[v:val] * a:weightbg) / (a:weightfg + a:weightbg)')
      let color = ((color_rgb[0] * 6 + color_rgb[1]) * 6 + color_rgb[2]) + 16
    endif
    return color
  endfunction

  function! calendar#color#select_rgb(color, rgb, weight) abort
    let c = calendar#color#nr_rgb(a:color < 0 ? (s:is_dark ? 255 : 232) : a:color)
    let cc = max([(c[0] + c[1] + c[2]) / 3, 5])
    let colors = [cc / a:weight, cc / a:weight, cc / a:weight]
    let colors[a:rgb] = cc
    let color = ((colors[0] * 6 + colors[1]) * 6 + colors[2]) + 16
    return color
  endfunction

else

  function! calendar#color#gen_color(fg, bg, weightfg, weightbg) abort
    let fg_rgb = map(matchlist(a:fg[0] == '#' ? a:fg : get(calendar#color#gui_color(), a:fg, ''), '#\(..\)\(..\)\(..\)')[1:3], '("0x".v:val) + 0')
    let bg_rgb = map(matchlist(a:bg[0] == '#' ? a:bg : get(calendar#color#gui_color(), a:bg, ''), '#\(..\)\(..\)\(..\)')[1:3], '("0x".v:val) + 0')
    if len(fg_rgb) != 3 | let fg_rgb = s:is_dark ?  [0xe4, 0xe4, 0xe4] : [0x12, 0x12, 0x12] | endif
    if len(bg_rgb) != 3 | let bg_rgb = s:is_dark ? [0x12, 0x12, 0x12] : [0xe4, 0xe4, 0xe4] | endif
    let color_rgb = map(map([0, 1, 2], '(fg_rgb[v:val] * a:weightfg + bg_rgb[v:val] * a:weightbg) / (a:weightfg + a:weightbg)'), 'v:val < 0 ? 0 : v:val > 0xff ? 0xff : v:val')
    let color = printf('0x%02x%02x%02x', color_rgb[0], color_rgb[1], color_rgb[2]) + 0
    if color < 0 || 0xffffff < color | let color = s:is_dark ? 0x3a3a3a : 0xbcbcbc | endif
    return printf('#%06x', color)
  endfunction

  function! calendar#color#select_rgb(color, rgb) abort
    let c = map(matchlist(a:color[0] == '#' ? a:color : get(calendar#color#gui_color(), a:color, ''), '#\(..\)\(..\)\(..\)')[1:3], '("0x".v:val) + 0')
    if len(c) != 3 | let c = s:is_dark ? [0xe4, 0xe4, 0xe4] : [0x12, 0x12, 0x12] | endif
    let cc = max([(c[0] + c[1] + c[2]) / 3, 0x6f])
    let color = printf('0x%02x%02x%02x', a:rgb % 2 ? cc : cc / 9, (a:rgb / 2) % 2 ? cc : cc / 9, (a:rgb / 4) % 2 ? cc : cc / 9) + 0
    if color < 0 || 0xffffff < color | let color = s:is_dark ? 0x3a3a3a : 0xbcbcbc | endif
    return printf('#%06x', color)
  endfunction

endif

function! calendar#color#colors() abort
  return [
        \ '#16a765',
        \ '#4986e7',
        \ '#fad165',
        \ '#b99aff',
        \ '#f83a22',
        \ '#9fe1e7',
        \ '#ffad46',
        \ '#9a9cff',
        \ '#f691b2',
        \ '#9fe1e7',
        \ '#92e1c0',
        \ '#ac725e',
        \ '#ff7537',
        \ '#b3dc6c',
        \ '#9fc6e7',
        \ '#fbe983',
        \ '#d06b64',
        \ ]
endfunction

function! calendar#color#syntax(name, fg, bg, attr) abort
  let term = len(a:attr) ? ' term=' . a:attr . ' cterm=' . a:attr . ' gui=' . a:attr : ''
  if s:is_gui
    let fg = len(a:fg) ? ' guifg=' . a:fg : ''
    let bg = len(a:bg) ? ' guibg=' . a:bg : ''
  else
    let fg = len(a:fg) ? ' ctermfg=' . a:fg : ''
    let bg = len(a:bg) ? ' ctermbg=' . a:bg : ''
  endif
  exec 'highlight Calendar' . a:name . term . fg . bg
endfunction

let s:_select_color = {}
function! s:select_color() abort
  let key = get(g:, 'colors_name', '') . &background
  if has_key(s:_select_color, key)
    return s:_select_color[key]
  endif
  let fg_color = calendar#color#normal_fg_color()
  let bg_color = calendar#color#normal_bg_color()
  let select_color = calendar#color#gen_color(fg_color, bg_color, 1, 4)
  if s:is_win32cui
    let select_color = s:is_dark ? 8 : 7
  endif
  let s:_select_color[key] = select_color
  return select_color
endfunction

let s:num = 0
let s:nums = {}
function! s:shorten(name) abort
  let name = matchstr(a:name, '...')
  let name = name ==# '' ? a:name : name
  let s:num = (s:num + 1) % 26
  let s:nums[a:name] = get(s:nums, a:name, s:num)
  return name . 'abcdefghijklmnopqrstuvwxyz'[s:nums[a:name]]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
