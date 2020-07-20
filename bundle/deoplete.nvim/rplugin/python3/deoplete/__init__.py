# ============================================================================
# FILE: __init__.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from importlib.util import find_spec
from deoplete.deoplete import Deoplete
from deoplete.util import Nvim


if find_spec('yarp'):
    import vim
elif find_spec('pynvim'):
    import pynvim as vim
else:
    import neovim as vim

Context = typing.Dict[str, typing.Any]

if hasattr(vim, 'plugin'):
    # Neovim only

    @vim.plugin
    class DeopleteHandlers(object):

        def __init__(self, vim: Nvim):
            self._vim = vim

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
