import parso

import pytest


def test_non_unicode():
    with pytest.raises(UnicodeDecodeError):
        parso.parse(b'\xe4')
