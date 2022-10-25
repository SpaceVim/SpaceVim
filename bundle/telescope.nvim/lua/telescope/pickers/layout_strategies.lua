---@tag telescope.layout
---@config { ["module"] = "telescope.layout" }

---@brief [[
--- The layout of telescope pickers can be adjusted using the
--- |telescope.defaults.layout_strategy| and |telescope.defaults.layout_config| options.
--- For example, the following configuration changes the default layout strategy and the
--- default size of the picker:
--- <code>
---   require('telescope').setup{
---     defaults = {
---       layout_strategy = 'vertical',
---       layout_config = { height = 0.95 },
---     },
---   }
--- </code>
---
--- ────────────────────────────────────────────────────────────────────────────────
---
--- Layout strategies are different functions to position telescope.
---
--- All layout strategies are functions with the following signature:
---
--- <code>
---   function(picker, columns, lines, layout_config)
---     -- Do some calculations here...
---     return {
---       preview = preview_configuration
---       results = results_configuration,
---       prompt = prompt_configuration,
---     }
---   end
--- </code>
---
--- <pre>
---   Parameters: ~
---     - picker        : A Picker object. (docs coming soon)
---     - columns       : (number) Columns in the vim window
---     - lines         : (number) Lines in the vim window
---     - layout_config : (table) The configuration values specific to the picker.
---
--- </pre>
---
--- This means you can create your own layout strategy if you want! Just be aware
--- for now that we may change some APIs or interfaces, so they may break if you create
--- your own.
---
--- A good method for creating your own would be to copy one of the strategies that most
--- resembles what you want from "./lua/telescope/pickers/layout_strategies.lua" in the
--- telescope repo.
---
---@brief ]]

local resolve = require "telescope.config.resolve"
local p_window = require "telescope.pickers.window"

local get_border_size = function(opts)
  if opts.window.border == false then
    return 0
  end

  return 1
end

local calc_tabline = function(max_lines)
  local tbln = (vim.o.showtabline == 2) or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
  if tbln then
    max_lines = max_lines - 1
  end
  return max_lines, tbln
end

-- Helper function for capping over/undersized width/height, and calculating spacing
--@param cur_size number: size to be capped
--@param max_size any: the maximum size, e.g. max_lines or max_columns
--@param bs number: the size of the border
--@param w_num number: the maximum number of windows of the picker in the given direction
--@param b_num number: the number of border rows/column in the given direction (when border enabled)
--@param s_num number: the number of gaps in the given direction (when border disabled)
local calc_size_and_spacing = function(cur_size, max_size, bs, w_num, b_num, s_num)
  local spacing = s_num * (1 - bs) + b_num * bs
  cur_size = math.min(cur_size, max_size)
  cur_size = math.max(cur_size, w_num + spacing)
  return cur_size, spacing
end

local layout_strategies = {}
layout_strategies._configurations = {}

--@param strategy_config table: table with keys for each option for a strategy
--@return table: table with keys for each option (for this strategy) and with keys for each layout_strategy
local get_valid_configuration_keys = function(strategy_config)
  local valid_configuration_keys = {
    -- TEMP: There are a few keys we should say are valid to start with.
    preview_cutoff = true,
    prompt_position = true,
  }

  for key in pairs(strategy_config) do
    valid_configuration_keys[key] = true
  end

  for name in pairs(layout_strategies) do
    valid_configuration_keys[name] = true
  end

  return valid_configuration_keys
end

local adjust_pos = function(pos, ...)
  for _, opts in ipairs { ... } do
    opts.col = opts.col and opts.col + pos[1]
    opts.line = opts.line and opts.line + pos[2]
  end
end

