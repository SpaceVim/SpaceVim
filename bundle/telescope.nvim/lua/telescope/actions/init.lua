---@tag telescope.actions
---@config { ["module"] = "telescope.actions" }

---@brief [[
--- Actions functions that are useful for people creating their own mappings.
---
--- Actions can be either normal functions that expect the prompt_bufnr as
--- first argument (1) or they can be a custom telescope type called "action" (2).
---
--- (1) The `prompt_bufnr` of a normal function denotes the identifier of your
--- picker which can be used to access the picker state. In practice, users
--- most commonly access from both picker and global state via the following:
--- <code>
---   -- for utility functions
---   local action_state = require "telescope.actions.state"
---
---   local actions = {}
---   actions.do_stuff = function(prompt_bufnr)
---     local current_picker = action_state.get_current_picker(prompt_bufnr) -- picker state
---     local entry = action_state.get_selected_entry()
---   end
--- </code>
---
--- See |telescope.actions.state| for more information.
---
--- (2) To transform a module of functions into a module of "action"s, you need
--- to do the following:
--- <code>
---   local transform_mod = require("telescope.actions.mt").transform_mod
---
---   local mod = {}
---   mod.a1 = function(prompt_bufnr)
---     -- your code goes here
---     -- You can access the picker/global state as described above in (1).
---   end
---
---   mod.a2 = function(prompt_bufnr)
---     -- your code goes here
---   end
---   mod = transform_mod(mod)
---
---   -- Now the following is possible. This means that actions a2 will be executed
---   -- after action a1. You can chain as many actions as you want.
---   local action = mod.a1 + mod.a2
---   action(bufnr)
--- </code>
---
--- Another interesing thing to do is that these actions now have functions you
--- can call. These functions include `:replace(f)`, `:replace_if(f, c)`,
--- `replace_map(tbl)` and `enhance(tbl)`. More information on these functions
--- can be found in the `developers.md` and `lua/tests/automated/action_spec.lua`
--- file.
---@brief ]]

local a = vim.api

local conf = require("telescope.config").values
local state = require "telescope.state"
local utils = require "telescope.utils"
local popup = require "plenary.popup"
local p_scroller = require "telescope.pickers.scroller"

local action_state = require "telescope.actions.state"
local action_utils = require "telescope.actions.utils"
local action_set = require "telescope.actions.set"
local entry_display = require "telescope.pickers.entry_display"
local from_entry = require "telescope.from_entry"

local transform_mod = require("telescope.actions.mt").transform_mod
local resolver = require "telescope.config.resolve"

local actions = setmetatable({}, {
  __index = function(_, k)
    error("Key does not exist for 'telescope.actions': " .. tostring(k))
  end,
})

--- Move the selection to the next entry
---@param prompt_bufnr number: The prompt bufnr
actions.move_selection_next = function(prompt_bufnr)
  action_set.shift_selection(prompt_bufnr, 1)
end

--- Move the selection to the previous entry
---@param prompt_bufnr number: The prompt bufnr
actions.move_selection_previous = function(prompt_bufnr)
  action_set.shift_selection(prompt_bufnr, -1)
end

--- Move the selection to the entry that has a worse score
---@param prompt_bufnr number: The prompt bufnr
actions.move_selection_worse = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  action_set.shift_selection(prompt_bufnr, p_scroller.worse(picker.sorting_strategy))
end

--- Move the selection to the entry that has a better score
---@param prompt_bufnr number: The prompt bufnr
actions.move_selection_better = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  action_set.shift_selection(prompt_bufnr, p_scroller.better(picker.sorting_strategy))
end

--- Move to the top of the picker
---@param prompt_bufnr number: The prompt bufnr
actions.move_to_top = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:set_selection(
    p_scroller.top(current_picker.sorting_strategy, current_picker.max_results, current_picker.manager:num_results())
  )
end

--- Move to the middle of the picker
---@param prompt_bufnr number: The prompt bufnr
actions.move_to_middle = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:set_selection(
    p_scroller.middle(current_picker.sorting_strategy, current_picker.max_results, current_picker.manager:num_results())
  )
end

--- Move to the bottom of the picker
---@param prompt_bufnr number: The prompt bufnr
actions.move_to_bottom = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:set_selection(
    p_scroller.bottom(current_picker.sorting_strategy, current_picker.max_results, current_picker.manager:num_results())
  )
end

--- Add current entry to multi select
---@param prompt_bufnr number: The prompt bufnr
actions.add_selection = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:add_selection(current_picker:get_selection_row())
end

--- Remove current entry from multi select
---@param prompt_bufnr number: The prompt bufnr
actions.remove_selection = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:remove_selection(current_picker:get_selection_row())
end

--- Toggle current entry status for multi select
---@param prompt_bufnr number: The prompt bufnr
actions.toggle_selection = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:toggle_selection(current_picker:get_selection_row())
end

--- Multi select all entries.
--- - Note: selected entries may include results not visible in the results popup.
---@param prompt_bufnr number: The prompt bufnr
actions.select_all = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  action_utils.map_entries(prompt_bufnr, function(entry, _, row)
    if not current_picker._multi:is_selected(entry) then
      current_picker._multi:add(entry)
      if current_picker:can_select_row(row) then
        local caret = current_picker:update_prefix(entry, row)
        if current_picker._selection_entry == entry and current_picker._selection_row == row then
          current_picker.highlighter:hi_selection(row, caret:match "(.*%S)")
        end
        current_picker.highlighter:hi_multiselect(row, current_picker._multi:is_selected(entry))
      end
    end
  end)
  current_picker:get_status_updater(current_picker.prompt_win, current_picker.prompt_bufnr)()
