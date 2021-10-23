" ============================================================================
" File:        mundo.vim
" Description: vim global plugin to visualize your undo tree
" Maintainer:  Hyeon Kim <simnalamburt@gmail.com>
" License:     GPLv2+ -- look it up.
" Notes:       Much of this code was thiefed from Mercurial, and the rest was
"              heavily inspired by scratch.vim and histwin.vim.
"
" ============================================================================

if !exists('g:mundo_debug') && (exists('g:mundo_disable') &&
            \ g:mundo_disable == 1 || exists('loaded_mundo') || &cp)"{{{
    finish
endif

let loaded_mundo = 1"}}}

" Default option values{{{

call mundo#util#set_default(
            \ 'g:mundo_auto_preview', 1,
            \ 'g:gundo_auto_preview')

call mundo#util#set_default('g:mundo_auto_preview_delay', 250)

call mundo#util#set_default(
            \ 'g:mundo_close_on_revert', 0,
            \ 'g:gundo_close_on_revert')

call mundo#util#set_default(
            \ 'g:mundo_first_visible_line', 0,
            \ 'g:gundo_first_visible_line')

call mundo#util#set_default('g:mundo_header', 1)

call mundo#util#set_default(
            \ 'g:mundo_help', 0,
            \ 'g:gundo_help')

call mundo#util#set_default(
            \ 'g:mundo_inline_undo', 0,
            \ 'g:gundo_inline_undo')

call mundo#util#set_default(
            \ 'g:mundo_last_visible_line', 0,
            \ 'g:gundo_last_visible_line')

call mundo#util#set_default(
            \ 'g:mundo_map_move_newer', 'k',
            \ 'g:gundo_map_move_newer')

call mundo#util#set_default(
            \ 'g:mundo_map_move_older', 'j',
            \ 'g:gundo_map_move_older')

call mundo#util#set_default(
            \ 'g:mundo_map_up_down', 1,
            \ 'g:gundo_map_up_down')

call mundo#util#set_default(
            \ 'g:mundo_mirror_graph', 0,
            \ 'g:gundo_mirror_graph')

call mundo#util#set_default(
            \ 'g:mundo_playback_delay', 60,
            \ 'g:gundo_playback_delay')

call mundo#util#set_default(
            \ 'g:mundo_prefer_python3', 0,
            \ 'g:gundo_prefer_python3')

call mundo#util#set_default(
            \ 'g:mundo_preview_bottom', 0,
            \ 'g:gundo_preview_bottom')

call mundo#util#set_default(
            \ 'g:mundo_preview_height', 15,
            \ 'g:gundo_preview_height')

call mundo#util#set_default(
            \ 'g:mundo_python_path_setup', 0,
            \ 'g:gundo_python_path_setup')

call mundo#util#set_default(
            \ 'g:mundo_return_on_revert', 1,
            \ 'g:gundo_return_on_revert')

call mundo#util#set_default(
            \ 'g:mundo_right', 0,
            \ 'g:gundo_right')

call mundo#util#set_default(
            \ 'g:mundo_verbose_graph', 1,
            \ 'g:gundo_verbose_graph')

call mundo#util#set_default(
            \ 'g:mundo_width', 45,
            \ 'g:gundo_width')

" Set up the default mappings, unless a g:mundo_mappings has already been
" provided
if mundo#util#set_default('g:mundo_mappings', {})
    let g:mundo_mappings = {
                \ '<CR>': 'preview',
                \ 'o': 'preview',
                \ 'J': 'move_older_write',
                \ 'K': 'move_newer_write',
                \ 'gg': 'move_top',
                \ 'G': 'move_bottom',
                \ 'P': 'play_to',
                \ 'd': 'diff',
                \ 'i': 'toggle_inline',
                \ '/': 'search',
                \ 'n': 'next_match',
                \ 'N': 'previous_match',
                \ 'p': 'diff_current_buffer',
                \ 'r': 'diff',
                \ '?': 'toggle_help',
                \ 'q': 'quit',
                \ '<2-LeftMouse>': 'mouse_click' }
    let g:mundo_mappings[g:mundo_map_move_older] = 'move_older'
    let g:mundo_mappings[g:mundo_map_move_newer] = 'move_newer'
    if g:mundo_map_up_down
        let g:mundo_mappings['<down>'] = 'move_older'
        let g:mundo_mappings['<up>'] = 'move_newer'
    endif
endif
"}}}

"{{{ Create commands

command! -nargs=0 MundoToggle call mundo#MundoToggle()
command! -nargs=0 MundoShow call mundo#MundoShow()
command! -nargs=0 MundoHide call mundo#MundoHide()
command! -nargs=0 GundoToggle call mundo#util#MundoToggle()
command! -nargs=0 GundoShow call mundo#util#MundoShow()
command! -nargs=0 GundoHide call mundo#util#MundoHide()
command! -nargs=0 GundoRenderGraph call mundo#util#MundoRenderGraph()

"}}}
