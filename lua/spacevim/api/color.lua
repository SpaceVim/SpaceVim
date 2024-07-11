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

  return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

return color
