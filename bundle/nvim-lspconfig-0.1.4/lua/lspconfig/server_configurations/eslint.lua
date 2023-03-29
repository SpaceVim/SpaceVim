local util = require 'lspconfig.util'
local lsp = vim.lsp
local is_windows = vim.fn.has 'win32' == 1

local function fix_all(opts)
  opts = opts or {}

  local eslint_lsp_client = util.get_active_client_by_name(opts.bufnr, 'eslint')
  if eslint_lsp_client == nil then
    return
  end

  local request
  if opts.sync then
    request = function(bufnr, method, params)
      eslint_lsp_client.request_sync(method, params, nil, bufnr)
    end
  else
    request = function(bufnr, method, params)
      eslint_lsp_client.request(method, params, nil, bufnr)
    end
  end

  local bufnr = util.validate_bufnr(opts.bufnr or 0)
  request(0, 'workspace/executeCommand', {
    command = 'eslint.applyAllFixes',
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = lsp.util.buf_versions[bufnr],
      },
    },
  })
end

local bin_name = 'vscode-eslint-language-server'
local cmd = { bin_name, '--stdio' }

if is_windows then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local root_file = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
}

local root_with_package = util.find_package_json_ancestor(vim.fn.expand '%:p:h')

if root_with_package then
  -- only add package.json if it contains eslintConfig field
  local path_sep = is_windows and '\\' or '/'
  for line in io.lines(root_with_package .. path_sep .. 'package.json') do
    if line:find 'eslintConfig' then
      table.insert(root_file, 'package.json')
      break
    end
  end
end

return {
  default_config = {
    cmd = cmd,
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue',
      'svelte',
      'astro',
    },
    -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
    root_dir = util.root_pattern(unpack(root_file)),
    -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
    settings = {
      validate = 'on',
      packageManager = 'npm',
      useESLintClass = false,
      experimental = {
        useFlatConfig = false,
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all',
      },
      format = true,
      quiet = false,
      onIgnoredFiles = 'off',
      rulesCustomizations = {},
      run = 'onType',
      problems = {
        shortenToSingleLine = false,
      },
      -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
      -- This path is relative to the workspace folder (root dir) of the server instance.
      nodePath = '',
      -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
      workingDirectory = { mode = 'location' },
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = 'separateLine',
        },
        showDocumentation = {
          enable = true,
        },
      },
    },
    on_new_config = function(config, new_root_dir)
      -- The "workspaceFolder" is a VSCode concept. It limits how far the
      -- server will traverse the file system when locating the ESLint config
      -- file (e.g., .eslintrc).
      config.settings.workspaceFolder = {
        uri = new_root_dir,
        name = vim.fn.fnamemodify(new_root_dir, ':t'),
      }

      -- Support Yarn2 (PnP) projects
      local pnp_cjs = util.path.join(new_root_dir, '.pnp.cjs')
      local pnp_js = util.path.join(new_root_dir, '.pnp.js')
      if util.path.exists(pnp_cjs) or util.path.exists(pnp_js) then
        config.cmd = vim.list_extend({ 'yarn', 'exec' }, cmd)
      end
    end,
    handlers = {
      ['eslint/openDoc'] = function(_, result)
        if not result then
          return
        end
        local sysname = vim.loop.os_uname().sysname
        if sysname:match 'Windows' then
          os.execute(string.format('start %q', result.url))
        elseif sysname:match 'Linux' then
          os.execute(string.format('xdg-open %q', result.url))
        else
          os.execute(string.format('open %q', result.url))
        end
        return {}
      end,
      ['eslint/confirmESLintExecution'] = function(_, result)
        if not result then
          return
        end
        return 4 -- approved
      end,
      ['eslint/probeFailed'] = function()
        vim.notify('[lspconfig] ESLint probe failed.', vim.log.levels.WARN)
        return {}
      end,
      ['eslint/noLibrary'] = function()
        vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
        return {}
      end,
    },
  },
  commands = {
    EslintFixAll = {
      function()
        fix_all { sync = true, bufnr = 0 }
      end,
      description = 'Fix all eslint problems for this buffer',
    },
  },
  docs = {
    description = [[
https://github.com/hrsh7th/vscode-langservers-extracted

`vscode-eslint-language-server` is a linting engine for JavaScript / Typescript.
It can be installed via `npm`:

```sh
npm i -g vscode-langservers-extracted
```

`vscode-eslint-language-server` provides an `EslintFixAll` command that can be used to format a document on save:
```vim
autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
```

See [vscode-eslint](https://github.com/microsoft/vscode-eslint/blob/55871979d7af184bf09af491b6ea35ebd56822cf/server/src/eslintServer.ts#L216-L229) for configuration options.

Messages handled in lspconfig: `eslint/openDoc`, `eslint/confirmESLintExecution`, `eslint/probeFailed`, `eslint/noLibrary`

Additional messages you can handle: `eslint/noConfig`
]],
  },
}
