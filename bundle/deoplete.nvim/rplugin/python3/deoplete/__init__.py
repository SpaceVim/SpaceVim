# ============================================================================
# FILE: __init__.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from importlib.util import find_spec
from pynvim import Nvim
import typing

from deoplete.deoplete import Deoplete

try:
    # For Vim8
    import vim
except ModuleNotFoundError:
    # For neovim
    # Note: neovim cannot import vim module
    import pynvim as vim

Context = typing.Dict[str, typing.Any]

if hasattr(vim, 'plugin'):
    # Neovim only

    @vim.plugin
    class DeopleteHandlers(object):

        def __init__(self, _vim: Nvim):
            self._vim = _vim

        @vim.function('_deoplete_init', sync=False)  # type: ignore
        def init_channel(self,
                         args: typing.List[typing.Any]) -> None:
            self._deoplete = Deoplete(self._vim)
            self._vim.call('deoplete#send_event', 'BufReadPost')

        @vim.rpc_export('deoplete_enable_logging')  # type: ignore
        def enable_logging(self, context: Context) -> None:
            self._deoplete.enable_logging()

        @vim.rpc_export('deoplete_auto_completion_begin')  # type: ignore
        def auto_completion_begin(self, context: Context) -> None:
            self._deoplete.completion_begin(context)

        @vim.rpc_export('deoplete_manual_completion_begin')  # type: ignore
        def manual_completion_begin(self, context: Context) -> None:
            self._deoplete.completion_begin(context)

        @vim.rpc_export('deoplete_on_event')  # type: ignore
        def on_event(self, context: Context) -> None:
            self._deoplete.on_event(context)


if find_spec('yarp'):

    global_deoplete = Deoplete(vim)

    def deoplete_init() -> None:
        global_deoplete._vim.call('deoplete#send_event', 'BufReadPost')

    def deoplete_enable_logging(context: Context) -> None:
        global_deoplete.enable_logging()

    def deoplete_auto_completion_begin(context: Context) -> None:
        global_deoplete.completion_begin(context)

    def deoplete_manual_completion_begin(context: Context) -> None:
        global_deoplete.completion_begin(context)

    def deoplete_on_event(context: Context) -> None:
        global_deoplete.on_event(context)
