"=============================================================================
" FILE: neobundle/install.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#neobundle_install#define() abort "{{{
  return [s:source_install, s:source_update]
endfunction"}}}

let s:source_install = {
      \ 'name' : 'neobundle/install',
      \ 'description' : 'install bundles',
      \ 'hooks' : {},
      \ 'default_kind' : 'word',
      \ 'syntax' : 'uniteSource__NeoBundleInstall',
      \ }

function! s:source_install.hooks.on_init(args, context) abort "{{{
  let bundle_names = filter(copy(a:args), "v:val != '!'")
  let a:context.source__bang =
        \ index(a:args, '!') >= 0 || !empty(bundle_names)
  let a:context.source__not_fuzzy = 0
  call s:init(a:context, bundle_names)
endfunction"}}}

function! s:source_install.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__NeoBundleInstall_Progress /(.\{-}):\s*.*/
        \ contained containedin=uniteSource__NeoBundleInstall
  highlight default link uniteSource__NeoBundleInstall_Progress String
  syntax match uniteSource__NeoBundleInstall_Source /|.\{-}|/
        \ contained containedin=uniteSource__NeoBundleInstall_Progress
  highlight default link uniteSource__NeoBundleInstall_Source Type
  syntax match uniteSource__NeoBundleInstall_URI /-> diff URI/
        \ contained containedin=uniteSource__NeoBundleInstall
  highlight default link uniteSource__NeoBundleInstall_URI Underlined
endfunction"}}}

function! s:source_install.hooks.on_close(args, context) abort "{{{
  if !empty(a:context.source__processes)
    for process in a:context.source__processes
      if has('nvim')
        call jobstop(process.proc)
      else
        call process.proc.waitpid()
      endif
    endfor
  endif
endfunction"}}}

function! s:source_install.async_gather_candidates(args, context) abort "{{{
  if !a:context.sync && empty(filter(range(1, winnr('$')),
        \ "getwinvar(v:val, '&l:filetype') ==# 'unite'"))
    return []
  endif

  let old_msgs = copy(neobundle#installer#get_updates_log())

  if a:context.source__number < a:context.source__max_bundles
    while a:context.source__number < a:context.source__max_bundles
        \ && len(a:context.source__processes) <
        \      g:neobundle#install_max_processes
      let bundle = a:context.source__bundles[a:context.source__number]
      call neobundle#installer#sync(bundle, a:context, 1)

      call unite#clear_message()
      call unite#print_source_message(
            \ neobundle#installer#get_progress_message(bundle,
            \ a:context.source__number,
            \ a:context.source__max_bundles), self.name)
      redrawstatus
    endwhile
  endif

  if !empty(a:context.source__processes)
    for process in a:context.source__processes
      call neobundle#installer#check_output(a:context, process, 1)
    endfor

    " Filter eof processes.
    call filter(a:context.source__processes, '!v:val.eof')
  else
    call neobundle#installer#update_log(
          \ neobundle#installer#get_updated_bundles_message(
          \ a:context.source__synced_bundles), 1)
    call neobundle#installer#update_log(
          \ neobundle#installer#get_errored_bundles_message(
          \ a:context.source__errored_bundles), 1)
    call neobundle#installer#update(
          \ a:context.source__synced_bundles)

    " Finish.
    call neobundle#installer#update_log('Completed.', 1)

    let a:context.is_async = 0
  endif

  return map(neobundle#installer#get_updates_log()[len(old_msgs) :], "{
        \ 'word' : (v:val =~ '^\\s*\\h\\w*://' ? ' -> diff URI' : v:val),
        \ 'is_multiline' : 1,
        \ 'kind' : (v:val =~ '^\\s*\\h\\w*://' ? 'uri' : 'word'),
        \ 'action__uri' : substitute(v:val, '^\\s\\+', '', ''),
        \}")
endfunction"}}}

function! s:source_install.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return ['!'] +
        \ neobundle#commands#complete_bundles(a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}

let s:source_update = deepcopy(s:source_install)
let s:source_update.name = 'neobundle/update'
let s:source_update.description = 'update bundles'

function! s:source_update.hooks.on_init(args, context) abort "{{{
  let a:context.source__bang =
        \ index(a:args, 'all') >= 0 ? 2 : 1
  let a:context.source__not_fuzzy = index(a:args, '!') >= 0
  let bundle_names = filter(copy(a:args),
        \ "v:val !=# 'all' && v:val !=# '!'")
  call s:init(a:context, bundle_names)
endfunction"}}}

function! s:init(context, bundle_names) abort "{{{
  let a:context.source__synced_bundles = []
  let a:context.source__errored_bundles = []

  let a:context.source__processes = []

  let a:context.source__number = 0

  let a:context.source__bundles = !a:context.source__bang ?
        \ neobundle#get_force_not_installed_bundles(a:bundle_names) :
        \ empty(a:bundle_names) ?
        \ neobundle#config#get_enabled_bundles() :
        \ a:context.source__not_fuzzy ?
        \ neobundle#config#search(a:bundle_names) :
        \ neobundle#config#fuzzy_search(a:bundle_names)

  call neobundle#installer#_load_install_info(
        \ a:context.source__bundles)

  let reinstall_bundles =
        \ neobundle#installer#get_reinstall_bundles(
        \   a:context.source__bundles)
  if !empty(reinstall_bundles)
    call neobundle#installer#reinstall(reinstall_bundles)
  endif

  let a:context.source__max_bundles =
        \ len(a:context.source__bundles)

  call neobundle#installer#clear_log()

  if empty(a:context.source__bundles)
    let a:context.is_async = 0
    call neobundle#installer#error(
          \ 'Target bundles not found. You may use wrong bundle name.')
  else
    call neobundle#installer#update_log(
          \ 'Update started: ' . strftime('(%Y/%m/%d %H:%M:%S)'))
  endif
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
