local fn = vim.fn
local utils = require "nvim-treesitter.utils"

-- Convert path for cmd.exe on Windows.
-- This is needed when vim.opt.shellslash is in use.
---@param p string
---@return string
local function cmdpath(p)
  if vim.opt.shellslash:get() then
    local r = p:gsub("/", "\\")
    return r
  else
    return p
  end
end

local M = {}

-- Returns the mkdir command based on the OS
---@param directory string
---@param cwd string
---@param info_msg string
---@return table
function M.select_mkdir_cmd(directory, cwd, info_msg)
  if fn.has "win32" == 1 then
    return {
      cmd = "cmd",
      opts = {
        args = { "/C", "mkdir", cmdpath(directory) },
        cwd = cwd,
      },
      info = info_msg,
      err = "Could not create " .. directory,
    }
  else
    return {
      cmd = "mkdir",
      opts = {
        args = { directory },
        cwd = cwd,
      },
      info = info_msg,
      err = "Could not create " .. directory,
    }
  end
end

-- Returns the remove command based on the OS
---@param file string
---@param info_msg string
---@return table
function M.select_rm_file_cmd(file, info_msg)
  if fn.has "win32" == 1 then
    return {
      cmd = "cmd",
      opts = {
        args = { "/C", "if", "exist", cmdpath(file), "del", cmdpath(file) },
      },
      info = info_msg,
      err = "Could not delete " .. file,
    }
  else
    return {
      cmd = "rm",
      opts = {
        args = { file },
      },
      info = info_msg,
      err = "Could not delete " .. file,
    }
  end
end

---@param executables string[]
---@return string|nil
function M.select_executable(executables)
  return vim.tbl_filter(function(c) ---@param c string
    return c ~= vim.NIL and fn.executable(c) == 1
  end, executables)[1]
end

-- Returns the compiler arguments based on the compiler and OS
---@param repo InstallInfo
---@param compiler string
---@return string[]
function M.select_compiler_args(repo, compiler)
  if string.match(compiler, "cl$") or string.match(compiler, "cl.exe$") then
    return {
      "/Fe:",
      "parser.so",
      "/Isrc",
      repo.files,
      "-Os",
      "/LD",
    }
  elseif string.match(compiler, "zig$") or string.match(compiler, "zig.exe$") then
    return {
      "c++",
      "-o",
      "parser.so",
      repo.files,
      "-lc",
      "-Isrc",
      "-shared",
      "-Os",
    }
  else
    local args = {
      "-o",
      "parser.so",
      "-I./src",
      repo.files,
      "-Os",
    }
    if fn.has "mac" == 1 then
      table.insert(args, "-bundle")
    else
      table.insert(args, "-shared")
    end
    if
      #vim.tbl_filter(function(file) ---@param file string
        local ext = vim.fn.fnamemodify(file, ":e")
        return ext == "cc" or ext == "cpp" or ext == "cxx"
      end, repo.files) > 0
    then
      table.insert(args, "-lstdc++")
    end
    if fn.has "win32" == 0 then
      table.insert(args, "-fPIC")
    end
    return args
  end
end

-- Returns the compile command based on the OS and user options
---@param repo InstallInfo
---@param cc string
---@param compile_location string
---@return Command
function M.select_compile_command(repo, cc, compile_location)
  local make = M.select_executable { "gmake", "make" }
  if
    string.match(cc, "cl$")
    or string.match(cc, "cl.exe$")
    or not repo.use_makefile
    or fn.has "win32" == 1
    or not make
  then
    return {
      cmd = cc,
      info = "Compiling...",
      err = "Error during compilation",
      opts = {
        args = vim.tbl_flatten(M.select_compiler_args(repo, cc)),
        cwd = compile_location,
      },
    }
  else
    return {
      cmd = make,
      info = "Compiling...",
      err = "Error during compilation",
      opts = {
        args = {
          "--makefile=" .. utils.join_path(utils.get_package_path(), "scripts", "compile_parsers.makefile"),
          "CC=" .. cc,
          "CXX_STANDARD=" .. (repo.cxx_standard or "c++14"),
        },
        cwd = compile_location,
      },
    }
  end
end

