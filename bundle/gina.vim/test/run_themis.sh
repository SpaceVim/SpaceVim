#!/bin/bash
themis --version

export THEMIS_VIM="vim"
themis --reporter dot

export THEMIS_VIM="nvim"
export THEMIS_ARGS="-e -s --headless"
themis --reporter dot
