#!/usr/bin/env bash

HERE="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cd $HERE/..

run() {
    nvim --headless --noplugin -u scripts/minimal_init.lua \
        -c "PlenaryBustedDirectory $1 { minimal_init = './scripts/minimal_init.lua' }"
}

if [[ $2 = '--summary' ]]; then
    ## really simple results summary by filtering plenary busted output
    run tests/$1  2> /dev/null | grep -E '^\S*(Success|Fail(ed)?|Errors?)\s*:'
else
    run tests/$1
fi
