def marks(code):
    if '.' in code:
        another(code[:code.index(',') - 1] + '!')
    else:
        another(code + '.')


def another(code2):
    call(numbers(code2 + 'haha'))

marks('start1 ')
marks('start2 ')


def alphabet(code4):
    if 1:
        if 2:
            return code4 + 'a'
        else:
            return code4 + 'b'
    else:
        if 2:
            return code4 + 'c'
        else:
            return code4 + 'd'


def numbers(code5):
    if 2:
        return alphabet(code5 + '1')
    else:
        return alphabet(code5 + '2')


def call(code3):
    code3 = numbers(numbers('end')) + numbers(code3)
    code3.partition
