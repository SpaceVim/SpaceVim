#!/bin/bash

VISUAL=${VISUAL:-vim}

cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd

dir='profile'
mkdir -vp "$dir"

file="$dir/startup-$(date +%Y-%m-%d.%H:%M:%S)"
file1="$file-1.log"
file2="$file-2.log"

"$VISUAL" -u vimrc-startup --startuptime "$file1"

echo 'g:matchup_delim_start_plaintext=0'
grep matchup "$file1"

export TEST_PLAIN=1
"$VISUAL" -u vimrc-startup --startuptime "$file2"

echo 'g:matchup_delim_start_plaintext=1'
grep matchup "$file2"

