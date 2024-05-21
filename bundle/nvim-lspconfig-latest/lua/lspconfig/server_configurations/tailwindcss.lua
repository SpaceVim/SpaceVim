local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'tailwindcss-language-server', '--stdio' },
    -- filetypes copied and adjusted from tailwindcss-intellisense
    filetypes = {
      -- html
      'aspnetcorerazor',
      'astro',
      'astro-markdown',
      'blade',
      'clojure',
      'django-html',
      'htmldjango',
      'edge',
      'eelixir', -- vim ft
      'elixir',
      'ejs',
      'erb',
      'eruby', -- vim ft
      'gohtml',
      'gohtmltmpl',
      'haml',
      'handlebars',
      'hbs',
      'html',
      -- 'HTML (Eex)',
      -- 'HTML (EEx)',
      'html-eex',
      'heex',
      'jade',
      'leaf',
      'liquid',
      'markdown',
      'mdx',
      'mustache',
      'njk',
      'nunjucks',
      'php',
      'razor',
      'slim',
      'twig',
      -- css
      'css',
      'less',
      'postcss',
      'sass',
      'scss',
      'stylus',
      'sugarss',
      -- js
      'javascript',
      'javascriptreact',
      'reason',
      'rescript',
      'typescript',
      'typescriptreact',
      -- mixed
      'vue',
      'svelte',
      'templ',
    },
    init_options = {
      userLanguages = {
        eelixir = 'html-eex',
        eruby = 'erb',
        templ = 'html',
      },
    },
    settings = {
      tailwindCSS = {
        validate = true,
        lint = {
          cssConflict = 'warning',
          invalidApply = 'error',
          invalidScreen = 'error',
          invalidVariant = 'error',
          invalidConfigPath = 'error',
          invalidTailwindDirective = 'error',
          recommendedVariantOrder = 'warning',
        },
        classAttributes = {
          'class',
          'className',
          'class:list',
          'classList',
          'ngClass',
        },
      },
    },
    on_new_config = function(new_config)
      if not new_config.settings then
        new_config.settings = {}
      end
      if not new_config.settings.editor then
        new_config.settings.editor = {}
      end
      if not new_config.settings.editor.tabSize then
        -- set tab size for hover
        new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
      end
    end,
    root_dir = function(fname)
      return util.root_pattern(
        'tailwind.config.js',
        'tailwind.config.cjs',
        'tailwind.config.mjs',
        'tailwind.config.ts',
        'postcss.config.js',
        'postcss.config.cjs',
        'postcss.config.mjs',
        'postcss.config.ts'
      )(fname) or util.find_package_json_ancestor(fname) or util.find_node_modules_ancestor(fname) or util.find_git_ancestor(
        fname
      )
    end,
  },
  docs = {
    description = [[
https://github.com/tailwindlabs/tailwindcss-intellisense

Tailwind CSS Language Server can be installed via npm:
```sh
npm install -g @tailwindcss/language-server
```
]],
    default_config = {
      root_dir = [[root_pattern('tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.cjs', 'postcss.config.mjs', 'postcss.config.ts', 'package.json', 'node_modules', '.git')]],
    },
  },
}
