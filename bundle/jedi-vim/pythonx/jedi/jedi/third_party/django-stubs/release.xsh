#!/usr/local/bin/xonsh

try:
    no_uncommitted_changes = bool(!(git diff-index --quiet HEAD --))
    if no_uncommitted_changes:
        pip install wheel twine
        python setup.py sdist bdist_wheel
        twine upload dist/*

finally:
    rm -rf dist/ build/