--@param strategy_name string: the name of the layout_strategy we are validating for
--@param configuration table: table with keys for each option available
--@param values table: table containing all of the non-default options we want to set
--@param default_layout_config table: table with the default values to configure layouts
--@return table: table containing the combined options (defaults and non-defaults)
local function validate_layout_config(strategy_name, configuration, values, default_layout_config)
  assert(strategy_name, "It is required to have a strategy name for validation.")
  local valid_configuration_keys = get_valid_configuration_keys(configuration)

  -- If no default_layout_config provided, check Telescope's config values
  default_layout_config = vim.F.if_nil(default_layout_config, require("telescope.config").values.layout_config)

  local result = {}
  local get_value = function(k)
    -- skip "private" items
    if string.sub(k, 1, 1) == "_" then
      return
    end

    local val
    -- Prioritise options that are specific to this strategy
    if values[strategy_name] ~= nil and values[strategy_name][k] ~= nil then
      val = values[strategy_name][k]
    end

    -- Handle nested layout config values
    if layout_strategies[k] and strategy_name ~= k and type(val) == "table" then
      val = vim.tbl_deep_extend("force", default_layout_config[k], val)
    end

    if val == nil and values[k] ~= nil then
      val = values[k]
    end

    if val == nil then
      if default_layout_config[strategy_name] ~= nil and default_layout_config[strategy_name][k] ~= nil then
        val = default_layout_config[strategy_name][k]
      else
        val = default_layout_config[k]
      end
    end

    return val
  end

  -- Always set the values passed first.
  for k in pairs(values) do
    if not valid_configuration_keys[k] then
      -- TODO: At some point we'll move to error here,
      --    but it's a bit annoying to just straight up crash everyone's stuff.
      vim.api.nvim_err_writeln(
        string.format(
          "Unsupported layout_config key for the %s strategy: %s\n%s",
          strategy_name,
          k,
          vim.inspect(values)
        )
      )
    end

    result[k] = get_value(k)
  end

  -- And then set other valid keys via "inheritance" style extension
  for k in pairs(valid_configuration_keys) do
    if result[k] == nil then
      result[k] = get_value(k)
    end
  end

  return result
end

-- List of options that are shared by more than one layout.
local shared_options = {
  width = { "How wide to make Telescope's entire layout", "See |resolver.resolve_width()|" },
  height = { "How tall to make Telescope's entire layout", "See |resolver.resolve_height()|" },
  mirror = "Flip the location of the results/prompt and preview windows",
  scroll_speed = "The number of lines to scroll through the previewer",
  prompt_position = { "Where to place prompt window.", "Available Values: 'bottom', 'top'" },
  anchor = { "Which edge/corner to pin the picker to", "See |resolver.resolve_anchor_pos()|" },
}

-- Used for generating vim help documentation.
layout_strategies._format = function(name)
  local strategy_config = layout_strategies._configurations[name]
  if vim.tbl_isempty(strategy_config) then
    return {}
  end

  local results = { "<pre>", "`picker.layout_config` shared options:" }

  local strategy_keys = vim.tbl_keys(strategy_config)
  table.sort(strategy_keys, function(a, b)
    return a < b
  end)

  local add_value = function(k, val)
    if type(val) == "string" then
      table.insert(results, string.format("  - %s: %s", k, val))
    elseif type(val) == "table" then
      table.insert(results, string.format("  - %s:", k))
      for _, line in ipairs(val) do
        table.insert(results, string.format("    - %s", line))
      end
    else
      error(string.format("expected string or table but found '%s'", type(val)))
    end
  end

  for _, k in ipairs(strategy_keys) do
    if shared_options[k] then
      add_value(k, strategy_config[k])
    end
  end

  table.insert(results, "")
  table.insert(results, "`picker.layout_config` unique options:")

  for _, k in ipairs(strategy_keys) do
    if not shared_options[k] then
      add_value(k, strategy_config[k])
    end
  end

  table.insert(results, "</pre>")
  return results
end

