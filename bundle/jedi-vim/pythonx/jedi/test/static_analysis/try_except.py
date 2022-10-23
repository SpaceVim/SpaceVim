try:
    #! 4 attribute-error
    str.not_existing
except TypeError:
    pass

try:
    str.not_existing
except AttributeError:
    #! 4 attribute-error
    str.not_existing
    pass

try:
    import not_existing_import
except ImportError:
    pass
try:
    #! 7 import-error
    import not_existing_import2
except AttributeError:
    pass

# -----------------
# multi except
# -----------------
try:
    str.not_existing
except (TypeError, AttributeError): pass

try:
    str.not_existing
except ImportError:
    pass
except (NotImplementedError, AttributeError): pass

try:
    #! 4 attribute-error
    str.not_existing
except (TypeError, NotImplementedError): pass

# -----------------
# detailed except
# -----------------
try:
    str.not_existing
except ((AttributeError)): pass
try:
    #! 4 attribute-error
    str.not_existing
except [AttributeError]: pass

# Should be able to detect errors in except statement as well.
try:
    pass
#! 7 name-error
except Undefined:
    pass

# -----------------
# inheritance
# -----------------

try:
    undefined
except Exception:
    pass

# should catch everything
try:
    undefined
except:
    pass

# -----------------
# kind of similar: hasattr
# -----------------

if hasattr(str, 'undefined'):
    str.undefined
    str.upper
    #! 4 attribute-error
    str.undefined2
    #! 4 attribute-error
    int.undefined
else:
    str.upper
    #! 4 attribute-error
    str.undefined

# -----------------
# arguments
# -----------------

def i_see(r):
    return r

def lala():
    # This weird structure checks if the error is actually resolved in the
    # right place.
    a = TypeError
    try:
        i_see()
    except a:
        pass
    #! 5 type-error-too-few-arguments
    i_see()
