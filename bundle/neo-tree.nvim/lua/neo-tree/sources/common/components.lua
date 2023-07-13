-- This file contains the built-in components. Each componment is a function
-- that takes the following arguments:
--      config: A table containing the configuration provided by the user
--              when declaring this component in their renderer config.
--      node:   A NuiNode object for the currently focused node.
--      state:  The current state of the source providing the items.
--
-- The function should return either a table, or a list of tables, each of which
-- contains the following keys:
--    text:      The text to display for this item.
--    highlight: The highlight group to apply to this text.

local highlights = require("neo-tree.ui.highlights")
local utils = require("neo-tree.utils")
local file_nesting = require("neo-tree.sources.common.file-nesting")
local container = require("neo-tree.sources.common.container")
local log = require("neo-tree.log")

local M = {}

local make_two_char = function(symbol)
  if vim.fn.strchars(symbol) == 1 then
    return symbol .. " "
  else
    return symbol
  end
end
-- only works in the buffers component, but it's here so we don't have to defined
-- multple renderers.
M.bufnr = function(config, node, state)
  local highlight = config.highlight or highlights.BUFFER_NUMBER
  local bufnr = node.extra and node.extra.bufnr
  if not bufnr then
    return {}
  end
  return {
    text = string.format("#%s", bufnr),
    highlight = highlight,
  }
end

M.clipboard = function(config, node, state)
  local clipboard = state.clipboard or {}
  local clipboard_state = clipboard[node:get_id()]
  if not clipboard_state then
    return {}
  end
  return {
    text = " (" .. clipboard_state.action .. ")",
    highlight = config.highlight or highlights.DIM_TEXT,
  }
end

M.container = container.render

M.current_filter = function(config, node, state)
  local filter = node.search_pattern or ""
  if filter == "" then
    return {}
  end
  return {
    {
      text = "Find",
      highlight = highlights.DIM_TEXT,
    },
    {
      text = string.format('"%s"', filter),
      highlight = config.highlight or highlights.FILTER_TERM,
    },
    {
      text = "in",
      highlight = highlights.DIM_TEXT,
    },
  }
end

M.diagnostics = function(config, node, state)
  local diag = state.diagnostics_lookup or {}
  local diag_state = diag[node:get_id()]
  if config.hide_when_expanded and node.type == "directory" and node:is_expanded() then
    return {}
  end
  if not diag_state then
    return {}
  end
  if config.errors_only and diag_state.severity_number > 1 then
    return {}
  end
  local severity = diag_state.severity_string
  local defined = vim.fn.sign_getdefined("DiagnosticSign" .. severity)
  if not defined then
    -- backwards compatibility...
    local old_severity = severity
    if severity == "Warning" then
      old_severity = "Warn"
    elseif severity == "Information" then
      old_severity = "Info"
    end
    defined = vim.fn.sign_getdefined("LspDiagnosticsSign" .. old_severity)
  end
  defined = defined and defined[1]

  -- check for overrides in the component config
  local severity_lower = severity:lower()
  if config.symbols and config.symbols[severity_lower] then
    defined = defined or { texthl = "Diagnostic" .. severity }
    defined.text = config.symbols[severity_lower]
  end
  if config.highlights and config.highlights[severity_lower] then
    defined = defined or { text = severity:sub(1, 1) }
    defined.texthl = config.highlights[severity_lower]
  end

  if defined and defined.text and defined.texthl then
    return {
      text = make_two_char(defined.text),
      highlight = defined.texthl,
    }
  else
    return {
      text = severity:sub(1, 1),
      highlight = "Diagnostic" .. severity,
    }
  end
end

