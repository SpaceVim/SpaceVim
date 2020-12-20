
function String()

  let output = filter(list, "matchstr(v:val, '^\s*\zsfoo\ze\\(bar\\|baz\\)')")
  let output = filter(list, 'matchstr(v:val, ''^\s*\zsfoo\ze\(bar\|baz\)'')')

endfunction

