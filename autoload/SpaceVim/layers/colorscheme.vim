"=============================================================================
" colorscheme.vim --- SpaceVim colorscheme layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section colorscheme, colorscheme
" @parentsection layers
" The ldefault colorscheme for SpaceVim is gruvbox. The colorscheme can be
" changed with the `g:spacevim_colorscheme` option by adding the following
" line to your `~/.SpaceVim/init.vim`.
" >
"   let g:spacevim_colorscheme = 'solarized'
" <
"
" The following colorschemes are include in SpaceVim. If the colorscheme you
" want is not included in the list below, a PR is welcome.
"
" Also, there's one thing which everyone should know and pay attention to.
" NOT all of below colorschemes support spell check very well. For example,
" a colorscheme called atom doesn't support spell check very well.
"
" SpaceVim is not gonna fix them since these should be in charge of each author.
" You can see a list which has no support of spell check in here:
" https://github.com/SpaceVim/SpaceVim/issues/209#issuecomment-280545818
"
" >
"   anderson
"   apprentice
"   atom
"   base16-3024
"   base16-apathy
"   base16-ashes
"   base16-atelier-cave
"   base16-atelier-dune
"   base16-atelier-estuary
"   base16-atelier-forest
"   base16-atelier-heath
"   base16-atelier-lakeside
"   base16-atelier-plateau
"   base16-atelier-savanna
"   base16-atelier-seaside
"   base16-atelier-sulphurpool
"   base16-bespin
"   base16-brewer
"   base16-bright
"   base16-chalk
"   base16-codeschool
"   base16-cupcake
"   base16-darktooth
"   base16-default-dark
"   base16-default-light
"   base16-dracula
"   base16-eighties
"   base16-embers
"   base16-flat
"   base16-github
"   base16-google-dark
"   base16-google-light
"   base16-grayscale-dark
"   base16-grayscale-light
"   base16-green-screen
"   base16-harmonic16-dark
"   base16-harmonic16-light
"   base16-hopscotch
"   base16-ir-black
"   base16-isotope
"   base16-london-tube
"   base16-macintosh
"   base16-marrakesh
"   base16-materia
"   base16-mexico-light
"   base16-mocha
"   base16-monokai
"   base16-ocean
"   base16-oceanicnext
"   base16-onedark
"   base16-paraiso
"   base16-phd
"   base16-pico
"   base16-pop
"   base16-railscasts
"   base16-seti-ui
"   base16-shapeshifter
"   base16-solar-flare
"   base16-solarized-dark
"   base16-solarized-light
"   base16-spacemacs
"   base16-summerfruit-dark
"   base16-summerfruit-light
"   base16-tomorrow
"   base16-tomorrow-night
"   base16-twilight
"   base16-unikitty-dark
"   base16-unikitty-light
"   base16-woodland
"   blue
"   darkblue
"   default
"   delek
"   desert
"   elflord
"   evening
"   flatcolor
"   flattened_dark
"   flattened_light
"   focuspoint
"   gruvbox
"   hybrid
"   hybrid-material
"   hybrid_material
"   hybrid_reverse
"   industry
"   janah
"   jellybeans
"   koehler
"   lightning
"   lucius
"   molokai
"   molokayo
"   morning
"   murphy
"   OceanicNext
"   OceanicNextLight
"   onedark
"   pablo
"   PaperColor
"   parsec
"   peachpuff
"   pyte
"   rdark-terminal2
"   ron
"   scheakur
"   seoul256
"   seoul256-light
"   shine
"   slate
"   solarized
"   torte
"   twilight256
"   wombat256mod
"   yowish
"   zellner
" <


function! SpaceVim#layers#colorscheme#plugins() abort
    return [
                \ ['kristijanhusak/vim-hybrid-material', { 'merged' : 0 }],
                \ ['altercation/vim-colors-solarized', { 'merged' : 0 }],
                \ ['nanotech/jellybeans.vim', { 'merged' : 0 }],
                \ ['mhartington/oceanic-next', { 'merged' : 0 }],
                \ ['mhinz/vim-janah', { 'merged' : 0 }],
                \ ['Gabirel/molokai', { 'merged' : 0 }],
                \ ['kabbamine/yowish.vim', { 'merged' : 0 }],
                \ ['vim-scripts/wombat256.vim', { 'merged' : 0 }],
                \ ['vim-scripts/twilight256.vim', { 'merged' : 0 }],
                \ ['junegunn/seoul256.vim', { 'merged' : 0 }],
                \ ['vim-scripts/rdark-terminal2.vim', { 'merged' : 0 }],
                \ ['vim-scripts/pyte', { 'merged' : 0 }],
                \ ['joshdick/onedark.vim', { 'merged' : 0 }],
                \ ['fmoralesc/molokayo', { 'merged' : 0 }],
                \ ['jonathanfilip/vim-lucius', { 'merged' : 0 }],
                \ ['wimstefan/Lightning', { 'merged' : 0 }],
                \ ['w0ng/vim-hybrid', { 'merged' : 0 }],
                \ ['scheakur/vim-scheakur', { 'merged' : 0 }],
                \ ['keith/parsec.vim', { 'merged' : 0 }],
                \ ['NLKNguyen/papercolor-theme', { 'merged' : 0 }],
                \ ['romainl/flattened', { 'merged' : 0 }],
                \ ['SpaceVim/FlatColor', { 'merged' : 0 }],
                \ ['chase/focuspoint-vim', { 'merged' : 0 }],
                \ ['chriskempson/base16-vim', { 'merged' : 0 }],
                \ ['gregsexton/Atom', { 'merged' : 0 }],
                \ ['gilgigilgil/anderson.vim', { 'merged' : 0 }],
                \ ['romainl/Apprentice', { 'merged' : 0 }],
                \ ['icymind/NeoSolarized', { 'merged' : 0 }],
                \ ['jacoborus/tender', { 'merged' : 0 }],
                \ ['wsdjeg/vim-one', { 'merged' : 0 }],
                \ ['arcticicestudio/nord-vim', { 'merged' : 0 }],
                \ ['KeitaNakamura/neodark.vim', { 'merged' : 0 }]
                \ ]
endfunction

let s:cs = ['gruvbox', 'molokai', 'onedark', 'jellybeans', 'one', 'nord']
let s:Number = SpaceVim#api#import('data#number')

function! SpaceVim#layers#colorscheme#config() abort
    call SpaceVim#mapping#space#def('nnoremap', ['T', 'n'],
                \ 'call call(' . string(s:_function('s:cycle_spacevim_theme'))
                \ . ', [])', 'cycle-spacevim-theme', 1)
endfunction


" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
    function! s:_function(fstr) abort
        return function(a:fstr)
    endfunction
else
    function! s:_SID() abort
        return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
    endfunction
    let s:_s = '<SNR>' . s:_SID() . '_'
    function! s:_function(fstr) abort
        return function(substitute(a:fstr, 's:', s:_s, 'g'))
    endfunction
endif
function! s:cycle_spacevim_theme() abort
    let id = s:Number.random(0, len(s:cs))
    exe 'colorscheme ' . s:cs[id]
endfunction
