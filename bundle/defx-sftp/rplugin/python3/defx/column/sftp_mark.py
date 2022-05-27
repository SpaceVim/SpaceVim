from pynvim import Nvim
import typing

from defx.column.mark import Column as Base, Highlights
from defx.context import Context
from defx.util import Candidate, len_bytes


class Column(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sftp_mark'

    def get_with_highlights(
        self, context: Context, candidate: Candidate
    ) -> typing.Tuple[str, Highlights]:
        candidate_path = candidate['action__path']
        if candidate['is_selected']:
            return (str(self.vars['selected_icon']),
                    [(f'{self.highlight_name}_selected',
                      self.start, len_bytes(self.vars['selected_icon']))])
        elif (candidate['is_root'] and not candidate_path.is_dir()):
            return (str(self.vars['readonly_icon']),
                    [(f'{self.highlight_name}_readonly',
                      self.start, len_bytes(self.vars['readonly_icon']))])
        return (' ' * self.vars['length'], [])
