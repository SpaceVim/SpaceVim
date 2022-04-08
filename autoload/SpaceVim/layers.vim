"=============================================================================
" layers.vim --- layers public API
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section Layers, layers
"   Layers help collecting related packages together to provides features.
" This approach helps keep configuration organized and reduces overhead for
" the user by keeping them from having to think about what packages to install.
"
" @subsection Enable layers
"
" By default SpaceVim enables these layers:
"
" 1. `autocomplete`
" 2. `checkers`
" 3. `format`
" 4. `edit`
" 5. `ui`
" 5. `core`
" 6. `core#banner`
" 7. `core#statusline`
" 8. `core#tabline`
"
" To enable a specific layer you need to edit SpaceVim's custom configuration files.
" The key binding for opening the configuration files.s `SPC f v d`.
"
" The following example shows how to load `shell` layer with some specified options:
" >
"   [[layers]]
"     name = 'shell'
"     default_position = 'top'
"     default_height = 30
" <
"
" @subsection Disable layers
"
" Some layers are enabled by default. The following example shows how to disable `shell` layer:
" >
"   [[layers]]
"     name = 'shell'
"     enable = false
" <

let s:enabled_layers = []
let s:layers_vars = {}


let s:SYS = SpaceVim#api#import('system')

""
" Load the {layer} you want. For all the layers SpaceVim supports, see @section(layers).
" the second argv is the layer variable. For example:
" >
"   call SpaceVim#layers#load('autocomplete',
"     \ {
"     \  'auto_completion_delay' : 50,
"     \ } 
"     \ )
" <
function! SpaceVim#layers#load(layer, ...) abort
  if a:layer ==# '-l'
    call s:list_layers()
    return
  elseif empty(a:layer) || type(a:layer) !=# type('')
    return
  endif
  let loadable = 1
  try
    let loadable = SpaceVim#layers#{a:layer}#loadable()
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
  if index(s:enabled_layers, a:layer) == -1
    if loadable
      call add(s:enabled_layers, a:layer)
    else
      call SpaceVim#logger#warn('Failed to load '
            \ . a:layer
            \ . ' layer, read :h SpaceVim-layer-' . a:layer 
            \ . ' for more info!', 0)
    endif
  endif
  if a:0 == 1 && type(a:1) == 4
    try
      call SpaceVim#layers#{a:layer}#set_variable(a:1)
      let s:layers_vars[a:layer] = a:1
    catch /^Vim\%((\a\+)\)\=:E117/
    endtry
  endif
  if a:0 > 0 && type(a:1) == 1 
    for l in a:000
      call SpaceVim#layers#load(l)
    endfor
  endif
endfunction

function! SpaceVim#layers#disable(layer) abort
  let index = index(s:enabled_layers, a:layer)
  if index != -1
    call remove(s:enabled_layers, index)
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
  let layers = SpaceVim#util#globpath(&rtp, 'autoload/SpaceVim/layers/**/*.vim')
  let pattern = s:SYS.isWindows ? '\\autoload\\SpaceVim\\layers\\' : '/autoload/SpaceVim/layers/'
  let rst = []
  for layer in layers
    if layer =~# pattern
      if s:SYS.isWindows
        let name = substitute(layer[matchend(layer, pattern):-5], '\\', '/', 'g')
      else
        let name = layer[matchend(layer, pattern):-5]
      endif
      let status = (index(s:enabled_layers, substitute(name, '/', '#','g')) != -1) ? 'loaded' : 'not loaded'
      if name ==# 'lsp'
        let url = 'language-server-protocol'
      else
        let url = name
      endif
      if filereadable(expand('~/.SpaceVim/docs/layers/' . url . '.md'))
        let website = 'https://spacevim.org/layers/' . url . '/'
      else
        let website = 'no exists'
      endif
      let name = substitute(name, '/', '#','g')
      if status ==# 'loaded'
        call add(rst, '+ ' . name . ':' . repeat(' ', 25 - len(name)) . status . repeat(' ', 10) . website)
      else
        call add(rst, '- ' . name . ':' . repeat(' ', 21 - len(name)) . status . repeat(' ', 10) . website)
      endif
    endif
  endfor
  return rst
endfunction

function! SpaceVim#layers#get() abort
  return deepcopy(s:enabled_layers)
endfunction

function! SpaceVim#layers#isLoaded(layer) abort
  return index(s:enabled_layers, a:layer) != -1
endfunction

function! SpaceVim#layers#report() abort
  let info = "```toml\n"
  for name in s:enabled_layers
    let info .= "[[layers]]\n"
    let info .= '  name="' . name . '"' . "\n"
    if has_key(s:layers_vars, name)
      for var in keys(s:layers_vars[name])
        if var !=# 'name'
          let info .= '  ' . var . '=' . string(s:layers_vars[name][var]) . "\n"
        endif
      endfor
    endif
  endfor
  let info .= "```\n"
  return info
endfunction

function! SpaceVim#layers#list() abort

  let files = SpaceVim#util#globpath('.', 'autoload/SpaceVim/layers/**/*.vim')
  let pattern = s:SYS.isWindows ? '\\autoload\\SpaceVim\\layers\\' : '/autoload/SpaceVim/layers/'
  let layers = []
  for file in files
    if s:SYS.isWindows
      let layer = substitute(file[matchend(file, pattern):-5], '\\', '/', 'g')
    else
      let layer = file[matchend(file, pattern):-5]
    endif
    call add(layers, layer)
  endfor

  return map(layers, "substitute(v:val, '/', '#','g')")

endfunction



" vim:set et sw=2:
