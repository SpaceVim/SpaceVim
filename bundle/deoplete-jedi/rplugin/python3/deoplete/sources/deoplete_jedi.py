import copy
import logging
import os
import re
from importlib.util import find_spec

from deoplete.base.source import Base
from deoplete.util import bytepos2charpos, getlines, load_external_module

load_external_module(__file__, 'sources')

from deoplete_jedi import profiler  # isort:skip  # noqa: E402

# Type mapping.  Empty values will use the key value instead.
# Keep them 5 characters max to minimize required space to display.
_types = {
    'import': 'imprt',
    'class': '',
    'function': 'def',
    'globalstmt': 'var',
    'instance': 'var',
    'statement': 'var',
    'keyword': 'keywd',
    'module': 'mod',
    'param': 'arg',
    'property': 'prop',
    'bool': '',
    'bytes': 'byte',
    'complex': 'cmplx',
    'dict': '',
    'list': '',
    'float': '',
    'int': '',
    'object': 'obj',
    'set': '',
    'slice': '',
    'str': '',
    'tuple': '',
    'mappingproxy': 'dict',  # cls.__dict__
    'member_descriptor': 'cattr',
    'getset_descriptor': 'cprop',
    'method_descriptor': 'cdef',
}


def sort_key(item):
    w = item.get('name')
    z = len(w) - len(w.lstrip('_'))
    return (('z' * z) + w.lower()[z:], len(w))


