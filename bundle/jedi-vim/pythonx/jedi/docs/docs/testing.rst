.. include:: ../global.rst

Jedi Testing
============

The test suite depends on ``pytest``::

    pip install pytest

If you want to test only a specific Python version (e.g. Python 3.8), it is as
easy as::

    python3.8 -m pytest

Tests are also run automatically on `GitHub Actions
<https://github.com/davidhalter/jedi/actions>`_.

You want to add a test for |jedi|? Great! We love that. Normally you should
write your tests as :ref:`Blackbox Tests <blackbox>`. Most tests would
fit right in there.

For specific API testing we're using simple unit tests, with a focus on a
simple and readable testing structure.

.. _blackbox:

Integration Tests (run.py)
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. automodule:: test.run

Refactoring Tests (refactor.py)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. automodule:: test.refactor

