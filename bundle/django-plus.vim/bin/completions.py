"""Print completions

- @@ prefix is a completion group.
- ## prefix is a completion word.
- All other lines are documentation.
"""
import os
import re
import sys
import inspect

from glob import glob

try:
    import django
except ImportError:
    sys.exit(0)

if django and '_DJANGOPLUS_MANAGEMENT' in os.environ:
    script = os.getenv('_DJANGOPLUS_MANAGEMENT')
    base = os.path.abspath(os.path.dirname(script))
    settings_module = ''

    with open(script) as fp:
        m = re.search(r'(["\'])DJANGO_SETTINGS_MODULE\1,\s+(["\'])([^\2]+?)\2', fp.read())
        if m:
            settings_module = m.group(3)
        os.environ['DJANGO_SETTINGS_MODULE'] = settings_module

    if settings_module:
        os.chdir(base)
        orig_path = sys.path[:]
        if base not in sys.path:
            sys.path.insert(0, base)

        try:
            django.setup()
        except:
            pass
        path_components = [base] + settings_module.split('.')[:-1] + ['*.py']
        settings = glob(os.path.join(*path_components))
    else:
        settings = []

    from django.apps import apps

else:
    django.setup = lambda: False

    from django.apps.registry import apps

    apps.apps_ready = True
    settings = []

from django.conf import global_settings
from django.core.exceptions import ImproperlyConfigured, AppRegistryNotReady
from django.db.models.query import QuerySet

print('@@apppaths')
try:
    for app_config in apps.get_app_configs():
        print('##%s' % app_config.path)
except AppRegistryNotReady:
    pass

try:
    from django.conf import settings as djsettings
    tpldirs = set(getattr(djsettings, 'TEMPLATE_DIRS', []))
    if not isinstance(tpldirs, set):
        tpldirs = set()

    for tplconf in getattr(djsettings, 'TEMPLATES', []):
        if 'DIRS' in tplconf:
            tpldirs.update(tplconf['DIRS'])

    for tpldir in tpldirs:
        print('##tpl|%s' % tpldir)
except:
    pass

try:
    from django.template import library
    from django.template.backends import django as tplbackend

    def import_library(module):
        return library.import_library(module)

    def get_installed_libraries():
        for module in tplbackend.get_installed_libraries().values():
            try:
                yield library.import_library(module)
            except (ImproperlyConfigured, library.InvalidTemplateLibrary):
                continue

except ImportError:
    from pkgutil import walk_packages

    from django.template import base as tplbase

    def import_library(module):
        return tplbase.import_library(module)

    def get_installed_libraries():
        for module in tplbase.get_templatetags_modules():
            try:
                pkg = tplbase.import_module(module)
            except:
                pass

            for entry in walk_packages(pkg.__path__, pkg.__name__ + '.'):
                try:
                    module = tplbase.import_module(entry[1])
                    if hasattr(module, 'register'):
                        yield module.register
                except (ImproperlyConfigured, ImportError):
                    pass


def func_signature(obj):
    if hasattr(inspect, 'signature'):
        return '%s%s' % (obj.__name__, str(inspect.signature(obj)))
    else:
        return '%s%s' % (obj.__name__,
                         inspect.formatargspec(*inspect.getargspec(obj)))

completions = {
    'settings': [],
    'queryset': [],
}

filename = global_settings.__file__
base, ext = os.path.splitext(filename)
if ext == '.pyc':
    filename = base + '.py'

settings.insert(0, filename)

seen_settings = set()
seen_tags = set()
seen_filters = set()


def print_tags(tags):
    if not tags:
        return

    print('@@htmldjangotags')
    for tagname, tagfunc in tags.items():
        if tagname in seen_tags:
            continue
        seen_tags.add(tagname)
        print('##{%% %s %%}' % tagname)
        print((inspect.getdoc(tagfunc) or '').replace('\n', '\\n'))


def print_filters(filters):
    if not filters:
        return
    print('@@htmldjangofilters')
    for filtername, filterfunc in filters.items():
        if filtername in seen_filters:
            continue
        seen_filters.add(filtername)
        print('##|%s' % filtername)
        print((inspect.getdoc(filterfunc) or '').replace('\n', '\\n'))


print('@@settings')
for filename in settings:
    with open(filename, 'rt') as fp:
        for doc, var in re.findall('^((?:\s*# .+\n)*)?\s*([0-9A-Z_]+) =',
                                   fp.read(), re.M):
            if var in seen_settings:
                continue
            seen_settings.add(var)
            print('##' + var)
            print('\\n'.join(x.strip('# ') for x
                             in doc.split('\n')).strip())

print('@@queryset')
for item in dir(QuerySet):
    if item.startswith('__'):
        continue
    obj = getattr(QuerySet, item)
    if hasattr(obj, '__call__'):
        print('##' + func_signature(obj))
        print((inspect.getdoc(obj) or '').replace('\n', '\\n'))
    else:
        print('##' + item)


print_tags(import_library('django.template.defaulttags').tags)
print_filters(import_library('django.template.defaultfilters').filters)


try:
    for lib in get_installed_libraries():
        print_tags(lib.tags)
        print_filters(lib.filters)
except AppRegistryNotReady:
    pass

# Make sure the completion parser finishes
print('##')
