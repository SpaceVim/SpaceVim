let s:cache_path = g:spacevim_data_dir . 'SpaceVim/bookmarks.json'


function! bookmarks#cache#write(data) abort
  call writefile([json_encode(a:data)], s:cache_path)
endfunction

function! bookmarks#cache#read() abort
  if filereadable(s:cache_path)
    let data = join(readfile(s:cache_path), '')
    if data !=# ''
      return json_decode(data)
    else
      return {}
    endif
  else
    return {}
  endif
endfunction
