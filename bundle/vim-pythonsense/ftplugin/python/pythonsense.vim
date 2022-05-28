"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:         ftplugin/python/pythonsense.vim
" Author:       Jeet Sukumaran
"
" Copyright:    (C) 2018 Jeet Sukumaran
"
" License:      Permission is hereby granted, free of charge, to any person obtaining
"               a copy of this software and associated documentation files (the
"               "Software"), to deal in the Software without restriction, including
"               without limitation the rights to use, copy, modify, merge, publish,
"               distribute, sublicense, and/or sell copies of the Software, and to
"               permit persons to whom the Software is furnished to do so, subject to
"               the following conditions:
"
"               The above copyright notice and this permission notice shall be included
"               in all copies or substantial portions of the Software.
"
"               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"               OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"               MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"               IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"               CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"               TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"
"               SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
" Credits:      - pythontextobj.vim by Nat Williams (https://github.com/natw/vim-pythontextobj)
"               - chapa.vim by Alfredo Deza (https://github.com/alfredodeza/chapa.vim)
"               - indentobj by Austin Taylor's (https://github.com/austintaylor/vim-indentobject)
"               - Python Docstring Text Objects by gfixler (https://pastebin.com/u/gfixler)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Book-Keeping Variables {{{1
let b:pythonsense_is_tab_indented = 0
" 1}}}

" Commands {{{1
command! Pywhere :call pythonsense#echo_python_location()
" }}}1
"
" Plug Definitions {{{1

" Text Objects {{{2
onoremap <buffer> <silent> <Plug>(PythonsenseOuterFunctionTextObject) :<C-u>call pythonsense#python_function_text_object(0, "o")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseInnerFunctionTextObject) :<C-u>call pythonsense#python_function_text_object(1, "o")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseOuterClassTextObject) :<C-u>call pythonsense#python_class_text_object(0, "o")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseInnerClassTextObject) :<C-u>call pythonsense#python_class_text_object(1, "o")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseOuterDocStringTextObject) :<C-u>call pythonsense#python_docstring_text_object(0)<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseInnerDocStringTextObject) :<C-u>call pythonsense#python_docstring_text_object(1)<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseOuterFunctionTextObject) :<C-u>call pythonsense#python_function_text_object(0, "v")<CR><Esc>gv
vnoremap <buffer> <silent> <Plug>(PythonsenseInnerFunctionTextObject) :<C-u>call pythonsense#python_function_text_object(1, "v")<CR><Esc>gv
vnoremap <buffer> <silent> <Plug>(PythonsenseOuterClassTextObject) :<C-u>call pythonsense#python_class_text_object(0, "v")<CR><Esc>gv
vnoremap <buffer> <silent> <Plug>(PythonsenseInnerClassTextObject) :<C-u>call pythonsense#python_class_text_object(1, "v")<CR><Esc>gv
vnoremap <buffer> <silent> <Plug>(PythonsenseOuterDocStringTextObject) :<C-u>cal pythonsense#python_docstring_text_object(0)<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseInnerDocStringTextObject) :<C-u>cal pythonsense#python_docstring_text_object(1)<CR>
" }}}2

" Motions {{{2

nnoremap <buffer> <silent> <Plug>(PythonsenseStartOfNextPythonClass) :<C-u>call pythonsense#move_to_python_object("class", 0, 1, "n")<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseStartOfNextPythonClass) :call pythonsense#move_to_python_object("class", 0, 1, "v")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseStartOfNextPythonClass) V:<C-u>call pythonsense#move_to_python_object("class", 0, 1, "o")<CR>
nnoremap <buffer> <silent> <Plug>(PythonsenseEndOfPythonClass) :<C-u>call pythonsense#move_to_python_object("class", 1, 1, "n")<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseEndOfPythonClass) :call pythonsense#move_to_python_object("class", 1, 1, "v")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseEndOfPythonClass) V:<C-u>call pythonsense#move_to_python_object("class", 1, 1, "o")<CR>
nnoremap <buffer> <silent> <Plug>(PythonsenseStartOfPythonClass) :<C-u>call pythonsense#move_to_python_object("class", 0, 0, "n")<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseStartOfPythonClass) :call pythonsense#move_to_python_object("class", 0, 0, "v")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseStartOfPythonClass) V:<C-u>call pythonsense#move_to_python_object("class", 0, 0, "o")<CR>
nnoremap <buffer> <silent> <Plug>(PythonsenseEndOfPreviousPythonClass) :<C-u>call pythonsense#move_to_python_object("class", 1, 0, "n")<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseEndOfPreviousPythonClass) :call pythonsense#move_to_python_object("class", 1, 0, "v")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseEndOfPreviousPythonClass) V:<C-u>call pythonsense#move_to_python_object("class", 1, 0, "o")<CR>

