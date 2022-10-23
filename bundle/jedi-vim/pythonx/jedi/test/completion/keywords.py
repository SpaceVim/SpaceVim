
#? ['raise']
raise

#? ['Exception']
except

#? []
b + continu

#? []
b + continue

#? ['continue']
b; continue

#? ['continue']
b; continu

#? []
c + pass

#? []
a + pass

#? ['pass']
b; pass

# -----------------
# Keywords should not appear everywhere.
# -----------------

#? []
with open() as f
#? []
def i
#? []
class i

#? []
continue i

# More syntax details, e.g. while only after newline, but not after semicolon,
# continue also after semicolon
#? ['while']
while
#? []
x while
#? []
x; while
#? ['continue']
x; continue

#? []
and
#? ['and']
x and
#? []
x * and
