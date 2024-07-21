--=============================================================================
-- color.lua ---
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local color = {}

--  rgb <-> hsl - hwb
--  rgb <-> cmyk
--  rgb <-> hsv
--  rgb <-> hex
--  rgb <-> linear <-> xyz <-> lab <-> lch

-- 参考： https://blog.csdn.net/Sunshine_in_Moon/article/details/45131285

color.rgb2hsl = function(r, g, b)
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

  return h, s, l
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

  return r, g, b
end

-- https://www.rapidtables.com/convert/color/rgb-to-cmyk.html

color.rgb2cmyk = function(r, g, b)
  local c, m, y, k
  k = 1 - math.max(r, g, b)
  if k ~= 1 then
    c = (1 - r - k) / (1 - k)
    m = (1 - g - k) / (1 - k)
    y = (1 - b - k) / (1 - k)
  else
    c, m, y = 0, 0, 0
  end
  return c, m, y, k
end

color.cmyk2rgb = function(c, m, y, k)
  local r, g, b
  r = (1 - c) * (1 - k)
  g = (1 - m) * (1 - k)
  b = (1 - y) * (1 - k)
  return r, g, b
end

-- https://www.rapidtables.com/convert/color/rgb-to-hsv.html

color.rgb2hsv = function(r, g, b)
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

  return h, s, v
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
  return r, g, b
end
color.hsv2hsl = function(h, s, v)
  return color.rgb2hsl(color.hsv2rgb(h, s, v))
end
color.hsl2hsv = function(h, s, l)
  return color.rgb2hsv(color.hsl2rgb(h, s, l))
end
color.hsl2cmyk = function(h, s, l)
  return color.rgb2cmyk(color.hsl2rgb(h, s, l))
end
color.hsv2cmyk = function(h, s, v)
  return color.rgb2cmyk(color.hsv2rgb(h, s, v))
end
color.cmyk2hsv = function(c, m, y, k)
  return color.rgb2hsv(color.cmyk2rgb(c, m, y, k))
end

color.cmyk2hsl = function(c, m, y, k)
  return color.rgb2hsl(color.cmyk2rgb(c, m, y, k))
end

color.hwb2rgb = function(h, w, b)
  if w + b >= 1 then
    local grey = w / (w + b)
    return grey, grey, grey
  end
  local R, G, B = color.hsl2rgb(h, 1, 0.5)
  local function f(c)
    c = c * (1 - w - b) + w
    if c > 1 then
      return 1
    elseif c <= 0 then
      return 0
    else
      return c
    end
  end
  return f(R), f(G), f(B)
end

color.rgb2hwb = function(r, g, b)
  local h = color.rgb2hsl(r, g, b)
  local w = math.min(r, g, b)
  b = 1 - math.max(r, g, b)
  return h, w, b
end

color.hsv2hwb = function(h, s, v)
  return color.rgb2hwb(color.hsv2rgb(h, s, v))
end

color.hsl2hwb = function(h, s, l)
  return color.rgb2hwb(color.hsl2rgb(h, s, l))
end

color.cmyk2hwb = function(c, m, y, k)
  return color.rgb2hwb(color.cmyk2rgb(c, m, y, k))
end

color.hwb2hsl = function(h, w, b)
  return color.rgb2hsl(color.hwb2rgb(h, w, b))
end

color.hwb2hsv = function(h, w, b)
  return color.rgb2hsv(color.hwb2rgb(h, w, b))
end

color.hwb2cmyk = function(h, w, b)
  return color.rgb2cmyk(color.hwb2rgb(h, w, b))
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
  r = decimalToHex(math.floor(r * 255 + 0.5))
  g = decimalToHex(math.floor(g * 255 + 0.5))
  b = decimalToHex(math.floor(b * 255 + 0.5))
  return '#' .. r .. g .. b
end
color.hex2rgb = function(hex)
  -- make sure hex is '#[0123456789ABCDEF]\+'
  local r, g, b
  r = tonumber(string.sub(hex, 2, 3), 16)
  g = tonumber(string.sub(hex, 4, 5), 16)
  b = tonumber(string.sub(hex, 6, 7), 16)
  return r / 255, g / 255, b / 255
end
color.hsv2hex = function(h, s, v)
  return color.rgb2hex(color.hsv2rgb(h, s, v))
