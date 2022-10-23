
def qualify_by_address(
        self, cr, uid, ids, context=None,
        params_to_check=frozenset(QUALIF_BY_ADDRESS_PARAM)):
    """ This gets called by the web server """


def qualify_by_address(self, cr, uid, ids, context=None,
                       params_to_check=frozenset(QUALIF_BY_ADDRESS_PARAM)):
    """ This gets called by the web server """


_ipv4_re = re.compile('^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
                      '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
                      '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
                      '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')


fct("""
    AAA """ + status_2_string)


if context:
    msg = """\
action: GET-CONFIG
payload:
    ip_address: "%(ip)s"
    username: "%(username)s"
""" % context


if context:
    msg = """\
action: \
GET-CONFIG
""" % context


if context:
    #: E122+2:0
    msg = """\
action: """\
"""GET-CONFIG
""" % context


def unicode2html(s):
    """Convert the characters &<>'" in string s to HTML-safe sequences.
    Convert newline to <br> too."""
    #: E127+1:28
    return unicode((s or '').replace('&', '&amp;')
                            .replace('\n', '<br>\n'))


parser.add_option('--count', action='store_true',
                  help="print total number of errors and warnings "
                       "to standard error and set exit code to 1 if "
                       "total is not null")

parser.add_option('--exclude', metavar='patterns', default=DEFAULT_EXCLUDE,
                  help="exclude files or directories which match these "
                       "comma separated patterns (default: %s)" %
                       DEFAULT_EXCLUDE)

add_option('--count',
           #: E135+1
           help="print total number of errors "
           "to standard error total is not null")

add_option('--count',
           #: E135+2:11
           help="print total number of errors "
                "to standard error "
           "total is not null")


help = ("print total number of errors " +
        "to standard error")

help = "print total number of errors " \
       "to standard error"

help = u"print total number of errors " \
       u"to standard error"

help = b"print total number of errors " \
       b"to standard error"

#: E122+1:5
help = br"print total number of errors " \
     br"to standard error"

d = dict('foo', help="exclude files or directories which match these "
                     #: E135:9
         "comma separated patterns (default: %s)" % DEFAULT_EXCLUDE)

d = dict('foo', help=u"exclude files or directories which match these "
                     u"comma separated patterns (default: %s)"
                     % DEFAULT_EXCLUDE)

#: E135+1:9 E135+2:9
d = dict('foo', help=b"exclude files or directories which match these "
         b"comma separated patterns (default: %s)"
         % DEFAULT_EXCLUDE)

d = dict('foo', help=br"exclude files or directories which match these "
                     br"comma separated patterns (default: %s)" %
                     DEFAULT_EXCLUDE)

d = dict('foo',
         help="exclude files or directories which match these "
              "comma separated patterns (default: %s)" %
              DEFAULT_EXCLUDE)

d = dict('foo',
         help="exclude files or directories which match these "
              "comma separated patterns (default: %s, %s)" %
              (DEFAULT_EXCLUDE, DEFAULT_IGNORE)
         )

d = dict('foo',
         help="exclude files or directories which match these "
              "comma separated patterns (default: %s, %s)" %
              # who knows what might happen here?
              (DEFAULT_EXCLUDE, DEFAULT_IGNORE)
         )

# parens used to allow the indenting.
troublefree_hash = {
    "hash": "value",
    "long": ("the quick brown fox jumps over the lazy dog before doing a "
             "somersault"),
    "long key that tends to happen more when you're indented": (
        "stringwithalongtoken you don't want to break"
    ),
}

# another accepted form
troublefree_hash = {
    "hash": "value",
    "long": "the quick brown fox jumps over the lazy dog before doing "
            "a somersault",
    ("long key that tends to happen more "
     "when you're indented"): "stringwithalongtoken you don't want to break",
}
# confusing but accepted... don't do that
troublesome_hash = {
    "hash": "value",
    "long": "the quick brown fox jumps over the lazy dog before doing a "
            #: E135:4
    "somersault",
    "longer":
        "the quick brown fox jumps over the lazy dog before doing a "
        "somersaulty",
    "long key that tends to happen more "
    "when you're indented": "stringwithalongtoken you don't want to break",
}

d = dict('foo',
         help="exclude files or directories which match these "
              "comma separated patterns (default: %s)" %
              DEFAULT_EXCLUDE
         )
d = dict('foo',
         help="exclude files or directories which match these "
              "comma separated patterns (default: %s)" % DEFAULT_EXCLUDE,
         foobar="this clearly should work, because it is at "
                "the right indent level",
         )

rv.update(dict.fromkeys(
              ('qualif_nr', 'reasonComment_en', 'reasonComment_fr',
               'reasonComment_de', 'reasonComment_it'),
              '?'), "foo",
          context={'alpha': 4, 'beta': 53242234, 'gamma': 17})


def f():
    try:
        if not Debug:
            hello('''
If you would like to see debugging output,
try: %s -d5
''' % sys.argv[0])


# The try statement above was not finished.
#: E901
d = {  # comment
    1: 2
}

# issue 138 (we won't allow this in parso)
#: E126+2:9
[
    12,  # this is a multi-line inline
         # comment
]
# issue 151
#: E122+1:3
if a > b and \
   c > d:
    moo_like_a_cow()

my_list = [
    1, 2, 3,
    4, 5, 6,
]

my_list = [1, 2, 3,
           4, 5, 6,
           ]

result = some_function_that_takes_arguments(
    'a', 'b', 'c',
    'd', 'e', 'f',
)

result = some_function_that_takes_arguments('a', 'b', 'c',
                                            'd', 'e', 'f',
                                            )

# issue 203
dica = {
    ('abc'
     'def'): (
        'abc'),
}

(abcdef[0]
 [1]) = (
    'abc')

('abc'
 'def') == (
    'abc')

# issue 214
bar(
    1).zap(
    2)

bar(
    1).zap(
    2)

if True:

    def example_issue254():
        return [node.copy(
                    (
                        replacement
                        # First, look at all the node's current children.
                        for child in node.children
                        # Replace them.
                        for replacement in replace(child)
                    ),
                    dict(name=token.undefined)
                )]


def valid_example():
    return [node.copy(properties=dict(
                          (key, val if val is not None else token.undefined)
                          for key, val in node.items()
                      ))]


foo([
    'bug'
])

# issue 144, finally!
some_hash = {
    "long key that tends to happen more when you're indented":
        "stringwithalongtoken you don't want to break",
}

{
    1:
        999999 if True
        else 0,
}


abc = dedent(
    '''
        mkdir -p ./{build}/
        mv ./build/ ./{build}/%(revision)s/
    '''.format(
        build='build',
        # more stuff
    )
)
