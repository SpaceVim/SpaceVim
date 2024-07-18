local M = {}
local color_mix_buf
local color_mix_win
local color_mix_color1
local color_mix_color2
local color_mix_color3
local color_mix_p1 = 0.5
local color_mix_p2 = 0.5
-- https://developer.mozilla.org/en-US/docs/Web/CSS/color-interpolation-method
local available_methods = { 'srgb', 'hsl', 'hwb' }
local available_hue_methods = { 'shorter', 'longer', 'increasing', 'decreasing' }
local method = 'srgb'
local hue_interpolation_method = 'shorter'
local hi = require('spacevim.api.vim.highlight')
local notify = require('spacevim.api.notify')
local util = require('cpicker.util')
local color = require('spacevim.api.color')

local function get_mix_method()
  if method == 'hsl' then
    return 'hsl ' .. hue_interpolation_method
  else
    return method
  end
end

local function get_method()
  local rst = ''
  for _, m in ipairs(available_methods) do
    if m == method then
      rst = rst .. '<' .. m .. '>'
    else
      rst = rst .. ' ' .. m .. ' '
    end
  end
  return rst
end

local function get_hue_method()
  local rst = ''
  for _, m in ipairs(available_hue_methods) do
    if m == hue_interpolation_method then
      rst = rst .. '<' .. m .. '>'
    else
      rst = rst .. ' ' .. m .. ' '
    end
  end
  return rst
end

