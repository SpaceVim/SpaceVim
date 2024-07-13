--=============================================================================
-- color.lua ---
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local color = {}

-- 参考： https://blog.csdn.net/Sunshine_in_Moon/article/details/45131285

color.rgb2hsl = function(r, g, b)
  r = r / 255
  g = g / 255
  b = b / 255
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s, l
  if max == min then
    h = 0
  elseif max == r and g >= b then
    h = 60 * (g - b) / (max - min) + 0
  elseif max == r and g < b then
    h = 60 * (g - b) / (max - min) + 360
  elseif max == g then
    h = 60 * (b - r) / (max - min) + 120
  elseif max == b then
    h = 60 * (r - g) / (max - min) + 240
  end

  l = 1 / 2 * (max + min)

  if l == 0 or max == min then
    s = 0
  elseif l > 0 and l <= 0.5 then
    s = (max - min) / (2 * l)
  elseif l > 0.5 then
    s = (max - min) / (2 - 2 * l)
  end

  return math.floor(h), s, l
end

-- https://stackoverflow.com/questions/68317097/how-to-properly-convert-hsl-colors-to-rgb-colors-in-lua

color.hsl2rgb = function(h, s, l)
  h = h / 360

  local r, g, b

  if s == 0 then
    r, g, b = l, l, l
  else
    local function hue2rgb(p, q, t)
      if t < 0 then
        t = t + 1
      end
      if t > 1 then
        t = t - 1
      end
      if t < 1 / 6 then
        return p + (q - p) * 6 * t
      end
      if t < 1 / 2 then
        return q
      end
      if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
      end
      return p
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  end

  return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

-- https://www.rapidtables.com/convert/color/rgb-to-hsv.html

color.rgb2hsv = function(r, g, b)
  r = r / 255
  g = g / 255
  b = b / 255

  local cmax = math.max(r, g, b)
  local cmin = math.min(r, g, b)
  local d = cmax - cmin

  local h, s, v

  if d == 0 then
    h = 0
  elseif cmax == r then
    h = 60 * (((g - b) / d) % 6)
  elseif cmax == g then
    h = 60 * (((b - r) / d) + 2)
  elseif cmax == b then
    h = 60 * (((r - g) / d) + 4)
  end

  if cmax == 0 then
    s = 0
  else
    s = d / cmax
  end

  v = cmax

  return math.floor(h), s, v
end

-- https://www.rapidtables.com/convert/color/hsv-to-rgb.html
color.hsv2rgb = function(h, s, v)
  local c = v * s
  local x = c * (1 - math.abs((h / 60) % 2 - 1))
  local m = v - c
  local r, g, b

  if h >= 0 and h < 60 then
    r, g, b = c, x, 0
  elseif h >= 60 and h < 120 then
    r, g, b = x, c, 0
  elseif h >= 120 and h < 180 then
    r, g, b = 0, c, x
  elseif h >= 180 and h < 240 then
    r, g, b = 0, x, c
  elseif h >= 240 and h < 300 then
    r, g, b = x, 0, c
  elseif h >= 300 and h < 360 then
    r, g, b = c, 0, x
  end
  r, g, b = (r + m), (g + m), (b + m)
  return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end
color.hsv2hsl = function(h, s, v)
  return color.rgb2hsl(color.hsv2rgb(h, s, v))
end
color.hsl2hsv = function(h, s, l)
  return color.rgb2hsv(color.hsl2rgb(h, s, l))
end

local function decimalToHex(decimal)
  local hex = ''
  local hexChars = '0123456789ABCDEF'
  while decimal > 0 do
    local mod = decimal % 16
    hex = string.sub(hexChars, mod + 1, mod + 1) .. hex
    decimal = math.floor(decimal / 16)
  end
  if hex == '' then
    return '00'
  elseif #hex == 1 then
    return '0' .. hex
  else
    return hex
  end
end
color.rgb2hex = function(r, g, b)
  r = decimalToHex(r)
  g = decimalToHex(g)
  b = decimalToHex(b)
  return '#' .. r .. g .. b
end
color.hsv2hex = function(h, s, v)
  return color.rgb2hex(color.hsv2rgb(h, s, v))
end
color.hsl2hex = function(h, s, l)
  return color.rgb2hex(color.hsl2rgb(h, s, l))
end

return color