end

--- Drop all entries from the current multi selection.
---@param prompt_bufnr number: The prompt bufnr
actions.drop_all = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  action_utils.map_entries(prompt_bufnr, function(entry, _, row)
    current_picker._multi:drop(entry)
    if current_picker:can_select_row(row) then
      local caret = current_picker:update_prefix(entry, row)
      if current_picker._selection_entry == entry and current_picker._selection_row == row then
        current_picker.highlighter:hi_selection(row, caret:match "(.*%S)")
      end
      current_picker.highlighter:hi_multiselect(row, current_picker._multi:is_selected(entry))
    end
  end)
  current_picker:get_status_updater(current_picker.prompt_win, current_picker.prompt_bufnr)()
end

--- Toggle multi selection for all entries.
--- - Note: toggled entries may include results not visible in the results popup.
---@param prompt_bufnr number: The prompt bufnr
actions.toggle_all = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  action_utils.map_entries(prompt_bufnr, function(entry, _, row)
    current_picker._multi:toggle(entry)
    if current_picker:can_select_row(row) then
      local caret = current_picker:update_prefix(entry, row)
      if current_picker._selection_entry == entry and current_picker._selection_row == row then
        current_picker.highlighter:hi_selection(row, caret:match "(.*%S)")
      end
      current_picker.highlighter:hi_multiselect(row, current_picker._multi:is_selected(entry))
    end
  end)
  current_picker:get_status_updater(current_picker.prompt_win, current_picker.prompt_bufnr)()
end

--- Scroll the preview window up
---@param prompt_bufnr number: The prompt bufnr
actions.preview_scrolling_up = function(prompt_bufnr)
  action_set.scroll_previewer(prompt_bufnr, -1)
end

--- Scroll the preview window down
---@param prompt_bufnr number: The prompt bufnr
actions.preview_scrolling_down = function(prompt_bufnr)
  action_set.scroll_previewer(prompt_bufnr, 1)
end

--- Scroll the results window up
---@param prompt_bufnr number: The prompt bufnr
actions.results_scrolling_up = function(prompt_bufnr)
  action_set.scroll_results(prompt_bufnr, -1)
end

--- Scroll the results window down
---@param prompt_bufnr number: The prompt bufnr
actions.results_scrolling_down = function(prompt_bufnr)
  action_set.scroll_results(prompt_bufnr, 1)
end

--- Center the cursor in the window, can be used after selecting a file to edit
--- You can just map `actions.select_default + actions.center`
---@param prompt_bufnr number: The prompt bufnr
actions.center = function(prompt_bufnr)
  vim.cmd ":normal! zz"
end

--- Perform default action on selection, usually something like<br>
--- `:edit <selection>`
---
--- i.e. open the selection in the current buffer
---@param prompt_bufnr number: The prompt bufnr
actions.select_default = {
  pre = function(prompt_bufnr)
    action_state
      .get_current_history()
      :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  end,
  action = function(prompt_bufnr)
    return action_set.select(prompt_bufnr, "default")
  end,
}

--- Perform 'horizontal' action on selection, usually something like<br>
---`:new <selection>`
---
--- i.e. open the selection in a new horizontal split
---@param prompt_bufnr number: The prompt bufnr
actions.select_horizontal = {
  pre = function(prompt_bufnr)
    action_state
      .get_current_history()
      :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  end,
  action = function(prompt_bufnr)
    return action_set.select(prompt_bufnr, "horizontal")
  end,
}

--- Perform 'vertical' action on selection, usually something like<br>
---`:vnew <selection>`
---
--- i.e. open the selection in a new vertical split
---@param prompt_bufnr number: The prompt bufnr
actions.select_vertical = {
  pre = function(prompt_bufnr)
    action_state
      .get_current_history()
      :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  end,
  action = function(prompt_bufnr)
    return action_set.select(prompt_bufnr, "vertical")
  end,
}

--- Perform 'tab' action on selection, usually something like<br>
---`:tabedit <selection>`
---
--- i.e. open the selection in a new tab
---@param prompt_bufnr number: The prompt bufnr
actions.select_tab = {
  pre = function(prompt_bufnr)
    action_state
      .get_current_history()
      :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  end,
  action = function(prompt_bufnr)
    return action_set.select(prompt_bufnr, "tab")
  end,
}

--- Perform 'drop' action on selection, usually something like<br>
---`:drop <selection>`
---
--- i.e. open the selection in a window
---@param prompt_bufnr number: The prompt bufnr
actions.select_drop = {
  pre = function(prompt_bufnr)
    action_state
      .get_current_history()
      :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  end,
  action = function(prompt_bufnr)
    return action_set.select(prompt_bufnr, "drop")
  end,
}

--- Perform 'tab drop' action on selection, usually something like<br>
---`:tab drop <selection>`
---
--- i.e. open the selection in a new tab
---@param prompt_bufnr number: The prompt bufnr
actions.select_tab_drop = {
  pre = function(prompt_bufnr)
    action_state
      .get_current_history()
      :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  end,
  action = function(prompt_bufnr)
    return action_set.select(prompt_bufnr, "tab drop")
  end,
}

-- TODO: consider adding float!
-- https://github.com/nvim-telescope/telescope.nvim/issues/365

--- Perform file edit on selection, usually something like<br>
--- `:edit <selection>`
---@param prompt_bufnr number: The prompt bufnr
actions.file_edit = function(prompt_bufnr)
  return action_set.edit(prompt_bufnr, "edit")
end

--- Perform file split on selection, usually something like<br>
--- `:new <selection>`
---@param prompt_bufnr number: The prompt bufnr
actions.file_split = function(prompt_bufnr)
  return action_set.edit(prompt_bufnr, "new")
