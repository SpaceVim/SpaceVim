""
" @section Layers, layers
"   SpaceVim support such layers:


""
" Load the {layer} you want. For all the layers SpaceVim supports, see @section(layers).
" the second argv is the layer variable.
function! SpaceVim#layers#load(layer, ...) abort
  if a:layer == '-l'
    call s:list_layers()
  endif
  if index(g:spacevim_plugin_groups, a:layer) == -1
    call add(g:spacevim_plugin_groups, a:layer)
  endif
  if a:0 == 1 && type(a:1) == 4
    try
      call SpaceVim#layers#{a:layer}#set_variable(a:1)
    catch /^Vim\%((\a\+)\)\=:E117/
    endtry
  endif
  if a:0 > 0 && type(a:1) == 1 
    for l in a:000
      call SpaceVim#layers#load(l)
    endfor
  endif
endfunction

function! s:list_layers() abort
  tabnew SpaceVimLayers
  nnoremap <buffer> q :q<cr>
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
  setf SpaceVimLayerManager
  nnoremap <silent> <buffer> q :bd<CR>
  let info = [
        \ 'SpaceVim layers:',
        \ '',
        \ ]
  call setline(1,info + s:find_layers())
  setl nomodifiable
endfunction

function! s:find_layers() abort
  let layers = SpaceVim#util#globpath(&rtp, "autoload/SpaceVim/layers/**/*.vim")
  let pattern = '/autoload/SpaceVim/layers/'
  let rst = []
  for layer in layers
    if layer =~# pattern
      let name = layer[matchend(layer, pattern):-5]
      let status = (index(g:spacevim_plugin_groups, substitute(name, '/', '#','g')) != -1) ? 'loaded' : 'not loaded'
      if filereadable(expand('~/.SpaceVim/docs/layers/' . name . '.md'))
        let website = 'https://spacevim.org/layers/' . name
      else
        let website = 'no exists'
      endif
      if status == 'loaded'
        call add(rst, '+ ' . name . ':' . repeat(' ', 25 - len(name)) . status . repeat(' ', 10) . website)
      else
        call add(rst, '- ' . name . ':' . repeat(' ', 21 - len(name)) . status . repeat(' ', 10) . website)
      endif
    endif
  endfor
  return rst
endfunction



" vim:set et sw=2:
