call vimtest#StartTap()
call vimtap#Plan(8 + 13 + 7 + 7 + 7 + 7) " <== XXX  Keep plan number updated.  XXX

" hundredths      vim   \<\%(\d\|[1-9]\d\)\>
" z_hundredths    vim   \<\d\{2}\>
" thousandths     vim   \<\%(\%{hundredths}\|[1-9]\d\d\)\>
" z_thousandths   vim   \<\d\{3}\>

call vimtap#Is(vrs#exactly('0',     'natural'),        1,  'natural - int')
call vimtap#Is(vrs#exactly('1',     'natural'),        1,  'natural - int')
call vimtap#Is(vrs#exactly('99',    'natural'),        1,  'natural - int')
call vimtap#Is(vrs#exactly('123',   'natural'),        1,  'natural - int')
call vimtap#Is(vrs#exactly('+1',    'natural'),        1,  'natural + posint')
call vimtap#Is(vrs#exactly('-1',    'natural'),        0,  'natural - negint')
call vimtap#Is(vrs#exactly('',      'natural'),        0,  'natural - empty')
call vimtap#Is(vrs#exactly('a',     'natural'),        0,  'natural - char')

call vimtap#Is(vrs#exactly('0',     'integer'),        1,  'integer + int')
call vimtap#Is(vrs#exactly('1',     'integer'),        1,  'integer + int')
call vimtap#Is(vrs#exactly('99',    'integer'),        1,  'integer + int')
call vimtap#Is(vrs#exactly('123',   'integer'),        1,  'integer + int')
call vimtap#Is(vrs#exactly('-1',    'integer'),        1,  'integer + negint')
call vimtap#Is(vrs#exactly('-99',   'integer'),        1,  'integer + negint')
call vimtap#Is(vrs#exactly('-123',  'integer'),        1,  'integer + negint')
call vimtap#Is(vrs#exactly('+1',    'integer'),        1,  'integer + posint')
call vimtap#Is(vrs#exactly('+99',   'integer'),        1,  'integer + posint')
call vimtap#Is(vrs#exactly('+123',  'integer'),        1,  'integer + posint')
call vimtap#Is(vrs#exactly('',      'integer'),        0,  'integer - empty')
call vimtap#Is(vrs#exactly('a',     'integer'),        0,  'integer - char')
call vimtap#Is(vrs#exactly('1.0',   'integer'),        0,  'integer - float')

call vimtap#Is(vrs#exactly('0',     'hundredths'),     1,  'hundredths - int 0')
call vimtap#Is(vrs#exactly('1',     'hundredths'),     1,  'hundredths - int 1')
call vimtap#Is(vrs#exactly('22',    'hundredths'),     1,  'hundredths - int 22')
call vimtap#Is(vrs#exactly('99',    'hundredths'),     1,  'hundredths - upperbound int 99')
call vimtap#Is(vrs#exactly('100',   'hundredths'),     0,  'hundredths - overbounds')
call vimtap#Is(vrs#exactly('',      'hundredths'),     0,  'hundredths - empty')
call vimtap#Is(vrs#exactly('a',     'hundredths'),     0,  'hundredths - char')

call vimtap#Is(vrs#exactly('00',    'z_hundredths'),   1,  'z_hundredths - int 00')
call vimtap#Is(vrs#exactly('01',    'z_hundredths'),   1,  'z_hundredths - int 01')
call vimtap#Is(vrs#exactly('22',    'z_hundredths'),   1,  'z_hundredths - int 22')
call vimtap#Is(vrs#exactly('99',    'z_hundredths'),   1,  'z_hundredths - upperbound int 99')
call vimtap#Is(vrs#exactly('100',   'z_hundredths'),   0,  'z_hundredths - overbounds')
call vimtap#Is(vrs#exactly('',      'z_hundredths'),   0,  'z_hundredths - empty')
call vimtap#Is(vrs#exactly('a',     'z_hundredths'),   0,  'z_hundredths - char')

call vimtap#Is(vrs#exactly('0',     'thousandths'),    1,  'thousandths - int 0')
call vimtap#Is(vrs#exactly('333',   'thousandths'),    1,  'thousandths - int 333')
call vimtap#Is(vrs#exactly('999',   'thousandths'),    1,  'thousandths - upperbound int 999')
call vimtap#Is(vrs#exactly('1',     'thousandths'),    1,  'thousandths - int 1')
call vimtap#Is(vrs#exactly('1000',  'thousandths'),    0,  'thousandths - overbounds')
call vimtap#Is(vrs#exactly('',      'thousandths'),    0,  'thousandths - empty')
call vimtap#Is(vrs#exactly('a',     'thousandths'),    0,  'thousandths - char')

call vimtap#Is(vrs#exactly('000',   'z_thousandths'),  1,  'z_thousandths - int 000')
call vimtap#Is(vrs#exactly('333',   'z_thousandths'),  1,  'z_thousandths - int 333')
call vimtap#Is(vrs#exactly('999',   'z_thousandths'),  1,  'z_thousandths - upperbound int 999')
call vimtap#Is(vrs#exactly('001',   'z_thousandths'),  1,  'z_thousandths - int 001')
call vimtap#Is(vrs#exactly('1000',  'z_thousandths'),  0,  'z_thousandths - overbounds')
call vimtap#Is(vrs#exactly('',      'z_thousandths'),  0,  'z_thousandths - empty')
call vimtap#Is(vrs#exactly('a',     'z_thousandths'),  0,  'z_thousandths - char')

call vimtest#Quit()
