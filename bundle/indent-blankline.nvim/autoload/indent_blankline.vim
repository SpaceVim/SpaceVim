
function! indent_blankline#Refresh()
    try
        lua require("indent_blankline").refresh()
    catch /E12/
        return
    catch
        if g:indent_blankline_debug
            echohl Error
            echom 'indent-blankline encountered an error on refresh: ' . v:exception
            echohl None
        endif
    endtry
endfunction
