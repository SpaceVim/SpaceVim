class Base():
    myfoobar = 3


class X(Base):
    def func(self, foo):
        pass


class Y(X):
    def actual_function(self):
        pass

    #? []
    def actual_function
    #? ['func']
    def f

    #? ['__doc__']
    __doc__
    #? []
    def __doc__

    # This might or might not be what we wanted, currently properties are also
    # used like this. IMO this is not wanted ~dave.
    #? ['__class__']
    def __class__
    #? []
    __class__


    #? ['__repr__']
    def __repr__

    #? []
    def mro

    #? ['myfoobar']
    myfoobar

#? []
myfoobar

# -----------------
# Inheritance
# -----------------

class Super():
    enabled = True
    if enabled:
        yo_dude = 4

class Sub(Super):
    #? ['yo_dude']
    yo_dud
