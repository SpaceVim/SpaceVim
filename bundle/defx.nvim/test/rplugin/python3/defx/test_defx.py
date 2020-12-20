import pytest

from defx.view import View
from pynvim import Nvim
from unittest.mock import create_autospec
from unittest.mock import MagicMock


def test_view():
    vim = create_autospec(Nvim)
    vim.channel_id = 0
    vim.vars = {}
    vim.call.return_value = ''
    vim.current = MagicMock()

    context = {}
    defx = View(vim, 0)
