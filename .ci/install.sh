#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C

.ci/install/linux.sh $VIM_BIN $VIM_TAG
if [ "$VIM_BIN" = "nvim" ]; then
    export PATH="${DEPS}/_neovim/${VIM_TAG}/bin:${PATH}"
    export VIM="${DEPS}/_neovim/${VIM_TAG}/share/nvim/runtime"
else
    export PATH="${DEPS}/_vim/${VIM_TAG}/bin:${PATH}"
    export VIM="${DEPS}/_vim/${VIM_TAG}/share/vim"
fi

echo "\$VIM: \"${VIM}\""
echo "=================  nvim version ======================"
$VIM_BIN --version
