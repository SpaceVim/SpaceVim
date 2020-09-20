call vimtest#StartTap()
call vimtap#Plan(2) " <== XXX  Keep plan number updated.  XXX

" use default lookup function (which simply accesses vim variables)
let erex = ExtendedRegexObject()

let x = 'a'
let t = '\<\%{g:x,4,.}\>'
let t_expanded = '\<a\.a\.a\.a\>'

call vimtap#Is(erex.expand_composition_atom(t), t_expanded, 'expand vim global variable (expand_composition_atom)')
call vimtap#Is(erex.parse(t), t_expanded, 'expand vim global variable (parse)')

call vimtest#Quit()
