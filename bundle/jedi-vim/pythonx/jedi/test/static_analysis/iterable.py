
a, b = {'asdf': 3, 'b': 'str'}
a

x = [1]
x[0], b = {'a': 1, 'b': '2'}

dct = {3: ''}
for x in dct:
    pass

#! 4 type-error-not-iterable
for x, y in dct:
    pass

# Shouldn't cause issues, because if there are no types (or we don't know what
# the types are, we should just ignore it.
#! 0 value-error-too-few-values
a, b = []
#! 7 name-error
a, b = NOT_DEFINED
