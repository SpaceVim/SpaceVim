""" Test docstrings in functions and classes, which are used to infer types """

# -----------------
# sphinx style
# -----------------
def sphinxy(a, b, c, d, x):
    """ asdfasdf
    :param a: blablabla
    :type a: str
    :type b: (str, int)
    :type c: random.Random
    :type d: :class:`random.Random`
    :param str x: blablabla
    :rtype: dict
    """
    #? str()
    a
    #? str()
    b[0]
    #? int()
    b[1]
    #? ['seed']
    c.seed
    #? ['seed']
    d.seed
    #? ['lower']
    x.lower

#? dict()
sphinxy()

# wrong declarations
def sphinxy2(a, b, x, y, z):
    """
    :param a: Forgot type declaration
    :type a:
    :param b: Just something
    :type b: ``
    :param x: Just something without type
    :param y: A function
    :type y: def l(): pass
    :param z: A keyword
    :type z: return
    :rtype:
    """
    #? 
    a
    #? 
    b
    #?
    x
    #?
    y
    #?
    z

#? 
sphinxy2()


def sphinxy_param_type_wrapped(a):
    """
    :param str a:
        Some description wrapped onto the next line with no space after the
        colon.
    """
    #? str()
    a


# local classes -> github #370
class ProgramNode():
    pass

def local_classes(node, node2):
    """
    :type node: ProgramNode
    ... and the class definition after this func definition:
    :type node2: ProgramNode2
    """
    #? ProgramNode()
    node
    #? ProgramNode2()
    node2

class ProgramNode2():
    pass


def list_with_non_imports(lst):
    """
    Should be able to work with tuples and lists and still import stuff.

    :type lst: (random.Random, [collections.defaultdict, ...])
    """
    #? ['seed']
    lst[0].seed

    import collections as col
    # use some weird index
    #? col.defaultdict()
    lst[1][10]


def two_dots(a):
    """
    :type a: json.decoder.JSONDecoder
    """
    #? ['raw_decode']
    a.raw_decode


# sphinx returns
def return_module_object():
    """
    :rtype: :class:`random.Random`
    """

#? ['seed']
return_module_object().seed


# -----------------
# epydoc style
# -----------------
def epydoc(a, b):
    """ asdfasdf
    @type a: str
    @param a: blablabla
    @type b: (str, int)
    @param b: blablah
    @rtype: list
    """
    #? str()
    a
    #? str()
    b[0]

    #? int()
    b[1]

#? list()
epydoc()


# Returns with param type only
def rparam(a,b):
    """
    @type a: str
    """
    return a

#? str()
rparam()


# Composite types
def composite():
    """
    @rtype: (str, int, dict)
    """

x, y, z = composite()
#? str()
x
#? int()
y
#? dict()
z


# Both docstring and calculated return type
def both():
    """
    @rtype: str
    """
    return 23

#? str() int()
both()

class Test(object):
    def __init__(self):
        self.teststr = ""
    """
    # jedi issue #210
    """
    def test(self):
        #? ['teststr']
        self.teststr

# -----------------
# statement docstrings
# -----------------
d = ''
""" bsdf """
#? str()
d.upper()

# -----------------
# class docstrings
# -----------------

class InInit():
    def __init__(self, foo):
        """
        :type foo: str
        """
        #? str()
        foo


class InClass():
    """
    :type foo: str
    """
    def __init__(self, foo):
        #? str()
        foo


class InBoth():
    """
    :type foo: str
    """
    def __init__(self, foo):
        """
        :type foo: int
        """
        #? str() int()
        foo


def __init__(foo):
    """
    :type foo: str
    """
    #? str()
    foo


# -----------------
# Renamed imports (#507)
# -----------------

import datetime
from datetime import datetime as datetime_imported

def import_issues(foo):
    """
    @type foo: datetime_imported
    """
    #? datetime.datetime()
    foo


# -----------------
# Doctest completions
# -----------------

def doctest_with_gt():
    """
    x

    >>> somewhere_in_docstring = 3
    #? ['import_issues']
    >>> import_issu
    #? ['somewhere_in_docstring']
    >>> somewhere_

    blabla

        >>> haha = 3
        #? ['haha']
        >>> hah
        #? ['doctest_with_space']
        >>> doctest_with_sp
    """

def doctest_with_space():
    """
    x
        #? ['import_issues']
        import_issu
    """

def doctest_issue_github_1748():
    """From GitHub #1748
    #? 10 []
    This. Al
    """
    pass


def docstring_rst_identifiers():
    """
    #? 30 ['import_issues']
    hello I'm here `import_iss` blabla

    #? ['import_issues']
    hello I'm here `import_iss

    #? []
    hello I'm here import_iss
    #? []
    hello I'm here ` import_iss

    #? ['upper']
    hello I'm here `str.upp
    """


def doctest_without_ending():
    """
    #? []
    import_issu
    ha

        no_ending = False
        #? ['import_issues']
        import_issu
        #? ['no_ending']
        no_endin
