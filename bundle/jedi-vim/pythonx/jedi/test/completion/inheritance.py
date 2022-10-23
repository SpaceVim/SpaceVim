
class Super(object):
    attribute = 3

    def func(self):
        return 1

    class Inner():
        pass


class Sub(Super):
    #? 13 Sub.attribute
    def attribute(self):
        pass

    #! 8 ['attribute = 3']
    def attribute(self):
        pass

    #! 4 ['def func']
    func = 3
    #! 12 ['def func']
    class func(): pass

    #! 8 ['class Inner']
    def Inner(self): pass

# -----------------
# Finding self
# -----------------

class Test1:
    class Test2:
        def __init__(self):
            self.foo_nested = 0
            #? ['foo_nested']
            self.foo_
            #?
            self.foo_here

    def __init__(self, self2):
        self.foo_here = 3
        #? ['foo_here', 'foo_in_func']
        self.foo_
        #? int()
        self.foo_here
        #?
        self.foo_nested
        #?
        self.foo_not_on_self
        #? float()
        self.foo_in_func
        self2.foo_on_second = ''

        def closure():
            self.foo_in_func = 4.

    def bar(self):
        self = 3
        self.foo_not_on_self = 3


class SubTest(Test1):
    def __init__(self):
        self.foo_sub_class = list

    def bar(self):
        #? ['foo_here', 'foo_in_func', 'foo_sub_class']
        self.foo_
        #? int()
        self.foo_here
        #?
        self.foo_nested
        #?
        self.foo_not_on_self
