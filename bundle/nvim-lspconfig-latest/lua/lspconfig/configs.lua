local util = require 'lspconfig.util'
local async = require 'lspconfig.async'
local api, validate, lsp, uv, fn = vim.api, vim.validate, vim.lsp, vim.loop, vim.fn
local tbl_deep_extend = vim.tbl_deep_extend

local configs = {}

--- @class lspconfig.Config : vim.lsp.ClientConfig
--- @field enabled? boolean
--- @field single_file_support? boolean
--- @field filetypes? string[]
--- @field filetype? string
--- @field on_new_config? function
--- @field autostart? boolean
--- @field package _on_attach? fun(client: vim.lsp.Client, bufnr: integer)

--- @param cmd any
local function sanitize_cmd(cmd)
  if cmd and type(cmd) == 'table' and not vim.tbl_isempty(cmd) then
    local original = cmd[1]
    cmd[1] = vim.fn.exepath(cmd[1])
    if #cmd[1] == 0 then
      cmd[1] = original
    end
  end
end

function configs.__newindex(t, config_name, config_def)
  validate {
    name = { config_name, 's' },
    default_config = { config_def.default_config, 't' },
    on_new_config = { config_def.on_new_config, 'f', true },
    on_attach = { config_def.on_attach, 'f', true },
    commands = { config_def.commands, 't', true },
  }

  if config_def.default_config.deprecate then
    vim.deprecate(
      config_name,
      config_def.default_config.deprecate.to,
      config_def.default_config.deprecate.version,
      'lspconfig',
      false
    )
  end

  if config_def.commands then
    for k, v in pairs(config_def.commands) do
      validate {
        ['command.name'] = { k, 's' },
        ['command.fn'] = { v[1], 'f' },
      }
    end
  else
    config_def.commands = {}
  end

  local M = {}

  local default_config = tbl_deep_extend('keep', config_def.default_config, util.default_config)

  -- Force this part.
  default_config.name = config_name

  --- @param user_config lspconfig.Config
  function M.setup(user_config)
    local lsp_group = api.nvim_create_augroup('lspconfig', { clear = false })

    validate {
      cmd = {
        user_config.cmd,
        { 'f', 't' },
        true,
      },
      root_dir = { user_config.root_dir, 'f', true },
      filetypes = { user_config.filetype, 't', true },
      on_new_config = { user_config.on_new_config, 'f', true },
      on_attach = { user_config.on_attach, 'f', true },
      commands = { user_config.commands, 't', true },
    }
    if user_config.commands then
      for k, v in pairs(user_config.commands) do
        validate {
          ['command.name'] = { k, 's' },
          ['command.fn'] = { v[1], 'f' },
        }
      end
    end

    local config = tbl_deep_extend('keep', user_config, default_config)

    sanitize_cmd(config.cmd)

    if util.on_setup then
      pcall(util.on_setup, config, user_config)
    end

    if config.autostart == true then
      local event_conf = config.filetypes and { event = 'FileType', pattern = config.filetypes }
        or { event = 'BufReadPost' }
      api.nvim_create_autocmd(event_conf.event, {
        pattern = event_conf.pattern or '*',
        callback = function(opt)
          M.manager:try_add(opt.buf)
        end,
        group = lsp_group,
        desc = string.format(
          'Checks whether server %s should start a new instance or attach to an existing one.',
          config.name
        ),
      })
    end

    local get_root_dir = config.root_dir

    function M.launch(bufnr)
      bufnr = bufnr or api.nvim_get_current_buf()
      if not api.nvim_buf_is_valid(bufnr) then
        return
      end
      local bufname = api.nvim_buf_get_name(bufnr)
      if (#bufname == 0 and not config.single_file_support) or (#bufname ~= 0 and not util.bufname_valid(bufname)) then
        return
      end

      local pwd = uv.cwd()

      async.run(function()
        local root_dir
        if get_root_dir then
          root_dir = get_root_dir(util.path.sanitize(bufname), bufnr)
          async.reenter()
          if not api.nvim_buf_is_valid(bufnr) then
            return
          end
        end

        if root_dir then
          api.nvim_create_autocmd('BufReadPost', {
            pattern = fn.fnameescape(root_dir) .. '/*',
            callback = function(arg)
              if #M.manager:clients() == 0 then
                return true
              end
              M.manager:try_add_wrapper(arg.buf, root_dir)
            end,
            group = lsp_group,
            desc = string.format(
              'Checks whether server %s should attach to a newly opened buffer inside workspace %q.',
              config.name,
              root_dir
            ),
          })

          for _, buf in ipairs(api.nvim_list_bufs()) do
            local buf_name = api.nvim_buf_get_name(buf)
            if util.bufname_valid(buf_name) then
              local buf_dir = util.path.sanitize(buf_name)
              if buf_dir:sub(1, root_dir:len()) == root_dir then
                M.manager:try_add_wrapper(buf, root_dir)
              end
            end
          end
        elseif config.single_file_support then
          -- This allows on_new_config to use the parent directory of the file
          -- Effectively this is the root from lspconfig's perspective, as we use
          -- this to attach additional files in the same parent folder to the same server.
          -- We just no longer send rootDirectory or workspaceFolders during initialization.
          if not api.nvim_buf_is_valid(bufnr) or (#bufname ~= 0 and not util.bufname_valid(bufname)) then
            return
          end
          local pseudo_root = #bufname == 0 and pwd or util.path.dirname(util.path.sanitize(bufname))
          M.manager:add(pseudo_root, true, bufnr)
        end
      end)
    end

    -- Used by :LspInfo
    M.get_root_dir = get_root_dir
    M.filetypes = config.filetypes
    M.handlers = config.handlers
    M.cmd = config.cmd
    M.autostart = config.autostart

    -- In the case of a reload, close existing things.
    local reload = false
    if M.manager then
      for _, client in ipairs(M.manager:clients()) do
        client.stop(true)
      end
      reload = true
      M.manager = nil
    end

    local make_config = function(root_dir)
      local new_config = tbl_deep_extend('keep', vim.empty_dict(), config) --[[@as lspconfig.Config]]
      new_config.capabilities = tbl_deep_extend('keep', new_config.capabilities, {
        workspace = {
          configuration = true,
        },
      })

      if config_def.on_new_config then
        pcall(config_def.on_new_config, new_config, root_dir)
      end
      if config.on_new_config then
        pcall(config.on_new_config, new_config, root_dir)
      end

      new_config.on_init = util.add_hook_after(new_config.on_init, function(client, result)
        -- Handle offset encoding by default
        if result.offsetEncoding then
          client.offset_encoding = result.offsetEncoding
        end

        -- Send `settings` to server via workspace/didChangeConfiguration
        function client.workspace_did_change_configuration(settings)
          if not settings then
            return
          end
          if vim.tbl_isempty(settings) then
            settings = { [vim.type_idx] = vim.types.dictionary }
          end
          return client.notify('workspace/didChangeConfiguration', {
            settings = settings,
          })
        end
      end)

      -- Save the old _on_attach so that we can reference it via the BufEnter.
      new_config._on_attach = new_config.on_attach
      new_config.on_attach = function(client, bufnr)
        if bufnr == api.nvim_get_current_buf() then
          M._setup_buffer(client.id, bufnr)
        else
          if api.nvim_buf_is_valid(bufnr) then
            api.nvim_create_autocmd('BufEnter', {
              callback = function()
                M._setup_buffer(client.id, bufnr)
              end,
              group = lsp_group,
              buffer = bufnr,
              once = true,
              desc = 'Reattaches the server with the updated configurations if changed.',
            })
          end
        end
      end

      new_config.root_dir = root_dir
      new_config.workspace_folders = {
        {
          uri = vim.uri_from_fname(root_dir),
          name = string.format('%s', root_dir),
        },
      }
      return new_config
    end

    local manager = require('lspconfig.manager').new(config, make_config)

    M.manager = manager
    M.make_config = make_config
    if reload and config.autostart ~= false then
      for _, bufnr in ipairs(api.nvim_list_bufs()) do
        manager:try_add_wrapper(bufnr)
      end
    end
  end

  function M._setup_buffer(client_id, bufnr)
    local client = lsp.get_client_by_id(client_id)
    if not client then
      return
    end
    local config = client.config --[[@as lspconfig.Config]]
    if config._on_attach then
      config._on_attach(client, bufnr)
    end
    if client.config.commands and not vim.tbl_isempty(client.config.commands) then
      M.commands = vim.tbl_deep_extend('force', M.commands, client.config.commands)
    end
    if not M.commands_created and not vim.tbl_isempty(M.commands) then
      util.create_module_commands(config_name, M.commands)
    end
  end

  M.commands = config_def.commands
  M.name = config_name
  M.document_config = config_def

  rawset(t, config_name, M)
end

return setmetatable({}, configs)
