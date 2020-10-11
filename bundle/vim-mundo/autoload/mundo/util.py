# import vim

normal = lambda s: vim().command('normal %s' % s)
normal_silent = lambda s: vim().command('silent! normal %s' % s)


def vim():
    """ call Vim.

        This is wrapped so that it can easily be mocked.
    """
    import vim
    return vim

def _goto_window_for_buffer(expr):
    """ Moves the cursor to the first window associated with buffer b in the
        current tab page (only).

        Arguments
        ---------
        expr : int or str
            The target buffer - either a buffer number (int) or a file-pattern
            (str). See :h bufwinnr for a more detailed description.
    """
    if not isinstance(expr, int) and not isinstance(expr, str):
        raise TypeError('b has invalid type, str or int expected.')

    if isinstance(expr, str):
        expr = "'{0}'".format(expr)

    winnr = int(vim().eval('bufwinnr({0})'.format(expr)))
    assert winnr != -1
    vim().command('%dwincmd w' % int(winnr))


# Rendering utility functions
def _output_preview_text(lines):
    """ Output a list of lines to the mundo preview window. """
    _goto_window_for_buffer('__Mundo_Preview__')
    vim().command('setlocal modifiable')
    vim().current.buffer[:] = [line.rstrip() for line in lines]
    vim().command('setlocal nomodifiable')


def _undo_to(n):
    n = int(n)
    if n == 0:
        vim().command('silent earlier %s' % (int(vim().eval('&undolevels')) + 1))
    else:
        vim().command('silent undo %d' % int(n))
