"=============================================================================
" neoformat.vim --- A Neovim plugin for formatting
" Copyright (c) 2016-2021 Steve Dignam
" Copyright (c) 2022 Eric Wong
" Author: Eric Wong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section PowerShell formatters, supported-filetypes-powershell
" @parentsection supported-filetypes
" For PowerShell script, there are two default formatters.
"
" @subsection PowerShellBeautifier
" >
"   {
"     'exe'   : 'Edit-DTWBeautifyScript',
"     'args'  : ["-IndentType FourSpaces", "-StandardOutput"],
"     'stdin' : 0,
"   }
" <
" @subsection PSScriptAnalyzer
" >
"   {
"     'exe'   : 'Invoke-Formatter',
"     'args' : ['-ScriptDefinition (Get-Content ' . expand('%') . ' -Raw)'],
"     'stdin' : 0,
"     'no_append' : 1,
"   }
" <

function! neoformat#formatters#powershell#enabled() abort
    return neoformat#formatters#ps1#enabled()
endfunction

function! neoformat#formatters#powershell#PowerShellBeautifier() abort
    return neoformat#formatters#ps1#PowerShellBeautifier()
endfunction

function! neoformat#formatters#powershell#PSScriptAnalyzer() abort
    return neoformat#formatters#ps1#PSScriptAnalyzer()
endfunction

