--=============================================================================
-- statusline.lua ---
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local highlight = require('spacevim.api.vim.highlight')
local system = require('spacevim.api.system')
local lang = require('spacevim.api.language')
local time = require('spacevim.api.time')
local JSON = require('spacevim.api.data.json')

local layer = require('spacevim.layer')

local messletters = require('spacevim.api.messletters')
local statusline = require('spacevim.api.vim.statusline')
local log = require('spacevim.logger').derive('stl')

local M = {}

local function index(t, v)
  for n, m in ipairs(t) do
    if m == v then
      return n
    end
  end
  return -1
end

-- https://github.com/ryanoasis/powerline-extra-symbols
local separators = {
  arrow = { '', '' },
  curve = { '', '' },
  slant = { '', '' },
  brace = { '', '' },
  fire = { '', '' },
  ['nil'] = { '', '' },
}
local i_separators = {
  arrow = { '', '' },
  curve = { '', '' },
  slant = { '', '' },
  bar = { '|', '|' },
  ['nil'] = { '', '' },
}

local lsep = ''
local rsep = ''
local ilsep = ''
local irsep = ''

local loaded_modes = {}
local colors_template = vim.fn['SpaceVim#mapping#guide#theme#gruvbox#palette']()
local section_old_pos = {}

local modes = {
  ['center-cursor'] = {
    icon = '',
    icon_asc = '-',
    desc = 'centered-cursor mode',
  },
  ['hi-characters-for-long-lines'] = {
    icon = '⑧',
    icon_asc = '8',
    desc = 'toggle highlight of characters for long lines',
  },
  ['fill-column-indicator'] = {
    icon = messletters.circled_letter('f'),
    icon_asc = 'f',
    desc = 'fill-column-indicator mode',
  },
  ['syntax-checking'] = {
    icon = messletters.circled_letter('s'),
    icon_asc = 's',
    desc = 'syntax-checking mode',
  },
  ['spell-checking'] = {
    icon = messletters.circled_letter('S'),
    icon_asc = 'S',
    desc = 'spell-checking mode',
  },
  ['paste-mode'] = {
    icon = messletters.circled_letter('p'),
    icon_asc = 'p',
    desc = 'paste mode',
  },
  whitespace = {
    icon = messletters.circled_letter('w'),
    icon_asc = 'w',
    desc = 'whitespace mode',
  },
  wrapline = {
    icon = messletters.circled_letter('W'),
    icon_asc = 'W',
    desc = 'wrap line mode',
  },
}

local major_mode_cache = true

if layer.isLoaded('checkers') then
  table.insert(loaded_modes, 'syntax-checking')
end

if vim.o.spell then
  table.insert(loaded_modes, 'spell-checking')
end

if vim.o.cc == '80' then
  table.insert(loaded_modes, 'fill-column-indicator')
end

if index(vim.g.spacevim_statusline_right, 'whitespace') ~= -1 then
  table.insert(loaded_modes, 'whitespace')
end

local function winnr(...)
  if select(1, ...) then
    if vim.g.spacevim_windows_index_type == 3 then
      return ' %{ get(w:, "winid", winnr()) } '
    else
      return ' %{ v:lua.require("spacevim.plugin.statusline").winnr(get(w:, "winid", winnr())) } '
    end
  else
    if vim.g.spacevim_enable_statusline_mode == 1 then
      return '%{v:lua.require("spacevim.plugin.statusline").mode(mode())} %{ v:lua.require("spacevim.plugin.statusline").winnr(get(w:, "winid", winnr())) } %{v:lua.require("spacevim.plugin.statusline").mode_text(mode())} '
    elseif vim.g.spacevim_windows_index_type == 3 then
      return '%{v:lua.require("spacevim.plugin.statusline").mode(mode())} %{ get(w:, "winid", winnr()) } '
    else
      return '%{v:lua.require("spacevim.plugin.statusline").mode(mode())} %{ v:lua.require("spacevim.plugin.statusline").winnr(get(w:, "winid", winnr())) } '
    end
  end
end

function M.winnr(id)
  return messletters.circled_num(id, vim.g.spacevim_windows_index_type)
end

local function whitespace()
  local ln = vim.fn.search('\\s\\+$', 'nw')
  if ln ~= 0 then
    return ' trailing[' .. ln .. '] '
  else
    return ''
  end
end

local function battery_status()
  if vim.fn.executable('acpi') == 1 then
  else
    return ''
  end
end

---@return string # The buffer name
local function buffer_name()
  if vim.b._spacevim_statusline_showbfname == 1 or vim.g.spacevim_enable_statusline_bfpath == 1 then
    return ' ' .. vim.fn.bufname('%')
  else
    return ''
  end
end

local function input_method()
  if vim.fn.executable('fcitx-remote') == 1 then
    if vim.fn.system('fcitx-remote') == 1 then
      return ' cn '
    else
      return ' en '
    end
  end
  return ''
