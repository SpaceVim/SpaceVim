-- This files holds code for scanning the filesystem to build the tree.
local uv = vim.loop

local renderer = require("neo-tree.ui.renderer")
local utils = require("neo-tree.utils")
local filter_external = require("neo-tree.sources.filesystem.lib.filter_external")
local file_items = require("neo-tree.sources.common.file-items")
local log = require("neo-tree.log")
local fs_watch = require("neo-tree.sources.filesystem.lib.fs_watch")
local git = require("neo-tree.git")
local events = require("neo-tree.events")
local async = require("plenary.async")

local Path = require("plenary.path")
local os_sep = Path.path.sep

local M = {}

local on_directory_loaded = function(context, dir_path)
  local state = context.state
  local scanned_folder = context.folders[dir_path]
  if scanned_folder then
    scanned_folder.loaded = true
  end
  if state.use_libuv_file_watcher then
    local root = context.folders[dir_path]
    if root then
      local target_path = root.is_link and root.link_to or root.path
      local fs_watch_callback = vim.schedule_wrap(function(err, fname)
        if err then
          log.error("file_event_callback: ", err)
          return
        end
        if context.is_a_never_show_file(fname) then
          -- don't fire events for nodes that are designated as "never show"
          return
        else
          events.fire_event(events.FS_EVENT, { afile = target_path })
        end
      end)

      log.trace("Adding fs watcher for ", target_path)
      fs_watch.watch_folder(target_path, fs_watch_callback)
    end
  end
end

local dir_complete = function(context, dir_path)
  local paths_to_load = context.paths_to_load
  local folders = context.folders

  on_directory_loaded(context, dir_path)

  -- check to see if there are more folders to load
  local next_path = nil
  while #paths_to_load > 0 and not next_path do
    next_path = table.remove(paths_to_load)
    -- ensure that the path is still valid
    local success, result = pcall(vim.loop.fs_stat, next_path)
    -- ensure that the result is a directory
    if success and result and result.type == "directory" then
      -- ensure that it is not already loaded
      local existing = folders[next_path]
      if existing and existing.loaded then
        next_path = nil
      end
    else
      -- if the path doesn't exist, skip it
      next_path = nil
    end
  end
  return next_path
end

local render_context = function(context)
  local state = context.state
  local root = context.root
  local parent_id = context.parent_id

  if not parent_id and state.use_libuv_file_watcher and state.enable_git_status then
    log.trace("Starting .git folder watcher")
    local path = root.path
    if root.is_link then
      path = root.link_to
    end
    fs_watch.watch_git_index(path, require("neo-tree").config.git_status_async)
  end
  fs_watch.updated_watched()

  if root and root.children then
    file_items.deep_sort(root.children, state.sort_function_override)
  end
  if parent_id then
    -- lazy loading a child folder
    renderer.show_nodes(root.children, state, parent_id, context.callback)
  else
    -- full render of the tree
    renderer.show_nodes({ root }, state, nil, context.callback)
  end

  context.state = nil
  context.callback = nil
  context.all_items = nil
  context.root = nil
  context.parent_id = nil
  context = nil
end

local job_complete = function(context)
  local state = context.state
  local parent_id = context.parent_id
  if #context.all_items == 0 then
    log.info("No items, skipping git ignored/status lookups")
    render_context(context)
    return
  end
  if state.filtered_items.hide_gitignored or state.enable_git_status then
    if require("neo-tree").config.git_status_async then
      git.mark_ignored(state, context.all_items, function(all_items)
        if parent_id then
          vim.list_extend(state.git_ignored, all_items)
        else
          state.git_ignored = all_items
        end
        vim.schedule(function()
          render_context(context)
        end)
      end)
      return
    else
      local all_items = git.mark_ignored(state, context.all_items)
      if parent_id then
        vim.list_extend(state.git_ignored, all_items)
      else
        state.git_ignored = all_items
      end
    end
  end
  render_context(context)
end

local function create_node(context, node)
  local success3, item = pcall(file_items.create_item, context, node.path, node.type)
end

local function process_node(context, path)
  on_directory_loaded(context, path)
end

local function get_children_sync(path)
  local children = {}
  local success, dir = pcall(vim.loop.fs_opendir, path, nil, 1000)
  if not success then
    log.error("Error opening dir:", dir)
  end
  local success2, stats = pcall(vim.loop.fs_readdir, dir)
  if success2 and stats then
    for _, stat in ipairs(stats) do
      local child_path = utils.path_join(path, stat.name)
      table.insert(children, { path = child_path, type = stat.type })
    end
  end
  pcall(vim.loop.fs_closedir, dir)
  return children
end

local function get_children_async(path, callback)
  uv.fs_opendir(path, function(_, dir)
    uv.fs_readdir(dir, function(_, stats)
      local children = {}
      if stats then
        for _, stat in ipairs(stats) do
          local child_path = utils.path_join(path, stat.name)
          table.insert(children, { path = child_path, type = stat.type })
        end
      end
      uv.fs_closedir(dir)
      callback(children)
    end)
  end, 1000)
