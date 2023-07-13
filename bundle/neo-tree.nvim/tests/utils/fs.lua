local Path = require("plenary.path")

local fs = {}

function fs.create_temp_dir()
  -- Resolve for two reasons.
  -- 1. Follow any symlinks which make comparing paths fail. (on macOS, TMPDIR can be under /var which is symlinked to
  --    /private/var)
  -- 2. Remove any double separators (on macOS TMPDIR can end in a trailing / which absolute doesn't remove, this should
  --    be coverted by https://github.com/nvim-lua/plenary.nvim/issues/330).
  local temp_dir = vim.fn.resolve(
    Path:new(
      vim.fn.fnamemodify(vim.fn.tempname(), ":h"),
      string.format("neo-tree-test-%s", vim.fn.rand())
    ):absolute()
  )
  vim.fn.mkdir(temp_dir, "p")
  return temp_dir
end

function fs.create_dir(path)
  local abspath = Path:new(path):absolute()
  vim.fn.mkdir(abspath, "p")
end

function fs.remove_dir(dir, recursive)
  if vim.fn.isdirectory(dir) == 1 then
    return vim.fn.delete(dir, recursive and "rf" or "d") == 0
  end
  return false
end

function fs.write_file(path, content)
  local abspath = Path:new(path):absolute()
  fs.create_dir(vim.fn.fnamemodify(abspath, ":h"))
  vim.fn.writefile(content or {}, abspath)
end

function fs.create_fs_tree(fs_tree)
  local function create_items(items, basedir, relative_root_path)
    relative_root_path = relative_root_path or "."

    for _, item in ipairs(items) do
      local relative_path = relative_root_path .. "/" .. item.name

      -- create lookups
      fs_tree.lookup[relative_path] = item
      if item.id then
        fs_tree.lookup[item.id] = item
      end

      -- create actual files and directories
      if item.type == "dir" then
        item.abspath = Path:new(basedir, item.name):absolute()
        fs.create_dir(item.abspath)
        if item.items then
          create_items(item.items, item.abspath, relative_path)
        end
      elseif item.type == "file" then
        item.abspath = Path:new(basedir, item.name):absolute()
        fs.write_file(item.abspath)
      end
    end
  end

  create_items(fs_tree.items, fs_tree.abspath)

  return fs_tree
end

function fs.init_test(fs_tree)
  fs_tree.lookup = {}
  if not fs_tree.abspath then
    fs_tree.abspath = fs.create_temp_dir()
  end

  local function setup()
    fs.remove_dir(fs_tree.abspath, true)
    fs.create_fs_tree(fs_tree)
    vim.cmd("tcd " .. fs_tree.abspath)
  end

  local function teardown()
    fs.remove_dir(fs_tree.abspath, true)
  end

  return {
    fs_tree = fs_tree,
    setup = setup,
    teardown = teardown,
  }
end

return fs
