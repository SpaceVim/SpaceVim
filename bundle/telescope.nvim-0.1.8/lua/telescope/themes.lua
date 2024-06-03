-- Prototype Theme System (WIP)
-- Currently certain designs need a number of parameters.
--
-- local opts = themes.get_dropdown { winblend = 3 }

---@tag telescope.themes
---@config { ["module"] = "telescope.themes" }

---@brief [[
--- Themes are ways to combine several elements of styling together.
---
--- They are helpful for managing the several different UI aspects for telescope and provide
--- a simple interface for users to get a particular "style" of picker.
---@brief ]]

local themes = {}

--- Dropdown style theme.
---
--- Usage:
--- <code>
---     local opts = {...} -- picker options
---     local builtin = require('telescope.builtin')
---     local themes = require('telescope.themes')
---     builtin.find_files(themes.get_dropdown(opts))
--- </code>
function themes.get_dropdown(opts)
  opts = opts or {}

  local theme_opts = {
    theme = "dropdown",

    results_title = false,

    sorting_strategy = "ascending",
    layout_strategy = "center",
    layout_config = {
      preview_cutoff = 1, -- Preview should always show (unless previewer = false)

      width = function(_, max_columns, _)
        return math.min(max_columns, 80)
      end,

      height = function(_, _, max_lines)
        return math.min(max_lines, 15)
      end,
    },

    border = true,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  }
  if opts.layout_config and opts.layout_config.prompt_position == "bottom" then
    theme_opts.borderchars = {
      prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      results = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    }
  end

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

--- Cursor style theme.
---
--- Usage:
--- <code>
---     local opts = {...} -- picker options
---     local builtin = require('telescope.builtin')
---     local themes = require('telescope.themes')
---     builtin.find_files(themes.get_cursor(opts))
--- </code>
function themes.get_cursor(opts)
  opts = opts or {}

  local theme_opts = {
    theme = "cursor",

    sorting_strategy = "ascending",
    results_title = false,
    layout_strategy = "cursor",
    layout_config = {
      width = 80,
      height = 9,
    },
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  }

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

--- Ivy style theme.
---
--- Usage:
--- <code>
---     local opts = {...} -- picker options
---     local builtin = require('telescope.builtin')
---     local themes = require('telescope.themes')
---     builtin.find_files(themes.get_ivy(opts))
--- </code>
function themes.get_ivy(opts)
  opts = opts or {}

  local theme_opts = {
    theme = "ivy",

    sorting_strategy = "ascending",

    layout_strategy = "bottom_pane",
    layout_config = {
      height = 25,
    },

    border = true,
    borderchars = {
      prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
      results = { " " },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  }
  if opts.layout_config and opts.layout_config.prompt_position == "bottom" then
    theme_opts.borderchars = {
      prompt = { " ", " ", "─", " ", " ", " ", "─", "─" },
      results = { "─", " ", " ", " ", "─", "─", " ", " " },
      preview = { "─", " ", "─", "│", "┬", "─", "─", "╰" },
    }
  end

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

return themes
