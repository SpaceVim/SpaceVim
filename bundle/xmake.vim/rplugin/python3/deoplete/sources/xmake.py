
from .base import Base
import re, os
import glob

PATH, _ = os.path.split(__file__)

apis = []
for docpath in glob.glob(PATH + '/docs/*'):
    path, name = os.path.split(docpath)
    f = open(docpath, 'rb')
    apis.append({'word': name, 'info': f.read().decode('utf-8')})
    f.close()

os.aaa = apis

_ = {
    'os':            'Current OS of compiling-system',
    'host':          'Current OS of localhost',
    'tmpdir':        'Temporary directory',
    'curdir':        'Current directory',
    'buildir':       'Build directory',
    'scriptdir':     'Script dictionary',
    'globaldir':     'Global-config directory',
    'configdir':     'Local-config directory',
    'programdir':    'Program directory',
    'projectdir':    'Project directory',
    'shell':         'Extern shell',
    'env':           'Get environment variable',
    'reg':           'Get windows register value'
}
builtin_vars = [{'word': k, 'menu': v} for k, v in _.items()]


class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.vim = vim
        self.name = 'xmake'
        self.mark = '[xmake]'
        self.filetypes = ['lua']
        self.input_pattern = r'\w+$|\$\($'

    def get_complete_position(self, context):
        input = context['input']
        word = re.search(r'\w+$', input)
        if word:
            return word.start()
        else:
            return len(input)

    def gather_candidates(self, context):
        global apis, builtin_vars

        if re.search('\$\(\w*$', context['input'][:context['complete_position']]):
            return builtin_vars
        else:
            return apis
