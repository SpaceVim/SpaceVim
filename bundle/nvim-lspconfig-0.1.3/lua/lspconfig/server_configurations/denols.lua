local util = require 'lspconfig.util'
local lsp = vim.lsp

local function buf_cache(bufnr)
  local params = {}
  params['referrer'] = { uri = vim.uri_from_bufnr(bufnr) }
  params['uris'] = {}
  lsp.buf_request(bufnr, 'deno/cache', params, function(err)
    if err then
      error(tostring(err))
    end
  end)
end

local function virtual_text_document_handler(uri, result)
  if not result then
    return nil
  end

  for client_id, res in pairs(result) do
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
    lsp.buf_attach_client(bufnr, client_id)
  end
end

local function virtual_text_document(uri)
  local params = {
    textDocument = {
      uri = uri,
    },
  }
  local result = lsp.buf_request_sync(0, 'deno/virtualTextDocument', params)
  virtual_text_document_handler(uri, result)
end

local function denols_handler(err, result, ctx)
  if not result or vim.tbl_isempty(result) then
    return nil
  end

  for _, res in pairs(result) do
    local uri = res.uri or res.targetUri
    if uri:match '^deno:' then
      virtual_text_document(uri)
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
    root_dir = util.root_pattern('deno.json', 'deno.jsonc', 'tsconfig.json', '.git'),
    init_options = {
      enable = true,
      lint = false,
      unstable = false,
    },
    handlers = {
      ['textDocument/definition'] = denols_handler,
      ['textDocument/references'] = denols_handler,
    },
  },
  commands = {
    DenolsCache = {
      function()
        buf_cache(0)
      end,
      description = 'Cache a module and all of its dependencies.',
    },
  },
  docs = {
    description = [[
https://github.com/denoland/deno

Deno's built-in language server

To approrpiately highlight codefences returned from denols, you will need to augment vim.g.markdown_fenced languages
 in your init.lua. Example:

```lua
vim.g.markdown_fenced_languages = {
  "ts=typescript"
}
```

]],
    default_config = {
      root_dir = [[root_pattern("deno.json", "deno.jsonc", "tsconfig.json", ".git")]],
    },
  },
}
