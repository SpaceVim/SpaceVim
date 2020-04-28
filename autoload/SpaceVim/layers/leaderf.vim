"=============================================================================
" leaderf.vim --- leaderf layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')

function! SpaceVim#layers#leaderf#plugins() abort
  let plugins = []
  call add(plugins, 
        \ ['Yggdroot/LeaderF',
        \ {
        \ 'loadconf' : 1,
        \ 'merged' : 0,
        \ }])
  call add(plugins, ['Shougo/neomru.vim', {'merged' : 0}])
  call add(plugins, ['Shougo/neoyank.vim', {'merged' : 0}])

  " use this repo unicode data
  call add(plugins, ['SpaceVim/Unite-sources', {'merged' : 0}])
  return plugins
endfunction


let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#leaderf#config() abort

  " disable default key binding Leader f and Leader b
  " use ctrl-p or SPC p f to search files in project
  " use SPC b b to list buffers
  let g:Lf_ShortcutF = ''
  let g:Lf_ShortcutB = ''

  let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
  let g:Lf_Extensions = {
  \ "neomru": {
  \       "source": string(s:_function('s:neomru', 1))[10:-3],
  \       "accept": string(s:_function('s:neomru_acp', 1))[10:-3],
  \       "supports_name_only": 1,
  \       "supports_multi": 0,
  \ },
  \}

  let g:Lf_Extensions.menu =
        \ {
        \       "source": string(s:_function('s:menu', 1))[10:-3],
        \       "arguments": [
        \           { "name": ["--name"], "nargs": 1, "help": "Use leaderf show unite menu"},
        \       ],
        \       "accept": string(s:_function('s:accept', 1))[10:-3],
        \ }

  let g:Lf_Extensions.register =
        \ {
        \       "source": string(s:_function('s:register', 1))[10:-3],
        \       "accept": string(s:_function('s:register_acp', 1))[10:-3],
        \       "highlights_def": {
        \               "Lf_register_name": '^".',
        \               "Lf_register_content": '\s\+.*',
        \       },
        \       "highlights_cmd": [
        \               "hi def link Lf_register_name ModeMsg",
        \               "hi def link Lf_register_content Normal",
        \       ],
        \  'after_enter' : string(s:_function('s:init_leaderf_win', 1))[10:-3]
        \ }

  let g:Lf_Extensions.jumplist =
        \ {
        \       "source": string(s:_function('s:jumplist', 1))[10:-3],
        \       "accept": string(s:_function('s:jumplist_acp', 1))[10:-3],
        \       "highlights_def": {
        \               "Lf_register_name": '^".',
        \               "Lf_register_content": '\s\+.*',
        \       },
        \       "highlights_cmd": [
        \               "hi def link Lf_register_name ModeMsg",
        \               "hi def link Lf_register_content Normal",
        \       ],
        \  'after_enter' : string(s:_function('s:init_leaderf_win', 1))[10:-3]
        \ }

  let g:Lf_Extensions.message =
        \ {
        \       "source": string(s:_function('s:message', 1))[10:-3],
        \       "accept": string(s:_function('s:message_acp', 1))[10:-3],
        \       "highlights_def": {
        \               "Lf_register_name": '^".',
        \               "Lf_register_content": '\s\+.*',
        \       },
        \       "highlights_cmd": [
        \               "hi def link Lf_register_name ModeMsg",
        \               "hi def link Lf_register_content Normal",
        \       ],
        \  'after_enter' : string(s:_function('s:init_leaderf_win', 1))[10:-3]
        \ }

  let g:Lf_Extensions.neoyank =
        \ {
        \       "source": string(s:_function('s:neoyank', 1))[10:-3],
        \       "accept": string(s:_function('s:neoyank_acp', 1))[10:-3],
        \       "highlights_def": {
        \               "Lf_register_name": '^".',
        \               "Lf_register_content": '\s\+.*',
        \       },
        \       "highlights_cmd": [
        \               "hi def link Lf_register_name ModeMsg",
        \               "hi def link Lf_register_content Normal",
        \       ],
        \  'after_enter' : string(s:_function('s:init_leaderf_win', 1))[10:-3]
        \ }

  let g:Lf_Extensions.quickfix =
        \ {
        \       "source": string(s:_function('s:quickfix', 1))[10:-3],
        \       "accept": string(s:_function('s:quickfix_acp', 1))[10:-3],
        \       "highlights_def": {
        \               "Lf_register_name": '^".',
        \               "Lf_register_content": '\s\+.*',
        \       },
        \       "highlights_cmd": [
        \               "hi def link Lf_register_name ModeMsg",
        \               "hi def link Lf_register_content Normal",
        \       ],
        \  'after_enter' : string(s:_function('s:init_leaderf_win', 1))[10:-3]
        \ }

  let g:Lf_Extensions.locationlist =
        \ {
        \       "source": string(s:_function('s:locationlist', 1))[10:-3],
        \       "accept": string(s:_function('s:locationlist_acp', 1))[10:-3],
        \       "highlights_def": {
        \               "Lf_register_name": '^".',
        \               "Lf_register_content": '\s\+.*',
        \       },
        \       "highlights_cmd": [
        \               "hi def link Lf_register_name ModeMsg",
        \               "hi def link Lf_register_content Normal",
        \       ],
        \  'after_enter' : string(s:_function('s:init_leaderf_win', 1))[10:-3]
        \ }

  let g:Lf_Extensions.unicode =
        \ {
        \       "source": string(s:_function('s:unicode', 1))[10:-3],
        \       "accept": string(s:_function('s:unicode_acp', 1))[10:-3],
        \       "arguments": [
        \           { "name": ["--name"], "nargs": '*', "help": "Use leaderf show unite menu"},
        \       ],
        \       "highlights_def": {
        \               "Lf_register_name": '^".',
        \               "Lf_register_content": '\s\+.*',
        \       },
        \       "highlights_cmd": [
        \               "hi def link Lf_register_name ModeMsg",
        \               "hi def link Lf_register_content Normal",
        \       ],
        \  'after_enter' : string(s:_function('s:init_leaderf_win', 1))[10:-3]
        \ }

  let g:_spacevim_mappings_space.i = {'name' : '+Insertion'}
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'u'], 'Leaderf unicode', 'search-and-insert-unicode', 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['?'], 'call call('
        \ . string(s:_function('s:warp_denite')) . ', ["Leaderf menu --name CustomKeyMaps --input [SPC]"])',
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
        \ . string(s:_function('s:warp_denite')) . ', ["Leaderf --recall"])',
        \ ['resume fuzzy finder windows',
        \ [
        \ 'SPC r l is to resume fuzzy finder windows',
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
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'], 'exe "Leaderf file " . expand("%:p:h")',
        \ ['Find files in the directory of the current buffer',
        \ [
        \ '[SPC f f] is to find files in the directory of the current buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'f'],
        \ 'Leaderf file --fullPath '
        \ . SpaceVim#plugins#projectmanager#current_root(),
        \ ['find files in current project',
        \ [
        \ '[SPC p f] is to find files in the root of the current project',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)
  nnoremap <silent> <C-p> :<C-u>exe 'Leaderf file --fullPath '
        \ . SpaceVim#plugins#projectmanager#current_root()<cr>


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

function! s:init_leaderf_win(...)
  setlocal nonumber
  setlocal nowrap
endfunction

function! s:register(...)
  return split(s:CMP.execute('registers'), '\n')[1:]
endfunction

function! s:register_acp(line, args)
  let @" = a:line
  echohl ModeMsg
  echon 'Yanked!'
  echohl None
endfunction

function! s:neomru(...) abort
    return neomru#_gather_file_candidates()
endfunction

function! s:neomru_acp(line, args) abort
  exe 'e' a:line
endfunction

function! s:jumplist(...) abort
  return split(s:CMP.execute('jumps'), '\n')[1:]
endfunction

function! s:jumplist_acp(line, args) abort
  let list = split(a:line)
  if len(list) < 4
    return
  endif

  let [linenr, col, file_text] = [list[1], list[2]+1, join(list[3:])]
  let lines = getbufline(file_text, linenr)
  let path = file_text
  if empty(lines)
    if stridx(join(split(getline(linenr))), file_text) == 0
      let lines = [file_text]
      let path = bufname('%')
    elseif filereadable(path)
      let lines = ['buffer unloaded']
    else
      " Skip.
      return
    endif
  endif

  exe 'e '  . path
  call cursor(linenr, col)
endfunction

function! s:message(...) abort
  return split(s:CMP.execute('message'), '\n')
endfunction

function! s:message_acp(line, args) abort
  let @" = a:line
  echohl ModeMsg
  echo 'Yanked'
  echohl None
endfunction

func! s:neoyank(...)
  let yank = []
  for text in neoyank#_get_yank_histories()['"']
    call add(yank, '": ' . join(split(text[0], "\n"), '\n'))
  endfor
  return yank
endfunction

function! s:neoyank_acp(line, args) abort
  let line = a:line[3:]
  call append(0, split(line, '\\n'))
endfunction

function! s:menu(name)
  let s:menu_action = {}
  let menu = get(g:unite_source_menu_menus, a:name['--name'][0], {})
  if has_key(menu, 'command_candidates')
    let rt = []
    for item in menu.command_candidates
      call add(rt, item[0])
      call extend(s:menu_action, {item[0] : item[1]}, 'force')
    endfor
    return rt
  else
    return []
  endif
endfunction

function! s:accept(line, args)
  let action = get(s:menu_action, a:line, '')
  exe action
endfunction


function! s:quickfix_to_grep(v) abort
  return bufname(a:v.bufnr) . ':' . a:v.lnum . ':' . a:v.col . ':' . a:v.text
endfunction
function! s:quickfix(...) abort
  return map(getqflist(), 's:quickfix_to_grep(v:val)')
endfunction

function! s:quickfix_acp(line, args) abort
  let line = a:line
  let filename = fnameescape(split(line, ':\d\+:')[0])
  let linenr = matchstr(line, ':\d\+:')[1:-2]
  let colum = matchstr(line, '\(:\d\+\)\@<=:\d\+:')[1:-2]
  exe 'e ' . filename
  call cursor(linenr, colum)
endfunction


function! s:location_list_to_grep(v) abort
  return bufname(a:v.bufnr) . ':' . a:v.lnum . ':' . a:v.col . ':' . a:v.text
endfunction

function! s:locationlist(...) abort
  return map(getloclist(0), 's:location_list_to_grep(v:val)')
endfunction

function! s:locationlist_acp(line, args) abort
  let line = a:line
  let filename = fnameescape(split(line, ':\d\+:')[0])
  let linenr = matchstr(line, ':\d\+:')[1:-2]
  let colum = matchstr(line, '\(:\d\+\)\@<=:\d\+:')[1:-2]
  exe 'e ' . filename
  call cursor(linenr, colum)
endfunction

function! s:unicode(unicode_groups) abort
  let unicode_group = get(a:unicode_groups, '--name', [])
  if empty(unicode_group)
    let filelist = map(split(globpath(g:unite_unicode_data_path, '*.txt'), '\n'),
          \ '[fnamemodify(v:val, ":t:r"), fnamemodify(v:val, ":p")]')
    return map(filelist, 'v:val[0]')
  else
    let unicode = []
    call map(unicode_group, 'extend(unicode, readfile(g:unite_unicode_data_path . v:val . ".txt"))')
    return unicode
  endif
endfunction

function! s:unicode_acp(line, args) abort
  if stridx(a:line, ';') > -1
    let glyph = matchstr(a:line, ';\x\{4,5}')
    let writable = nr2char(str2nr(glyph[1:], 16))

    exe "norm! a" . eval("\"" . writable . "\"")
    " echo printf("%s%s", writable, glyph)
  else
    exe 'Leaderf unicode --name ' . a:line
  endif
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
  nnoremap <silent> <Leader>fr
        \ :<C-u>Leaderf --recall<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.r = ['Leaderf --recall',
        \ 'resume fuzzy finder window',
        \ [
        \ '[Leader f r ] is to resume fuzzy finder window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fe
        \ :<C-u>Leaderf register<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.e = ['Leaderf register',
        \ 'fuzzy find registers',
        \ [
        \ '[Leader f r ] is to fuzzy find registers',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fh
        \ :<C-u>Leaderf neoyank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.h = ['Leaderf neoyank',
        \ 'fuzzy find yank history',
        \ [
        \ '[Leader f h] is to fuzzy find history and yank content',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fj
        \ :<C-u>Leaderf jumplist<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.j = ['Leaderf jumplist',
        \ 'fuzzy find jump list',
        \ [
        \ '[Leader f j] is to fuzzy find jump list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fl
        \ :<C-u>Leaderf locationlist<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.l = ['Leaderf locationlist',
        \ 'fuzzy find location list',
        \ [
        \ '[Leader f l] is to fuzzy find location list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fm
        \ :<C-u>Leaderf message<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.m = ['Leaderf message',
        \ 'fuzzy find message',
        \ [
        \ '[Leader f m] is to fuzzy find message',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fq
        \ :<C-u>Leaderf quickfix<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.q = ['Leaderf quickfix',
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
  nnoremap <silent> <Leader>f<Space> :<C-u>Leaderf menu --name CustomKeyMaps<CR>
  let g:_spacevim_mappings.f['[SPC]'] = ['Leaderf menu --name CustomKeyMaps',
        \ 'fuzzy find custom key bindings',
        \ [
        \ '[Leader f SPC] is to fuzzy find custom key bindings',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fp  :<C-u>Leaderf menu --name AddedPlugins<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.p = ['Leaderf menu --name AddedPlugins',
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
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr, ...) abort
    if a:0 > 1
      return function(substitute(a:fstr, 's:', s:_s, 'g'))
    else
      return function(a:fstr)
    endif
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
