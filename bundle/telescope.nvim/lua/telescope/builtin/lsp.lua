local channel = require("plenary.async.control").channel

local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local utils = require "telescope.utils"

local lsp = {}

lsp.references = function(opts)
  local filepath = vim.api.nvim_buf_get_name(opts.bufnr)
  local lnum = vim.api.nvim_win_get_cursor(opts.winnr)[1]
  local params = vim.lsp.util.make_position_params(opts.winnr)
  local include_current_line = vim.F.if_nil(opts.include_current_line, false)
  params.context = { includeDeclaration = vim.F.if_nil(opts.include_declaration, true) }

  vim.lsp.buf_request(opts.bufnr, "textDocument/references", params, function(err, result, ctx, _)
    if err then
      vim.api.nvim_err_writeln("Error when finding references: " .. err.message)
      return
    end

    local locations = {}
    if result then
      local results = vim.lsp.util.locations_to_items(result, vim.lsp.get_client_by_id(ctx.client_id).offset_encoding)
      if include_current_line then
        locations = vim.tbl_filter(function(v)
          -- Remove current line from result
          return not (v.filename == filepath and v.lnum == lnum)
        end, vim.F.if_nil(results, {}))
      else
        locations = vim.F.if_nil(results, {})
      end
    end

    if vim.tbl_isempty(locations) then
      return
    end

    pickers.new(opts, {
      prompt_title = "LSP References",
      finder = finders.new_table {
        results = locations,
        entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.generic_sorter(opts),
      push_cursor_on_edit = true,
    }):find()
  end)
end

local function list_or_jump(action, title, opts)
  opts = opts or {}

  local params = vim.lsp.util.make_position_params(opts.winnr)
  vim.lsp.buf_request(opts.bufnr, action, params, function(err, result, ctx, _)
    if err then
      vim.api.nvim_err_writeln("Error when executing " .. action .. " : " .. err.message)
      return
    end
    local flattened_results = {}
    if result then
      -- textDocument/definition can return Location or Location[]
      if not vim.tbl_islist(result) then
        flattened_results = { result }
      end

      vim.list_extend(flattened_results, result)
    end

    local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding

    if #flattened_results == 0 then
      return
    elseif #flattened_results == 1 and opts.jump_type ~= "never" then
      if opts.jump_type == "tab" then
        vim.cmd "tabedit"
      elseif opts.jump_type == "split" then
        vim.cmd "new"
      elseif opts.jump_type == "vsplit" then
        vim.cmd "vnew"
      end
      vim.lsp.util.jump_to_location(flattened_results[1], offset_encoding)
    else
      local locations = vim.lsp.util.locations_to_items(flattened_results, offset_encoding)
      pickers.new(opts, {
        prompt_title = title,
        finder = finders.new_table {
          results = locations,
          entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
        },
        previewer = conf.qflist_previewer(opts),
        sorter = conf.generic_sorter(opts),
      }):find()
    end
  end)
end

lsp.definitions = function(opts)
  return list_or_jump("textDocument/definition", "LSP Definitions", opts)
end

lsp.type_definitions = function(opts)
  return list_or_jump("textDocument/typeDefinition", "LSP Type Definitions", opts)
end

lsp.implementations = function(opts)
  return list_or_jump("textDocument/implementation", "LSP Implementations", opts)
end

lsp.document_symbols = function(opts)
  local params = vim.lsp.util.make_position_params(opts.winnr)
  vim.lsp.buf_request(opts.bufnr, "textDocument/documentSymbol", params, function(err, result, _, _)
    if err then
      vim.api.nvim_err_writeln("Error when finding document symbols: " .. err.message)
      return
    end

    if not result or vim.tbl_isempty(result) then
      utils.notify("builtin.lsp_document_symbols", {
        msg = "No results from textDocument/documentSymbol",
        level = "INFO",
      })
      return
    end

    local locations = vim.lsp.util.symbols_to_items(result or {}, opts.bufnr) or {}
    locations = utils.filter_symbols(locations, opts)
    if locations == nil then
      -- error message already printed in `utils.filter_symbols`
      return
    end

    if vim.tbl_isempty(locations) then
      utils.notify("builtin.lsp_document_symbols", {
        msg = "No document_symbol locations found",
        level = "INFO",
      })
      return
    end

    opts.ignore_filename = opts.ignore_filename or true
    pickers.new(opts, {
      prompt_title = "LSP Document Symbols",
      finder = finders.new_table {
        results = locations,
        entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.prefilter_sorter {
        tag = "symbol_type",
        sorter = conf.generic_sorter(opts),
      },
      push_cursor_on_edit = true,
    }):find()
  end)
end

lsp.workspace_symbols = function(opts)
  local params = { query = opts.query or "" }
  vim.lsp.buf_request(opts.bufnr, "workspace/symbol", params, function(err, server_result, _, _)
    if err then
      vim.api.nvim_err_writeln("Error when finding workspace symbols: " .. err.message)
      return
    end

    local locations = vim.lsp.util.symbols_to_items(server_result or {}, opts.bufnr) or {}
    locations = utils.filter_symbols(locations, opts)
    if locations == nil then
      -- error message already printed in `utils.filter_symbols`
      return
    end

    if vim.tbl_isempty(locations) then
      utils.notify("builtin.lsp_workspace_symbols", {
        msg = "No results from workspace/symbol. Maybe try a different query: "
          .. "'Telescope lsp_workspace_symbols query=example'",
        level = "INFO",
      })
      return
    end

    opts.ignore_filename = utils.get_default(opts.ignore_filename, false)

    pickers.new(opts, {
      prompt_title = "LSP Workspace Symbols",
      finder = finders.new_table {
        results = locations,
        entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.prefilter_sorter {
        tag = "symbol_type",
        sorter = conf.generic_sorter(opts),
      },
    }):find()
  end)
end

local function get_workspace_symbols_requester(bufnr, opts)
  local cancel = function() end

  return function(prompt)
    local tx, rx = channel.oneshot()
    cancel()
    _, cancel = vim.lsp.buf_request(bufnr, "workspace/symbol", { query = prompt }, tx)

    -- Handle 0.5 / 0.5.1 handler situation
    local err, res = rx()
    assert(not err, err)

    local locations = vim.lsp.util.symbols_to_items(res or {}, bufnr) or {}
    if not vim.tbl_isempty(locations) then
      locations = utils.filter_symbols(locations, opts) or {}
    end
    return locations
  end
end

lsp.dynamic_workspace_symbols = function(opts)
  pickers.new(opts, {
    prompt_title = "LSP Dynamic Workspace Symbols",
    finder = finders.new_dynamic {
      entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
      fn = get_workspace_symbols_requester(opts.bufnr, opts),
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

local function check_capabilities(feature, bufnr)
  local clients = vim.lsp.buf_get_clients(bufnr)

  local supported_client = false
  for _, client in pairs(clients) do
    supported_client = client.server_capabilities[feature]
    if supported_client then
      break
    end
  end

  if supported_client then
    return true
  else
    if #clients == 0 then
      utils.notify("builtin.lsp_*", {
        msg = "no client attached",
        level = "INFO",
      })
    else
      utils.notify("builtin.lsp_*", {
        msg = "server does not support " .. feature,
        level = "INFO",
      })
    end
    return false
  end
end

local feature_map = {
  ["document_symbols"] = "documentSymbolProvider",
  ["references"] = "referencesProvider",
  ["definitions"] = "definitionProvider",
  ["type_definitions"] = "typeDefinitionProvider",
  ["implementations"] = "implementationProvider",
  ["workspace_symbols"] = "workspaceSymbolProvider",
}

local function apply_checks(mod)
  for k, v in pairs(mod) do
    mod[k] = function(opts)
      opts = opts or {}

      local feature_name = feature_map[k]
      if feature_name and not check_capabilities(feature_name, opts.bufnr) then
        return
      end
      v(opts)
    end
  end

  return mod
end

return apply_checks(lsp)
