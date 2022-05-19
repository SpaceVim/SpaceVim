local a = vim.api
local utils = require "nvim-tree.utils"
local view = require "nvim-tree.view"
local core = require "nvim-tree.core"
local log = require "nvim-tree.log"

local M = {}

local GROUP = "NvimTreeDiagnosticSigns"

local function get_lowest_severity(diagnostics)
  local severity = math.huge
  for _, v in ipairs(diagnostics) do
    if v.severity < severity then
      severity = v.severity
    end
  end
  return severity
end

local severity_levels = { Error = 1, Warning = 2, Information = 3, Hint = 4 }
local sign_names = {
  { "NvimTreeSignError", "NvimTreeLspDiagnosticsError" },
  { "NvimTreeSignWarning", "NvimTreeLspDiagnosticsWarning" },
  { "NvimTreeSignInformation", "NvimTreeLspDiagnosticsInformation" },
  { "NvimTreeSignHint", "NvimTreeLspDiagnosticsHint" },
}

local function add_sign(linenr, severity)
  local buf = view.get_bufnr()
  if not a.nvim_buf_is_valid(buf) or not a.nvim_buf_is_loaded(buf) then
    return
  end
  local sign_name = sign_names[severity][1]
  vim.fn.sign_place(1, GROUP, sign_name, buf, { lnum = linenr + 1 })
end

local function from_nvim_lsp()
  local buffer_severity = {}

  -- vim.lsp.diagnostic.get_all was deprecated in nvim 0.7 and replaced with vim.diagnostic.get
  -- This conditional can be removed when the minimum required version of nvim is changed to 0.7.
  if vim.diagnostic then
    -- nvim version >= 0.7
    for _, diagnostic in ipairs(vim.diagnostic.get()) do
      local buf = diagnostic.bufnr
      if a.nvim_buf_is_valid(buf) then
        local bufname = a.nvim_buf_get_name(buf)
        local lowest_severity = buffer_severity[bufname]
        if not lowest_severity or diagnostic.severity < lowest_severity then
          buffer_severity[bufname] = diagnostic.severity
        end
      end
    end
  else
    -- nvim version < 0.7
    for buf, diagnostics in pairs(vim.lsp.diagnostic.get_all()) do
      if a.nvim_buf_is_valid(buf) then
        local bufname = a.nvim_buf_get_name(buf)
        if not buffer_severity[bufname] then
          local severity = get_lowest_severity(diagnostics)
          buffer_severity[bufname] = severity
        end
      end
    end
  end

  return buffer_severity
end

local function from_coc()
  if vim.g.coc_service_initialized ~= 1 then
    return {}
  end

  local diagnostic_list = vim.fn.CocAction "diagnosticList"
  if type(diagnostic_list) ~= "table" or vim.tbl_isempty(diagnostic_list) then
    return {}
  end

  local buffer_severity = {}
  local diagnostics = {}

  for _, diagnostic in ipairs(diagnostic_list) do
    local bufname = diagnostic.file
    local severity = severity_levels[diagnostic.severity]

    local severity_list = diagnostics[bufname] or {}
    table.insert(severity_list, severity)
    diagnostics[bufname] = severity_list
  end

  for bufname, severity_list in pairs(diagnostics) do
    if not buffer_severity[bufname] then
      local severity = math.min(unpack(severity_list))
      buffer_severity[bufname] = severity
    end
  end

  return buffer_severity
end

local function is_using_coc()
  return vim.g.coc_service_initialized == 1
end

function M.clear()
  if not M.enable or not view.is_buf_valid(view.get_bufnr()) then
    return
  end

  vim.fn.sign_unplace(GROUP)
end

function M.update()
  if not M.enable or not core.get_explorer() or not view.is_buf_valid(view.get_bufnr()) then
    return
  end
  local ps = log.profile_start "diagnostics update"
  log.line("diagnostics", "update")

  local buffer_severity
  if is_using_coc() then
    buffer_severity = from_coc()
  else
    buffer_severity = from_nvim_lsp()
  end

  M.clear()
  for bufname, severity in pairs(buffer_severity) do
    local bufpath = utils.canonical_path(bufname)
    log.line("diagnostics", " bufpath '%s' severity %d", bufpath, severity)
    if 0 < severity and severity < 5 then
      local node, line = utils.find_node(core.get_explorer().nodes, function(node)
        local nodepath = utils.canonical_path(node.absolute_path)
        log.line("diagnostics", "  checking nodepath '%s'", nodepath)
        if M.show_on_dirs and not node.open then
          return vim.startswith(bufpath, nodepath)
        else
          return nodepath == bufpath
        end
      end)
      if node then
        log.line("diagnostics", " matched node '%s'", node.absolute_path)
        add_sign(line, severity)
      end
    end
  end
  log.profile_end(ps, "diagnostics update")
end

local links = {
  NvimTreeLspDiagnosticsError = "DiagnosticError",
  NvimTreeLspDiagnosticsWarning = "DiagnosticWarn",
  NvimTreeLspDiagnosticsInformation = "DiagnosticInfo",
  NvimTreeLspDiagnosticsHint = "DiagnosticHint",
}

function M.setup(opts)
  M.enable = opts.diagnostics.enable
  M.show_on_dirs = opts.diagnostics.show_on_dirs
  vim.fn.sign_define(sign_names[1][1], { text = opts.diagnostics.icons.error, texthl = sign_names[1][2] })
  vim.fn.sign_define(sign_names[2][1], { text = opts.diagnostics.icons.warning, texthl = sign_names[2][2] })
  vim.fn.sign_define(sign_names[3][1], { text = opts.diagnostics.icons.info, texthl = sign_names[3][2] })
  vim.fn.sign_define(sign_names[4][1], { text = opts.diagnostics.icons.hint, texthl = sign_names[4][2] })

  for lhs, rhs in pairs(links) do
    vim.cmd("hi def link " .. lhs .. " " .. rhs)
  end

  if M.enable then
    log.line("diagnostics", "setup")
    vim.cmd "au DiagnosticChanged * lua require'nvim-tree.diagnostics'.update()"
    vim.cmd "au User CocDiagnosticChange lua require'nvim-tree.diagnostics'.update()"
  end
end

return M
