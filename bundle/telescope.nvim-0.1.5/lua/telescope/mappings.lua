---@tag telescope.mappings

---@brief [[
--- |telescope.mappings| is used to configure the keybindings within
--- a telescope picker. These key binds are only local to the picker window
--- and will be cleared once you exit the picker.
---
--- We provide multiple configuration options to make it easy for you to adjust
--- telescope's default key bindings and create your own custom key binds.
---
--- To see many of the builtin actions that you can use as values for this
--- table, see |telescope.actions|
---
--- Format is:
--- <code>
---   {
---     mode = { ..keys }
---   }
--- </code>
---
---  where {mode} is the one character letter for a mode ('i' for insert, 'n' for normal).
---
---  For example:
--- <code>
---   mappings = {
---     i = {
---       ["<esc>"] = require('telescope.actions').close,
---     },
---   }
--- </code>
---
--- To disable a keymap, put `[map] = false`<br>
--- For example:
--- <code>
---   {
---     ...,
---     ["<C-n>"] = false,
---     ...,
---   }
--- </code>
---
--- To override behavior of a key, simply set the value
--- to be a function (either by requiring an action or by writing
--- your own function)
--- <code>
---   {
---     ...,
---     ["<C-i>"] = require('telescope.actions').select_default,
---     ...,
---   }
--- </code>
---
---  If the function you want is part of `telescope.actions`, then you can
---  simply supply the function name as a string.
---    For example, the previous option is equivalent to:
--- <code>
---   {
---     ...,
---     ["<C-i>"] = "select_default",
---     ...,
---   }
--- </code>
---
---  You can also add other mappings using tables with `type = "command"`.
---    For example:
--- <code>
---   {
---     ...,
---     ["jj"] = { "<esc>", type = "command" },
---     ["kk"] = { "<cmd>echo \"Hello, World!\"<cr>", type = "command" },)
---     ...,
---   }
--- </code>
---
--- You can also add additional options for mappings of any type ("action" and "command").
---   For example:
--- <code>
---   {
---     ...,
---     ["<C-j>"] = {
---       actions.move_selection_next, type = "action",
---       opts = { nowait = true, silent = true }
---     },
---     ...,
---   }
--- </code>
---
--- There are three main places you can configure |telescope.mappings|. These are
--- ordered from the lowest priority to the highest priority.
---
--- 1. |telescope.defaults.mappings|
--- 2. In the |telescope.setup()| table, inside a picker with a given name, use the `mappings` key
--- <code>
---   require("telescope").setup {
---     pickers = {
---       find_files = {
---         mappings = {
---           n = {
---             ["kj"] = "close",
---           },
---         },
---       },
---     },
---   }
--- </code>
--- 3. `attach_mappings` function for a particular picker.
--- <code>
---   require("telescope.builtin").find_files {
---     attach_mappings = function(_, map)
---       map("i", "asdf", function(_prompt_bufnr)
---         print "You typed asdf"
---       end)
---
---       map({"i", "n"}, "<C-r>", function(_prompt_bufnr)
---         print "You typed <C-r>"
---       end)
---
---       -- needs to return true if you want to map default_mappings and
---       -- false if not
---       return true
---     end,
---   }
--- </code>
---@brief ]]

local a = vim.api

local actions = require "telescope.actions"
local config = require "telescope.config"

local mappings = {}

mappings.default_mappings = config.values.default_mappings
  or {
    i = {
      ["<C-n>"] = actions.move_selection_next,
      ["<C-p>"] = actions.move_selection_previous,

      ["<C-c>"] = actions.close,

      ["<Down>"] = actions.move_selection_next,
      ["<Up>"] = actions.move_selection_previous,

      ["<CR>"] = actions.select_default,
      ["<C-x>"] = actions.select_horizontal,
      ["<C-v>"] = actions.select_vertical,
      ["<C-t>"] = actions.select_tab,

      ["<C-u>"] = actions.preview_scrolling_up,
      ["<C-d>"] = actions.preview_scrolling_down,

      ["<PageUp>"] = actions.results_scrolling_up,
      ["<PageDown>"] = actions.results_scrolling_down,

      ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
      ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
      ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      ["<C-l>"] = actions.complete_tag,
      ["<C-/>"] = actions.which_key,
      ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      ["<C-w>"] = { "<c-s-w>", type = "command" },

      -- disable c-j because we dont want to allow new lines #2123
      ["<C-j>"] = actions.nop,
    },

    n = {
      ["<esc>"] = actions.close,
      ["<CR>"] = actions.select_default,
      ["<C-x>"] = actions.select_horizontal,
      ["<C-v>"] = actions.select_vertical,
      ["<C-t>"] = actions.select_tab,

      ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
      ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
      ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

      -- TODO: This would be weird if we switch the ordering.
      ["j"] = actions.move_selection_next,
      ["k"] = actions.move_selection_previous,
      ["H"] = actions.move_to_top,
      ["M"] = actions.move_to_middle,
      ["L"] = actions.move_to_bottom,

      ["<Down>"] = actions.move_selection_next,
      ["<Up>"] = actions.move_selection_previous,
      ["gg"] = actions.move_to_top,
      ["G"] = actions.move_to_bottom,

      ["<C-u>"] = actions.preview_scrolling_up,
      ["<C-d>"] = actions.preview_scrolling_down,

      ["<PageUp>"] = actions.results_scrolling_up,
      ["<PageDown>"] = actions.results_scrolling_down,

      ["?"] = actions.which_key,
    },
  }

