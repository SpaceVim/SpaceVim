--=============================================================================
-- layer.lua --- spacevim layer module
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}
local sp = require('spacevim')
local spsys = require('spacevim.api').import('system')

-- local mt = {
-- __newindex = function(layer, layer_name, layer_obj)
-- rawset(layer, layer_name, layer_obj)
-- end,
-- __index = function(layer, layer_name)
-- if vim.g ~= nil then
-- return vim.g['spacevim_' .. key] or nil
-- else
-- return sp.eval('get(g:, "spacevim_' .. key .. '", v:null)')
-- end
-- end
-- }
-- setmetatable(M, mt)

function M.isLoaded(layer)
    return sp.call('SpaceVim#layers#isLoaded', layer) == 1
end

local function find_layers()
    local layers = sp.fn.globpath(sp.vim_options.runtimepath, 'autoload/SpaceVim/layers/**/*.vim', 0, 1)
    local pattern = '/autoload/SpaceVim/layers/'
    local rst = {}
    for _, layer in pairs(layers) do
        local name = layer:gsub('.+SpaceVim[\\/]layers[\\/]', ''):gsub('.vim$', ''):gsub('[\\/]', '/')
        local status = ''
        local url = ''
        local website = ''
        if name == 'lsp' then
            url = 'language-server-protocol'
        else
            url = name
        end
        if sp.fn.filereadable(sp.fn.expand('~/.SpaceVim/docs/layers/' .. url .. '.md')) == 1 then
            website = 'https://spacevim.org/layers/' .. url .. '/'
        else
            website = 'no exists'
        end
        name = sp.fn.substitute(name, '/', '#','g')
        if M.isLoaded(name) then
            status = 'loaded'
        else
            status = 'not loaded'
        end
        if status == 'loaded' then
            table.insert(rst, '+ ' .. name .. ':' .. sp.fn['repeat'](' ', 25 - sp.fn.len(name)) .. status .. sp.fn['repeat'](' ', 10) .. website)
        else
            table.insert(rst, '- ' .. name .. ':' .. sp.fn['repeat'](' ', 21 - sp.fn.len(name)) .. status .. sp.fn['repeat'](' ', 10) .. website)
        end
    end
    return rst
end

local function list_layers()
    vim.cmd('tabnew SpaceVimLayers')
    vim.cmd('nnoremap <buffer> q :q<cr>')
    vim.cmd('setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell')
    vim.cmd('setf SpaceVimLayerManager')
    vim.cmd('nnoremap <silent> <buffer> q :bd<CR>')
    local info = {'SpaceVim layers:', ''}
    for k,v in pairs(find_layers()) do table.insert(info, v) end
    sp.fn.setline(1,info)
    vim.cmd('setl nomodifiable')
end


function M.load(layer, ...)
    if layer == '-l' then
        list_layers()
        return
    end
end


return M
