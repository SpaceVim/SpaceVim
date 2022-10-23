if True:
    result = some_function_that_takes_arguments(
        'a', 'b', 'c',
        'd', 'e', 'f',
        #: E123:0
)
#: E122+1
if some_very_very_very_long_variable_name or var \
or another_very_long_variable_name:
    raise Exception()
#: E122+1
if some_very_very_very_long_variable_name or var[0] \
or another_very_long_variable_name:
    raise Exception()
if True:
    #: E122+1
    if some_very_very_very_long_variable_name or var \
    or another_very_long_variable_name:
        raise Exception()
if True:
    #: E122+1
    if some_very_very_very_long_variable_name or var[0] \
    or another_very_long_variable_name:
        raise Exception()

#: E901+1:8
dictionary = [
    "is": {
        # Might be a E122:4, but is not because the code is invalid Python.
    "nested": yes(),
    },
]
setup('',
      scripts=[''],
      classifiers=[
          #: E121:6
      'Development Status :: 4 - Beta',
          'Environment :: Console',
          'Intended Audience :: Developers',
      ])


#: E123+2:4 E291:15
abc = "E123", (   
    "bad", "hanging", "close"
    )

result = {
    'foo': [
        'bar', {
            'baz': 'frop',
            #: E123
            }
        #: E123
        ]
    #: E123
    }
result = some_function_that_takes_arguments(
    'a', 'b', 'c',
    'd', 'e', 'f',
    #: E123
    )
my_list = [1, 2, 3,
           4, 5, 6,
           #: E124:0
]
my_list = [1, 2, 3,
           4, 5, 6,
           #: E124:19
                   ]
#: E124+2
result = some_function_that_takes_arguments('a', 'b', 'c',
                                            'd', 'e', 'f',
)
fooff(aaaa,
      cca(
          vvv,
          dadd
      ), fff,
      #: E124:0
)
fooff(aaaa,
      ccaaa(
          vvv,
          dadd
      ),
      fff,
      #: E124:0
)
d = dict('foo',
         help="exclude files or directories which match these "
              "comma separated patterns (default: %s)" % DEFAULT_EXCLUDE
         #: E124:14
              )

if line_removed:
    self.event(cr, uid,
               #: E128:8
        name="Removing the option for contract",
               #: E128:8
        description="contract line has been removed",
               #: E124:8
        )

#: E129+1:4
if foo is None and bar is "frop" and \
    blah == 'yeah':
    blah = 'yeahnah'


#: E129+1:4 E129+2:4
def long_function_name(
    var_one, var_two, var_three,
    var_four):
    hello(var_one)


def qualify_by_address(
        #: E129:4 E129+1:4
    self, cr, uid, ids, context=None,
    params_to_check=frozenset(QUALIF_BY_ADDRESS_PARAM)):
    """ This gets called by the web server """


#: E129+1:4 E129+2:4
if (a == 2 or
    b == "abc def ghi"
    "jkl mno"):
    True

my_list = [
    1, 2, 3,
    4, 5, 6,
    #: E123:8
        ]

abris = 3 + \
        4 + \
        5 + 6

fixed = re.sub(r'\t+', ' ', target[c::-1], 1)[::-1] + \
        target[c + 1:]

rv.update(dict.fromkeys((
              'qualif_nr', 'reasonComment_en', 'reasonComment_fr',
              #: E121:12
            'reasonComment_de', 'reasonComment_it'),
                        '?'),
          #: E128:4
    "foo")
#: E126+1:8
eat_a_dict_a_day({
        "foo": "bar",
})
#: E129+1:4
if (
    x == (
            3
            #: E129:4
    ) or
        y == 4):
    pass
#: E129+1:4 E121+2:8 E129+3:4
if (
    x == (
        3
    ) or
        x == (
            # This one has correct indentation.
            3
            #: E129:4
    ) or
        y == 4):
    pass
troublesome_hash = {
    "hash": "value",
    #: E135+1:8
    "long": "the quick brown fox jumps over the lazy dog before doing a "
        "somersault",
}

# Arguments on first line forbidden when not using vertical alignment
#: E128+1:4
foo = long_function_name(var_one, var_two,
    var_three, var_four)

#: E128+1:4
hello('l.%s\t%s\t%s\t%r' %
    (token[2][0], pos, tokenize.tok_name[token[0]], token[1]))


def qualify_by_address(self, cr, uid, ids, context=None,
                       #: E128:8
        params_to_check=frozenset(QUALIF_BY_ADDRESS_PARAM)):
    """ This gets called by the web server """