end

local function scan_dir_sync(context, path)
  process_node(context, path)
  local children = get_children_sync(path)
  for _, child in ipairs(children) do
    create_node(context, child)
    if child.type == "directory" then
      local grandchild_nodes = get_children_sync(child.path)
      if
        grandchild_nodes == nil
        or #grandchild_nodes == 0
        or #grandchild_nodes == 1 and grandchild_nodes[1].type == "directory"
      then
        scan_dir_sync(context, child.path)
      end
    end
  end
end

local function scan_dir_async(context, path, callback)
  get_children_async(path, function(children)
    for _, child in ipairs(children) do
      create_node(context, child)
      if child.type == "directory" then
        local grandchild_nodes = get_children_sync(child.path)
        if
          grandchild_nodes == nil
          or #grandchild_nodes == 0
          or #grandchild_nodes == 1 and grandchild_nodes[1].type == "directory"
        then
          scan_dir_sync(context, child.path)
        end
      end
    end
    process_node(context, path)
    callback(path)
  end)
end

-- async_scan scans all the directories in context.paths_to_load
-- and adds them as items to render in the UI.
local function async_scan(context, path)
  log.trace("async_scan: ", path)
  local scan_mode = require("neo-tree").config.filesystem.scan_mode

  if scan_mode == "deep" then
    local scan_tasks = {}
    for _, p in ipairs(context.paths_to_load) do
      local scan_task = async.wrap(function(callback)
        scan_dir_async(context, p, callback)
      end, 1)
      table.insert(scan_tasks, scan_task)
    end

    async.util.run_all(
      scan_tasks,
      vim.schedule_wrap(function()
        job_complete(context)
      end)
    )
    return
  end

  -- scan_mode == "shallow"
  context.directories_scanned = 0
  context.directories_to_scan = #context.paths_to_load

  context.on_exit = vim.schedule_wrap(function()
    job_complete(context)
  end)

  -- from https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/scandir.lua
  local function read_dir(current_dir, ctx)
    uv.fs_opendir(current_dir, function(err, dir)
      if err then
        log.error(current_dir, ": ", err)
        return
      end
      local function on_fs_readdir(err, entries)
        if err then
          log.error(current_dir, ": ", err)
          return
        end
        if entries then
          for _, entry in ipairs(entries) do
            local success, item = pcall(
              file_items.create_item,
              ctx,
              utils.path_join(current_dir, entry.name),
              entry.type
            )
            if success then
              if ctx.recursive and item.type == "directory" then
                ctx.directories_to_scan = ctx.directories_to_scan + 1
                table.insert(ctx.paths_to_load, item.path)
              end
            else
              log.error("error creating item for ", path)
            end
          end

          uv.fs_readdir(dir, on_fs_readdir)
          return
        end
        uv.fs_closedir(dir)
        on_directory_loaded(ctx, current_dir)
        ctx.directories_scanned = ctx.directories_scanned + 1
        if ctx.directories_scanned == #ctx.paths_to_load then
          ctx.on_exit()
        end

        --local next_path = dir_complete(ctx, current_dir)
        --if next_path then
        --  local success, error = pcall(read_dir, next_path)
        --  if not success then
        --    log.error(next_path, ": ", error)
        --  end
        --else
        --  on_exit()
        --end
      end

      uv.fs_readdir(dir, on_fs_readdir)
    end)
  end

  --local first = table.remove(context.paths_to_load)
  --local success, err = pcall(read_dir, first)
  --if not success then
  --  log.error(first, ": ", err)
  --end
  for i = 1, context.directories_to_scan do
    read_dir(context.paths_to_load[i], context)
  end
end

local function sync_scan(context, path_to_scan)
  log.trace("sync_scan: ", path_to_scan)
  local scan_mode = require("neo-tree").config.filesystem.scan_mode
  if scan_mode == "deep" then
    for _, path in ipairs(context.paths_to_load) do
      scan_dir_sync(context, path)
      -- scan_dir(context, path)
    end
    job_complete(context)
  else -- scan_mode == "shallow"
    local success, dir = pcall(vim.loop.fs_opendir, path_to_scan, nil, 1000)
    if not success then
      log.error("Error opening dir:", dir)
    end
    local success2, stats = pcall(vim.loop.fs_readdir, dir)
    if success2 and stats then
      for _, stat in ipairs(stats) do
        local path = utils.path_join(path_to_scan, stat.name)
        local success3, item = pcall(file_items.create_item, context, path, stat.type)
        if success3 then
          if context.recursive and stat.type == "directory" then
            table.insert(context.paths_to_load, path)
          end
        else
          log.error("error creating item for ", path)
        end
      end
    end
    vim.loop.fs_closedir(dir)

    local next_path = dir_complete(context, path_to_scan)
    if next_path then
      sync_scan(context, next_path)
    else
      job_complete(context)
    end
  end
