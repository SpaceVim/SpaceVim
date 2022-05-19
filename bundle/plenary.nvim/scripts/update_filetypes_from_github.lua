local FORCE_DOWNLOAD = false

local log = require('plenary.log')


-- Defines all Languages known to GitHub.
--
-- fs_name               - Optional field. Only necessary as a replacement for the sample directory name if the
--                         language name is not a valid filename under the Windows filesystem (e.g., if it
--                         contains an asterisk).
-- type                  - Either data, programming, markup, prose, or nil
-- aliases               - An Array of additional aliases (implicitly includes name.downcase)
-- ace_mode              - A String name of the Ace Mode used for highlighting whenever
--                         a file is edited. This must match one of the filenames in http://git.io/3XO_Cg.
--                         Use "text" if a mode does not exist.
-- codemirror_mode       - A String name of the CodeMirror Mode used for highlighting whenever a file is edited.
--                         This must match a mode from https://git.io/vi9Fx
-- codemirror_mime_type  - A String name of the file mime type used for highlighting whenever a file is edited.
--                         This should match the `mime` associated with the mode from https://git.io/f4SoQ
-- wrap                  - Boolean wrap to enable line wrapping (default: false)
-- extensions            - An Array of associated extensions (the first one is
--                         considered the primary extension, the others should be
--                         listed alphabetically)
-- filenames             - An Array of filenames commonly associated with the language
-- interpreters          - An Array of associated interpreters
-- searchable            - Boolean flag to enable searching (defaults to true)
-- language_id           - Integer used as a language-name-independent indexed field so that we can rename
--                         languages in Linguist without reindexing all the code on GitHub. Must not be
--                         changed for existing languages without the explicit permission of GitHub staff.
-- color                 - CSS hex color to represent the language. Only used if type is "programming" or "markup".
-- tm_scope              - The TextMate scope that represents this programming
--                         language. This should match one of the scopes listed in
--                         the grammars.yml file. Use "none" if there is no grammar
--                         for this language.
-- group                 - Name of the parent language. Languages in a group are counted
--                         in the statistics as the parent language.

local lyaml = require('lyaml')

local Path = require('plenary.path')
local curl = require('plenary.curl')

local write_file = function(path, string)
  local fd = assert(vim.loop.fs_open(path, "w", 438))
  assert(vim.loop.fs_write(fd, string, 0))
  assert(vim.loop.fs_close(fd))
end

if FORCE_DOWNLOAD or not Path:new("build/languages.yml"):exists() then
  local languages_yml = curl.get(
    'https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml'
  ).body

  write_file("build/languages.yml", languages_yml)
else
  print("Using already downloaded file!")
end

local prio = {
  no_match    = -1,
  scope       = 1,
  alias       = 2,
  exact_match = 3,
}

local find_filetype = function(name, linguist_info, filetype_set)
  name = string.lower(name)

  local filetype, priority = nil, -1
  if filetype_set[name] then
    filetype, priority = name, prio.exact_match
  end

  if not filetype then
    if linguist_info.aliases then
      for _, ft in ipairs(linguist_info.aliases) do
        ft = string.lower(ft)
        if filetype_set[ft] then
          filetype, priority = ft, prio.alias

          break
        end
      end
    end
  end

  if not filetype then
    if linguist_info.tm_scope then
      local tm_scope_split = vim.split(linguist_info.tm_scope, ".", true)
      local tm_scope = tm_scope_split[#tm_scope_split]

      if filetype_set[tm_scope] then
        filetype, priority = tm_scope, prio.scope
      end
    end
  end

  return filetype, priority
end

local overeager_filetypes = {
  xml = true,
}


local parse_file = function()
  local yml_string = Path:new("build/languages.yml"):read()
  local yml_table = lyaml.load(yml_string)

  local output = {
    extension = {},
    file_name = {}
  }
  local intervention = {}

  local filetype_completions = vim.fn.getcompletion('', 'filetype')

  local filetype_set = {}
  for _, completed_ft in ipairs(filetype_completions) do
    filetype_set[completed_ft] = true
  end

  local add_extension = function(ext, filetype, priority)
    -- If we have a better match, don't do it.
    if output.extension[ext] then
      if overeager_filetypes[output.extension[ext].filetype] then
        log.debug("Overager:", output.extension[ext].filetype)
      elseif output.extension[ext].priority > priority then
        log.debug(
          "Skipping:", ext, filetype, priority,
          "due to existing:", output.extension[ext].priority, output.extension[ext].filetype
        )

        return
      else
        log.debug(
          "Override:", ext, filetype, priority,
          "due to existing:", output.extension[ext].priority, output.extension[ext].filetype
        )
      end
    end

    output.extension[ext] = {
      filetype = filetype,
      priority = priority,
    }
  end

  local add_filename = function(filename, filetype)
    output.file_name[filename:lower()] = {
      filetype = filetype:lower()
    }
  end

  for k, v in pairs(yml_table) do
    local filetype, priority = find_filetype(k, v, filetype_set)

    if filetype then
      if v.extensions then
        for _, ext in ipairs(v.extensions) do
          if ext:sub(1, 1) == '.' then
            ext = ext:sub(2, #ext)
          end

          add_extension(ext, filetype, priority)
        end
      end

      -- For stuff like 'Makefile'
      -- This should go in a separate table
      if v.filenames then
        for _, fname in ipairs(v.filenames) do
          add_filename(fname, filetype)
        end
      end
    else
      table.insert(intervention, v)
    end
  end

  -- P(intervention)

  local result = 'return {\n'

  result = result .. "  extension = {\n"
  for k, v in pairs(output.extension) do
    result = result .. string.format("    ['%s'] = [[%s]],\n", k, v.filetype)
  end
  result = result .. '  },\n'

  result = result .. "  file_name = {\n"
  for k, v in pairs(output.file_name) do
    result = result .. string.format("    ['%s'] = [[%s]],\n", k, v.filetype)
  end
  result = result .. '  },\n'

  result = result .. '}\n'

  return result
end

print("Parsing File...")
local res = parse_file()
print("...Done")

print("Writing File...")
write_file('./data/plenary/filetypes/base.lua', res)
print("...Done!")
