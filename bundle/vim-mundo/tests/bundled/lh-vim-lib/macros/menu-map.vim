"===========================================================================
" $Id: menu-map.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		macros/menu-map.vim
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
" 		<URL:http://code.google.com/p/lh-vim/>
"
" Purpose:	Define functions to build mappings and menus at the same time
"
" Version:	2.2.1
" Last Update:  $Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $ (02nd Dec 2006)
"
" Last Changes: {{{
" 	Version 2.0.0:
" 		Moved to vim7, 
" 		Functions moved to {rtp}/autoload/
" 	Version 1.6.2: 
" 		(*) Silent mappings and menus
" 	Version 1.6. : 
" 		(*) Uses has('gui_running') instead of has('gui') to check if
" 		we can generate the menu.
" 	Version 1.5. : 
" 		(*) visual mappings launched from select-mode don't end with
" 		    text still selected -- applied to :VCalls
" 	Version 1.4. : 
" 		(*) address obfuscated for spammers
" 		(*) support the local option 
" 		    b:want_buffermenu_or_global_disable if we don't want
" 		    buffermenu to be used systematically.
" 		    0 -> buffer menu not used
" 		    1 -> buffer menu used
" 		    2 -> the VimL developper will use a global disable.
" 		    cf.:   tex-maps.vim:: s:SimpleMenu()
" 		       and texmenus.vim
" 	Version 1.3. :
"		(*) add continuation lines support ; cf 'cpoptions'
" 	Version 1.2. :
" 		(*) Code folded.
" 		(*) Take advantage of buffermenu.vim if present for local
" 		    menus.
" 		(*) If non gui is available, the menus won't be defined
" 	Version 1.1. :
"               (*) Bug corrected : 
"                   vnore(map\|menu) does not imply v+n(map\|menu) any more
" }}}
"
" Inspired By:	A function from Benji Fisher
"
" TODO:		(*) no menu if no gui.
"
"===========================================================================

if exists("g:loaded_menu_map") | finish | endif
let g:loaded_menu_map = 1  

"" line continuation used here ??
let s:cpo_save = &cpo
set cpo&vim

"=========================================================================
" Commands {{{
command! -nargs=+ -bang      MAP      map<bang> <args>
command! -nargs=+           IMAP     imap       <args>
command! -nargs=+           NMAP     nmap       <args>
command! -nargs=+           CMAP     cmap       <args>
command! -nargs=+           VMAP     vmap       <args>
command! -nargs=+           AMAP
      \       call lh#menu#map_all('amap', <f-args>)

command! -nargs=+ -bang  NOREMAP  noremap<bang> <args>
command! -nargs=+       INOREMAP inoremap       <args>
command! -nargs=+       NNOREMAP nnoremap       <args>
command! -nargs=+       CNOREMAP cnoremap       <args>
command! -nargs=+       VNOREMAP vnoremap       <args>
command! -nargs=+       ANOREMAP
      \       call lh#menu#map_all('anoremap', <f-args>)
" }}}

" End !
let &cpo = s:cpo_save
finish

"=========================================================================
" vim600: set fdm=marker:
