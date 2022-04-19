from __future__ import annotations
import typing
from pathlib import PurePosixPath
import stat
from paramiko import SFTPClient, SFTPAttributes


class SFTPPath(PurePosixPath):
    def __new__(cls, client: SFTPClient, path: str,
                stat: SFTPAttributes = None):
        self = super().__new__(cls, path)
        self.client: SFTPClient = client
        self.path: str = path
        self._stat: SFTPAttributes = stat
        return self

    def __eq__(self, other):
        return self.__str__() == str(other)

    def __str__(self):
        return self.path

    def copy(self, dest: SFTPPath) -> None:
        fl = self.client.open(self.path)
        self.client.putfo(fl, str(dest))

    def copy_recursive(self, dest: SFTPPath) -> None:
        if self.is_file():
            self.copy(dest)
        else:
            dest.mkdir()
            for f in self.iterdir():
                new_dest = dest.joinpath(f.name)
                f.copy_recursive(new_dest)

    def exists(self):
        try:
            return bool(self.stat())
        except FileNotFoundError:
            return False

    def is_dir(self) -> bool:
        return not self.is_file()

    def is_file(self) -> bool:
        mode = self.stat().st_mode
        return stat.S_ISREG(mode)

    def is_symlink(self) -> bool:
        mode = self.stat().st_mode
        return stat.S_ISLNK(mode)

    def iterdir(self) -> typing.Iterable(SFTPPath):
        for f in self.client.listdir_attr(self.path):
            yield self.joinpath(f.filename, f)

    def joinpath(self, name: str, stat: SFTPAttributes = None):
        sep = '' if self.path == '/' else '/'
        new_path = self.path + sep + name
        return SFTPPath(self.client, new_path, stat)

    def mkdir(self, parents=False, exist_ok=False):
        # TODO: mkdir recursively
        self.client.mkdir(self.path)

    @property
    def parent(self):
        if self.path == '/':
            return self
        parts = self.path.split('/')
        new_path = '/'.join(parts[:-1])
        if not new_path:
            new_path = '/'
        return SFTPPath(self.client, new_path)

    def relative_to(self, other) -> SFTPPath:
        return self

    def rename(self, new: SFTPPath) -> SFTPPath:
        self.client.rename(self.path, new.path)

    def resolve(self) -> SFTPPath:
        client = self.client
        new_path = client.normalize(self.path)
        return SFTPPath(client, new_path)

    def rmdir(self):
        """
        Remove directory. Directory must be empty.
        """
        self.client.rmdir(self.path)

    def rmdir_recursive(self):
        if self.is_file():
            self.unlink()
        else:
            for f in self.iterdir():
                f.rmdir_recursive()
            self.rmdir()

    def stat(self) -> SFTPAttributes:
        if self._stat:
            return self._stat
        else:
            return self.client.stat(self.path)

    def touch(self, exist_ok=True):
        self.client.open(self.path, mode='x')

    def unlink(self, missing_ok=False):
        self.client.unlink(self.path)


if __name__ == '__main__':
    print(SFTPPath.parse_path('//hoge@13.4.3'))