--@param name string: the name to be assigned to the layout
--@param layout_config table: table where keys are the available options for the layout
--@param layout function: function with signature
--          function(self, max_columns, max_lines, layout_config): table
--        the returned table is the sizing and location information for the parts of the picker
--@retun function: wrapped function that inputs a validated layout_config into the `layout` function
local function make_documented_layout(name, layout_config, layout)
  -- Save configuration data to be used by documentation
  layout_strategies._configurations[name] = layout_config

  -- Return new function that always validates configuration
  return function(self, max_columns, max_lines, override_layout)
    return layout(
      self,
      max_columns,
      max_lines,
      validate_layout_config(
        name,
        layout_config,
        vim.tbl_deep_extend("keep", vim.F.if_nil(override_layout, {}), vim.F.if_nil(self.layout_config, {}))
      )
    )
  end
end

--- Horizontal layout has two columns, one for the preview
--- and one for the prompt and results.
---
--- <pre>
--- ┌──────────────────────────────────────────────────┐
--- │                                                  │
--- │    ┌───────────────────┐┌───────────────────┐    │
--- │    │                   ││                   │    │
--- │    │                   ││                   │    │
--- │    │                   ││                   │    │
--- │    │      Results      ││                   │    │
--- │    │                   ││      Preview      │    │
--- │    │                   ││                   │    │
--- │    │                   ││                   │    │
--- │    └───────────────────┘│                   │    │
--- │    ┌───────────────────┐│                   │    │
--- │    │      Prompt       ││                   │    │
--- │    └───────────────────┘└───────────────────┘    │
--- │                                                  │
--- └──────────────────────────────────────────────────┘
--- </pre>
---@eval { ["description"] = require('telescope.pickers.layout_strategies')._format("horizontal") }
---
layout_strategies.horizontal = make_documented_layout(
  "horizontal",
  vim.tbl_extend("error", shared_options, {
    preview_width = { "Change the width of Telescope's preview window", "See |resolver.resolve_width()|" },
    preview_cutoff = "When columns are less than this value, the preview will be disabled",
  }),
  function(self, max_columns, max_lines, layout_config)
    local initial_options = p_window.get_initial_window_options(self)
    local preview = initial_options.preview
    local results = initial_options.results
    local prompt = initial_options.prompt

    local tbln
    max_lines, tbln = calc_tabline(max_lines)

    local width_opt = layout_config.width
    local width = resolve.resolve_width(width_opt)(self, max_columns, max_lines)

    local height_opt = layout_config.height
    local height = resolve.resolve_height(height_opt)(self, max_columns, max_lines)

    local bs = get_border_size(self)

    local w_space
    if self.previewer and max_columns >= layout_config.preview_cutoff then
      -- Cap over/undersized width (with previewer)
      width, w_space = calc_size_and_spacing(width, max_columns, bs, 2, 4, 1)

      preview.width = resolve.resolve_width(vim.F.if_nil(layout_config.preview_width, function(_, cols)
        if cols < 150 then
          return math.floor(cols * 0.4)
        elseif cols < 200 then
          return 80
        else
          return 120
        end
      end))(self, width, max_lines)

      results.width = width - preview.width - w_space
      prompt.width = results.width
    else
      -- Cap over/undersized width (without previewer)
      width, w_space = calc_size_and_spacing(width, max_columns, bs, 1, 2, 0)

      preview.width = 0
      results.width = width - preview.width - w_space
      prompt.width = results.width
    end

    local h_space
    -- Cap over/undersized height
    height, h_space = calc_size_and_spacing(height, max_lines, bs, 2, 4, 1)

    prompt.height = 1
    results.height = height - prompt.height - h_space

    if self.previewer then
      preview.height = height - 2 * bs
    else
      preview.height = 0
    end

    local width_padding = math.floor((max_columns - width) / 2)
    -- Default value is false, to use the normal horizontal layout
    if not layout_config.mirror then
      results.col = width_padding + bs + 1
      prompt.col = results.col
      preview.col = results.col + results.width + 1 + bs
    else
      preview.col = width_padding + bs + 1
      prompt.col = preview.col + preview.width + 1 + bs
      results.col = preview.col + preview.width + 1 + bs
    end

    preview.line = math.floor((max_lines - height) / 2) + bs + 1
    if layout_config.prompt_position == "top" then
      prompt.line = preview.line
      results.line = prompt.line + prompt.height + 1 + bs
    elseif layout_config.prompt_position == "bottom" then
      results.line = preview.line
      prompt.line = results.line + results.height + 1 + bs
    else
      error(string.format("Unknown prompt_position: %s\n%s", self.window.prompt_position, vim.inspect(layout_config)))
    end

    local anchor_pos = resolve.resolve_anchor_pos(layout_config.anchor or "", width, height, max_columns, max_lines)
    adjust_pos(anchor_pos, prompt, results, preview)

    if tbln then
      prompt.line = prompt.line + 1
      results.line = results.line + 1
      preview.line = preview.line + 1
    end

    return {
      preview = self.previewer and preview.width > 0 and preview,
      results = results,
      prompt = prompt,
    }
  end
)

