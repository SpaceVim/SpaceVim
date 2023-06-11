local util = require("cmp_dictionary.util")
local config = require("cmp_dictionary.config")
local Async = require("cmp_dictionary.kit.Async")
local Worker = require("cmp_dictionary.kit.Thread.Worker")

local SQLite = {}

local just_updated = false

---@return table db
function SQLite:open()
  if self.db then
    return self.db
  end

  local ok, sqlite = pcall(require, "sqlite")
  if not ok or sqlite == nil then
    error("[cmp-dictionary] sqlite.lua is not installed!")
  end

  local db_path = vim.fn.stdpath("data") .. "/cmp-dictionary.sqlite3"
  self.db = sqlite:open(db_path)
  if not self.db then
    error("[cmp-dictionary] Error in opening DB")
  end

  if not self.db:exists("dictionary") then
    self.db:create("dictionary", {
      filepath = { "text", primary = true },
      mtime = { "integer", required = true },
      valid = { "integer", default = 1 },
    })
  end

  if not self.db:exists("items") then
    self.db:create("items", {
      label = { "text", required = true },
      detail = { "text", required = true },
      filepath = { "text", required = true },
      documentation = "text",
    })
  end

  vim.api.nvim_create_autocmd("VimLeave", {
    group = vim.api.nvim_create_augroup("cmp-dictionary-database", {}),
    callback = function()
      self.db:close()
    end,
  })

  return self.db
end

function SQLite:exists_index(name)
  self:open()
  -- Can't use db:select() for sqlite_master.
  local result = self.db:eval("SELECT * FROM sqlite_master WHERE type = 'index' AND name = ?", name)
  return type(result) == "table" and #result == 1
end

function SQLite:index(tbl_name, column)
  local name = column .. "index"
  if SQLite:exists_index(name) then
    self.db:execute("DROP INDEX " .. name)
  end
  self.db:execute(("CREATE INDEX %s ON %s(%s)"):format(name, tbl_name, column))
end

local function need_to_load(db)
  local dictionaries = util.get_dictionaries()
  local updated_or_new = {}
  for _, dictionary in ipairs(dictionaries) do
    local path = vim.fn.expand(dictionary)
    if util.bool_fn.filereadable(path) then
      local mtime = vim.fn.getftime(path)
      local mtime_cache = db:select("dictionary", { select = "mtime", where = { filepath = path } })
      if mtime_cache[1] and mtime_cache[1].mtime == mtime then
        db:update("dictionary", {
          set = { valid = 1 },
          where = { filepath = path },
        })
      else
        table.insert(updated_or_new, { path = path, mtime = mtime })
      end
    end
  end
  return updated_or_new
end

local read_items = Worker.new(function(path, name)
  local buffer = require("cmp_dictionary.util").read_file_sync(path)

  local detail = string.format("belong to `%s`", name)
  local items = {}
  for w in vim.gsplit(buffer, "%s+") do
    if w ~= "" then
      table.insert(items, { label = w, detail = detail, filepath = path })
    end
  end
  return items
end)

local function update(db)
  local buftype = vim.api.nvim_buf_get_option(0, "buftype")
  if buftype ~= "" then
    return
  end

  db:update("dictionary", { set = { valid = 0 } })

  Async.all(vim.tbl_map(function(n)
    local path, mtime = n.path, n.mtime
    local name = vim.fn.fnamemodify(path, ":t")
    return read_items(path, name):next(function(items)
      db:delete("items", { where = { filepath = path } })
      db:insert("items", items)

      -- Index for fast search
      SQLite:index("items", "label")
      SQLite:index("items", "filepath")

      -- If there is no data matching where, it automatically switches to insert.
      db:update("dictionary", {
        set = { mtime = mtime, valid = 1 },
        where = { filepath = path },
      })
    end)
  end, need_to_load(db))):next(function()
    just_updated = true
  end)
end

local DB = {}

function DB.update()
  local db = SQLite:open()
  util.debounce("update_db", function()
    update(db)
  end, 100)
end

---@param req string
---@return lsp.CompletionItem[] items
---@return boolean isIncomplete
function DB.request(req, _)
  local db = SQLite:open()
  local max_items = config.get("max_items")
  local items = db:eval(
    [[
    SELECT label, detail, documentation FROM items
      WHERE filepath IN (SELECT filepath FROM dictionary WHERE valid = 1)
      AND label GLOB :a
      LIMIT :b
    ]],
    { a = req .. "*", b = max_items }
  )
  if type(items) == "table" then
    return items, #items == max_items
  else
    return {}, false
  end
end

function DB.is_just_updated()
  if just_updated then
    just_updated = false
    return true
  end
  return false
end

---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function DB.document(completion_item, callback)
  if completion_item.documentation then
    callback(completion_item)
    return
  end

  local db = SQLite:open()
  local label = completion_item.label
  require("cmp_dictionary.document")(completion_item, function(completion_item_)
    if completion_item_ and completion_item_.documentation then
      -- By first_case_insensitive, the case of the label is ambiguous.
      db:eval(
        "UPDATE items SET documentation = :a WHERE label like :b",
        { a = completion_item_.documentation, b = label }
      )
    end
    callback(completion_item_)
  end)
end

return DB