-- normal names are prefixed with telescope|
-- encoded objects are prefixed with telescopej|
local get_desc_for_keyfunc = function(v)
  if type(v) == "table" then
    local name = ""
    for _, action in ipairs(v) do
      if type(action) == "string" then
        name = name == "" and action or name .. " + " .. action
      end
    end
    return "telescope|" .. name
  elseif type(v) == "function" then
    local info = debug.getinfo(v)
    return "telescopej|" .. vim.json.encode { source = info.source, linedefined = info.linedefined }
  end
end

local telescope_map = function(prompt_bufnr, mode, key_bind, key_func, opts)
  if not key_func then
    return
  end

  opts = opts or {}
  if opts.noremap == nil then
    opts.noremap = true
  end
  if opts.silent == nil then
    opts.silent = true
  end

  if type(key_func) == "string" then
    key_func = actions[key_func]
  elseif type(key_func) == "table" then
    if key_func.type == "command" then
      vim.keymap.set(
        mode,
        key_bind,
        key_func[1],
        vim.tbl_extend("force", opts or {
          silent = true,
        }, { buffer = prompt_bufnr })
      )
      return
    elseif key_func.type == "action_key" then
      key_func = actions[key_func[1]]
    elseif key_func.type == "action" then
      key_func = key_func[1]
    end
  end

  vim.keymap.set(mode, key_bind, function()
    local ret = key_func(prompt_bufnr)
    vim.api.nvim_exec_autocmds("User", { pattern = "TelescopeKeymap" })
    return ret
  end, vim.tbl_extend("force", opts, { buffer = prompt_bufnr, desc = get_desc_for_keyfunc(key_func) }))
end

local extract_keymap_opts = function(key_func)
  if type(key_func) == "table" and key_func.opts ~= nil then
    -- we can't clear this because key_func could be a table from the config.
    -- If we clear it the table ref would lose opts after the first bind
    -- We need to copy it so noremap and silent won't be part of the table ref after the first bind
    return vim.deepcopy(key_func.opts)
  end
  return {}
end

mappings.apply_keymap = function(prompt_bufnr, attach_mappings, buffer_keymap)
  local applied_mappings = { n = {}, i = {} }

  local map = function(modes, key_bind, key_func, opts)
    if type(modes) == "string" then
      modes = { modes }
    end

    for _, mode in pairs(modes) do
      mode = string.lower(mode)
      local key_bind_internal = a.nvim_replace_termcodes(key_bind, true, true, true)
      applied_mappings[mode][key_bind_internal] = true

      telescope_map(prompt_bufnr, mode, key_bind, key_func, opts)
    end
  end

  if attach_mappings then
    local attach_results = attach_mappings(prompt_bufnr, map)

    if attach_results == nil then
      error(
        "Attach mappings must always return a value. `true` means use default mappings, "
          .. "`false` means only use attached mappings"
      )
    end

    if not attach_results then
      return
    end
  end

  for mode, mode_map in pairs(buffer_keymap or {}) do
    mode = string.lower(mode)

    for key_bind, key_func in pairs(mode_map) do
      local key_bind_internal = a.nvim_replace_termcodes(key_bind, true, true, true)
      if not applied_mappings[mode][key_bind_internal] then
        applied_mappings[mode][key_bind_internal] = true
        telescope_map(prompt_bufnr, mode, key_bind, key_func, extract_keymap_opts(key_func))
      end
    end
  end

  -- TODO: Probably should not overwrite any keymaps
  for mode, mode_map in pairs(mappings.default_mappings) do
    mode = string.lower(mode)

    for key_bind, key_func in pairs(mode_map) do
      local key_bind_internal = a.nvim_replace_termcodes(key_bind, true, true, true)
      if not applied_mappings[mode][key_bind_internal] then
        applied_mappings[mode][key_bind_internal] = true
        telescope_map(prompt_bufnr, mode, key_bind, key_func, extract_keymap_opts(key_func))
      end
    end
  end
end

return mappings