end

--- Perform file vsplit on selection, usually something like<br>
--- `:vnew <selection>`
---@param prompt_bufnr number: The prompt bufnr
actions.file_vsplit = function(prompt_bufnr)
  return action_set.edit(prompt_bufnr, "vnew")
end

--- Perform file tab on selection, usually something like<br>
--- `:tabedit <selection>`
---@param prompt_bufnr number: The prompt bufnr
actions.file_tab = function(prompt_bufnr)
  return action_set.edit(prompt_bufnr, "tabedit")
end

actions.close_pum = function(_)
  if 0 ~= vim.fn.pumvisible() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-y>", true, true, true), "n", true)
  end
end

--- Close the Telescope window, usually used within an action
---@param prompt_bufnr number: The prompt bufnr
actions.close = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local original_win_id = picker.original_win_id
  local cursor_valid, original_cursor = pcall(a.nvim_win_get_cursor, original_win_id)

  actions.close_pum(prompt_bufnr)

  require("telescope.pickers").on_close_prompt(prompt_bufnr)
  pcall(a.nvim_set_current_win, original_win_id)
  if cursor_valid and a.nvim_get_mode().mode == "i" and picker._original_mode ~= "i" then
    pcall(a.nvim_win_set_cursor, original_win_id, { original_cursor[1], original_cursor[2] + 1 })
  end
end

--- Close the Telescope window, usually used within an action<br>
--- Deprecated and no longer needed, does the same as |telescope.actions.close|. Might be removed in the future
---@deprecated
---@param prompt_bufnr number: The prompt bufnr
actions._close = function(prompt_bufnr)
  actions.close(prompt_bufnr)
end

local set_edit_line = function(prompt_bufnr, fname, prefix, postfix)
  postfix = vim.F.if_nil(postfix, "")
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection(fname)
    return
  end
  actions.close(prompt_bufnr)
  a.nvim_feedkeys(a.nvim_replace_termcodes(prefix .. selection.value .. postfix, true, false, true), "t", true)
end

--- Set a value in the command line and dont run it, making it editable.
---@param prompt_bufnr number: The prompt bufnr
actions.edit_command_line = function(prompt_bufnr)
  set_edit_line(prompt_bufnr, "actions.edit_command_line", ":")
end

--- Set a value in the command line and run it
---@param prompt_bufnr number: The prompt bufnr
actions.set_command_line = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.set_command_line"
    return
  end
  actions.close(prompt_bufnr)
  vim.fn.histadd("cmd", selection.value)
  vim.cmd(selection.value)
end

--- Set a value in the search line and dont search for it, making it editable.
---@param prompt_bufnr number: The prompt bufnr
actions.edit_search_line = function(prompt_bufnr)
  set_edit_line(prompt_bufnr, "actions.edit_search_line", "/")
end

--- Set a value in the search line and search for it
---@param prompt_bufnr number: The prompt bufnr
actions.set_search_line = function(prompt_bufnr)
  set_edit_line(prompt_bufnr, "actions.set_search_line", "/", "<CR>")
end

--- Edit a register
---@param prompt_bufnr number: The prompt bufnr
actions.edit_register = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local picker = action_state.get_current_picker(prompt_bufnr)

  vim.fn.inputsave()
  local updated_value = vim.fn.input("Edit [" .. selection.value .. "] ❯ ", selection.content)
  vim.fn.inputrestore()
  if updated_value ~= selection.content then
    vim.fn.setreg(selection.value, updated_value)
    selection.content = updated_value
  end

  -- update entry in results table
  -- TODO: find way to redraw finder content
  for _, v in pairs(picker.finder.results) do
    if v == selection then
      v.content = updated_value
    end
  end
  -- print(vim.inspect(picker.finder.results))
end

--- Paste the selected register into the buffer
---
--- Note: only meant to be used inside builtin.registers
---@param prompt_bufnr number: The prompt bufnr
actions.paste_register = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.paste_register"
    return
  end

  actions.close(prompt_bufnr)

  -- ensure that the buffer can be written to
  if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
    vim.api.nvim_paste(selection.content, true, -1)
  end
end

--- Insert a symbol into the current buffer (while switching to normal mode)
---@param prompt_bufnr number: The prompt bufnr
actions.insert_symbol = function(prompt_bufnr)
  local symbol = action_state.get_selected_entry().value[1]
  actions.close(prompt_bufnr)
  vim.api.nvim_put({ symbol }, "", true, true)
end

--- Insert a symbol into the current buffer and keeping the insert mode.
---@param prompt_bufnr number: The prompt bufnr
actions.insert_symbol_i = function(prompt_bufnr)
  local symbol = action_state.get_selected_entry().value[1]
  actions.close(prompt_bufnr)
  vim.schedule(function()
    vim.cmd [[startinsert]]
    vim.api.nvim_put({ symbol }, "", true, true)
  end)
end

-- TODO: Think about how to do this.
actions.insert_value = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.insert_value"
    return
  end

  vim.schedule(function()
    actions.close(prompt_bufnr)
  end)

  return selection.value
end

