" help source for unite.vim
" Version:     0.0.3
" Last Change: 14 Feb 2014.
" Author:      tsukkee <takayuki0510 at gmail.com>
" Licence:     The MIT License {{{
"     Permission is hereby granted, free of charge, to any person obtaining a copy
"     of this software and associated documentation files (the "Software"), to deal
"     in the Software without restriction, including without limitation the rights
"     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
"     copies of the Software, and to permit persons to whom the Software is
"     furnished to do so, subject to the following conditions:
"
"     The above copyright notice and this permission notice shall be included in
"     all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
"     THE SOFTWARE.
" }}}

" define source
function! unite#sources#help#define()
    return unite#util#has_vimproc() ? s:source : {}
endfunction

let s:Cache = unite#util#get_vital_cache()

" cache
let s:cache = []
let s:cont_number = 0
let s:cont_max = 0
function! unite#sources#help#refresh()
    let s:cache = []

    let cache_dir = unite#get_data_directory() . '/help'
    if s:Cache.filereadable(cache_dir, 'help-cache')
        " Delete cache file.
        call s:Cache.deletefile(cache_dir, 'help-cache')
    endif
endfunction
let s:vimproc_files = {}

" source
let s:source = {
\   'name': 'help',
\   'max_candidates': 50,
\   'action_table': {},
\   'hooks': {},
\   'default_action': 'execute',
\   'filters' : ['matcher_default', 'sorter_word', 'converter_default'],
\}
function! s:source.hooks.on_init(args, context)
    let lang_filter = []
    for arg in a:args
        if arg == '!'
            let should_refresh = 1
        endif

        if arg =~ '[a-z]\{2\}'
            call add(lang_filter, arg)
        endif
    endfor

    let a:context.source__lang_filter = lang_filter

    let a:context.source__input = a:context.input
    if a:context.source__input == ''
        let a:context.source__input =
                    \ unite#util#input('Please input search word: ', '', 'help')
    endif

    call unite#print_source_message('Search word: '
                \ . a:context.source__input, s:source.name)
endfunction
function! s:source.gather_candidates(args, context)
    let should_refresh = a:context.is_redraw

    if should_refresh
        call unite#sources#help#refresh()
        let a:context.is_async = 1
    endif

    let cache_dir = unite#get_data_directory() . '/help'
    if s:Cache.filereadable(cache_dir, 'help-cache')
        " Use cache file.
        let s:cache = eval(get(s:Cache.readfile(
                    \ cache_dir, 'help-cache'), 0, '[]'))

        let a:context.is_async = 0
        call unite#print_source_message('Completed.', s:source.name)
    endif

    if !empty(s:cache)
        let list = copy(s:cache)

        return s:filter_list(list, a:context)
    endif

    " load files.
    let s:vimproc_files = {}
    for tagfile in s:globpath(&runtimepath, 'doc/{tags,tags-*}', 1, 1)
        if !filereadable(tagfile) | continue | endif

        let file = {
                    \ 'proc' : vimproc#fopen(tagfile, 'O_RDONLY'),
                    \ 'lang' : matchstr(tagfile, 'tags-\zs[a-z]\{2\}'),
                    \ 'path': fnamemodify(expand(tagfile), ':p:h:h:t'),
                    \ 'max' : len(readfile(tagfile)),
                    \ 'lnum' : 0,
                    \ }
        let s:vimproc_files[tagfile] = file
    endfor

    let s:cont_number = 1
    let s:cont_max = len(s:vimproc_files)

    return []
endfunction
function! s:source.async_gather_candidates(args, context)
    let list = []
    for [key, file] in items(s:vimproc_files)
        let lines = file.proc.read_lines(1000, 2000)

        " Show progress.
        let file.lnum += len(lines)
        let progress = (file.lnum * 100) / file.max
        if progress > 100
            let progress = 100
        endif

        call unite#clear_message()

        call unite#print_source_message(
                    \    printf('[%2d/%2d] Making cache of "%s"...%d%%',
                    \      s:cont_number, s:cont_max,
                    \      file.path, progress), s:source.name)

        for line in lines
            if line == '' || line[0] == '!'
                continue
            endif

            let name = split(line, "\t")[0]
            let word = name . '@' . (file.lang != '' ? file.lang : 'en')
            let abbr = printf("%s%s (in %s)",
                        \ name, ((file.lang != '') ? '@' . file.lang : ''), file.path)

            call add(list, {
                        \ 'word':   word,
                        \ 'abbr':   abbr,
                        \ 'action__command': 'help ' . word,
                        \ 'source__lang'   : file.lang != '' ? file.lang : 'en'
                        \})
        endfor

        if file.proc.eof
            call file.proc.close()
            call remove(s:vimproc_files, key)
            let s:cont_number += 1
        endif
    endfor

    let s:cache += list
    if empty(s:vimproc_files)
        let a:context.is_async = 0
        call unite#print_source_message('Completed.', s:source.name)

        " Save cache file.
        let cache_dir = unite#get_data_directory() . '/help'
        call s:Cache.writefile(cache_dir, 'help-cache',
                    \ [string(s:cache)])
    endif

    return s:filter_list(list, a:context)
endfunction
function! s:source.hooks.on_close(args, context)
endfunction

function! s:filter_list(list, context)
    call filter(a:list, 'stridx(v:val.word, a:context.source__input) >= 0')
    if !empty(a:context.source__lang_filter)
        call filter(a:list, 'index(a:context.source__lang_filter,
                    \        v:val.source__lang) != -1')
    endif

    return a:list
endfunction

" action
let s:action_table = {}

let s:action_table.execute = {
\   'description': 'lookup help'
\}
function! s:action_table.execute.func(candidate)
    let save_ignorecase = &ignorecase
    set noignorecase
    execute a:candidate.action__command
    let &ignorecase = save_ignorecase
endfunction

let s:action_table.tabopen = {
\   'description': 'open help in a new tab'
\}
function! s:action_table.tabopen.func(candidate)
    let save_ignorecase = &ignorecase
    set noignorecase
    execute 'tab' a:candidate.action__command
    let &ignorecase = save_ignorecase
endfunction

function! s:globpath(path, expr, suf, list) abort
    if has('patch-7.4.279')
        return globpath(a:path, a:expr, a:suf, a:list)
    else
        let rst = globpath(a:path, a:expr, a:suf)
        if a:list
            return split(rst, "\n")
        else
            return rst
        endif
    endif
endfunction

let s:source.action_table.common = s:action_table

" vim: expandtab:ts=4:sts=4:sw=4
