call vimtest#StartTap()
call vimtap#Plan(2) " <== XXX  Keep plan number updated.  XXX

let an_ip4              = '192.168.1.1'
let not_an_ip4          = '999.168.1.1'

call vimtap#Is(vrs#matches(an_ip4            , 'ip4'   ), 1, 'ip4')
call vimtap#Is(vrs#matches(not_an_ip4        , 'ip4'   ), 0, 'not an ip4')

call vimtest#Quit()