--- Centered layout with a combined block of the prompt
--- and results aligned to the middle of the screen.
--- The preview window is then placed in the remaining
--- space above or below, according to `anchor` or `mirror`.
--- Particularly useful for creating dropdown menus
--- (see |telescope.themes| and |themes.get_dropdown()|).
---
--- Note that vertical anchoring, i.e. `anchor` containing
--- `"N"` or `"S"`, will override `mirror` config. For `"N"`
--- anchoring preview will be placed below prompt/result
--- block. For `"S"` anchoring preview will be placed above
--- prompt/result block. For horizontal only anchoring preview
--- will be placed according to `mirror` config, default is
--- above the prompt/result block.
---
--- <pre>
--- ┌──────────────────────────────────────────────────┐
--- │    ┌────────────────────────────────────────┐    │
--- │    |                 Preview                |    │
--- │    |                 Preview                |    │
--- │    └────────────────────────────────────────┘    │
--- │    ┌────────────────────────────────────────┐    │
--- │    |                 Prompt                 |    │
--- │    ├────────────────────────────────────────┤    │
--- │    |                 Result                 |    │
--- │    |                 Result                 |    │
--- │    └────────────────────────────────────────┘    │
--- │                                                  │
--- │                                                  │
--- │                                                  │
--- │                                                  │
--- └──────────────────────────────────────────────────┘
--- </pre>
---@eval { ["description"] = require("telescope.pickers.layout_strategies")._format("center") }
---
layout_strategies.center = make_documented_layout(
  "center",
  vim.tbl_extend("error", shared_options, {
    preview_cutoff = "When lines are less than this value, the preview will be disabled",
  }),
  function(self, max_columns, max_lines, layout_config)
    local initial_options = p_window.get_initial_window_options(self)
    local preview = initial_options.preview
    local results = initial_options.results
    local prompt = initial_options.prompt

    local tbln
    max_lines, tbln = calc_tabline(max_lines)

    -- This sets the width for the whole layout
    local width_opt = layout_config.width
    local width = resolve.resolve_width(width_opt)(self, max_columns, max_lines)

    -- This sets the height for the whole layout
    local height_opt = layout_config.height
    local height = resolve.resolve_height(height_opt)(self, max_columns, max_lines)

    local bs = get_border_size(self)

    local w_space
    -- Cap over/undersized width
    width, w_space = calc_size_and_spacing(width, max_columns, bs, 1, 2, 0)

    prompt.width = width - w_space
    results.width = width - w_space
    preview.width = width - w_space

    local h_space
    -- Cap over/undersized height
    height, h_space = calc_size_and_spacing(height, max_lines, bs, 2, 3, 0)

    prompt.height = 1
    results.height = height - prompt.height - h_space

    local topline = math.floor((max_lines / 2) - ((results.height + (2 * bs)) / 2) + 1)
    -- Align the prompt and results so halfway up the screen is
    -- in the middle of this combined block
    if layout_config.prompt_position == "top" then
      prompt.line = topline
      results.line = prompt.line + 1 + bs
    elseif layout_config.prompt_position == "bottom" then
      results.line = topline
      prompt.line = results.line + results.height + bs
      if type(prompt.title) == "string" then
        prompt.title = { { pos = "S", text = prompt.title } }
      end
    else
      error(string.format("Unknown prompt_position: %s\n%s", self.window.prompt_position, vim.inspect(layout_config)))
    end

    local width_padding = math.floor((max_columns - width) / 2) + bs + 1
    results.col, preview.col, prompt.col = width_padding, width_padding, width_padding

    local anchor = layout_config.anchor or ""
    local anchor_pos = resolve.resolve_anchor_pos(anchor, width, height, max_columns, max_lines)
    adjust_pos(anchor_pos, prompt, results, preview)

    -- Vertical anchoring (S or N variations) ignores layout_config.mirror
    anchor = anchor:upper()
    local mirror
    if anchor:find "S" then
      mirror = false
    elseif anchor:find "N" then
      mirror = true
    else
      mirror = layout_config.mirror
    end

    -- Set preview position
    local block_line = math.min(results.line, prompt.line)
    if not mirror then -- Preview at top
      preview.line = 1 + bs
      preview.height = block_line - (2 + 2 * bs)
    else -- Preview at bottom
      preview.line = block_line + results.height + 2 + 2 * bs
      preview.height = max_lines - preview.line - bs + 1
    end

    if not (self.previewer and max_lines >= layout_config.preview_cutoff) then
      preview.height = 0
    end

    if tbln then
      prompt.line = prompt.line + 1
      results.line = results.line + 1
      preview.line = preview.line + 1
    end

    return {
      preview = self.previewer and preview.height > 0 and preview,
      results = results,
      prompt = prompt,
    }
  end
)

