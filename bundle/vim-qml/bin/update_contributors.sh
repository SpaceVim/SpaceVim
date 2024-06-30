#!/bin/sh

cat <<_EOF > CONTRIBUTORS.md
# Contributors

In addition to the original work done by Warwick Allison, the following people
have made contributions:

_EOF

git shortlog -s | gawk '{$1=""; print "*" $0}' | sort -u >> CONTRIBUTORS.md
