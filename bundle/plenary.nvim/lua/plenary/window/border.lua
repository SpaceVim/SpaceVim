local strings = require "plenary.strings"

local Border = {}

Border.__index = Border

Border._default_thickness = {
  top = 1,
  right = 1,
  bot = 1,
  left = 1,
}

local calc_left_start = function(title_pos, title_len, total_width)
  if string.find(title_pos, "W") then
    return 0
  elseif string.find(title_pos, "E") then
    return total_width - title_len
  else
    return math.floor((total_width - title_len) / 2)
  end
end

local create_horizontal_line = function(title, pos, width, left_char, mid_char, right_char)
  local title_len
  if title == "" then
    title_len = 0
  else
    local len = strings.strdisplaywidth(title)
    local max_title_width = width - 2
    if len > max_title_width then
      title = strings.truncate(title, max_title_width)
      len = strings.strdisplaywidth(title)
    end
    title = string.format(" %s ", title)
    title_len = len + 2
  end

  local left_start = calc_left_start(pos, title_len, width)

  local horizontal_line = string.format(
    "%s%s%s%s%s",
    left_char,
    string.rep(mid_char, left_start),
    title,
    string.rep(mid_char, width - title_len - left_start),
    right_char
  )
  local ranges = {}
  if title_len ~= 0 then
    -- Need to calculate again due to multi-byte characters
    local r_start = string.len(left_char) + math.max(left_start, 0) * string.len(mid_char)
    ranges = { { r_start, r_start + string.len(title) } }
  end
  return horizontal_line, ranges
end

function Border._create_lines(content_win_id, content_win_options, border_win_options)
  local content_pos = vim.api.nvim_win_get_position(content_win_id)
  local content_height = vim.api.nvim_win_get_height(content_win_id)
  local content_width = vim.api.nvim_win_get_width(content_win_id)

  -- TODO: Handle border width, which I haven't right here.
  local thickness = border_win_options.border_thickness

  local top_enabled = thickness.top == 1
  local right_enabled = thickness.right == 1 and content_pos[2] + content_width < vim.o.columns
  local bot_enabled = thickness.bot == 1
  local left_enabled = thickness.left == 1 and content_pos[2] > 0

  border_win_options.border_thickness.left = left_enabled and 1 or 0
  border_win_options.border_thickness.right = right_enabled and 1 or 0

  local border_lines = {}
  local ranges = {}

  -- border_win_options.title should have be a list with entries of the
  -- form: { pos = foo, text = bar }.
  -- pos can take values in { "NW", "N", "NE", "SW", "S", "SE" }
  local titles = type(border_win_options.title) == "string" and { { pos = "N", text = border_win_options.title } }
    or border_win_options.title
    or {}

  local topline = nil
  local topleft = (left_enabled and border_win_options.topleft) or ""
  local topright = (right_enabled and border_win_options.topright) or ""
  -- Only calculate the topline if there is space above the first content row (relative to the editor)
  if content_pos[1] > 0 then
    for _, title in ipairs(titles) do
      if string.find(title.pos, "N") then
        local top_ranges
        topline, top_ranges = create_horizontal_line(
          title.text,
          title.pos,
          content_win_options.width,
          topleft,
          border_win_options.top or "",
          topright
        )
        for _, r in pairs(top_ranges) do
          table.insert(ranges, { 0, r[1], r[2] })
        end
        break
      end
    end
    if topline == nil then
      if top_enabled then
        topline = topleft .. string.rep(border_win_options.top, content_win_options.width) .. topright
      end
    end
  else
    border_win_options.border_thickness.top = 0
  end

  if topline then
    table.insert(border_lines, topline)
  end

  local middle_line = string.format(
    "%s%s%s",
    (left_enabled and border_win_options.left) or "",
    string.rep(" ", content_win_options.width),
    (right_enabled and border_win_options.right) or ""
  )

  for _ = 1, content_win_options.height do
    table.insert(border_lines, middle_line)
  end

  local botline = nil
  local botleft = (left_enabled and border_win_options.botleft) or ""
  local botright = (right_enabled and border_win_options.botright) or ""
  if content_pos[1] + content_height < vim.o.lines then
    for _, title in ipairs(titles) do
      if string.find(title.pos, "S") then
        local bot_ranges
        botline, bot_ranges = create_horizontal_line(
          title.text,
          title.pos,
          content_win_options.width,
          botleft,
          border_win_options.bot or "",
          botright
        )
        for _, r in pairs(bot_ranges) do
          table.insert(ranges, { content_win_options.height + thickness.top, r[1], r[2] })
        end
        break
      end
    end
    if botline == nil then
      if bot_enabled then
        botline = botleft .. string.rep(border_win_options.bot, content_win_options.width) .. botright
      end
    end
  else
    border_win_options.border_thickness.bot = 0
  end

  if botline then
    table.insert(border_lines, botline)
  end

  return border_lines, ranges