local function update_color_mix_buftext()
  local r3, g3, b3
  if method == 'srgb' then
    local r1, g1, b1 = color.hex2rgb(color_mix_color1)
    local r2, g2, b2 = color.hex2rgb(color_mix_color2)
    local p1, p2
    if color_mix_p1 == 0 and color_mix_p2 == 0 then
      p1 = 0.5
      p2 = 0.5
    else
      p1 = color_mix_p1 / (color_mix_p1 + color_mix_p2)
      p2 = color_mix_p2 / (color_mix_p1 + color_mix_p2)
    end
    r3, g3, b3 = r1 * p1 + r2 * p2, g1 * p1 + g2 * p2, b1 * p1 + b2 * p2
  elseif method == 'hsl' or method == 'hwb' then
    local h1, s1, l1, w1, b1
    local h2, s2, l2, w2, b2
    if method == 'hsl' then
      h1, s1, l1 = color.rgb2hsl(color.hex2rgb(color_mix_color1))
      h2, s2, l2 = color.rgb2hsl(color.hex2rgb(color_mix_color2))
    elseif method == 'hwb' then
      h1, w1, b1 = color.rgb2hwb(color.hex2rgb(color_mix_color1))
      h2, w2, b2 = color.rgb2hwb(color.hex2rgb(color_mix_color2))
    end
    local h3
    local p1, p2
    if color_mix_p1 == 0 and color_mix_p2 == 0 then
      p1 = 0.5
      p2 = 0.5
    else
      p1 = color_mix_p1 / (color_mix_p1 + color_mix_p2)
      p2 = color_mix_p2 / (color_mix_p1 + color_mix_p2)
    end
    if hue_interpolation_method == 'shorter' then
      if h2 >= h1 then
        if h2 - h1 <= 180 then
          h3 = h1 * p1 + h2 * p2
        else
          h3 = (h1 + 360) * p1 + h2 * p2
        end
      else
        if h1 - h2 <= 180 then
          h3 = h1 * p1 + h2 * p2
        else
          h3 = h1 * p1 + (h2 + 360) * p2
        end
      end
    elseif hue_interpolation_method == 'longer' then
      if h2 >= h1 then
        if h2 - h1 >= 180 then
          h3 = h1 * p1 + h2 * p2
        else
          h3 = (h1 + 360) * p1 + h2 * p2
        end
      else
        if h1 - h2 >= 180 then
          h3 = h1 * p1 + h2 * p2
        else
          h3 = h1 * p1 + (h2 + 360) * p2
        end
      end
    elseif hue_interpolation_method == 'increasing' then
      if h1 <= h2 then
        h3 = h1 * p1 + h2 * p2
      else
        h3 = h1 * p1 + (h2 + 360) * p2
      end
    elseif hue_interpolation_method == 'decreasing' then
      if h1 >= h2 then
        h3 = h1 * p1 + h2 * p2
      else
        h3 = (h1 + 360) * p1 + h2 * p2
      end
    end
    if h3 >= 360 then
      h3 = h3 - 360
    end
    if method == 'hsl' then
      r3, g3, b3 = color.hsl2rgb(h3, s1 * p1 + s2 * p2, l1 * p1 + l2 * p2)
    elseif method == 'hwb' then
      r3, g3, b3 = color.hwb2rgb(h3, w1 * p1 + w2 * p2, b1 * p1 + b2 * p2)
    end
  end
  -- 验证结果 https://products.aspose.app/svg/zh/color-mixer
  color_mix_color3 = color.rgb2hex(r3, g3, b3)
  local normal_bg = hi.group2dict('Normal').guibg
  local normal_fg = hi.group2dict('Normal').guifg
  if
    math.abs(util.get_hsl_l(normal_bg) - util.get_hsl_l(color_mix_color3))
    > math.abs(util.get_hsl_l(color_mix_color3) - util.get_hsl_l(normal_fg))
  then
    hi.hi({
      name = 'SpaceVimPickerMixColor3Code',
      guifg = color_mix_color3,
      guibg = normal_bg,
      bold = 1,
    })
  else
    hi.hi({
      name = 'SpaceVimPickerMixColor3Code',
      guifg = color_mix_color3,
      guibg = normal_fg,
      bold = 1,
    })
  end
  hi.hi({
    name = 'SpaceVimPickerMixColor3Background',
    guibg = color_mix_color3,
    guifg = color_mix_color3,
  })
  local rst = {}
  table.insert(
    rst,
    '   '
      .. color_mix_color1
      .. '     '
      .. 'P1:'
      .. string.format(' %3s%%', math.floor(color_mix_p1 * 100 + 0.5))
      .. ' '
      .. util.generate_bar(color_mix_p1, '+')
  )
  table.insert(
    rst,
    '   '
      .. color_mix_color2
      .. '     '
      .. 'P2:'
      .. string.format(' %3s%%', math.floor(color_mix_p2 * 100 + 0.5))
      .. ' '
      .. util.generate_bar(color_mix_p2, '+')
  )
  table.insert(rst, '           method:' .. get_method())
  table.insert(rst, '              hue:' .. get_hue_method())
  table.insert(rst, ' ')
  table.insert(
    rst,
    '    =======  '
      .. color_mix_color3
      .. '                                                                          '
  )
  table.insert(
    rst,
    '    =======  '
      .. string.format(
        'color-mix(in %s, %s %3s%%, %3s %3s%%)                                                                         ',
        get_mix_method(),
        color_mix_color1,
        math.floor(color_mix_p1 * 100 + 0.5),
        color_mix_color2,
        math.floor(color_mix_p2 * 100 + 0.5)
      )
  )
  vim.api.nvim_set_option_value('modifiable', true, {
    buf = color_mix_buf,
  })
  vim.api.nvim_buf_set_lines(color_mix_buf, 0, -1, false, rst)
  vim.api.nvim_set_option_value('modifiable', false, {
    buf = color_mix_buf,
  })
end

local function increase_p_f(p)
  if p <= 0.99 then
    p = p + 0.01
  elseif p < 1 then
    p = 1
  end
  return p
end

local function reduce_p_f(p)
  if p >= 0.01 then
    p = p - 0.01
  elseif p > 0 then
    p = 0
  end
  return p
end

local function next_hue_method()
  for i, v in ipairs(available_hue_methods) do
    if v == hue_interpolation_method then
      if i == #available_hue_methods then
        return available_hue_methods[1]
      else
        return available_hue_methods[i + 1]
      end
    end
  end
