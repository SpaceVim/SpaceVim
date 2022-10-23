# -*- coding: utf-8 -*-
import sys
from textwrap import dedent


def indent(code):
    lines = code.splitlines(True)
    return ''.join([' ' * 2 + line for line in lines])


def build_nested(code, depth, base='def f():\n'):
    if depth == 0:
        return code

    new_code = base + indent(code)
    return build_nested(new_code, depth - 1, base=base)


FAILING_EXAMPLES = [
    '1 +',
    '?',
    'continue',
    'break',
    'return',
    'yield',

    # SyntaxError from Python/ast.c
    'f(x for x in bar, 1)',
    'from foo import a,',
    'from __future__ import whatever',
    'from __future__ import braces',
    'from .__future__ import whatever',
    'def f(x=3, y): pass',
    'lambda x=3, y: x',
    '__debug__ = 1',
    'with x() as __debug__: pass',

    '[]: int',
    '[a, b]: int',
    '(): int',
    '(()): int',
    '((())): int',
    '{}: int',
    'True: int',
    '(a, b): int',
    '*star,: int',
    'a, b: int = 3',
    'foo(+a=3)',
    'f(lambda: 1=1)',
    'f(x=1, x=2)',
    'f(**x, y)',
    'f(x=2, y)',
    'f(**x, *y)',
    'f(**x, y=3, z)',
    # augassign
    'a, b += 3',
    '(a, b) += 3',
    '[a, b] += 3',
    '[a, 1] += 3',
    'f() += 1',
    'lambda x:None+=1',
    '{} += 1',
    '{a:b} += 1',
    '{1} += 1',
    '{*x} += 1',
    '(x,) += 1',
    '(x, y if a else q) += 1',
    '[] += 1',
    '[1,2] += 1',
    '[] += 1',
    'None += 1',
    '... += 1',
    'a > 1 += 1',
    '"test" += 1',
    '1 += 1',
    '1.0 += 1',
    '(yield) += 1',
    '(yield from x) += 1',
    '(x if x else y) += 1',
    'a() += 1',
    'a + b += 1',
    '+a += 1',
    'a and b += 1',
    '*a += 1',
    'a, b += 1',
    'f"xxx" += 1',
    # All assignment tests
    'lambda a: 1 = 1',
    '[x for x in y] = 1',
    '{x for x in y} = 1',
    '{x:x for x in y} = 1',
    '(x for x in y) = 1',
    'None = 1',
    '... = 1',
    'a == b = 1',
    '{a, b} = 1',
    '{a: b} = 1',
    '1 = 1',
    '"" = 1',
    'b"" = 1',
    'b"" = 1',
    '"" "" = 1',
    '1 | 1 = 3',
    '1**1 = 3',
    '~ 1 = 3',
    'not 1 = 3',
    '1 and 1 = 3',
    'def foo(): (yield 1) = 3',
    'def foo(): x = yield 1 = 3',
    'async def foo(): await x = 3',
    '(a if a else a) = a',
    'a, 1 = x',
    'foo() = 1',
    # Cases without the equals but other assignments.
    'with x as foo(): pass',
    'del bar, 1',
    'for x, 1 in []: pass',
    'for (not 1) in []: pass',
    '[x for 1 in y]',
    '[x for a, 3 in y]',
    '(x for 1 in y)',
    '{x for 1 in y}',
    '{x:x for 1 in y}',
    # Unicode/Bytes issues.
    r'u"\x"',
    r'u"\"',
    r'u"\u"',
    r'u"""\U"""',
    r'u"\Uffffffff"',
    r"u'''\N{}'''",
    r"u'\N{foo}'",
    r'b"\x"',
    r'b"\"',
    'b"ä"',

    '*a, *b = 3, 3',
    'async def foo(): yield from []',
    'yield from []',
    '*a = 3',
    'del *a, b',
    'def x(*): pass',
    '(%s *d) = x' % ('a,' * 256),
    '{**{} for a in [1]}',
    '(True,) = x',
    '([False], a) = x',
    'def x(): from math import *',

    # invalid del statements
    'del x + y',
    'del x(y)',
    'async def foo(): del await x',
    'def foo(): del (yield x)',
    'del [x for x in range(10)]',
    'del *x',
    'del *x,',
    'del (*x,)',
    'del [*x]',
    'del x, *y',
    'del *x.y,',
    'del *x[y],',
    'del *x[y::], z',
    'del x, (y, *z)',
    'del (x, *[y, z])',
    'del [x, *(y, [*z])]',
    'del {}',
    'del {x}',
    'del {x, y}',
    'del {x, *y}',

    # invalid starred expressions
    '*x',
    '(*x)',
    '((*x))',
    '1 + (*x)',
    '*x; 1',
    '1; *x',
    '1\n*x',
    'x = *y',
    'x: int = *y',
    'def foo(): return *x',
    'def foo(): yield *x',
    'f"{*x}"',
    'for *x in 1: pass',
    '[1 for *x in 1]',

    # str/bytes combinations
    '"s" b""',
    '"s" b"" ""',
    'b"" "" b"" ""',
    'f"s" b""',
    'b"s" f""',

    # Parser/tokenize.c
    r'"""',
    r'"',
    r"'''",
    r"'",
    r"\blub",
    # IndentationError: too many levels of indentation
    build_nested('pass', 100),

    # SyntaxErrors from Python/symtable.c
    'def f(x, x): pass',
    'nonlocal a',

    # IndentationError
    ' foo',
    'def x():\n    1\n 2',
    'def x():\n 1\n  2',
    'if 1:\nfoo',
    'if 1: blubb\nif 1:\npass\nTrue and False',

    # f-strings
    'f"{}"',
    r'f"{\}"',
    'f"{\'\\\'}"',
    'f"{#}"',
    "f'{1!b}'",
    "f'{1:{5:{3}}}'",
    "f'{'",
    "f'{'",
    "f'}'",
    "f'{\"}'",
    "f'{\"}'",
    # Now nested parsing
    "f'{continue}'",
    "f'{1;1}'",
    "f'{a;}'",
    "f'{b\"\" \"\"}'",
    # f-string expression part cannot include a backslash
    r'''f"{'\n'}"''',

    'async def foo():\n yield x\n return 1',
    'async def foo():\n yield x\n return 1',

    '[*[] for a in [1]]',
    'async def bla():\n def x():  await bla()',
    'del None',
    'del True',
    'del False',
    'del ...',

    # Errors of global / nonlocal
    dedent('''
        def glob():
            x = 3
            x.z
            global x'''),
    dedent('''
        def glob():
            x = 3
            global x'''),
    dedent('''
        def glob():
            x
            global x'''),
    dedent('''
        def glob():
            x = 3
            x.z
            nonlocal x'''),
    dedent('''
        def glob():
            x = 3
            nonlocal x'''),
    dedent('''
        def glob():
            x
            nonlocal x'''),
    # Annotation issues
    dedent('''
        def glob():
            x[0]: foo
            global x'''),
    dedent('''
        def glob():
            x.a: foo
            global x'''),
    dedent('''
        def glob():
            x: foo
            global x'''),
    dedent('''
        def glob():
            x: foo = 5
            global x'''),
    dedent('''
        def glob():
            x: foo = 5
            x
            global x'''),
    dedent('''
        def glob():
            global x
            x: foo = 3
        '''),
    # global/nonlocal + param
    dedent('''
        def glob(x):
            global x
        '''),
    dedent('''
        def glob(x):
            nonlocal x
        '''),
    dedent('''
        def x():
            a =3
            def z():
                nonlocal a
                a = 3
                nonlocal a
        '''),
    dedent('''
        def x():
            a = 4
            def y():
                global a
                nonlocal a
        '''),
    # Missing binding of nonlocal
    dedent('''
        def x():
            nonlocal a
        '''),
    dedent('''
        def x():
            def y():
                nonlocal a
        '''),
    dedent('''
        def x():
            a = 4
            def y():
                global a
                print(a)
                def z():
                    nonlocal a
        '''),
    # Name is assigned before nonlocal declaration
    dedent('''
        def x(a):
            def y():
                a = 10
                nonlocal a
       '''),
]

