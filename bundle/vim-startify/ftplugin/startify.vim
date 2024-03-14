if g:spacevim_enable_tabline_ft_icon || get(g:, 'spacevim_enable_tabline_filetype_icon', 0)
  let s:FILE = SpaceVim#api#import('file')
  call s:FILE.hi_icons()
  augroup startify_highlith_icons
    autocmd! * <buffer>
    autocmd BufDelete,BufWipeout <buffer> call s:FILE.clear_icons()
  augroup END
endif
