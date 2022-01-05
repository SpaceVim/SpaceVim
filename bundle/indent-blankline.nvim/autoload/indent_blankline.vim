
function! indent_blankline#Refresh(...)
    try
        if a:0 > 0
            call luaeval("require('indent_blankline').refresh(_A)", a:1)
        else
            lua require("indent_blankline").refresh()
        end
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
