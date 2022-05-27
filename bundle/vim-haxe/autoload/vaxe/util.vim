"Vaxe utility functions (vutil)

" Utility function that recursively searches parent directories for 'dir'
" until a file matching "pattern" is found.
function! vaxe#util#ParentSearch(patterns, dir)
    let current_dir = fnamemodify(a:dir,":p:h")
    let last_dir = ''
    while(current_dir != last_dir)
        let last_dir = current_dir
        for p in a:patterns
            let match = globpath(current_dir, p)
            if match != ''
                return match
            endif
        endfor
        let current_dir = fnamemodify(current_dir, ":p:h:h")
    endwhile
    return ''
endfunction

" returns the current running haxe version on the cache server
function! vaxe#util#HaxeServerVersion()
    let response = vaxe#util#SimpleSystem("haxe --connect "
                \ . g:vaxe_cache_server_port . ' -version' )
    if response =~ '\v^([0-9]\.)*[0-9]$'
        return response
    else
        return '0'
    endif
endfunction

function! vaxe#util#Strip(str)
        return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! vaxe#util#SimpleSystem(cmd)
    let lines = system(a:cmd)
    let firstline = split(lines,'\n')[0]
    return vaxe#util#Strip(firstline)
endfunction


" ye olde default config setter
function! vaxe#util#Config(name, default)
    if !exists(a:name)
        return a:default
    else
        return eval(a:name)
    endif
endfunction


" Utility function that lets users select from a list.  If list is length 1,
" then that item is returned.  Uses tlib#inpu#List if available.
function! vaxe#util#InputList(label, items)
  if len(a:items) == 1
    return a:items[0]
  endif
  if exists("g:loaded_tlib")
      return tlib#input#List("s", a:label, a:items)
  else
      let items_list = map(range(len(a:items)),'(v:val+1)." ".a:items[v:val]')
      let items_list = [a:label] + items_list
      let sel = inputlist(items_list)
      " 0 is the label.  If that is returned, just use the first item in the
      " list instead
      if sel == 0
          let sel = 1
      endif
      return a:items[sel-1]
  endif
endfunction

" Utility function that returns a list of unique values in the list argument.
function! vaxe#util#UniqueList(items)
    let d = {}
    for v in a:items
        let d[v] = 1
    endfor
    return keys(d)
endfunction

