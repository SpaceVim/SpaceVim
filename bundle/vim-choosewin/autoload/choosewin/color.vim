let s:Color = {}

function! s:Color.init() "{{{1
  if has_key(self, 'mgr')
    return
  endif

  let config   = choosewin#config#get()
  let self.mgr = choosewin#hlmanager#new('')

  let colors = {
        \ "Label":          config['color_label'],
        \ "LabelCurrent":   config['color_label_current'],
        \ "Overlay":        config['color_overlay'],
        \ "OverlayCurrent": config['color_overlay_current'],
        \ "Shade":          config['color_shade'],
        \ "Land":           config['color_land'],
        \ "Other":          config[ config.label_fill ? "color_label" : "color_other" ],
        \ }
  for [color, spec] in items(colors)
    call self.mgr.register("ChooseWin" . color, spec)
  endfor
endfunction
"}}}

" API:
function! choosewin#color#init() "{{{1
  return s:Color.init()
endfunction

function! choosewin#color#refresh() "{{{1
  call s:Color.init()
  call s:Color.mgr.refresh()
endfunction
"}}}

" vim: foldmethod=marker
