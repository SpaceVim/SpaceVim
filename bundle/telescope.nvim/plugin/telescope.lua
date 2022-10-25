if 1 ~= vim.fn.has "nvim-0.7.0" then
  vim.api.nvim_err_writeln "Telescope.nvim requires at least nvim-0.7.0. See `:h telescope.changelog-1851`"
  return
end

if vim.g.loaded_telescope == 1 then
  return
end
vim.g.loaded_telescope = 1

local highlights = {
  -- Sets the highlight for selected items within the picker.
  TelescopeSelection = { default = true, link = "Visual" },
  TelescopeSelectionCaret = { default = true, link = "TelescopeSelection" },
  TelescopeMultiSelection = { default = true, link = "Type" },
  TelescopeMultiIcon = { default = true, link = "Identifier" },

  -- "Normal" in the floating windows created by telescope.
  TelescopeNormal = { default = true, link = "Normal" },
  TelescopePreviewNormal = { default = true, link = "TelescopeNormal" },
  TelescopePromptNormal = { default = true, link = "TelescopeNormal" },
  TelescopeResultsNormal = { default = true, link = "TelescopeNormal" },

  -- Border highlight groups.
  --   Use TelescopeBorder to override the default.
  --   Otherwise set them specifically
  TelescopeBorder = { default = true, link = "TelescopeNormal" },
  TelescopePromptBorder = { default = true, link = "TelescopeBorder" },
  TelescopeResultsBorder = { default = true, link = "TelescopeBorder" },
  TelescopePreviewBorder = { default = true, link = "TelescopeBorder" },

  -- Title highlight groups.
  --   Use TelescopeTitle to override the default.
  --   Otherwise set them specifically
  TelescopeTitle = { default = true, link = "TelescopeBorder" },
  TelescopePromptTitle = { default = true, link = "TelescopeTitle" },
  TelescopeResultsTitle = { default = true, link = "TelescopeTitle" },
  TelescopePreviewTitle = { default = true, link = "TelescopeTitle" },

  TelescopePromptCounter = { default = true, link = "NonText" },

  -- Used for highlighting characters that you match.
  TelescopeMatching = { default = true, link = "Special" },

  -- Used for the prompt prefix
  TelescopePromptPrefix = { default = true, link = "Identifier" },

  -- Used for highlighting the matched line inside Previewer. Works only for (vim_buffer_ previewer)
  TelescopePreviewLine = { default = true, link = "Visual" },
  TelescopePreviewMatch = { default = true, link = "Search" },

  TelescopePreviewPipe = { default = true, link = "Constant" },
  TelescopePreviewCharDev = { default = true, link = "Constant" },
  TelescopePreviewDirectory = { default = true, link = "Directory" },
  TelescopePreviewBlock = { default = true, link = "Constant" },
  TelescopePreviewLink = { default = true, link = "Special" },
  TelescopePreviewSocket = { default = true, link = "Statement" },
  TelescopePreviewRead = { default = true, link = "Constant" },
  TelescopePreviewWrite = { default = true, link = "Statement" },
  TelescopePreviewExecute = { default = true, link = "String" },
  TelescopePreviewHyphen = { default = true, link = "NonText" },
  TelescopePreviewSticky = { default = true, link = "Keyword" },
  TelescopePreviewSize = { default = true, link = "String" },
  TelescopePreviewUser = { default = true, link = "Constant" },
  TelescopePreviewGroup = { default = true, link = "Constant" },
  TelescopePreviewDate = { default = true, link = "Directory" },
  TelescopePreviewMessage = { default = true, link = "TelescopePreviewNormal" },
  TelescopePreviewMessageFillchar = { default = true, link = "TelescopePreviewMessage" },

  -- Used for Picker specific Results highlighting
  TelescopeResultsClass = { default = true, link = "Function" },
  TelescopeResultsConstant = { default = true, link = "Constant" },
  TelescopeResultsField = { default = true, link = "Function" },
  TelescopeResultsFunction = { default = true, link = "Function" },
  TelescopeResultsMethod = { default = true, link = "Method" },
  TelescopeResultsOperator = { default = true, link = "Operator" },
  TelescopeResultsStruct = { default = true, link = "Struct" },
  TelescopeResultsVariable = { default = true, link = "SpecialChar" },

  TelescopeResultsLineNr = { default = true, link = "LineNr" },
  TelescopeResultsIdentifier = { default = true, link = "Identifier" },
  TelescopeResultsNumber = { default = true, link = "Number" },
  TelescopeResultsComment = { default = true, link = "Comment" },
  TelescopeResultsSpecialComment = { default = true, link = "SpecialComment" },

  -- Used for git status Results highlighting
  TelescopeResultsDiffChange = { default = true, link = "DiffChange" },
  TelescopeResultsDiffAdd = { default = true, link = "DiffAdd" },
  TelescopeResultsDiffDelete = { default = true, link = "DiffDelete" },
  TelescopeResultsDiffUntracked = { default = true, link = "NonText" },
}

for k, v in pairs(highlights) do
  vim.api.nvim_set_hl(0, k, v)
end

-- This is like "<C-R>" in your terminal.
--     To use it, do `cmap <C-R> <Plug>(TelescopeFuzzyCommandSearch)
vim.keymap.set(
  "c",
  "<Plug>(TelescopeFuzzyCommandSearch)",
  "<C-\\>e \"lua require('telescope.builtin').command_history "
    .. '{ default_text = [=[" . escape(getcmdline(), \'"\') . "]=] }"<CR><CR>',
  { silent = true, noremap = true }
)

vim.api.nvim_create_user_command("Telescope", function(opts)
  require("telescope.command").load_command(unpack(opts.fargs))
end, {
  nargs = "*",
  complete = function(_, line)
    local builtin_list = vim.tbl_keys(require "telescope.builtin")
    local extensions_list = vim.tbl_keys(require("telescope._extensions").manager)

    local l = vim.split(line, "%s+")
    local n = #l - 2

    if n == 0 then
      return vim.tbl_filter(function(val)
        return vim.startswith(val, l[2])
      end, vim.tbl_extend("force", builtin_list, extensions_list))
    end

    if n == 1 then
      local is_extension = vim.tbl_filter(function(val)
        return val == l[2]
      end, extensions_list)

      if #is_extension > 0 then
        local extensions_subcommand_dict = require("telescope.command").get_extensions_subcommand()
        return vim.tbl_filter(function(val)
          return vim.startswith(val, l[3])
        end, extensions_subcommand_dict[l[2]])
      end
    end

    local options_list = vim.tbl_keys(require("telescope.config").values)
    return vim.tbl_filter(function(val)
      return vim.startswith(val, l[#l])
    end, options_list)
  end,
})
