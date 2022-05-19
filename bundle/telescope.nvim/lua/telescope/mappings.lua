-- TODO: Customize keymap
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
      ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      ["<C-w>"] = { "<c-s-w>", type = "command" },
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

__TelescopeKeymapStore = __TelescopeKeymapStore
  or setmetatable({}, {
    __index = function(t, k)
      rawset(t, k, {})

      return rawget(t, k)
    end,
  })
local keymap_store = __TelescopeKeymapStore

local _mapping_key_id = 0
local get_next_id = function()
  _mapping_key_id = _mapping_key_id + 1
  return _mapping_key_id
end

local assign_function = function(prompt_bufnr, func)
  local func_id = get_next_id()

  keymap_store[prompt_bufnr][func_id] = func

  return func_id
end

--[[
Usage:

mappings.apply_keymap(42, <function>, {
  n = {
    ["<leader>x"] = "just do this string",

    ["<CR>"] = function(picker, prompt_bufnr)
      actions.close_prompt()

>     local filename = ...
      vim.cmd(string.format(":e %s", filename))
    end,
  },

  i = {
  }
})
--]]
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
      a.nvim_buf_set_keymap(prompt_bufnr, mode, key_bind, key_func[1], opts or {
        silent = true,
      })
      return
    elseif key_func.type == "action_key" then
      key_func = actions[key_func[1]]
    elseif key_func.type == "action" then
      key_func = key_func[1]
    end
  end

  local key_id = assign_function(prompt_bufnr, key_func)
  local prefix

  local map_string
  if opts.expr then
    map_string = string.format(
      [[luaeval("require('telescope.mappings').execute_keymap(%s, %s)")]],
      prompt_bufnr,
      key_id
    )
  else
    if mode == "i" and not opts.expr then
      prefix = "<cmd>"
    elseif mode == "n" then
      prefix = ":<C-U>"
    else
      prefix = ":"
    end

    map_string = string.format(
      "%slua require('telescope.mappings').execute_keymap(%s, %s)<CR>",
      prefix,
      prompt_bufnr,
      key_id
    )
  end

  a.nvim_buf_set_keymap(prompt_bufnr, mode, key_bind, map_string, opts)
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

  local map = function(mode, key_bind, key_func, opts)
    mode = string.lower(mode)
    local key_bind_internal = a.nvim_replace_termcodes(key_bind, true, true, true)
    applied_mappings[mode][key_bind_internal] = true

    telescope_map(prompt_bufnr, mode, key_bind, key_func, opts)
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

mappings.execute_keymap = function(prompt_bufnr, keymap_identifier)
  local key_func = keymap_store[prompt_bufnr][keymap_identifier]

  assert(key_func, string.format("Unsure of how we got this failure: %s %s", prompt_bufnr, keymap_identifier))

  key_func(prompt_bufnr)
  vim.api.nvim_exec_autocmds("User TelescopeKeymap", {})
end

mappings.clear = function(prompt_bufnr)
  keymap_store[prompt_bufnr] = nil
end

return mappings
