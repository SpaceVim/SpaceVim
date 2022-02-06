#!/bin/bash

set -eu

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ -f "$DIR/../vimunit/vutest.sh" ]; then
	# vimunit in the plugin root
	VU="$DIR/../vimunit/vutest.sh"

elif [ -f "$DIR/../../vimunit/vutest.sh" ]; then
	# vimunit in the plugin root's parent dir (think of ~/.vim/bundle)
	VU="$DIR/../../vimunit/vutest.sh"

else
	# no vimunit found, just grab it from github
	git clone https://github.com/complex857/vimunit.git "$DIR/../vimunit"
	VU="$DIR/../vimunit/vutest.sh"
fi

VIM='vim'

if [ ! -f "$VU" ]; then
	echo "Could not run tests. Vimunit executeable not found at: '$VU'"
else
    if [[ $# > 0 ]]; then
        for f in $@; do
            $VU -e "$VIM -u $DIR/vimrc" $f
        done
    else
        for f in "$DIR/"*.vim; do
            $VU -e "$VIM -u $DIR/vimrc" $f
        done
    fi
fi
