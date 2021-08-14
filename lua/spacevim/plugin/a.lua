local M = {}
local sp = require('spacevim')
local cmp = require('spacevim.api').import('vim.compatible')
local sp_file = require('spacevim.api').import('file')
local sp_json = require('spacevim.api').import('date.json')
local logger = require('spacevim.logger').derive('a.vim')

local alternate_conf = {}
alternate_conf['_'] = '.project_alt.json'

local cache_path = sp_file.unify_path(sp.eval('g:spacevim_data_dir'), ':p') .. 'SpaceVim/a.json'


local project_config = {}

local function cache()

end

function M.alt(request_parse, ...)
    
end
