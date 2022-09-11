--=============================================================================
-- default.lua --- default option
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}

function M.options()

    if vim.fn.has('gui_running') == 1 then
        vim.opt.guioptions:remove(
        {
            'm', -- hide menu bar
            'T', -- hide toolbar
            'L', -- hide left-hand scrollbar
            'r', -- hide right-hand scrollbar
            'b', -- hide bottom scrollbar
            'e', -- hide tab
        }
        )
    end

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
        vim.fn.mkdir(vim.g.data_dir, 'p', 0700)
    end
    if vim.fn.finddir(vim.g.backup_dir) == '' then
        vim.fn.mkdir(vim.g.backup_dir, 'p', 0700)
    end
    if vim.fn.finddir(vim.g.swap_dir) == '' then
        vim.fn.mkdir(vim.g.swap_dir, 'p', 0700)
    end
    if vim.fn.finddir(vim.g.undo_dir) == '' then
        vim.fn.mkdir(vim.g.undo_dir, 'p', 0700)
    end
    if vim.fn.finddir(vim.g.conf_dir) == '' then
        vim.fn.mkdir(vim.g.conf_dir, 'p', 0700)
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

    vim.o.ruler = true

    vim.o.showmatch = true

    vim.o.showmode = true


    vim.o.completeopt = {'menu', 'menuone', 'longest'}

    vim.o.complete = {'.', 'w', 'b', 'u', 't'}

    vim.o.pumheight = 15

    vim.o.scrolloff = 1
    vim.o.sidescrolloff = 5
    vim.o.display = vim.o.display + {'lastline'}
    vim.o.incsearch = true
    vim.o.hlsearch = true
    vim.o.wildignorecase = true
    vim.o.mouse = 'nv'
    vim.o.hidden = true
    vim.o.ttimeout = true
    vim.o.ttimeoutlen = 50
    if vim.fn.has('patch-7.4.314') == 1 then
        -- don't give ins-completion-menu messages.
        vim.o.shortmess:append({'c'})
    end
        vim.o.shortmess:append({'s'})
    -- Do not wrap lone lines
    vim.o.wrap = false

    vim.o.foldtext = 'SpaceVim#default#Customfoldtext()'


end

return M