nnoremap <buffer> <silent> <Plug>(PythonsenseStartOfNextPythonFunction) :<C-u>call pythonsense#move_to_python_object('\(def\\|async def\)', 0, 1, "n")<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseStartOfNextPythonFunction) :call pythonsense#move_to_python_object('\(def\\|async def\)', 0, 1, "v")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseStartOfNextPythonFunction) V:<C-u>call pythonsense#move_to_python_object('\(def\\|async def\)', 0, 1, "o")<CR>
nnoremap <buffer> <silent> <Plug>(PythonsenseEndOfPythonFunction) :<C-u>call pythonsense#move_to_python_object('\(def\\|async def\)', 1, 1, "n")<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseEndOfPythonFunction) :call pythonsense#move_to_python_object('\(def\\|async def\)', 1, 1, "v")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseEndOfPythonFunction) V:<C-u>call pythonsense#move_to_python_object('\(def\\|async def\)', 1, 1, "o")<CR>
nnoremap <buffer> <silent> <Plug>(PythonsenseStartOfPythonFunction) :<C-u>call pythonsense#move_to_python_object('\(def\\|async def\)', 0, 0, "n")<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseStartOfPythonFunction) :call pythonsense#move_to_python_object('\(def\\|async def\)', 0, 0, "v")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseStartOfPythonFunction) V:<C-u>call pythonsense#move_to_python_object('\(def\\|async def\)', 0, 0, "o")<CR>
nnoremap <buffer> <silent> <Plug>(PythonsenseEndOfPreviousPythonFunction) :<C-u>call pythonsense#move_to_python_object('\(def\\|async def\)', 1, 0, "n")<CR>
vnoremap <buffer> <silent> <Plug>(PythonsenseEndOfPreviousPythonFunction) :call pythonsense#move_to_python_object('\(def\\|async def\)', 1, 0, "v")<CR>
onoremap <buffer> <silent> <Plug>(PythonsenseEndOfPreviousPythonFunction) V:<C-u>call pythonsense#move_to_python_object('\(def\\|async def\)', 1, 0, "o")<CR>
" }}}2

" Information {{{2
nnoremap <buffer> <silent> <Plug>(PythonsensePyWhere) :Pywhere<CR>
" }}}2

" }}}1

" Plug Binding Key Maps  {{{1

if ! get(g:, "is_pythonsense_suppress_keymaps", 0) && ! get(g:, "is_pythonsense_suppress_object_keymaps", 0)

    if !hasmapto('<Plug>PythonsenseOuterClassTextObject')
        vmap <buffer> ac <Plug>(PythonsenseOuterClassTextObject)
        omap <buffer> ac <Plug>(PythonsenseOuterClassTextObject)
        sunmap <buffer> ac
    endif
    if !hasmapto('<Plug>PythonsenseInnerClassTextObject')
        vmap <buffer> ic <Plug>(PythonsenseInnerClassTextObject)
        omap <buffer> ic <Plug>(PythonsenseInnerClassTextObject)
        sunmap <buffer> ic
    endif

    if !hasmapto('<Plug>PythonsenseOuterFunctionTextObject')
        vmap <buffer> af <Plug>(PythonsenseOuterFunctionTextObject)
        omap <buffer> af <Plug>(PythonsenseOuterFunctionTextObject)
        sunmap <buffer> af
    endif
    if !hasmapto('<Plug>PythonsenseInnerFunctionTextObject')
        vmap <buffer> if <Plug>(PythonsenseInnerFunctionTextObject)
        omap <buffer> if <Plug>(PythonsenseInnerFunctionTextObject)
        sunmap <buffer> if
    endif

    if !hasmapto('<Plug>PythonsenseOuterDocStringTextObject')
        omap <buffer> ad <Plug>(PythonsenseOuterDocStringTextObject)
        vmap <buffer> ad <Plug>(PythonsenseOuterDocStringTextObject)
        sunmap <buffer> ad
    endif
    if !hasmapto('<Plug>PythonsenseInnerDocStringTextObject')
        omap <buffer> id <Plug>(PythonsenseInnerDocStringTextObject)
        vmap <buffer> id <Plug>(PythonsenseInnerDocStringTextObject)
        sunmap <buffer> id
    endif
endif

if ! get(g:, "is_pythonsense_suppress_keymaps", 0) && ! get(g:, "is_pythonsense_suppress_location_keymaps", 0)

    if !hasmapto('<Plug>(PythonsensePyWhere)')
        map g: <Plug>(PythonsensePyWhere)
    endif

endif

" }}}1

