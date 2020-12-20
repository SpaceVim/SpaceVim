#!/bin/sh
#
# A test script that ignores SIGTERM.

trap 'echo not stopping on SIGTERM' TERM
# trap 'echo stopping on SIGHUP; exit' HUP

echo "Started: $$"
c=0
while true; do
  c=$((c + 1))
  echo $c
  sleep .1
done
