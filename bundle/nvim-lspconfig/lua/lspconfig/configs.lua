local util = require 'lspconfig/util'
local api, validate, lsp = vim.api, vim.validate, vim.lsp
local tbl_extend = vim.tbl_extend

local configs = {}

function configs.__newindex(t, config_name, config_def)
  validate {
    name = { config_name, 's' },
    default_config = { config_def.default_config, 't' },
    on_new_config = { config_def.on_new_config, 'f', true },
    on_attach = { config_def.on_attach, 'f', true },
    commands = { config_def.commands, 't', true },
  }
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

  local default_config = tbl_extend('keep', config_def.default_config, util.default_config)

  -- Force this part.
  default_config.name = config_name

  function M.setup(config)
    validate {
      cmd = { config.cmd, 't', true },
      root_dir = { config.root_dir, 'f', default_config.root_dir ~= nil },
      filetypes = { config.filetype, 't', true },
      on_new_config = { config.on_new_config, 'f', true },
      on_attach = { config.on_attach, 'f', true },
      commands = { config.commands, 't', true },
    }
    if config.commands then
      for k, v in pairs(config.commands) do
        validate {
          ['command.name'] = { k, 's' },
          ['command.fn'] = { v[1], 'f' },
        }
      end
    end

    config = tbl_extend('keep', config, default_config)

    if util.on_setup then
      pcall(util.on_setup, config)
    end

    local trigger
    if config.filetypes then
      trigger = 'FileType ' .. table.concat(config.filetypes, ',')
    else
      trigger = 'BufReadPost *'
    end
    if not (config.autostart == false) then
      api.nvim_command(
        string.format("autocmd %s unsilent lua require'lspconfig'[%q].manager.try_add()", trigger, config.name)
      )
    end

    local get_root_dir = config.root_dir

    function M.autostart()
      local root_dir = get_root_dir(api.nvim_buf_get_name(0), api.nvim_get_current_buf())
      if not root_dir then
        vim.notify(string.format('Autostart for %s failed: matching root directory not detected.', config_name))
        return
      end
      api.nvim_command(
        string.format(
          "autocmd %s unsilent lua require'lspconfig'[%q].manager.try_add_wrapper()",
          'BufReadPost ' .. root_dir .. '/*',
          config.name
        )
      )
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local buf_dir = api.nvim_buf_get_name(bufnr)
        if buf_dir:sub(1, root_dir:len()) == root_dir then
          M.manager.try_add_wrapper(bufnr)
        end
      end
    end

    -- Used by :LspInfo
    M.get_root_dir = get_root_dir
    M.filetypes = config.filetypes
    M.handlers = config.handlers
    M.cmd = config.cmd
    M._autostart = config.autostart

    -- In the case of a reload, close existing things.
    local reload = false
    if M.manager then
      for _, client in ipairs(M.manager.clients()) do
        client.stop(true)
      end
      reload = true
      M.manager = nil
    end

    local make_config = function(_root_dir)
      local new_config = vim.tbl_deep_extend('keep', vim.empty_dict(), config)
      new_config = vim.tbl_deep_extend('keep', new_config, default_config)
      new_config.capabilities = new_config.capabilities or lsp.protocol.make_client_capabilities()
      new_config.capabilities = vim.tbl_deep_extend('keep', new_config.capabilities, {
        workspace = {
          configuration = true,
        },
      })

      if config_def.on_new_config then
        pcall(config_def.on_new_config, new_config, _root_dir)
      end
      if config.on_new_config then
        pcall(config.on_new_config, new_config, _root_dir)
      end

      new_config.on_init = util.add_hook_after(new_config.on_init, function(client, _result)
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
        if not vim.tbl_isempty(new_config.settings) then
          client.workspace_did_change_configuration(new_config.settings)
        end
      end)

      -- Save the old _on_attach so that we can reference it via the BufEnter.
      new_config._on_attach = new_config.on_attach
      new_config.on_attach = vim.schedule_wrap(function(client, bufnr)
        if bufnr == api.nvim_get_current_buf() then
          M._setup_buffer(client.id, bufnr)
        else
          api.nvim_command(
            string.format(
              "autocmd BufEnter <buffer=%d> ++once lua require'lspconfig'[%q]._setup_buffer(%d,%d)",
              bufnr,
              config_name,
              client.id,
              bufnr
            )
          )
        end
      end)

      new_config.root_dir = _root_dir
      return new_config
    end

    local manager = util.server_per_root_dir_manager(function(_root_dir)
      return make_config(_root_dir)
    end)

    function manager.try_add(bufnr)
      bufnr = bufnr or api.nvim_get_current_buf()
      if vim.api.nvim_buf_get_option(bufnr, 'buftype') == 'nofile' then
        return
      end
      local root_dir = get_root_dir(api.nvim_buf_get_name(bufnr), bufnr)
      local id = manager.add(root_dir)
      if id then
        lsp.buf_attach_client(bufnr, id)
      end
    end

    function manager.try_add_wrapper(bufnr)
      local buf_filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      for _, filetype in ipairs(config.filetypes) do
        if buf_filetype == filetype then
          manager.try_add(bufnr)
          return
        end
      end
    end

    M.manager = manager
    M.make_config = make_config
    if reload and not (config.autostart == false) then
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        manager.try_add_wrapper(bufnr)
      end
    end
  end

  function M._setup_buffer(client_id, bufnr)
    local client = lsp.get_client_by_id(client_id)
    if not client then
      return
    end
    if client.config._on_attach then
      client.config._on_attach(client, bufnr)
    end
    if client.config.commands and not vim.tbl_isempty(client.config.commands) then
      M.commands = vim.tbl_deep_extend('force', M.commands, client.config.commands)
    end
    if not M.commands_created and not vim.tbl_isempty(M.commands) then
      -- Create the module commands
      util.create_module_commands(config_name, M.commands)
      M.commands_created = true
    end
  end

  M.commands_created = false
  M.commands = config_def.commands
  M.name = config_name
  M.document_config = config_def

  rawset(t, config_name, M)

  return M
end

return setmetatable({}, configs)
