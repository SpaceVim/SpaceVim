local api = vim.api
local ts = vim.treesitter

local new_lang_api = ts.language.register ~= nil

local filetype_to_parsername = {}

if new_lang_api then
  filetype_to_parsername = setmetatable({}, {
    __newindex = function(_, k, v)
      require("nvim-treesitter.utils").notify(
        "filetype_to_parsername is deprecated, please use 'vim.treesitter.language.register'",
        vim.log.levels.WARN
      )
      ts.language.register(v, k)
    end,
  })
end

local function register_lang(lang, ft)
  if new_lang_api then
    ts.language.register(lang, ft)
    return
  end
  filetype_to_parsername[ft] = lang
end

for ft, lang in pairs {
  javascriptreact = "javascript",
  ecma = "javascript",
  jsx = "javascript",
  sh = "bash",
  PKGBUILD = "bash",
  html_tags = "html",
  ["typescript.tsx"] = "tsx",
  ["html.handlebars"] = "glimmer",
  systemverilog = "verilog",
  cls = "latex",
  sty = "latex",
  pandoc = "markdown",
  rmd = "markdown",
  quarto = "markdown",
  dosini = "ini",
  confini = "ini",
} do
  register_lang(lang, ft)
end

---@class InstallInfo
---@field url string
---@field branch string|nil
---@field revision string|nil
---@field files string[]
---@field generate_requires_npm boolean|nil
---@field requires_generate_from_grammar boolean|nil
---@field location string|nil
---@field use_makefile boolean|nil
---@field cxx_standard string|nil

---@class ParserInfo
---@field install_info InstallInfo
---@field filetype string
---@field maintainers string[]
---@field experimental boolean|nil
---@field readme_name string|nil

---@type ParserInfo[]
local list = setmetatable({}, {
  __newindex = function(table, parsername, parserconfig)
    rawset(table, parsername, parserconfig)
    register_lang(parsername, parserconfig.filetype or parsername)
  end,
})

list.ada = {
  install_info = {
    url = "https://github.com/briot/tree-sitter-ada",
    files = { "src/parser.c" },
  },
  maintainers = { "@briot" },
}

list.agda = {
  install_info = {
    url = "https://github.com/AusCyberman/tree-sitter-agda",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@Decodetalkers" },
}

list.arduino = {
  install_info = {
    url = "https://github.com/ObserverOfTime/tree-sitter-arduino",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@ObserverOfTime" },
}

list.astro = {
  install_info = {
    url = "https://github.com/virchau13/tree-sitter-astro",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@virchau13" },
}

list.awk = {
  install_info = {
    url = "https://github.com/Beaglefoot/tree-sitter-awk",
    files = { "src/parser.c", "src/scanner.c" },
  },
}

list.bash = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-bash",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "sh",
  maintainers = { "@TravonteD" },
}

list.bass = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-bass",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.beancount = {
  install_info = {
    url = "https://github.com/polarmutex/tree-sitter-beancount",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@polarmutex" },
}

list.bibtex = {
  install_info = {
    url = "https://github.com/latex-lsp/tree-sitter-bibtex",
    files = { "src/parser.c" },
  },
  filetype = "bib",
  maintainers = { "@theHamsta", "@clason" },
}

list.bicep = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-bicep",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.blueprint = {
  install_info = {
    url = "https://gitlab.com/gabmus/tree-sitter-blueprint.git",
    files = { "src/parser.c" },
  },
  maintainers = { "@gabmus" },
  experimental = true,
}

list.c = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-c",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.c_sharp = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-c-sharp",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "cs",
  maintainers = { "@Luxed" },
}

list.cairo = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-cairo",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.capnp = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-capnp",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.chatito = {
  install_info = {
    url = "https://github.com/ObserverOfTime/tree-sitter-chatito",
    files = { "src/parser.c" },
  },
  maintainers = { "@ObserverOfTime" },
}

list.clojure = {
  install_info = {
    url = "https://github.com/sogaiu/tree-sitter-clojure",
    files = { "src/parser.c" },
  },
  maintainers = { "@sogaiu" },
}

