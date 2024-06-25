"=============================================================================
" sql.vim --- lang#sql layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#sql, layers-lang-sql
" @parentsection layers
" This layer is for sql development, disabled by default, to enable this
" layer, add following snippet to your @section(options) file.
" >
"   [[layers]]
"     name = 'lang#sql'
" <
"
" @subsection Options
"
" 1. `enabled_formatters`: set the default formatters for sql, default is ['sqlfmtorg']
"   https://github.com/sql-formatter-org/sql-formatter
"   you can also use `sqlformat` which is from https://github.com/andialbrecht/sqlparse
" 2. `sql_formatter_command`: Set the command of sql-formatter.
" 3. `sql_dialect`: set the SQL dialect, default is basic sql.
" 4. `sql_formatter_config`: set the path of config path. default is empty
" string.
" 5. `sqlformat_cmd`: set the command for sqlformat.
" 6. `sqlformat_output_encode`: set the output encoding of sqlformat, default
" is `utf-8`. If you are using window, maybe need to change this option to
" `cp936`.
"
"

if exists('s:enabled_formatters')
  finish
endif

let s:enabled_formatters = ['sqlfmtorg']
let s:sql_formatter_command = 'sql-formatter'
let s:sql_dialect = 'sql'
let s:sql_formatter_config = ''
let s:sqlformat_cmd = 'sqlformat'
let s:sqlformat_output_encode = 'utf-8'

function! SpaceVim#layers#lang#sql#plugins() abort
  let plugins = []
  call add(plugins, ['tpope/vim-dadbod', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#sql#set_variable(opt) abort
  " keep compatibility with enabled_formater
  let s:enabled_formatters = get(a:opt, 'enabled_formatters', get(a:opt, 'enabled_formater', s:enabled_formatters)) 
  let s:sql_formatter_command = get(a:opt, 'sql_formatter_command', s:sql_formatter_command) 
  let s:sql_dialect = get(a:opt, 'sql_dialect', s:sql_dialect)
  let s:sql_formatter_config = get(a:opt, 'sql_formatter_config', s:sql_formatter_config)
  let s:sqlformat_cmd = get(a:opt, 'sqlformat_cmd', s:sqlformat_cmd) 
  let s:sqlformat_output_encode = get(a:opt, 'sqlformat_output_encode', s:sqlformat_output_encode)
endfunction

function! SpaceVim#layers#lang#sql#config() abort
  
  let g:neoformat_enabled_sql = s:enabled_formatters
  let argv = []
  if !empty(s:sql_formatter_config)
    let argv = ['-c', s:sql_formatter_config]
  endif
  let g:neoformat_sql_sqlfmtorg = {
        \ 'exe': s:sql_formatter_command,
        \ 'args': ['-l', s:sql_dialect,] + argv,
        \ 'stdin': 1,
        \ }
  let g:neoformat_sql_sqlformat = {
        \ 'exe': s:sqlformat_cmd,
        \ 'args': ['--reindent', '-'],
        \ 'output_encode': s:sqlformat_output_encode,
        \ 'stdin': 1,
        \ }
endfunction

function! SpaceVim#layers#lang#sql#health() abort
  call SpaceVim#layers#lang#sql#plugins()
  return 1
endfunction
function! SpaceVim#layers#lang#sql#loadable() abort

  return 1

endfunction
