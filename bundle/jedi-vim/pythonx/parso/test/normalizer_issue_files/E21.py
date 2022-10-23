#: E211:4
spam (1)
#: E211:4 E211:19
dict ['key'] = list [index]
#: E211:11
dict['key'] ['subkey'] = list[index]
# Okay
spam(1)
dict['key'] = list[index]


# This is not prohibited by PEP8, but avoid it.
# Dave: I think this is extremely stupid. Use the same convention everywhere.
#: E211:9
class Foo (Bar, Baz):
    pass