list.cmake = {
  install_info = {
    url = "https://github.com/uyha/tree-sitter-cmake",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@uyha" },
}

list.comment = {
  install_info = {
    url = "https://github.com/stsewd/tree-sitter-comment",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@stsewd" },
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

list.cooklang = {
  install_info = {
    url = "https://github.com/addcninblue/tree-sitter-cooklang",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@addcninblue" },
}

list.corn = {
  install_info = {
    url = "https://github.com/jakestanger/tree-sitter-corn",
    files = { "src/parser.c" },
  },
  maintainers = { "@jakestanger" },
}

list.cpon = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-cpon",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.cpp = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-cpp",
    files = { "src/parser.c", "src/scanner.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@theHamsta" },
}

list.css = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-css",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@TravonteD" },
}

list.cuda = {
  install_info = {
    url = "https://github.com/theHamsta/tree-sitter-cuda",
    files = { "src/parser.c", "src/scanner.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@theHamsta" },
}

list.cue = {
  install_info = {
    url = "https://github.com/eonpatapon/tree-sitter-cue",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.d = {
  install_info = {
    url = "https://github.com/CyberShadow/tree-sitter-d",
    files = { "src/parser.c", "src/scanner.cc" },
    requires_generate_from_grammar = true,
  },
  -- Generating grammar takes ~60s
  experimental = true,
  maintainers = { "@nawordar" },
}

list.dart = {
  install_info = {
    url = "https://github.com/UserNobody14/tree-sitter-dart",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@akinsho" },
}

list.devicetree = {
  install_info = {
    url = "https://github.com/joelspadin/tree-sitter-devicetree",
    files = { "src/parser.c" },
  },
  filetype = "dts",
  maintainers = { "@jedrzejboczar" },
}

list.dhall = {
  install_info = {
    url = "https://github.com/jbellerb/tree-sitter-dhall",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.diff = {
  install_info = {
    url = "https://github.com/the-mikedavis/tree-sitter-diff",
    files = { "src/parser.c" },
  },
  filetype = "gitdiff",
  maintainers = { "@gbprod" },
}

list.dockerfile = {
  install_info = {
    url = "https://github.com/camdencheek/tree-sitter-dockerfile",
    files = { "src/parser.c" },
  },
  maintainers = { "@camdencheek" },
}

list.dot = {
  install_info = {
    url = "https://github.com/rydesun/tree-sitter-dot",
    files = { "src/parser.c" },
  },
  maintainers = { "@rydesun" },
}

list.ebnf = {
  install_info = {
    url = "https://github.com/RubixDev/ebnf",
    files = { "src/parser.c" },
    location = "crates/tree-sitter-ebnf",
  },
  maintainers = { "@RubixDev" },
  experimental = true,
}

list.eex = {
  install_info = {
    url = "https://github.com/connorlay/tree-sitter-eex",
    files = { "src/parser.c" },
  },
  filetype = "eelixir",
  maintainers = { "@connorlay" },
}

list.elixir = {
  install_info = {
    url = "https://github.com/elixir-lang/tree-sitter-elixir",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@connorlay" },
}

list.elm = {
  install_info = {
    url = "https://github.com/elm-tooling/tree-sitter-elm",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@zweimach" },
}

list.elsa = {
  install_info = {
    url = "https://github.com/glapa-grossklag/tree-sitter-elsa",
    files = { "src/parser.c" },
  },
  maintainers = { "@glapa-grossklag", "@amaanq" },
}

list.elvish = {
  install_info = {
    url = "https://github.com/elves/tree-sitter-elvish",
    files = { "src/parser.c" },
  },
  maintainers = { "@elves" },
}

list.embedded_template = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-embedded-template",
    files = { "src/parser.c" },
  },
  filetype = "eruby",
}

list.erlang = {
  install_info = {
    url = "https://github.com/WhatsApp/tree-sitter-erlang",
    files = { "src/parser.c" },
  },
  maintainers = { "@filmor" },
}

list.fennel = {
  install_info = {
    url = "https://github.com/travonted/tree-sitter-fennel",
    files = { "src/parser.c" },
  },
  maintainers = { "@TravonteD" },
}

list.firrtl = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-firrtl",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.fish = {
  install_info = {
    url = "https://github.com/ram02z/tree-sitter-fish",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@ram02z" },
}

list.foam = {
  install_info = {
    url = "https://github.com/FoamScience/tree-sitter-foam",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@FoamScience" },
  -- Queries might change over time on the grammar's side
  -- Otherwise everything runs fine
  experimental = true,
}

list.fortran = {
  install_info = {
    url = "https://github.com/stadelmanma/tree-sitter-fortran",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.fsh = {
  install_info = {
    url = "https://github.com/mgramigna/tree-sitter-fsh",
    files = { "src/parser.c" },
  },
  maintainers = { "@mgramigna" },
}

list.func = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-func",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.fusion = {
  install_info = {
    url = "https://gitlab.com/jirgn/tree-sitter-fusion.git",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@jirgn" },
}

list.gdscript = {
  install_info = {
    url = "https://github.com/PrestonKnopp/tree-sitter-gdscript",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@PrestonKnopp" },
  readme_name = "Godot (gdscript)",
}

list.git_rebase = {
  install_info = {
    url = "https://github.com/the-mikedavis/tree-sitter-git-rebase",
    files = { "src/parser.c" },
  },
  filetype = "gitrebase",
  maintainers = { "@gbprod" },
}

list.gitattributes = {
  install_info = {
    url = "https://github.com/ObserverOfTime/tree-sitter-gitattributes",
    files = { "src/parser.c" },
  },
  maintainers = { "@ObserverOfTime" },
}

list.gitcommit = {
  install_info = {
    url = "https://github.com/gbprod/tree-sitter-gitcommit",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@gbprod" },
}

list.git_config = {
  install_info = {
    url = "https://github.com/the-mikedavis/tree-sitter-git-config",
    files = { "src/parser.c" },
  },
  filetype = "gitconfig",
  maintainers = { "@amaanq" },
  readme_name = "git_config",
}

list.gitignore = {
  install_info = {
    url = "https://github.com/shunsambongi/tree-sitter-gitignore",
    files = { "src/parser.c" },
  },
  maintainers = { "@theHamsta" },
}

list.gleam = {
  install_info = {
    url = "https://github.com/gleam-lang/tree-sitter-gleam",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.glimmer = {
  install_info = {
    url = "https://github.com/alexlafroscia/tree-sitter-glimmer",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "handlebars",
  maintainers = { "@NullVoxPopuli" },
  readme_name = "Glimmer and Ember",
}

list.glsl = {
  install_info = {
    url = "https://github.com/theHamsta/tree-sitter-glsl",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@theHamsta" },
}

list.go = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-go",
    files = { "src/parser.c" },
  },
  maintainers = { "@theHamsta", "@WinWisely268" },
}

list.godot_resource = {
  install_info = {
    url = "https://github.com/PrestonKnopp/tree-sitter-godot-resource",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "gdresource",
  maintainers = { "@pierpo" },
  readme_name = "Godot Resources (gdresource)",
}

list.gomod = {
  install_info = {
    url = "https://github.com/camdencheek/tree-sitter-go-mod",
    files = { "src/parser.c" },
  },
  maintainers = { "@camdencheek" },
}

list.gosum = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-go-sum",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.gowork = {
  install_info = {
    url = "https://github.com/omertuc/tree-sitter-go-work",
    files = { "src/parser.c" },
  },
  maintainers = { "@omertuc" },
}

list.groovy = {
  install_info = {
    url = "https://github.com/Decodetalkers/tree-sitter-groovy",
    files = { "src/parser.c" },
    branch = "gh-pages",
  },
  maintainers = { "@Decodetalkers" },
}

list.graphql = {
  install_info = {
    url = "https://github.com/bkegley/tree-sitter-graphql",
    files = { "src/parser.c" },
  },
  maintainers = { "@bkegley" },
}

list.hack = {
  install_info = {
    url = "https://github.com/slackhq/tree-sitter-hack",
    files = { "src/parser.c", "src/scanner.c" },
  },
}

list.hare = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-hare",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.haskell = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-haskell",
    files = { "src/parser.c", "src/scanner.c" },
  },
}

list.haskell_persistent = {
  install_info = {
    url = "https://github.com/MercuryTechnologies/tree-sitter-haskell-persistent",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  filetype = "haskellpersistent",
  maintainers = { "@lykahb" },
}

list.hcl = {
  install_info = {
    url = "https://github.com/MichaHoffmann/tree-sitter-hcl",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@MichaHoffmann" },
}

list.heex = {
  install_info = {
    url = "https://github.com/connorlay/tree-sitter-heex",
    files = { "src/parser.c" },
  },
  maintainers = { "@connorlay" },
}

list.hjson = {
  install_info = {
    url = "https://github.com/winston0410/tree-sitter-hjson",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@winston0410" },
}

list.hlsl = {
  install_info = {
    url = "https://github.com/theHamsta/tree-sitter-hlsl",
    files = { "src/parser.c", "src/scanner.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@theHamsta" },
}

list.hocon = {
  install_info = {
    url = "https://github.com/antosha417/tree-sitter-hocon",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@antosha417" },
}

list.hoon = {
  install_info = {
    url = "https://github.com/urbit-pilled/tree-sitter-hoon",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@urbit-pilled" },
  experimental = true,
}

list.html = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-html",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@TravonteD" },
}

list.htmldjango = {
  install_info = {
    url = "https://github.com/interdependence/tree-sitter-htmldjango",
    files = { "src/parser.c" },
  },
  maintainers = { "@ObserverOfTime" },
  experimental = true,
}

list.http = {
  install_info = {
    url = "https://github.com/rest-nvim/tree-sitter-http",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@amaanq" },
}

list.hurl = {
  install_info = {
    url = "https://github.com/pfeiferj/tree-sitter-hurl",
    files = { "src/parser.c" },
  },
  maintainers = { "@pfeiferj" },
}

list.ini = {
  install_info = {
    url = "https://github.com/justinmk/tree-sitter-ini",
    files = { "src/parser.c" },
  },
  maintainers = { "@theHamsta" },
  experimental = true,
}

list.ispc = {
  install_info = {
    url = "https://github.com/fab4100/tree-sitter-ispc",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@fab4100" },
}

list.janet_simple = {
  install_info = {
    url = "https://github.com/sogaiu/tree-sitter-janet-simple",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "janet",
  maintainers = { "@sogaiu" },
}

list.java = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-java",
    files = { "src/parser.c" },
  },
  maintainers = { "@p00f" },
}

list.javascript = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-javascript",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@steelsojka" },
}

list.jq = {
  install_info = {
    url = "https://github.com/flurie/tree-sitter-jq",
    files = { "src/parser.c" },
  },
  maintainers = { "@ObserverOfTime" },
}

list.jsdoc = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-jsdoc",
    files = { "src/parser.c" },
  },
  maintainers = { "@steelsojka" },
}

list.json = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-json",
    files = { "src/parser.c" },
  },
  maintainers = { "@steelsojka" },
}

list.json5 = {
  install_info = {
    url = "https://github.com/Joakker/tree-sitter-json5",
    files = { "src/parser.c" },
  },
  maintainers = { "@Joakker" },
}

list.jsonc = {
  install_info = {
    url = "https://gitlab.com/WhyNotHugo/tree-sitter-jsonc.git",
    files = { "src/parser.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@WhyNotHugo" },
  readme_name = "JSON with comments",
}

list.jsonnet = {
  install_info = {
    url = "https://github.com/sourcegraph/tree-sitter-jsonnet",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@nawordar" },
}

list.julia = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-julia",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@theHamsta" },
}

list.kdl = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-kdl",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.kotlin = {
  install_info = {
    url = "https://github.com/fwcd/tree-sitter-kotlin",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@SalBakraa" },
}

list.lalrpop = {
  install_info = {
    url = "https://github.com/traxys/tree-sitter-lalrpop",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@traxys" },
}

list.latex = {
  install_info = {
    url = "https://github.com/latex-lsp/tree-sitter-latex",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "tex",
  maintainers = { "@theHamsta", "@clason" },
}

list.ledger = {
  install_info = {
    url = "https://github.com/cbarrete/tree-sitter-ledger",
    files = { "src/parser.c" },
  },
  maintainers = { "@cbarrete" },
}

list.llvm = {
  install_info = {
    url = "https://github.com/benwilliamgraham/tree-sitter-llvm",
    files = { "src/parser.c" },
  },
  maintainers = { "@benwilliamgraham" },
}

list.lua = {
  install_info = {
    url = "https://github.com/MunifTanjim/tree-sitter-lua",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@muniftanjim" },
}

list.luadoc = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-luadoc",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.luap = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-luap",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
  readme_name = "lua patterns",
}

list.luau = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-luau",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.m68k = {
  install_info = {
    url = "https://github.com/grahambates/tree-sitter-m68k",
    files = { "src/parser.c" },
  },
  filetype = "asm68k",
  maintainers = { "@grahambates" },
}

list.make = {
  install_info = {
    url = "https://github.com/alemuller/tree-sitter-make",
    files = { "src/parser.c" },
  },
  maintainers = { "@lewis6991" },
}

list.markdown = {
  install_info = {
    url = "https://github.com/MDeiml/tree-sitter-markdown",
    location = "tree-sitter-markdown",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@MDeiml" },
  readme_name = "markdown (basic highlighting)",
  experimental = true,
}

list.markdown_inline = {
  install_info = {
    url = "https://github.com/MDeiml/tree-sitter-markdown",
    location = "tree-sitter-markdown-inline",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@MDeiml" },
  readme_name = "markdown_inline (needed for full highlighting)",
  experimental = true,
}

list.matlab = {
  install_info = {
    url = "https://github.com/acristoffers/tree-sitter-matlab",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@acristoffers" },
}

list.menhir = {
  install_info = {
    url = "https://github.com/Kerl13/tree-sitter-menhir",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@Kerl13" },
}

list.mermaid = {
  install_info = {
    url = "https://github.com/monaqa/tree-sitter-mermaid",
    files = { "src/parser.c" },
  },
  experimental = true,
}

list.meson = {
  install_info = {
    url = "https://github.com/Decodetalkers/tree-sitter-meson",
    files = { "src/parser.c" },
  },
  maintainers = { "@Decodetalkers" },
}

list.mlir = {
  install_info = {
    url = "https://github.com/artagnon/tree-sitter-mlir",
    files = { "src/parser.c" },
    requires_generate_from_grammar = true,
  },
  experimental = true,
  maintainers = { "@artagnon" },
}

list.nickel = {
  install_info = {
    url = "https://github.com/nickel-lang/tree-sitter-nickel",
    files = { "src/parser.c", "src/scanner.cc" },
  },
}

list.ninja = {
  install_info = {
    url = "https://github.com/alemuller/tree-sitter-ninja",
    files = { "src/parser.c" },
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

list.norg = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg",
    files = { "src/parser.c", "src/scanner.cc" },
    cxx_standard = "c++14",
    use_makefile = true,
  },
  maintainers = { "@JoeyGrajciar", "@vhyrro" },
}

list.objc = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-objc",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.ocaml = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-ocaml",
    files = { "src/parser.c", "src/scanner.c" },
    location = "ocaml",
  },
  maintainers = { "@undu" },
}

list.ocaml_interface = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-ocaml",
    files = { "src/parser.c", "src/scanner.c" },
    location = "interface",
  },
  filetype = "ocamlinterface",
  maintainers = { "@undu" },
}

list.ocamllex = {
  install_info = {
    url = "https://github.com/atom-ocaml/tree-sitter-ocamllex",
    files = { "src/parser.c", "src/scanner.c" },
    requires_generate_from_grammar = true,
  },
  maintainers = { "@undu" },
}

list.odin = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-odin",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.org = {
  install_info = {
    url = "https://github.com/milisims/tree-sitter-org",
    files = { "src/parser.c", "src/scanner.c" },
  },
}

list.pascal = {
  install_info = {
    url = "https://github.com/Isopod/tree-sitter-pascal.git",
    files = { "src/parser.c" },
  },
  maintainers = { "@Isopod" },
}

list.passwd = {
  install_info = {
    url = "https://github.com/ath3/tree-sitter-passwd",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.pem = {
  install_info = {
    url = "https://github.com/ObserverOfTime/tree-sitter-pem",
    files = { "src/parser.c" },
  },
  maintainers = { "@ObserverOfTime" },
}

list.perl = {
  install_info = {
    url = "https://github.com/ganezdragon/tree-sitter-perl",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@lcrownover" },
}

list.php = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-php",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@tk-shirasaka" },
}

-- Parsers for injections
list.phpdoc = {
  install_info = {
    url = "https://github.com/claytonrcarter/tree-sitter-phpdoc",
    files = { "src/parser.c", "src/scanner.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@mikehaertl" },
  experimental = true,
}

list.pioasm = {
  install_info = {
    url = "https://github.com/leo60228/tree-sitter-pioasm",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@leo60228" },
}

list.po = {
  install_info = {
    url = "https://github.com/erasin/tree-sitter-po",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.poe_filter = {
  install_info = {
    url = "https://github.com/ObserverOfTime/tree-sitter-poe-filter",
    files = { "src/parser.c" },
  },
  filetype = "poefilter",
  maintainers = { "@ObserverOfTime" },
  readme_name = "Path of Exile item filter",
  experimental = true,
}

list.pony = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-pony",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq", "@mfelsche" },
}

list.prisma = {
  install_info = {
    url = "https://github.com/victorhqc/tree-sitter-prisma",
    files = { "src/parser.c" },
  },
  maintainers = { "@elianiva" },
}

list.promql = {
  install_info = {
    url = "https://github.com/MichaHoffmann/tree-sitter-promql",
    files = { "src/parser.c" },
    experimental = true,
  },
  maintainers = { "@MichaHoffmann" },
}

list.proto = {
  install_info = {
    url = "https://github.com/treywood/tree-sitter-proto",
    files = { "src/parser.c" },
  },
  maintainers = { "@treywood" },
}

list.prql = {
  install_info = {
    url = "https://github.com/PRQL/tree-sitter-prql",
    files = { "src/parser.c" },
  },
  maintainers = { "@matthias-Q" },
}

list.pug = {
  install_info = {
    url = "https://github.com/zealot128/tree-sitter-pug",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@zealot128" },
  experimental = true,
}

list.puppet = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-puppet",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.python = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-python",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@stsewd", "@theHamsta" },
}

list.ql = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-ql",
    files = { "src/parser.c" },
  },
  maintainers = { "@pwntester" },
}

list.qmldir = {
  install_info = {
    url = "https://github.com/Decodetalkers/tree-sitter-qmldir",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.qmljs = {
  install_info = {
    url = "https://github.com/yuja/tree-sitter-qmljs",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "qml",
  maintainers = { "@Decodetalkers" },
}

list.query = {
  install_info = {
    url = "https://github.com/nvim-treesitter/tree-sitter-query",
    files = { "src/parser.c" },
  },
  maintainers = { "@steelsojka" },
  readme_name = "Tree-Sitter query language",
}

list.r = {
  install_info = {
    url = "https://github.com/r-lib/tree-sitter-r",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@echasnovski" },
}

list.racket = {
  install_info = {
    url = "https://github.com/6cdh/tree-sitter-racket",
    files = { "src/parser.c", "src/scanner.c" },
  },
}

list.rasi = {
  install_info = {
    url = "https://github.com/Fymyte/tree-sitter-rasi",
    files = { "src/parser.c" },
  },
  maintainers = { "@Fymyte" },
}

list.regex = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-regex",
    files = { "src/parser.c" },
  },
  maintainers = { "@theHamsta" },
}

list.rego = {
  install_info = {
    url = "https://github.com/FallenAngel97/tree-sitter-rego",
    files = { "src/parser.c" },
  },
  maintainers = { "@FallenAngel97" },
}

list.requirements = {
  install_info = {
    url = "https://github.com/ObserverOfTime/tree-sitter-requirements",
    files = { "src/parser.c" },
  },
  maintainers = { "@ObserverOfTime" },
  readme_name = "pip requirements",
}

list.rnoweb = {
  install_info = {
    url = "https://github.com/bamonroe/tree-sitter-rnoweb",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@bamonroe" },
}

list.robot = {
  install_info = {
    url = "https://github.com/Hubro/tree-sitter-robot",
    files = { "src/parser.c" },
  },
  maintainers = { "@ema2159" },
  experimental = true,
}

list.ron = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-ron",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.rst = {
  install_info = {
    url = "https://github.com/stsewd/tree-sitter-rst",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@stsewd" },
}

list.ruby = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-ruby",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@TravonteD" },
}

list.rust = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-rust",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.scala = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-scala",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@stevanmilic" },
}

list.scfg = {
  install_info = {
    url = "https://git.sr.ht/~rockorager/tree-sitter-scfg",
    files = { "src/parser.c" },
    requires_generate_from_grammar = true,
  },
  maintainers = { "@WhyNotHugo" },
}

list.scheme = {
  install_info = {
    url = "https://github.com/6cdh/tree-sitter-scheme",
    files = { "src/parser.c" },
  },
}

list.scss = {
  install_info = {
    url = "https://github.com/serenadeai/tree-sitter-scss",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@elianiva" },
}

list.slint = {
  install_info = {
    url = "https://github.com/jrmoulton/tree-sitter-slint",
    files = { "src/parser.c" },
  },
  maintainers = { "@jrmoulton" },
  experimental = true,
}

list.smali = {
  install_info = {
    url = "https://git.sr.ht/~yotam/tree-sitter-smali",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.smithy = {
  install_info = {
    url = "https://github.com/indoorvivants/tree-sitter-smithy",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq", "@keynmol" },
}

list.solidity = {
  install_info = {
    url = "https://github.com/JoranHonig/tree-sitter-solidity",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq" },
}

list.sparql = {
  install_info = {
    url = "https://github.com/BonaBeavis/tree-sitter-sparql",
    files = { "src/parser.c" },
  },
  maintainers = { "@BonaBeavis" },
}

list.sql = {
  install_info = {
    url = "https://github.com/derekstride/tree-sitter-sql",
    files = { "src/parser.c" },
    branch = "gh-pages",
  },
  maintainers = { "@derekstride" },
}

list.squirrel = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-squirrel",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.starlark = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-starlark",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "bzl",
  maintainers = { "@amaanq" },
}

list.supercollider = {
  install_info = {
    url = "https://github.com/madskjeldgaard/tree-sitter-supercollider",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@madskjeldgaard" },
}

list.surface = {
  install_info = {
    url = "https://github.com/connorlay/tree-sitter-surface",
    files = { "src/parser.c" },
  },
  filetype = "sface",
  maintainers = { "@connorlay" },
}

list.svelte = {
  install_info = {
    url = "https://github.com/Himujjal/tree-sitter-svelte",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@elianiva" },
}

list.swift = {
  install_info = {
    url = "https://github.com/alex-pinkus/tree-sitter-swift",
    files = { "src/parser.c", "src/scanner.c" },
    requires_generate_from_grammar = true,
  },
  maintainers = { "@alex-pinkus" },
}

list.sxhkdrc = {
  install_info = {
    url = "https://github.com/RaafatTurki/tree-sitter-sxhkdrc",
    files = { "src/parser.c" },
  },
  maintainers = { "@RaafatTurki" },
}

list.systemtap = {
  install_info = {
    url = "https://github.com/ok-ryoko/tree-sitter-systemtap",
    files = { "src/parser.c" },
  },
  maintainers = { "@ok-ryoko" },
}

list.t32 = {
  install_info = {
    url = "https://gitlab.com/xasc/tree-sitter-t32.git",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@xasc" },
}

list.tablegen = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-tablegen",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@amaanq" },
}

list.teal = {
  install_info = {
    url = "https://github.com/euclidianAce/tree-sitter-teal",
    files = { "src/parser.c", "src/scanner.c" },
    requires_generate_from_grammar = true,
  },
  maintainers = { "@euclidianAce" },
}

list.terraform = {
  install_info = {
    url = "https://github.com/MichaHoffmann/tree-sitter-hcl",
    files = { "src/parser.c", "src/scanner.c" },
    location = "dialects/terraform",
  },
  maintainers = { "@MichaHoffmann" },
}

list.thrift = {
  install_info = {
    url = "https://github.com/duskmoon314/tree-sitter-thrift",
    files = { "src/parser.c" },
  },
  maintainers = { "@amaanq", "@duskmoon314" },
}

list.tiger = {
  install_info = {
    url = "https://github.com/ambroisie/tree-sitter-tiger",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@ambroisie" },
}

list.tlaplus = {
  install_info = {
    url = "https://github.com/tlaplus-community/tree-sitter-tlaplus",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  filetype = "tla",
  maintainers = { "@ahelwer", "@susliko" },
}

list.todotxt = {
  install_info = {
    url = "https://github.com/arnarg/tree-sitter-todotxt.git",
    files = { "src/parser.c" },
  },
  maintainers = { "@arnarg" },
  experimental = true,
}

list.toml = {
  install_info = {
    url = "https://github.com/ikatyang/tree-sitter-toml",
    files = { "src/parser.c", "src/scanner.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@tk-shirasaka" },
}

list.tsx = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-typescript",
    files = { "src/parser.c", "src/scanner.c" },
    location = "tsx",
    generate_requires_npm = true,
  },
  filetype = "typescriptreact",
  maintainers = { "@steelsojka" },
}

list.turtle = {
  install_info = {
    url = "https://github.com/BonaBeavis/tree-sitter-turtle",
    files = { "src/parser.c" },
  },
  maintainers = { "@BonaBeavis" },
}

list.twig = {
  install_info = {
    url = "https://github.com/gbprod/tree-sitter-twig",
    files = { "src/parser.c" },
  },
  maintainers = { "@gbprod" },
}

list.typescript = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-typescript",
    files = { "src/parser.c", "src/scanner.c" },
    location = "typescript",
    generate_requires_npm = true,
  },
  maintainers = { "@steelsojka" },
}

list.ungrammar = {
  install_info = {
    url = "https://github.com/Philipp-M/tree-sitter-ungrammar",
    files = { "src/parser.c" },
  },
  maintainers = { "@Philipp-M", "@amaanq" },
}

list.usd = {
  install_info = {
    url = "https://github.com/ColinKennedy/tree-sitter-usd",
    files = { "src/parser.c" },
  },
  maintainers = { "@ColinKennedy" },
}

list.uxntal = {
  install_info = {
    url = "https://github.com/amaanq/tree-sitter-uxntal",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "tal",
  maintainers = { "@amaanq" },
  readme_name = "uxn tal",
}

list.v = {
  install_info = {
    url = "https://github.com/v-analyzer/v-analyzer",
    files = { "src/parser.c", "src/scanner.c" },
    location = "tree_sitter_v",
  },
  filetype = "vlang",
  maintainers = { "@kkharji", "@amaanq" },
}

list.vala = {
  install_info = {
    url = "https://github.com/vala-lang/tree-sitter-vala",
    files = { "src/parser.c" },
  },
  maintainers = { "@Prince781" },
}

list.verilog = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-verilog",
    files = { "src/parser.c" },
  },
  maintainers = { "@zegervdv" },
}

list.vhs = {
  install_info = {
    url = "https://github.com/charmbracelet/tree-sitter-vhs",
    files = { "src/parser.c" },
  },
  filetype = "tape",
  maintainers = { "@caarlos0" },
}

list.vim = {
  install_info = {
    url = "https://github.com/neovim/tree-sitter-vim",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@clason" },
}

list.vimdoc = {
  install_info = {
    url = "https://github.com/neovim/tree-sitter-vimdoc",
    files = { "src/parser.c" },
  },
  filetype = "help",
  maintainers = { "@clason" },
}

list.vue = {
  install_info = {
    url = "https://github.com/ikatyang/tree-sitter-vue",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  maintainers = { "@WhyNotHugo" },
}

list.wgsl = {
  install_info = {
    url = "https://github.com/szebniok/tree-sitter-wgsl",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@szebniok" },
}

list.wgsl_bevy = {
  install_info = {
    url = "https://github.com/theHamsta/tree-sitter-wgsl-bevy",
    files = { "src/parser.c", "src/scanner.c" },
    generate_requires_npm = true,
  },
  maintainers = { "@theHamsta" },
}

list.wing = {
  install_info = {
    url = "https://github.com/winglang/wing",
    files = { "src/parser.c", "src/scanner.c" },
    location = "libs/tree-sitter-wing",
    requires_generate_from_grammar = true,
  },
  maintainers = { "@gshpychka" },
  experimental = true,
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
}

list.yuck = {
  install_info = {
    url = "https://github.com/Philipp-M/tree-sitter-yuck",
    files = { "src/parser.c", "src/scanner.c" },
  },
  maintainers = { "@Philipp-M", "@amaanq" },
}

list.zig = {
  install_info = {
    url = "https://github.com/maxxnino/tree-sitter-zig",
    files = { "src/parser.c" },
  },
  maintainers = { "@maxxnino" },
}

local M = {
  list = list,
  filetype_to_parsername = filetype_to_parsername,
}

local function get_lang(ft)
  if new_lang_api then
    return ts.language.get_lang(ft)
  end
  return filetype_to_parsername[ft]
end

function M.ft_to_lang(ft)
  local result = get_lang(ft)
  if result then
    return result
  else
    ft = vim.split(ft, ".", { plain = true })[1]
    return get_lang(ft) or ft
  end
end

-- Get a list of all available parsers
---@return string[]
function M.available_parsers()
  local parsers = vim.tbl_keys(M.list)
  table.sort(parsers)
  if vim.fn.executable "tree-sitter" == 1 and vim.fn.executable "node" == 1 then
    return parsers
  else
    return vim.tbl_filter(function(p) ---@param p string
      return not M.list[p].install_info.requires_generate_from_grammar
    end, parsers)
  end
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

-- Gets the language of a given buffer
---@param bufnr number? or current buffer
---@return string
function M.get_buf_lang(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  return M.ft_to_lang(api.nvim_buf_get_option(bufnr, "ft"))
end

return M
