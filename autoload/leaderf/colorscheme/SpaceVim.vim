" ============================================================================
" spacevim.vim --- leaderf theme for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
" ============================================================================

let s:palette = {
            \   'stlName': {
            \       'gui': 'bold',
            \       'font': 'NONE',
            \       'guifg': '#282828',
            \       'guibg': '#928374',
            \       'cterm': 'bold',
            \       'ctermfg': '22',
            \       'ctermbg': '148'
            \   },
            \   'stlCategory': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#3c3836',
            \       'guibg': '#83a598',
            \       'cterm': 'NONE',
            \       'ctermfg': '88',
            \       'ctermbg': '208'
            \   },
            \   'stlNameOnlyMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#665c54',
            \       'guibg': '#bdae93',
            \       'cterm': 'NONE',
            \       'ctermfg': '23',
            \       'ctermbg': '231'
            \   },
            \   'stlFullPathMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#FFFFFF',
            \       'guibg': '#FF2929',
            \       'cterm': 'NONE',
            \       'ctermfg': '231',
            \       'ctermbg': '196'
            \   },
            \   'stlFuzzyMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#004747',
            \       'guibg': '#FFFFFF',
            \       'cterm': 'NONE',
            \       'ctermfg': '23',
            \       'ctermbg': '231'
            \   },
            \   'stlRegexMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#000000',
            \       'guibg': '#7FECAD',
            \       'cterm': 'NONE',
            \       'ctermfg': '16',
            \       'ctermbg': '121'
            \   },
            \   'stlCwd': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#bdae93',
            \       'guibg': '#665c54',
            \       'cterm': 'NONE',
            \       'ctermfg': '231',
            \       'ctermbg': '240'
            \   },
            \   'stlBlank': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': 'NONE',
            \       'guibg': '#303136',
            \       'cterm': 'NONE',
            \       'ctermfg': 'NONE',
            \       'ctermbg': '236'
            \   },
            \   'stlLineInfo': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#C9C9C9',
            \       'guibg': '#585858',
            \       'cterm': 'NONE',
            \       'ctermfg': '251',
            \       'ctermbg': '240'
            \   },
            \   'stlTotal': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#545454',
            \       'guibg': '#D0D0D0',
            \       'cterm': 'NONE',
            \       'ctermfg': '240',
            \       'ctermbg': '252'
            \   }
            \ }

let g:leaderf#colorscheme#SpaceVim#palette = leaderf#colorscheme#mergePalette(s:palette)
