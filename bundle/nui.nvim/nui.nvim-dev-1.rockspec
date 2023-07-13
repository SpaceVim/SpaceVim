rockspec_format = "3.0"
package = "nui.nvim"
version = "dev-1"
source = {
  url = "git+https://github.com/MunifTanjim/nui.nvim.git",
  tag = nil,
}
description = {
  summary = "UI Component Library for Neovim.",
  detailed = [[
    UI Component Library for Neovim.
  ]],
  license = "MIT",
  homepage = "https://github.com/MunifTanjim/nui.nvim",
  issues_url = "https://github.com/MunifTanjim/nui.nvim/issues",
  maintainer = "Munif Tanjim (https://muniftanjim.dev)",
  labels = {
    "neovim",
  },
}
build = {
  type = "builtin",
}
test = {
  type = "command",
  command = "scripts/test.sh",
}
