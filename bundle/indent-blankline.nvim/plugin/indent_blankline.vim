
if exists('g:loaded_indent_blankline') || !has('nvim-0.5.0')
    finish
endif
let g:loaded_indent_blankline = 1

let g:indent_blankline_char = get(g:, 'indent_blankline_char', get(g:, 'indentLine_char', '|'))
let g:indent_blankline_char_list = get(g:, 'indent_blankline_char_list', get(g:, 'indentLine_char_list', []))
let g:indent_blankline_char_highlight_list = get(g:, 'indent_blankline_char_highlight_list', [])

let g:indent_blankline_space_char = get(g:, 'indent_blankline_space_char', indent_blankline#helper#GetListChar('space', ' '))
let g:indent_blankline_space_char_highlight_list = get(g:, 'indent_blankline_space_char_highlight_list', [])

let g:indent_blankline_space_char_blankline = get(g:, 'indent_blankline_space_char_blankline', g:indent_blankline_space_char)
let g:indent_blankline_space_char_blankline_highlight_list = get(g:, 'indent_blankline_space_char_blankline_highlight_list', g:indent_blankline_space_char_highlight_list)

let g:indent_blankline_indent_level = get(g:, 'indent_blankline_indent_level', get(g:, 'indentLine_indentLevel', 20))
let g:indent_blankline_enabled = get(g:, 'indent_blankline_enabled', get(g:, 'indentLine_enabled', v:true))
let g:indent_blankline_filetype = get(g:, 'indent_blankline_filetype', get(g:, 'indentLine_fileType', []))
let g:indent_blankline_filetype_exclude = get(g:, 'indent_blankline_filetype_exclude', get(g:, 'indentLine_fileTypeExclude', []))
let g:indent_blankline_bufname_exclude = get(g:, 'indent_blankline_bufname_exclude', get(g:, 'indentLine_bufNameExclude', []))
let g:indent_blankline_buftype_exclude = get(g:, 'indent_blankline_buftype_exclude', get(g:, 'indentLine_bufTypeExclude', []))
let g:indent_blankline_viewport_buffer = get(g:, 'indent_blankline_viewport_buffer', 10)
let g:indent_blankline_use_treesitter = get(g:, 'indent_blankline_use_treesitter', v:false)
let g:indent_blankline_debug = get(g:, 'indent_blankline_debug', v:false)
let g:indent_blankline_disable_warning_message = get(g:, 'indent_blankline_disable_warning_message', v:false)
let g:indent_blankline_show_first_indent_level = get(g:, 'indent_blankline_show_first_indent_level', v:true)
let g:indent_blankline_show_trailing_blankline_indent = get(g:, 'indent_blankline_show_trailing_blankline_indent', v:true)
let g:indent_blankline_show_end_of_line = get(g:, 'indent_blankline_show_end_of_line', v:false)
let g:indent_blankline_show_foldtext = get(g:, 'indent_blankline_show_foldtext', v:true)
let g:indent_blankline_show_current_context = get(g:, 'indent_blankline_show_current_context', v:false)
let g:indent_blankline_context_highlight_list = get(g:, 'indent_blankline_context_highlight_list', [])
let g:indent_blankline_context_patterns = get(g:, 'indent_blankline_context_patterns', ['class', 'function', 'method'])
let g:indent_blankline_strict_tabs = get(g:, 'indent_blankline_strict_tabs', v:false)

lua require("indent_blankline").setup()

function s:try(cmd)
    try
        execute a:cmd
    catch /E12/
        return
    endtry
endfunction

command! -bang IndentBlanklineRefresh call s:try('lua require("indent_blankline.commands").refresh("<bang>" == "!")')
command! -bang IndentBlanklineEnable call s:try('lua require("indent_blankline.commands").enable("<bang>" == "!")')
command! -bang IndentBlanklineDisable call s:try('lua require("indent_blankline.commands").disable("<bang>" == "!")')
command! -bang IndentBlanklineToggle call s:try('lua require("indent_blankline.commands").toggle("<bang>" == "!")')

function s:IndentBlanklineInit()
    if exists(':IndentLinesEnable') && !g:indent_blankline_disable_warning_message
        echohl Error
        echom 'indent-blankline does not require IndentLine anymore, please remove it.'
        echohl None
    endif
    IndentBlanklineRefresh!
endfunction

augroup IndentBlanklineAutogroup
    autocmd!
    autocmd OptionSet shiftwidth,tabstop,expandtab IndentBlanklineRefresh
    autocmd FileChangedShellPost,TextChanged,TextChangedI,WinScrolled,BufWinEnter,Filetype * IndentBlanklineRefresh
    autocmd VimEnter * call s:IndentBlanklineInit()
    autocmd ColorScheme * lua require("indent_blankline.utils").reset_highlights()
augroup END

if g:indent_blankline_show_current_context
    augroup IndentBlanklineContextAutogroup
        autocmd!
        autocmd CursorMoved * IndentBlanklineRefresh
    augroup END
endif
