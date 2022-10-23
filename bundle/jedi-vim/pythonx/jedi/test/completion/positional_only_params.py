# python >= 3.8

def positional_only_call(a, /, b):
    #? str()
    a
    #? int()
    b
    if UNDEFINED:
        return a
    else:
        return b


#? int() str()
positional_only_call('', 1)


def positional_only_call2(a, /, b=3):
    if UNDEFINED:
        return a
    else:
        return b

#? int()
positional_only_call2(1)
#? int()
positional_only_call2(SOMETHING_UNDEFINED)
#? str()
positional_only_call2(SOMETHING_UNDEFINED, '')

# Maybe change this? Because it's actually not correct
#? int() str()
positional_only_call2(a=1, b='')
#? tuple str()
positional_only_call2(b='', a=tuple)
