#!/usr/bin/env bash

set -ex
if [ "$LINT" = "vimlint" ]; then
    for file in $(git diff --name-only HEAD dev | grep .vim$);
    do
        sh /tmp/vimlint/bin/vimlint.sh -l /tmp/vimlint -p /tmp/vimlparser $file;
    done
elif [ "$LINT" = "vimlint-errors" ]; then
    export VIMLINT_LOG="<ditails>"
    for file in $(git diff --name-only HEAD dev | grep .vim$);
    do
        export VIMLINT_LOG="$VIMLINT_LOG$(sh /tmp/vimlint/bin/vimlint.sh -E -l /tmp/vimlint -p /tmp/vimlparser $file)\n";
    done
    export VIMLINT_LOG="$VIMLINT_LOG\n</ditails>"
    if [ "$VIMLINT_LOG" != "<ditails>\n</ditails>" ]; then
        exit 2
    fi
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
