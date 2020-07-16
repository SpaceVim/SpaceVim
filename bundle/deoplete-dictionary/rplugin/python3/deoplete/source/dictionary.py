# ============================================================================
# FILE: dictionary.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from os import scandir
from os.path import getmtime, exists, isdir
from collections import namedtuple

from deoplete.base.source import Base
from deoplete.util import expand

DictCacheItem = namedtuple('DictCacheItem', 'mtime candidates')


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'dictionary'
        self.mark = '[D]'
        self.events = ['InsertEnter']

        self._cache = {}

    def on_event(self, context):
        self._make_cache(context)

    def gather_candidates(self, context):
        if not self._cache:
            self._make_cache(context)

        candidates = []
        for filename in [x for x in self._get_dictionaries(context)
                         if x in self._cache]:
            candidates.append(self._cache[filename].candidates)
        return {'sorted_candidates': candidates}

    def _make_cache(self, context):
        for filename in self._get_dictionaries(context):
            mtime = getmtime(filename)
            if filename in self._cache and self._cache[
                    filename].mtime == mtime:
                continue
            with open(filename, 'r', errors='replace') as f:
                self._cache[filename] = DictCacheItem(
                    mtime, [{'word': x} for x in sorted(
                        (x.strip() for x in f), key=str.lower)]
                )

    def _get_dictionaries(self, context):
        dict_opt = self.get_buf_option('dictionary')
        if not dict_opt:
            return []

        dicts = []
        for d in [expand(x) for x in dict_opt.split(',') if exists(x)]:
            if isdir(d):
                with scandir(d) as it:
                    dicts += [x.path for x in it if x.is_file()]
            else:
                dicts.append(d)
        return dicts
