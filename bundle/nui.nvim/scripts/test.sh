#!/usr/bin/env bash

set -euo pipefail

test_scope="nui"

while [[ $# -gt 0 ]]; do
  case "${1}" in
    --clean)
      shift
      echo "[test] cleaning up environment"
      rm -rf ./.testcache
      echo "[test] envionment cleaned"
      ;;
    *)
      if [[ "${test_scope}" == "nui" ]] && [[ "${1}" == "nui/"* ]]; then
        test_scope="${1}"
      fi
      shift
      ;;
  esac
done

function setup_environment() {
  echo
  echo "[test] setting up environment"
  echo

  local plugins_dir="./.testcache/site/pack/deps/start"
  if [[ ! -d "${plugins_dir}" ]]; then
    mkdir -p "${plugins_dir}"
  fi

  if [[ ! -d "${plugins_dir}/plenary.nvim" ]]; then
    echo "[plugins] plenary.nvim: installing..."
    git clone https://github.com/nvim-lua/plenary.nvim "${plugins_dir}/plenary.nvim"
    # commit 9069d14a120cadb4f6825f76821533f2babcab92 broke luacov
    # issue: https://github.com/nvim-lua/plenary.nvim/issues/353
    local -r plenary_353_patch="$(pwd)/scripts/plenary-353.patch"
    git -C "${plugins_dir}/plenary.nvim" apply "${plenary_353_patch}"
    echo "[plugins] plenary.nvim: installed"
    echo
  fi

  echo "[test] environment ready"
  echo
}

function luacov_start() {
  luacov_dir="$(dirname "$(luarocks which luacov 2>/dev/null | head -1)")"
  if [[ "${luacov_dir}" == "." ]]; then
    luacov_dir=""
  fi

  if test -n "${luacov_dir}"; then
    rm -f luacov.*.out
    export LUA_PATH=";;${luacov_dir}/?.lua"
  fi
}

function luacov_end() {
  if test -n "${luacov_dir}"; then
    luacov

    echo
    tail -n +$(($(grep -n "^Summary$" luacov.report.out | cut -d":" -f1) - 1)) luacov.report.out
  fi
}

setup_environment

luacov_start

if [[ -d "./tests/${test_scope}/" ]]; then
  nvim --headless --noplugin -u tests/minimal_init.lua -c "lua require('plenary.test_harness').test_directory('./tests/${test_scope}/', { minimal_init = 'tests/minimal_init.lua', sequential = true })"
elif [[ -f "./tests/${test_scope}_spec.lua" ]]; then
  nvim --headless --noplugin -u tests/minimal_init.lua -c "lua require('plenary.busted').run('./tests/${test_scope}_spec.lua')"
fi

luacov_end
