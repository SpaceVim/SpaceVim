# =============================================================================
# FILE: lsp.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# =============================================================================

import json
import re

from deoplete.source.base import Base


LSP_KINDS = [
    'Text',
    'Method',
    'Function',
    'Constructor',
    'Field',
    'Variable',
    'Class',
    'Interface',
    'Module',
    'Property',
    'Unit',
    'Value',
    'Enum',
    'Keyword',
    'Snippet',
    'Color',
    'File',
    'Reference',
    'Folder',
    'EnumMember',
    'Constant',
    'Struct',
    'Event',
    'Operator',
    'TypeParameter',
]

LSP_KINDS_WITH_ICONS = [
    ' [text]     ',
    ' [method]   ',
    ' [function] ',
    ' [constructor]',
    'ﰠ [field]    ',
    '𝒙 [variable] ',
    ' [class]    ',
    ' [interface]',
    ' [module]   ',
    ' [property] ',
    ' [unit]     ',
    ' [value]    ',
    ' [enum]     ',
    ' [key]      ',
    '﬌ [snippet]  ',
    ' [color]    ',
    ' [file]     ',
    ' [refrence] ',
    ' [folder]   ',
    ' [enumMember]',
    ' [constant] ',
    ' [struct]   ',
    ' [event]    ',
    ' [operator] ',
    ' [typeParameter]',
]


class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'lsp'
        self.mark = '[lsp]'
        self.rank = 500
        self.input_pattern = r'(\.|:|->)$'
        self.is_volatile = True
        self.vars = {}
        self.vim.vars['deoplete#source#lsp#_results'] = []
        self.vim.vars['deoplete#source#lsp#_success'] = False
        self.vim.vars['deoplete#source#lsp#_requested'] = False
        self.vim.vars['deoplete#source#lsp#_prev_input'] = ''
        if 'deoplete#lsp#use_icons_for_candidates' not in self.vim.vars:
            self.vim.vars['deoplete#lsp#use_icons_for_candidates'] = False

        self.lsp_kinds = LSP_KINDS

    def gather_candidates(self, context):
        if not self.vim.call('has', 'nvim-0.5.0'):
            return []

        prev_input = self.vim.vars['deoplete#source#lsp#_prev_input']
        if context['input'] == prev_input and self.vim.vars[
                'deoplete#source#lsp#_requested']:
            return self.process_candidates()

        vars = self.vim.vars
        vars['deoplete#source#lsp#_requested'] = False
        vars['deoplete#source#lsp#_prev_input'] = context['input']
        vars['deoplete#source#lsp#_complete_position'] = context[
            'complete_position']

        # Note: request_candidates() may be failed
        try:
            params = self.vim.call(
                'luaeval',
                'vim.lsp.util.make_position_params()')

            self.vim.call(
                'luaeval', 'require("candidates").request_candidates('
                '_A.arguments)',
                {'arguments': params})
        except Exception:
            pass
        return []

    def process_candidates(self):
        candidates = []
        vars = self.vim.vars
        results = vars['deoplete#source#lsp#_results']

        if not results:
            return
        elif isinstance(results, dict):
            if 'items' not in results:
                self.print_error(
                    'LSP results does not have "items" key:{}'.format(
                        str(results)))
                return
            items = results['items']
        else:
            items = results

        use_icons = vars['deoplete#lsp#use_icons_for_candidates']
        if use_icons:
            self.lsp_kinds = LSP_KINDS_WITH_ICONS

        for rec in items:
            if 'textEdit' in rec and rec['textEdit'] is not None:
                textEdit = rec['textEdit']
                if ('range' in textEdit and textEdit['range']['start'] ==
                        textEdit['range']['end']):
                    previous_input = vars['deoplete#source#lsp#_prev_input']
                    complete_position = vars[
                        'deoplete#source#lsp#_complete_position']
                    new_text = textEdit['newText']
                    word = f'{previous_input[complete_position:]}{new_text}'
                else:
                    word = textEdit['newText']
            elif rec.get('insertText', ''):
                if rec.get('insertTextFormat', 1) != 1:
                    word = rec.get('entryName', rec.get('label'))
                else:
                    word = rec['insertText']
            else:
                word = rec.get('entryName', rec.get('label'))

            # Remove parentheses from word.
            # Note: some LSP includes snippet parentheses in word(newText)
            word = re.sub(r'[\(|<].*[\)|>](\$\d+)?', '', word)

            item = {
                'word': word,
                'abbr': rec['label'],
                'dup': 0,
                'user_data': json.dumps({
                    'lspitem': rec
                })
            }

            if isinstance(rec.get('kind'), int):
                item['kind'] = self.lsp_kinds[rec['kind'] - 1]
            elif rec.get('insertTextFormat') == 2:
                item['kind'] = 'Snippet'

            if rec.get('detail'):
                item['menu'] = rec['detail']

            if isinstance(rec.get('documentation'), str):
                item['info'] = rec['documentation']
            elif (isinstance(rec.get('documentation'), dict) and
                  'value' in rec['documentation']):
                item['info'] = rec['documentation']['value']

            candidates.append(item)

        return candidates
