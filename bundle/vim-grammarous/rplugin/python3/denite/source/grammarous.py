from .base import Base


class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'grammarous'
        self.kind = 'file'

    def on_init(self, context):
        context['__path'] = self.vim.current.buffer.name

    def convert(self, item, context):
        """convert one item from the search result to a candidate"""

        word = "'{0}' -> {1}".format(
            item['context'][int(item['contextoffset']):(
                int(item['contextoffset']) + int(item['errorlength'])
            )], item['msg']
        )

        return {
            'word': word,
            'action__path': context['__path'],
            'action__line': int(item['fromy']) + 1,
            'action__col': int(item['fromx']) + 1
        }

    def gather_candidates(self, context):
        try:
            result = self.vim.eval('b:grammarous_result')
        except Exception as e:
            result = []

        return [self.convert(item, context) for item in result]

    def define_syntax(self):
        self.vim.command(
            """syntax match deniteSource_grammarous /\\v^.*$/"""
        )
        self.vim.command(
            """syntax region deniteSource__GrammarousError start="'" """
            """end="'" oneline contained containedin=deniteSource_grammarous"""
        )
        self.vim.command(
            """syntax match deniteSource__GrammarousArrow "->" """
            """contained containedin=deniteSource_grammarous"""
        )

    def highlight(self):
        self.vim.command(
            'highlight default link deniteSource__GrammarousArrow Keyword'
        )
        self.vim.command(
            'highlight default link deniteSource__GrammarousError ErrorMsg'
        )
