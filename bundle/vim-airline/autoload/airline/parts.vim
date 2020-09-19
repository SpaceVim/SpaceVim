" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:parts = {}

" PUBLIC API {{{

function! airline#parts#define(key, config)
  let s:parts[a:key] = get(s:parts, a:key, {})
  if exists('g:airline#init#bootstrapping')
    call extend(s:parts[a:key], a:config, 'keep')
  else
    call extend(s:parts[a:key], a:config, 'force')
  endif
endfunction

function! airline#parts#define_function(key, name)
  call airline#parts#define(a:key, { 'function': a:name })
endfunction

function! airline#parts#define_text(key, text)
  call airline#parts#define(a:key, { 'text': a:text })
endfunction

function! airline#parts#define_raw(key, raw)
  call airline#parts#define(a:key, { 'raw': a:raw })
endfunction

function! airline#parts#define_minwidth(key, width)
  call airline#parts#define(a:key, { 'minwidth': a:width })
endfunction

function! airline#parts#define_condition(key, predicate)
  call airline#parts#define(a:key, { 'condition': a:predicate })
endfunction

function! airline#parts#define_accent(key, accent)
  call airline#parts#define(a:key, { 'accent': a:accent })
endfunction

function! airline#parts#define_empty(keys)
  for key in a:keys
    call airline#parts#define_raw(key, '')
  endfor
endfunction

function! airline#parts#get(key)
  return get(s:parts, a:key, {})
endfunction

" }}}

function! airline#parts#mode()
  return airline#util#shorten(get(w:, 'airline_current_mode', ''), 79, 1)
endfunction

function! airline#parts#crypt()
  return g:airline_detect_crypt && exists("+key") && !empty(&key) ? g:airline_symbols.crypt : ''
endfunction

function! airline#parts#paste()
  return g:airline_detect_paste && &paste ? g:airline_symbols.paste : ''
endfunction

function! airline#parts#spell()
  let spelllang = g:airline_detect_spelllang ? printf(" [%s]", toupper(substitute(&spelllang, ',', '/', 'g'))) : ''
  if g:airline_detect_spell && &spell
    let winwidth = airline#util#winwidth()
    if winwidth >= 90
      return g:airline_symbols.spell . spelllang
    elseif winwidth >= 70
      return g:airline_symbols.spell
    else
      return split(g:airline_symbols.spell, '\zs')[0]
    endif
  endif
  return ''
endfunction

function! airline#parts#iminsert()
  if g:airline_detect_iminsert && &iminsert && exists('b:keymap_name')
    return toupper(b:keymap_name)
  endif
  return ''
endfunction

function! airline#parts#readonly()
  " only consider regular buffers (e.g. ones that represent actual files,
  " but not special ones like e.g. NERDTree)
  if !empty(&buftype) || airline#util#ignore_buf(bufname('%'))
    return ''
  endif
  if &readonly && !filereadable(bufname('%'))
    return '[noperm]'
  else
    return &readonly ? g:airline_symbols.readonly : ''
  endif
endfunction

function! airline#parts#filetype()
  return (airline#util#winwidth() < 90 && strlen(&filetype) > 3)
        \ ? matchstr(&filetype, '...'). (&encoding is? 'utf-8' ? '…' : '>')
        \ : &filetype
endfunction

function! airline#parts#ffenc()
  let expected = get(g:, 'airline#parts#ffenc#skip_expected_string', '')
  let bomb     = &l:bomb ? '[BOM]' : ''
  let ff       = strlen(&ff) ? '['.&ff.']' : ''
  if expected is# &fenc.bomb.ff
    return ''
  else
    return &fenc.bomb.ff
  endif
endfunction
