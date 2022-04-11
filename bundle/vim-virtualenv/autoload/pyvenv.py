import vim, os, sys

prev_syspath = None

activate_content = """
try:
    __file__
except NameError:
    raise AssertionError(
        "You must run this like execfile('path/to/activate_this.py', dict(__file__='path/to/activate_this.py'))")
import sys
import os

old_os_path = os.environ['PATH']
os.environ['PATH'] = os.path.dirname(os.path.abspath(__file__)) + os.pathsep + old_os_path
base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if sys.platform == 'win32':
    site_packages = os.path.join(base, 'Lib', 'site-packages')
else:
    version = '%s.%s' % (sys.version_info.major, sys.version_info.minor)
    site_packages = os.path.join(base, 'lib', 'python%s' % version, 'site-packages')
prev_sys_path = list(sys.path)
import site
site.addsitedir(site_packages)
sys.real_prefix = sys.prefix
sys.prefix = base
# Move the added items to the front of the path:
new_sys_path = []
for item in list(sys.path):
    if item not in prev_sys_path:
        new_sys_path.append(item)
        sys.path.remove(item)
sys.path[:0] = new_sys_path
"""

def activate(env):
    global prev_syspath
    prev_syspath = list(sys.path)
    activate = os.path.join(env, (sys.platform == 'win32') and 'Scripts' or 'bin', 'activate_this.py')
    try:
        fo = open(activate)
        f = fo.read()
        fo.close()
    except:
        f = activate_content

    code = compile(f, activate, 'exec')
    exec(code, dict(__file__=activate))


def deactivate():
    global prev_syspath
    try:
        sys.path[:] = prev_syspath
        prev_syspath = None
    except:
        pass
