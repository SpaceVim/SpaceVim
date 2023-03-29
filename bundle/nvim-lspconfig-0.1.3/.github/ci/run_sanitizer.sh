#!/usr/bin/env bash
set -e

REF_BRANCH="$1"
PR_BRANCH="$2"

# checks for added lines that contain search pattern and prints them
SEARCH_PATTERN="(dirname|fn\.cwd)"

if git diff --pickaxe-all -U0 -G "${SEARCH_PATTERN}" "${REF_BRANCH}" "${PR_BRANCH}" -- '*.lua' | grep -Ev '(configs|utils)\.lua$' | grep -E "^\+.*${SEARCH_PATTERN}" ; then
  echo
  echo 'String "dirname" found. There is a high risk that this might contradict the directive:'
  echo '"Do not add vim.fn.cwd or util.path.dirname in root_dir".'
  echo "see: https://github.com/neovim/nvim-lspconfig/blob/master/CONTRIBUTING.md#adding-a-server-to-lspconfig."
  exit 1
fi
