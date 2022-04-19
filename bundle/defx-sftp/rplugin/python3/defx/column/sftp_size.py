from pynvim import Nvim
import typing

from defx.column.size import Column as Base, Highlights
from defx.context import Context
from defx.util import Candidate


class Column(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sftp_size'

    def get_with_highlights(
        self, context: Context, candidate: Candidate
    ) -> typing.Tuple[str, Highlights]:
        path = candidate['action__path']
        if path.is_dir():
            return (' ' * self._length, [])
        size = self._get_size(path.stat().st_size)
        text = '{:>6s}{:>3s}'.format(size[0], size[1])
        highlight = f'{self.highlight_name}_{size[1]}'
        return (text, [(highlight, self.start, self._length)])
