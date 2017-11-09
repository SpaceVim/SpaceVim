#!/usr/bin/env bash

set -ex
if [ "$LINT" = "vimlint" ]; then
    for file in $(git diff --name-only HEAD dev | grep .vim$);
    do
        sh /tmp/vimlint/bin/vimlint.sh -l /tmp/vimlint -p /tmp/vimlparser $file;
    done
elif [ "$LINT" = "vimlint-errors" ]; then
    for file in $(git diff --name-only HEAD dev | grep .vim$);
    do
        sh /tmp/vimlint/bin/vimlint.sh -E -l /tmp/vimlint -p /tmp/vimlparser $file;
    done
elif [ "$LINT" = "vint" ]; then
    /tmp/vint/bin/vint .
elif [ "$LINT" = "vint-errors" ]; then
    /tmp/vint/bin/vint --error .
elif [ "$LINT" = "vader" ]; then
    pip install covimerage
    make test_coverage
    covimerage -vv xml --omit 'build/*'
    pip install codecov
    codecov -X search gcov pycov -f coverage.xml
fi
set +x
