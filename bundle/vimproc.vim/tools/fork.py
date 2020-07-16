import os
import sys
import time

# Create new process
pid = os.fork()

# Print text
c = 'p' if pid == 0 else 'c'

if pid == 0:
    sys.exit(0)

while True:
    time.sleep(1)
    sys.stderr.write(c)
