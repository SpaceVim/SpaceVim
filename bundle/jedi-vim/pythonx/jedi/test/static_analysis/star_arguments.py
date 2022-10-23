# -----------------
# *args
# -----------------


def simple(a):
    return a


def nested(*args):
    return simple(*args)

nested(1)
#! 6 type-error-too-few-arguments
nested()


def nested_no_call_to_function(*args):
    return simple(1, *args)


def simple2(a, b, c):
    return b
def nested(*args):
    return simple2(1, *args)
def nested_twice(*args1):
    return nested(*args1)

nested_twice(2, 3)
#! 13 type-error-too-few-arguments
nested_twice(2)
#! 19 type-error-too-many-arguments
nested_twice(2, 3, 4)


# A named argument can be located before *args.
def star_args_with_named(*args):
    return simple2(c='', *args)

star_args_with_named(1, 2)
# -----------------
# **kwargs
# -----------------


def kwargs_test(**kwargs):
    return simple2(1, **kwargs)

kwargs_test(c=3, b=2)
#! 12 type-error-too-few-arguments
kwargs_test(c=3)
#! 12 type-error-too-few-arguments
kwargs_test(b=2)
#! 22 type-error-keyword-argument
kwargs_test(b=2, c=3, d=4)
#! 12 type-error-multiple-values
kwargs_test(b=2, c=3, a=4)


def kwargs_nested(**kwargs):
    return kwargs_test(b=2, **kwargs)

kwargs_nested(c=3)
#! 13 type-error-too-few-arguments
kwargs_nested()
#! 19 type-error-keyword-argument
kwargs_nested(c=2, d=4)
#! 14 type-error-multiple-values
kwargs_nested(c=2, a=4)
# TODO reenable
##! 14 type-error-multiple-values
#kwargs_nested(b=3, c=2)

# -----------------
# mixed *args/**kwargs
# -----------------

def simple_mixed(a, b, c):
    return b

def mixed(*args, **kwargs):
    return simple_mixed(1, *args, **kwargs)

mixed(1, 2)
mixed(1, c=2)
mixed(b=2, c=3)
mixed(c=4, b='')

# need separate functions, otherwise these might swallow the errors
def mixed2(*args, **kwargs):
    return simple_mixed(1, *args, **kwargs)


#! 7 type-error-too-few-arguments
mixed2(c=2)
#! 7 type-error-too-few-arguments
mixed2(3)
#! 13 type-error-too-many-arguments
mixed2(3, 4, 5)
# TODO reenable
##! 13 type-error-too-many-arguments
#mixed2(3, 4, c=5)
#! 7 type-error-multiple-values
mixed2(3, b=5)

# -----------------
# plain wrong arguments
# -----------------

#! 12 type-error-star-star
simple(1, **[])
#! 12 type-error-star-star
simple(1, **1)
class A(): pass
#! 12 type-error-star-star
simple(1, **A())

#! 11 type-error-star
simple(1, *1)
