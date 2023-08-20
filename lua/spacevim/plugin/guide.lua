--=============================================================================
-- guide.lua --- Key binding guide for spacevim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local log = require('spacevim.logger').derive('guide')
local Key = require('spacevim.api').import('vim.keys')

local cmp = require('spacevim.api').import('vim.compatible')
local buffer = require('spacevim.api').import('vim.buffer')
local VIM = require('spacevim.api').import('vim')
local SL = require('spacevim.api').import('vim.statusline')

-- all local values should be listed here:

local desc_lookup = {}

local cached_dicts = {}
local reg = ''

local winid = -1

local count = ''
local toplevel = false
local prefix_key
local guide_group = {}

local bufnr = -1

local prefix_key_inp = {}

local lmap = {}

local undo_history = {}

-- the flag for guide help mode, the default is false
local guide_help_mode = false

local vis = ''

-- local function without callout

local wait_for_input

local function create_cache()
  desc_lookup = {}

  cached_dicts = {}
end

function M.has_configuration()
  return desc_lookup ~= nil
end

function M.register_prefix_descriptions(key, dictname)
  if key == '<Space>' then
    key = ' '
  end
  if desc_lookup == nil then
    create_cache()
  end
  if #key == 0 then
    desc_lookup['top'] = dictname
  elseif desc_lookup[key] == nil then
    desc_lookup[key] = dictname
  end
  log.debug('desc_lookup is:' .. vim.inspect(desc_lookup))
end

local function merge(dict_t, dict_o)
  local target = dict_t
  local other = dict_o
  for k, v in ipairs(target) do
    if vim.fn.type(target[k]) == 4 and vim.fn.has_key(other, k) then
      if vim.fn.type(other[k]) == 4 then
        if vim.fn.has_key(target[k], 'name') then
          other[k].name = target[k].name
        end
        merge(target[k], other[k])
      elseif vim.fn.type(other[k]) == 3 then
        if vim.g.leaderGuide_flatten == 0 or vim.fn.type(target[k]) == 4 then
          target[k .. 'm'] = target[k]
        end
        target[k] = other[k]
        if vim.fn.has_key(other, k .. 'm') and vim.fn.type(other[k .. 'm']) == 4 then
          merge(target[k .. 'm'], other[k .. 'm'])
        end
      end
    end
  end
  vim.fn.extend(target, other, 'keep')
end

local function create_target_dict(key)
  local topdict = {}
  local tardict = {}
  local mapdict = {}
  if desc_lookup['top'] ~= nil then
    topdict = cmp.fn.deepcopy(vim.api.nvim_eval(desc_lookup['top']))
    if toplevel then
      tardict = topdict
    else
      tardict = topdict[key] or {}
    end
    mapdict = cached_dicts[key]
    merge(tardict, mapdict)
  elseif desc_lookup[key] ~= nil then
    tardict = cmp.fn.deepcopy(vim.api.nvim_eval(desc_lookup[key]))
    mapdict = cached_dicts[key]
  else
    tardict = cached_dicts[key]
  end
  return tardict
end

local function format_displaystring(map)
  vim.g['leaderGuide#displayname'] = map

  if vim.g['leaderGuide_displayfunc'] then
    for _, f in ipairs(vim.g['leaderGuide_displayfunc']) do
      pcall(f)
    end
  end

  local display = vim.g['leaderGuide#displayname']
  vim.cmd('unlet g:leaderGuide#displayname')
  return display
end