end
color.hsl2hex = function(h, s, l)
  return color.rgb2hex(color.hsl2rgb(h, s, l))
end
color.cmyk2hex = function(c, y, m, k)
  return color.rgb2hex(color.cmyk2rgb(c, y, m, k))
end

color.hwb2hex = function(h, w, b)
  return color.rgb2hex(color.hwb2rgb(h, w, b))
end

color.rgb2linear = function(r, g, b)
  return unpack(vim.tbl_map(function(x)
    if x <= 0.04045 then
      return x / 12.92
    end
    return ((x + 0.055) / 1.055) ^ 2.4
  end, { r, g, b }))
end

color.linear2rgb = function(r, g, b)
  return unpack(vim.tbl_map(function(x)
    if x <= 0.0031308 then
      local a = 12.92 * x
      if a > 1 then
        return 1
      elseif a < 0 then
        return 0
      else
        return a
      end
    else
      local a = 1.055 * x ^ (1 / 2.4) - 0.055
      if a > 1 then
        return 1
      elseif a < 0 then
        return 0
      else
        return a
      end
    end
  end, { r, g, b }))
end

color.linear2hsl = function(r, g, b)
  return color.rgb2hsl(color.linear2rgb(r, g, b))
end

color.linear2hwb = function(r, g, b)
  return color.rgb2hwb(color.linear2rgb(r, g, b))
end
color.linear2cmyk = function(r, g, b)
  return color.rgb2cmyk(color.linear2rgb(r, g, b))
end
color.linear2hsv = function(r, g, b)
  return color.rgb2hsv(color.linear2rgb(r, g, b))
end
color.linear2hex = function(r, g, b)
  return color.rgb2hex(color.linear2rgb(r, g, b))
end
color.linear2lab = function(r, g, b)
  return color.xyz2lab(color.linear2xyz(r, g, b))
end

color.hsl2linear = function(h, s, l)
  return color.rgb2linear(color.hsl2rgb(h, s, l))
end

color.hwb2linear = function(h, w, b)
  return color.rgb2linear(color.hwb2rgb(h, w, b))
end

color.cmyk2linear = function(c, m, y, k)
  return color.rgb2linear(color.cmyk2rgb(c, m, y, k))
end

color.hsv2linear = function(h, s, v)
  return color.rgb2linear(color.hsv2rgb(h, s, v))
end

--------------------------------------------------------------------------------
-- XYZ color space
--------------------------------------------------------------------------------

local linear2xyz = {
  { 0.41239079926595, 0.35758433938387, 0.18048078840183 },
  { 0.21263900587151, 0.71516867876775, 0.072192315360733 },
  { 0.019330818715591, 0.11919477979462, 0.95053215224966 },
}
local xyz2linear = {
  { 3.240969941904521, -1.537383177570093, -0.498610760293 },
  { -0.96924363628087, 1.87596750150772, 0.041555057407175 },
  { 0.055630079696993, -0.20397695888897, 1.056971514242878 },
}

