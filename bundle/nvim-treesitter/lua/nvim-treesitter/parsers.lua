local api = vim.api
local ts = vim.treesitter

local filetype_to_parsername = {
  arduino = "cpp",
  javascriptreact = "javascript",
  ecma = "javascript",
  jsx = "javascript",
  PKGBUILD = "bash",
  html_tags = "html",
  ["typescript.tsx"] = "tsx",
  terraform = "hcl",
  ["html.handlebars"] = "glimmer",
  systemverilog = "verilog",
  cls = "latex",
  sty = "latex",
  OpenFOAM = "foam",
  pandoc = "markdown",
  rmd = "markdown",
}

local list = setmetatable({}, {
  __newindex = function(table, parsername, parserconfig)
    rawset(
      table,
      parsername,
      setmetatable(parserconfig, {
        __newindex = function(parserconfigtable, key, value)
          if key == "used_by" then
            require("nvim-treesitter.utils").notify(
              "used_by is deprecated, please use 'filetype_to_parsername'",
              vim.log.levels.WARN
            )
            filetype_to_parsername[value] = parsername
          else
            rawset(parserconfigtable, key, value)
          end
        end,
      })
    )

    filetype_to_parsername[parserconfig.filetype or parsername] = parsername
  end,
})

list.scheme = {
  install_info = {
    url = "https://github.com/6cdh/tree-sitter-scheme",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@6cdh" },
}

list.javascript = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-javascript",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@steelsojka" },
}

list.rego = {
  install_info = {
    url = "https://github.com/FallenAngel97/tree-sitter-rego",
    files = { "src/parser.c" },
  },
  maintainers = { "@FallenAngel97" },
  filetype = "rego",
}

list.c = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-c",
    files = { "src/parser.c" },
  },
  maintainers = { "@vigoux" },
}

list.clojure = {
  install_info = {
    url = "https://github.com/sogaiu/tree-sitter-clojure",
    files = { "src/parser.c" },
  },
  maintainers = { "@sogaiu" },
}

list.commonlisp = {
  install_info = {
    url = "https://github.com/theHamsta/tree-sitter-commonlisp",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  filetype = "lisp",
  maintainers = { "@theHamsta" },
}

list.cpp = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-cpp",
    files = { "src/parser.c", "src/scanner.cc" },
    generate_requires_npm = true,
  },
  maintainers = { "@theHamsta" },
}

list.cuda = {
  install_info = {
    url = "https://github.com/theHamsta/tree-sitter-cuda",
    files = { "src/parser.c", "src/scanner.cc" },
    generate_requires_npm = true,
  },
  maintainers = { "@theHamsta" },
}

list.d = {
  install_info = {
    url = "https://github.com/CyberShadow/tree-sitter-d",
    files = { "src/parser.c", "src/scanner.cc" },
    requires_generate_from_grammar = true,
  },
  maintainers = { "@nawordar" },
  -- Generating grammar takes ~60s
  experimental = true,
}

list.glsl = {
  install_info = {
    url = "https://github.com/theHamsta/tree-sitter-glsl",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@theHamsta" },
}

list.dockerfile = {
  install_info = {
    url = "https://github.com/camdencheek/tree-sitter-dockerfile",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@camdencheek" },
}

list.dot = {
  install_info = {
    url = "https://github.com/rydesun/tree-sitter-dot",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@rydesun" },
}

list.rust = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-rust",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@vigoux" },
}

list.fusion = {
  install_info = {
    url = "https://gitlab.com/jirgn/tree-sitter-fusion.git",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "main",
  },
  maintainers = { "@jirgn" },
}

list.ledger = {
  install_info = {
    url = "https://github.com/cbarrete/tree-sitter-ledger",
    files = { "src/parser.c" },
  },
  maintainers = { "@cbarrete" },
}

list.lua = {
  install_info = {
    url = "https://github.com/MunifTanjim/tree-sitter-lua",
    branch = "main",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@muniftanjim" },
}

list.python = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-python",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@stsewd", "@theHamsta" },
}

