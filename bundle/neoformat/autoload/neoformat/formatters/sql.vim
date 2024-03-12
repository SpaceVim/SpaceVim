"=============================================================================
" neoformat.vim --- A Neovim plugin for formatting
" Copyright (c) 2016-2021 Steve Dignam
" Copyright (c) 2022 Eric Wong
" Author: Eric Wong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================



""
" @section SQL formatters, supported-filetypes-sql
" @parentsection supported-filetypes
" For SQL language, there are three default formatters.
"
" @subsection sqlformat
" >
"   {
"     'exe': 'sqlformat',
"     'args': ['--reindent', '-'],
"     'stdin': 1,
"   }
" <
" @subsection pg_format
" @subsection sqlfmt


function! neoformat#formatters#sql#enabled() abort
    return ['sqlformat', 'pg_format', 'sqlfmt']
endfunction

function! neoformat#formatters#sql#sqlformat() abort
    return {
        \ 'exe': 'sqlformat',
        \ 'args': ['--reindent', '-'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#sql#pg_format() abort
    return {
        \ 'exe': 'pg_format',
        \ 'args': ['-'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#sql#sqlfmt() abort
    return {
        \ 'exe': 'sqlfmt',
        \ 'args': [],
        \ 'stdin': 1,
        \ }
endfunction