--- Create and checkout a new git branch if it doesn't already exist
---@param prompt_bufnr number: The prompt bufnr
actions.git_create_branch = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local new_branch = action_state.get_current_line()

  if new_branch == "" then
    utils.notify("actions.git_create_branch", {
      msg = "Missing the new branch name",
      level = "ERROR",
    })
  else
    local confirmation = vim.fn.input(string.format("Create new branch '%s'? [y/n]: ", new_branch))
    if string.len(confirmation) == 0 or string.sub(string.lower(confirmation), 0, 1) ~= "y" then
      utils.notify("actions.git_create_branch", {
        msg = string.format("fail to create branch: '%s'", new_branch),
        level = "ERROR",
      })
      return
    end

    actions.close(prompt_bufnr)

    local _, ret, stderr = utils.get_os_command_output({ "git", "checkout", "-b", new_branch }, cwd)
    if ret == 0 then
      utils.notify("actions.git_create_branch", {
        msg = string.format("Switched to a new branch: %s", new_branch),
        level = "INFO",
      })
    else
      utils.notify("actions.git_create_branch", {
        msg = string.format(
          "Error when creating new branch: '%s' Git returned '%s'",
          new_branch,
          table.concat(stderr, " ")
        ),
        level = "INFO",
      })
    end
  end
end

--- Applies an existing git stash
---@param prompt_bufnr number: The prompt bufnr
actions.git_apply_stash = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.git_apply_stash"
    return
  end
  actions.close(prompt_bufnr)
  local _, ret, stderr = utils.get_os_command_output { "git", "stash", "apply", "--index", selection.value }
  if ret == 0 then
    utils.notify("actions.git_apply_stash", {
      msg = string.format("applied: '%s' ", selection.value),
      level = "INFO",
    })
  else
    utils.notify("actions.git_apply_stash", {
      msg = string.format("Error when applying: %s. Git returned: '%s'", selection.value, table.concat(stderr, " ")),
      level = "ERROR",
    })
  end
end

--- Checkout an existing git branch
---@param prompt_bufnr number: The prompt bufnr
actions.git_checkout = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.git_checkout"
    return
  end
  actions.close(prompt_bufnr)
  local _, ret, stderr = utils.get_os_command_output({ "git", "checkout", selection.value }, cwd)
  if ret == 0 then
    utils.notify("actions.git_checkout", {
      msg = string.format("Checked out: %s", selection.value),
      level = "INFO",
    })
    vim.cmd "checktime"
  else
    utils.notify("actions.git_checkout", {
      msg = string.format(
        "Error when checking out: %s. Git returned: '%s'",
        selection.value,
        table.concat(stderr, " ")
      ),
      level = "ERROR",
    })
  end
end

--- Switch to git branch.<br>
--- If the branch already exists in local, switch to that.
--- If the branch is only in remote, create new branch tracking remote and switch to new one.
---@param prompt_bufnr number: The prompt bufnr
actions.git_switch_branch = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.git_switch_branch"
    return
  end
  actions.close(prompt_bufnr)
  local pattern = "^refs/remotes/%w+/"
  local branch = selection.value
  if string.match(selection.refname, pattern) then
    branch = string.gsub(selection.refname, pattern, "")
  end
  local _, ret, stderr = utils.get_os_command_output({ "git", "switch", branch }, cwd)
  if ret == 0 then
    utils.notify("actions.git_switch_branch", {
      msg = string.format("Switched to: '%s'", branch),
      level = "INFO",
    })
  else
    utils.notify("actions.git_switch_branch", {
      msg = string.format(
        "Error when switching to: %s. Git returned: '%s'",
        selection.value,
        table.concat(stderr, " ")
      ),
      level = "ERROR",
    })
  end
end

local function make_git_branch_action(opts)
  return function(prompt_bufnr)
    local cwd = action_state.get_current_picker(prompt_bufnr).cwd
    local selection = action_state.get_selected_entry()
    if selection == nil then
      utils.__warn_no_selection(opts.action_name)
      return
    end

    local should_confirm = opts.should_confirm
    if should_confirm then
      local confirmation = vim.fn.input(string.format(opts.confirmation_question, selection.value))
      if confirmation ~= "" and string.lower(confirmation) ~= "y" then
        return
      end
    end

    actions.close(prompt_bufnr)
    local _, ret, stderr = utils.get_os_command_output(opts.command(selection.value), cwd)
    if ret == 0 then
      utils.notify(opts.action_name, {
        msg = string.format(opts.success_message, selection.value),
        level = "INFO",
      })
    else
      utils.notify(opts.action_name, {
        msg = string.format(opts.error_message, selection.value, table.concat(stderr, " ")),
        level = "ERROR",
      })
    end
  end
end

--- Tell git to track the currently selected remote branch in Telescope
---@param prompt_bufnr number: The prompt bufnr
actions.git_track_branch = make_git_branch_action {
  should_confirm = false,
  action_name = "actions.git_track_branch",
  success_message = "Tracking branch: %s",
  error_message = "Error when tracking branch: %s. Git returned: '%s'",
  command = function(branch_name)
    return { "git", "checkout", "--track", branch_name }
  end,
}

--- Delete the currently selected branch
---@param prompt_bufnr number: The prompt bufnr
actions.git_delete_branch = make_git_branch_action {
  should_confirm = true,
  action_name = "actions.git_delete_branch",
  confirmation_question = "Do you really wanna delete branch %s? [Y/n] ",
  success_message = "Deleted branch: %s",
  error_message = "Error when deleting branch: %s. Git returned: '%s'",
  command = function(branch_name)
    return { "git", "branch", "-D", branch_name }
  end,
}

--- Merge the currently selected branch
---@param prompt_bufnr number: The prompt bufnr
actions.git_merge_branch = make_git_branch_action {
  should_confirm = true,
  action_name = "actions.git_merge_branch",
  confirmation_question = "Do you really wanna merge branch %s? [Y/n] ",
  success_message = "Merged branch: %s",
  error_message = "Error when merging branch: %s. Git returned: '%s'",
  command = function(branch_name)
    return { "git", "merge", branch_name }
  end,
}

