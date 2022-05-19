#!/bin/sh

# run after changing nvim-tree.lua DEFAULT_OPTS: scrapes and updates README.md, nvim-tree-lua.txt

begin="BEGIN_DEFAULT_OPTS"
end="END_DEFAULT_OPTS"

# scrape, indented at 2
sed -n -e "/${begin}/,/${end}/{ /${begin}/d; /${end}/d; p; }" lua/nvim-tree.lua > /tmp/DEFAULT_OPTS.2.lua

# indent some more
sed -e "s/^  /      /" /tmp/DEFAULT_OPTS.2.lua > /tmp/DEFAULT_OPTS.6.lua

# README.md indented at 2
sed -i -e "/${begin}/,/${end}/{ /${begin}/{p; r /tmp/DEFAULT_OPTS.2.lua
           }; /${end}/p; d }" README.md

# help, indented at 6
sed -i -e "/${begin}/,/${end}/{ /${begin}/{p; r /tmp/DEFAULT_OPTS.6.lua
           }; /${end}/p; d }" doc/nvim-tree-lua.txt