--- Cursor layout dynamically positioned below the cursor if possible.
--- If there is no place below the cursor it will be placed above.
---
--- <pre>
--- ┌──────────────────────────────────────────────────┐
--- │                                                  │
--- │   █                                              │
--- │   ┌──────────────┐┌─────────────────────┐        │
--- │   │    Prompt    ││      Preview        │        │
--- │   ├──────────────┤│      Preview        │        │
--- │   │    Result    ││      Preview        │        │
--- │   │    Result    ││      Preview        │        │
--- │   └──────────────┘└─────────────────────┘        │
--- │                                         █        │
--- │                                                  │
--- │                                                  │
--- │                                                  │
--- │                                                  │
--- │                                                  │
--- └──────────────────────────────────────────────────┘
--- </pre>
layout_strategies.cursor = make_documented_layout(
  "cursor",
  vim.tbl_extend("error", {
    width = shared_options.width,
    height = shared_options.height,
    scroll_speed = shared_options.scroll_speed,
  }, {
    preview_width = { "Change the width of Telescope's preview window", "See |resolver.resolve_width()|" },
    preview_cutoff = "When columns are less than this value, the preview will be disabled",
  }),
  function(self, max_columns, max_lines, layout_config)
    local initial_options = p_window.get_initial_window_options(self)
    local preview = initial_options.preview
    local results = initial_options.results
    local prompt = initial_options.prompt

    local height_opt = layout_config.height
    local height = resolve.resolve_height(height_opt)(self, max_columns, max_lines)

    local width_opt = layout_config.width
    local width = resolve.resolve_width(width_opt)(self, max_columns, max_lines)

    local bs = get_border_size(self)

    local h_space
    -- Cap over/undersized height
    height, h_space = calc_size_and_spacing(height, max_lines, bs, 2, 3, 0)

    prompt.height = 1
    results.height = height - prompt.height - h_space
    preview.height = height - 2 * bs

    local w_space
    if self.previewer and max_columns >= layout_config.preview_cutoff then
      -- Cap over/undersized width (with preview)
      width, w_space = calc_size_and_spacing(width, max_columns, bs, 2, 4, 0)

      preview.width = resolve.resolve_width(vim.F.if_nil(layout_config.preview_width, 2 / 3))(self, width, max_lines)
      prompt.width = width - preview.width - w_space
      results.width = prompt.width
    else
      -- Cap over/undersized width (without preview)
      width, w_space = calc_size_and_spacing(width, max_columns, bs, 1, 2, 0)

      preview.width = 0
      prompt.width = width - w_space
      results.width = prompt.width
    end

    local position = vim.api.nvim_win_get_position(0)
    local winbar = (function()
      if vim.fn.exists "&winbar" == 1 then
        return vim.o.winbar == "" and 0 or 1
      end
      return 0
    end)()
    local top_left = {
      line = vim.fn.winline() + position[1] + bs + winbar,
      col = vim.fn.wincol() + position[2],
    }
    local bot_right = {
      line = top_left.line + height - 1,
      col = top_left.col + width - 1,
    }

    if bot_right.line > max_lines then
      -- position above current line
      top_left.line = top_left.line - height - 1
    end
    if bot_right.col >= max_columns then
      -- cap to the right of the screen
      top_left.col = max_columns - width
    end

    prompt.line = top_left.line + 1
    results.line = prompt.line + bs + 1
    preview.line = prompt.line

    prompt.col = top_left.col + 1
    results.col = prompt.col
    preview.col = results.col + (bs * 2) + results.width

    return {
      preview = self.previewer and preview.width > 0 and preview,
      results = results,
      prompt = prompt,
    }
  end
)

