function! github#api#authorize() abort
  if !empty(g:githubapi_token)
    return ['--header', "Authorization: Bearer " . g:githubapi_token]
  else
    return []
  endif
endfunction
