-- Last Change: 2022 Apr 16

if vim.g.loaded_nvim_treesitter then
  return
end
vim.g.loaded_nvim_treesitter = true

-- setup modules
require("nvim-treesitter").setup()

local api = vim.api

-- define autocommands
local augroup = api.nvim_create_augroup("NvimTreesitter", {})

api.nvim_create_autocmd("Filetype", {
  pattern = "query",
  group = augroup,
  callback = function()
    api.nvim_clear_autocmds {
      group = augroup,
      event = "BufWritePost",
    }
    api.nvim_create_autocmd("BufWritePost", {
      group = augroup,
      buffer = 0,
      callback = function(opts)
        require("nvim-treesitter.query").invalidate_query_file(opts.file)
      end,
      desc = "Invalidate query file",
    })
  end,
  desc = "Reload query",
})
