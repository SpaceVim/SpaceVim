local api = vim.api
local tsq = require "vim.treesitter.query"
local tsrange = require "nvim-treesitter.tsrange"
local utils = require "nvim-treesitter.utils"
local parsers = require "nvim-treesitter.parsers"
local caching = require "nvim-treesitter.caching"

local M = {}

local EMPTY_ITER = function() end

M.built_in_query_groups = { "highlights", "locals", "folds", "indents", "injections" }

-- Creates a function that checks whether a given query exists
-- for a specific language.
local function get_query_guard(query)
  return function(lang)
    return M.has_query_files(lang, query)
  end
end

for _, query in ipairs(M.built_in_query_groups) do
  M["has_" .. query] = get_query_guard(query)
end

function M.available_query_groups()
  local query_files = api.nvim_get_runtime_file("queries/*/*.scm", true)
  local groups = {}
  for _, f in ipairs(query_files) do
    groups[vim.fn.fnamemodify(f, ":t:r")] = true
  end
  local list = {}
  for k, _ in pairs(groups) do
    table.insert(list, k)
  end
  return list
end

do
  local query_cache = caching.create_buffer_cache()

  local function update_cached_matches(bufnr, changed_tick, query_group)
    query_cache.set(query_group, bufnr, {
      tick = changed_tick,
      cache = M.collect_group_results(bufnr, query_group) or {},
    })
  end

  function M.get_matches(bufnr, query_group)
    bufnr = bufnr or api.nvim_get_current_buf()
    local cached_local = query_cache.get(query_group, bufnr)
    if not cached_local or api.nvim_buf_get_changedtick(bufnr) > cached_local.tick then
      update_cached_matches(bufnr, api.nvim_buf_get_changedtick(bufnr), query_group)
    end

    return query_cache.get(query_group, bufnr).cache
  end
end

local function runtime_queries(lang, query_name)
  return api.nvim_get_runtime_file(string.format("queries/%s/%s.scm", lang, query_name), true) or {}
end

local query_files_cache = {}
function M.has_query_files(lang, query_name)
  if not query_files_cache[lang] then
    query_files_cache[lang] = {}
  end
  if query_files_cache[lang][query_name] == nil then
    local files = runtime_queries(lang, query_name)
    query_files_cache[lang][query_name] = files and #files > 0
  end
  return query_files_cache[lang][query_name]
end

do
  local mt = {}
  mt.__index = function(tbl, key)
    if rawget(tbl, key) == nil then
      rawset(tbl, key, {})
    end
    return rawget(tbl, key)
  end

  -- cache will auto set the table for each lang if it is nil
  local cache = setmetatable({}, mt)

  --- Same as `vim.treesitter.query` except will return cached values
  function M.get_query(lang, query_name)
    if cache[lang][query_name] == nil then
      cache[lang][query_name] = tsq.get_query(lang, query_name)
    end

    return cache[lang][query_name]
  end

  --- Invalidates the query file cache.
  --- If lang and query_name is both present, will reload for only the lang and query_name.
  --- If only lang is present, will reload all query_names for that lang
  --- If none are present, will reload everything
  function M.invalidate_query_cache(lang, query_name)
    if lang and query_name then
      cache[lang][query_name] = nil
      if query_files_cache[lang] then
        query_files_cache[lang][query_name] = nil
      end
    elseif lang and not query_name then
      query_files_cache[lang] = nil
      for query_name, _ in pairs(cache[lang]) do
        M.invalidate_query_cache(lang, query_name)
      end
    elseif not lang and not query_name then
      query_files_cache = {}
      for lang, _ in pairs(cache) do
        for query_name, _ in pairs(cache[lang]) do
          M.invalidate_query_cache(lang, query_name)
        end
      end
    else
      error "Cannot have query_name by itself!"
    end
  end
end

--- This function is meant for an autocommand and not to be used. Only use if file is a query file.
function M.invalidate_query_file(fname)
  local fnamemodify = vim.fn.fnamemodify
  M.invalidate_query_cache(fnamemodify(fname, ":p:h:t"), fnamemodify(fname, ":t:r"))
end

local function prepare_query(bufnr, query_name, root, root_lang)
  local buf_lang = parsers.get_buf_lang(bufnr)

  if not buf_lang then
    return
  end

  local parser = parsers.get_parser(bufnr, buf_lang)
  if not parser then
    return
  end

  if not root then
    local first_tree = parser:trees()[1]

    if first_tree then
      root = first_tree:root()
    end
  end

  if not root then
    return
  end

  local range = { root:range() }

  if not root_lang then
    local lang_tree = parser:language_for_range(range)

    if lang_tree then
      root_lang = lang_tree:lang()
    end
  end

  if not root_lang then
    return
  end

  local query = M.get_query(root_lang, query_name)
  if not query then
    return
  end

  return query,
    {
      root = root,
      source = bufnr,
      start = range[1],
      -- The end row is exclusive so we need to add 1 to it.
      stop = range[3] + 1,
    }
end