local function dot(a, b)
  assert(#a == #b)
  local result = 0
  for i = 1, #a do
    result = result + a[i] * b[i]
  end
  return result
end

local function product(m, v)
  local row = #m
  local result = {}
  for i = 1, row do
    result[i] = dot(m[i], v)
  end
  return unpack(result)
end

function color.linear2xyz(r, g, b)
  return product(linear2xyz, { r, g, b })
end

function color.xyz2linear(x, y, z)
  return product(xyz2linear, { x, y, z })
end

function color.rgb2xyz(r, g, b)
  return color.linear2xyz(color.rgb2linear(r, g, b))
end
function color.xyz2rgb(x, y, z)
  return color.linear2rgb(color.xyz2linear(x, y, z))
end
function color.xyz2hex(x, y, z)
  return color.rgb2hex(color.xyz2rgb(x, y, z))
end
function color.xyz2hsv(x, y, z)
  return color.rgb2hsv(color.xyz2rgb(x, y, z))
end
function color.hsv2xyz(h, s, v)
  return color.rgb2xyz(color.hsv2rgb(h, s, v))
end
function color.xyz2hsl(x, y, z)
  return color.rgb2hsl(color.xyz2rgb(x, y, z))
end
function color.hsl2xyz(h, s, l)
  return color.rgb2xyz(color.hsl2rgb(h, s, l))
end
function color.xyz2cmyk(x, y, z)
  return color.rgb2cmyk(color.xyz2rgb(x, y, z))
end
function color.cmyk2xyz(c, m, y, k)
  return color.rgb2xyz(color.cmyk2rgb(c, m, y, k))
end
function color.xyz2hwb(x, y, z)
  return color.rgb2hwb(color.xyz2rgb(x, y, z))
end
function color.hwb2xyz(h, w, b)
  return color.rgb2xyz(color.hwb2rgb(h, w, b))
end

--------------------------------------------------------------------------------
-- Lab color space
--------------------------------------------------------------------------------
-- What Does CIE L*a*b* Stand for?
--
-- The CIE in CIELAB is the abbreviation for the International Commission on
-- Illumination’s French name, Commission Internationale de l´Eclairage.
-- The letters L*, a* and b* represent each of the three values the CIELAB color
-- space uses to measure objective color and calculate color differences.
-- L* represents lightness from black to white on a scale of zero to 100,
-- while a* and b* represent chromaticity with no specific numeric limits.
-- Negative a* corresponds with green, positive a* corresponds with red,
-- negative b* corresponds with blue and positive b* corresponds with yellow.
--
-- https://www.hunterlab.com/blog/what-is-cielab-color-space/
-- https://zh.wikipedia.org/wiki/CIELAB%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4
-- https://en.wikipedia.org/wiki/CIELAB_color_space
-- https://developer.mozilla.org/zh-CN/docs/Web/CSS/color_value/lab

function color.xyz2lab(x, y, z)
  local Xn, Yn, Zn = 0.9505, 1, 1.089
  local function f(t)
    if t > (6 / 29) ^ 3 then
      return 116 * t ^ (1 / 3) - 16
    end
    return (29 / 3) ^ 3 * t
  end
  return f(y / Yn), (500 / 116) * (f(x / Xn) - f(y / Yn)), (200 / 116) * (f(y / Yn) - f(z / Zn))
end

function color.lab2xyz(l, a, b)
  local Xn, Yn, Zn = 0.9505, 1, 1.089
  local fy = (l + 16) / 116
  local fx = fy + (a / 500)
  local fz = fy - (b / 200)
  local function t(f)
    if f > 6 / 29 then
      return f ^ 3
    end
    return (116 * f - 16) * (3 / 29) ^ 3
  end
  return t(fx) * Xn, t(fy) * Yn, t(fz) * Zn
end

function color.rgb2lab(r, g, b)
  return color.xyz2lab(color.linear2xyz(color.rgb2linear(r, g, b)))
end

function color.hsl2lab(h, s, l)
  return color.rgb2lab(color.hsl2rgb(h, s, l))
end
function color.cmyk2lab(c, m, y, k)
  return color.rgb2lab(color.cmyk2rgb(c, m, y, k))
end
function color.hsv2lab(h, s, v)
  return color.rgb2lab(color.hsv2rgb(h, s, v))
end
function color.hwb2lab(h, w, b)
  return color.rgb2lab(color.hwb2rgb(h, w, b))
end

function color.lab2rgb(l, a, b)
  return color.linear2rgb(color.xyz2linear(color.lab2xyz(l, a, b)))
end

function color.lab2hex(l, a, b)
  return color.rgb2hex(color.lab2rgb(l, a, b))
end

function color.lab2hsl(l, a, b)
  return color.rgb2hsl(color.lab2rgb(l, a, b))
end
function color.lab2hsv(l, a, b)
  return color.rgb2hsv(color.lab2rgb(l, a, b))
end
function color.lab2hwb(l, a, b)
  return color.rgb2hwb(color.lab2rgb(l, a, b))
end
function color.lab2cmyk(l, a, b)
  return color.rgb2cmyk(color.lab2rgb(l, a, b))
end
function color.lab2linear(l, a, b)
  return color.xyz2linear(color.lab2xyz(l, a, b))
end

function color.lab2lch(L, a, b)
  local H = math.atan2(b, a)
  local C = math.sqrt(a ^ 2 + b ^ 2)
  H = H / (2 * math.pi) * 360 -- [rad] -> [deg]
  H = H % 360
  return L, C, H
end

function color.lch2lab(L, C, H)
  H = H / 360 * (2 * math.pi) -- [deg] -> [rad]
  local a = C * math.cos(H)
  local b = C * math.sin(H)
  return L, a, b
end
return color
