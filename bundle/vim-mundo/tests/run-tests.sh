#!/usr/bin/env bash

set -e

if [[ $# -eq 0 ]]
then
    TESTS="`ls *.vim | tr "\n" ' '`"
else
    IFS=' '
    TESTS="$*"
fi

vim -u vimrc_test -c ":UTRun $TESTS"