--- Vertical layout stacks the items on top of each other.
--- Particularly useful with thinner windows.
---
--- <pre>
--- ┌──────────────────────────────────────────────────┐
--- │                                                  │
--- │    ┌────────────────────────────────────────┐    │
--- │    |                 Preview                |    │
--- │    |                 Preview                |    │
--- │    |                 Preview                |    │
--- │    └────────────────────────────────────────┘    │
--- │    ┌────────────────────────────────────────┐    │
--- │    |                 Result                 |    │
--- │    |                 Result                 |    │
--- │    └────────────────────────────────────────┘    │
--- │    ┌────────────────────────────────────────┐    │
--- │    |                 Prompt                 |    │
--- │    └────────────────────────────────────────┘    │
--- │                                                  │
--- └──────────────────────────────────────────────────┘
--- </pre>
---@eval { ["description"] = require("telescope.pickers.layout_strategies")._format("vertical") }
---
layout_strategies.vertical = make_documented_layout(
  "vertical",
  vim.tbl_extend("error", shared_options, {
    preview_cutoff = "When lines are less than this value, the preview will be disabled",
    preview_height = { "Change the height of Telescope's preview window", "See |resolver.resolve_height()|" },
  }),
  function(self, max_columns, max_lines, layout_config)
    local initial_options = p_window.get_initial_window_options(self)
    local preview = initial_options.preview
    local results = initial_options.results
    local prompt = initial_options.prompt

    local tbln
    max_lines, tbln = calc_tabline(max_lines)

    local width_opt = layout_config.width
    local width = resolve.resolve_width(width_opt)(self, max_columns, max_lines)

    local height_opt = layout_config.height
    local height = resolve.resolve_height(height_opt)(self, max_columns, max_lines)

    local bs = get_border_size(self)

    local w_space
    -- Cap over/undersized width
    width, w_space = calc_size_and_spacing(width, max_columns, bs, 1, 2, 0)

    prompt.width = width - w_space
    results.width = prompt.width
    preview.width = prompt.width

    local h_space
    if self.previewer and max_lines >= layout_config.preview_cutoff then
      -- Cap over/undersized height (with previewer)
      height, h_space = calc_size_and_spacing(height, max_lines, bs, 3, 6, 2)

      preview.height =
        resolve.resolve_height(vim.F.if_nil(layout_config.preview_height, 0.5))(self, max_columns, height)
    else
      -- Cap over/undersized height (without previewer)
      height, h_space = calc_size_and_spacing(height, max_lines, bs, 2, 4, 1)

      preview.height = 0
    end
    prompt.height = 1
    results.height = height - preview.height - prompt.height - h_space

    local width_padding = math.floor((max_columns - width) / 2) + bs + 1
    results.col, preview.col, prompt.col = width_padding, width_padding, width_padding

    local height_padding = math.floor((max_lines - height) / 2)
    if not layout_config.mirror then
      preview.line = height_padding + (1 + bs)
      if layout_config.prompt_position == "top" then
        prompt.line = (preview.height == 0) and preview.line or preview.line + preview.height + (1 + bs)
        results.line = prompt.line + prompt.height + (1 + bs)
      elseif layout_config.prompt_position == "bottom" then
        results.line = (preview.height == 0) and preview.line or preview.line + preview.height + (1 + bs)
        prompt.line = results.line + results.height + (1 + bs)
      else
        error(string.format("Unknown prompt_position: %s\n%s", self.window.prompt_position, vim.inspect(layout_config)))
      end
    else
      if layout_config.prompt_position == "top" then
        prompt.line = height_padding + (1 + bs)
        results.line = prompt.line + prompt.height + (1 + bs)
        preview.line = results.line + results.height + (1 + bs)
      elseif layout_config.prompt_position == "bottom" then
        results.line = height_padding + (1 + bs)
        prompt.line = results.line + results.height + (1 + bs)
        preview.line = prompt.line + prompt.height + (1 + bs)
      else
        error(string.format("Unknown prompt_position: %s\n%s", self.window.prompt_position, vim.inspect(layout_config)))
      end
    end

    local anchor_pos = resolve.resolve_anchor_pos(layout_config.anchor or "", width, height, max_columns, max_lines)
    adjust_pos(anchor_pos, prompt, results, preview)

    if tbln then
      prompt.line = prompt.line + 1
      results.line = results.line + 1
      preview.line = preview.line + 1
    end

    return {
      preview = self.previewer and preview.height > 0 and preview,
      results = results,
      prompt = prompt,
    }
  end
)