end

local function syntax_checking()
  if vim.fn['SpaceVim#lsp#buf_server_ready']() then
    local counts = require('spacevim.lsp').lsp_diagnostic_count()
    local errors = counts[1] or 0
    local warnings = counts[2] or 0
    local infos = counts[3] or 0
    local hints = counts[4] or 0

    local errors_l = ''
    if errors > 0 then
      errors_l = '%#SpaceVim_statusline_error#● ' .. errors
    end
    local warnings_l = ''
    if warnings > 0 then
      warnings_l = '%#SpaceVim_statusline_warn#● ' .. warnings
    end
    local infos_l = ''
    if infos > 0 then
      infos_l = '%#SpaceVim_statusline_info#● ' .. infos
    end
    local hints_l = ''
    if hints > 0 then
      hints_l = '%#SpaceVim_statusline_hint#● ' .. hints
    end
    local l = table.concat(
      vim.tbl_filter(function(t)
        return t ~= ''
      end, { errors_l, warnings_l, infos_l, hints_l }),
      ' '
    )
    if #l > 0 then
      return ' ' .. l .. ' '
    else
      return ''
    end
  elseif vim.g.spacevim_lint_engine == 'neomake' then
    if not vim.g.loaded_neomake then
      return ''
    end
    local counts = vim.fn['neomake#statusline#LoclistCounts']()
    local warnings = counts.W or 0
    local errors = counts.E or 0
    local l = ''

    if warnings > 0 then
      l = '%#SpaceVim_statusline_warn# ● ' .. warnings .. ' '
    end
    if errors > 0 then
      l = l .. '%#SpaceVim_statusline_error#● ' .. errors
    end
    if l ~= '' then
      return ' ' .. l .. ' '
    else
      return ''
    end
  elseif vim.g.spacevim_lint_engine == 'ale' then
    if not vim.g.ale_enabled then
      return ''
    end

    local counts = vim.fn['ale#statusline#Count'](vim.fn.bufnr(''))
    local warnings = counts.warning + counts.style_warning
    local errors = counts.error + counts.style_error
    local l = ''

    if warnings > 0 then
      l = '%#SpaceVim_statusline_warn# ● ' .. warnings .. ' '
    end
    if errors > 0 then
      l = l .. '%#SpaceVim_statusline_error#● ' .. errors
    end
    if l ~= '' then
      return ' ' .. l .. ' '
    else
      return ''
    end
  else
    if vim.fn.exists(':SyntasticCheck') == 0 then
      return ''
    end
    local l = vim.fn.SyntasticStatuslineFlag()
    if #l > 0 then
      return l
    else
      return ''
    end
  end
end

local function search_status() end

local function search_count() end

local function filesize()
  local size = vim.fn.getfsize(vim.fn.bufname('%'))
  if size <= 0 then
    return ''
  elseif size < 1024 then
    return size .. ' bytes '
  elseif size < 1024 * 1024 then
    return string.format('%.1f', size / 1024) .. 'k '
  elseif size < 1024 * 1024 * 1024 then
    return string.format('%.1f', size / 1024 / 1024) .. 'm '
  else
    return string.format('%.1f', size / 1024 / 1024 / 1024) .. 'g '
  end
end

local function filename()
  local name = vim.fn.fnamemodify(vim.fn.bufname('%'), ':t')
  if name == '' then
    name = 'No Name'
  end
  return "%{ &modified ? ' * ' : ' - '}" .. filesize() .. name .. ' '
end

local function fileformat()
  if vim.g.spacevim_statusline_unicode == 1 then
    vim.g._spacevim_statusline_fileformat = system.fileformat()
  else
    vim.g._spacevim_statusline_fileformat = vim.o.ff
  end
  return '%{ " " . g:_spacevim_statusline_fileformat . " '
    .. irsep
    .. ' " . (&fenc!=""?&fenc:&enc) . " "}'
end

local function major_mode()
  local alias = lang.get_alias(vim.o.filetype)
  if alias == '' then
    return ''
  else
    return ' ' .. alias .. ' '
  end
end

local function get_modes() -- same as s:modes() in vim statusline
  local m
  if vim.g.spacevim_statusline_unicode == 1 then
    m = ' ❖ '
  else
    m = ' # '
  end
  for _, mode in ipairs(loaded_modes) do
    if vim.g.spacevim_statusline_unicode == 1 then
      m = m .. modes[mode].icon .. ' '
    else
      m = m .. modes[mode].icon_asc .. ' '
    end
  end
  return m .. ' '
end

local function totallines()
  return ' %L '
end

local function percentage()
  return ' %P '
end

local function cursorpos()
  return [[%{' ' . join(map(getpos('.')[1:2], "printf('%3d', v:val)"), ':') . ' '}]]
end

