#!/bin/sh

## Credit: @B0o (Maddison Hellstrom)

set -euo pipefail

function get_icon_names() {
  curl 'https://raw.githubusercontent.com/kyazdani42/nvim-web-devicons/master/lua/nvim-web-devicons.lua' |
    lua -e '
      pats={}
      for name in pairs(dofile().get_icons()) do
        table.insert(pats, name)
      end
      table.sort(pats)
      print(table.concat(pats, "\n"))
    '
}

function main() {
  local tmp
  tmp="$(mktemp -d)"
  # shellcheck disable=2064
  trap "rmdir '$tmp'" EXIT
  cd "$tmp"
  local file
  local -A filetypes=()
  local -a missing=()
  while read -r pat; do
    echo "$pat" >&2
    if [[ "$pat" =~ ^\. ]]; then
      file="$pat"
    else
      file="test.$pat"
    fi
    touch "./$file"
    local ft
    ft="$(/usr/bin/nvim -u NORC --noplugin --headless "./$file" +'lua
      local ok, err = pcall(vim.fn.writefile, { vim.bo.filetype }, "/dev/stdout")
      if not ok then
        print(err .. "\n")
        vim.cmd "cquit"
      end
      vim.cmd "quit"
    ')"
    rm "./$file"
    if [[ -n "$ft" ]]; then
      if [[ -v filetypes["$ft"] ]]; then
        filetypes["$ft"]="${filetypes["$ft"]}, '$pat'"
      else
        filetypes["$ft"]="'$pat'"
      fi
    else
      missing+=("$pat")
    fi
  done < <(get_icon_names)

  echo "local filetypes = {"
  for ft in "${!filetypes[@]}"; do
    echo "  ['$ft'] = { ${filetypes[$ft]} },"
  done
  echo "}"
  echo
  echo "local missing = {"
  printf "  '%s',\n" "${missing[@]}"
  echo "}"
}

main "$@"