end

M.get_items_sync = function(state, parent_id, path_to_reveal, callback)
  return M.get_items(state, parent_id, path_to_reveal, callback, false)
end

M.get_items_async = function(state, parent_id, path_to_reveal, callback)
  M.get_items(state, parent_id, path_to_reveal, callback, true)
end

M.get_items = function(state, parent_id, path_to_reveal, callback, async, recursive)
  if state.async_directory_scan == "always" then
    async = true
  elseif state.async_directory_scan == "never" then
    async = false
  elseif type(async) == "nil" then
    async = (state.async_directory_scan == "auto") or state.async_directory_scan
  end

  if not parent_id then
    M.stop_watchers(state)
  end
  local context = file_items.create_context()
  context.state = state
  context.parent_id = parent_id
  context.path_to_reveal = path_to_reveal
  context.recursive = recursive
  context.callback = callback

  -- Create root folder
  local root = file_items.create_item(context, parent_id or state.path, "directory")
  root.name = vim.fn.fnamemodify(root.path, ":~")
  root.loaded = true
  root.search_pattern = state.search_pattern
  context.root = root
  context.folders[root.path] = root
  state.default_expanded_nodes = state.force_open_folders or { state.path }

  if state.search_pattern then
    local search_opts = {
      filtered_items = state.filtered_items,
      find_command = state.find_command,
      limit = state.search_limit or 50,
      path = root.path,
      term = state.search_pattern,
      find_args = state.find_args,
      find_by_full_path_words = state.find_by_full_path_words,
      fuzzy_finder_mode = state.fuzzy_finder_mode,
      on_insert = function(err, path)
        if err then
          log.debug(err)
        else
          file_items.create_item(context, path)
        end
      end,
      on_exit = vim.schedule_wrap(function()
        job_complete(context)
      end),
    }
    if state.use_fzy then
      filter_external.fzy_sort_files(search_opts, state)
    else
      -- Use the external command because the plenary search is slow
      filter_external.find_files(search_opts)
    end
  else
    -- In the case of a refresh or navigating up, we need to make sure that all
    -- open folders are loaded.
    local path = parent_id or state.path
    context.paths_to_load = {}
    if parent_id == nil then
      if utils.truthy(state.force_open_folders) then
        for _, f in ipairs(state.force_open_folders) do
          table.insert(context.paths_to_load, f)
        end
      elseif state.tree then
        context.paths_to_load = renderer.get_expanded_nodes(state.tree, state.path)
      end
      -- Ensure that there are no nested files in the list of folders to load
      context.paths_to_load = vim.tbl_filter(function(p)
        local stats = vim.loop.fs_stat(p)
        return stats and stats.type == "directory"
      end, context.paths_to_load)
      if path_to_reveal then
        -- be sure to load all of the folders leading up to the path to reveal
        local path_to_reveal_parts = utils.split(path_to_reveal, utils.path_separator)
        table.remove(path_to_reveal_parts) -- remove the file name
        -- add all parent folders to the list of paths to load
        utils.reduce(path_to_reveal_parts, "", function(acc, part)
          local current_path = utils.path_join(acc, part)
          if #current_path > #path then -- within current root
            table.insert(context.paths_to_load, current_path)
            table.insert(state.default_expanded_nodes, current_path)
          end
          return current_path
        end)
        context.paths_to_load = utils.unique(context.paths_to_load)
      end
    end

    local filtered_items = state.filtered_items or {}
    context.is_a_never_show_file = function(fname)
      if fname then
        local _, name = utils.split_path(fname)
        if name then
          if filtered_items.never_show and filtered_items.never_show[name] then
            return true
          end
          if utils.is_filtered_by_pattern(filtered_items.never_show_by_pattern, fname, name) then
            return true
          end
        end
      end
      return false
    end
    table.insert(context.paths_to_load, path)
    if async then
      async_scan(context, path)
    else
      sync_scan(context, path)
    end
  end
end

M.stop_watchers = function(state)
  if state.use_libuv_file_watcher and state.tree then
    -- We are loaded a new root or refreshing, unwatch any folders that were
    -- previously being watched.
    local loaded_folders = renderer.select_nodes(state.tree, function(node)
      return node.type == "directory" and node.loaded
    end)
    fs_watch.unwatch_git_index(state.path, require("neo-tree").config.git_status_async)
    for _, folder in ipairs(loaded_folders) do
      log.trace("Unwatching folder ", folder.path)
      if folder.is_link then
        fs_watch.unwatch_folder(folder.link_to)
      else
        fs_watch.unwatch_folder(folder:get_id())
      end
    end
  else
    log.debug(
      "Not unwatching folders... use_libuv_file_watcher is ",
      state.use_libuv_file_watcher,
      " and state.tree is ",
      utils.truthy(state.tree)
    )
  end
end

return M
