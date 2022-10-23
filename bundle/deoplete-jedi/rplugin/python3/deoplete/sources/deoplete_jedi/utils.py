import os
import re
import sys


def file_mtime(filename):
    """Get file modification time

    Return 0 if the file does not exist
    """
    if not os.path.exists(filename):
        return 0
    return int(os.path.getmtime(filename))


def module_file(dirname, suffix, base):
    """Find a script that matches the suffix path."""
    search = os.path.abspath(os.path.join(dirname, suffix))
    # dirname = os.path.dirname(dirname)
    found = ''
    while True:
        p = os.path.join(search, '__init__.py')
        if os.path.isfile(p):
            found = p
            break
        p = search + '.py'
        if os.path.isfile(p):
            found = p
            break
        if os.path.basename(search) == base or search == dirname:
            break
        search = os.path.dirname(search)
    return found


def module_search(module, paths):
    """Search paths for a file matching the module."""
    if not module:
        return ''

    base = re.sub(r'\.+', '.', module).strip('.').split('.')[0]
    module_path = os.path.normpath(re.sub(r'(\.+)', r'/\1/', module).strip('/'))
    for p in paths:
        found = module_file(p, module_path, base)
        if found:
            return found
    return ''


def rplugin_runtime_paths(context):
    """Adds Neovim runtime paths.

    Additional paths are added only if a `rplugin/python*` exists.
    """
    paths = []

    if context and 'cwd' in context:
        cwd = context.get('cwd')
        rplugins = ('rplugin/python{}'.format(sys.version_info[0]),
                    'rplugin/pythonx')

        paths.extend(filter(os.path.exists,
                            (os.path.join(cwd, x)
                             for x in rplugins)))

        if paths:
            for rtp in context.get('runtimepath', '').split(','):
                if not rtp:
                    continue
                paths.extend(filter(os.path.exists,
                                    (os.path.join(rtp, x)
                                     for x in rplugins)))
    return paths


def jedi_walk(completions, depth=0, max_depth=5):
    """Walk through Jedi objects

    The purpose for this is to help find an object with a specific name.  Once
    found, the walking will stop.
    """
    for c in completions:
        yield c
        if hasattr(c, 'description') and c.type == 'import':
            d = c.description
            if d.startswith('from ') and d.endswith('*') and depth < max_depth:
                # Haven't determined the lowest Python 3 version required.
                # If we determine 3.3, we can use `yield from`
                for sub in jedi_walk(c.defined_names(), depth + 1, max_depth):
                    yield sub
