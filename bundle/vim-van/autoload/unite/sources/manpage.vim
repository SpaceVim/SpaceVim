let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'manpage',
      \ 'hooks': {},
      \ 'action_table': {'*': {}},
      \ }

let s:unite_source.action_table['*'].preview = {
      \ 'description' : 'open this manpage',
      \ 'is_quit' : 0,
      \ }

function! s:unite_source.action_table['*'].preview.func(candidate)
  execute a:candidate.action__command
endfunction

function! s:manpage(x)
  return printf("%s %s", "SuperMan", a:x)
endfunction

function! s:unite_source.gather_candidates(args, context)

  let l:manpages = system("apropos . | awk \'{print $1}\'")

  let manpageslist = unite#util#sort_by(unite#util#uniq_by(
      \ map(split(l:manpages, '\n'),
      \'[fnamemodify(v:val, ":t:r"), fnamemodify(v:val, ":p")]'), 'v:val[0]'),
      \'v:val[0]')

  return map(manpageslist, '{
        \ "word": v:val[0],
        \ "source": "manpage",
        \ "kind": ["file", "command"],
        \ "action__command": s:manpage(v:val[0]),
        \ "action__type": ": ",
        \ "action__path": v:val[1],
        \ "action__directory": fnamemodify(v:val[1], ":h"),
        \ }')
endfunction

function! unite#sources#manpage#define()
  return s:unite_source
endfunction

"unlet s:unite_source

let &cpo = s:save_cpo
unlet s:save_cpo
