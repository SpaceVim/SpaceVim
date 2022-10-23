#: E128+1
foo(1, 2, 3,
4, 5, 6)
#: E128+1:1
foo(1, 2, 3,
 4, 5, 6)
#: E128+1:2
foo(1, 2, 3,
  4, 5, 6)
#: E128+1:3
foo(1, 2, 3,
   4, 5, 6)
foo(1, 2, 3,
    4, 5, 6)
#: E127+1:5
foo(1, 2, 3,
     4, 5, 6)
#: E127+1:6
foo(1, 2, 3,
      4, 5, 6)
#: E127+1:7
foo(1, 2, 3,
       4, 5, 6)
#: E127+1:8
foo(1, 2, 3,
        4, 5, 6)
#: E127+1:9
foo(1, 2, 3,
         4, 5, 6)
#: E127+1:10
foo(1, 2, 3,
          4, 5, 6)
#: E127+1:11
foo(1, 2, 3,
           4, 5, 6)
#: E127+1:12
foo(1, 2, 3,
            4, 5, 6)
#: E127+1:13
foo(1, 2, 3,
             4, 5, 6)
if line_removed:
    #: E128+1:14 E128+2:14
    self.event(cr, uid,
              name="Removing the option for contract",
              description="contract line has been removed",
               )

if line_removed:
    self.event(cr, uid,
               #: E127:16
                name="Removing the option for contract",
               #: E127:16
                description="contract line has been removed",
               #: E124:16
                )
rv.update(d=('a', 'b', 'c'),
          #: E127:13
             e=42)

#: E135+2:17
rv.update(d=('a' + 'b', 'c'),
          e=42, f=42
                 + 42)
rv.update(d=('a' + 'b', 'c'),
          e=42, f=42
                  + 42)
#: E127+1:26
input1 = {'a': {'calc': 1 + 2}, 'b': 1
                          + 42}
#: E128+2:17
rv.update(d=('a' + 'b', 'c'),
          e=42, f=(42
                 + 42))

if True:
    def example_issue254():
        #: 
        return [node.copy(
                    (
                        #: E121:16 E121+3:20
                replacement
                        # First, look at all the node's current children.
                        for child in node.children
                    for replacement in replace(child)
                    ),
                    dict(name=token.undefined)
                )]
# TODO multiline docstring are currently not handled. E125+1:4?
if ("""
    """):
    pass

# TODO same
for foo in """
    abc
    123
    """.strip().split():
    hello(foo)
abc = dedent(
    '''
        mkdir -p ./{build}/
        mv ./build/ ./{build}/%(revision)s/
    '''.format(
        #: E121:4 E121+1:4 E123+2:0
    build='build',
    # more stuff
)
)
#: E701+1: E122+1
if True:\
hello(True)

#: E128+1
foobar(a
, end=' ')
