#: E501:4
a = '12345678901234567890123456789012345678901234567890123456789012345678901234567890'
#: E501:80
a = '1234567890123456789012345678901234567890123456789012345678901234567890' or \
    6
#: E501+1:80
a = 7 or \
    '1234567890123456789012345678901234567890123456789012345678901234567890' or \
    6
#: E501+1:80 E501+2:80
a = 7 or \
    '1234567890123456789012345678901234567890123456789012345678901234567890' or \
    '1234567890123456789012345678901234567890123456789012345678901234567890' or \
    6
#: E501:78
a = '1234567890123456789012345678901234567890123456789012345678901234567890'  # \
#: E502:78
a = ('123456789012345678901234567890123456789012345678901234567890123456789'  \
     '01234567890')
#: E502+1:11
a = ('AAA  \
      BBB' \
     'CCC')
#: E502:38
if (foo is None and bar is "e000" and \
        blah == 'yeah'):
    blah = 'yeahnah'
#
# Okay
a = ('AAA'
     'BBB')

a = ('AAA  \
      BBB'
     'CCC')

a = 'AAA'    \
    'BBB'    \
    'CCC'

a = ('AAA\
BBBBBBBBB\
CCCCCCCCC\
DDDDDDDDD')
#
# Okay
if aaa:
    pass
elif bbb or \
        ccc:
    pass

ddd = \
    ccc

('\
    ' + ' \
')
('''
    ''' + ' \
')
#: E501:67 E225:21 E225:22
very_long_identifiers=and_terrible_whitespace_habits(are_no_excuse+for_long_lines)
#
# TODO Long multiline strings are not handled. E501?
'''multiline string
with a long long long long long long long long long long long long long long long long line
'''
#: E501
'''same thing, but this time without a terminal newline in the string
long long long long long long long long long long long long long long long long line'''
#
# issue 224 (unavoidable long lines in docstrings)
# Okay
"""
I'm some great documentation.  Because I'm some great documentation, I'm
going to give you a reference to some valuable information about some API
that I'm calling:

    http://msdn.microsoft.com/en-us/library/windows/desktop/aa363858(v=vs.85).aspx
"""
#: E501
"""
longnospaceslongnospaceslongnospaceslongnospaceslongnospaceslongnospaceslongnospaceslongnospaces"""


# Regression test for #622
def foo():
    """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis pulvinar vitae
    """


# Okay
"""
This
                                                                       almost_empty_line
"""

"""
This
                                                                        almost_empty_line
"""
# A basic comment
#: E501
# with a long long long long long long long long long long long long long long long long line

#
# Okay
# I'm some great comment.  Because I'm so great, I'm going to give you a
# reference to some valuable information about some API that I'm calling:
#
#     http://msdn.microsoft.com/en-us/library/windows/desktop/aa363858(v=vs.85).aspx

x = 3

# longnospaceslongnospaceslongnospaceslongnospaceslongnospaceslongnospaceslongnospaceslongnospaces

#
# Okay
# This
#                                                                      almost_empty_line

#
#: E501+1
# This
#                                                                       almost_empty_line
