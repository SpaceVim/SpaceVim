#!/usr/bin/env bash

set -eu pipefall

declare -r INSTALL_DIR="$PWD/utils"
declare -r RELEASE="0.10.0"
declare -r OS="linux"
# declare -r OS="$(uname -s)"
declare -r FILENAME="stylua-$RELEASE-$OS"

declare -a __deps=("curl" "unzip")

function check_deps() {
  for dep in "${__deps[@]}"; do
    if ! command -v "$dep" >/dev/null; then
      echo "Missing depdendecy!"
      echo "The \"$dep\" command was not found!. Please install and try again."
    fi
  done
}

function download_stylua() {
  local DOWNLOAD_DIR
  local URL="https://github.com/JohnnyMorganz/StyLua/releases/download/v$RELEASE/$FILENAME.zip"

  DOWNLOAD_DIR="$(mktemp -d)"
  echo "Initiating download for Stylua v$RELEASE"
  if ! curl --progress-bar --fail -L "$URL" -o "$DOWNLOAD_DIR/$FILENAME.zip"; then
    echo "Download failed.  Check that the release/filename are correct."
    exit 1
  fi

  echo "Installation in progress.."
  unzip -q "$DOWNLOAD_DIR/$FILENAME.zip" -d "$DOWNLOAD_DIR"

  if [ -f "$DOWNLOAD_DIR/stylua" ]; then
    mv "$DOWNLOAD_DIR/stylua" "$INSTALL_DIR/stylua"
  else
    mv "$DOWNLOAD_DIR/$FILENAME/stylua" "$INSTALL_DIR/."
  fi

  chmod u+x "$INSTALL_DIR/stylua"
}

function verify_install() {
  echo "Verifying installation.."
  local DOWNLOADED_VER
  DOWNLOADED_VER="$("$INSTALL_DIR/stylua" -V | awk '{ print $2 }')"
  if [ "$DOWNLOADED_VER" != "$RELEASE" ]; then
    echo "Mismatched version!"
    echo "Expected: v$RELEASE but got v$DOWNLOADED_VER"
    exit 1
  fi
  echo "Verification complete!"
}

function main() {
  check_deps
  download_stylua
  verify_install
}

main "$@"
