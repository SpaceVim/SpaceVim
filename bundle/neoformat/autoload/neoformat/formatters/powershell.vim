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
" `Edit-DTWBeautifyScript` and `Invoke-Formatter`.
"
" Before using these default formatters, you need to install the PowerShell
" modules.
" >
"   Install-Module -Name PowerShell-Beautifier -Scope CurrentUser
"   Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
" <
"
" @subsection PowerShellBeautifier
" >
"   {
"     'exe'   : 'powershell',
"     'args'  : ['-noprofile', '-Command', "Edit-DTWBeautifyScript", "-IndentType", "FourSpaces", "-StandardOutput"],
"     'stdin' : 0,
"   }
" <
" @subsection PSScriptAnalyzer
" >
"   {
"     'exe'   : 'powershell',
"     'args' : ['-noprofile', '-Command', 'Invoke-Formatter', '-ScriptDefinition (Get-Content ' . expand('%') . ' -Raw)'],
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

