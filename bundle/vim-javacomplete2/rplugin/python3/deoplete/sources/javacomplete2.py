import pynvim
from deoplete.base.source import Base

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'javacomplete2'
        self.mark = '[jc]'
        self.filetypes = ['java', 'jsp']
        self.is_bytepos = True
        self.input_pattern = '[^. \t0-9]\.\w*'
        self.rank = 500
        self.max_pattern_length = -1
        self.matchers = ['matcher_full_fuzzy']

    def get_complete_position(self, context):
        return self.vim.call('javacomplete#complete#complete#Complete',
                             1, '', 0)

    def gather_candidates(self, context):
        try:
            return self.vim.call('javacomplete#complete#complete#Complete',
                                 0, context['complete_str'], 0)
        except pynvim.api.common.NvimError as er:
            print(er)
            raise er
