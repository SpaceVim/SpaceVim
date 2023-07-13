--=============================================================================
-- default.lua --- default option
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local SYSTEM = require('spacevim.api').import('system')
local logger = require('spacevim.logger')
local guifont = ''
local function set_font(font)
  vim.o.guifont = font
end

function M.options()
  logger.info('init default vim options')
  --  indent use backspace delete indent, eol use backspace delete line at
  --  begining start delete the char you just typed in if you do not use set
  --  nocompatible ,you need this
  vim.o.backspace = 'indent,eol,start'
  vim.opt.nrformats:remove({ 'octal' })
  vim.o.listchars = 'tab:→ ,eol:↵,trail:·,extends:↷,precedes:↶'
  vim.o.fillchars = 'vert:│,fold:·'
  vim.o.laststatus = 2

  vim.o.showcmd = false

  vim.o.autoindent = true

  vim.o.linebreak = true

  vim.o.wildmenu = true

  vim.o.linebreak = true

  vim.o.number = true

  vim.o.autoread = true

  vim.o.backup = true

  vim.o.undofile = true

  vim.o.undolevels = 1000

  if vim.fn.has('nvim-0.5.0') == 1 then
    vim.g.data_dir = vim.g.spacevim_data_dir .. 'SpaceVim/'
  else
    vim.g.data_dir = vim.g.spacevim_data_dir .. 'SpaceVim/old/'
  end

  vim.g.backup_dir = vim.g.data_dir .. 'backup//'
  vim.g.swap_dir = vim.g.data_dir .. 'swap//'
  vim.g.undo_dir = vim.g.data_dir .. 'undofile//'
  vim.g.conf_dir = vim.g.data_dir .. 'conf'

  if vim.fn.finddir(vim.g.data_dir) == '' then
    pcall(vim.fn.mkdir, vim.g.data_dir, 'p', '0700')
  end
  if vim.fn.finddir(vim.g.backup_dir) == '' then
    pcall(vim.fn.mkdir, vim.g.backup_dir, 'p', '0700')
  end
  if vim.fn.finddir(vim.g.swap_dir) == '' then
    pcall(vim.fn.mkdir, vim.g.swap_dir, 'p', '0700')
  end
  if vim.fn.finddir(vim.g.undo_dir) == '' then
    pcall(vim.fn.mkdir, vim.g.undo_dir, 'p', '0700')
  end
  if vim.fn.finddir(vim.g.conf_dir) == '' then
    pcall(vim.fn.mkdir, vim.g.conf_dir, 'p', '0700')
  end
  vim.o.undodir = vim.g.undo_dir
  vim.o.backupdir = vim.g.backup_dir
  vim.o.directory = vim.g.swap_dir
  vim.g.data_dir = nil
  vim.g.backup_dir = nil
  vim.g.swap_dir = nil
  vim.g.undo_dir = nil
  vim.g.conf_dir = nil

  vim.o.writebackup = false

  vim.o.matchtime = 0

  vim.o.ruler = false

  vim.o.showmatch = true

  vim.o.showmode = true

  vim.o.completeopt = 'menu,menuone,longest'

  vim.o.complete = '.,w,b,u,t'

  vim.o.pumheight = 15

  vim.o.scrolloff = 1
  vim.o.sidescrolloff = 5
  vim.opt.display = vim.opt.display + { 'lastline' }
  vim.o.incsearch = true
  vim.o.hlsearch = true
  vim.o.wildignorecase = true
  vim.o.mouse = 'nv'
  vim.o.hidden = true
  vim.o.ttimeout = true
  vim.o.ttimeoutlen = 50
  if vim.fn.has('patch-7.4.314') == 1 then
    -- don't give ins-completion-menu messages.
    vim.opt.shortmess:append('c')
  end
  vim.opt.shortmess:append('s')
  -- Do not wrap lone lines
  vim.o.wrap = false

  vim.o.foldtext = 'SpaceVim#default#Customfoldtext()'

  logger.info('options init done')
end

return M
