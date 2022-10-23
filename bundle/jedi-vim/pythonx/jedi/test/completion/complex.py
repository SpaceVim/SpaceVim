""" Mostly for stupid error reports of @dbrgn. :-) """

import time

class Foo(object):
    global time
    asdf = time

def asdfy():
    return Foo

xorz = getattr(asdfy()(), 'asdf')
#? time
xorz



def args_returner(*args):
    return args


#? tuple()
args_returner(1)[:]
#? int()
args_returner(1)[:][0]


def kwargs_returner(**kwargs):
    return kwargs


# TODO This is not really correct, needs correction probably at some point, but
#      at least it doesn't raise an error.
#? int()
kwargs_returner(a=1)[:]
#?
kwargs_returner(b=1)[:][0]
