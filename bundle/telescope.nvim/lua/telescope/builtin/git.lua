local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local utils = require "telescope.utils"
local entry_display = require "telescope.pickers.entry_display"
local strings = require "plenary.strings"
local Path = require "plenary.path"

local conf = require("telescope.config").values

local git = {}

git.files = function(opts)
  if opts.is_bare then
    utils.notify("builtin.git_files", {
      msg = "This operation must be run in a work tree",
      level = "ERROR",
    })
    return
  end

  local show_untracked = utils.get_default(opts.show_untracked, true)
  local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
  if show_untracked and recurse_submodules then
    utils.notify("builtin.git_files", {
      msg = "Git does not support both --others and --recurse-submodules",
      level = "ERROR",
    })
    return
  end

  -- By creating the entry maker after the cwd options,
  -- we ensure the maker uses the cwd options when being created.
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_file(opts))
  local git_command = vim.F.if_nil(opts.git_command, { "git", "ls-files", "--exclude-standard", "--cached" })

  pickers.new(opts, {
    prompt_title = "Git Files",
    finder = finders.new_oneshot_job(
      vim.tbl_flatten {
        git_command,
        show_untracked and "--others" or nil,
        recurse_submodules and "--recurse-submodules" or nil,
      },
      opts
    ),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

git.commits = function(opts)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))
  local git_command = vim.F.if_nil(opts.git_command, { "git", "log", "--pretty=oneline", "--abbrev-commit", "--", "." })

  pickers.new(opts, {
    prompt_title = "Git Commits",
    finder = finders.new_oneshot_job(git_command, opts),
    previewer = {
      previewers.git_commit_diff_to_parent.new(opts),
      previewers.git_commit_diff_to_head.new(opts),
      previewers.git_commit_diff_as_was.new(opts),
      previewers.git_commit_message.new(opts),
    },
    sorter = conf.file_sorter(opts),
    attach_mappings = function(_, map)
      actions.select_default:replace(actions.git_checkout)
      map("i", "<c-r>m", actions.git_reset_mixed)
      map("n", "<c-r>m", actions.git_reset_mixed)
      map("i", "<c-r>s", actions.git_reset_soft)
      map("n", "<c-r>s", actions.git_reset_soft)
      map("i", "<c-r>h", actions.git_reset_hard)
      map("n", "<c-r>h", actions.git_reset_hard)
      return true
    end,
  }):find()
end

git.stash = function(opts)
  opts.show_branch = vim.F.if_nil(opts.show_branch, true)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_stash(opts))

  pickers.new(opts, {
    prompt_title = "Git Stash",
    finder = finders.new_oneshot_job(
      vim.tbl_flatten {
        "git",
        "--no-pager",
        "stash",
        "list",
      },
      opts
    ),
    previewer = previewers.git_stash_diff.new(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(actions.git_apply_stash)
      return true
    end,
  }):find()
end

local get_current_buf_line = function(winnr)
  local lnum = vim.api.nvim_win_get_cursor(winnr)[1]
  return vim.trim(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(winnr), lnum - 1, lnum, false)[1])
end

git.bcommits = function(opts)
  opts.current_line = (opts.current_file == nil) and get_current_buf_line(opts.winnr) or nil
  opts.current_file = vim.F.if_nil(opts.current_file, vim.api.nvim_buf_get_name(opts.bufnr))
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))
  local git_command = vim.F.if_nil(opts.git_command, { "git", "log", "--pretty=oneline", "--abbrev-commit" })

  pickers.new(opts, {
    prompt_title = "Git BCommits",
    finder = finders.new_oneshot_job(
      vim.tbl_flatten {
        git_command,
        opts.current_file,
      },
      opts
    ),
    previewer = {
      previewers.git_commit_diff_to_parent.new(opts),
      previewers.git_commit_diff_to_head.new(opts),
      previewers.git_commit_diff_as_was.new(opts),
      previewers.git_commit_message.new(opts),
    },
    sorter = conf.file_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(actions.git_checkout_current_buffer)
      local transfrom_file = function()
        return opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd) or ""
      end

      local get_buffer_of_orig = function(selection)
        local value = selection.value .. ":" .. transfrom_file()
        local content = utils.get_os_command_output({ "git", "--no-pager", "show", value }, opts.cwd)

        local bufnr = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
        vim.api.nvim_buf_set_name(bufnr, "Original")
        return bufnr
      end

      local vimdiff = function(selection, command)
        local ft = vim.bo.filetype
        vim.cmd "diffthis"

        local bufnr = get_buffer_of_orig(selection)
        vim.cmd(string.format("%s %s", command, bufnr))
        vim.bo.filetype = ft
        vim.cmd "diffthis"

        vim.api.nvim_create_autocmd("WinClosed", {
          event = "WinClosed",
          buffer = bufnr,
          nested = true,
          once = true,
          function()
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end,
        })
      end

      actions.select_vertical:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vimdiff(selection, "leftabove vert sbuffer")
      end)

      actions.select_horizontal:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vimdiff(selection, "belowright sbuffer")
      end)

      actions.select_tab:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd("tabedit " .. transfrom_file())
        vimdiff(selection, "leftabove vert sbuffer")
      end)
      return true
    end,
  }):find()
end

