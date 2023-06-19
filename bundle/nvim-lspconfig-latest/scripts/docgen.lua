require 'lspconfig'
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
local inspect = vim.inspect
local uv = vim.loop
local fn = vim.fn
local tbl_flatten = vim.tbl_flatten

local function template(s, params)
  return (s:gsub('{{([^{}]+)}}', params))
end

local function map_list(t, func)
  local res = {}
  for i, v in ipairs(t) do
    local x = func(v, i)
    if x ~= nil then
      table.insert(res, x)
    end
  end
  return res
end

local function indent(n, s)
  local prefix
  if type(n) == 'number' then
    if n <= 0 then
      return s
    end
    prefix = string.rep(' ', n)
  else
    assert(type(n) == 'string', 'n must be number or string')
    prefix = n
  end
  local lines = vim.split(s, '\n', true)
  for i, line in ipairs(lines) do
    lines[i] = prefix .. line
  end
  return table.concat(lines, '\n')
end

local function make_parts(fns)
  return tbl_flatten(map_list(fns, function(v)
    if type(v) == 'function' then
      v = v()
    end
    return { v }
  end))
end

local function make_section(indentlvl, sep, parts)
  return indent(indentlvl, table.concat(make_parts(parts), sep))
end

local function readfile(path)
  assert(util.path.is_file(path))
  return io.open(path):read '*a'
end

local function sorted_map_table(t, func)
  local keys = vim.tbl_keys(t)
  table.sort(keys)
  return map_list(keys, function(k)
    return func(k, t[k])
  end)
end

local lsp_section_template = [[
## {{template_name}}

{{preamble}}

**Snippet to enable the language server:**
```lua
require'lspconfig'.{{template_name}}.setup{}
```
{{commands}}

**Default values:**
{{default_values}}

]]

local function require_all_configs()
  -- Make sure username doesn't leak into the generated document
  local old_home = vim.env.HOME
  local old_cache_home = vim.env.XDG_CACHE_HOME
  vim.env.HOME = '/home/user'
  vim.env.XDG_CACHE_HOME = '/home/user/.cache'

  -- Configs are lazy-loaded, tickle them to populate the `configs` singleton.
  for _, v in ipairs(vim.fn.glob('lua/lspconfig/server_configurations/*.lua', 1, 1)) do
    local module_name = v:gsub('.*/', ''):gsub('%.lua$', '')
    configs[module_name] = require('lspconfig.server_configurations.' .. module_name)
  end

  -- Reset the environment variables
  vim.env.HOME = old_home
  vim.env.XDG_CACHE_HOME = old_cache_home
end