class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'jedi'
        self.mark = '[jedi]'
        self.rank = 500
        self.filetypes = ['python', 'cython', 'pyrex']
        self.input_pattern = (r'[\w\)\]\}\'\"]+\.\w*$|'
                              r'^\s*@\w*$|'
                              r'^\s*from\s+[\w\.]*(?:\s+import\s+(?:\w*(?:,\s*)?)*)?|'
                              r'^\s*import\s+(?:[\w\.]*(?:,\s*)?)*')

        self._async_keys = set()
        self.workers_started = False
        self._jedi = None

    def on_init(self, context):
        vars = context['vars']

        self.statement_length = 50
        if 'deoplete#sources#jedi#statement_length' in vars:
            self.statement_length = vars[
                'deoplete#sources#jedi#statement_length']
        self.enable_typeinfo = True
        if 'deoplete#sources#jedi#enable_typeinfo' in vars:
            self.enable_typeinfo = vars[
                'deoplete#sources#jedi#enable_typeinfo']
        self.enable_short_types = False
        if 'deoplete#sources#jedi#enable_short_types' in vars:
            self.enable_short_types = vars[
                'deoplete#sources#jedi#enable_short_types']
        self.short_types_map = copy.copy(_types)
        if 'deoplete#sources#jedi#short_types_map' in vars:
            self.short_types_map.update(vars[
                'deoplete#sources#jedi#short_types_map'])
        self.show_docstring = False
        if 'deoplete#sources#jedi#show_docstring' in vars:
            self.show_docstring = vars[
                'deoplete#sources#jedi#show_docstring']
        self.ignore_errors = False
        if 'deoplete#sources#jedi#ignore_errors' in vars:
            self.ignore_errors = vars[
                'deoplete#sources#jedi#ignore_errors']
        self.ignore_private_members = False
        if 'deoplete#sources#jedi#ignore_private_members' in vars:
            self.ignore_private_members = vars[
                'deoplete#sources#jedi#ignore_private_members']
        # TODO(blueyed)
        self.extra_path = ''
        if 'deoplete#sources#jedi#extra_path' in vars:
            self.extra_path = vars[
                'deoplete#sources#jedi#extra_path']

        if not self.is_debug_enabled:
            root_log = logging.getLogger('deoplete')
            child_log = root_log.getChild('jedi')
            child_log.propagate = False

        self._python_path = None
        """Current Python executable."""

        self._env = None
        """Current Jedi Environment."""

        self._envs = {}
        """Cache for Jedi Environments."""

        if find_spec('jedi'):
            import jedi  # noqa: E402
            self._jedi = jedi
        else:
            self.print_error(
                'jedi module is not found.  You need to install it.')

    @profiler.profile
    def set_env(self, python_path):
        if not python_path:
            import shutil
            python_path = shutil.which('python')
            self._python_path = python_path

        try:
            self._env = self._envs[python_path]
        except KeyError:
            self._env = self._jedi.api.environment.Environment(
                python_path, env_vars={'PYTHONPATH': str(self.extra_path)})
            self.debug('Using Jedi environment: %r', self._env)

    @profiler.profile
    def get_script(self, source, filename, environment):
        return self._jedi.Script(code=source, path=filename, environment=self._env)

    @profiler.profile
    def get_completions(self, script, line, col):
        return script.complete(line, col)

    @profiler.profile
    def finalize_completions(self, completions):
        out = []
        tmp_filecache = {}
        for c in completions:
            out.append(self.parse_completion(c, tmp_filecache))

        if self.ignore_private_members:
            out = [x for x in out if not x['name'].startswith('__')]

        # partly from old finalized_cached
        out = [self.finalize(x) for x in sorted(out, key=sort_key)]

        return out

    @profiler.profile
    def gather_candidates(self, context):
        if not self._jedi:
            return []

        python_path = None
        if 'deoplete#sources#jedi#python_path' in context['vars']:
            python_path = context['vars'][
                'deoplete#sources#jedi#python_path']
        if python_path != self._python_path or self.extra_path:
            self.set_env(python_path)

        line = context['position'][1]
        col = bytepos2charpos(
            context['encoding'], context['input'],
            context['complete_position'])
        buf = self.vim.current.buffer
        filename = str(buf.name)

        # Only use source if buffer is modified, to skip transferring, joining,
        # and splitting the buffer lines unnecessarily.
        modified = buf.options['modified']
        if not modified and os.path.exists(filename):
            source = None
        else:
            source = '\n'.join(getlines(self.vim))

        if (line != self.vim.call('line', '.')
                or context['complete_position'] >= self.vim.call('col', '$')):
            return []

        self.debug('Line: %r, Col: %r, Filename: %r, modified: %r',
                   line, col, filename, modified)

        script = self.get_script(source, filename, environment=self._env)

        try:
            completions = self.get_completions(script, line, col)
        except BaseException:
            if not self.ignore_errors:
                raise
            return []

        return self.finalize_completions(completions)

    def get_complete_position(self, context):
        if not self._jedi:
            return -1

        pattern = r'\w*$'
        if context['input'].lstrip().startswith(('from ', 'import ')):
            m = re.search(r'[,\s]$', context['input'])
            if m:
                return m.end()
        m = re.search(pattern, context['input'])
        return m.start() if m else -1

    def mix_boilerplate(self, completions):
        seen = set()
        for item in self.boilerplate + completions:
            if item['name'] in seen:
                continue
            seen.add(item['name'])
            yield item

    def finalize(self, item):
        abbr = item['name']
        desc = item['doc']

        if item['params']:
            sig = '{}({})'.format(item['name'], ', '.join(item['params']))
            sig_len = len(sig)

            desc = sig + '\n\n' + desc

            if self.statement_length > 0 and sig_len > self.statement_length:
                params = []
                length = len(item['name']) + 2

                for p in item['params']:
                    p = p.split('=', 1)[0]
                    length += len(p)
                    params.append(p)

                length += 2 * (len(params) - 1)

                # +5 for the ellipsis and separator
                while length + 5 > self.statement_length and len(params):
                    length -= len(params[-1]) + 2
                    params = params[:-1]

                if len(item['params']) > len(params):
                    params.append('...')

                sig = '{}({})'.format(item['name'], ', '.join(params))

            abbr = sig

        if self.enable_short_types:
            kind = item['short_type'] or item['type']
        else:
            kind = item['type']

        return {
            'word': item['name'],
            'abbr': abbr,
            'kind': kind,
            'info': desc.strip(),
            'dup': 1,
        }

    def completion_dict(self, name, type_, comp):
        """Final construction of the completion dict."""

        doc = ''
        if self.show_docstring:
            try:
                doc = comp.docstring()
            except BaseException:
                if not self.ignore_errors:
                    raise
            i = doc.find('\n\n')
            if i != -1:
                doc = doc[i:]

        params = None
        try:
            if type_ in ('function', 'class'):
                params = []
                for i, p in enumerate(comp.params):
                    desc = p.description.strip()
                    if i == 0 and desc == 'self':
                        continue
                    if '\\n' in desc:
                        desc = desc.replace('\\n', '\\x0A')
                    # Note: Hack for jedi param bugs
                    if desc.startswith('param ') or desc == 'param':
                        desc = desc[5:].strip()
                    if desc:
                        params.append(desc)
        except Exception:
            params = None

        return {
            'name': name,
            'type': type_,
            'short_type': self.short_types_map.get(type_),
            'doc': doc.strip(),
            'params': params,
        }

    def parse_completion(self, comp, cache):
        """Return a tuple describing the completion.

        Returns (name, type, description, abbreviated)
        """
        name = comp.name

        if self.enable_typeinfo:
            type_ = comp.type
        else:
            type_ = ''
        if self.show_docstring:
            desc = comp.description
        else:
            desc = ''

        if type_ == 'instance' and desc.startswith(('builtins.', 'posix.')):
            # Simple description
            builtin_type = desc.rsplit('.', 1)[-1]
            if builtin_type in _types:
                return self.completion_dict(name, builtin_type, comp)

        return self.completion_dict(name, type_, comp)
