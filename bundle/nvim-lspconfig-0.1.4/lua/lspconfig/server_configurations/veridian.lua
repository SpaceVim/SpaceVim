local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'veridian' },
    filetypes = { 'systemverilog', 'verilog' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/vivekmalneedi/veridian

A SystemVerilog LanguageServer.

Download the latest release for your OS from the releases page

# install with slang feature, if C++17 compiler is available
cargo install --git https://github.com/vivekmalneedi/veridian.git --all-features
# install if C++17 compiler is not available
cargo install --git https://github.com/vivekmalneedi/veridian.git
    ]],
  },
}