M.git_status = function(config, node, state)
  local git_status_lookup = state.git_status_lookup
  if config.hide_when_expanded and node.type == "directory" and node:is_expanded() then
    return {}
  end
  if not git_status_lookup then
    return {}
  end
  local git_status = git_status_lookup[node.path]
  if not git_status then
    if node.filtered_by and node.filtered_by.gitignored then
      git_status = "!!"
    else
      return {}
    end
  end

  local symbols = config.symbols or {}
  local change_symbol
  local change_highlt = highlights.FILE_NAME
  local status_symbol = symbols.staged
  local status_highlt = highlights.GIT_STAGED
  if node.type == "directory" and git_status:len() == 1 then
    status_symbol = nil
  end

  if git_status:sub(1, 1) == " " then
    status_symbol = symbols.unstaged
    status_highlt = highlights.GIT_UNSTAGED
  end

  if git_status:match("?$") then
    status_symbol = nil
    status_highlt = highlights.GIT_UNTRACKED
    change_symbol = symbols.untracked
    change_highlt = highlights.GIT_UNTRACKED
    -- all variations of merge conflicts
  elseif git_status == "DD" then
    status_symbol = symbols.conflict
    status_highlt = highlights.GIT_CONFLICT
    change_symbol = symbols.deleted
    change_highlt = highlights.GIT_CONFLICT
  elseif git_status == "UU" then
    status_symbol = symbols.conflict
    status_highlt = highlights.GIT_CONFLICT
    change_symbol = symbols.modified
    change_highlt = highlights.GIT_CONFLICT
  elseif git_status == "AA" then
    status_symbol = symbols.conflict
    status_highlt = highlights.GIT_CONFLICT
    change_symbol = symbols.added
    change_highlt = highlights.GIT_CONFLICT
  elseif git_status:match("U") then
    status_symbol = symbols.conflict
    status_highlt = highlights.GIT_CONFLICT
    if git_status:match("A") then
      change_symbol = symbols.added
    elseif git_status:match("D") then
      change_symbol = symbols.deleted
    end
    change_highlt = highlights.GIT_CONFLICT
    -- end merge conflict section
  elseif git_status:match("M") then
    change_symbol = symbols.modified
    change_highlt = highlights.GIT_MODIFIED
  elseif git_status:match("R") then
    change_symbol = symbols.renamed
    change_highlt = highlights.GIT_RENAMED
  elseif git_status:match("[ACT]") then
    change_symbol = symbols.added
    change_highlt = highlights.GIT_ADDED
  elseif git_status:match("!") then
    status_symbol = nil
    change_symbol = symbols.ignored
    change_highlt = highlights.GIT_IGNORED
  elseif git_status:match("D") then
    change_symbol = symbols.deleted
    change_highlt = highlights.GIT_DELETED
  end

  if change_symbol or status_symbol then
    local components = {}
    if type(change_symbol) == "string" and #change_symbol > 0 then
      table.insert(components, {
        text = make_two_char(change_symbol),
        highlight = change_highlt,
      })
    end
    if type(status_symbol) == "string" and #status_symbol > 0 then
      table.insert(components, {
        text = make_two_char(status_symbol),
        highlight = status_highlt,
      })
    end
    return components
  else
    return {
      text = "[" .. git_status .. "]",
      highlight = config.highlight or change_highlt,
    }
  end
end

M.filtered_by = function(config, node, state)
  local result = {}
  if type(node.filtered_by) == "table" then
    local fby = node.filtered_by
    if fby.name then
      result = {
        text = "(hide by name)",
        highlight = highlights.HIDDEN_BY_NAME,
      }
    elseif fby.pattern then
      result = {
        text = "(hide by pattern)",
        highlight = highlights.HIDDEN_BY_NAME,
      }
    elseif fby.gitignored then
      result = {
        text = "(gitignored)",
        highlight = highlights.GIT_IGNORED,
      }
    elseif fby.dotfiles then
      result = {
        text = "(dotfile)",
        highlight = highlights.DOTFILE,
      }
    elseif fby.hidden then
      result = {
        text = "(hidden)",
        highlight = highlights.WINDOWS_HIDDEN,
      }
    end
    fby = nil
  end
  return result
end

M.icon = function(config, node, state)
  local icon = config.default or " "
  local highlight = config.highlight or highlights.FILE_ICON
  if node.type == "directory" then
    highlight = highlights.DIRECTORY_ICON
    if node.loaded and not node:has_children() then
      icon = not node.empty_expanded and config.folder_empty or config.folder_empty_open
    elseif node:is_expanded() then
      icon = config.folder_open or "-"
    else
      icon = config.folder_closed or "+"
    end
  elseif node.type == "file" or node.type == "terminal" then
    local success, web_devicons = pcall(require, "nvim-web-devicons")
    if success then
      local devicon, hl = web_devicons.get_icon(node.name, node.ext)
      icon = devicon or icon
      highlight = hl or highlight
    end
  end

  local filtered_by = M.filtered_by(config, node, state)

  return {
    text = icon .. " ",
    highlight = filtered_by.highlight or highlight,
  }
