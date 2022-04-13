from pathlib import Path
import site
import typing
from urllib.parse import urlparse

from pynvim import Nvim
from paramiko import Transport, SFTPClient, RSAKey, SSHConfig

from defx.context import Context
from defx.base.source import Base

site.addsitedir(str(Path(__file__).parent.parent))
from sftp import SFTPPath  # noqa: E402


class Source(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
        self.name = 'sftp'

        self.client: SFTPClient = None
        self.config: SSHConfig = None

        from kind.sftp import Kind
        self.kind: Kind = Kind(self.vim, self)

        self.username: str = ''
        self.hostname: str = ''

        self.vars = {
            'root': None,
        }

    def init_client(self, hostname, username, port=None) -> None:
        self.username = username
        self.hostname = hostname

        key_path = ''
        conf_path = Path("~/.ssh/config").expanduser()
        if conf_path.exists():
            self.config = SSHConfig.from_path(conf_path)
            conf = self.config.lookup(hostname)
            if "identityfile" in conf:
                key_path = conf["identityfile"][0]
            port = conf.get("port", 22)

        if not key_path:
            key_path = self.vim.vars.get(
                "defx_sftp#key_path", str(Path("~/.ssh/id_rsa").expanduser())
            )
        if port is None:
            port = 22
        transport = Transport((hostname, int(port)))
        rsa_private_key = RSAKey.from_private_key_file(key_path)
        transport.connect(username=username, pkey=rsa_private_key)
        self.client = SFTPClient.from_transport(transport)

    def get_root_candidate(
            self, context: Context, path: Path
    ) -> typing.Dict[str, typing.Any]:
        path_str = self._parse_arg(str(path))
        path = SFTPPath(self.client, path_str)
        word = str(path)
        if word[-1:] != '/':
            word += '/'
        if self.vars['root']:
            word = self.vim.call(self.vars['root'], str(path))
        word = word.replace('\n', '\\n')
        return {
            'word': word,
            'is_directory': True,
            'action__path': path,
        }

    def gather_candidates(
            self, context: Context, path: Path
    ) -> typing.List[typing.Dict[str, typing.Any]]:
        path_str = self._parse_arg(str(path))
        path = SFTPPath(self.client, path_str)

        candidates = []
        for f in path.iterdir():
            candidates.append({
                'word': f.name + ('/' if f.is_dir() else ''),
                'is_directory': f.is_dir(),
                'action__path': f,
            })
        return candidates

    def _parse_arg(self, path: str) -> str:
        parsed = urlparse(path)
        uname = parsed.username
        hname = parsed.hostname
        if hname is None:
            return parsed.path
        if uname is None:
            uname = ''
        if (uname != self.username or
                hname != self.hostname):
            self.init_client(hname, uname, parsed.port)
        rmt_path = parsed.path
        if not rmt_path:
            rmt_path = '.'
        return self.client.normalize(rmt_path)