git.branches = function(opts)
  local format = "%(HEAD)"
    .. "%(refname)"
    .. "%(authorname)"
    .. "%(upstream:lstrip=2)"
    .. "%(committerdate:format-local:%Y/%m/%d %H:%M:%S)"
  local output = utils.get_os_command_output(
    { "git", "for-each-ref", "--perl", "--format", format, opts.pattern },
    opts.cwd
  )

  local results = {}
  local widths = {
    name = 0,
    authorname = 0,
    upstream = 0,
    committerdate = 0,
  }
  local unescape_single_quote = function(v)
    return string.gsub(v, "\\([\\'])", "%1")
  end
  local parse_line = function(line)
    local fields = vim.split(string.sub(line, 2, -2), "''", true)
    local entry = {
      head = fields[1],
      refname = unescape_single_quote(fields[2]),
      authorname = unescape_single_quote(fields[3]),
      upstream = unescape_single_quote(fields[4]),
      committerdate = fields[5],
    }
    local prefix
    if vim.startswith(entry.refname, "refs/remotes/") then
      prefix = "refs/remotes/"
    elseif vim.startswith(entry.refname, "refs/heads/") then
      prefix = "refs/heads/"
    else
      return
    end
    local index = 1
    if entry.head ~= "*" then
      index = #results + 1
    end

    entry.name = string.sub(entry.refname, string.len(prefix) + 1)
    for key, value in pairs(widths) do
      widths[key] = math.max(value, strings.strdisplaywidth(entry[key] or ""))
    end
    if string.len(entry.upstream) > 0 then
      widths.upstream_indicator = 2
    end
    table.insert(results, index, entry)
  end
  for _, line in ipairs(output) do
    parse_line(line)
  end
  if #results == 0 then
    return
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 1 },
      { width = widths.name },
      { width = widths.authorname },
      { width = widths.upstream_indicator },
      { width = widths.upstream },
      { width = widths.committerdate },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.head },
      { entry.name, "TelescopeResultsIdentifier" },
      { entry.authorname },
      { string.len(entry.upstream) > 0 and "=>" or "" },
      { entry.upstream, "TelescopeResultsIdentifier" },
      { entry.committerdate },
    }
  end

  pickers.new(opts, {
    prompt_title = "Git Branches",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        entry.value = entry.name
        entry.ordinal = entry.name
        entry.display = make_display
        return entry
      end,
    },
    previewer = previewers.git_branch_log.new(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(_, map)
      actions.select_default:replace(actions.git_checkout)
      map("i", "<c-t>", actions.git_track_branch)
      map("n", "<c-t>", actions.git_track_branch)

      map("i", "<c-r>", actions.git_rebase_branch)
      map("n", "<c-r>", actions.git_rebase_branch)

      map("i", "<c-a>", actions.git_create_branch)
      map("n", "<c-a>", actions.git_create_branch)

      map("i", "<c-s>", actions.git_switch_branch)
      map("n", "<c-s>", actions.git_switch_branch)

      map("i", "<c-d>", actions.git_delete_branch)
      map("n", "<c-d>", actions.git_delete_branch)

      map("i", "<c-y>", actions.git_merge_branch)
      map("n", "<c-y>", actions.git_merge_branch)
      return true
    end,
  }):find()
end

git.status = function(opts)
  if opts.is_bare then
    utils.notify("builtin.git_status", {
      msg = "This operation must be run in a work tree",
      level = "ERROR",
    })
    return
  end

  local gen_new_finder = function()
    local expand_dir = utils.if_nil(opts.expand_dir, true, opts.expand_dir)
    local git_cmd = { "git", "status", "-s", "--", "." }

    if expand_dir then
      table.insert(git_cmd, #git_cmd - 1, "-u")
    end

    local output = utils.get_os_command_output(git_cmd, opts.cwd)

    if #output == 0 then
      print "No changes found"
      utils.notify("builtin.git_status", {
        msg = "No changes found",
        level = "WARN",
      })
      return
    end

    return finders.new_table {
      results = output,
      entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_status(opts)),
    }
  end

  local initial_finder = gen_new_finder()
  if not initial_finder then
    return
  end

  pickers.new(opts, {
    prompt_title = "Git Status",
    finder = initial_finder,
    previewer = previewers.git_file_diff.new(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.git_staging_toggle:enhance {
        post = function()
          action_state.get_current_picker(prompt_bufnr):refresh(gen_new_finder(), { reset_prompt = true })
        end,
      }

      map("i", "<tab>", actions.git_staging_toggle)
      map("n", "<tab>", actions.git_staging_toggle)
      return true
    end,
  }):find()
end

local set_opts_cwd = function(opts)
  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  else
    opts.cwd = vim.loop.cwd()
  end

  -- Find root of git directory and remove trailing newline characters
  local git_root, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)
  local use_git_root = utils.get_default(opts.use_git_root, true)

  if ret ~= 0 then
    local in_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
    local in_bare = utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)

    if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
      error(opts.cwd .. " is not a git directory")
    elseif in_worktree[1] ~= "true" and in_bare[1] == "true" then
      opts.is_bare = true
    end
  else
    if use_git_root then
      opts.cwd = git_root[1]
    end
  end
end

local function apply_checks(mod)
  for k, v in pairs(mod) do
    mod[k] = function(opts)
      opts = vim.F.if_nil(opts, {})

      set_opts_cwd(opts)
      v(opts)
    end
  end

  return mod
end

return apply_checks(git)
