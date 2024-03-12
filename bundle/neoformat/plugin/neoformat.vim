""
"
" Format the entire buffer, or visual selection of the buffer
" >
" 	:Neoformat
"
" <Or specify a certain formatter (must be defined for the current filetype)
" >
" 	:Neoformat jsbeautify
"
" Or format a visual selection of code in a different filetype
"
" *Note:* you must use a ! and pass the filetype of the selection
"
" >
" 	:Neoformat! python
" >
" You can also pass a formatter to use
"
" >
" 	:Neoformat! python yapf
" <
"
" Or perhaps run a formatter on save
"
" >
"     augroup fmt
"       autocmd!
"       autocmd BufWritePre * undojoin | Neoformat
"     augroup END
" <
"
" The |undojoin| command will put changes made by Neoformat into the same
" |undo-block| with the latest preceding change. See
" |neoformat-managing-undo-history|.
command! -nargs=? -bar -range=% -bang -complete=customlist,neoformat#CompleteFormatters Neoformat
            \ call neoformat#Neoformat(<bang>0, <q-args>, <line1>, <line2>)
