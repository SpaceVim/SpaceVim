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
local registered_name = {}

-- the flag for guide help mode, the default is false
local guide_help_mode = false

local vis = ''

-- local function without callout

local wait_for_input

local cursor_hilight_id = -1

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
  for k, _ in ipairs(target) do
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

local function escape_mappings(mapping)
  local rstring = vim.fn.substitute(mapping.rhs, [[\]], [[\\\\]], 'g')
  rstring = vim.fn.substitute(rstring, [[<\([^<>]*\)>]], '\\\\<\\1>', 'g')
  rstring = vim.fn.substitute(rstring, '"', '\\\\"', 'g')
  rstring = 'call feedkeys("' .. rstring .. '", "' .. mapping.feedkeyargs .. '")'
  return rstring
end

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

local function add_map_to_dict(map, level, dict)
  if #map.lhs > level then
    local curkey = map.lhs[level + 1]
    local nlevel = level + 1
    if not dict[curkey] then
      dict[curkey] = { name = vim.g.leaderGuide_default_group_name }
    elseif vim.tbl_islist(dict[curkey]) and vim.g.leaderGuide_flatten == 1 then
      local cmd = escape_mappings(map)
      curkey = table.concat(map.lhs, '', level)
      nlevel = level
      if not dict[curkey] then
        dict[curkey] = { cmd, map.display }
      end
    elseif vim.tbl_islist(dict[curkey]) and vim.g.leaderGuide_flatten == 0 then
      curkey = curkey .. 'm'
      if not dict[curkey] then
        dict[curkey] = { name = vim.g.leaderGuide_default_group_name }
      end
    end
    if not vim.tbl_islist(dict[curkey]) then
      add_map_to_dict(map, nlevel, dict[curkey])
    end
  else
    local cmd = escape_mappings(map)
    log.debug(vim.inspect(map))
    log.debug(level)
    if not dict[map.lhs[level]] then
      dict[map.lhs[level]] = { cmd, map.display }
    elseif not vim.tbl_islist(dict[map.lhs[level]]) and vim.g.leaderGuide_flatten == 1 then
      local childmap = flattenmap(dict[map.lhs[level]], map.lhs[level])
      for it, _ in pairs(childmap) do
        dict[it] = childmap[it]
      end

      dict[map.lhs[level]] = { cmd, map.display }
    end
  end
end