list.go = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-go",
    files = { "src/parser.c" },
  },
  maintainers = { "@theHamsta", "@WinWisely268" },
}

list.gomod = {
  install_info = {
    url = "https://github.com/camdencheek/tree-sitter-go-mod",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@camdencheek" },
  filetype = "gomod",
}

list.gowork = {
  install_info = {
    url = "https://github.com/omertuc/tree-sitter-go-work",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@omertuc" },
  filetype = "gowork",
}

list.graphql = {
  install_info = {
    url = "https://github.com/bkegley/tree-sitter-graphql",
    files = { "src/parser.c" },
  },
  maintainers = { "@bkegley" },
}

list.ruby = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-ruby",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@TravonteD" },
}

list.perl = {
  install_info = {
    url = "https://github.com/ganezdragon/tree-sitter-perl",
    files = { "src/parser.c", "src/scanner.cc" },
    generate_requires_npm = true,
  },
  maintainers = { "@ganezdragon" },
}

list.bash = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-bash",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  filetype = "sh",
  maintainers = { "@TravonteD" },
}

list.fish = {
  install_info = {
    url = "https://github.com/ram02z/tree-sitter-fish",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@ram02z" },
}

list.php = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-php",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@tk-shirasaka" },
}

list.java = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-java",
    files = { "src/parser.c" },
  },
  maintainers = { "@p00f" },
}

list.kotlin = {
  install_info = {
    url = "https://github.com/fwcd/tree-sitter-kotlin",
    branch = "main",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@SalBakraa" },
}

list.html = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-html",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@TravonteD" },
}

list.julia = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-julia",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@mroavi", "@theHamsta" },
}

list.json = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-json",
    files = { "src/parser.c" },
  },
  maintainers = { "@steelsojka" },
}

list.css = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-css",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@TravonteD" },
}

list.scss = {
  install_info = {
    url = "https://github.com/serenadeai/tree-sitter-scss",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@elianiva" },
}

list.erlang = {
  install_info = {
    url = "https://github.com/AbstractMachinesLab/tree-sitter-erlang",
    files = { "src/parser.c" },
    branch = "main",
  },
  maintainers = { "@ostera" },
}

list.elixir = {
  install_info = {
    url = "https://github.com/elixir-lang/tree-sitter-elixir",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
  },
  maintainers = { "@jonatanklosko", "@connorlay" },
}

list.gleam = {
  install_info = {
    url = "https://github.com/J3RN/tree-sitter-gleam",
    files = { "src/parser.c" },
    branch = "main",
  },
  maintainers = { "@connorlay" },
}

list.surface = {
  install_info = {
    url = "https://github.com/connorlay/tree-sitter-surface",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "sface",
  maintainers = { "@connorlay" },
}

list.eex = {
  install_info = {
    url = "https://github.com/connorlay/tree-sitter-eex",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "eex",
  maintainers = { "@connorlay" },
}

list.heex = {
  install_info = {
    url = "https://github.com/connorlay/tree-sitter-heex",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "heex",
  maintainers = { "@connorlay" },
}

list.ocaml = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-ocaml",
    files = { "src/parser.c", "src/scanner.cc" },
    location = "tree-sitter-ocaml/ocaml",
  },
  maintainers = { "@undu" },
}

list.ocaml_interface = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-ocaml",
    files = { "src/parser.c", "src/scanner.cc" },
    location = "tree-sitter-ocaml_interface/interface",
  },
  maintainers = { "@undu" },
  filetype = "ocamlinterface",
}

list.ocamllex = {
  install_info = {
    url = "https://github.com/atom-ocaml/tree-sitter-ocamllex",
    files = { "src/parser.c", "src/scanner.cc" },
    requires_generate_from_grammar = true,
  },
  maintainers = { "@undu" },
}