local function start_parser(key, dict)
  if key == '[KEYs]' then
    return ''
  end

  if key == ' ' then
    key = '<Space>'
  end

  local readmap = cmp.execute('map ' .. key, 'silent')

  for _, line in ipairs(cmp.fn.split(readmap, '\n')) do
    local name = vim.fn.split(string.sub(line, 4, #line))[1]
    log.debug('name is:' .. name)
    local mapd = cmp.fn.maparg(name, string.sub(line, 1, 1), 0, 1)
    if mapd.lhs == '\\' then
      mapd.feedkeyargs = ''
    elseif mapd.noremap == 1 then
      mapd.feedkeyargs = 'nt'
    else
      mapd.feedkeyargs = 'mt'
    end
    if mapd.lhs == '<Plug>.*' or mapd.lhs == '<SNR>.*' then
      goto continue
    end
    mapd.display = format_displaystring(mapd.rhs)
    mapd.lhs = cmp.fn.substitute(mapd.lhs, key, '', '')
    mapd.lhs = cmp.fn.substitute(mapd.lhs, '<Space>', ' ', 'g')
    mapd.lhs = cmp.fn.substitute(mapd.lhs, '<Tab>', '<C-I>', 'g')
    mapd.rhs = cmp.fn.substitute(mapd.rhs, '<SID>', '<SNR>' .. mapd['sid'] .. '_', 'g')
    if mapd.lhs ~= '' and mapd.display ~= 'LeaderGuide.*' then
    end
    ::continue::
  end
end

local function add_map_to_dict(map, level, dict) end

local function flattenmap(dict, str)
  local ret = {}

  for kv, _ in ipairs(dict) do
    if vim.fn.type(dict[kv]) == 3 then
      local toret = {}
      toret[str .. kv] = dict[kv]
      return toret
    elseif vim.fn.type(dict[kv]) == 4 then
      vim.fn.extend(ret, flattenmap(dict[kv], str .. kv))
    end
  end

  return ret
end

local function escape_mappings(mapping)
  local rstring = vim.fn.substitute(mapping.rhs, [[\]], [[\\\\]], 'g')
  rstring = vim.fn.substitute(rstring, [[<\([^<>]*\)>]], '\\\\<\\1>', 'g')
  rstring = vim.fn.substitute(rstring, '"', '\\\\"', 'g')
  rstring = 'call feedkeys("' .. rstring .. '", "' .. mapping.feedkeyargs .. '")'
  return rstring
end

local function string_to_keys(input)
  local retlist = {}

  if vim.fn.match(input, [[<.\+>]]) ~= -1 then
    local si = 0
    local go = true
    while si < vim.fn.len(input) do
      if go then
        if input[si] == ' ' then
          vim.fn.add(retlist, '[SPC]')
        else
          vim.fn.add(retlist, input[si])
        end
      else
        retlist[-1] = retlist[-1] .. input[si]
      end
      if input[si] == '<' then
        go = false
      else
        go = true
      end
      si = si + 1
    end
  else
    for _, it in ipairs(vim.fn.split(input, [[\zs]])) do
      if it == ' ' then
        vim.fn.add(retlist, '[SPC]')
      else
        vim.fn.add(retlist, it)
      end
    end
  end
  return retlist
end

local function escape_keys(inp)
  local ret = cmp.fn.substitute(inp, '<', '<lt>', '')
  return cmp.fn.substitute(ret, '|', '<Bar>', '')
end

local function calc_layout()
  local ret = {}

  local smap = vim.fn.filter(vim.fn.copy(lmap), 'v:key !=# "name"')
  ret.n_items = vim.fn.len(smap)
  local length = {}
  for k, v in pairs(smap) do
    if v.name then
      table.insert(length, vim.fn.strdisplaywidth('[' .. k .. ']' .. v.name))
    else
      table.insert(length, vim.fn.strdisplaywidth('[' .. k .. ']' .. v[2]))
    end
  end
  local maxlength = vim.fn.max(length) + vim.g.leaderGuide_hspace

  if vim.g.leaderGuide_vertical == 1 then
    ret.n_rows = vim.fn.winheight(0) - 2
    ret.n_cols = ret.n_items / ret.n_rows
    if ret.n_items ~= ret.n_rows then
      ret.n_cols = ret.n_cols + 1
    end
    ret.col_width = maxlength
    ret.win_dim = ret.n_cols * ret.col_width
  else
    if vim.fn.winwidth(winid) >= maxlength then
      ret.n_cols = vim.fn.winwidth(winid) / maxlength
    else
      ret.n_cols = 1
    end
    ret.col_width = vim.fn.winwidth(winid) / ret.n_cols
    ret.n_rows = ret.n_items / ret.n_cols
    if vim.fn.fmod(ret.n_items, ret.n_cols) > 0 then
      ret.n_rows = ret.n_rows + 1
    end
    ret.win_dim = ret.n_rows
  end
  return ret
end

local function get_key_number(key)
  if key == '[SPC]' then
    return 32
  elseif key == '<Tab>' then
    return 9
  else
    return cmp.fn.char2nr(key)
  end
end

local function compare_key(i1, i2)
  local a = get_key_number(i1)
  local b = get_key_number(i2)
  if a - b == 32 and a >= 97 and a <= 122 then
    return -1
  elseif b - a == 32 and b >= 97 and b <= 122 then
    return 1
  elseif a >= 97 and a <= 122 and b >= 97 and b <= 122 then
    if a == b then
      return 0
    elseif a > b then
      return 1
    else
      return -1
    end
  elseif a >= 65 and a <= 90 and b >= 65 and b <= 90 then
    if a == b then
      return 0
    elseif a > b then
      return 1
    else
      return -1
    end
  elseif a >= 97 and a <= 122 and b >= 65 and b <= 90 then
    return compare_key(cmp.fn.nr2char(a), cmp.fn.nr2char(b + 32))
  elseif a >= 65 and a <= 90 and b >= 97 and b <= 122 then
    return compare_key(cmp.fn.nr2char(a), cmp.fn.nr2char(b - 32))
  end
  if a == b then
    return 0
  elseif a > b then
    return 1
  else
    return -1
  end
end

local function create_string(layout)
  local l = layout

  l.capacity = l.n_rows * l.n_cols

  local overcap = l.capacity - l.n_cols

  local overh = l.n_cols - overcap

  local n_rows = l.n_rows - 1

  local rows = {}

  local row = 0

  local col = 0
  log.debug('lmap is:' .. vim.inspect(lmap))
  local smap = {}
  for k, _ in pairs(lmap) do
    if k ~= 'name' then
      table.insert(smap, k)
    end
  end
  table.sort(smap, compare_key)

  for _, k in ipairs(smap) do
    local desc = ''
    if lmap[k].name then
      desc = lmap[k].name
    else
      desc = lmap[k][2] or ''
    end
    local displaystring = '[' .. k .. ']' .. desc
    local crow = rows[row] or {}

    if vim.fn.empty(crow) == 1 then
      vim.fn.add(rows, crow)
    end
    vim.fn.add(crow, displaystring)
    vim.fn.add(crow, vim.fn['repeat'](' ', l.col_width - vim.fn.strdisplaywidth(displaystring)))
    if vim.g.leaderGuide_sort_horizontal == 0 then
      if overh >= n_rows - 1 then
        if overh > 0 and row < n_rows then
          overh = overh - 1
          row = row + 1
        else
          row = 0
          col = col + 1
        end
      else
        row = row + 1
      end
    else
      if col == l.n_cols - 1 then
        row = row + 1
        col = 0
      else
        col = col + 1
      end
    end
  end
  local r = { '' }
  local mlen = 0
  for _, ro in ipairs(rows) do
    local line = vim.fn.join(ro, '')
    vim.fn.add(r, line)
    if vim.fn.strdisplaywidth(line) > mlen then
      mlen = vim.fn.strdisplaywidth(line)
    end
  end
  table.insert(r, '')
  return r
end

local function highlight_cursor() end

local function remove_cursor_highlight() end

local function updateStatusline() end

local function toggle_hide_cursor() end
local function winopen()
  highlight_cursor()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    bufnr = buffer.create_buf(false, true)
  end
  winid = vim.api.nvim_open_win(bufnr, true, {
    relative = 'editor',
    width = vim.o.columns,
    height = 12,
    row = vim.o.lines - 14,
    col = 0,
  })
  guide_help_mode = false
  updateStatusline()
  toggle_hide_cursor()
  return winid, bufnr
end
local function start_buffer()
  local winv = cmp.fn.winsaveview()
  local winnr = cmp.fn.winnr()
  local winres = cmp.fn.winrestcmd()
  local winid = 0
  local bufnr = 0
  winid, bufnr = winopen()
  local layout = calc_layout()
  local text = create_string(layout)
  if vim.g.leaderGuide_max_size then
    layout.win_dim = cmp.fn.min({ vim.g.leaderGuide_max_size, layout.win_dim })
  end
  cmp.fn.setbufvar(bufnr, '&modifiable', 1)
  -- always in neovim >= 0.9.0
  vim.api.nvim_win_set_config(winid, {
    relative = 'editor',
    width = vim.o.columns,
    height = layout.win_dim + 2,
    row = vim.o.lines - layout.win_dim - 4,
    col = 0,
  })

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, text)

  cmp.fn.setbufvar(bufnr, '&modifiable', 0)

  vim.cmd('redraw!')

  wait_for_input()
end

local function close_float_statusline() end
local function winclose()
  toggle_hide_cursor()
  vim.api.nvim_win_close(winid, true)
  close_float_statusline()
  remove_cursor_highlight()
end

local function handle_input(input)
  log.debug('handle_input:' .. vim.inspect(input))
  winclose()
  if type(input) == 'table' then
    lmap = input
    start_buffer()
  else
    prefix_key_inp = {}
    cmp.fn.feedkeys(vis .. reg .. count, 'ti')

    --- redraw!

    local ok, errors = pcall(vim.fn.execute, input[1])
    if not ok then
      print(vim.v.exception)
    end
  end
end
local function toggle_hide_cursor() end

local function page_down() end

local function page_undo()
  winclose()
  if vim.fn.len(prefix_key_inp) > 0 then
    vim.fn.remove(prefix_key_inp, -1)
  end
  if vim.fn.len(undo_history) > 0 then
    lmap = vim.fn.remove(undo_history, -1)
  end
  start_buffer()
end

local function page_up() end

local function handle_submode_mapping(cmd)
  guide_help_mode = false

  updateStatusline()

  if cmd == 'n' then
    page_down()
  elseif cmd == 'p' then
    page_up()
  elseif cmd == 'u' then
    page_undo()
  else
    winclose()
  end
end

local function submode_mappings(key)
  handle_submode_mapping(key)
end

local function build_mpt(mpt)
  vim.fn.execute('normal! :')

  vim.fn.execute('echohl Comment')

  if type(mpt) == 'string' then
    print(mpt)
  else
  end

  vim.fn.execute('echohl NONE')
end

wait_for_input = function()
  local t = Key.t
  local inp = VIM.getchar()
  if inp == t('<Esc') then
    prefix_key_inp = {}
    undo_history = {}
    guide_help_mode = false
    winclose()
    vim.cmd('doautocmd WinEnter')
  elseif guide_help_mode then
    submode_mappings(inp)
    guide_help_mode = false
  elseif inp == t('<C-h>') then
    guide_help_mode = true
    updateStatusline()
    -- redraw!
    wait_for_input()
  else
    if inp == ' ' then
      inp = '[SPC]'
    else
      inp = Key.char2name(inp)
    end
    log.debug('inp:' .. inp)
    local fsel = lmap[inp] or ''
    if vim.fn.empty(fsel) == 0 then
      vim.fn.add(prefix_key_inp, inp)
      vim.fn.add(undo_history, lmap)
      handle_input(fsel)
    else
      winclose()
      vim.cmd('doautocmd WinEnter')
      local keys = prefix_key_inp
      local name = M.getName(prefix_key)
      local _keys = vim.fn.join(keys, '-')
      if vim.fn.empty(_keys) == 1 then
        build_mpt({ 'Key bindings is not defined: ', name .. '-' .. inp })
      else
        build_mpt({ 'key bindings is not defined: ', name .. '-' .. _keys .. '-' .. inp })
      end
      prefix_key_inp = {}
      guide_help_mode = false
    end
  end
end

local function guide_help_msg(escape)
  local msg = ''
  if guide_help_mode then
    msg = ' n -> next-page, p -> previous-page, u -> undo-key'
  else
    msg = ' [C-h paging/help]'
  end
  if escape then
    return vim.fn.substitute(msg, ' ', '\\ ', 'g')
  else
    return msg
  end
end

local function mapmaparg(maparg)
  local map = ''
  local buf = ''
  local silent = ''
  local nowait = ''

  if maparg.noremap == 1 then
    map = 'noremap'
  else
    map = 'map'
  end

  if maparg.buffer == 1 then
    buf = '<buffer>'
  end

  if maparg.silent == 1 then
    silent = '<silent>'
  end
  if maparg.nowait == 1 then
    nowait = '<nowait>'
  end
  local st = maparg.mode
    .. ''
    .. map
    .. ' '
    .. nowait
    .. silent
    .. buf
    .. ''
    .. maparg.lhs
    .. ' '
    .. maparg.rhs
  vim.execute(st)
end

local function get_register()
  if vim.fn.match(vim.o.clipboard, 'unnamedplus') >= 0 then
    return '+'
  elseif vim.fn.match(vim.o.clipboard, 'unnamed') >= 0 then
    return '*'
  else
    return '"'
  end
end

function M.start_by_prefix(_vis, _key)
  log.debug('start by prefix:' .. _key .. ' vis:' .. _vis)

  if _key == ' ' and vim.fn.exists('b:spacevim_lang_specified_mappings') == 1 then
    vim.g._spacevim_mappings_space.l = vim.b.spacevim_lang_specified_mappings
  end
  guide_help_mode = false
  -- _vis is 0 or 1
  if _vis == 1 then
    vis = 'gv'
  else
    vis = ''
  end

  if vim.v.count ~= 0 then
    count = vim.v.count
  else
    count = ''
  end

  if _key == ' ' then
    toplevel = true
  else
    toplevel = false
  end
  prefix_key = _key
  guide_group = {}

  if vim.v.register ~= get_register() then
    reg = '"' .. vim.v.register
  else
    reg = ''
  end

  if not cached_dicts[_key] or vim.g.leaderGuide_run_map_on_popup then
    cached_dicts[_key] = {}

    start_parser(_key, cached_dicts[_key])
  end
  if desc_lookup[_key] or desc_lookup['top'] then
    lmap = create_target_dict(_key)
  else
    lmap = cached_dicts[_key]
  end
  start_buffer()
end

function M.start(_vis, _dict)
  if _vis == 'gv' then
    vis = 'gv'
  else
    vis = ''
  end
  lmap = _dict
  start_buffer()
end

function M.register_displayname(lhs, name) end

function M.populate_dictionary(key, dictname)
  start_parser(key, cached_dicts[key])
end

function M.parse_mappings()
  for k, v in ipairs(cached_dicts) do
    start_parser(k, v)
  end
end

function M.getName(p)
  return vim.fn['SpaceVim#mapping#leader#getName'](p)
end

return M
