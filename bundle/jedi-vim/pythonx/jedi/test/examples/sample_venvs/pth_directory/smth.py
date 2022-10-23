import sys
sys.path.append('/foo/smth.py:module')


def extend_path_foo():
    sys.path.append('/foo/smth.py:from_func')