function M.iter_prepared_matches(query, qnode, bufnr, start_row, end_row)
  -- A function that splits  a string on '.'
  local function split(string)
    local t = {}
    for str in string.gmatch(string, "([^.]+)") do
      table.insert(t, str)
    end

    return t
  end
  -- Given a path (i.e. a List(String)) this functions inserts value at path
  local function insert_to_path(object, path, value)
    local curr_obj = object

    for index = 1, (#path - 1) do
      if curr_obj[path[index]] == nil then
        curr_obj[path[index]] = {}
      end

      curr_obj = curr_obj[path[index]]
    end

    curr_obj[path[#path]] = value
  end

  local matches = query:iter_matches(qnode, bufnr, start_row, end_row)

  local function iterator()
    local pattern, match = matches()
    if pattern ~= nil then
      local prepared_match = {}

      -- Extract capture names from each match
      for id, node in pairs(match) do
        local name = query.captures[id] -- name of the capture in the query
        if name ~= nil then
          local path = split(name .. ".node")
          insert_to_path(prepared_match, path, node)
        end
      end

      -- Add some predicates for testing
      local preds = query.info.patterns[pattern]
      if preds then
        for _, pred in pairs(preds) do
          -- functions
          if pred[1] == "set!" and type(pred[2]) == "string" then
            insert_to_path(prepared_match, split(pred[2]), pred[3])
          end
          if pred[1] == "make-range!" and type(pred[2]) == "string" and #pred == 4 then
            insert_to_path(
              prepared_match,
              split(pred[2] .. ".node"),
              tsrange.TSRange.from_nodes(bufnr, match[pred[3]], match[pred[4]])
            )
          end
        end
      end

      return prepared_match
    end
  end
  return iterator
end

--- Return all nodes corresponding to a specific capture path (like @definition.var, @reference.type)
-- Works like M.get_references or M.get_scopes except you can choose the capture
-- Can also be a nested capture like @definition.function to get all nodes defining a function.
--
-- @param bufnr the buffer
-- @param captures a single string or a list of strings
-- @param query_group the name of query group (highlights or injections for example)
-- @param root (optional) node from where to start the search
-- @param lang (optional) the language from where to get the captures.
--             Root nodes can have several languages.
function M.get_capture_matches(bufnr, captures, query_group, root, lang)
  if type(captures) == "string" then
    captures = { captures }
  end
  local strip_captures = {}
  for i, capture in ipairs(captures) do
    if capture:sub(1, 1) ~= "@" then
      error 'Captures must start with "@"'
      return
    end
    -- Remove leading "@".
    strip_captures[i] = capture:sub(2)
  end

  local matches = {}
  for match in M.iter_group_results(bufnr, query_group, root, lang) do
    for _, capture in ipairs(strip_captures) do
      local insert = utils.get_at_path(match, capture)
      if insert then
        table.insert(matches, insert)
      end
    end
  end
  return matches
end

function M.iter_captures(bufnr, query_name, root, lang)
  local query, params = prepare_query(bufnr, query_name, root, lang)
  if not query then
    return EMPTY_ITER
  end

  local iter = query:iter_captures(params.root, params.source, params.start, params.stop)

  local function wrapped_iter()
    local id, node, metadata = iter()
    if not id then
      return
    end

    local name = query.captures[id]
    if string.sub(name, 1, 1) == "_" then
      return wrapped_iter()
    end

    return name, node, metadata
  end

  return wrapped_iter
end

function M.find_best_match(bufnr, capture_string, query_group, filter_predicate, scoring_function, root)
  if string.sub(capture_string, 1, 1) == "@" then
    --remove leading "@"
    capture_string = string.sub(capture_string, 2)
  end

  local best
  local best_score

  for maybe_match in M.iter_group_results(bufnr, query_group, root) do
    local match = utils.get_at_path(maybe_match, capture_string)

    if match and filter_predicate(match) then
      local current_score = scoring_function(match)
      if not best then
        best = match
        best_score = current_score
      end
      if current_score > best_score then
        best = match
        best_score = current_score
      end
    end
  end
  return best
end

-- Iterates matches from a query file.
-- @param bufnr the buffer
-- @param query_group the query file to use
-- @param root the root node
-- @param root the root node lang, if known
function M.iter_group_results(bufnr, query_group, root, root_lang)
  local query, params = prepare_query(bufnr, query_group, root, root_lang)
  if not query then
    return EMPTY_ITER
  end

  return M.iter_prepared_matches(query, params.root, params.source, params.start, params.stop)
end

function M.collect_group_results(bufnr, query_group, root, lang)
  local matches = {}

  for prepared_match in M.iter_group_results(bufnr, query_group, root, lang) do
    table.insert(matches, prepared_match)
  end

  return matches
end

--- Same as get_capture_matches except this will recursively get matches for every language in the tree.
-- @param bufnr The bufnr
-- @param capture_or_fn The capture to get. If a function is provided then that
--                      function will be used to resolve both the capture and query argument.
--                      The function can return `nil` to ignore that tree.
-- @param query_type The query to get the capture from. This is ignore if a function is provided
--                   for the captuer argument.
function M.get_capture_matches_recursively(bufnr, capture_or_fn, query_type)
  local type_fn = type(capture_or_fn) == "function" and capture_or_fn
    or function()
      return capture_or_fn, query_type
    end
  local parser = parsers.get_parser(bufnr)
  local matches = {}

  if parser then
    parser:for_each_tree(function(tree, lang_tree)
      local lang = lang_tree:lang()
      local capture, type_ = type_fn(lang, tree, lang_tree)

      if capture then
        vim.list_extend(matches, M.get_capture_matches(bufnr, capture, type_, tree:root(), lang))
      end
    end)
  end

  return matches
end

return M
