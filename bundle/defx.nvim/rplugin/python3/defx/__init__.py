# ============================================================================
# FILE: __init__.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from importlib.util import find_spec
from defx.rplugin import Rplugin


if find_spec('yarp'):
    import vim
else:
    import pynvim as vim

Args = typing.List[typing.Any]

if hasattr(vim, 'plugin'):
    # Neovim only

    @vim.plugin
    class DefxHandlers:

        def __init__(self, vim: vim.Nvim) -> None:
            self._rplugin = Rplugin(vim)

        @vim.function('_defx_init', sync=True)  # type: ignore
        def init_channel(self, args: Args) -> None:
            self._rplugin.init_channel()

        @vim.rpc_export('_defx_start', sync=True)  # type: ignore
        def start(self, args: Args) -> None:
            self._rplugin.start(args)

        @vim.rpc_export('_defx_do_action', sync=True)  # type: ignore
        def do_action(self, args: Args) -> None:
            self._rplugin.do_action(args)

        @vim.rpc_export('_defx_async_action', sync=False)  # type: ignore
        def async_action(self, args: Args) -> None:
            self._rplugin.do_action(args)

        @vim.rpc_export('_defx_get_candidate', sync=True)  # type: ignore
        def get_candidate(self, args: Args
                          ) -> typing.Dict[str, typing.Union[str, bool]]:
            return self._rplugin.get_candidate()

        @vim.rpc_export('_defx_get_context', sync=True)  # type: ignore
        def get_context(self, args: Args) -> typing.Dict[str, typing.Any]:
            return self._rplugin.get_context()

        @vim.rpc_export('_defx_redraw', sync=True)  # type: ignore
        def redraw(self, args: Args) -> None:
            return self._rplugin.redraw(self._rplugin._views)

if find_spec('yarp'):

    global_rplugin = Rplugin(vim)

    def _defx_init() -> None:
        pass

    def _defx_start(args: Args) -> None:
        global_rplugin.start(args)

    def _defx_do_action(args: Args) -> None:
        global_rplugin.do_action(args)

    def _defx_async_action(args: Args) -> None:
        global_rplugin.do_action(args)

    def _defx_get_candidate(args: Args
                            ) -> typing.Dict[str, typing.Union[str, bool]]:
        return global_rplugin.get_candidate()

    def _defx_get_context(args: Args) -> typing.Dict[str, typing.Any]:
        return global_rplugin.get_context()

    def _defx_redraw(args: Args) -> None:
        return global_rplugin.redraw(global_rplugin._views)
