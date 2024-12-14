if vim.b.did_ftp == true then
  return
end

vim.opt_local.cursorline = true
vim.opt_local.modifiable = false
vim.opt_local.buflisted = false
vim.opt_local.number = false
-- vim.opt_local.iskeyword:append(':')
vim.opt_local.iskeyword:append('-')
vim.opt_local.relativenumber = false
vim.opt_local.bufhidden = 'wipe'
vim.opt_local.syntax = 'zktagstree'
vim.opt_local.buftype = 'nofile'
vim.opt_local.swapfile = false
vim.opt_local.winfixwidth = true

local hi = require('spacevim.api.vim.highlight')

vim.api.nvim_buf_set_keymap(0, 'n', '<F2>', '', {
  noremap = true,
  silent = true,
  nowait = true,
  callback = function() end,
})
vim.api.nvim_buf_set_keymap(0, 'n', '<Enter>', '', {
  noremap = true,
  silent = true,
  nowait = true,
  callback = function()
    local bufnr = vim.fn.bufnr('zk://browser')
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
      vim.api.nvim_buf_set_lines(
        bufnr,
        0,
        -1,
        false,
        require('zettelkasten').get_note_browser_content({ tags = { vim.fn.trim(vim.fn.getline('.')) } })
      )
    end
    vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
  end,
})
vim.api.nvim_buf_set_keymap(0, 'n', '<LeftRelease>', '', {
  noremap = true,
  silent = true,
  nowait = true,
  callback = function()
    if hi.syntax_at() == 'zktagstreeOrg' then
      require('zettelkasten.sidebar').toggle_folded_key()
    else
      local bufnr = vim.fn.bufnr('zk://browser')
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
        vim.api.nvim_buf_set_lines(
          bufnr,
          0,
          -1,
          false,
          require('zettelkasten').get_note_browser_content({ tags = { vim.fn.trim(vim.fn.getline('.')) } })
        )
      end
      vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
    end
  end,
})
