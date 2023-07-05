
if exists('g:loaded_indent_blankline') || !has('nvim-0.5.0')
    finish
endif
let g:loaded_indent_blankline = 1

function s:try(cmd)
    try
        execute a:cmd
    catch /E12/
        return
    endtry
endfunction

command! -bang IndentBlanklineRefresh call s:try('lua require("indent_blankline.commands").refresh("<bang>" == "!")')
command! -bang IndentBlanklineRefreshScroll call s:try('lua require("indent_blankline.commands").refresh("<bang>" == "!", true)')
command! -bang IndentBlanklineEnable call s:try('lua require("indent_blankline.commands").enable("<bang>" == "!")')
command! -bang IndentBlanklineDisable call s:try('lua require("indent_blankline.commands").disable("<bang>" == "!")')
command! -bang IndentBlanklineToggle call s:try('lua require("indent_blankline.commands").toggle("<bang>" == "!")')

if exists(':IndentLinesEnable') && !g:indent_blankline_disable_warning_message
    echohl Error
    echom 'indent-blankline does not require IndentLine anymore, please remove it.'
    echohl None
endif

if !exists('g:__indent_blankline_setup_completed')
    lua require("indent_blankline").setup {}
endif

lua require("indent_blankline").init()

augroup IndentBlanklineAutogroup
    autocmd!
    autocmd OptionSet list,listchars,shiftwidth,tabstop,expandtab IndentBlanklineRefresh
    autocmd FileChangedShellPost,TextChanged,TextChangedI,CompleteChanged,BufWinEnter,Filetype * IndentBlanklineRefresh
    autocmd WinScrolled * IndentBlanklineRefreshScroll
    autocmd ColorScheme * lua require("indent_blankline.utils").reset_highlights()
    autocmd VimEnter * lua require("indent_blankline").init()
augroup END

