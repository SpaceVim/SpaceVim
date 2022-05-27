#!/usr/bin/env bash

stylua . --check || exit 1
luacheck . || exit 1