--- Flex layout swaps between `horizontal` and `vertical` strategies based on the window width
---  -  Supports |layout_strategies.vertical| or |layout_strategies.horizontal| features
---
---@eval { ["description"] = require("telescope.pickers.layout_strategies")._format("flex") }
---
layout_strategies.flex = make_documented_layout(
  "flex",
  vim.tbl_extend("error", shared_options, {
    flip_columns = "The number of columns required to move to horizontal mode",
    flip_lines = "The number of lines required to move to horizontal mode",
    vertical = "Options to pass when switching to vertical layout",
    horizontal = "Options to pass when switching to horizontal layout",
  }),
  function(self, max_columns, max_lines, layout_config)
    local flip_columns = vim.F.if_nil(layout_config.flip_columns, 100)
    local flip_lines = vim.F.if_nil(layout_config.flip_lines, 20)

    if max_columns < flip_columns and max_lines > flip_lines then
      self.__flex_strategy = "vertical"
      return layout_strategies.vertical(self, max_columns, max_lines, layout_config.vertical)
    else
      self.__flex_strategy = "horizontal"
      return layout_strategies.horizontal(self, max_columns, max_lines, layout_config.horizontal)
    end
  end
)

layout_strategies.current_buffer = make_documented_layout("current_buffer", {
  -- No custom options.
  -- height, width ignored
}, function(self, _, _, _)
  local initial_options = p_window.get_initial_window_options(self)

  local window_width = vim.api.nvim_win_get_width(0)
  local window_height = vim.api.nvim_win_get_height(0)

  local preview = initial_options.preview
  local results = initial_options.results
  local prompt = initial_options.prompt

  local bs = get_border_size(self)

  -- Width
  local width_padding = (1 + bs) -- TODO(l-kershaw): make this configurable

  prompt.width = window_width - 2 * width_padding
  results.width = prompt.width
  preview.width = prompt.width

  -- Height
  local height_padding = (1 + bs) -- TODO(l-kershaw): make this configurable

  prompt.height = 1
  if self.previewer then
    results.height = 10 -- TODO(l-kershaw): make this configurable
    preview.height = window_height - results.height - prompt.height - 2 * (1 + bs) - 2 * height_padding
  else
    results.height = window_height - prompt.height - (1 + bs) - 2 * height_padding
    preview.height = 0
  end

  local win_position = vim.api.nvim_win_get_position(0)

  local line = win_position[1]
  if self.previewer then
    preview.line = height_padding + line + 1
    results.line = preview.line + preview.height + (1 + bs)
    prompt.line = results.line + results.height + (1 + bs)
  else
    results.line = height_padding + line + 1
    prompt.line = results.line + results.height + (1 + bs)
  end

  local col = win_position[2] + width_padding + 1
  preview.col, results.col, prompt.col = col, col, col

  return {
    preview = preview.height > 0 and preview,
    results = results,
    prompt = prompt,
  }
end)