local function current_time()
  return ' ' .. time.current_time() .. ' '
end

local function current_date()
  return ' ' .. time.current_date() .. ' '
end

local registed_sections = {
  winnr = winnr,
  ['syntax checking'] = syntax_checking,
  filename = filename,
  fileformat = fileformat,
  ['major mode'] = major_mode,
  ['minor mode lighters'] = get_modes,
  cursorpos = cursorpos,
  percentage = percentage,
  totallines = totallines,
  time = current_time,
  date = current_date,
  whitespace = whitespace,
  ['battery status'] = battery_status,
  ['input method'] = input_method,
  ['search status'] = search_status,
  ['search count'] = search_count,
}

local function current_tag()
  return '%{ v:lua.require("spacevim.plugin.statusline")._current_tag() }'
end

function M._current_tag()
  local tag = ''
  pcall(function()
    -- current tag should be show only after vimenter
    -- @fixme this make sure tagbar has been loaded
    -- because when first run tagbar, it needs long time.
    -- and also there no syntax highlight when first time open file.
    if
      vim.g._spacevim_after_vimenter == 1
      and vim.g.spacevim_enable_statusline_tag == 1
      and vim.g.loaded_tagbar == 1
    then
      tag = vim.fn['tagbar#currenttag']('%s ', '')
    end
  end)
  return tag
end

local function active()
  local lsec = {}
  for _, section in ipairs(vim.g.spacevim_statusline_left) do
    if registed_sections[section] then
      local rst = ''
      local ok, _ = pcall(function()
        if type(registed_sections[section]) == 'function' then
          rst = registed_sections[section]()
        elseif type(registed_sections[section]) == 'string' then
          rst = vim.fn[registed_sections[section]]()
        end
      end)
      if not ok then
        log.debug('failed to call section func:' .. section)
      end
      table.insert(lsec, rst)
    end
  end
  local rsec = {}
  for _, section in ipairs(vim.g.spacevim_statusline_right) do
    if registed_sections[section] then
      local rst = ''
      local ok, _ = pcall(function()
        if type(registed_sections[section]) == 'function' then
          rst = registed_sections[section]()
        elseif type(registed_sections[section]) == 'string' then
          rst = vim.fn[registed_sections[section]]()
        end
      end)
      if not ok then
        log.debug('failed to call section func:' .. section)
      end
      table.insert(rsec, rst)
    end
  end
  local fname = buffer_name()
  local tag = current_tag()
  local winwidth = vim.fn.winwidth(vim.fn.winnr())
  if vim.o.laststatus == 3 then
    winwidth = vim.o.columns
  end
  return statusline.build(
    lsec,
    rsec,
    lsep,
    rsep,
    fname,
    tag,
    'SpaceVim_statusline_a',
    'SpaceVim_statusline_b',
    'SpaceVim_statusline_c',
    'SpaceVim_statusline_z',
    winwidth
  )
end

local function inactive()
  local l = '%#SpaceVim_statusline_ia#'
    .. winnr(1)
    .. '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#'
    .. lsep
    .. '%#SpaceVim_statusline_b#'
  local secs = { filename(), ' ' .. vim.o.filetype, get_modes() }
  local base = 10
  for _, sec in ipairs(secs) do
    local len = statusline.len(sec)
    base = base + len
    l = l
      .. '%{ get(w:, "winwidth", 150) < '
      .. base
      .. ' ? "" : (" '
      .. statusline.eval(sec)
      .. ' '
      .. ilsep
      .. '")}'
  end
  if (vim.w.winwidth or 150) > base + 10 then
    l = l
      .. table.concat({
        '%=',
        '%{" " . get(g:, "_spacevim_statusline_fileformat", "") . " "}',
        '%{" " . (&fenc!=""?&fenc:&enc) . " "}',
        ' %P ',
      }, irsep)
  end
  return l
end

---@return string # return a simple statusline with special name
local function simple_name(name)
  return '%#SpaceVim_statusline_ia#'
    .. winnr(1)
    .. '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#'
    .. lsep
    .. '%#SpaceVim_statusline_b# '
    .. name
    .. ' %#SpaceVim_statusline_b_SpaceVim_statusline_c#'
    .. lsep
    .. '%#SpaceVim_statusline_c#'
end

