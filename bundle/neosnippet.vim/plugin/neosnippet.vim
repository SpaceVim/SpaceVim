"=============================================================================
" FILE: neosnippet.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_neosnippet')
  finish
elseif v:version < 704
  echoerr 'neosnippet does not work this version of Vim "' . v:version . '".'
  finish
endif

" Plugin key-mappings.
inoremap <silent><expr> <Plug>(neosnippet_expand_or_jump)
      \ neosnippet#mappings#expand_or_jump_impl()
inoremap <silent><expr> <Plug>(neosnippet_jump_or_expand)
      \ neosnippet#mappings#jump_or_expand_impl()
inoremap <silent><expr> <Plug>(neosnippet_expand)
      \ neosnippet#mappings#expand_impl()
inoremap <silent><expr> <Plug>(neosnippet_jump)
      \ neosnippet#mappings#jump_impl()
snoremap <silent><expr> <Plug>(neosnippet_expand_or_jump)
      \ neosnippet#mappings#expand_or_jump_impl()
snoremap <silent><expr> <Plug>(neosnippet_jump_or_expand)
      \ neosnippet#mappings#jump_or_expand_impl()
snoremap <silent><expr> <Plug>(neosnippet_expand)
      \ neosnippet#mappings#expand_impl()
snoremap <silent><expr> <Plug>(neosnippet_jump)
      \ neosnippet#mappings#jump_impl()

" start Select Mode either by g_CTRL-H in Normal or v_CTRL-G in Visual and use
" predefined ones in smap
nmap <Plug>(neosnippet_expand_or_jump) g<C-h><Plug>(neosnippet_expand_or_jump)
nmap <Plug>(neosnippet_jump_or_expand) g<C-h><Plug>(neosnippet_jump_or_expand)
nmap <Plug>(neosnippet_expand)         g<C-h><Plug>(neosnippet_expand)
nmap <Plug>(neosnippet_jump)           g<C-h><Plug>(neosnippet_jump)
xmap <Plug>(neosnippet_expand_or_jump) <C-g><Plug>(neosnippet_expand_or_jump)
xmap <Plug>(neosnippet_jump_or_expand) <C-g><Plug>(neosnippet_jump_or_expand)
xmap <Plug>(neosnippet_expand)         <C-g><Plug>(neosnippet_expand)
xmap <Plug>(neosnippet_jump)           <C-g><Plug>(neosnippet_jump)

xnoremap <silent> <Plug>(neosnippet_get_selected_text)
      \ :call neosnippet#helpers#get_selected_text(visualmode(), 1)<CR>

xnoremap <silent> <Plug>(neosnippet_expand_target)
      \ :<C-u>call neosnippet#mappings#_expand_target()<CR>
xnoremap <silent> <Plug>(neosnippet_register_oneshot_snippet)
      \ :<C-u>call neosnippet#mappings#_register_oneshot_snippet()<CR>

inoremap <expr><silent> <Plug>(neosnippet_start_unite_snippet)
      \ unite#sources#neosnippet#start_complete()


augroup neosnippet
  autocmd InsertEnter * call neosnippet#init#_initialize()
augroup END

" Commands.
command! -nargs=? -bar
      \ -complete=customlist,neosnippet#commands#_edit_complete
      \ NeoSnippetEdit
      \ call neosnippet#commands#_edit(<q-args>)

command! -nargs=? -bar
      \ -complete=customlist,neosnippet#commands#_filetype_complete
      \ NeoSnippetMakeCache
      \ call neosnippet#commands#_make_cache(<q-args>)

command! -nargs=1 -bar -complete=file
      \ NeoSnippetSource
      \ call neosnippet#commands#_source(<q-args>)

command! -bar NeoSnippetClearMarkers
      \ call neosnippet#commands#_clear_markers()


let g:loaded_neosnippet = 1