--- Bottom pane can be used to create layouts similar to "ivy".
---
--- For an easy ivy configuration, see |themes.get_ivy()|
layout_strategies.bottom_pane = make_documented_layout(
  "bottom_pane",
  vim.tbl_extend("error", shared_options, {
    preview_width = { "Change the width of Telescope's preview window", "See |resolver.resolve_width()|" },
    preview_cutoff = "When columns are less than this value, the preview will be disabled",
  }),
  function(self, max_columns, max_lines, layout_config)
    local initial_options = p_window.get_initial_window_options(self)
    local results = initial_options.results
    local prompt = initial_options.prompt
    local preview = initial_options.preview

    local tbln
    max_lines, tbln = calc_tabline(max_lines)

    local height = vim.F.if_nil(resolve.resolve_height(layout_config.height)(self, max_columns, max_lines), 25)
    if type(layout_config.height) == "table" and type(layout_config.height.padding) == "number" then
      -- Since bottom_pane only has padding at the top, we only need half as much padding in total
      -- This doesn't match the vim help for `resolve.resolve_height`, but it matches expectations
      height = math.floor((max_lines + height) / 2)
    end

    local bs = get_border_size(self)

    -- Cap over/undersized height
    height, _ = calc_size_and_spacing(height, max_lines, bs, 2, 3, 0)

    -- Height
    prompt.height = 1
    results.height = height - prompt.height - (2 * bs)
    preview.height = results.height - bs

    -- Width
    prompt.width = max_columns - 2 * bs
    if self.previewer and max_columns >= layout_config.preview_cutoff then
      -- Cap over/undersized width (with preview)
      local width, w_space = calc_size_and_spacing(max_columns, max_columns, bs, 2, 4, 0)

      preview.width = resolve.resolve_width(vim.F.if_nil(layout_config.preview_width, 0.5))(self, width, max_lines)
      results.width = width - preview.width - w_space
    else
      results.width = prompt.width
      preview.width = 0
    end

    -- Line
    if layout_config.prompt_position == "top" then
      prompt.line = max_lines - results.height - (1 + bs) + 1
      results.line = prompt.line + 1
      preview.line = results.line + bs
      if results.border == true then
        results.border = { 0, 1, 1, 1 }
      end
      if type(results.title) == "string" then
        results.title = { { pos = "S", text = results.title } }
      end
    elseif layout_config.prompt_position == "bottom" then
      results.line = max_lines - results.height - (1 + bs) + 1
      preview.line = results.line
      prompt.line = max_lines - bs
      if type(prompt.title) == "string" then
        prompt.title = { { pos = "S", text = prompt.title } }
      end
      if results.border == true then
        results.border = { 1, 1, 0, 1 }
      end
    else
      error(string.format("Unknown prompt_position: %s\n%s", self.window.prompt_position, vim.inspect(layout_config)))
    end

    -- Col
    prompt.col = 0 -- centered
    if layout_config.mirror and preview.width > 0 then
      results.col = preview.width + (3 * bs) + 1
      preview.col = bs + 1
    else
      results.col = bs + 1
      preview.col = results.width + (3 * bs) + 1
    end

    if tbln then
      prompt.line = prompt.line + 1
      results.line = results.line + 1
      preview.line = preview.line + 1
    end

    return {
      preview = self.previewer and preview.width > 0 and preview,
      prompt = prompt,
      results = results,
    }
  end
)

layout_strategies._validate_layout_config = validate_layout_config

return layout_strategies
