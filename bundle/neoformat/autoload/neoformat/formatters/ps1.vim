function! neoformat#formatters#ps1#enabled() abort
    return ['PSScriptAnalyzer', 'PowerShellBeautifier']
endfunction

function! neoformat#formatters#ps1#PowerShellBeautifier() abort
    return {
        \ 'exe'   : 'powershell',
        \ 'args'  : ['-noprofile', '-Command', "Edit-DTWBeautifyScript", "-IndentType", "FourSpaces", "-StandardOutput"],
        \ 'stdin' : 0,
        \ }
endfunction

function! neoformat#formatters#ps1#PSScriptAnalyzer() abort
    return {
        \ 'exe'   : 'powershell',
        \ 'args' : ['-noprofile', '-Command', 'Invoke-Formatter', '-ScriptDefinition (Get-Content ' . expand('%') . ' -Raw)'],
        \ 'stdin' : 0,
        \ 'no_append' : 1,
        \ }
endfunction