-- Returns the remove command based on the OS
---@param cache_folder string
---@param project_name string
---@return Command
function M.select_install_rm_cmd(cache_folder, project_name)
  if fn.has "win32" == 1 then
    local dir = cache_folder .. "\\" .. project_name
    return {
      cmd = "cmd",
      opts = {
        args = { "/C", "if", "exist", cmdpath(dir), "rmdir", "/s", "/q", cmdpath(dir) },
      },
    }
  else
    return {
      cmd = "rm",
      opts = {
        args = { "-rf", cache_folder .. "/" .. project_name },
      },
    }
  end
end

-- Returns the move command based on the OS
---@param from string
---@param to string
---@param cwd string
---@return Command
function M.select_mv_cmd(from, to, cwd)
  if fn.has "win32" == 1 then
    return {
      cmd = "cmd",
      opts = {
        args = { "/C", "move", "/Y", cmdpath(from), cmdpath(to) },
        cwd = cwd,
      },
    }
  else
    return {
      cmd = "mv",
      opts = {
        args = { "-f", from, to },
        cwd = cwd,
      },
    }
  end
end

---@param repo InstallInfo
---@param project_name string
---@param cache_folder string
---@param revision string|nil
---@param prefer_git boolean
---@return table
function M.select_download_commands(repo, project_name, cache_folder, revision, prefer_git)
  local can_use_tar = vim.fn.executable "tar" == 1 and vim.fn.executable "curl" == 1
  local is_github = repo.url:find("github.com", 1, true)
  local is_gitlab = repo.url:find("gitlab.com", 1, true)

  revision = revision or repo.branch or "master"

  if can_use_tar and (is_github or is_gitlab) and not prefer_git then
    local path_sep = utils.get_path_sep()
    local url = repo.url:gsub(".git$", "")

    local folder_rev = revision
    if is_github and revision:match "^v%d" then
      folder_rev = revision:sub(2)
    end

    return {
      M.select_install_rm_cmd(cache_folder, project_name .. "-tmp"),
      {
        cmd = "curl",
        info = "Downloading " .. project_name .. "...",
        err = "Error during download, please verify your internet connection",
        opts = {
          args = {
            "--silent",
            "-L", -- follow redirects
            is_github and url .. "/archive/" .. revision .. ".tar.gz"
              or url .. "/-/archive/" .. revision .. "/" .. project_name .. "-" .. revision .. ".tar.gz",
            "--output",
            project_name .. ".tar.gz",
          },
          cwd = cache_folder,
        },
      },
      M.select_mkdir_cmd(project_name .. "-tmp", cache_folder, "Creating temporary directory"),
      {
        cmd = "tar",
        info = "Extracting " .. project_name .. "...",
        err = "Error during tarball extraction.",
        opts = {
          args = {
            "-xvzf",
            project_name .. ".tar.gz",
            "-C",
            project_name .. "-tmp",
          },
          cwd = cache_folder,
        },
      },
      M.select_rm_file_cmd(cache_folder .. path_sep .. project_name .. ".tar.gz"),
      M.select_mv_cmd(
        utils.join_path(project_name .. "-tmp", url:match "[^/]-$" .. "-" .. folder_rev),
        project_name,
        cache_folder
      ),
      M.select_install_rm_cmd(cache_folder, project_name .. "-tmp"),
    }
  else
    local git_folder = utils.join_path(cache_folder, project_name)
    local clone_error = "Error during download, please verify your internet connection"

    return {
      {
        cmd = "git",
        info = "Downloading " .. project_name .. "...",
        err = clone_error,
        opts = {
          args = {
            "clone",
            repo.url,
            project_name,
          },
          cwd = cache_folder,
        },
      },
      {
        cmd = "git",
        info = "Checking out locked revision",
        err = "Error while checking out revision",
        opts = {
          args = {
            "checkout",
            revision,
          },
          cwd = git_folder,
        },
      },
    }
  end
end

---@param dir string
---@param command string
---@return string command
function M.make_directory_change_for_command(dir, command)
  if fn.has "win32" == 1 then
    if string.find(vim.o.shell, "cmd") ~= nil then
      return string.format("pushd %s & %s & popd", cmdpath(dir), command)
    else
      return string.format("pushd %s ; %s ; popd", cmdpath(dir), command)
    end
  else
    return string.format("cd %s;\n %s", dir, command)
  end
end

return M