local special_statusline = {
  vimfiler = function()
    return simple_name('VimFiler')
  end,
  qf = function()
    local l = ''
    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    if wininfo.quickfix == 1 and wininfo.loclist == 0 then
      local title = vim.fn.getqflist({ title = 0 }).title
      if title == ':setqflist()' then
        title = ''
      end
      l = simple_name('QuickFix') .. ' ' .. title
    elseif wininfo.loclist == 1 then
      local title = vim.fn.getloclist(vim.fn.winnr(), { title = 0 }).title
      if title == ':setloclist()' then
        title = ''
      end
      l = simple_name('Location list') .. ' ' .. title
    end
    return l
  end,
  defx = function()
    return simple_name('defx')
  end,
  ['git-status'] = function()
    return simple_name('Git status')
  end,
  startify = function()
    pcall(vim.fn['fugitive#detect'], vim.fn.getcwd())
    local st = '%#SpaceVim_statusline_ia#'
      .. winnr(1)
      .. '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#'
      .. lsep
      .. '%#SpaceVim_statusline_b# startify %#SpaceVim_statusline_b_SpaceVim_statusline_c#'
      .. lsep
    if index(vim.g.spacevim_statusline_left, 'vcs') ~= -1 and registed_sections.vcs then
      st = st .. '%#SpaceVim_statusline_c#'
      if type(registed_sections.vcs) == 'string' then
        st = st .. vim.fn[registed_sections.vcs]()
      elseif type(registed_sections.vcs) == 'function' then
        st = st .. registed_sections.vcs()
      end
      st = st .. '%#SpaceVim_statusline_c_SpaceVim_statusline_z#' .. lsep
    end
    return st
  end,
  NvimTree = function()
    return simple_name('NvimTree')
  end,
  ['neo-tree'] = function()
    return simple_name('NeoTree')
  end,
  Fuzzy = function() end, -- todo
  ['git-commit'] = function()
    return simple_name('Git commit')
  end,
  ['git-rebase'] = function()
    return simple_name('Git rebase')
  end,
  ['git-blame'] = function()
    return simple_name('Git blame')
  end,
  ['git-log'] = function()
    return simple_name('Git log')
  end,
  ['git-diff'] = function()
    return simple_name('Git diff')
  end,
  ['git-config'] = function()
    return simple_name('Git config')
  end,
  SpaceVimMessageBuffer = function()
    return simple_name('Message')
  end,
  ['gista-list'] = function()
    return simple_name('Gista')
  end,
  terminal = function() end, -- todo
  vimchat = function()

    return '%#SpaceVim_statusline_ia#' .. winnr(1) .. '%#SpaceVim_statusline_ia_SpaceVim_statusline_b#' .. lsep
          .. '%#SpaceVim_statusline_b# Chat %#SpaceVim_statusline_b_SpaceVim_statusline_c#' .. lsep
          .. '%#SpaceVim_statusline_c# '
          .. '%{chat#windows#status().protocol}' .. ' %#SpaceVim_statusline_c_SpaceVim_statusline_b#' .. lsep
          .. '%#SpaceVim_statusline_b# '
          .. '%{chat#windows#status().channel}' .. ' %#SpaceVim_statusline_b_SpaceVim_statusline_c#' .. lsep
          .. '%#SpaceVim_statusline_c# '
          .. '%{chat#windows#status().usercount}'
  end, -- todo
  calender = function()
    return simple_name('Calendar')
  end,
  zkbrowser = function()
    return simple_name('Zettelkasten Browser')
  end,
  zktagstree = function()
    return simple_name('ZkTags Tree')
  end,
  ['vader-result'] = function()
    return simple_name('Vader result')
  end,
  ['gina-status'] = function()
    return simple_name('Gina status')
  end,
  ['gina-commit'] = function()
    return simple_name('Gina commit')
  end,
  nerdtree = function()
    return simple_name('Nerdtree')
  end,
  Mundo = function()
    return simple_name('Mundo')
  end,
  MundoDiff = function()
    return simple_name('MundoDiff')
  end,
  SpaceVimLayerManager = function()
    return simple_name('LayerManager')
  end,
  SpaceVimFindArgv = function()
    return simple_name('Find')
  end,
  SpaceVimGitLogPopup = function()
    return simple_name('Git log popup')
  end,
  ['response.idris'] = function()
    return simple_name('Idris Response')
  end,
  ['markdown.lspdoc'] = function()
    return simple_name('LSP hover info')
  end,
  SpaceVimWinDiskManager = function()
    return simple_name('WinDisk')
  end,
  SpaceVimTodoManager = function()
    return simple_name('TODO manager')
  end,
  SpaceVimTasksInfo = function()
    return simple_name('Tasks manager')
  end,
  SpaceVimGitBranchManager = function()
    return simple_name('Branch manager')
  end,
  SpaceVimGitRemoteManager = function()
    return simple_name('Remote manager')
  end,
  SpaceVimPlugManager = function()
    return simple_name('PlugManager')
  end,
  SpaceVimTabsManager = function()
    return simple_name('TabsManager')
  end,
  fzf = function() end, -- todo
  denite = function() end, -- todo
  ['denite-filter'] = function()
    return '%#SpaceVim_statusline_a_bold#'
      .. ' Filter '
      .. '%#SpaceVim_statusline_a_SpaceVim_statusline_b#'
      .. lsep
  end,
  unite = function() end, -- todo
  SpaceVimFlyGrep = function() end, -- todo
  TransientState = function()
    return '%#SpaceVim_statusline_ia# Transient State %#SpaceVim_statusline_a_SpaceVim_statusline_b#'
  end,
  SpaceVimLog = function()
    return simple_name('SpaceVim Runtime Log')
  end,
  SpaceVimTomlViewer = function()
    return simple_name('Toml Json Viewer')
  end,
  vimcalc = function()
    return simple_name('VimCalc')
  end,
  HelpDescribe = function()
    return simple_name('HelpDescribe')
  end,
  SpaceVimRunner = function()
    return simple_name('Runner') .. ' %{SpaceVim#plugins#runner#status()}'
  end,
  SpaceVimREPL = function()
    return simple_name('REPL') .. ' %{SpaceVim#plugins#repl#status()}'
  end,
  VimMailClient = function() end, -- todo
  SpaceVimQuickFix = function()
    return simple_name('SpaceVimQuickFix')
  end,
  VebuggerShell = function()
    return simple_name('VebuggerShell')
  end,
  VebuggerTerminal = function()
    return simple_name('VebuggerTerminal')
  end,
}

