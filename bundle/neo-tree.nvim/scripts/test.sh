#!/usr/bin/env bash

set -euo pipefail

luacov_dir=""

while [[ $# -gt 0 ]]; do
  case "${1}" in
    --clean)
      shift
      echo "[test] cleaning up environment"
      rm -rf ./.testcache
      echo "[test] envionment cleaned"
      ;;
    *)
      shift
      ;;
  esac
done

function setup_environment() {
  echo
  echo "[test] setting up environment"
  echo

  local plugins_dir="./.testcache/site/pack/vendor/start"
  if [[ ! -d "${plugins_dir}" ]]; then
    mkdir -p "${plugins_dir}"
  fi

  if [[ ! -d "${plugins_dir}/nui.nvim" ]]; then
    echo "[plugins] nui.nvim: installing..."
    git clone https://github.com/MunifTanjim/nui.nvim "${plugins_dir}/nui.nvim"
    echo "[plugins] nui.nvim: installed"
    echo
  fi

  if [[ ! -d "${plugins_dir}/nvim-web-devicons" ]]; then
    echo "[plugins] nvim-web-devicons: installing..."
    git clone https://github.com/nvim-tree/nvim-web-devicons "${plugins_dir}/nvim-web-devicons"
    echo "[plugins] nvim-web-devicons: installed"
    echo
  fi

  if [[ ! -d "${plugins_dir}/plenary.nvim" ]]; then
    echo "[plugins] plenary.nvim: installing..."
    git clone https://github.com/nvim-lua/plenary.nvim "${plugins_dir}/plenary.nvim"
    # this commit broke luacov
    #git -C "${plugins_dir}/plenary.nvim" revert --no-commit 9069d14a120cadb4f6825f76821533f2babcab92
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

#luacov_start

make test

#luacov_end
