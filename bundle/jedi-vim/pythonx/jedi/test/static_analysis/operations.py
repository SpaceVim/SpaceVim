-1 + 1
1 + 1.0
#! 2 type-error-operation
1 + '1'
#! 2 type-error-operation
1 - '1'

-1 - - 1
# TODO uncomment
#-1 - int()
#int() - float()
float() - 3.0

a = 3
b = ''
#! 2 type-error-operation
a + b
