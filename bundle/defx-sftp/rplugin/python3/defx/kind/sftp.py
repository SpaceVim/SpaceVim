from pathlib import Path
from urllib.parse import urlparse
import site

from pynvim import Nvim
from paramiko import SFTPClient

from defx.action import ActionAttr
from defx.kind.file import Kind as Base
from defx.base.kind import action
from defx.clipboard import ClipboardAction
from defx.context import Context
from defx.defx import Defx
from defx.view import View

site.addsitedir(str(Path(__file__).parent.parent))
from sftp import SFTPPath  # noqa: E402
from source.sftp import Source  # noqa: E402


class Kind(Base):

    def __init__(self, vim: Nvim, source) -> None:
        self.vim = vim
        self.name = 'sftp'
        self._source: Source = source

    @property
    def client(self) -> SFTPClient:
        return self._source.client

    def is_readable(self, path: SFTPPath) -> bool:
        pass

    def get_home(self) -> SFTPPath:
        return SFTPPath(self.client, self.client.normalize('.'))

    def path_maker(self, path: str) -> SFTPPath:
        path = urlparse(path).path
        if not path:
            path = self._source.client.normalize('.')
        return SFTPPath(self.client, path)

    def rmtree(self, path: SFTPPath) -> None:
        path.rmdir_recursive()

    def get_buffer_name(self, path: str) -> str:
        # TODO: return 'sftp://{}@{}'
        pass

    def paste(self, view: View, src: SFTPPath, dest: SFTPPath,
              cwd: str) -> None:
        action = view._clipboard.action
        if view._clipboard.source_name == 'file':
            if action == ClipboardAction.COPY:
                self._put_recursive(src, dest, self.client)
            elif action == ClipboardAction.MOVE:
                pass
            elif action == ClipboardAction.LINK:
                pass
            view._vim.command('redraw')
            return

        if action == ClipboardAction.COPY:
            if src.is_dir():
                src.copy_recursive(dest)
            else:
                src.copy(dest)
        elif action == ClipboardAction.MOVE:
            src.rename(dest)

            # Check rename
            # TODO: add prefix
            if not src.is_dir():
                view._vim.call('defx#util#buffer_rename',
                               view._vim.call('bufnr', str(src)), str(dest))
        elif action == ClipboardAction.LINK:
            # Create the symbolic link to dest
            # dest.symlink_to(src, target_is_directory=src.is_dir())
            pass

    @action(name='copy')
    def _copy(self, view: View, defx: Defx, context: Context) -> None:
        super()._copy(view, defx, context)

        def copy_to_local(path: str, dest: str):
            client = defx._source.client
            self._copy_recursive(SFTPPath(client, path), Path(dest), client)
        view._clipboard.paster = copy_to_local

    @action(name='remove_trash', attr=ActionAttr.REDRAW)
    def _remove_trash(self, view: View, defx: Defx, context: Context) -> None:
        view.print_msg('remove_trash is not supported')

    def _copy_recursive(self, path: SFTPPath, dest: Path, client) -> None:
        ''' copy remote files to the local host '''
        if path.is_file():
            client.get(str(path), str(dest))
        else:
            dest.mkdir(parents=True)
            for f in path.iterdir():
                new_dest = dest.joinpath(f.name)
                self._copy_recursive(f, new_dest, client)

    def _put_recursive(self, path: Path, dest: SFTPPath,
                       client: SFTPClient) -> None:
        ''' copy local files to the remote host '''
        if path.is_file():
            client.put(str(path), str(dest))
        else:
            dest.mkdir()
            for f in path.iterdir():
                new_dest = dest.joinpath(f.name)
                self._put_recursive(f, new_dest, client)