--- Rebase to selected git branch
---@param prompt_bufnr number: The prompt bufnr
actions.git_rebase_branch = make_git_branch_action {
  should_confirm = true,
  action_name = "actions.git_rebase_branch",
  confirmation_question = "Do you really wanna rebase branch %s? [Y/n] ",
  success_message = "Rebased branch: %s",
  error_message = "Error when rebasing branch: %s. Git returned: '%s'",
  command = function(branch_name)
    return { "git", "rebase", branch_name }
  end,
}

local git_reset_branch = function(prompt_bufnr, mode)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.git_reset_branch"
    return
  end

  local confirmation = vim.fn.input("Do you really wanna " .. mode .. " reset to " .. selection.value .. "? [Y/n] ")
  if confirmation ~= "" and string.lower(confirmation) ~= "y" then
    return
  end

  actions.close(prompt_bufnr)
  local _, ret, stderr = utils.get_os_command_output({ "git", "reset", mode, selection.value }, cwd)
  if ret == 0 then
    utils.notify("actions.git_rebase_branch", {
      msg = string.format("Reset to: '%s'", selection.value),
      level = "INFO",
    })
  else
    utils.notify("actions.git_rebase_branch", {
      msg = string.format("Rest to: %s. Git returned: '%s'", selection.value, table.concat(stderr, " ")),
      level = "ERROR",
    })
  end
end

--- Reset to selected git commit using mixed mode
---@param prompt_bufnr number: The prompt bufnr
actions.git_reset_mixed = function(prompt_bufnr)
  git_reset_branch(prompt_bufnr, "--mixed")
end

--- Reset to selected git commit using soft mode
---@param prompt_bufnr number: The prompt bufnr
actions.git_reset_soft = function(prompt_bufnr)
  git_reset_branch(prompt_bufnr, "--soft")
end

--- Reset to selected git commit using hard mode
---@param prompt_bufnr number: The prompt bufnr
actions.git_reset_hard = function(prompt_bufnr)
  git_reset_branch(prompt_bufnr, "--hard")
end

--- Checkout a specific file for a given sha
---@param prompt_bufnr number: The prompt bufnr
actions.git_checkout_current_buffer = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.git_checkout_current_buffer"

    return
  end
  actions.close(prompt_bufnr)
  utils.get_os_command_output({ "git", "checkout", selection.value, "--", selection.file }, cwd)
  vim.cmd "checktime"
end

--- Stage/unstage selected file
---@param prompt_bufnr number: The prompt bufnr
actions.git_staging_toggle = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection "actions.git_staging_toggle"
    return
  end
  if selection.status:sub(2) == " " then
    utils.get_os_command_output({ "git", "restore", "--staged", selection.value }, cwd)
  else
    utils.get_os_command_output({ "git", "add", selection.value }, cwd)
  end
end

local entry_to_qf = function(entry)
  local text = entry.text

  if not text then
    if type(entry.value) == "table" then
      text = entry.value.text
    else
      text = entry.value
    end
  end

  return {
    bufnr = entry.bufnr,
    filename = from_entry.path(entry, false, false),
    lnum = vim.F.if_nil(entry.lnum, 1),
    col = vim.F.if_nil(entry.col, 1),
    text = text,
  }
end

local send_selected_to_qf = function(prompt_bufnr, mode, target)
  local picker = action_state.get_current_picker(prompt_bufnr)

  local qf_entries = {}
  for _, entry in ipairs(picker:get_multi_selection()) do
    table.insert(qf_entries, entry_to_qf(entry))
  end

  local prompt = picker:_get_prompt()
  actions.close(prompt_bufnr)

  if target == "loclist" then
    vim.fn.setloclist(picker.original_win_id, qf_entries, mode)
  else
    local qf_title = string.format([[%s (%s)]], picker.prompt_title, prompt)
    vim.fn.setqflist(qf_entries, mode)
    vim.fn.setqflist({}, "a", { title = qf_title })
  end
end

local send_all_to_qf = function(prompt_bufnr, mode, target)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local manager = picker.manager

  local qf_entries = {}
  for entry in manager:iter() do
    table.insert(qf_entries, entry_to_qf(entry))
  end

  local prompt = picker:_get_prompt()
  actions.close(prompt_bufnr)

  if target == "loclist" then
    vim.fn.setloclist(picker.original_win_id, qf_entries, mode)
  else
    vim.fn.setqflist(qf_entries, mode)
    local qf_title = string.format([[%s (%s)]], picker.prompt_title, prompt)
    vim.fn.setqflist({}, "a", { title = qf_title })
  end
end

--- Sends the selected entries to the quickfix list, replacing the previous entries.
---@param prompt_bufnr number: The prompt bufnr
actions.send_selected_to_qflist = function(prompt_bufnr)
  send_selected_to_qf(prompt_bufnr, " ")
end

--- Adds the selected entries to the quickfix list, keeping the previous entries.
---@param prompt_bufnr number: The prompt bufnr
actions.add_selected_to_qflist = function(prompt_bufnr)
  send_selected_to_qf(prompt_bufnr, "a")
end

--- Sends all entries to the quickfix list, replacing the previous entries.
---@param prompt_bufnr number: The prompt bufnr
actions.send_to_qflist = function(prompt_bufnr)
  send_all_to_qf(prompt_bufnr, " ")
end

--- Adds all entries to the quickfix list, keeping the previous entries.
---@param prompt_bufnr number: The prompt bufnr
actions.add_to_qflist = function(prompt_bufnr)
  send_all_to_qf(prompt_bufnr, "a")
end

--- Sends the selected entries to the location list, replacing the previous entries.
---@param prompt_bufnr number: The prompt bufnr
actions.send_selected_to_loclist = function(prompt_bufnr)
  send_selected_to_qf(prompt_bufnr, " ", "loclist")