list.swift = {
  install_info = {
    url = "https://github.com/alex-pinkus/tree-sitter-swift",
    files = { "src/parser.c", "src/scanner.c" },
    requires_generate_from_grammar = true,
    generate_requires_npm = true,
  },
}

list.c_sharp = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-c-sharp",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "cs",
  maintainers = { "@Luxed" },
}

list.todotxt = {
  install_info = {
    url = "https://github.com/arnarg/tree-sitter-todotxt.git",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "todotxt",
  maintainers = { "@arnarg" },
  experimental = true,
}

list.typescript = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-typescript",
    files = { "src/parser.c", "src/scanner.c" },
    location = "tree-sitter-typescript/typescript",
    generate_requires_npm = true,
  },
  maintainers = { "@steelsojka" },
}

list.tsx = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-typescript",
    files = { "src/parser.c", "src/scanner.c" },
    location = "tree-sitter-tsx/tsx",
    generate_requires_npm = true,
  },
  filetype = "typescriptreact",
  maintainers = { "@steelsojka" },
}

list.scala = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-scala",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@stevanmilic" },
}

list.supercollider = {
  install_info = {
    url = "https://github.com/madskjeldgaard/tree-sitter-supercollider",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "main",
  },
  maintainers = { "@madskjeldgaard" },
  filetype = "supercollider",
}

list.slint = {
  install_info = {
    url = "https://github.com/jrmoulton/tree-sitter-slint",
    files = { "src/parser.c" },
    branch = "main",
  },
  maintainers = { "@jrmoulton" },
  experimental = true,
}

list.haskell = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-haskell",
    files = { "src/parser.c", "src/scanner.c" },
  },
}

list.hcl = {
  install_info = {
    url = "https://github.com/MichaHoffmann/tree-sitter-hcl",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
  },
  maintainers = { "@MichaHoffmann" },
  filetype = "hcl",
}

list.markdown = {
  install_info = {
    url = "https://github.com/MDeiml/tree-sitter-markdown",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
  },
  experimental = true,
}

