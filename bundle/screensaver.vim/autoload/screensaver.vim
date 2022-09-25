" =============================================================================
" Filename: autoload/screensaver.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/11/21 20:10:28.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! screensaver#new(...) abort
  if !has_key(b:, 'screensaver')
    let controller = deepcopy(s:self)
    call controller.saveoption()
    silent! noautocmd tabnew
    let b:screensaver = controller
  else
    let b:screensaver.previous_name = b:screensaver.source.name
  endif
  try
    let source = screensaver#source(a:0 ? a:1 : 'clock')
  catch
    let source = screensaver#source('clock')
  endtry
  call b:screensaver.start(source)
endfunction

function! screensaver#source(name) abort
  let source = screensaver#source#{a:name}#new()
  let source.name = a:name
  return source
endfunction

function! screensaver#complete(arglead, ...) abort
  let paths = split(globpath(&runtimepath, 'autoload/screensaver/source/**.vim'), '\n')
  let names = map(paths, 'substitute(fnamemodify(v:val, ":t"), "\\.vim", "", "")')
  let matchnames = filter(copy(names), 'stridx(v:val, a:arglead) == 0')
  if len(matchnames)
    return matchnames
  endif
  return filter(copy(names), 'stridx(v:val, a:arglead) >= 0')
endfunction

let s:self = {}

let s:use_timer = has('timers') && (v:version >= 800 || has('nvim'))

function! s:self.start(source) dict abort
  call self.setoption()
  call self.setcursor()
  call self.call('end')
  let self.source = a:source
  call self.mapping()
  call self.call('start')
  call self.redraw()
  execute 'augroup ScreenSaver' . bufnr('')
    autocmd!
    if s:use_timer
      call timer_start(200, function('s:timer_callback'))
    else
      autocmd CursorHold <buffer>
            \   if has_key(b:, 'screensaver')
            \ |   call b:screensaver.redraw()
            \ | endif
    endif
    autocmd BufLeave <buffer>
          \   if has_key(b:, 'screensaver')
          \ |   call b:screensaver.end()
          \ | endif
  augroup END
  let self.bufnr = bufnr('')
endfunction

function! s:timer_callback(timer) abort
  if has_key(b:, 'screensaver')
    call b:screensaver.redraw()
  endif
endfunction

function! s:self.saveoption() dict abort
  let self.setting = {}
  let self.setting.laststatus = &laststatus
  let self.setting.showtabline = &showtabline
  let self.setting.ruler = &ruler
  if !s:use_timer
    let self.setting.updatetime = &updatetime
  endif
  let self.setting.hlsearch = &hlsearch
  let self.setting.guicursor = &guicursor
  let self.setting.t_ve = &t_ve
  let self.setting.winnr = winnr()
  let self.setting.tabpagenr = tabpagenr()
endfunction

function! s:self.setoption() dict abort
  setlocal laststatus=0 showtabline=0 noruler nohlsearch
        \ buftype=nofile noswapfile nolist completefunc= omnifunc=
        \ bufhidden=hide wrap nowrap nobuflisted nofoldenable foldcolumn=0
        \ nocursorcolumn nocursorline nonumber nomodeline filetype=screensaver
  if exists('&colorcolumn')
    setlocal colorcolumn=
  endif
  if exists('&relativenumber')
    setlocal norelativenumber
  endif
  if !s:use_timer
    setlocal updatetime=150
  endif
endfunction

function! s:self.restoreoption() dict abort
  let &laststatus = self.setting.laststatus
  let &showtabline = self.setting.showtabline
  let &ruler = self.setting.ruler
  if !s:use_timer
    let &updatetime = self.setting.updatetime
  endif
  let &hlsearch = self.setting.hlsearch
  call self.restorecursor()
endfunction

function! s:self.setcursor() dict abort
  set guicursor=n:block-NONE
  set t_ve=
endfunction

function! s:self.restorecursor() dict abort
  let &guicursor = self.setting.guicursor
  let &t_ve = self.setting.t_ve
endfunction

function! s:self.redraw() dict abort
  call cursor(1, 1)
  call self.call('redraw')
  if s:use_timer
    call timer_start(200, function('s:timer_callback'))
  else
    silent! call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>" . (v:count ? v:count : ''), 'n')
  endif
endfunction

function! s:self.mapping() dict abort
  let save_cpo = &cpo
  set cpo&vim
  nnoremap <buffer><silent> <Plug>(screensaver_end) :<C-u>call b:screensaver.end()<CR>
  call screensaver#util#nmapall('<Plug>(screensaver_end)')
  if get(g:, 'screensaver_password')
    nmap <buffer> : <Plug>(screensaver_end)
  else
    silent! nunmap <buffer> :
  endif
  let &cpo = save_cpo
endfunction

function! s:self.call(method) dict abort
  if has_key(self, 'source') && has_key(self.source, a:method)
    call self.source[a:method]()
  endif
endfunction

function! s:self.previous() dict abort
  call screensaver#new(get(self, 'previous_name', self.source.name))
endfunction

function! s:self.end(...) dict abort
  call self.call('end')
  if a:0 && a:1 || !get(g:, 'screensaver_password')
    call self.restoreoption()
    silent! noautocmd quit!
    silent! exec 'tabnext' self.setting.tabpagenr
    silent! exec self.setting.winnr 'wincmd w'
    silent! exec 'bwipeout!' self.bufnr
  else
    call screensaver#new('password')
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
