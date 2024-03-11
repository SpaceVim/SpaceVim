-- Execute as `nvim --headless -c "luafile ./scripts/write-lockfile.lua"`

---@type string|any[]
local skip_langs = vim.fn.getenv "SKIP_LOCKFILE_UPDATE_FOR_LANGS"

if skip_langs == vim.NIL then
  skip_langs = {}
else
  ---@diagnostic disable-next-line: param-type-mismatch
  skip_langs = vim.fn.split(skip_langs, ",")
end

print("Skipping languages: " .. vim.inspect(skip_langs))
require("nvim-treesitter.install").write_lockfile("verbose", skip_langs)
vim.cmd "q"