function M.get(...)
  if special_statusline[vim.o.filetype] then
    return special_statusline[vim.o.filetype]()
  end
  if select(1, ...) then
    return active()
  else
    return inactive()
  end
end

function M.def_colors()
  local name = vim.g.colors_name or 'gruvbox'

  local t

  if #vim.g.spacevim_custom_color_palette > 0 then
    t = vim.g.spacevim_custom_color_palette
  else
    local ok = pcall(function()
      t = vim.fn['SpaceVim#mapping#guide#theme#' .. name .. '#palette']()
    end)

    if not ok then
      t = vim.fn['SpaceVim#mapping#guide#theme#gruvbox#palette']()
    end
  end
  colors_template = t
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a', {
    fg = t[1][1],
    bg = t[1][2],
    ctermfg = t[1][4],
    ctermbg = t[1][3],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a_bold', {
    bold = true,
    fg = t[1][1],
    bg = t[1][2],
    ctermfg = t[1][4],
    ctermbg = t[1][3],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_ia', {
    fg = t[1][1],
    bg = t[1][2],
    ctermfg = t[1][4],
    ctermbg = t[1][3],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_b', {
    fg = t[2][1],
    bg = t[2][2],
    ctermfg = t[2][4],
    ctermbg = t[2][3],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_c', {
    fg = t[3][1],
    bg = t[3][2],
    ctermfg = t[3][4],
    ctermbg = t[3][3],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_z', {
    fg = t[3][1],
    bg = t[4][1],
    ctermfg = t[3][3],
    ctermbg = t[4][2],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_error', {
    bold = true,
    fg = '#ffc0b9',
    bg = t[2][2],
    ctermfg = 'Black',
    ctermbg = t[2][3],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_warn', {
    bold = true,
    fg = '#fce094',
    bg = t[2][2],
    ctermfg = 'Black',
    ctermbg = t[2][3],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_info', {
    bold = true,
    fg = '#8cf8f7',
    bg = t[2][2],
    ctermfg = 'Black',
    ctermbg = t[2][3],
  })
  vim.api.nvim_set_hl(0, 'SpaceVim_statusline_hint', {
    bold = true,
    fg = '#a6dbff',
    bg = t[2][2],
    ctermfg = 'Black',
    ctermbg = t[2][3],
  })
  highlight.hi_separator('SpaceVim_statusline_a', 'SpaceVim_statusline_b')
  highlight.hi_separator('SpaceVim_statusline_a_bold', 'SpaceVim_statusline_b')
  highlight.hi_separator('SpaceVim_statusline_ia', 'SpaceVim_statusline_b')
  highlight.hi_separator('SpaceVim_statusline_b', 'SpaceVim_statusline_c')
  highlight.hi_separator('SpaceVim_statusline_b', 'SpaceVim_statusline_z')
  highlight.hi_separator('SpaceVim_statusline_c', 'SpaceVim_statusline_z')
end

function M.register_mode(mode)
  if modes[mode.key] and mode.func then
    modes[mode.key].func = mode.func
    log.debug('register major mode function:' .. mode.key)
  else
    modes[mode.key] = mode
  end
end

local function update_conf()
  log.debug('write major mode to major_mode.json')
  local conf = {}
  for key, _ in pairs(modes) do
    if index(loaded_modes, key) > -1 then
      conf[key] = true
    else
      conf[key] = false
    end
  end
  if
    vim.fn.writefile(
      { JSON.json_encode(conf) },
      vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/major_mode.json')
    ) == 0
  then
    log.debug('update major_mode.json done')
  else
    log.debug('failed to update major_mode.json')
  end
end

