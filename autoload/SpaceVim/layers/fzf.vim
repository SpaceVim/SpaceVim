"=============================================================================
" fzf.vim --- fzf layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')


function! SpaceVim#layers#fzf#plugins() abort
  let plugins = []
  call add(plugins, ['junegunn/fzf',                { 'merged' : 0}])
  call add(plugins, ['Shougo/neoyank.vim', {'merged' : 0}])
  call add(plugins, ['SpaceVim/fzf-neoyank',                { 'merged' : 0}])
  return plugins
endfunction


let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#fzf#config() abort
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'f'],
        \ 'FzfFiles',
        \ ['find files in current project',
        \ [
        \ '[SPC p f] is to find files in the root of the current project',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'Denite outline', 'jump to a definition in buffer', 1)
  nnoremap <silent> <C-p> :FzfFiles<cr>
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'FzfColors', 'fuzzy find colorschemes', 1)
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'],
        \ "exe 'FZF ' . fnamemodify(bufname('%'), ':h')",
        \ ['Find files in the directory of the current buffer',
        \ [
        \ '[SPC f f] is to find files in the directory of the current buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
  nnoremap <silent> <Leader>fe
        \ :<C-u>FzfRegister<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.e = ['FzfRegister',
        \ 'fuzzy find registers',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fj
        \ :<C-u>FzfJumps<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.j = ['FzfJumps',
        \ 'fuzzy find jump list',
        \ [
        \ '[Leader f j] is to fuzzy find jump list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fh
        \ :<C-u>FZFNeoyank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.h = ['FZFNeoyank',
        \ 'fuzzy find yank history',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fm
        \ :<C-u>FzfMessages<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.m = ['FzfMessages',
        \ 'fuzzy find message',
        \ [
        \ '[Leader f m] is to fuzzy find message',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fq
        \ :<C-u>FzfQuickfix<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.q = ['FzfQuickfix',
        \ 'fuzzy find quickfix list',
        \ [
        \ '[Leader f q] is to fuzzy find quickfix list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fl
        \ :<C-u>FzfLocationList<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.l = ['FzfLocationList',
        \ 'fuzzy find location list',
        \ [
        \ '[Leader f l] is to fuzzy find location list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fo  :<C-u>FzfOutline<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.o = ['FzfOutline',
        \ 'fuzzy find outline',
        \ [
        \ '[Leader f o] is to fuzzy find outline',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
endfunction

command! FzfColors call <SID>colors()
function! s:colors() abort
  let s:source = 'colorscheme'
  call fzf#run({'source': map(split(globpath(&rtp, 'colors/*.vim')),
        \               "fnamemodify(v:val, ':t:r')"),
        \ 'sink': 'colo', 'down': '40%'})
endfunction

command! FzfFiles call <SID>files()
function! s:files() abort
  let s:source = 'files'
  call fzf#run({'sink': 'e', 'options': '--reverse', 'down' : '40%'})
endfunction

let s:source = ''

function! SpaceVim#layers#fzf#sources() abort

  return s:source

endfunction
command! FzfJumps call <SID>jumps()
function! s:bufopen(e) abort
    let list = split(a:e)
    if len(list) < 4
      return
    endif

    let [linenr, col, file_text] = [list[1], list[2]+1, join(list[3:])]
    let lines = getbufline(file_text, linenr)
    let path = file_text
    let bufnr = bufnr(file_text)
    if empty(lines)
      if stridx(join(split(getline(linenr))), file_text) == 0
        let lines = [file_text]
        let path = bufname('%')
        let bufnr = bufnr('%')
      elseif filereadable(path)
        let bufnr = 0
        let lines = ['buffer unloaded']
      else
        " Skip.
        return
      endif
    endif

    exe 'e '  . path
    call cursor(linenr, col)
endfunction
function! s:jumps() abort
  let s:source = 'jumps'
  function! s:jumplist() abort
    return split(s:CMP.execute('jumps'), '\n')[1:]
  endfunction
  call fzf#run({
        \   'source':  reverse(<sid>jumplist()),
        \   'sink':    function('s:bufopen'),
        \   'options': '+m',
        \   'down':    len(<sid>jumplist()) + 2
        \ })
endfunction
command! FzfMessages call <SID>message()
function! s:yankmessage(e) abort
  let @" = a:e
  echohl ModeMsg
  echo 'Yanked'
  echohl None
endfunction
function! s:message() abort
  let s:source = 'message'
  function! s:messagelist() abort
    return split(s:CMP.execute('message'), '\n')
  endfunction
  call fzf#run({
        \   'source':  reverse(<sid>messagelist()),
        \   'sink':    function('s:yankmessage'),
        \   'options': '+m',
        \   'down':    len(<sid>messagelist()) + 2
        \ })
endfunction

command! FzfQuickfix call s:quickfix()
function! s:open_quickfix_item(e) abort
    let line = a:e
    let filename = fnameescape(split(line, ':\d\+:')[0])
    let linenr = matchstr(line, ':\d\+:')[1:-2]
    let colum = matchstr(line, '\(:\d\+\)\@<=:\d\+:')[1:-2]
    exe 'e ' . filename
    call cursor(linenr, colum)
endfunction
function! s:quickfix_to_grep(v) abort
  return bufname(a:v.bufnr) . ':' . a:v.lnum . ':' . a:v.col . ':' . a:v.text
endfunction
function! s:quickfix() abort
  let s:source = 'quickfix'
  function! s:quickfix_list() abort
    return map(getqflist(), 's:quickfix_to_grep(v:val)')
  endfunction
  call fzf#run({
        \ 'source':  reverse(<sid>quickfix_list()),
        \ 'sink':    function('s:open_quickfix_item'),
        \ 'options': '--reverse',
        \ 'down' : '40%',
        \ })
endfunction
command! FzfLocationList call s:location_list()
function! s:location_list_to_grep(v) abort
  return bufname(a:v.bufnr) . ':' . a:v.lnum . ':' . a:v.col . ':' . a:v.text
endfunction
function! s:open_location_item(e) abort
    let line = a:e
    let filename = fnameescape(split(line, ':\d\+:')[0])
    let linenr = matchstr(line, ':\d\+:')[1:-2]
    let colum = matchstr(line, '\(:\d\+\)\@<=:\d\+:')[1:-2]
    exe 'e ' . filename
    call cursor(linenr, colum)
endfunction
function! s:location_list() abort
  let s:source = 'location_list'
  function! s:get_location_list() abort
    return map(getloclist(0), 's:location_list_to_grep(v:val)')
  endfunction
  call fzf#run({
        \ 'source':  reverse(<sid>get_location_list()),
        \ 'sink':    function('s:open_location_item'),
        \ 'options': '--reverse',
        \ 'down' : '40%',
        \ })
endfunction


command! -bang FzfOutline call fzf#run(fzf#wrap('outline', s:outline(), <bang>0))
function! s:outline_format(lists) abort
  for list in a:lists
    let linenr = list[2][:len(list[2])-3]
    let line = getline(linenr)
    let idx = stridx(line, list[0])
    let len = len(list[0])
    let list[0] = line[:idx-1] . printf("\x1b[%s%sm%s\x1b[m", 34, '', line[idx : idx+len-1]) . line[idx + len :]
  endfor
  for list in a:lists
    call map(list, "printf('%s', v:val)")
  endfor
  return a:lists
endfunction

function! s:outline_source(tag_cmds) abort
  if !filereadable(expand('%'))
    throw 'Save the file first'
  endif

  for cmd in a:tag_cmds
    let lines = split(system(cmd), "\n")
    if !v:shell_error
      break
    endif
  endfor
  if v:shell_error
    throw get(lines, 0, 'Failed to extract tags')
  elseif empty(lines)
    throw 'No tags found'
  endif
  return map(s:outline_format(map(lines, 'split(v:val, "\t")')), 'join(v:val, "\t")')
endfunction

function! s:outline_sink(lines) abort
  if !empty(a:lines)
    let line = a:lines[0]
    execute split(line, "\t")[2]
  endif
endfunction

function! s:outline(...) abort
  let s:source = 'outline'
  let args = copy(a:000)
  let tag_cmds = [
    \ printf('ctags -f - --sort=no --excmd=number --language-force=%s %s 2>/dev/null', &filetype, expand('%:S')),
    \ printf('ctags -f - --sort=no --excmd=number %s 2>/dev/null', expand('%:S'))]
  return {
    \ 'source':  s:outline_source(tag_cmds),
    \ 'sink*':   function('s:outline_sink'),
    \ 'options': '--reverse +m -d "\t" --with-nth 1 -n 1 --ansi --prompt "Outline> "'}
endfunction


command! FzfRegister call <SID>register()
function! s:yankregister(e) abort
  let @" = a:e
  echohl ModeMsg
  echo 'Yanked'
  echohl None
endfunction
function! s:register() abort
  let s:source = 'registers'
  function! s:registers_list() abort
    return split(s:CMP.execute('registers'), '\n')[1:]
  endfunction
  call fzf#run({
        \   'source':  reverse(<sid>registers_list()),
        \   'sink':    function('s:yankregister'),
        \   'options': '+m',
        \   'down': '40%'
        \ })
endfunction
