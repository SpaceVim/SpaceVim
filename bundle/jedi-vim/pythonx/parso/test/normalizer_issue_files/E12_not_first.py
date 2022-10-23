# The issue numbers described in this file are part of the pycodestyle tracker
# and not of parso.
# Originally there were no issues in here, I (dave) added the ones that were
# necessary and IMO useful.
if (
        x == (
            3
        ) or
        y == 4):
    pass

y = x == 2 \
    or x == 3

#: E129+1:4
if x == 2 \
    or y > 1 \
        or x == 3:
    pass

if x == 2 \
        or y > 1 \
        or x == 3:
    pass


if (foo == bar and
        baz == frop):
    pass

#: E129+1:4 E129+2:4 E123+3
if (
    foo == bar and
    baz == frop
):
    pass

if (
        foo == bar and
        baz == frop
        #: E129:4 
    ):
    pass

a = (
)

a = (123,
     )


if start[1] > end_col and not (
        over_indent == 4 and indent_next):
    assert (0, "E121 continuation line over-"
            "indented for visual indent")


abc = "OK", ("visual",
             "indent")

abc = "Okay", ("visual",
               "indent_three"
               )

abc = "a-ok", (
    "there",
    "dude",
)

abc = "hello", (
    "there",
    "dude")

abc = "hello", (

    "there",
    # "john",
    "dude")

abc = "hello", (
    "there", "dude")

abc = "hello", (
    "there", "dude",
)

# Aligned with opening delimiter
foo = long_function_name(var_one, var_two,
                         var_three, var_four)

# Extra indentation is not necessary.
foo = long_function_name(
    var_one, var_two,
    var_three, var_four)


arm = 'AAA'    \
      'BBB'    \
      'CCC'

bbb = 'AAA'    \
      'BBB'    \
      'CCC'

cc = ('AAA'
      'BBB'
      'CCC')

cc = {'text': 'AAA'
              'BBB'
              'CCC'}

cc = dict(text='AAA'
               'BBB')

sat = 'AAA'    \
      'BBB'    \
      'iii'    \
      'CCC'

abricot = (3 +
           4 +
           5 + 6)

#: E122+1:4
abricot = 3 + \
    4 + \
          5 + 6

part = [-1, 2, 3,
        4, 5, 6]

#: E128+1:8
part = [-1, (2, 3,
        4, 5, 6), 7,
        8, 9, 0]

fnct(1, 2, 3,
     4, 5, 6)

fnct(1, 2, 3,
     4, 5, 6,
     7, 8, 9,
     10, 11)


def long_function_name(
        var_one, var_two, var_three,
        var_four):
    hello(var_one)


if ((row < 0 or self.moduleCount <= row or
     col < 0 or self.moduleCount <= col)):
    raise Exception("%s,%s - %s" % (row, col, self.moduleCount))


result = {
    'foo': [
        'bar', {
            'baz': 'frop',
        }
    ]
}


foo = my.func({
    "foo": "bar",
}, "baz")


fooff(aaaa,
      cca(
          vvv,
          dadd
      ), fff,
      ggg)

fooff(aaaa,
      abbb,
      cca(
          vvv,
          aaa,
          dadd),
      "visual indentation is not a multiple of four",)

if bar:
    assert (
        start, 'E121 lines starting with a '
        'closing bracket should be indented '
        "to match that of the opening "
        "bracket's line"
    )

# you want vertical alignment, so use a parens
if ((foo.bar("baz") and
     foo.bar("frop")
     )):
    hello("yes")

# also ok, but starting to look like LISP
if ((foo.bar("baz") and
     foo.bar("frop"))):
    hello("yes")

#: E129+1:4 E127+2:9
if (a == 2 or
    b == "abc def ghi"
         "jkl mno"):
    assert True

#: E129+1:4
if (a == 2 or
    b == """abc def ghi
jkl mno"""):
    assert True

if length > options.max_line_length:
    assert options.max_line_length, \
        "E501 line too long (%d characters)" % length


# blub


asd = 'l.{line}\t{pos}\t{name}\t{text}'.format(
    line=token[2][0],
    pos=pos,
    name=tokenize.tok_name[token[0]],
    text=repr(token[1]),
)

#: E121+1:6 E121+2:6
hello('%-7d %s per second (%d total)' % (
      options.counters[key] / elapsed, key,
      options.counters[key]))


if os.path.exists(os.path.join(path, PEP8_BIN)):
    cmd = ([os.path.join(path, PEP8_BIN)] +
           self._pep8_options(targetfile))


fixed = (re.sub(r'\t+', ' ', target[c::-1], 1)[::-1] +
         target[c + 1:])

fixed = (
    re.sub(r'\t+', ' ', target[c::-1], 1)[::-1] +
    target[c + 1:]
)


if foo is None and bar is "frop" and \
        blah == 'yeah':
    blah = 'yeahnah'


"""This is a multi-line
   docstring."""


if blah:
    # is this actually readable?  :)
    multiline_literal = """
while True:
    if True:
        1
""".lstrip()
    multiline_literal = (
        """
while True:
    if True:
        1
""".lstrip()
    )
    multiline_literal = (
        """
while True:
    if True:
        1
"""
        .lstrip()
    )


if blah:
    multiline_visual = ("""
while True:
    if True:
        1
"""
                        .lstrip())


rv = {'aaa': 42}
rv.update(dict.fromkeys((
              #: E121:4 E121+1:4
    'qualif_nr', 'reasonComment_en', 'reasonComment_fr',
    'reasonComment_de', 'reasonComment_it'), '?'))

rv.update(dict.fromkeys(('qualif_nr', 'reasonComment_en',
                         'reasonComment_fr', 'reasonComment_de',
                         'reasonComment_it'), '?'))

#: E128+1:10
rv.update(dict.fromkeys(('qualif_nr', 'reasonComment_en', 'reasonComment_fr',
          'reasonComment_de', 'reasonComment_it'), '?'))


rv.update(dict.fromkeys(
              ('qualif_nr', 'reasonComment_en', 'reasonComment_fr',
               'reasonComment_de', 'reasonComment_it'), '?'
          ), "foo", context={
              'alpha': 4, 'beta': 53242234, 'gamma': 17,
          })


rv.update(
    dict.fromkeys((
        'qualif_nr', 'reasonComment_en', 'reasonComment_fr',
        'reasonComment_de', 'reasonComment_it'), '?'),
    "foo",
    context={
        'alpha': 4, 'beta': 53242234, 'gamma': 17,
    },
)


event_obj.write(cursor, user_id, {
                    'user': user,
                    'summary': text,
                    'data': data,
                })

event_obj.write(cursor, user_id, {
                    'user': user,
                    'summary': text,
                    'data': {'aaa': 1, 'bbb': 2},
                })

event_obj.write(cursor, user_id, {
                    'user': user,
                    'summary': text,
                    'data': {
                        'aaa': 1,
                        'bbb': 2},
                })

event_obj.write(cursor, user_id, {
                    'user': user,
                    'summary': text,
                    'data': {'timestamp': now, 'content': {
                                 'aaa': 1,
                                 'bbb': 2
                             }},
                })
