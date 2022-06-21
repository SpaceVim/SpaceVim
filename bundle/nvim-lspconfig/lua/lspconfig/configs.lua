local util = require 'lspconfig.util'
local api, validate, lsp = vim.api, vim.validate, vim.lsp
local tbl_deep_extend = vim.tbl_deep_extend

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

  local default_config = tbl_deep_extend('keep', config_def.default_config, util.default_config)

  -- Force this part.
  default_config.name = config_name

  function M.setup(config)
    validate {
      cmd = { config.cmd, 't', true },
      root_dir = { config.root_dir, 'f', true },
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

    config = tbl_deep_extend('keep', config, default_config)

    if util.on_setup then
      pcall(util.on_setup, config)
    end

    if config.autostart == true then
      local event
      local pattern
      if config.filetypes then
        event = 'FileType'
        pattern = table.concat(config.filetypes, ',')
      else
        event = 'BufReadPost'
        pattern = '*'
      end
      api.nvim_command(
        string.format(
          "autocmd %s %s unsilent lua require'lspconfig'[%q].manager.try_add()",
          event,
          pattern,
          config.name
        )
      )
    end

    local get_root_dir = config.root_dir

    function M.launch()
      local root_dir
      if get_root_dir then
        local bufnr = api.nvim_get_current_buf()
        local bufname = api.nvim_buf_get_name(bufnr)
        if not util.bufname_valid(bufname) then
          return
        end
        root_dir = get_root_dir(util.path.sanitize(bufname), bufnr)
      end

      if root_dir then
        -- Lazy-launching: attach when a buffer in this directory is opened.
        api.nvim_command(
          string.format(
            "autocmd BufReadPost %s/* unsilent lua require'lspconfig'[%q].manager.try_add_wrapper()",
            vim.fn.fnameescape(root_dir),
            config.name
          )
        )
        -- Attach for all existing buffers in this directory.
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          local bufname = api.nvim_buf_get_name(bufnr)
          if util.bufname_valid(bufname) then
            local buf_dir = util.path.sanitize(bufname)
            if buf_dir:sub(1, root_dir:len()) == root_dir then
              M.manager.try_add_wrapper(bufnr)
            end
          end
        end
      elseif config.single_file_support then
        -- This allows on_new_config to use the parent directory of the file
        -- Effectively this is the root from lspconfig's perspective, as we use
        -- this to attach additional files in the same parent folder to the same server.
        -- We just no longer send rootDirectory or workspaceFolders during initialization.
        local bufname = api.nvim_buf_get_name(0)
        if not util.bufname_valid(bufname) then
          return
        end
        local pseudo_root = util.path.dirname(util.path.sanitize(bufname))
        local client_id = M.manager.add(pseudo_root, true)
        vim.lsp.buf_attach_client(vim.api.nvim_get_current_buf(), client_id)
      end
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
      for _, client in ipairs(M.manager.clients()) do
        client.stop(true)
      end
      reload = true
      M.manager = nil
    end

    local make_config = function(root_dir)
      local new_config = tbl_deep_extend('keep', vim.empty_dict(), config)
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
          if vim.api.nvim_buf_is_valid(bufnr) then
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
        end
      end)

      new_config.root_dir = root_dir
      new_config.workspace_folders = {
        {
          uri = vim.uri_from_fname(root_dir),
          name = string.format('%s', root_dir),
        },
      }
      return new_config
    end

    local manager = util.server_per_root_dir_manager(function(root_dir)
      return make_config(root_dir)
    end)

    -- Try to attach the buffer `bufnr` to a client using this config, creating
    -- a new client if one doesn't already exist for `bufnr`.
    function manager.try_add(bufnr)
      bufnr = bufnr or api.nvim_get_current_buf()

      if vim.api.nvim_buf_get_option(bufnr, 'buftype') == 'nofile' then
        return
      end

      local id
      local root_dir

      local bufname = api.nvim_buf_get_name(bufnr)
      if not util.bufname_valid(bufname) then
        return
      end
      local buf_path = util.path.sanitize(bufname)

      if get_root_dir then
        root_dir = get_root_dir(buf_path, bufnr)
      end

      if root_dir then
        id = manager.add(root_dir, false)
      elseif config.single_file_support then
        local pseudo_root = util.path.dirname(buf_path)
        id = manager.add(pseudo_root, true)
      end

      if id then
        lsp.buf_attach_client(bufnr, id)
      end
    end

    -- Check that the buffer `bufnr` has a valid filetype according to
    -- `config.filetypes`, then do `manager.try_add(bufnr)`.
    function manager.try_add_wrapper(bufnr)
      bufnr = bufnr or api.nvim_get_current_buf()
      local buf_filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      if config.filetypes then
        for _, filetype in ipairs(config.filetypes) do
          if buf_filetype == filetype then
            manager.try_add(bufnr)
            return
          end
        end
        -- `config.filetypes = nil` means all filetypes are valid.
      else
        manager.try_add(bufnr)
      end
    end

    M.manager = manager
    M.make_config = make_config
    if reload and config.autostart ~= false then
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
