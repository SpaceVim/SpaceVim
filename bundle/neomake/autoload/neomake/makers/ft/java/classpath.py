import os
from xml.etree.ElementTree import *


def ReadClasspathFile(fn):
    cp = []
    for a in parse(fn).findall('classpathentry'):
        kind = a.get('kind')
        if kind == 'src' and 'output' in a.keys():
            cp.append(os.path.abspath(a.get('output')))
        elif kind == 'lib' and 'path' in a.keys():
            cp.append(os.path.abspath(a.get('path')))
        elif kind == 'output' and 'path' in a.keys():
            cp.append(os.path.abspath(a.get('path')))
    return cp