end

M.modified = function(config, node, state)
  local opened_buffers = state.opened_buffers or {}
  local buf_info = opened_buffers[node.path]

  if buf_info and buf_info.modified then
    return {
      text = (make_two_char(config.symbol) or "[+]"),
      highlight = config.highlight or highlights.MODIFIED,
    }
  else
    return {}
  end
end

M.name = function(config, node, state)
  local highlight = config.highlight or highlights.FILE_NAME
  local text = node.name
  if node.type == "directory" then
    highlight = highlights.DIRECTORY_NAME
    if config.trailing_slash and text ~= "/" then
      text = text .. "/"
    end
  end

  if node:get_depth() == 1 and node.type ~= "message" then
    highlight = highlights.ROOT_NAME
  else
    local filtered_by = M.filtered_by(config, node, state)
    highlight = filtered_by.highlight or highlight
    if config.use_git_status_colors then
      local git_status = state.components.git_status({}, node, state)
      if git_status and git_status.highlight then
        highlight = git_status.highlight
      end
    end
  end

  local hl_opened = config.highlight_opened_files
  if hl_opened then
    local opened_buffers = state.opened_buffers or {}
    if
      (hl_opened == "all" and opened_buffers[node.path])
      or (opened_buffers[node.path] and opened_buffers[node.path].loaded)
    then
      highlight = highlights.FILE_NAME_OPENED
    end
  end

  if type(config.right_padding) == "number" then
    if config.right_padding > 0 then
      text = text .. string.rep(" ", config.right_padding)
    end
  else
    text = text
  end

  return {
    text = text,
    highlight = highlight,
  }
end

M.indent = function(config, node, state)
  if not state.skip_marker_at_level then
    state.skip_marker_at_level = {}
  end

  local strlen = vim.fn.strdisplaywidth
  local skip_marker = state.skip_marker_at_level
  local indent_size = config.indent_size or 2
  local padding = config.padding or 0
  local level = node.level
  local with_markers = config.with_markers
  local with_expanders = config.with_expanders == nil and file_nesting.is_enabled()
    or config.with_expanders
  local marker_highlight = config.highlight or highlights.INDENT_MARKER
  local expander_highlight = config.expander_highlight or config.highlight or highlights.EXPANDER

  local function get_expander()
    if with_expanders and utils.is_expandable(node) then
      return node:is_expanded() and (config.expander_expanded or "")
        or (config.expander_collapsed or "")
    end
  end

  if indent_size == 0 or level < 2 or not with_markers then
    local len = indent_size * level + padding
    local expander = get_expander()
    if level == 0 or not expander then
      return {
        text = string.rep(" ", len),
      }
    end
    return {
      text = string.rep(" ", len - strlen(expander) - 1) .. expander .. " ",
      highlight = expander_highlight,
    }
  end

  local indent_marker = config.indent_marker or "│"
  local last_indent_marker = config.last_indent_marker or "└"

  skip_marker[level] = node.is_last_child
  local indent = {}
  if padding > 0 then
    table.insert(indent, { text = string.rep(" ", padding) })
  end

  for i = 1, level do
    local char = ""
    local spaces_count = indent_size
    local highlight = nil

    if i > 1 and not skip_marker[i] or i == level then
      spaces_count = spaces_count - 1
      char = indent_marker
      highlight = marker_highlight
      if i == level then
        local expander = get_expander()
        if expander then
          char = expander
          highlight = expander_highlight
        elseif node.is_last_child then
          char = last_indent_marker
          spaces_count = spaces_count - (vim.api.nvim_strwidth(last_indent_marker) - 1)
        end
      end
    end

    table.insert(indent, { text = char .. string.rep(" ", spaces_count), highlight = highlight })
  end

  return indent
end

M.symlink_target = function(config, node, state)
  if node.is_link then
    return {
      text = string.format(" ➛ %s", node.link_to),
      highlight = config.highlight or highlights.SYMBOLIC_LINK_TARGET,
    }
  else
    return {}
  end
end

return M