if sys.version_info[:2] >= (3, 7):
    # This is somehow ok in previous versions.
    FAILING_EXAMPLES += [
        'class X(base for base in bases): pass',
    ]

if sys.version_info[:2] < (3, 8):
    FAILING_EXAMPLES += [
        # Python/compile.c
        dedent('''\
            for a in [1]:
                try:
                    pass
                finally:
                    continue
            '''),  # 'continue' not supported inside 'finally' clause"
    ]

if sys.version_info[:2] >= (3, 8):
    # assignment expressions from issue#89
    FAILING_EXAMPLES += [
        # Case 2
        '(lambda: x := 1)',
        '((lambda: x) := 1)',
        # Case 3
        '(a[i] := x)',
        '((a[i]) := x)',
        '(a(i) := x)',
        # Case 4
        '(a.b := c)',
        '[(i.i:= 0) for ((i), j) in range(5)]',
        # Case 5
        '[i:= 0 for i, j in range(5)]',
        '[(i:= 0) for ((i), j) in range(5)]',
        '[(i:= 0) for ((i), j), in range(5)]',
        '[(i:= 0) for ((i), j.i), in range(5)]',
        '[[(i:= i) for j in range(5)] for i in range(5)]',
        '[i for i, j in range(5) if True or (i:= 1)]',
        '[False and (i:= 0) for i, j in range(5)]',
        # Case 6
        '[i+1 for i in (i:= range(5))]',
        '[i+1 for i in (j:= range(5))]',
        '[i+1 for i in (lambda: (j:= range(5)))()]',
        # Case 7
        'class Example:\n [(j := i) for i in range(5)]',
        # Not in that issue
        '(await a := x)',
        '((await a) := x)',
        # new discoveries
        '((a, b) := (1, 2))',
        '([a, b] := [1, 2])',
        '({a, b} := {1, 2})',
        '({a: b} := {1: 2})',
        '(a + b := 1)',
        '(True := 1)',
        '(False := 1)',
        '(None := 1)',
        '(__debug__ := 1)',
        # Unparenthesized walrus not allowed in dict literals, dict comprehensions and slices
        '{a:="a": b:=1}',
        '{y:=1: 2 for x in range(5)}',
        'a[b:=0:1:2]',
    ]
    # f-string debugging syntax with invalid conversion character
    FAILING_EXAMPLES += [
        "f'{1=!b}'",
    ]