end

--- Adds the selected entries to the location list, keeping the previous entries.
---@param prompt_bufnr number: The prompt bufnr
actions.add_selected_to_loclist = function(prompt_bufnr)
  send_selected_to_qf(prompt_bufnr, "a", "loclist")
end

--- Sends all entries to the location list, replacing the previous entries.
---@param prompt_bufnr number: The prompt bufnr
actions.send_to_loclist = function(prompt_bufnr)
  send_all_to_qf(prompt_bufnr, " ", "loclist")
end

--- Adds all entries to the location list, keeping the previous entries.
---@param prompt_bufnr number: The prompt bufnr
actions.add_to_loclist = function(prompt_bufnr)
  send_all_to_qf(prompt_bufnr, "a", "loclist")
end

local smart_send = function(prompt_bufnr, mode, target)
  local picker = action_state.get_current_picker(prompt_bufnr)
  if #picker:get_multi_selection() > 0 then
    send_selected_to_qf(prompt_bufnr, mode, target)
  else
    send_all_to_qf(prompt_bufnr, mode, target)
  end
end

--- Sends the selected entries to the quickfix list, replacing the previous entries.
--- If no entry was selected, sends all entries.
---@param prompt_bufnr number: The prompt bufnr
actions.smart_send_to_qflist = function(prompt_bufnr)
  smart_send(prompt_bufnr, " ")
end

--- Adds the selected entries to the quickfix list, keeping the previous entries.
--- If no entry was selected, adds all entries.
---@param prompt_bufnr number: The prompt bufnr
actions.smart_add_to_qflist = function(prompt_bufnr)
  smart_send(prompt_bufnr, "a")
end

--- Sends the selected entries to the location list, replacing the previous entries.
--- If no entry was selected, sends all entries.
---@param prompt_bufnr number: The prompt bufnr
actions.smart_send_to_loclist = function(prompt_bufnr)
  smart_send(prompt_bufnr, " ", "loclist")
end

--- Adds the selected entries to the location list, keeping the previous entries.
--- If no entry was selected, adds all entries.
---@param prompt_bufnr number: The prompt bufnr
actions.smart_add_to_loclist = function(prompt_bufnr)
  smart_send(prompt_bufnr, "a", "loclist")
end

--- Open completion menu containing the tags which can be used to filter the results in a faster way
---@param prompt_bufnr number: The prompt bufnr
actions.complete_tag = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local tags = current_picker.sorter.tags
  local delimiter = current_picker.sorter._delimiter

  if not tags then
    utils.notify("actions.complete_tag", {
      msg = "No tag pre-filtering set for this picker",
      level = "ERROR",
    })

    return
  end

  -- format tags to match filter_function
  local prefilter_tags = {}
  for tag, _ in pairs(tags) do
    table.insert(prefilter_tags, string.format("%s%s%s ", delimiter, tag:lower(), delimiter))
  end

  local line = action_state.get_current_line()
  local filtered_tags = {}
  -- retrigger completion with already selected tag anew
  -- trim and add space since we can match [[:pattern: ]]  with or without space at the end
  if vim.tbl_contains(prefilter_tags, vim.trim(line) .. " ") then
    filtered_tags = prefilter_tags
  else
    -- match tag by substring
    for _, tag in pairs(prefilter_tags) do
      local start, _ = tag:find(line)
      if start then
        table.insert(filtered_tags, tag)
      end
    end
  end

  if vim.tbl_isempty(filtered_tags) then
    utils.notify("complete_tag", {
      msg = "No matches found",
      level = "INFO",
    })
    return
  end

  -- incremental completion by substituting string starting from col - #line byte offset
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  vim.fn.complete(col - #line, filtered_tags)
end

--- Cycle to the next search prompt in the history
---@param prompt_bufnr number: The prompt bufnr
actions.cycle_history_next = function(prompt_bufnr)
  local history = action_state.get_current_history()
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local line = action_state.get_current_line()

  local entry = history:get_next(line, current_picker)
  if entry == false then
    return
  end

  current_picker:reset_prompt()
  if entry ~= nil then
    current_picker:set_prompt(entry)
  end
end

--- Cycle to the previous search prompt in the history
---@param prompt_bufnr number: The prompt bufnr
actions.cycle_history_prev = function(prompt_bufnr)
  local history = action_state.get_current_history()
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local line = action_state.get_current_line()

  local entry = history:get_prev(line, current_picker)
  if entry == false then
    return
  end
  if entry ~= nil then
    current_picker:reset_prompt()
    current_picker:set_prompt(entry)
  end
end

--- Open the quickfix list. It makes sense to use this in combination with one of the send_to_qflist actions
--- `actions.smart_send_to_qflist + actions.open_qflist`
---@param prompt_bufnr number: The prompt bufnr
actions.open_qflist = function(prompt_bufnr)
  vim.cmd [[copen]]
end

--- Open the location list. It makes sense to use this in combination with one of the send_to_loclist actions
--- `actions.smart_send_to_qflist + actions.open_qflist`
---@param prompt_bufnr number: The prompt bufnr
actions.open_loclist = function(prompt_bufnr)
  vim.cmd [[lopen]]
end

--- Delete the selected buffer or all the buffers selected using multi selection.
---@param prompt_bufnr number: The prompt bufnr
actions.delete_buffer = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:delete_selection(function(selection)
    local force = vim.api.nvim_buf_get_option(selection.bufnr, "buftype") == "terminal"
    local ok = pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = force })
    return ok
  end)
end

