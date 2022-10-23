.. include:: ../global.rst

Development
===========

If you want to contribute anything to |parso|, just open an issue or pull
request to discuss it. We welcome changes! Please check the ``CONTRIBUTING.md``
file in the repository, first.


Deprecations Process
--------------------

The deprecation process is as follows:

1. A deprecation is announced in the next major/minor release.
2. We wait either at least a year & at least two minor releases until we remove
   the deprecated functionality.


Testing
-------

The test suite depends on ``pytest``::

    pip install pytest

To run the tests use the following::

    pytest

If you want to test only a specific Python version (e.g. Python 3.9), it's as
easy as::

    python3.9 -m pytest

Tests are also run automatically on `GitHub Actions
<https://github.com/davidhalter/parso/actions>`_.