list.tlaplus = {
  install_info = {
    url = "https://github.com/tlaplus-community/tree-sitter-tlaplus",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@ahelwer", "@susliko" },
  filetype = "tla",
}

list.toml = {
  install_info = {
    url = "https://github.com/ikatyang/tree-sitter-toml",
    files = { "src/parser.c", "src/scanner.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@tk-shirasaka" },
}

list.glimmer = {
  install_info = {
    url = "https://github.com/alexlafroscia/tree-sitter-glimmer",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "main",
  },
  readme_name = "Glimmer and Ember",
  maintainers = { "@alexlafroscia" },
  filetype = "handlebars",
}

list.pug = {
  install_info = {
    url = "https://github.com/zealot128/tree-sitter-pug",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@zealot128" },
  filetype = "pug",
}

list.vue = {
  install_info = {
    url = "https://github.com/ikatyang/tree-sitter-vue",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@WhyNotHugo" },
}

list.jsonc = {
  install_info = {
    url = "https://gitlab.com/WhyNotHugo/tree-sitter-jsonc.git",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  readme_name = "JSON with comments",
  maintainers = { "@WhyNotHugo" },
}

list.elm = {
  install_info = {
    url = "https://github.com/elm-tooling/tree-sitter-elm",
    files = { "src/parser.c", "src/scanner.cc" },
  },
}

list.yaml = {
  install_info = {
    url = "https://github.com/ikatyang/tree-sitter-yaml",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@stsewd" },
}

list.yang = {
  install_info = {
    url = "https://github.com/Hubro/tree-sitter-yang",
    files = { "src/parser.c" },
  },
  maintainers = { "@Hubro" },
  filetype = "yang",
}

list.ninja = {
  install_info = {
    url = "https://github.com/alemuller/tree-sitter-ninja",
    files = { "src/parser.c" },
    branch = "main",
  },
  maintainers = { "@alemuller" },
}

list.nix = {
  install_info = {
    url = "https://github.com/cstrahan/tree-sitter-nix",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@leo60228" },
}

list.dart = {
  install_info = {
    url = "https://github.com/UserNobody14/tree-sitter-dart",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@Akin909" },
}

list.rst = {
  install_info = {
    url = "https://github.com/stsewd/tree-sitter-rst",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@stsewd" },
}

list.fennel = {
  install_info = {
    url = "https://github.com/travonted/tree-sitter-fennel",
    files = { "src/parser.c" },
  },
  maintainers = { "@TravonteD" },
}

list.teal = {
  install_info = {
    url = "https://github.com/euclidianAce/tree-sitter-teal",
    files = { "src/parser.c", "src/scanner.c" },
    requires_generate_from_grammar = true,
  },
  maintainers = { "@euclidianAce" },
}

list.ql = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-ql",
    files = { "src/parser.c" },
  },
  maintainers = { "@pwntester" },
}

list.verilog = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-verilog",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@zegervdv" },
  -- The parser still uses API version 12, because it does not compile with 13
  experimental = true,
}

list.pascal = {
  install_info = {
    url = "https://github.com/Isopod/tree-sitter-pascal.git",
    files = { "src/parser.c" },
  },
  maintainers = { "@isopod" },
}

-- Parsers for injections
list.phpdoc = {
  install_info = {
    url = "https://github.com/claytonrcarter/tree-sitter-phpdoc",
    files = { "src/parser.c", "src/scanner.c" },
    -- parser.c in the repo still based on TS 0.17 due to other dependencies
    requires_generate_from_grammar = true,
    generate_requires_npm = true,
  },
  maintainers = { "@mikehaertl" },
  experimental = true,
}

list.regex = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-regex",
    files = { "src/parser.c" },
  },
  maintainers = { "@theHamsta" },
}

list.comment = {
  install_info = {
    url = "https://github.com/stsewd/tree-sitter-comment",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@stsewd" },
}

list.jsdoc = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-jsdoc",
    files = { "src/parser.c" },
  },
  maintainers = { "@steelsojka" },
}

list.query = {
  install_info = {
    url = "https://github.com/nvim-treesitter/tree-sitter-query",
    files = { "src/parser.c" },
  },
  readme_name = "Tree-sitter query language",
  maintainers = { "@steelsojka" },
}

list.sparql = {
  install_info = {
    url = "https://github.com/BonaBeavis/tree-sitter-sparql",
    files = { "src/parser.c" },
    branch = "main",
  },
  maintainers = { "@bonabeavis" },
}

list.gdscript = {
  install_info = {
    url = "https://github.com/PrestonKnopp/tree-sitter-gdscript",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  readme_name = "Godot (gdscript)",
  maintainers = { "@Shatur95" },
}

list.godot_resource = {
  install_info = {
    url = "https://github.com/PrestonKnopp/tree-sitter-godot-resource",
    files = { "src/parser.c", "src/scanner.c" },
    requires_generate_from_grammar = true,
  },
  filetype = "gdresource",
  readme_name = "Godot Resources (gdresource)",
  maintainers = { "@pierpo" },
}

list.turtle = {
  install_info = {
    url = "https://github.com/BonaBeavis/tree-sitter-turtle",
    files = { "src/parser.c" },
    branch = "main",
  },
  maintainers = { "@bonabeavis" },
}

list.devicetree = {
  install_info = {
    url = "https://github.com/joelspadin/tree-sitter-devicetree",
    files = { "src/parser.c" },
    branch = "main",
    requires_generate_from_grammar = true,
  },
  filetype = "dts",
  maintainers = { "@jedrzejboczar" },
}

list.svelte = {
  install_info = {
    url = "https://github.com/Himujjal/tree-sitter-svelte",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "master",
  },
  maintainers = { "@elianiva" },
}

list.r = {
  install_info = {
    url = "https://github.com/r-lib/tree-sitter-r",
    files = { "src/parser.c" },
  },
  maintainers = { "@jimhester" },
}

list.beancount = {
  install_info = {
    url = "https://github.com/polarmutex/tree-sitter-beancount",
    files = { "src/parser.c" },
    branch = "master",
  },
  maintainers = { "@polarmutex" },
}

list.latex = {
  install_info = {
    url = "https://github.com/latex-lsp/tree-sitter-latex",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "tex",
  maintainers = { "@theHamsta, @clason" },
}

list.bibtex = {
  install_info = {
    url = "https://github.com/latex-lsp/tree-sitter-bibtex",
    files = { "src/parser.c" },
  },
  filetype = "bib",
  maintainers = { "@theHamsta, @clason" },
}

list.zig = {
  install_info = {
    url = "https://github.com/maxxnino/tree-sitter-zig",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "zig",
  maintainers = { "@maxxnino" },
}

list.fortran = {
  install_info = {
    url = "https://github.com/stadelmanma/tree-sitter-fortran",
    files = { "src/parser.c", "src/scanner.cc" },
  },
}

list.cmake = {
  install_info = {
    url = "https://github.com/uyha/tree-sitter-cmake",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@uyha" },
}

list.vim = {
  install_info = {
    url = "https://github.com/vigoux/tree-sitter-viml",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "vim",
  maintainers = { "@vigoux" },
}

list.help = {
  install_info = {
    url = "https://github.com/vigoux/tree-sitter-vimdoc",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "help",
  maintainers = { "@vigoux" },
  experimental = true,
}

list.json5 = {
  install_info = {
    url = "https://github.com/Joakker/tree-sitter-json5",
    files = { "src/parser.c" },
  },
  filetype = "json5",
  maintainers = { "@Joakker" },
}

list.pioasm = {
  install_info = {
    url = "https://github.com/leo60228/tree-sitter-pioasm",
    branch = "main",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@leo60228" },
}

list.hjson = {
  install_info = {
    url = "https://github.com/winston0410/tree-sitter-hjson",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@winston0410" },
}

list.hocon = {
  install_info = {
    url = "https://github.com/antosha417/tree-sitter-hocon",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@antosha417" },
}

list.llvm = {
  install_info = {
    url = "https://github.com/benwilliamgraham/tree-sitter-llvm",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@benwilliamgraham" },
}

list.http = {
  install_info = {
    url = "https://github.com/NTBBloodbath/tree-sitter-http",
    branch = "main",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@NTBBloodbath" },
}

list.prisma = {
  install_info = {
    url = "https://github.com/victorhqc/tree-sitter-prisma",
    branch = "master",
    files = { "src/parser.c" },
  },
  maintainers = { "@elianiva" },
}

list.make = {
  install_info = {
    url = "https://github.com/alemuller/tree-sitter-make",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@lewis6991" },
}

list.rasi = {
  install_info = {
    url = "https://github.com/Fymyte/tree-sitter-rasi",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@Fymyte" },
}

list.foam = {
  install_info = {
    url = "https://github.com/FoamScience/tree-sitter-foam",
    branch = "master",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@FoamScience" },
  filetype = "foam",
  -- Queries might change over time on the grammar's side
  -- Otherwise everything runs fine
  experimental = true,
}

list.hack = {
  install_info = {
    url = "https://github.com/slackhq/tree-sitter-hack",
    branch = "main",
    files = { "src/parser.c", "src/scanner.cc" },
  },
}

list.norg = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg",
    branch = "main",
    files = { "src/parser.c", "src/scanner.cc" },
    use_makefile = true,
    cxx_standard = "c++14",
  },
  maintainers = { "@JoeyGrajciar", "@vhyrro", "@mrossinek" },
}

list.vala = {
  install_info = {
    url = "https://github.com/matbme/tree-sitter-vala",
    branch = "main",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@matbme" },
}

list.lalrpop = {
  install_info = {
    url = "https://github.com/traxys/tree-sitter-lalrpop",
    branch = "master",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@traxys" },
}

list.solidity = {
  install_info = {
    url = "https://github.com/YongJieYongJie/tree-sitter-solidity",
    branch = "with-generated-c-code",
    files = { "src/parser.c" },
  },
  maintainers = { "@YongJieYongJie" },
}

list.cooklang = {
  install_info = {
    url = "https://github.com/addcninblue/tree-sitter-cooklang",
    branch = "master",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@addcninblue" },
}

list.elvish = {
  install_info = {
    url = "https://github.com/ckafi/tree-sitter-elvish",
    branch = "main",
    files = { "src/parser.c" },
  },
  maintainers = { "@ckafi" },
}

list.astro = {
  install_info = {
    url = "https://github.com/virchau13/tree-sitter-astro",
    branch = "master",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@virchau13" },
}

list.wgsl = {
  install_info = {
    url = "https://github.com/szebniok/tree-sitter-wgsl",
    files = { "src/parser.c" },
  },
  maintainers = { "@szebniok" },
  filetype = "wgsl",
}

local M = {
  list = list,
  filetype_to_parsername = filetype_to_parsername,
}

function M.ft_to_lang(ft)
  local result = filetype_to_parsername[ft]
  if result then
    return result
  else
    ft = vim.split(ft, ".", true)[1]
    return filetype_to_parsername[ft] or ft
  end
end

function M.available_parsers()
  if vim.fn.executable "tree-sitter" == 1 and vim.fn.executable "node" == 1 then
    return vim.tbl_keys(M.list)
  else
    return vim.tbl_filter(function(p)
      return not M.list[p].install_info.requires_generate_from_grammar
    end, vim.tbl_keys(M.list))
  end
end

function M.maintained_parsers()
  require("nvim-treesitter.utils").notify(
    "ensure_installed='maintained' will be removed April 30, 2022. Specify parsers explicitly or use 'all'.",
    vim.log.levels.WARN
  )
  local has_tree_sitter_cli = vim.fn.executable "tree-sitter" == 1 and vim.fn.executable "node" == 1
  return vim.tbl_filter(function(lang)
    return M.list[lang].maintainers
      and not M.list[lang].experimental
      and (has_tree_sitter_cli or not M.list[lang].install_info.requires_generate_from_grammar)
  end, M.available_parsers())
end

function M.get_parser_configs()
  return M.list
end

local parser_files

function M.reset_cache()
  parser_files = setmetatable({}, {
    __index = function(tbl, key)
      rawset(tbl, key, api.nvim_get_runtime_file("parser/" .. key .. ".*", false))
      return rawget(tbl, key)
    end,
  })
end

M.reset_cache()

function M.has_parser(lang)
  lang = lang or M.get_buf_lang(api.nvim_get_current_buf())

  if not lang or #lang == 0 then
    return false
  end
  -- HACK: nvim internal API
  if vim._ts_has_language(lang) then
    return true
  end
  return #parser_files[lang] > 0
end

function M.get_parser(bufnr, lang)
  bufnr = bufnr or api.nvim_get_current_buf()
  lang = lang or M.get_buf_lang(bufnr)

  if M.has_parser(lang) then
    return ts.get_parser(bufnr, lang)
  end
end

-- @deprecated This is only kept for legacy purposes.
--             All root nodes should be accounted for.
function M.get_tree_root(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  return M.get_parser(bufnr):parse()[1]:root()
end

-- get language of given buffer
-- @param optional buffer number or current buffer
-- @returns language string of buffer
function M.get_buf_lang(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  return M.ft_to_lang(api.nvim_buf_get_option(bufnr, "ft"))
end

return M
