call vimtest#StartTap()
call vimtap#Plan(8 + 8 + 7) " <== XXX  Keep plan number updated.  XXX

let erex = ExtendedRegexObject('vrs#get')

let t = '\<\%{_ip4_segment,4,.}\>'
let t_expanded = '\<\%(25[0-5]\|2[0-4]\d\|[01]\?\d\d\?\)\.\%(25[0-5]\|2[0-4]\d\|[01]\?\d\d\?\)\.\%(25[0-5]\|2[0-4]\d\|[01]\?\d\d\?\)\.\%(25[0-5]\|2[0-4]\d\|[01]\?\d\d\?\)\>'
let vim_func_pat = '^[\ 	:]*fu\%[nction]!\?\s*\(.\{-}\)('

call vimtap#Is(erex.expand_composition_atom(t), t_expanded, 'expand _ip4_segment')
call vimtap#Is(erex.expand_composition_atom('\%{_ip4_segment,2,.}'), '\%(25[0-5]\|2[0-4]\d\|[01]\?\d\d\?\)\.\%(25[0-5]\|2[0-4]\d\|[01]\?\d\d\?\)', 'explicit count of 2 and explicit sep of dot')
call vimtap#Is(erex.expand_composition_atom('\%{vim_function,1,}'), vim_func_pat, 'explicit count of 1 and explicitly empty sep')
call vimtap#Is(erex.expand_composition_atom('\%{vim_function,1}'), vim_func_pat, 'explicit count of 1 and implicit sep')
call vimtap#Is(erex.expand_composition_atom('\%{vim_function}'), vim_func_pat, 'implicitly expand name only')
call vimtap#Is(erex.expand_composition_atom('\%{vim_function,2,}'), vim_func_pat . vim_func_pat, 'explicit count and explicitly empty sep')
call vimtap#Is(erex.expand_composition_atom('\%{vim_function,2}'), vim_func_pat . vim_func_pat, 'explicit count, implicit sep')
call vimtap#Is(erex.expand_composition_atom('\%{vim_function,3,\n}'), join(repeat(vim_func_pat, 3), "\n"), 'explicit literal sep')

call vimtap#Is(erex.parse(t), t_expanded, 'expand _ip4_segment')
call vimtap#Is(erex.parse('\%{_ip4_segment,2,.}'), '\%(25[0-5]\|2[0-4]\d\|[01]\?\d\d\?\)\.\%(25[0-5]\|2[0-4]\d\|[01]\?\d\d\?\)', 'explicit count of 2 and explicit sep of dot')
call vimtap#Is(erex.parse('\%{vim_function,1,}'),   vim_func_pat, 'explicit count of 1 and explicitly empty sep')
call vimtap#Is(erex.parse('\%{vim_function,1}'),    vim_func_pat, 'explicit count of 1 and implicit sep')
call vimtap#Is(erex.parse('\%{vim_function}'),      vim_func_pat, 'expand name only')
call vimtap#Is(erex.parse('\%{vim_function,2,}'),   vim_func_pat . vim_func_pat, 'explicit count and explicitly empty sep')
call vimtap#Is(erex.parse('\%{vim_function,2}'),    vim_func_pat . vim_func_pat, 'explicit count, implicit sep')
call vimtap#Is(erex.parse('\%{vim_function,3,\n}'), join(repeat(vim_func_pat, 3), "\n"), 'explicit literal sep')

" with spaces

let t = '\<\%{_ip4_segment, 4, .}\>'
call vimtap#Is( erex.parse(t), t_expanded, 'expand _ip4_segment with spaces')
call vimtap#Is( erex.parse('\%{vim_function , 1 , }'),     vim_func_pat, 'expand explicitly empty sep with spaces')
call vimtap#Is( erex.parse('\%{vim_function ,1}'),         vim_func_pat, 'expand implicit sep with spaces')
call vimtap#Is( erex.parse('\%{vim_function }'),           vim_func_pat, 'expand name only with space')
call vimtap#Is( erex.parse('\%{vim_function, 2, }'),       vim_func_pat . vim_func_pat, 'expand count of 2 and explicitly empty sep with spaces')
call vimtap#Is( erex.parse('\%{vim_function , 2}'),        vim_func_pat . vim_func_pat, 'expand count of 2 and implicit sep with spaces')
call vimtap#Is( erex.parse('\%{ vim_function , 3 , \n }'), join(repeat(vim_func_pat, 3), "\n"), 'expand count of 3 and explicit of \\n sep with spaces')

call vimtest#Quit()