end

local function previous_hue_method()
  for i, v in ipairs(available_hue_methods) do
    if v == hue_interpolation_method then
      if i == 1 then
        return available_hue_methods[#available_hue_methods]
      else
        return available_hue_methods[i - 1]
      end
    end
  end
end

local function next_mix_method()
  for i, v in ipairs(available_methods) do
    if v == method then
      if i == #available_methods then
        return available_methods[1]
      else
        return available_methods[i + 1]
      end
    end
  end
end

local function previous_mix_method()
  for i, v in ipairs(available_methods) do
    if v == method then
      if i == 1 then
        return available_methods[#available_methods]
      else
        return available_methods[i - 1]
      end
    end
  end
end

local function increase_p()
  if vim.fn.line('.') == 1 then
    color_mix_p1 = increase_p_f(color_mix_p1)
  elseif vim.fn.line('.') == 2 then
    color_mix_p2 = increase_p_f(color_mix_p2)
  elseif vim.fn.line('.') == 3 then
    method = next_mix_method()
  elseif vim.fn.line('.') == 4 then
    hue_interpolation_method = next_hue_method()
  end
  update_color_mix_buftext()
end

local function reduce_p()
  if vim.fn.line('.') == 1 then
    color_mix_p1 = reduce_p_f(color_mix_p1)
  elseif vim.fn.line('.') == 2 then
    color_mix_p2 = reduce_p_f(color_mix_p2)
  elseif vim.fn.line('.') == 3 then
    method = previous_mix_method()
  elseif vim.fn.line('.') == 4 then
    hue_interpolation_method = previous_hue_method()
  end
  update_color_mix_buftext()
end

local function copy_color_mix()
  local from, to =
    vim.regex([[#[0123456789ABCDEF]\+\|color-mix([^)]*)]]):match_str(vim.fn.getline('.'))
  if from then
    vim.fn.setreg('+', string.sub(vim.fn.getline('.'), from, to + 1))
    notify.notify('copied:' .. string.sub(vim.fn.getline('.'), from, to + 1))
  end
end

M.color_mix = function(hex1, hex2)
  color_mix_color1 = hex1 or '#000000'
  color_mix_color2 = hex2 or '#FFFFFF'
  hi.hi({
    name = 'SpaceVimPickerMixColor1',
    guifg = color_mix_color1,
    bold = 1,
  })
  hi.hi({
    name = 'SpaceVimPickerMixColor2',
    guifg = color_mix_color2,
    bold = 1,
  })
  if not color_mix_buf or not vim.api.nvim_win_is_valid(color_mix_buf) then
    color_mix_buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_set_option_value('buftype', 'nofile', {
      buf = color_mix_buf,
    })
    vim.api.nvim_set_option_value('filetype', 'spacevim_cpicker_mix', {
      buf = color_mix_buf,
    })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', {
      buf = color_mix_buf,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', 'l', '', {
      callback = increase_p,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', 'h', '', {
      callback = reduce_p,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', '<Right>', '', {
      callback = increase_p,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', '<Left>', '', {
      callback = reduce_p,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', 'q', '', {
      callback = function()
        vim.api.nvim_win_close(color_mix_win, true)
      end,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', '<Cr>', '', {
      callback = copy_color_mix,
    })
  end
  if not color_mix_win or not vim.api.nvim_win_is_valid(color_mix_win) then
    color_mix_win = vim.api.nvim_open_win(color_mix_buf, true, {
      relative = 'cursor',
      border = 'single',
      width = 75,
      height = 7,
      row = 1,
      col = 1,
    })
  end
  vim.api.nvim_set_option_value('number', false, {
    win = color_mix_win,
  })
  vim.api.nvim_set_option_value('winhighlight', 'NormalFloat:Normal,FloatBorder:WinSeparator', {
    win = color_mix_win,
  })
  vim.api.nvim_set_option_value('modifiable', false, {
    buf = color_mix_buf,
  })
  update_color_mix_buftext()
end
return M
