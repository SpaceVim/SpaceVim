call vimtest#StartTap()
call vimtap#Plan(1) " <== XXX  Keep plan number updated.  XXX

call vrs#set('vrs#test', 'test', 'abc')

call vimtap#Ok(!vrs#set('vrs#test', 'test', 'cde'), 'Prevent duplicated entries.')

call vimtest#Quit()

