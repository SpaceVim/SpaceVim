" ============================================================================
" File:        spacevim.vim
" Description: colorscheme for leaderf
" Author:      Shidong Wang <wsdjeg@outlook.com>
" Website:     https://github.com/wsdjeg
" License:     MIT
" ============================================================================

let s:palette = {
            \   'stlName': {
            \       'gui': 'bold',
            \       'font': 'NONE',
            \       'guifg': '#005F00',
            \       'guibg': '#AFDF00',
            \       'cterm': 'bold',
            \       'ctermfg': '22',
            \       'ctermbg': '148'
            \   },
            \   'stlCategory': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#870000',
            \       'guibg': '#FF8700',
            \       'cterm': 'NONE',
            \       'ctermfg': '88',
            \       'ctermbg': '208'
            \   },
            \   'stlNameOnlyMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#005D5D',
            \       'guibg': '#FFFFFF',
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
            \       'guifg': '#FFFFFF',
            \       'guibg': '#585858',
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

let g:leaderf#colorscheme#spacevim#palette = leaderf#colorscheme#mergePalette(s:palette)
