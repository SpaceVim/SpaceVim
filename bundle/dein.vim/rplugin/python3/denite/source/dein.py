# ============================================================================
# FILE: dein.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from .base import Base
import re
import os


URL_PATTERN = re.compile('^(https?|git)://(github.com/)?')
REF_PATTERN = re.compile('^ref: (refs/heads/(.*))$')


class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'dein'
        self.kind = 'directory'
        self.default_action = 'cd'

    def gather_candidates(self, context):
        return [
            _build_candidate(plugin_context)
            for plugin_context in self.vim.eval('values(dein#get())')
        ]


def _build_candidate(plugin_context):
    name = URL_PATTERN.sub('', plugin_context['repo'])
    path = plugin_context['path']
    # Find git revision
    try:
        revision, branch = _resolve_ref(os.path.join(path, '.git'), 'HEAD')
    except Exception:
        # Fail silently
        revision = ''
        branch = None
    rev = revision if branch is None else '%s (%s)' % (branch, revision[:7])
    return {
        'word': name.strip(),
        'abbr': name.strip() if not rev else '%s -- %s' % (name.strip(), rev.strip()),
        'action__path': path,
    }


def _resolve_ref(git, ref, branch=None):
    with open(os.path.join(git, ref)) as fi:
        content = fi.readline()
    m = REF_PATTERN.match(content)
    if not m:
        return (content, branch)
    return _resolve_ref(git, m.group(1), m.group(2))