function M.toggle_mode(name)
  log.debug('toggle major mode:' .. name)
  local mode = modes[name]
  if not mode then
    log.debug('can not find major mode:' .. name)
    return
  end
  local done
  if mode.func then
    if type(mode.func) == 'string' then
      done = vim.fn[mode.func]()
    elseif type(mode.func) == 'function' then
      done = mode.func()
    end
  end
  local idx = index(loaded_modes, name)
  if idx ~= -1 then
    table.remove(loaded_modes, idx)
  else
    if done == 1 then
      table.insert(loaded_modes, name)
    end
  end
  vim.opt_local.statusline = M.get(1)
  if major_mode_cache then
    update_conf()
  end
end
function M.toggle_section(name)
  if
    index(vim.g.spacevim_statusline_left, name) == -1
    and index(vim.g.spacevim_statusline_right, name) == -1
    and not section_old_pos[name]
  then
    if name == 'search status' then
      local temp = vim.g.spacevim_statusline_left
      table.insert(temp, 2, name)
      vim.g.spacevim_statusline_left = temp
    else
      local temp = vim.g.spacevim_statusline_right
      table.insert(temp, name)
      vim.g.spacevim_statusline_right = temp
    end
  elseif index(vim.g.spacevim_statusline_right, name) ~= -1 then
    section_old_pos[name] = { 'r', index(vim.g.spacevim_statusline_right, name) }
    local temp = vim.g.spacevim_statusline_right
    table.remove(temp, index(temp, name))
    vim.g.spacevim_statusline_right = temp
  elseif index(vim.g.spacevim_statusline_left, name) ~= -1 then
    section_old_pos[name] = { 'l', index(vim.g.spacevim_statusline_left, name) }
    local temp = vim.g.spacevim_statusline_left
    table.remove(temp, index(temp, name))
    vim.g.spacevim_statusline_left = temp
  elseif section_old_pos[name] then
    if section_old_pos[name][1] == #'r' then
      local temp = vim.g.spacevim_statusline_right
      table.insert(temp, section_old_pos[name][2], name)
      vim.g.spacevim_statusline_right = temp
    else
      local temp = vim.g.spacevim_statusline_left
      table.insert(temp, section_old_pos[name][2], name)
      vim.g.spacevim_statusline_left = temp
    end
  end
  vim.opt_local.statusline = M.get(1)
end
function M.ctrlp_status(str)
  return statusline.build(
    { ' Ctrlp ', ' ' .. str .. ' ' },
    { ' ' .. vim.fn.getcwd() .. ' ' },
    lsep,
    rsep,
    '',
    '',
    'SpaceVim_statusline_a',
    'SpaceVim_statusline_b',
    'SpaceVim_statusline_c',
    'SpaceVim_statusline_z',
    vim.fn.winwidth(vim.fn.winnr())
  )
