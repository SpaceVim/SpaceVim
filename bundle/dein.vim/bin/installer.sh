#!/bin/sh
# Standalone installer for Unixs
# Original version is created by shoma2da
# https://github.com/shoma2da/neobundle_installer

set -e

if [ $# -ne 1 ]; then
  echo "You must specify the installation directory!"
  exit 1
fi

# Convert the installation directory to absolute path
case $1 in
  /*) PLUGIN_DIR=$1;;
  *) PLUGIN_DIR=$PWD/$1;;
esac
INSTALL_DIR="${PLUGIN_DIR}/repos/github.com/Shougo/dein.vim"
echo "Install to \"$INSTALL_DIR\"..."
if [ -e "$INSTALL_DIR" ]; then
  echo "\"$INSTALL_DIR\" already exists!"
fi

echo ""

# check git command
type git || {
  echo 'Please install git or update your path to include the git executable!'
  exit 1
}
echo ""

# make plugin dir and fetch dein
if ! [ -e "$INSTALL_DIR" ]; then
  echo "Begin fetching dein..."
  mkdir -p "$PLUGIN_DIR"
  git clone --depth=1 https://github.com/Shougo/dein.vim "$INSTALL_DIR"
  echo "Done."
  echo ""
fi

# write initial setting for .vimrc
echo "Please add the following settings for dein to the top of your vimrc (Vim) or init.vim (NeoVim) file:"
{
    echo ""
    echo ""
    echo "\"dein Scripts-----------------------------"
    echo "if &compatible"
    echo "  set nocompatible               \" Be iMproved"
    echo "endif"
    echo ""
    echo "\" Required:"
    echo "set runtimepath+=$INSTALL_DIR"
    echo ""
    echo "\" Required:"
    echo "call dein#begin('$PLUGIN_DIR')"
    echo ""
    echo "\" Let dein manage dein"
    echo "\" Required:"
    echo "call dein#add('$INSTALL_DIR')"
    echo ""
    echo "\" Add or remove your plugins here like this:"
    echo "\"call dein#add('Shougo/neosnippet.vim')"
    echo "\"call dein#add('Shougo/neosnippet-snippets')"
    echo ""
    echo "\" Required:"
    echo "call dein#end()"
    echo ""
    echo "\" Required:"
    echo "filetype plugin indent on"
    echo "syntax enable"
    echo ""
    echo "\" If you want to install not installed plugins on startup."
    echo "\"if dein#check_install()"
    echo "\"  call dein#install()"
    echo "\"endif"
    echo ""
    echo "\"End dein Scripts-------------------------"
    echo ""
    echo ""
}

echo "Done."

echo "Complete setup dein!"
