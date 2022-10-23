#: E261:4
pass # an inline comment
#: E261:4
pass# an inline comment

# Okay
pass  # an inline comment
pass   # an inline comment
#: E262:11
x = x + 1  #Increment x
#: E262:11
x = x + 1  #  Increment x
#: E262:11
x = y + 1  #:  Increment x
#: E265
#Block comment
a = 1
#: E265+1
m = 42
#! This is important
mx = 42 - 42

# Comment without anything is not an issue.
#
# However if there are comments at the end without anything it obviously
# doesn't make too much sense.
#: E262:9
foo = 1  #


#: E266+2:4 E266+5:4
def how_it_feel(r):

    ### This is a variable ###
    a = 42

    ### Of course it is unused
    return


#: E266 E266+1
##if DEBUG:
##    logging.error()
#: E266
######################################### 

# Not at the beginning of a file
#: E265
#!/usr/bin/env python

# Okay

pass  # an inline comment
x = x + 1   # Increment x
y = y + 1   #: Increment x

# Block comment
a = 1

# Block comment1

# Block comment2
aaa = 1


# example of docstring (not parsed)
def oof():
    """
    #foo not parsed
    """

    ###########################################################################
    #                               A SEPARATOR                               #
    ###########################################################################

    # ####################################################################### #
    # ########################## another separator ########################## #
    # ####################################################################### #
