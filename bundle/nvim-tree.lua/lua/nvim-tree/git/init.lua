local git_utils = require "nvim-tree.git.utils"
local Runner = require "nvim-tree.git.runner"

local M = {
  config = nil,
  projects = {},
  cwd_to_project_root = {},
}

function M.reload()
  if not M.config.enable then
    return {}
  end

  for project_root in pairs(M.projects) do
    M.projects[project_root] = {}
    local git_status = Runner.run {
      project_root = project_root,
      list_untracked = git_utils.should_show_untracked(project_root),
      list_ignored = true,
      timeout = M.config.timeout,
    }
    M.projects[project_root] = {
      files = git_status,
      dirs = git_utils.file_status_to_dir_status(git_status, project_root),
    }
  end

  return M.projects
end

function M.get_project_root(cwd)
  if M.cwd_to_project_root[cwd] then
    return M.cwd_to_project_root[cwd]
  end

  if M.cwd_to_project_root[cwd] == false then
    return nil
  end

  local project_root = git_utils.get_toplevel(cwd)
  return project_root
end

function M.load_project_status(cwd)
  if not M.config.enable then
    return {}
  end

  local project_root = M.get_project_root(cwd)
  if not project_root then
    M.cwd_to_project_root[cwd] = false
    return {}
  end

  local status = M.projects[project_root]
  if status then
    return status
  end

  local git_status = Runner.run {
    project_root = project_root,
    list_untracked = git_utils.should_show_untracked(project_root),
    list_ignored = true,
    timeout = M.config.timeout,
  }
  M.projects[project_root] = {
    files = git_status,
    dirs = git_utils.file_status_to_dir_status(git_status, project_root),
  }
  return M.projects[project_root]
end

function M.setup(opts)
  M.config = opts.git
end

return M
