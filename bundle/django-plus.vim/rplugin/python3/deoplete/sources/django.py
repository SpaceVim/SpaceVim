import re

from .base import Base


_high_priority_re = re.compile(
    r'(?:'
    r'(?:\.objects\.\w*)|'
    r'(?:\bsettings\.\w*)|'
    r'(?:\{%\s+(?:include|extends)\s+["\'][\w/]+)|'
    r'(?:(?:render\([^,]+,|get_template\(|render_to_string\(|render_to_response\(|template_name\s*=)\s*["\'][\w/]*)'
    r')$'
)


class Source(Base):
    def __init__(self, vim):
        super(Source, self).__init__(vim)
        self.name = 'django'
        self.mark = ''
        self.filetypes = ['python', 'htmldjango']
        self.input_pattern = '.\.\w*$|\|\w*$|\{%\s+\w*$'

    def get_complete_position(self, context):
        self.rank = 10
        line = context.get('input')
        if line and _high_priority_re.search(line):
            self.rank = 9000
        return self.vim.call('djangoplus#complete', 1, '')

    def gather_candidates(self, context):
        candidates = self.vim.call('djangoplus#complete', 0,
                                   context['complete_str'])
        return candidates
