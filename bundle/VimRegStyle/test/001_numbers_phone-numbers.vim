call vimtest#StartTap()
call vimtap#Plan(4) " <== XXX  Keep plan number updated.  XXX

let a_phone_number = '1-234-567-0987:1234'
let not_a_phone_number_1 = ''
let not_a_phone_number_2 = 'x'
let not_a_phone_number_3 = '1234'

call vimtap#Is(vrs#matches(a_phone_number, 'phone_number'), 1, 'valid telephone matches')
call vimtap#Is(vrs#matches(not_a_phone_number_1, 'phone_number'), 0, 'invalid telephone 1 does not match')
call vimtap#Is(vrs#matches(not_a_phone_number_2, 'phone_number'), 0, 'invalid telephone 2 does not match')
call vimtap#Is(vrs#matches(not_a_phone_number_3, 'phone_number'), 0, 'invalid telephone 3 does not match')

call vimtest#Quit()
