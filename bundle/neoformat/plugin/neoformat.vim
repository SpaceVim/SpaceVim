command! -nargs=? -bar -range=% -bang -complete=customlist,neoformat#CompleteFormatters Neoformat
            \ call neoformat#Neoformat(<bang>0, <q-args>, <line1>, <line2>)
