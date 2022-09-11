local util = require 'lspconfig.util'
local lsp = vim.lsp

local function buf_cache(bufnr, client)
  local params = {}
  params['referrer'] = { uri = vim.uri_from_bufnr(bufnr) }
  params['uris'] = {}
  client.request_sync('deno/cache', params)
end

local function virtual_text_document_handler(uri, res, client)
  if not res then
    return nil
  end

  local lines = vim.split(res.result, '\n')
  local bufnr = vim.uri_to_bufnr(uri)

  local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if #current_buf ~= 0 then
    return nil
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, nil, lines)
  vim.api.nvim_buf_set_option(bufnr, 'readonly', true)
  vim.api.nvim_buf_set_option(bufnr, 'modified', false)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  lsp.buf_attach_client(bufnr, client.id)
end

local function virtual_text_document(uri, client)
  local params = {
    textDocument = {
      uri = uri,
    },
  }
  local result = client.request_sync('deno/virtualTextDocument', params)
  virtual_text_document_handler(uri, result, client)
end

local function denols_handler(err, result, ctx)
  if not result or vim.tbl_isempty(result) then
    return nil
  end

  local client = vim.lsp.get_client_by_id(ctx.client_id)
  for _, res in pairs(result) do
    local uri = res.uri or res.targetUri
    if uri:match '^deno:' then
      virtual_text_document(uri, client)
      res['uri'] = uri
      res['targetUri'] = uri
    end
  end

  lsp.handlers[ctx.method](err, result, ctx)
end

return {
  default_config = {
    cmd = { 'deno', 'lsp' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root_dir = util.root_pattern('deno.json', 'deno.jsonc', '.git'),
    init_options = {
      enable = true,
      unstable = false,
    },
    handlers = {
      ['textDocument/definition'] = denols_handler,
      ['textDocument/references'] = denols_handler,
      ['workspace/executeCommand'] = function(err, result, context)
        if context.params.command == 'deno.cache' then
          buf_cache(context.bufnr, vim.lsp.get_client_by_id(context.client_id))
        else
          lsp.handlers[context.method](err, result, context)
        end
      end,
    },
  },
  commands = {
    DenolsCache = {
      function()
        local clients = vim.lsp.get_active_clients()
        for _, client in ipairs(clients) do
          if client.name == 'denols' then
            buf_cache(0, client)
            break
          end
        end
      end,
      description = 'Cache a module and all of its dependencies.',
    },
  },
  docs = {
    description = [[
https://github.com/denoland/deno

Deno's built-in language server

To appropriately highlight codefences returned from denols, you will need to augment vim.g.markdown_fenced languages
 in your init.lua. Example:

```lua
vim.g.markdown_fenced_languages = {
  "ts=typescript"
}
```

]],
    default_config = {
      root_dir = [[root_pattern("deno.json", "deno.jsonc", ".git")]],
    },
  },
}
