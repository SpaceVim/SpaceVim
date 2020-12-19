"=============================================================================
" FILE: commands.vim
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

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Command functions:
function! vimproc#commands#_install(args) abort "{{{
  let savemp = &makeprg
  let savecwd = getcwd()

  try
    if executable('gmake')
      let &makeprg = 'gmake'
    elseif executable('make')
      let &makeprg = 'make'
    elseif executable('nmake')
      let &makeprg = 'nmake -f make_msvc.mak nodebug=1'
    endif

    " Change to the correct directory and run make
    execute 'lcd' fnameescape(fnamemodify(g:vimproc#dll_path, ':h:h'))
    execute 'make' a:args
  finally
     " Restore working directory and makeprg
     execute 'lcd' fnameescape(savecwd)
     let &makeprg = savemp
  endtry
endfunction"}}}
function! vimproc#commands#_bang(cmdline) abort "{{{
  " Expand % and #.
  let cmdline = join(map(vimproc#parser#split_args_through(
        \ vimproc#util#iconv(a:cmdline,
        \   vimproc#util#termencoding(), &encoding)),
        \ 'substitute(expand(v:val), "\n", " ", "g")'))

  " Open pipe.
  let subproc = vimproc#pgroup_open(cmdline, 1)

  call subproc.stdin.close()

  while !subproc.stdout.eof || !subproc.stderr.eof
    if !subproc.stdout.eof
      let output = subproc.stdout.read(10000, 0)
      if output != ''
        let output = vimproc#util#iconv(output,
              \ vimproc#util#stdoutencoding(), &encoding)

        echon output
        sleep 1m
      endif
    endif

    if !subproc.stderr.eof
      let output = subproc.stderr.read(10000, 0)
      if output != ''
        let output = vimproc#util#iconv(output,
              \ vimproc#util#stderrencoding(), &encoding)
        echohl WarningMsg | echon output | echohl None

        sleep 1m
      endif
    endif
  endwhile

  call subproc.stdout.close()
  call subproc.stderr.close()

  call subproc.waitpid()
endfunction"}}}
function! vimproc#commands#_read(cmdline) abort "{{{
  " Expand % and #.
  let cmdline = join(map(vimproc#parser#split_args_through(
        \ vimproc#util#iconv(a:cmdline,
        \   vimproc#util#termencoding(), &encoding)),
        \ 'substitute(expand(v:val), "\n", " ", "g")'))

  " Expand args.
  call append('.', split(vimproc#util#iconv(vimproc#system(cmdline),
        \ vimproc#util#stdoutencoding(), &encoding), '\r\n\|\n'))
endfunction"}}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
" vim:foldmethod=marker:fen:sw=2:sts=2