end
function M.config()
  if separators[vim.g.spacevim_statusline_separator] then
    lsep = separators[vim.g.spacevim_statusline_separator][1]
    rsep = separators[vim.g.spacevim_statusline_separator][2]
  end
  if i_separators[vim.g.spacevim_statusline_iseparator] then
    ilsep = i_separators[vim.g.spacevim_statusline_iseparator][1]
    irsep = i_separators[vim.g.spacevim_statusline_iseparator][2]
  end
  vim.fn['SpaceVim#mapping#space#def'](
    'nnoremap',
    { 't', 'm', 'm' },
    'call SpaceVim#layers#core#statusline#toggle_section("minor mode lighters")',
    'toggle the minor mode lighters',
    1
  )
  vim.fn['SpaceVim#mapping#space#def'](
    'nnoremap',
    { 't', 'm', 'M' },
    'call SpaceVim#layers#core#statusline#toggle_section("major mode")',
    'toggle the major mode',
    1
  )
  vim.fn['SpaceVim#mapping#space#def'](
    'nnoremap',
    { 't', 'm', 'b' },
    'call SpaceVim#layers#core#statusline#toggle_section("battery status")',
    'toggle the battery status',
    1
  )
  vim.fn['SpaceVim#mapping#space#def'](
    'nnoremap',
    { 't', 'm', 'd' },
    'call SpaceVim#layers#core#statusline#toggle_section("date")',
    'toggle the date',
    1
  )
  vim.fn['SpaceVim#mapping#space#def'](
    'nnoremap',
    { 't', 'm', 'i' },
    'call SpaceVim#layers#core#statusline#toggle_section("input method")',
    'toggle the input method',
    1
  )
  vim.fn['SpaceVim#mapping#space#def'](
    'nnoremap',
    { 't', 'm', 't' },
    'call SpaceVim#layers#core#statusline#toggle_section("time")',
    'toggle the time',
    1
  )
  vim.fn['SpaceVim#mapping#space#def'](
    'nnoremap',
    { 't', 'm', 'p' },
    'call SpaceVim#layers#core#statusline#toggle_section("cursorpos")',
    'toggle the cursor position',
    1
  )
  vim.fn['SpaceVim#mapping#space#def'](
    'nnoremap',
    { 't', 'm', 'T' },
    'if &laststatus == 2 | let &laststatus = 0 | else | let &laststatus = 2 | endif',
    'toggle the statusline itself',
    1
  )
  local function TagbarStatusline(_, _, fname, _)
    local name = ''
    if vim.fn.strwidth(fname) > vim.g.spacevim_sidebar_width - 15 then
      name = string.sub(fname, vim.g.spacevim_sidebar_width - 20) .. '..'
    else
      name = fname
    end
    return statusline.build(
      { winnr(1), ' Tagbar ', ' ' .. name .. ' ' },
      {},
      lsep,
      rsep,
      '',
      '',
      'SpaceVim_statusline_ia',
      'SpaceVim_statusline_b',
      'SpaceVim_statusline_c',
      'SpaceVim_statusline_z',
      vim.g.spacevim_sidebar_width
    )
  end
  vim.g.tagbar_status_func = TagbarStatusline
  vim.g.unite_force_overwrite_statusline = 0
  vim.g.ctrlp_status_func = {
    main = 'SpaceVim#layers#core#statusline#ctrlp',
    prog = 'SpaceVim#layers#core#statusline#ctrlp_status',
  }
  if
    vim.fn.filereadable(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/major_mode.json')) == 1
    and major_mode_cache
  then
    log.debug('load cache from major_mode.json')
    local conf = JSON.json_decode(
      vim.fn.join(
        vim.fn.readfile(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/major_mode.json'), ''),
        ''
      )
    )
    if type(conf) == 'table' then
      for k, v in pairs(conf) do
        if v == 1 or v == true then
          log.debug('cached major mode: ' .. k)
          M.toggle_mode(k)
        end
      end
    end
  end
end
function M.ctrlp(focus, byfname, _, prev, item, next, _)
  return statusline.build(
    { ' Ctrlp ', ' ' .. prev .. ' ', ' ' .. item .. ' ', ' ' .. next .. ' ' },
    { ' ' .. focus .. ' ', ' ' .. byfname .. ' ', ' ' .. vim.fn.getcwd() .. ' ' },
    lsep,
    rsep,
    '',
    '',
    'SpaceVim_statusline_a_bold',
    'SpaceVim_statusline_b',
    'SpaceVim_statusline_c',
    'SpaceVim_statusline_z',
    vim.fn.winwidth(vim.fn.winnr())
  )
end
function M.jump(i)
  pcall(function()
    vim.cmd(i .. 'wincmd w')
  end)
end

function M.mode(mode)
  local t = colors_template
  local iedit_mode = vim.w.spacevim_iedit_mode or ''
  if vim.w.spacevim_statusline_mode ~= mode then
    if mode == 'n' then
      if iedit_mode == 'n' then
        vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a', {
          bold = true,
          fg = t[9][1],
          bg = t[9][2],
          ctermfg = t[9][3],
          ctermbg = t[9][4],
        })
      elseif iedit_mode == 'i' then
        vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a', {
          bold = true,
          fg = t[8][1],
          bg = t[8][2],
          ctermfg = t[8][3],
          ctermbg = t[8][4],
        })
      else
        vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a', {
          bold = true,
          fg = t[1][1],
          bg = t[1][2],
          ctermfg = t[1][4],
          ctermbg = t[1][3],
        })
      end
    elseif mode == 'i' then
      vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a', {
        bold = true,
        fg = t[5][1],
        bg = t[5][2],
        ctermfg = t[5][3],
        ctermbg = t[5][4],
      })
    elseif mode == 'R' then
      vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a', {
        bold = true,
        fg = t[7][1],
        bg = t[7][2],
        ctermfg = t[7][3],
        ctermbg = t[7][4],
      })
    elseif
      mode == 'v'
      or mode == 'V'
      or mode == #''
      or mode == 's'
      or mode == 'S'
      or mode == #''
    then
      vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a', {
        bold = true,
        fg = t[6][1],
        bg = t[6][2],
        ctermfg = t[6][3],
        ctermbg = t[6][4],
      })
    end
    highlight.hi_separator('SpaceVim_statusline_a', 'SpaceVim_statusline_b')
    vim.w.spacevim_statusline_mode = mode
  end
  return ''
end

