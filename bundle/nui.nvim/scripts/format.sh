#!/usr/bin/env sh

r_v_major="0"
r_v_minor="13"
r_v_patch="1"

v="$(stylua --version | cut -d' ' -f2)"
v_major="$(echo "${v}" | cut -d'.' -f1)"
v_minor="$(echo "${v}" | cut -d'.' -f2)"
v_patch="$(echo "${v}" | cut -d'.' -f3)"

v_error_message="required stylua ~v${r_v_major}.${r_v_minor}.${r_v_patch}, found v${v_major}.${v_minor}.${v_patch}"

if test ${v_major} -ne ${r_v_major} || test ${v_minor} -ne ${r_v_minor} || test ${v_patch} -lt ${r_v_patch}; then
  echo ${v_error_message} >&2
  exit 1
fi

stylua --color always ${1} lua/nui/ tests/
