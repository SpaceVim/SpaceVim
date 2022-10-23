import pytest
from textwrap import dedent

from parso import load_grammar, ParserSyntaxError
from parso.python.tokenize import tokenize


@pytest.fixture
def grammar():
    return load_grammar(version='3.8')


@pytest.mark.parametrize(
    'code', [
        # simple cases
        'f"{1}"',
        'f"""{1}"""',
        'f"{foo} {bar}"',

        # empty string
        'f""',
        'f""""""',

        # empty format specifier is okay
        'f"{1:}"',

        # use of conversion options
        'f"{1!a}"',
        'f"{1!a:1}"',

        # format specifiers
        'f"{1:1}"',
        'f"{1:1.{32}}"',
        'f"{1::>4}"',
        'f"{x:{y}}"',
        'f"{x:{y:}}"',
        'f"{x:{y:1}}"',

        # Escapes
        'f"{{}}"',
        'f"{{{1}}}"',
        'f"{{{1}"',
        'f"1{{2{{3"',
        'f"}}"',

        # New Python 3.8 syntax f'{a=}'
        'f"{a=}"',
        'f"{a()=}"',

        # multiline f-string
        'f"""abc\ndef"""',
        'f"""abc{\n123}def"""',

        # a line continuation inside of an fstring_string
        'f"abc\\\ndef"',
        'f"\\\n{123}\\\n"',

        # a line continuation inside of an fstring_expr
        'f"{\\\n123}"',

        # a line continuation inside of an format spec
        'f"{123:.2\\\nf}"',

        # some unparenthesized syntactic structures
        'f"{*x,}"',
        'f"{*x, *y}"',
        'f"{x, *y}"',
        'f"{*x, y}"',
        'f"{x for x in [1]}"',

        # named unicode characters
        'f"\\N{BULLET}"',
        'f"\\N{FLEUR-DE-LIS}"',
        'f"\\N{NO ENTRY}"',
        'f"Combo {expr} and \\N{NO ENTRY}"',
        'f"\\N{NO ENTRY} and {expr}"',
        'f"\\N{no entry}"',
        'f"\\N{SOYOMBO LETTER -A}"',
        'f"\\N{DOMINO TILE HORIZONTAL-00-00}"',
        'f"""\\N{NO ENTRY}"""',
    ]
)
def test_valid(code, grammar):
    module = grammar.parse(code, error_recovery=False)
    fstring = module.children[0]
    assert fstring.type == 'fstring'
    assert fstring.get_code() == code


@pytest.mark.parametrize(
    'code', [
        # an f-string can't contain unmatched curly braces
        'f"}"',
        'f"{"',
        'f"""}"""',
        'f"""{"""',

        # invalid conversion characters
        'f"{1!{a}}"',
        'f"{1=!{a}}"',
        'f"{!{a}}"',

        # The curly braces must contain an expression
        'f"{}"',
        'f"{:}"',
        'f"{:}}}"',
        'f"{:1}"',
        'f"{!:}"',
        'f"{!}"',
        'f"{!a}"',

        # invalid (empty) format specifiers
        'f"{1:{}}"',
        'f"{1:{:}}"',

        # a newline without a line continuation inside a single-line string
        'f"abc\ndef"',

        # various named unicode escapes that aren't name-shaped
        'f"\\N{ BULLET }"',
        'f"\\N{NO   ENTRY}"',
        'f"""\\N{NO\nENTRY}"""',
    ]
)
def test_invalid(code, grammar):
    with pytest.raises(ParserSyntaxError):
        grammar.parse(code, error_recovery=False)

    # It should work with error recovery.
    grammar.parse(code, error_recovery=True)


@pytest.mark.parametrize(
    ('code', 'positions'), [
        # 2 times 2, 5 because python expr and endmarker.
        ('f"}{"', [(1, 0), (1, 2), (1, 3), (1, 4), (1, 5)]),
        ('f" :{ 1 : } "', [(1, 0), (1, 2), (1, 4), (1, 6), (1, 8), (1, 9),
                           (1, 10), (1, 11), (1, 12), (1, 13)]),
        ('f"""\n {\nfoo\n }"""', [(1, 0), (1, 4), (2, 1), (3, 0), (4, 1),
                                  (4, 2), (4, 5)]),
        ('f"\\N{NO ENTRY} and {expr}"', [(1, 0), (1, 2), (1, 19), (1, 20),
                                         (1, 24), (1, 25), (1, 26)]),
    ]
)
def test_tokenize_start_pos(code, positions):
    tokens = list(tokenize(code, version_info=(3, 6)))
    assert positions == [p.start_pos for p in tokens]


@pytest.mark.parametrize(
    'code', [
        dedent("""\
            f'''s{
               str.uppe
            '''
            """),
        'f"foo',
        'f"""foo',
        'f"abc\ndef"',
    ]
)
def test_roundtrip(grammar, code):
    tree = grammar.parse(code)
    assert tree.get_code() == code