function M.mode_text(mode)
  local past_mode = ''
  if vim.o.paste then
    past_mode = 'Paste ' .. ilsep .. ' '
  end
  local mode_text = ''
  local iedit_mode = vim.w.spacevim_iedit_mode or ''
  if mode == 'n' then
    if iedit_mode ~= '' then
      if iedit_mode == 'n' then
        mode_text = 'IEDIT-NORMAL'
      elseif iedit_mode == 'i' then
        mode_text = 'IEDIT-INSERT'
      end
    else
      mode_text = ' NORMAL'
    end
  elseif mode == 'i' then
    mode_text = ' INSERT'
  elseif mode == 'R' then
    mode_text = 'REPLACE'
  elseif mode == 'v' then
    mode_text = ' VISUAL'
  elseif mode == 'V' then
    mode_text = ' V-LINE'
  elseif mode == '' then
    mode_text = 'V-BLOCK'
  elseif mode == 'c' then
    mode_text = 'COMMAND'
  elseif mode == 't' then
    mode_text = '   TERM'
  elseif
    mode == 'v'
    or mode == 'V'
    or mode == '^V'
    or mode == 's'
    or mode == 'S'
    or mode == '^S'
  then
    mode_text = ' VISUAL'
  end
  return past_mode .. mode_text
end
function M.set_variable(var)
  major_mode_cache = var.major_mode_cache or major_mode_cache
end
function M.check_section(name)
  for _, v in ipairs(vim.g.spacevim_statusline_right) do
    if v == name then
      return true
    end
  end
  for _, v in ipairs(vim.g.spacevim_statusline_left) do
    if v == name then
      return true
    end
  end
  return false
end

function M.denite_status(argv)
  local denite_ver ---@type number
  if vim.fn.exists('*denite#get_status_mode') == 1 then
    denite_ver = 2
  else
    denite_ver = 3
  end
  if denite_ver == 3 then
    return vim.fn['denite#get_status'](argv)
  else
    return vim.fn['denite#get_status_' .. argv]()
  end
end
function M.denite_mode()
  local t = colors_template
  local denite_ver ---@type number
  if vim.fn.exists('*denite#get_status_mode') == 1 then
    denite_ver = 2
  else
    denite_ver = 3
  end
  if denite_ver == 3 then
    return 'Denite'
  else
    local dmode = vim.fn.split(vim.fn['denite#get_status_mode']())[2]
    if vim.w.spacevim_statusline_mode ~= dmode then
      if dmode == 'NORMAL' then
        vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a_bold', {
          bold = true,
          fg = t[1][1],
          bg = t[1][2],
          ctermfg = t[1][4],
          ctermbg = t[1][3],
        })
      else
        vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a_bold', {
          bold = true,
          fg = t[5][1],
          bg = t[5][2],
          ctermfg = t[5][3],
          ctermbg = t[5][4],
        })
      end
      highlight.hi_separator('SpaceVim_statusline_a_bold', 'SpaceVim_statusline_b')
      vim.w.spacevim_statusline_mode = dmode
    end
    return dmode
  end
end
function M.unite_mode()
  local t = colors_template
  local dmode = vim.fn.mode()
  if vim.w.spacevim_statusline_mode ~= dmode then
    if dmode == 'n' then
      vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a_bold', {
        bold = true,
        fg = t[1][1],
        bg = t[1][2],
        ctermfg = t[1][4],
        ctermbg = t[1][3],
      })
    elseif dmode == 'i' then
      vim.api.nvim_set_hl(0, 'SpaceVim_statusline_a_bold', {
        bold = true,
        fg = t[5][1],
        bg = t[5][2],
        ctermfg = t[5][3],
        ctermbg = t[5][4],
      })
    end
    highlight.hi_separator('SpaceVim_statusline_a_bold', 'SpaceVim_statusline_b')
    vim.w.spacevim_statusline_mode = dmode
  end
  return dmode
end

function M.register_sections(name, func)
  if registed_sections[name] then
    log.info('statusline build-in section ' .. name .. ' has been changed!')
  end
  if type(func) ~= 'function' and type(func) ~= 'string' then
    log.warn('section' .. name .. ' need to be function or string')
    return
  end
  registed_sections[name] = func
end

function M.remove_section(name)
  local left = {}
  local right = {}
  for _, v in ipairs(vim.g.spacevim_statusline_left) do
    if v ~= name then
      table.insert(left, v)
    end
  end
  vim.g.spacevim_statusline_left = left
  for _, v in ipairs(vim.g.spacevim_statusline_right) do
    if v ~= name then
      table.insert(right, v)
    end
  end
  vim.g.spacevim_statusline_right = right
  vim.opt_local.statusline = M.get(1)
end
function M.health()

  return true

end
function M.init()
  local group = vim.api.nvim_create_augroup('spacevim_statusline', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'FileType', 'BufWritePost' }, {
    group = group,
    pattern = { '*' },
    callback = function(_)
      vim.opt_local.statusline = M.get(1)
    end,
  })
  vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    group = group,
    pattern = { '*' },
    callback = function(_)
      vim.opt_local.statusline = M.get()
    end,
  })
  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    group = group,
    pattern = { '*' },
    callback = function(_)
      M.def_colors()
    end,
  })
end

function M.rsep()
  return separators[vim.g.spacevim_statusline_separator] or separators.arrow
end

return M
