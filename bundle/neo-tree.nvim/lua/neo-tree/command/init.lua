local parser = require("neo-tree.command.parser")
local log = require("neo-tree.log")
local manager = require("neo-tree.sources.manager")
local utils = require("neo-tree.utils")
local renderer = require("neo-tree.ui.renderer")
local inputs = require("neo-tree.ui.inputs")
local completion = require("neo-tree.command.completion")
local do_show_or_focus, handle_reveal

local M = {
  complete_args = completion.complete_args,
}

---Executes a Neo-tree action from outside of a Neo-tree window,
---such as show, hide, navigate, etc.
---@param args table The action to execute. The table can have the following keys:
---  action = string   The action to execute, can be one of:
---                    "close",
---                    "focus", <-- default value
---                    "show",
---  source = string   The source to use for this action. This will default
---                    to the default_source specified in the user's config.
---                    Can be one of:
---                    "filesystem",
---                    "buffers",
---                    "git_status",
--                     "migrations"
---  position = string The position this action will affect. This will default
---                    to the the last used position or the position specified
---                    in the user's config for the given source. Can be one of:
---                    "left",
---                    "right",
---                    "float",
---                    "current"
---  toggle = boolean  Whether to toggle the visibility of the Neo-tree window.
---  reveal = boolean  Whether to reveal the current file in the Neo-tree window.
---  reveal_file = string The specific file to reveal.
---  dir = string      The root directory to set.
---  git_base = string The git base used for diff
M.execute = function(args)
  local nt = require("neo-tree")
  nt.ensure_config()

  if args.source == "migrations" then
    require("neo-tree.setup.deprecations").show_migrations()
    return
  end

  args.action = args.action or "focus"

  -- handle close action, which can specify a source and/or position
  if args.action == "close" then
    if args.source then
      manager.close(args.source, args.position)
    else
      manager.close_all(args.position)
    end
    return
  end

  -- The rest of the actions require a source
  args.source = args.source or nt.config.default_source

  -- If position=current was requested, but we are currently in a neo-tree window,
  -- then we need to override that.
  if args.position == "current" and vim.bo.filetype == "neo-tree" then
    local position = vim.api.nvim_buf_get_var(0, "neo_tree_position")
    if position then
      args.position = position
    end
  end

  -- Now get the correct state
  local state
  local requested_position = args.position or nt.config[args.source].window.position
  if requested_position == "current" then
    local winid = vim.api.nvim_get_current_win()
    state = manager.get_state(args.source, nil, winid)
  else
    state = manager.get_state(args.source, nil, nil)
  end

  -- Next handle toggle, the rest is irrelevant if there is a window to toggle
  if args.toggle then
    if renderer.close(state) then
      -- It was open, and now it's not.
      return
    end
  end

  -- Handle position override
  local default_position = nt.config[args.source].window.position
  local current_position = state.current_position or default_position
  local position_changed = false
  if args.position then
    state.current_position = args.position
    position_changed = args.position ~= current_position
  end

  -- Handle setting directory if requested
  local path_changed = false
  if utils.truthy(args.dir) then
    if #args.dir > 1 and args.dir:sub(-1) == utils.path_separator then
      args.dir = args.dir:sub(1, -2)
    end
    path_changed = state.path ~= args.dir
  else
    args.dir = state.path
  end

  -- Handle setting git ref
  local git_base_changed = state.git_base ~= args.git_base
  if utils.truthy(args.git_base) then
    state.git_base = args.git_base
  end

  -- Handle reveal logic
  args.reveal = args.reveal or args.reveal_force_cwd
  local do_reveal = utils.truthy(args.reveal_file)
  if args.reveal and not do_reveal then
    args.reveal_file = manager.get_path_to_reveal()
    do_reveal = utils.truthy(args.reveal_file)
  end

  -- All set, now show or focus the window
  local force_navigate = path_changed or do_reveal or git_base_changed or state.dirty
  if position_changed and args.position ~= "current" and current_position ~= "current" then
    manager.close(args.source)
  end
  if do_reveal then
    handle_reveal(args, state)
  else
    do_show_or_focus(args, state, force_navigate)
  end
end

---Parses and executes the command line. Use execute(args) instead.
---@param ... string Argument as strings.
M._command = function(...)
  local args = parser.parse({ ... }, true)
  M.execute(args)
end

do_show_or_focus = function(args, state, force_navigate)
  local window_exists = renderer.window_exists(state)
  local function close_other_sources()
    if not window_exists then
      -- Clear the space in case another source is already open
      local target_position = args.position or state.current_position or state.window.position
      if target_position ~= "current" then
        manager.close_all(target_position)
      end
    end
  end

  if args.action == "show" then
    -- "show" means show the window without focusing it
    if window_exists and not force_navigate then
      -- There's nothing to do here, we are already at the target state
      return
    end
    close_other_sources()
    local current_win = vim.api.nvim_get_current_win()
    manager.navigate(state, args.dir, args.reveal_file, function()
      -- navigate changes the window to neo-tree, so just quickly hop back to the original window
      vim.api.nvim_set_current_win(current_win)
    end, false)
  elseif args.action == "focus" then
    -- "focus" mean open and jump to the window if closed, and just focus it if already opened
    if window_exists then
      vim.api.nvim_set_current_win(state.winid)
    end
    if force_navigate or not window_exists then
      close_other_sources()
      manager.navigate(state, args.dir, args.reveal_file, nil, false)
    end
  end
end

handle_reveal = function(args, state)
  -- Deal with cwd if we need to
  local cwd = state.path
  local path = args.reveal_file
  if cwd == nil then
    cwd = manager.get_cwd(state)
  end
  if args.reveal_force_cwd and not utils.is_subpath(cwd, path) then
    args.dir, _ = utils.split_path(path)
    do_show_or_focus(args, state, true)
    return
  elseif not utils.is_subpath(cwd, path) then
    -- force was not specified, so we need to ask the user
    cwd, _ = utils.split_path(path)
    inputs.confirm("File not in cwd. Change cwd to " .. cwd .. "?", function(response)
      if response == true then
        args.dir = cwd
      else
        args.reveal_file = nil
      end
      do_show_or_focus(args, state, true)
    end)
    return
  else
    do_show_or_focus(args, state, true)
  end
end
return M
