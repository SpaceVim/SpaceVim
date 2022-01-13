let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'colorscheme',
      \ 'hooks': {},
      \ 'action_table': {'*': {}},
      \ }

function! s:unite_source.hooks.on_init(args, context)
  let s:beforecolor = get(g:, 'colors_name', 'default')
endfunction

function! s:unite_source.hooks.on_close(args, context)
  if s:beforecolor == g:colors_name
    return
  endif
  execute s:colorscheme(s:beforecolor)
endfunction

let s:unite_source.action_table['*'].preview = {
      \ 'description' : 'preview this colorscheme',
      \ 'is_quit' : 0,
      \ }

function! s:unite_source.action_table['*'].preview.func(candidate)
  execute a:candidate.action__command
endfunction

function! s:colorscheme(x)
  return printf("%s %s",
        \ get(g:, 'unite_colorscheme_command', 'colorscheme'),
        \ a:x)
endfunction

function! s:blacklist_colorschemes(colorlist)
  let blacklist = get(g:, 'unite_colorscheme_blacklist', [])
  let kept = []
  for color in a:colorlist
    if index(blacklist, color[0]) < 0
      let kept = add(kept, color)
    endif
  endfor
  return kept
endfunction

function! s:unite_source.gather_candidates(args, context)
  " [(name, path)]
  " e.g. [('adaryn', '/Users/ujihisa/.vimbundles/ColorSamplerPack/colors/adaryn.vim'), ...]
  let colorlist = unite#util#sort_by(unite#util#uniq_by(
      \ map(split(globpath(&runtimepath, 'colors/*.vim'), '\n'),
      \'[fnamemodify(v:val, ":t:r"), fnamemodify(v:val, ":p")]'), 'v:val[0]'),
      \'v:val[0]')
  let colorlist = s:blacklist_colorschemes(colorlist)

  " "action__type" is necessary to avoid being added into cmdline-history.
  return map(colorlist, '{
        \ "word": v:val[0],
        \ "source": "colorscheme",
        \ "kind": ["file", "command"],
        \ "action__command": s:colorscheme(v:val[0]),
        \ "action__type": ": ",
        \ "action__path": v:val[1],
        \ "action__directory": fnamemodify(v:val[1], ":h"),
        \ }')
endfunction

function! unite#sources#colorscheme#define()
  return s:unite_source
endfunction


"unlet s:unite_source

let &cpo = s:save_cpo
unlet s:save_cpo
