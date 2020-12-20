syntax match neomakePythonLint "[EWFC]\d\+" containedin=ALL

syntax keyword neomakePyLamaNames pycodestyle pydocstyle pyflakes mccabe pylint radon gjslint
syntax match neomakePyLamaLinter "\[\k\+]" contains=neomakePyLamaNames

highlight default link neomakePythonLint ErrorMsg
highlight default link neomakePyLamaNames Special
" vim: ts=4 sw=4 et