local function make_lsp_sections()
  return make_section(
    0,
    '\n',
    sorted_map_table(configs, function(template_name, template_object)
      local template_def = template_object.document_config
      local docs = template_def.docs

      local params = {
        template_name = template_name,
        preamble = '',
        commands = '',
        default_values = '',
      }

      params.commands = make_section(0, '\n\n', {
        function()
          if not template_def.commands or #vim.tbl_keys(template_def.commands) == 0 then
            return
          end
          return '**Commands:**\n'
            .. make_section(0, '\n', {
              sorted_map_table(template_def.commands, function(name, def)
                if def.description then
                  return string.format('- %s: %s', name, def.description)
                end
                return string.format('- %s', name)
              end),
            })
        end,
      })

      params.default_values = make_section(2, '\n\n', {
        function()
          if not template_def.default_config then
            return
          end
          return make_section(0, '\n', {
            sorted_map_table(template_def.default_config, function(k, v)
              local description = ((docs or {}).default_config or {})[k]
              if description and type(description) ~= 'string' then
                description = inspect(description)
              elseif not description and type(v) == 'function' then
                description = 'see source file'
              end
              return string.format('- `%s` : \n```lua\n%s\n```', k, description or inspect(v))
            end),
          })
        end,
      })

      if docs then
        local tempdir = os.getenv 'DOCGEN_TEMPDIR' or uv.fs_mkdtemp '/tmp/nvim-lsp.XXXXXX'
        local preamble_parts = make_parts {
          function()
            if docs.description and #docs.description > 0 then
              return docs.description
            end
          end,
          function()
            local package_json_name = util.path.join(tempdir, template_name .. '.package.json')
            if docs.package_json then
              if not util.path.is_file(package_json_name) then
                os.execute(string.format('curl -v -L -o %q %q', package_json_name, docs.package_json))
              end
              if not util.path.is_file(package_json_name) then
                print(string.format('Failed to download package.json for %q at %q', template_name, docs.package_json))
                os.exit(1)
                return
              end
              local data = vim.json.decode(readfile(package_json_name))
              -- The entire autogenerated section.
              return make_section(0, '\n', {
                -- The default settings section
                function()
                  local default_settings = (data.contributes or {}).configuration
                  if not default_settings.properties then
                    return
                  end
                  -- The outer section.
                  return make_section(0, '\n', {
                    'This server accepts configuration via the `settings` key.',
                    '<details><summary>Available settings:</summary>',
                    '',
                    -- The list of properties.
                    make_section(
                      0,
                      '\n\n',
                      sorted_map_table(default_settings.properties, function(k, v)
                        local function tick(s)
                          return string.format('`%s`', s)
                        end
                        local function bold(s)
                          return string.format('**%s**', s)
                        end

                        -- https://github.github.com/gfm/#backslash-escapes
                        local function escape_markdown_punctuations(str)
                          local pattern =
                            '\\(\\*\\|\\.\\|?\\|!\\|"\\|#\\|\\$\\|%\\|\'\\|(\\|)\\|,\\|-\\|\\/\\|:\\|;\\|<\\|=\\|>\\|@\\|\\[\\|\\\\\\|\\]\\|\\^\\|_\\|`\\|{\\|\\\\|\\|}\\)'
                          return fn.substitute(str, pattern, '\\\\\\0', 'g')
                        end

                        -- local function pre(s) return string.format("<pre>%s</pre>", s) end
                        -- local function code(s) return string.format("<code>%s</code>", s) end
                        if not (type(v) == 'table') then
                          return
                        end
                        return make_section(0, '\n', {
                          '- ' .. make_section(0, ': ', {
                            bold(tick(k)),
                            function()
                              if v.enum then
                                return tick('enum ' .. inspect(v.enum))
                              end
                              if v.type then
                                return tick(table.concat(tbl_flatten { v.type }, '|'))
                              end
                            end,
                          }),
                          '',
                          make_section(2, '\n\n', {
                            { v.default and 'Default: ' .. tick(inspect(v.default, { newline = '', indent = '' })) },
                            { v.items and 'Array items: ' .. tick(inspect(v.items, { newline = '', indent = '' })) },
                            { escape_markdown_punctuations(v.description) },
                          }),
                        })
                      end)
                    ),
                    '',
                    '</details>',
                  })
                end,
              })
            end
          end,
        }
        if not os.getenv 'DOCGEN_TEMPDIR' then
          os.execute('rm -rf ' .. tempdir)
        end
        -- Insert a newline after the preamble if it exists.
        if #preamble_parts > 0 then
          table.insert(preamble_parts, '')
        end
        params.preamble = table.concat(preamble_parts, '\n')
      end

      return template(lsp_section_template, params)
    end)
  )
end

local function make_implemented_servers_list()
  return make_section(
    0,
    '\n',
    sorted_map_table(configs, function(k)
      return template('- [{{server}}](#{{server}})', { server = k })
    end)
  )
end

local function generate_readme(template_file, params)
  vim.validate {
    lsp_server_details = { params.lsp_server_details, 's' },
    implemented_servers_list = { params.implemented_servers_list, 's' },
  }
  local input_template = readfile(template_file)
  local readme_data = template(input_template, params)

  local writer = io.open('doc/server_configurations.md', 'w')
  writer:write(readme_data)
  writer:close()
  uv.fs_copyfile('doc/server_configurations.md', 'doc/server_configurations.txt')
end

require_all_configs()
generate_readme('scripts/README_template.md', {
  implemented_servers_list = make_implemented_servers_list(),
  lsp_server_details = make_lsp_sections(),
})
