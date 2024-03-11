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
" 1. `enabled_formater`: set the default formatter for sql, default is ['sqlfmtorg']
"   https://github.com/sql-formatter-org/sql-formatter
" 2. `sql_formatter_command`: Set the command of sql-formatter.
" 3. `sql_dialect`: set the SQL dialect, default is basic sql.
" 4. `sql_formatter_config`: set the path of config path. default is empty
" string.
"

if exists('s:enabled_formater')
  finish
endif

let s:enabled_formater = ['sqlfmtorg']
let s:sql_formatter_command = 'sql-formatter'
let s:sql_dialect = 'sql'
let s:sql_formatter_config = ''

function! SpaceVim#layers#lang#sql#plugins() abort
  let plugins = []
  call add(plugins, ['tpope/vim-dadbod', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#sql#set_variable(opt) abort
  let s:enabled_formater = get(a:opt, 'enabled_formater', s:enabled_formater) 
  let s:sql_formatter_command = get(a:opt, 'sql_formatter_command', s:sql_formatter_command) 
  let s:sql_dialect = get(a:opt, 'sql_dialect', s:sql_dialect)
  let s:sql_formatter_config = get(a:opt, 'sql_formatter_config', s:sql_formatter_config)
endfunction

function! SpaceVim#layers#lang#sql#config() abort
  
  let g:neoformat_enabled_sql = s:enabled_formater
  let argv = []
  if !empty(s:sql_formatter_config)
    let argv = ['-c', s:sql_formatter_config]
  endif
  let g:neoformat_sql_sqlfmtorg = {
        \ 'exe': s:sql_formatter_command,
        \ 'args': ['-l', s:sql_dialect,] + argv,
        \ 'stdin': 1,
        \ }
endfunction

function! SpaceVim#layers#lang#sql#health() abort
  call SpaceVim#layers#lang#sql#plugins()
  return 1
endfunction
