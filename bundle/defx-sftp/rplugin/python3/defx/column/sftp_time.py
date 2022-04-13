from pynvim import Nvim
import time
import typing

from defx.column.time import Column as Base, Highlights
from defx.context import Context
from defx.util import Candidate


class Column(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sftp_time'

    def get_with_highlights(
        self, context: Context, candidate: Candidate
    ) -> typing.Tuple[str, Highlights]:
        path = candidate['action__path']
        text = time.strftime(self.vars['format'],
                             time.localtime(path.stat().st_mtime))
        return (text, [(self.highlight_name, self.start, self._length)])
