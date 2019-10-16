"=============================================================================
" leaderf.vim --- leaderf layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#leaderf#plugins() abort
  let plugins = []
  call add(plugins, 
        \ ['Yggdroot/LeaderF',
        \ {
        \ 'loadconf' : 1,
        \ 'merged' : 0,
        \ }])
  call add(plugins, ['Shougo/neomru.vim', {'merged' : 0}])
  return plugins
endfunction


let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#leaderf#config() abort

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['?'], 'call call('
        \ . string(s:_function('s:warp_denite')) . ', ["Denite menu:CustomKeyMaps -input=[SPC]"])',
        \ ['show-mappings',
        \ [
        \ 'SPC ? is to show mappings',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['h', '[SPC]'], 'Leaderf help --input=SpaceVim',
        \ ['find-SpaceVim-help',
        \ [
        \ 'SPC h SPC is to find SpaceVim help',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)
  " @fixme SPC h SPC make vim flick
  nmap <Space>h<Space> [SPC]h[SPC]

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'b'], 'Leaderf buffer',
        \ ['buffer-list',
        \ [
        \ 'SPC b b is to open buffer list',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  " let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
  " let g:Lf_Extensions = {
        " \ "neomru": {
        " \       "source": function("neomru#_gather_file_candidates()"),
        " \       "accept": function("s:accept_mru"),
        " \       "supports_name_only": 1,
        " \       "supports_multi": 0,
        " \ },
        " \}
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'r'], 'Leaderf neomru',
        \ ['open-recent-file',
        \ [
        \ 'SPC f r is to open recent file list',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'Leaderf function',
        \ ['jump to a definition in buffer',
        \ [
        \ 'SPC j i is to jump to a definition in buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['r', 'l'], 'call call('
        \ . string(s:_function('s:warp_denite')) . ', ["Denite -resume"])',
        \ ['resume denite buffer',
        \ [
        \ 'SPC r l is to resume denite buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'Leaderf colorscheme',
        \ ['fuzzy find colorschemes',
        \ [
        \ 'SPC T s is to fuzzy find colorschemes',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'], 'call call('
        \ . string(s:_function('s:warp_denite')) . ', ["DeniteBufferDir file/rec"])',
        \ ['Find files in the directory of the current buffer',
        \ [
        \ '[SPC f f] is to find files in the directory of the current buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'f'], 'Leaderf file',
        \ ['find files in current project',
        \ [
        \ '[SPC p f] is to find files in the root of the current project',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)
  nnoremap <silent> <C-p> :<C-u>Leaderf file<cr>


  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'i'], 'LeaderfHelpCword',
        \ ['get help with the symbol at point',
        \ [
        \ '[SPC h i] is to get help with the symbol at point',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
endfunction

function! Grep(args)
  let ignorecase = ""
  if has_key(a:args, "--ignore-case")
    let ignorecase = "-i"
  endif

  let whole_word = ""
  if has_key(a:args, "-w")
    let whole_word = "-w"
  endif

  return printf("grep -n -I -r %s %s '%s' .", ignorecase, whole_word, get(a:args, "pattern", [""])[0])
endfunction

function! FormatLine(line, args)
  let line = substitute(a:line, '^[^:]*\zs:', '\t|', '')
  let line = substitute(line, '|\d\+\zs:', '|\t', '')
  return line
endfunction

function! Accept(line, args)
  let items = split(a:line, '\t')
  let file = items[0]
  let line = items[1][1:-2]
  exec "edit +".line." ".file
  norm! zz
  setlocal cursorline!
  redraw
  sleep 100m
  setlocal cursorline!
endfunction

function! Preview(orig_buf_nr, orig_cursor, ...)
  " currently, we are in the LeaderF window
  let line = getline('.')
  " jump to the original window
  exe bufwinnr(a:orig_buf_nr). "wincmd w"

  let items = split(line, '\t')
  let file = items[0]
  let line = items[1][1:-2]
  exec "edit +".line." ".file
  norm! zz
  setlocal cursorline!
  redraw
  sleep 100m
  setlocal cursorline!
endfunction

function! Highlight(args)
  highlight Grep_Pattern guifg=Black guibg=lightgreen ctermfg=16 ctermbg=120

  " suppose that pattern is not a regex
  if has_key(a:args, "-w")
    let pattern = '\<' . get(a:args, "pattern", [""])[0] . '\>'
  else
    let pattern = get(a:args, "pattern", [""])[0]
  endif

  if has_key(a:args, "--ignore-case")
    let pattern = '\c' . pattern
  endif

  let ids = []
  call add(ids, matchadd("Grep_Pattern", pattern, 20))
  return ids
endfunction

function! Get_digest(line, mode)
  " full path, i.e, the whole line
  if a:mode == 0
    return [a:line, 0]
    " name only, i.e, the part of file name
  elseif a:mode == 1
    return [split(a:line)[0], 0]
    " directory, i.e, the part of greped line
  else
    let items = split(a:line, '\t')
    return [items[2], len(a:line) - len(items[2])]
  endif
endfunction

function! Do_nothing(orig_buf_nr, orig_cursor, args)
endfunction

let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
let g:Lf_Extensions.grep =
      \ {
      \       "source": {"command": function("Grep")},
      \       "arguments": [
      \           { "name": ["pattern"], "nargs": 1 },
      \           { "name": ["--ignore-case", "-i"], "nargs": 0 },
      \           { "name": ["-w"], "nargs": 0, "help": "Select  only  those lines containing matches that form whole words." },
      \       ],
      \       "format_line": "FormatLine",
      \       "accept": "Accept",
      \       "preview": "Preview",
      \       "supports_name_only": 1,
      \       "get_digest": "Get_digest",
      \       "highlights_def": {
      \               "Lf_hl_grep_file": '^.\{-}\ze\t',
      \               "Lf_hl_grep_line": '\t|\zs\d\+\ze|\t',
      \       },
      \       "highlights_cmd": [
      \               "hi Lf_hl_grep_file guifg=red ctermfg=196",
      \               "hi Lf_hl_grep_line guifg=green ctermfg=120",
      \       ],
      \       "highlight": "Highlight",
      \       "bang_enter": "Do_nothing",
      \       "after_enter": "",
      \       "before_exit": "",
      \       "supports_multi": 0,
      \ }

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
  nnoremap <silent> <Leader>fr
        \ :<C-u>Denite -resume<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.r = ['Denite -resume',
        \ 'resume unite window',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fe
        \ :<C-u>Denite register<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.e = ['Denite register',
        \ 'fuzzy find registers',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fh
        \ :<C-u>Denite neoyank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.h = ['Denite neoyank',
        \ 'fuzzy find yank history',
        \ [
        \ '[Leader f h] is to fuzzy find history and yank content',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fj
        \ :<C-u>Denite jump<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.j = ['Denite jump',
        \ 'fuzzy find jump list',
        \ [
        \ '[Leader f j] is to fuzzy find jump list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fl
        \ :<C-u>Denite location_list<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.l = ['Denite location_list',
        \ 'fuzzy find location list',
        \ [
        \ '[Leader f l] is to fuzzy find location list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fm
        \ :<C-u>Denite output:message<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.m = ['Denite output:message',
        \ 'fuzzy find message',
        \ [
        \ '[Leader f m] is to fuzzy find message',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fq
        \ :<C-u>Denite quickfix<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.q = ['Denite quickfix',
        \ 'fuzzy find quickfix list',
        \ [
        \ '[Leader f q] is to fuzzy find quickfix list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fo  :<C-u>Leaderf function<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.o = ['Leaderf function',
        \ 'fuzzy find outline',
        \ [
        \ '[Leader f o] is to fuzzy find outline',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>f<Space> :Denite menu:CustomKeyMaps<CR>
  let g:_spacevim_mappings.f['[SPC]'] = ['Denite menu:CustomKeyMaps',
        \ 'fuzzy find custom key bindings',
        \ [
        \ '[Leader f SPC] is to fuzzy find custom key bindings',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fp  :<C-u>Denite menu:AddedPlugins<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.p = ['Denite menu:AddedPlugins',
        \ 'fuzzy find vim packages',
        \ [
        \ '[Leader f p] is to fuzzy find vim packages installed in SpaceVim',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
endfunction

function! s:accept_mru(line) abort
  exe 'e ' . line
endfunction

function! s:warp_denite(cmd) abort
  exe a:cmd
  doautocmd WinEnter
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif
" vim:set et sw=2 cc=80:
