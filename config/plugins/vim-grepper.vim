" initialize g:grepper if it does not exist
if !exists('g:grepper')
  let g:grepper = {}
endif

" set value of g:grepper['tools'] to the same list of tools used by FlyGrep
if !has_key(g:grepper, 'tools')
  let g:grepper = {'tools': g:spacevim_search_tools}
endif

" invoke Grepper using visually selected pattern
xmap gp <plug>(GrepperOperator)
