local shebang_prefixes = { '/usr/bin/', '/bin/', '/usr/bin/env ', '/bin/env ' }
local shebang_fts = {
  ['fish'] = 'fish',
  ['perl'] = 'perl',
  ['python'] = 'python',
  ['python2'] = 'python',
  ['python3'] = 'python',
  ['bash'] = 'sh',
  ['sh'] = 'sh',
  ['zsh'] = 'zsh',
}

local shebang = {}
for _, prefix in ipairs(shebang_prefixes) do
  for k, v in pairs(shebang_fts) do
    shebang[prefix .. k] = v
  end
end

return {
  extension = {
    ['_coffee'] = 'coffee',
    ['coffee'] = 'coffee',
    ['cljd'] = 'clojure',
    ['dart'] = 'dart',
    ['ex'] = 'elixir',
    ['exs'] = 'elixir',
    ['erb'] = 'eruby',
    ['fnl'] = 'fennel',
    ['gql'] = 'graphql',
    ['graphql'] = 'graphql',
    ['gradle'] = 'groovy',
    ['hbs'] = 'handlebars',
    ['hdbs'] = 'handlebars',
    ['janet'] = 'janet',
    ['jsx'] = 'javascriptreact',
    ['jl'] = 'julia',
    ['kt'] = 'kotlin',
    ['nix'] = 'nix',
    ['purs'] = 'purescript',
    ['rkt'] = 'racket',
    ['res'] = 'rescript',
    ['resi'] = 'rescript',
    ['tsx'] = 'typescriptreact',
    ['plist'] = 'xml',
  },
  file_name = {
    ['cakefile'] = 'coffee',
    ['.babelrc'] = 'json',
    ['.eslintrc'] = 'json',
    ['.firebaserc'] = 'json',
    ['.prettierrc'] = 'json',
  },
  shebang = shebang
}