local function string_to_keys(input)
  log.debug('string_to_keys input:' .. input)
  local retlist = {}

  if vim.fn.match(input, [[<.\+>]]) ~= -1 then
    local si = 1
    local go = true
    while si <= #input do
      if go then
        if string.sub(input, si, si) == ' ' then
          table.insert(retlist, '[SPC]')
        else
          table.insert(retlist, string.sub(input, si, si))
        end
      else
        retlist[#retlist] = retlist[#retlist] .. string.sub(input, si, si)
      end
      if string.sub(input, si, si) == '<' then
        go = false
      elseif string.sub(input, si, si) == '>' then
        go = true
      end
      si = si + 1
    end
  else
    for _, it in ipairs(vim.fn.split(input, [[\zs]])) do
      if it == ' ' then
        table.insert(retlist, '[SPC]')
      else
        table.insert(retlist, it)
      end
    end
  end
  log.debug('string_to_keys output:' .. vim.inspect(retlist))
  return retlist
end

local function start_parser(key, dict)
  if key == '[KEYs]' then
    return ''
  end

  if key == ' ' then
    key = '<Space>'
  end

  local readmap = cmp.execute('map ' .. key, 'silent')
  local visual = false
  if vis == 'gv' then
    visual = true
  else
    visual = false
  end

  for _, line in ipairs(cmp.fn.split(readmap, '\n')) do
    local name = vim.fn.split(string.sub(line, 4, #line))[1]
    log.debug('name is:' .. name)
    log.debug('line is:' .. line)
    local mapd = cmp.fn.maparg(name, string.sub(line, 1, 1), 0, 1)
    log.debug('mapd is:' .. vim.inspect(mapd))
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
      log.debug('mapd is:' .. vim.inspect(mapd))
      mapd.lhs = string_to_keys(mapd.lhs)
      log.debug('mapd is:' .. vim.inspect(mapd))
      if
        (visual and vim.fn.match(mapd.mode, '[vx ]') >= 0)
        or (not visual and vim.fn.match(mapd.mode, '[vx ]') == -1)
      then
        add_map_to_dict(mapd, 1, dict)
      end
    end
    ::continue::
  end
end

local function calc_layout()
  local ret = {}

  log.debug('calc_layout:')
  log.debug('lmap is:\n' .. vim.inspect(lmap))

  local smap = vim.fn.filter(vim.fn.copy(lmap), 'v:key !=# "name"')
  log.debug('smap is:\n' .. vim.inspect(smap))
  log.debug('#smap is:' .. #smap)
  ret.n_items = vim.fn.len(smap)
  log.debug('n_items is:' .. ret.n_items)
  local length = {}
  for k, v in pairs(smap) do
    if v.name then
      table.insert(length, vim.fn.strdisplaywidth('[' .. k .. ']' .. v.name))
    else
      table.insert(length, vim.fn.strdisplaywidth('[' .. k .. ']' .. v[2]))
    end
  end
  log.debug('length is:' .. vim.inspect(length))
  local maxlength = vim.fn.max(length) + vim.g.leaderGuide_hspace
  log.debug('maxlength is:' .. maxlength)

  if vim.g.leaderGuide_vertical == 1 then
    ret.n_rows = vim.fn.winheight(0) - 2
    ret.n_cols = math.floor(ret.n_items / ret.n_rows)
    if ret.n_items ~= ret.n_rows then
      ret.n_cols = ret.n_cols + 1
    end
    ret.col_width = maxlength
    ret.win_dim = ret.n_cols * ret.col_width
  else
    if vim.fn.winwidth(winid) >= maxlength then
      ret.n_cols = math.floor(vim.fn.winwidth(winid) / maxlength)
    else
      ret.n_cols = 1
    end
    ret.col_width = math.floor(vim.fn.winwidth(winid) / ret.n_cols)
    ret.n_rows = math.floor(ret.n_items / ret.n_cols)
    if vim.fn.fmod(ret.n_items, ret.n_cols) > 0 then
      ret.n_rows = ret.n_rows + 1
    end
    ret.win_dim = ret.n_rows
  end
  log.debug('layout is:' .. vim.inspect(ret))
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
    return true
  elseif b - a == 32 and b >= 97 and b <= 122 then
    return false
  elseif a >= 97 and a <= 122 and b >= 97 and b <= 122 then
    if a == b then
      return false
    elseif a > b then
      return false
    else
      return true
    end
  elseif a >= 65 and a <= 90 and b >= 65 and b <= 90 then
    if a == b then
      return false
    elseif a > b then
      return false
    else
      return true
    end
  elseif a >= 97 and a <= 122 and b >= 65 and b <= 90 then
    return compare_key(cmp.fn.nr2char(a), cmp.fn.nr2char(b + 32))
  elseif a >= 65 and a <= 90 and b >= 97 and b <= 122 then
    return compare_key(cmp.fn.nr2char(a), cmp.fn.nr2char(b - 32))
  end
  if a == b then
    return false
  elseif a > b then
    return false
  else
    return true
  end
end

local function create_string(layout)
  log.debug('create string:')
  log.debug('layout is:' .. vim.inspect(layout))
  local l = layout

  l.capacity = l.n_rows * l.n_cols

  local overcap = l.capacity - l.n_cols

  local overh = l.n_cols - overcap

  local n_rows = l.n_rows - 1

  local rows = {}

  local row = 1

  local col = 1

  local crow = {}
  log.debug('lmap is:' .. vim.inspect(lmap))
  local smap = {}
  for k, _ in pairs(lmap) do
    if k ~= 'name' then
      table.insert(smap, k)
    end
  end
  table.sort(smap, compare_key)
  -- log.debug('smap is:' .. vim.inspect(smap))

  for _, k in ipairs(smap) do
    local desc = ''
    if lmap[k].name then
      desc = lmap[k].name
    else
      desc = lmap[k][2] or ''
    end
    local offset = string.rep(' ', 8 - #k)
    local displaystring
    if vim.g.spacevim_leader_guide_theme == 'whichkey' then
      displaystring = offset .. k .. ' -> ' .. desc
    else
      displaystring = offset .. '[' .. k .. '] ' .. desc
    end
    crow = rows[row] or {}
    -- log.debug('crow is:' .. vim.inspect(crow))

    if #crow == 0 then
      table.insert(rows, crow)
    end
    -- if the displaystring is too long
    if #displaystring > l.col_width then
      table.insert(crow, string.sub(displaystring, 1, l.col_width -5) .. '...  ')
    else
      table.insert(crow, displaystring)
      table.insert(crow, vim.fn['repeat'](' ', l.col_width - vim.fn.strdisplaywidth(displaystring)))
    end
    if vim.g.leaderGuide_sort_horizontal == 0 then
      log.debug('row is:' .. row)
      if row > n_rows then
        if overh > 0 and row < n_rows then
          overh = overh - 1
          row = row + 1
        else
          row = 1
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
    local line = table.concat(ro, '')
    table.insert(r, line)
    if vim.fn.strdisplaywidth(line) > mlen then
      mlen = vim.fn.strdisplaywidth(line)
    end
  end
  table.insert(r, '')
  log.debug('string is:\n' .. table.concat(r, '\n'))
  return r
end

local function highlight_cursor()
  log.debug(
    'highlight cursor: line ' .. vim.fn.line('.') .. ' col ' .. vim.fn.col('.') .. ' vis ' .. vis
  )
  vim.cmd('hi! def link SpaceVimGuideCursor Cursor')
  if vis == 'gv' then
    local _begin = vim.fn.getpos("'<")
    local _end = vim.fn.getpos("'>")
    local pos = {}
    if _begin[2] == _end[2] then
      pos = { { _begin[2], math.min(_begin[3], _end[3]), math.abs(_begin[3] - _end[3]) + 1 } }
    else
      pos = {
        { _begin[2], _begin[3], vim.fn.len(vim.fn.getline(_begin[2])) - _begin[3] + 1 },
        { _end[2], 1, _end[3] },
      }
      for _, lnum in ipairs(vim.fn.range(_begin[2] + 1, _end[2] - 1)) do
        table.insert(pos, { lnum, 1, vim.fn.len(vim.fn.getline(lnum)) })
      end
    end
    log.debug('pos:' .. vim.inspect(pos))
    cursor_hilight_id = vim.fn.matchaddpos('SpaceVimGuideCursor', pos)
  else
    cursor_hilight_id =
      vim.fn.matchaddpos('SpaceVimGuideCursor', { { vim.fn.line('.'), vim.fn.col('.'), 1 } })
  end
end

local function remove_cursor_highlight()
  pcall(vim.fn.matchdelete, cursor_hilight_id)
end

local function guide_help_msg(escape)
  local msg
  if guide_help_mode then
    msg = ' n -> next-page, p -> previous-page, u -> undo-key'
  else
    msg = ' [C-h paging/help]'
  end
  if escape then
    return vim.fn.substitute(msg, ' ', '\\\\ ', 'g')
  else
    return msg
  end
end

local function updateStatusline()
  vim.fn['SpaceVim#mapping#guide#theme#hi']()
  local gname = guide_group.name or ''
  if #gname > 0 then
    gname = ' - ' .. string.sub(gname, 2)
  end
  local keys = prefix_key_inp

  SL.open_float({
    { 'Guide: ', 'LeaderGuiderPrompt' },
    { ' ', 'LeaderGuiderSep1' },
    {
      vim.fn['SpaceVim#mapping#leader#getName'](prefix_key) .. table.concat(keys, '') .. gname,
      'LeaderGuiderName',
    },
    { ' ', 'LeaderGuiderSep2' },
    { guide_help_msg(false), 'LeaderGuiderFill' },
    { string.rep(' ', 999), 'LeaderGuiderFill' },
  })
end

local function setlocalopt(buf, win, opts)
  for o, value in pairs(opts) do
    local info = vim.api.nvim_get_option_info2(o, {})
    if info.scope == 'win' then
      vim.api.nvim_set_option_value(o, value, {
        win = win,
      })
    elseif info.scope == 'buf' then
      vim.api.nvim_set_option_value(o, value, {
        buf = buf,
      })
    end
  end
end
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
  setlocalopt(bufnr, winid, {
    winhighlight = 'Normal:Pmenu,Search:',
    filetype = 'leaderGuide',
    number = false,
    relativenumber = false,
    list = false,
    modeline = false,
    wrap = false,
    buflisted = false,
    buftype = 'nofile',
    bufhidden = 'unload',
    swapfile = false,
    cursorline = false,
    cursorcolumn = false,
    colorcolumn = '',
    winfixwidth = true,
    winfixheight = true,
  })
  updateStatusline()
  return winid, bufnr
end
local function start_buffer()
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

  log.debug('text is:\n' .. vim.inspect(text))

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, text)

  cmp.fn.setbufvar(bufnr, '&modifiable', 0)

  vim.cmd('redraw!')

  wait_for_input()
end

local function close_float_statusline()
  SL.close_float()
end
local function winclose()
  vim.api.nvim_win_close(winid, true)
  close_float_statusline()
  remove_cursor_highlight()
end

local function handle_input(input)
  log.debug('handle_input:' .. vim.inspect(input))
  winclose()
  if not vim.tbl_islist(input) then
    lmap = input
    start_buffer()
  else
    prefix_key_inp = {}
    cmp.fn.feedkeys(vis .. reg .. count, 'ti')

    --- redraw!

    local ok, _ = pcall(vim.fn.execute, input[1])
    if not ok then
      print(vim.v.exception)
    end
  end
end

local function page_down()
  log.debug('page down')
  -- vim.api.nvim_feedkeys(Key.t('<C-c>'), 'n', false)
  vim.api.nvim_feedkeys(Key.t('<C-d>'), 'x', false)
  vim.cmd('redraw!')
  wait_for_input()
end

local function page_undo()
  winclose()
  if #prefix_key_inp then
    table.remove(prefix_key_inp)
  end
  if #undo_history > 0 then
    lmap = table.remove(undo_history)
  end
  start_buffer()
end

local function page_up()
  log.debug('page up')

  -- vim.api.nvim_feedkeys(Key.t('<C-c>'), 'n', false)
  vim.api.nvim_feedkeys(Key.t('<C-u>'), 'x', false)
  vim.cmd('redraw!')
  wait_for_input()
end

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

local function warn_not_defined(mpt)
  vim.cmd('redraw')
  vim.api.nvim_echo({
    { mpt[1], 'Comment' },
    { mpt[2], 'Wildmenu' },
  }, false, {})
end

wait_for_input = function()
  log.debug('wait for input:')
  local t = Key.t
  local inp = VIM.getchar()
  log.debug('inp is:' .. inp)
  if inp == t('<Esc>') then
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
    vim.cmd('redraw!')
    wait_for_input()
  else
    if inp == ' ' then
      inp = '[SPC]'
    else
      inp = Key.char2name(inp)
    end
    local fsel = lmap[inp] or ''
    if vim.fn.empty(fsel) == 0 then
      table.insert(prefix_key_inp, inp)
      table.insert(undo_history, lmap)
      handle_input(fsel)
    else
      winclose()
      vim.cmd('doautocmd WinEnter')
      local keys = prefix_key_inp
      local name = M.getName(prefix_key)
      local _keys = vim.fn.join(keys, '-')
      if vim.fn.empty(_keys) == 1 then
        warn_not_defined({ 'Key bindings is not defined: ', name .. '-' .. inp })
      else
        warn_not_defined({ 'key bindings is not defined: ', name .. '-' .. _keys .. '-' .. inp })
      end
      prefix_key_inp = {}
      guide_help_mode = false
    end
  end
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
    vim.g._spacevim_mappings_space.l = vim.b['spacevim_lang_specified_mappings']
  end
  guide_help_mode = false
  -- _vis is 0 or 1
  if _vis == '1' then
    vis = 'gv'
  else
    vis = ''
  end

  log.debug('vis is:' .. vis)

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

function M.register_displayname(lhs, name)
  registered_name[lhs] = name
end

function M.displayfunc()
  if registered_name[vim.g['leaderGuide#displayname']] then
    vim.g['leaderGuide#displayname'] = registered_name[vim.g['leaderGuide#displayname']]
  end
end

function M.populate_dictionary(key, _)
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