end

local set_title_highlights = function(bufnr, ranges, hl)
  -- Check if both `hl` and `ranges` are provided, and `ranges` is not the empty table.
  if hl and ranges and next(ranges) then
    for _, r in pairs(ranges) do
      vim.api.nvim_buf_add_highlight(bufnr, -1, hl, r[1], r[2], r[3])
    end
  end
end

function Border:change_title(new_title, pos)
  if self._border_win_options.title == new_title then
    return
  end

  pos = pos
    or (self._border_win_options.title and self._border_win_options.title[1] and self._border_win_options.title[1].pos)
  if pos == nil then
    self._border_win_options.title = new_title
  else
    self._border_win_options.title = { { text = new_title, pos = pos } }
  end

  self.contents, self.title_ranges = Border._create_lines(
    self.content_win_id,
    self.content_win_options,
    self._border_win_options
  )
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, self.contents)

  set_title_highlights(self.bufnr, self.title_ranges, self._border_win_options.titlehighlight)
end

-- Updates characters for border lines, and returns nvim_win_config
-- (generally used in conjunction with `move` or `new`)
function Border:__align_calc_config(content_win_options, border_win_options)
  border_win_options = vim.tbl_deep_extend("keep", border_win_options, {
    border_thickness = Border._default_thickness,

    -- Border options, could be passed as a list?
    topleft = "╔",
    topright = "╗",
    top = "═",
    left = "║",
    right = "║",
    botleft = "╚",
    botright = "╝",
    bot = "═",
  })

  -- Ensure the relevant contents and border win_options are set
  self._border_win_options = border_win_options
  self.content_win_options = content_win_options
  -- Update border characters and title_ranges
  self.contents, self.title_ranges = Border._create_lines(self.content_win_id, content_win_options, border_win_options)

  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, self.contents)

  local thickness = border_win_options.border_thickness
  local nvim_win_config = {
    anchor = content_win_options.anchor,
    relative = content_win_options.relative,
    style = "minimal",
    row = content_win_options.row - thickness.top,
    col = content_win_options.col - thickness.left,
    width = content_win_options.width + thickness.left + thickness.right,
    height = content_win_options.height + thickness.top + thickness.bot,
    zindex = content_win_options.zindex or 50,
    noautocmd = content_win_options.noautocmd,
    focusable = vim.F.if_nil(border_win_options.focusable, false),
  }

  return nvim_win_config
end

-- Sets the size and position of the given Border.
-- Can be used to create a new window (with `create_window = true`)
-- or change an existing one
function Border:move(content_win_options, border_win_options)
  -- Update lines in border buffer, and get config for border window
  local nvim_win_config = self:__align_calc_config(content_win_options, border_win_options)

  -- Set config for border window
  vim.api.nvim_win_set_config(self.win_id, nvim_win_config)

  set_title_highlights(self.bufnr, self.title_ranges, self._border_win_options.titlehighlight)
end

function Border:new(content_bufnr, content_win_id, content_win_options, border_win_options)
  assert(type(content_win_id) == "number", "Must supply a valid win_id. It's possible you forgot to call with ':'")

  local obj = {}

  obj.content_win_id = content_win_id

  obj.bufnr = vim.api.nvim_create_buf(false, true)
  assert(obj.bufnr, "Failed to create border buffer")
  vim.api.nvim_buf_set_option(obj.bufnr, "bufhidden", "wipe")

  -- Create a border window and buffer, with border characters around the edge
  local nvim_win_config = Border.__align_calc_config(obj, content_win_options, border_win_options)
  obj.win_id = vim.api.nvim_open_win(obj.bufnr, false, nvim_win_config)

  if border_win_options.highlight then
    vim.api.nvim_win_set_option(obj.win_id, "winhl", border_win_options.highlight)
  end

  set_title_highlights(obj.bufnr, obj.title_ranges, obj._border_win_options.titlehighlight)

  vim.cmd(
    string.format(
      "autocmd BufDelete <buffer=%s> ++nested ++once :lua require('plenary.window').close_related_win(%s, %s)",
      content_bufnr,
      content_win_id,
      obj.win_id
    )
  )

  vim.cmd(
    string.format(
      "autocmd WinClosed <buffer=%s> ++nested ++once :lua require('plenary.window').try_close(%s, true)",
      content_bufnr,
      obj.win_id
    )
  )

  setmetatable(obj, Border)

  return obj
end

return Border
