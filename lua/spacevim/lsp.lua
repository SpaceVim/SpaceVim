local M = {}

M.clients = {}
-- store the clients for different filetype
-- which can be called via vim.lsp.start_client()

function M.register(filetype, cmd)
  M.clients[filetype] = {
    ['cmd'] = cmd,
  }
end

function M.setup(enabled_clients, override_client_cmds) -- {{{
  local nvim_lsp = require('lspconfig')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- buf_set_keymap('n', '<space>e', '<cmd>lua require("spacevim.diagnostic").show_line_diagnostics()<CR>', opts)
    -- buf_set_keymap('n', '[d', '<cmd>lua require("spacevim.diagnostic").goto_prev()<CR>', opts)
    -- buf_set_keymap('n', ']d', '<cmd>lua require("spacevim.diagnostic").goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua require("spacevim.diagnostic").set_loclist()<CR>', opts)
    -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  for _, lsp in ipairs(enabled_clients) do
    nvim_lsp[lsp].setup({
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
    })
  end
  for client, override_cmd in pairs(override_client_cmds) do
    if type(client) == 'string' then
      nvim_lsp[client].setup({
        cmd = override_cmd,
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
      })
    end
  end
end
-- }}}

local function spliteof(data, delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(data, delimiter, from)
  while delim_from do
    table.insert(result, string.sub(data, from, delim_from - 1))
    from = delim_to + 1
    delim_from, delim_to = string.find(data, delimiter, from)
  end
  table.insert(result, string.sub(data, from))
  return result
end
--
-- if data.contents is a string and not empty
--        silent put =a:data
--        return 'markdown'
-- if data
function M.hover_callback(success, data)
  if not success then
    vim.api.nvim_command('call SpaceVim#util#echoWarn("Failed to retrieve hover information")')
    return
  end
  if type(data.contents) == 'table' then
    vim.api.nvim_command('leftabove split __lspdoc__')
    vim.api.nvim_command('set filetype=markdown.lspdoc')
    vim.api.nvim_command('setlocal nobuflisted')
    vim.api.nvim_command('setlocal buftype=nofile')
    vim.api.nvim_command('setlocal bufhidden=wipe')
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, spliteof(data.contents.value, '\n'))
  elseif type(data.contents) == 'string' and data.contents ~= '' then
    -- for k, v in pairs(data) do
    -- print(k .. " - " ..  v)
    -- kind is filetype
    -- value is contents string
    -- end
    vim.api.nvim_command('leftabove split __lspdoc__')
    vim.api.nvim_command('set filetype=markdown.lspdoc')
    vim.api.nvim_command('setlocal nobuflisted')
    vim.api.nvim_command('setlocal buftype=nofile')
    vim.api.nvim_command('setlocal bufhidden=wipe')
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, spliteof(data.contents, '\n'))
  elseif type(data.contents.language) ~= 'string' and data.contents.language ~= '' then
    vim.api.nvim_command('leftabove split __lspdoc__')
    vim.api.nvim_command('set filetype=markdown.lspdoc')
    vim.api.nvim_command('setlocal nobuflisted')
    vim.api.nvim_command('setlocal buftype=nofile')
    vim.api.nvim_command('setlocal bufhidden=wipe')
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, { '```' .. data.contents.language })
    vim.api.nvim_buf_set_lines(0, 1, -1, 0, spliteof(data.contents, '\n'))
    vim.api.nvim_buf_set_lines(0, -1, -1, 0, { '```' })
  elseif type(data.contents.kind) ~= 'string' and data.contents.kind ~= '' then
    vim.api.nvim_command('leftabove split __lspdoc__')
    vim.api.nvim_command('set filetype=' .. data.contents.kind .. '.lspdoc')
    vim.api.nvim_command('setlocal nobuflisted')
    vim.api.nvim_command('setlocal buftype=nofile')
    vim.api.nvim_command('setlocal bufhidden=wipe')
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, spliteof(data.contents, '\n'))
  else
    print('No hover information found')
  end
  -- print(type(data))
end
return M