--- Cycle to the next previewer if there is one available.<br>
--- This action is not mapped on default.
---@param prompt_bufnr number: The prompt bufnr
actions.cycle_previewers_next = function(prompt_bufnr)
  action_state.get_current_picker(prompt_bufnr):cycle_previewers(1)
end

--- Cycle to the previous previewer if there is one available.<br>
--- This action is not mapped on default.
---@param prompt_bufnr number: The prompt bufnr
actions.cycle_previewers_prev = function(prompt_bufnr)
  action_state.get_current_picker(prompt_bufnr):cycle_previewers(-1)
end

--- Removes the selected picker in |builtin.pickers|.<br>
--- This action is not mapped by default and only intended for |builtin.pickers|.
---@param prompt_bufnr number: The prompt bufnr
actions.remove_selected_picker = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local selection_index = current_picker:get_index(current_picker:get_selection_row())
  local cached_pickers = state.get_global_key "cached_pickers"
  current_picker:delete_selection(function()
    table.remove(cached_pickers, selection_index)
  end)
  if #cached_pickers == 0 then
    actions.close(prompt_bufnr)
  end
end

--- Display the keymaps of registered actions similar to which-key.nvim.<br>
--- - Notes:
---   - The defaults can be overridden via |action_generate.which_key|.
---@param prompt_bufnr number: The prompt bufnr
actions.which_key = function(prompt_bufnr, opts)
  opts = opts or {}
  opts.max_height = vim.F.if_nil(opts.max_height, 0.4)
  opts.only_show_current_mode = vim.F.if_nil(opts.only_show_current_mode, true)
  opts.mode_width = vim.F.if_nil(opts.mode_width, 1)
  opts.keybind_width = vim.F.if_nil(opts.keybind_width, 7)
  opts.name_width = vim.F.if_nil(opts.name_width, 30)
  opts.line_padding = vim.F.if_nil(opts.line_padding, 1)
  opts.separator = vim.F.if_nil(opts.separator, " -> ")
  opts.close_with_action = vim.F.if_nil(opts.close_with_action, true)
  opts.normal_hl = vim.F.if_nil(opts.normal_hl, "TelescopePrompt")
  opts.border_hl = vim.F.if_nil(opts.border_hl, "TelescopePromptBorder")
  opts.winblend = vim.F.if_nil(opts.winblend, conf.winblend)
  opts.column_padding = vim.F.if_nil(opts.column_padding, "  ")

  -- Assigning into 'opts.column_indent' would override a number with a string and
  -- cause issues with subsequent calls, keep a local copy of the string instead
  local column_indent = table.concat(utils.repeated_table(vim.F.if_nil(opts.column_indent, 4), " "))

  -- close on repeated keypress
  local km_bufs = (function()
    local ret = {}
    local bufs = a.nvim_list_bufs()
    for _, buf in ipairs(bufs) do
      for _, bufname in ipairs { "_TelescopeWhichKey", "_TelescopeWhichKeyBorder" } do
        if string.find(a.nvim_buf_get_name(buf), bufname) then
          table.insert(ret, buf)
        end
      end
    end
    return ret
  end)()
  if not vim.tbl_isempty(km_bufs) then
    for _, buf in ipairs(km_bufs) do
      utils.buf_delete(buf)
      local win_ids = vim.fn.win_findbuf(buf)
      for _, win_id in ipairs(win_ids) do
        pcall(a.nvim_win_close, win_id, true)
      end
    end
    return
  end

  local displayer = entry_display.create {
    separator = opts.separator,
    items = {
      { width = opts.mode_width },
      { width = opts.keybind_width },
      { width = opts.name_width },
    },
  }

  local make_display = function(mapping)
    return displayer {
      { mapping.mode, vim.F.if_nil(opts.mode_hl, "TelescopeResultsConstant") },
      { mapping.keybind, vim.F.if_nil(opts.keybind_hl, "TelescopeResultsVariable") },
      { mapping.name, vim.F.if_nil(opts.name_hl, "TelescopeResultsFunction") },
    }
  end

  local mappings = {}
  local mode = a.nvim_get_mode().mode
  for _, v in pairs(action_utils.get_registered_mappings(prompt_bufnr)) do
    -- holds true for registered keymaps
    if type(v.func) == "table" then
      local name = ""
      for _, action in ipairs(v.func) do
        if type(action) == "string" then
          name = name == "" and action or name .. " + " .. action
        end
      end
      if name and name ~= "which_key" and name ~= "nop" then
        if not opts.only_show_current_mode or mode == v.mode then
          table.insert(mappings, { mode = v.mode, keybind = v.keybind, name = name })
        end
      end
    elseif type(v.func) == "function" then
      if not opts.only_show_current_mode or mode == v.mode then
        local fname = action_utils._get_anon_function_name(v.func)
        -- telescope.setup mappings might result in function names that reflect the keys
        fname = fname:lower() == v.keybind:lower() and "<anonymous>" or fname
        table.insert(mappings, { mode = v.mode, keybind = v.keybind, name = fname })
        if fname == "<anonymous>" then
          utils.notify("actions.which_key", {
            msg = "No name available for anonymous functions.",
            level = "INFO",
            once = true,
          })
        end
      end
    end
  end

  table.sort(mappings, function(x, y)
    if x.name < y.name then
      return true
    elseif x.name == y.name then
      -- show normal mode as the standard mode first
      if x.mode > y.mode then
        return true
      else
        return false
      end
    else
      return false
    end
  end)

  local entry_width = #opts.column_padding
    + opts.mode_width
    + opts.keybind_width
    + opts.name_width
    + (3 * #opts.separator)
  local num_total_columns = math.floor((vim.o.columns - #column_indent) / entry_width)
  opts.num_rows =
    math.min(math.ceil(#mappings / num_total_columns), resolver.resolve_height(opts.max_height)(_, _, vim.o.lines))
  local total_available_entries = opts.num_rows * num_total_columns
  local winheight = opts.num_rows + 2 * opts.line_padding

  -- place hints at top or bottom relative to prompt
  local win_central_row = function(win_nr)
    return a.nvim_win_get_position(win_nr)[1] + 0.5 * a.nvim_win_get_height(win_nr)
  end
  -- TODO(fdschmidt93|l-kershaw): better generalization of where to put which key float
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_row = win_central_row(picker.prompt_win)
  local results_row = win_central_row(picker.results_win)
  local preview_row = picker.preview_win and win_central_row(picker.preview_win) or results_row
  local prompt_pos = prompt_row < 0.4 * vim.o.lines
    or prompt_row < 0.6 * vim.o.lines and results_row + preview_row < vim.o.lines

  local modes = { n = "Normal", i = "Insert" }
  local title_mode = opts.only_show_current_mode and modes[mode] .. " Mode " or ""
  local title_text = title_mode .. "Keymaps"
  local popup_opts = {
    relative = "editor",
    enter = false,
    minwidth = vim.o.columns,
    maxwidth = vim.o.columns,
    minheight = winheight,
    maxheight = winheight,
    line = prompt_pos == true and vim.o.lines - winheight + 1 or 1,
    col = 0,
    border = { prompt_pos and 1 or 0, 0, not prompt_pos and 1 or 0, 0 },
    borderchars = { prompt_pos and "─" or " ", "", not prompt_pos and "─" or " ", "", "", "", "", "" },
    noautocmd = true,
    title = { { text = title_text, pos = prompt_pos and "N" or "S" } },
  }
  local km_win_id, km_opts = popup.create("", popup_opts)
  local km_buf = a.nvim_win_get_buf(km_win_id)
  a.nvim_buf_set_name(km_buf, "_TelescopeWhichKey")
  a.nvim_buf_set_name(km_opts.border.bufnr, "_TelescopeTelescopeWhichKeyBorder")
  a.nvim_win_set_option(km_win_id, "winhl", "Normal:" .. opts.normal_hl)
  a.nvim_win_set_option(km_opts.border.win_id, "winhl", "Normal:" .. opts.border_hl)
  a.nvim_win_set_option(km_win_id, "winblend", opts.winblend)
  a.nvim_win_set_option(km_win_id, "foldenable", false)

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = km_buf,
    once = true,
    callback = function()
      pcall(vim.api.nvim_win_close, km_win_id, true)
      pcall(vim.api.nvim_win_close, km_opts.border.win_id, true)
      require("telescope.utils").buf_delete(km_buf)
    end,
  })

  a.nvim_buf_set_lines(km_buf, 0, -1, false, utils.repeated_table(opts.num_rows + 2 * opts.line_padding, column_indent))

  local keymap_highlights = a.nvim_create_namespace "telescope_whichkey"
  local highlights = {}
  for index, mapping in ipairs(mappings) do
    local row = utils.cycle(index, opts.num_rows) - 1 + opts.line_padding
    local prev_line = a.nvim_buf_get_lines(km_buf, row, row + 1, false)[1]
    if index == total_available_entries and total_available_entries > #mappings then
      local new_line = prev_line .. "..."
      a.nvim_buf_set_lines(km_buf, row, row + 1, false, { new_line })
      break
    end
    local display, display_hl = make_display(mapping)
    local new_line = prev_line .. display .. opts.column_padding -- incl. padding
    a.nvim_buf_set_lines(km_buf, row, row + 1, false, { new_line })
    table.insert(highlights, { hl = display_hl, row = row, col = #prev_line })
  end

  -- highlighting only after line setting as vim.api.nvim_buf_set_lines removes hl otherwise
  for _, highlight_tbl in pairs(highlights) do
    local highlight = highlight_tbl.hl
    local row_ = highlight_tbl.row
    local col = highlight_tbl.col
    for _, hl_block in ipairs(highlight) do
      a.nvim_buf_add_highlight(km_buf, keymap_highlights, hl_block[2], row_, col + hl_block[1][1], col + hl_block[1][2])
    end
  end

  -- only set up autocommand after showing preview completed
  if opts.close_with_action then
    vim.schedule(function()
      vim.api.nvim_create_autocmd("User TelescopeKeymap", {
        once = true,
        callback = function()
          pcall(vim.api.nvim_win_close, km_win_id, true)
          pcall(vim.api.nvim_win_close, km_opts.border.win_id, true)
          require("telescope.utils").buf_delete(km_buf)
        end,
      })
    end)
  end
end

--- Move from a none fuzzy search to a fuzzy one<br>
--- This action is meant to be used in live_grep and lsp_dynamic_workspace_symbols
---@param prompt_bufnr number: The prompt bufnr
actions.to_fuzzy_refine = function(prompt_bufnr)
  local line = action_state.get_current_line()
  local prefix = (function()
    local title = action_state.get_current_picker(prompt_bufnr).prompt_title
    if title == "Live Grep" then
      return "Find Word"
    elseif title == "LSP Dynamic Workspace Symbols" then
      return "LSP Workspace Symbols"
    else
      return "Fuzzy over"
    end
  end)()

  require("telescope.actions.generate").refine(prompt_bufnr, {
    prompt_title = string.format("%s (%s)", prefix, line),
    sorter = conf.generic_sorter {},
  })
end

actions.nop = function(_) end

-- ==================================================
-- Transforms modules and sets the correct metatables.
-- ==================================================
actions = transform_mod(actions)
return actions
