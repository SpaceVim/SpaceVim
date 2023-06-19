#!/bin/sh
exec nvim -u NONE -E -R --headless +'set rtp+=$PWD' +'luafile scripts/docgen.lua' +q
