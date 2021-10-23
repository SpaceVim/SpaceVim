local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local lsp = vim.lsp

local server_name = 'denols'

local function deno_uri_to_uri(uri)
  -- denols returns deno:/https/deno.land/std%400.85.0/http/server.ts
  -- nvim-lsp only handles deno://
  if string.sub(uri, 1, 6) == 'deno:/' and string.sub(uri, 7, 7) ~= '/' then
    return string.gsub(uri, '^deno:/', 'deno://', 1)
  end
  return uri
end

local function uri_to_deno_uri(uri)
  -- denols use deno:/ and nvim-lsp use deno:// as buffer_uri.
  -- When buffer_uri is deno://, change uri to deno:/.
  if string.sub(uri, 1, 7) == 'deno://' and string.sub(uri, 8, 8) ~= '/' then
    return string.gsub(uri, '^deno://', 'deno:/', 1)
  end
  return uri
end

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
    local bufnr = vim.uri_to_bufnr(deno_uri_to_uri(uri))

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

local function denols_handler(err, method, result)
  if not result or vim.tbl_isempty(result) then
    return nil
  end

  for _, res in pairs(result) do
    local uri = res.uri or res.targetUri
    if string.sub(uri, 1, 6) == 'deno:/' then
      virtual_text_document(uri)
      res['uri'] = deno_uri_to_uri(uri)
      res['targetUri'] = deno_uri_to_uri(uri)
    end
  end

  lsp.handlers[method](err, method, result)
end

local function denols_definition()
  local params = lsp.util.make_position_params()
  params.textDocument.uri = uri_to_deno_uri(params.textDocument.uri)
  lsp.buf_request(0, 'textDocument/definition', params)
end

local function denols_references(context)
  vim.validate { context = { context, 't', true } }
  local params = lsp.util.make_position_params()
  params.context = context or {
    includeDeclaration = true,
  }
  params[vim.type_idx] = vim.types.dictionary
  params.textDocument.uri = uri_to_deno_uri(params.textDocument.uri)
  lsp.buf_request(0, 'textDocument/references', params)
end

configs[server_name] = {
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
    root_dir = util.root_pattern('package.json', 'tsconfig.json', '.git'),
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
    DenolsDefinition = {
      denols_definition,
      description = 'Jump to definition. This handle deno:/ schema in deno:// buffer.',
    },
    DenolsReferences = {
      function()
        denols_references { includeDeclaration = true }
      end,
      description = 'List references. This handle deno:/ schema in deno:// buffer.',
    },
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
]],
    default_config = {
      root_dir = [[root_pattern("package.json", "tsconfig.json", ".git")]],
    },
  },
}

configs.denols.definition = denols_definition
configs.denols.references = denols_references
configs.denols.buf_cache = buf_cache
configs.denols.virtual_text_document = virtual_text_document
-- vim:et ts=2 sw=2
