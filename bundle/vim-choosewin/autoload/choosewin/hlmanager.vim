" Util:
function! s:define_type_checker() "{{{1
  " dynamically define s:is_Number(v)  etc..
  let types = {
        \ "Number":     0,
        \ "String":     1,
        \ "Funcref":    2,
        \ "List":       3,
        \ "Dictionary": 4,
        \ "Float":      5,
        \ }

  for [type, number] in items(types)
    let s = ''
    let s .= 'function! s:is_' . type . '(v)' . "\n"
    let s .= '  return type(a:v) is ' . number . "\n"
    let s .= 'endfunction' . "\n"
    execute s
  endfor
endfunction
"}}}
call s:define_type_checker()
unlet! s:define_type_checker

" Copied from vim-airline's airline#init#gui_mode function
let s:SCREEN = (has('gui_running') ||
      \ (has('termtruecolor') && &guicolors == 1) ||
      \ (has('termguicolors') && &termguicolors == 1) ||
      \ (has('nvim') && exists('$NVIM_TUI_ENABLE_TRUE_COLOR')
      \ && !exists('+termguicolors'))) ? 'gui' : 'cterm'

" Main:
let s:hlmgr = {}

function! s:hlmgr.new(prefix) "{{{1
  let R = deepcopy(self)
  call R.init(a:prefix)
  return R
endfunction

function! s:hlmgr.init(prefix) "{{{1
  let self._colors = {}
  let self._specs = {}
  let self.prefix      = a:prefix
  return self
endfunction

function! s:hlmgr.register_auto(spec) "{{{1
  if s:is_String(a:spec)
    return a:spec
  endif

  if s:is_Dictionary(a:spec)
    let spec = string(a:spec[s:SCREEN])
    let name = get(self._specs, spec, '')
    if !empty(name)
      " If color is already defined for spec provided.
      " return that color
      return name
    endif
  endif

  return self.register(self.color_next(), a:spec)
endfunction

function! s:hlmgr.register(name, spec) "{{{1
  call self.define(a:name, a:spec)
  let self._colors[a:name] = a:spec

  " This might overwrite existing spec but its OK since _specs is simple color
  " re-using mechanizm for performance.
  let self._specs[string(a:spec[s:SCREEN])] = a:name
  return a:name
endfunction

function! s:hlmgr.define(name, color) "{{{1
  let command = printf('highlight %s %s', a:name, self.hl_defstr(a:color))
  silent execute command
endfunction

function! s:hlmgr.refresh() "{{{1
  for [name, color] in items(self._colors)
    call self.define(name, color)
  endfor
endfunction

function! s:hlmgr.color_next() "{{{1
  return printf(self.prefix . '%05d', len(self._colors))
endfunction

function! s:hlmgr.reset() "{{{1
  call self.clear()
  call self.init(self.prefix)
endfunction

function! s:hlmgr.spec_for(color) "{{{1
  return get(self._colors, a:color, '')
endfunction

function! s:hlmgr.parse(spec, ...) "{{{1
  " return dictionary from string
  " 'guifg=#25292c guibg=#afb0ae' =>  {'gui': ['#afb0ae', '#25292c']}
  let R = {}
  if empty(a:spec)
    return R
  endif

  let screens = empty(a:000) ? [s:SCREEN] : ['gui', 'cterm' ]
  for screen in screens
    let R[screen] = ['','']
    for def in split(a:spec)
      let [key,val] = split(def, '=')
      if     key ==# screen . 'bg' | let R[screen][0]   = val
      elseif key ==# screen . 'fg' | let R[screen][1]   = val
      elseif key ==# screen        | call add(R[screen], val)
      endif
    endfor
  endfor
  return R
endfunction

function! s:hlmgr.parse_full(spec) "{{{1
  return self.parse(a:spec, 1)
endfunction

function! s:hlmgr.capture(hlname) "{{{1
  let hlname = a:hlname

  if empty(hlID(hlname))
    " if hl not exists, return empty string
    return ''
  endif

  redir => HL_SAVE
  execute 'silent! highlight ' . hlname
  redir END
  if !empty(matchstr(HL_SAVE, 'xxx cleared$'))
    return ''
  endif

  " follow highlight link
  let link = matchstr(HL_SAVE, 'xxx links to \zs.*')
  if !empty(link)
    return self.capture(link)
  endif

  return matchstr(HL_SAVE, 'xxx \zs.*')
endfunction

function! s:hlmgr.clear() "{{{1
  for color in self.colors()
    silent execute 'highlight clear' color
  endfor
endfunction

function! s:hlmgr.colors() "{{{1
  return keys(self._colors)
endfunction

function! s:hlmgr.hl_defstr(color) "{{{1
  " return 'guibg=DarkGreen gui=bold' (Type: String)
  let color = a:color[s:SCREEN]
  let R = []
  "[NOTE] empty() is not appropriate, cterm color is specified with number
  for [idx, s] in [[ 0, 'bg' ], [ 1, 'fg' ] ,[ 2, ''] ]
    let c = get(color, idx, -1)
    if (s:is_String(c) && empty(c)) || (s:is_Number(c) && c ==# -1)
      continue
    endif
    call add(R, printf('%s%s=%s', s:SCREEN, s, color[idx]))
  endfor
  return join(R)
endfunction

function! s:hlmgr.convert(hlname) "{{{1
  return self.parse(self.capture(a:hlname))
endfunction

function! s:hlmgr.convert_full(hlname) "{{{1
  return self.parse_full(self.capture(a:hlname))
endfunction

function! s:hlmgr.dump() "{{{1
  return PP(self)
endfunction
"}}}

" API:
function! choosewin#hlmanager#new(prefix) "{{{1
  return s:hlmgr.new(a:prefix)
endfunction
"}}}

" vim: foldmethod=marker
