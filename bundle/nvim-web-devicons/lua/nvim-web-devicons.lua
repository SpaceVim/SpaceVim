-- exact match by file name
local icons_by_filename = {
  [".babelrc"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Babelrc",
  },
  [".bash_profile"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "BashProfile",
  },
  [".bashrc"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Bashrc",
  },
  [".ds_store"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "239",
    name = "DsStore",
  },
  [".eslintrc"] = {
    icon = "",
    color = "#4b32c3",
    cterm_color = "56",
    name = "Eslintrc",
  },
  [".gitattributes"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "239",
    name = "GitAttributes",
  },
  [".gitconfig"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "239",
    name = "GitConfig",
  },
  [".gitignore"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "239",
    name = "GitIgnore",
  },
  [".gitlab-ci.yml"] = {
    icon = "",
    color = "#e24329",
    cterm_color = "196",
    name = "GitlabCI",
  },
  [".gitmodules"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "239",
    name = "GitModules",
  },
  [".gvimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "28",
    name = "Gvimrc",
  },
  [".npmignore"] = {
    icon = "",
    color = "#E8274B",
    cterm_color = "197",
    name = "NPMIgnore",
  },
  [".npmrc"] = {
    icon = "",
    color = "#E8274B",
    cterm_color = "197",
    name = "NPMrc",
  },
  [".settings.json"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "SettingsJson",
  },
  [".vimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "28",
    name = "Vimrc",
  },
  [".zprofile"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshprofile",
  },
  [".zshenv"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshenv",
  },
  [".zshrc"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshrc",
  },
  ["brewfile"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Brewfile",
  },
  ["cmakelists.txt"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "CMakeLists",
  },
  ["commit_editmsg"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "239",
    name = "GitCommit",
  },
  ["containerfile"] = {
    icon = "󰡨",
    color = "#458ee6",
    cterm_color = "68",
    name = "Dockerfile",
  },
  ["copying"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  ["copying.lesser"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  ["docker-compose.yml"] = {
    icon = "󰡨",
    color = "#458ee6",
    cterm_color = "68",
    name = "Dockerfile",
  },
  ["docker-compose.yaml"] = {
    icon = "󰡨",
    color = "#458ee6",
    cterm_color = "68",
    name = "Dockerfile",
  },
  [".dockerignore"] = {
    icon = "󰡨",
    color = "#458ee6",
    cterm_color = "68",
    name = "Dockerfile",
  },
  ["gemfile$"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Gemfile",
  },
  ["license"] = {
    icon = "",
    color = "#d0bf41",
    cterm_color = "185",
    name = "License",
  },
  ["r"] = {
    icon = "󰟔",
    color = "#358a5b",
    cterm_color = "29",
    name = "R",
  },
  ["rmd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Rmd",
  },
  ["vagrantfile$"] = {
    icon = "",
    color = "#1563FF",
    cterm_color = "27",
    name = "Vagrantfile",
  },
  ["_gvimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "28",
    name = "Gvimrc",
  },
  ["_vimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "28",
    name = "Vimrc",
  },
  ["package.json"] = {
    icon = "",
    color = "#e8274b",
    name = "PackageJson",
  },
  ["package-lock.json"] = {
    icon = "",
    color = "#7a0d21",
    name = "PackageLockJson",
  },
  ["node_modules"] = {
    icon = "",
    color = "#E8274B",
    cterm_color = "197",
    name = "NodeModules",
  },
  ["favicon.ico"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Favicon",
  },
  ["gnumakefile"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Makefile",
  },
  ["makefile"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Makefile",
  },
  ["mix.lock"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "MixLock",
  },
  [".env"] = {
    icon = "",
    color = "#faf743",
    cterm_color = "227",
    name = "Env",
  },
  ["gruntfile"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "166",
    name = "Gruntfile",
  },
  ["gulpfile"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Gulpfile",
  },
  ["webpack"] = {
    icon = "󰜫",
    color = "#519aba",
    cterm_color = "74",
    name = "Webpack",
  },
  ["rakefile"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rakefile",
  },
  ["procfile"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Procfile",
  },
  ["dockerfile"] = {
    icon = "󰡨",
    color = "#458ee6",
    cterm_color = "68",
    name = "Dockerfile",
  },
  ["build"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "BazelBuild",
  },
  ["workspace"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "BazelWorkspace",
  },
  ["unlicense"] = {
    icon = "",
    color = "#d0bf41",
    cterm_color = "185",
    name = "License",
  },
}

-- fuzzy match by extension
local icons_by_file_extension = {
  ["ai"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ai",
  },
  ["awk"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "240",
    name = "Awk",
  },
  ["bash"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Bash",
  },
  ["bat"] = {
    icon = "",
    color = "#C1F12E",
    cterm_color = "191",
    name = "Bat",
  },
  ["bazel"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Bazel",
  },
  ["bzl"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Bzl",
  },
  ["bmp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Bmp",
  },
  ["c"] = {
    icon = "",
    color = "#599eff",
    cterm_color = "111",
    name = "C",
  },
  ["c++"] = {
    icon = "",
    color = "#f34b7d",
    cterm_color = "204",
    name = "CPlusPlus",
  },
  ["cbl"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cc"] = {
    icon = "",
    color = "#f34b7d",
    cterm_color = "204",
    name = "CPlusPlus",
  },
  ["cfg"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "255",
    name = "Configuration",
  },
  ["cjs"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Cjs",
  },
  ["clj"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "113",
    name = "Clojure",
  },
  ["cljc"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "113",
    name = "ClojureC",
  },
  ["cljs"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "ClojureJS",
  },
  ["cljd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "ClojureDart",
  },
  ["cmake"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "CMake",
  },
  ["cob"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cobol"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["coffee"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Coffee",
  },
  ["conf"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Conf",
  },
  ["config.ru"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "ConfigRu",
  },
  ["cp"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Cp",
  },
  ["cpp"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Cpp",
  },
  ["cpy"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cr"] = {
    icon = "",
    color = "#c8c8c8",
    cterm_color = "251",
    name = "Crystal",
  },
  ["cs"] = {
    icon = "󰌛",
    color = "#596706",
    cterm_color = "58",
    name = "Cs",
  },
  ["csh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "240",
    name = "Csh",
  },
  ["cson"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Cson",
  },
  ["css"] = {
    icon = "",
    color = "#42a5f5",
    cterm_color = "75",
    name = "Css",
  },
  ["csv"] = {
    icon = "󰈙",
    color = "#89e051",
    cterm_color = "113",
    name = "Csv",
  },
  ["cxx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Cxx",
  },
  ["d"] = {
    icon = "",
    color = "#427819",
    cterm_color = "28",
    name = "D",
  },
  ["dart"] = {
    icon = "",
    color = "#03589C",
    cterm_color = "25",
    name = "Dart",
  },
  ["db"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Db",
  },
  ["desktop"] = {
    icon = "",
    color = "#563d7c",
    cterm_color = "54",
    name = "DesktopEntry",
  },
  ["diff"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "239",
    name = "Diff",
  },
  ["doc"] = {
    icon = "󰈬",
    color = "#185abd",
    cterm_color = "26",
    name = "Doc",
  },
  ["docx"] = {
    icon = "󰈬",
    color = "#185abd",
    cterm_color = "26",
    name = "Docx",
  },
  ["drl"] = {
    icon = "",
    color = "#ffafaf",
    cterm_color = "217",
    name = "Drools",
  },
  ["dropbox"] = {
    icon = "",
    color = "#0061FE",
    cterm_color = "27",
    name = "Dropbox",
  },
  ["dump"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Dump",
  },
  ["edn"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Edn",
  },
  ["eex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Eex",
  },
  ["ejs"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ejs",
  },
  ["elm"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Elm",
  },
  ["epp"] = {
    icon = "",
    color = "#FFA61A",
    name = "Epp",
  },
  ["erb"] = {
    icon = "",
    color = "#701516",
    cterm_color = "214",
    name = "Erb",
  },
  ["erl"] = {
    icon = "",
    color = "#B83998",
    cterm_color = "163",
    name = "Erl",
  },
  ["ex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Ex",
  },
  ["exs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Exs",
  },
  ["f#"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Fsharp",
  },
  ["f90"] = {
    icon = "󱈚",
    color = "#734f96",
    cterm_color = "97",
    name = "Fortran",
  },
  ["fnl"] = {
    color = "#fff3d7",
    icon = "🌜",
    cterm_color = "230",
    name = "Fennel",
  },
  ["fish"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "240",
    name = "Fish",
  },
  ["fs"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Fs",
  },
  ["fsi"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Fsi",
  },
  ["fsscript"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Fsscript",
  },
  ["fsx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Fsx",
  },
  ["gd"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "GDScript",
  },
  ["gemspec"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Gemspec",
  },
  ["gif"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Gif",
  },
  ["git"] = {
    icon = "",
    color = "#F14C28",
    cterm_color = "196",
    name = "GitLogo",
  },
  ["glb"] = {
    icon = "",
    color = "#FFB13B",
    cterm_color = "214",
    name = "BinaryGLTF",
  },
  ["go"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Go",
  },
  ["godot"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "GodotProject",
  },
  ["graphql"] = {
    icon = "",
    color = "#e535ab",
    cterm_color = "199",
    name = "GraphQL",
  },
  ["gql"] = {
    icon = "",
    color = "#e535ab",
    cterm_color = "199",
    name = "GraphQL",
  },
  ["h"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "H",
  },
  ["haml"] = {
    icon = "",
    color = "#eaeae1",
    cterm_color = "255",
    name = "Haml",
  },
  ["hbs"] = {
    icon = "",
    color = "#f0772b",
    cterm_color = "202",
    name = "Hbs",
  },
  ["heex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Heex",
  },
  ["hh"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hh",
  },
  ["hpp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hpp",
  },
  ["hrl"] = {
    icon = "",
    color = "#B83998",
    cterm_color = "163",
    name = "Hrl",
  },
  ["hs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hs",
  },
  ["htm"] = {
    icon = "",
    color = "#e34c26",
    cterm_color = "196",
    name = "Htm",
  },
  ["html"] = {
    icon = "",
    color = "#e44d26",
    cterm_color = "196",
    name = "Html",
  },
  ["hxx"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hxx",
  },
  ["ico"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ico",
  },
  ["import"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "255",
    name = "ImportConfiguration",
  },
  ["ini"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Ini",
  },
  ["java"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Java",
  },
  ["jl"] = {
    icon = "",
    color = "#a270ba",
    cterm_color = "133",
    name = "Jl",
  },
  ["jpeg"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Jpeg",
  },
  ["jpg"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Jpg",
  },
  ["js"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Js",
  },
  ["test.js"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "TestJs",
  },
  ["spec.js"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "SpecJs",
  },
  ["json"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Json",
  },
  ["json5"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Json5",
  },
  ["jsx"] = {
    icon = "",
    color = "#20c2e3",
    cterm_color = "45",
    name = "Jsx",
  },
  ["test.jsx"] = {
    icon = "",
    color = "#20c2e3",
    cterm_color = "45",
    name = "JavaScriptReactTest",
  },
  ["spec.jsx"] = {
    icon = "",
    color = "#20c2e3",
    cterm_color = "45",
    name = "JavaScriptReactSpec",
  },
  ["ksh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "240",
    name = "Ksh",
  },
  ["kt"] = {
    icon = "",
    color = "#7F52FF",
    cterm_color = "99",
    name = "Kotlin",
  },
  ["kts"] = {
    icon = "",
    color = "#7F52FF",
    cterm_color = "99",
    name = "KotlinScript",
  },
  ["leex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Leex",
  },
  ["less"] = {
    icon = "",
    color = "#563d7c",
    cterm_color = "54",
    name = "Less",
  },
  ["lhs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Lhs",
  },
  ["license"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  ["lua"] = {
    icon = "",
    color = "#51a0cf",
    cterm_color = "74",
    name = "Lua",
  },
  ["luau"] = {
    icon = "",
    color = "#51a0cf",
    cterm_color = "74",
    name = "Luau",
  },
  ["gnumakefile"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Makefile",
  },
  ["makefile"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Makefile",
  },
  ["mk"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Makefile",
  },
  ["markdown"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Markdown",
  },
  ["material"] = {
    icon = "󰔉",
    color = "#B83998",
    cterm_color = "163",
    name = "Material",
  },
  ["md"] = {
    icon = "",
    color = "#ffffff",
    cterm_color = "231",
    name = "Md",
  },
  ["mdx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Mdx",
  },
  ["mint"] = {
    icon = "󰌪",
    color = "#87c095",
    cterm_color = "108",
    name = "Mint",
  },
  ["mjs"] = {
    icon = "",
    color = "#f1e05a",
    cterm_color = "185",
    name = "Mjs",
  },
  ["ml"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "166",
    name = "Ml",
  },
  ["mli"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "166",
    name = "Mli",
  },
  ["mo"] = {
    icon = "∞",
    color = "#9772FB",
    cterm_color = "135",
    name = "Motoko",
  },
  ["mustache"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "166",
    name = "Mustache",
  },
  ["nim"] = {
    icon = "",
    color = "#f3d400",
    cterm_color = "220",
    name = "Nim",
  },
  ["nix"] = {
    icon = "",
    color = "#7ebae4",
    cterm_color = "110",
    name = "Nix",
  },
  ["opus"] = {
    icon = "󰈣",
    color = "#F88A02",
    cterm_color = "208",
    name = "OPUS",
  },
  ["org"] = {
    icon = "",
    color = "#77AA99",
    cterm_color = "73",
    name = "OrgMode",
  },
  ["otf"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "255",
    name = "OpenTypeFont",
  },
  ["pck"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "PackedResource",
  },
  ["pdf"] = {
    icon = "",
    color = "#b30b00",
    cterm_color = "124",
    name = "Pdf",
  },
  ["php"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Php",
  },
  ["pl"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Pl",
  },
  ["pm"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Pm",
  },
  ["png"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Png",
  },
  ["pp"] = {
    icon = "",
    color = "#FFA61A",
    name = "Pp",
  },
  ["ppt"] = {
    icon = "󰈧",
    color = "#cb4a32",
    cterm_color = "214",
    name = "Ppt",
  },
  ["pro"] = {
    icon = "",
    color = "#e4b854",
    cterm_color = "179",
    name = "Prolog",
  },
  ["ps1"] = {
    icon = "󰨊",
    color = "#4273ca",
    cterm_color = "68",
    name = "PsScriptfile",
  },
  ["psd1"] = {
    icon = "󰨊",
    color = "#6975c4",
    cterm_color = "68",
    name = "PsManifestfile",
  },
  ["psm1"] = {
    icon = "󰨊",
    color = "#6975c4",
    cterm_color = "68",
    name = "PsScriptModulefile",
  },
  ["psb"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Psb",
  },
  ["psd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Psd",
  },
  ["py"] = {
    icon = "",
    color = "#ffbc03",
    cterm_color = "214",
    name = "Py",
  },
  ["pyc"] = {
    icon = "",
    color = "#ffe291",
    cterm_color = "222",
    name = "Pyc",
  },
  ["pyd"] = {
    icon = "",
    color = "#ffe291",
    cterm_color = "222",
    name = "Pyd",
  },
  ["pyo"] = {
    icon = "",
    color = "#ffe291",
    cterm_color = "222",
    name = "Pyo",
  },
  ["query"] = {
    icon = "",
    color = "#90a850",
    cterm_color = "107",
    name = "Query",
  },
  ["r"] = {
    icon = "󰟔",
    color = "#358a5b",
    cterm_color = "29",
    name = "R",
  },
  ["rake"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rake",
  },
  ["rb"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rb",
  },
  ["res"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "ReScript",
  },
  ["resi"] = {
    icon = "",
    color = "#f55385",
    cterm_color = "204",
    name = "ReScriptInterface",
  },
  ["rlib"] = {
    icon = "",
    color = "#dea584",
    cterm_color = "216",
    name = "Rlib",
  },
  ["rmd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Rmd",
  },
  ["rproj"] = {
    icon = "󰗆",
    color = "#358a5b",
    cterm_color = "29",
    name = "Rproj",
  },
  ["rs"] = {
    icon = "",
    color = "#dea584",
    cterm_color = "216",
    name = "Rs",
  },
  ["rss"] = {
    icon = "",
    color = "#FB9D3B",
    cterm_color = "215",
    name = "Rss",
  },
  ["sass"] = {
    icon = "",
    color = "#f55385",
    cterm_color = "204",
    name = "Sass",
  },
  ["sbt"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "sbt",
  },
  ["scala"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Scala",
  },
  ["scm"] = {
    icon = "󰘧",
    color = "#000000",
    cterm_color = "16",
    name = "Scheme",
  },
  ["scss"] = {
    icon = "",
    color = "#f55385",
    cterm_color = "204",
    name = "Scss",
  },
  ["sh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "240",
    name = "Sh",
  },
  ["sig"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "166",
    name = "Sig",
  },
  ["slim"] = {
    icon = "",
    color = "#e34c26",
    cterm_color = "196",
    name = "Slim",
  },
  ["sln"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "Sln",
  },
  ["sml"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "166",
    name = "Sml",
  },
  ["sql"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Sql",
  },
  ["sqlite"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Sql",
  },
  ["sqlite3"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Sql",
  },
  ["styl"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "113",
    name = "Styl",
  },
  ["sublime"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "166",
    name = "Suo",
  },
  ["suo"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "Suo",
  },
  ["sv"] = {
    icon = "󰍛",
    color = "#019833",
    cterm_color = "28",
    name = "SystemVerilog",
  },
  ["svelte"] = {
    icon = "",
    color = "#ff3e00",
    cterm_color = "196",
    name = "Svelte",
  },
  ["svh"] = {
    icon = "󰍛",
    color = "#019833",
    cterm_color = "28",
    name = "SystemVerilog",
  },
  ["svg"] = {
    icon = "󰜡",
    color = "#FFB13B",
    cterm_color = "214",
    name = "Svg",
  },
  ["swift"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "166",
    name = "Swift",
  },
  ["t"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Tor",
  },
  ["tbc"] = {
    icon = "󰛓",
    color = "#1e5cb3",
    cterm_color = "25",
    name = "Tcl",
  },
  ["tcl"] = {
    icon = "󰛓",
    color = "#1e5cb3",
    cterm_color = "25",
    name = "Tcl",
  },
  ["terminal"] = {
    icon = "",
    color = "#31B53E",
    cterm_color = "34",
    name = "Terminal",
  },
  ["tex"] = {
    icon = "󰙩",
    color = "#3D6117",
    cterm_color = "22",
    name = "Tex",
  },
  ["tf"] = {
    icon = "",
    color = "#5F43E9",
    cterm_color = "93",
    name = "Terraform",
  },
  ["tfvars"] = {
    icon = "",
    color = "#5F43E9",
    cterm_color = "93",
    name = "TFVars",
  },
  ["toml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Toml",
  },
  ["tres"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "TextResource",
  },
  ["ts"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "Ts",
  },
  ["test.ts"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "TestTs",
  },
  ["spec.ts"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "74",
    name = "SpecTs",
  },
  ["tscn"] = {
    icon = "󰎁",
    color = "#a074c4",
    cterm_color = "140",
    name = "TextScene",
  },
  ["tsx"] = {
    icon = "",
    color = "#1354bf",
    cterm_color = "26",
    name = "Tsx",
  },
  ["test.tsx"] = {
    icon = "",
    color = "#1354bf",
    cterm_color = "26",
    name = "TypeScriptReactTest",
  },
  ["spec.tsx"] = {
    icon = "",
    color = "#1354bf",
    cterm_color = "26",
    name = "TypeScriptReactSpec",
  },
  ["twig"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "113",
    name = "Twig",
  },
  ["txt"] = {
    icon = "󰈙",
    color = "#89e051",
    cterm_color = "113",
    name = "Txt",
  },
  ["v"] = {
    icon = "󰍛",
    color = "#019833",
    cterm_color = "28",
    name = "Verilog",
  },
  ["vala"] = {
    icon = "",
    color = "#7239b3",
    cterm_color = "91",
    name = "Vala",
  },
  ["vh"] = {
    icon = "󰍛",
    color = "#019833",
    cterm_color = "28",
    name = "Verilog",
  },
  ["vhd"] = {
    icon = "󰍛",
    color = "#019833",
    cterm_color = "28",
    name = "VHDL",
  },
  ["vhdl"] = {
    icon = "󰍛",
    color = "#019833",
    cterm_color = "28",
    name = "VHDL",
  },
  ["vim"] = {
    icon = "",
    color = "#019833",
    cterm_color = "28",
    name = "Vim",
  },
  ["vue"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "113",
    name = "Vue",
  },
  ["webmanifest"] = {
    icon = "",
    color = "#f1e05a",
    cterm_color = "185",
    name = "Webmanifest",
  },
  ["webp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Webp",
  },
  ["webpack"] = {
    icon = "󰜫",
    color = "#519aba",
    cterm_color = "74",
    name = "Webpack",
  },
  ["xcplayground"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "166",
    name = "XcPlayground",
  },
  ["xls"] = {
    icon = "󰈛",
    color = "#207245",
    cterm_color = "29",
    name = "Xls",
  },
  ["xlsx"] = {
    icon = "󰈛",
    color = "#207245",
    cterm_color = "29",
    name = "Xlsx",
  },
  ["xml"] = {
    icon = "󰗀",
    color = "#e37933",
    cterm_color = "166",
    name = "Xml",
  },
  ["xul"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "166",
    name = "Xul",
  },
  ["yaml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Yaml",
  },
  ["yml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Yml",
  },
  ["zig"] = {
    icon = "",
    color = "#f69a1b",
    cterm_color = "172",
    name = "Zig",
  },
  ["zsh"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zsh",
  },
  ["sol"] = {
    icon = "󰞻",
    color = "#519aba",
    cterm_color = "74",
    name = "Solidity",
  },
  ["prisma"] = {
    icon = "󰔶",
    color = "#ffffff",
    cterm_color = "231",
    name = "Prisma",
  },
  ["lock"] = {
    icon = "",
    color = "#bbbbbb",
    cterm_color = "250",
    name = "Lock",
  },
  ["log"] = {
    icon = "󰌱",
    color = "#ffffff",
    cterm_color = "231",
    name = "Log",
  },
  ["wasm"] = {
    icon = "",
    color = "#5c4cdb",
    cterm_color = "62",
    name = "Wasm",
  },
  ["liquid"] = {
    icon = "",
    color = "#95BF47",
    cterm_color = "106",
    name = "Liquid",
  },
}

-- When adding new icons, remember to add an entry to the `filetypes` table, if applicable.
local icons

-- Set the current icons tables, depending on the 'background' option.
local function refresh_icons()
  local by_filename, by_file_extension
  if vim.o.background == "light" then
    by_filename = require("nvim-web-devicons-light").icons_by_filename
    by_file_extension = require("nvim-web-devicons-light").icons_by_file_extension
  else
    by_filename = icons_by_filename
    by_file_extension = icons_by_file_extension
  end
  icons = vim.tbl_extend("keep", {}, by_filename, by_file_extension)
end

-- Map of filetypes -> icon names
local filetypes = {
  ["bzl"] = "bzl",
  ["brewfile"] = "brewfile",
  ["commit"] = "commit_editmsg",
  ["copying"] = "copying",
  ["gemfile"] = "gemfile$",
  ["lesser"] = "copying.lesser",
  ["vagrantfile"] = "vagrantfile$",
  ["awk"] = "awk",
  ["bmp"] = "bmp",
  ["c"] = "c",
  ["cfg"] = "cfg",
  ["clojure"] = "clj",
  ["cmake"] = "cmake",
  ["cobol"] = "cobol",
  ["coffee"] = "coffee",
  ["conf"] = "conf",
  ["cp"] = "cp",
  ["cpp"] = "cpp",
  ["cr"] = "cr",
  ["cs"] = "cs",
  ["csh"] = "csh",
  ["cson"] = "cson",
  ["css"] = "css",
  ["csv"] = "csv",
  ["d"] = "d",
  ["dart"] = "dart",
  ["desktop"] = "desktop",
  ["diff"] = "diff",
  ["doc"] = "doc",
  ["docx"] = "docx",
  ["dockerfile"] = "dockerfile",
  ["dosbatch"] = "bat",
  ["dosini"] = "ini",
  ["drools"] = "drl",
  ["dropbox"] = "dropbox",
  ["dump"] = "dump",
  ["eex"] = "eex",
  ["ejs"] = "ejs",
  ["elixir"] = "ex",
  ["elm"] = "elm",
  ["epuppet"] = "epp",
  ["erlang"] = "erl",
  ["eruby"] = "erb",
  ["fennel"] = "fnl",
  ["fish"] = "fish",
  ["forth"] = "fs",
  ["fortran"] = "f90",
  ["fsharp"] = "f#",
  ["fsi"] = "fsi",
  ["fsscript"] = "fsscript",
  ["fsx"] = "fsx",
  ["gd"] = "gd",
  ["gif"] = "gif",
  ["git"] = "git",
  ["gitconfig"] = ".gitconfig",
  ["gitcommit"] = "commit_editmsg",
  ["gitignore"] = ".gitignore",
  ["gitattributes"] = ".gitattributes",
  ["glb"] = "glb",
  ["go"] = "go",
  ["godot"] = "godot",
  ["graphql"] = "graphql",
  ["gql"] = "gql",
  ["gruntfile"] = "gruntfile",
  ["gulpfile"] = "gulpfile",
  ["haml"] = "haml",
  ["haskell"] = "hs",
  ["hbs"] = "hbs",
  ["heex"] = "heex",
  ["html"] = "html",
  ["ico"] = "ico",
  ["idlang"] = "pro",
  ["import"] = "import",
  ["java"] = "java",
  ["javascript"] = "js",
  ["javascript.jsx"] = "jsx",
  ["javascriptreact"] = "jsx",
  ["jpeg"] = "jpeg",
  ["jpg"] = "jpg",
  ["json"] = "json",
  ["json5"] = "json5",
  ["julia"] = "jl",
  ["kotlin"] = "kt",
  ["leex"] = "leex",
  ["less"] = "less",
  ["liquid"] = "liquid",
  ["lhaskell"] = "lhs",
  ["license"] = "license",
  ["unlicense"] = "unlicense",
  ["log"] = "log",
  ["lock"] = "lock",
  ["lprolog"] = "sig",
  ["lua"] = "lua",
  ["make"] = "makefile",
  ["markdown"] = "markdown",
  ["material"] = "material",
  ["mdx"] = "mdx",
  ["mint"] = "mint",
  ["motoko"] = "mo",
  ["mustache"] = "mustache",
  ["nim"] = "nim",
  ["nix"] = "nix",
  ["node"] = "node_modules",
  ["ocaml"] = "ml",
  ["opus"] = "opus",
  ["otf"] = "otf",
  ["pck"] = "pck",
  ["pdf"] = "pdf",
  ["perl"] = "pl",
  ["php"] = "php",
  ["plaintex"] = "tex",
  ["png"] = "png",
  ["postscr"] = "ai",
  ["ppt"] = "ppt",
  ["prisma"] = "prisma",
  ["procfile"] = "procfile",
  ["prolog"] = "pro",
  ["ps1"] = "ps1",
  ["psd1"] = "psd1",
  ["psm1"] = "psm1",
  ["psb"] = "psb",
  ["psd"] = "psd",
  ["puppet"] = "pp",
  ["pyc"] = "pyc",
  ["pyd"] = "pyd",
  ["pyo"] = "pyo",
  ["python"] = "py",
  ["query"] = "query",
  ["r"] = "r",
  ["res"] = "rescript",
  ["resi"] = "rescript",
  ["rlib"] = "rlib",
  ["rmd"] = "rmd",
  ["rproj"] = "rproj",
  ["ruby"] = "rb",
  ["rust"] = "rs",
  ["sass"] = "sass",
  ["sbt"] = "sbt",
  ["scala"] = "scala",
  ["scheme"] = "scm",
  ["scss"] = "scss",
  ["sh"] = "sh",
  ["slim"] = "slim",
  ["sln"] = "sln",
  ["sml"] = "sml",
  ["solidity"] = "sol",
  ["sql"] = "sql",
  ["sqlite"] = "sqlite",
  ["sqlite3"] = "sqlite3",
  ["styl"] = "styl",
  ["sublime"] = "sublime",
  ["suo"] = "suo",
  ["svelte"] = "svelte",
  ["svg"] = "svg",
  ["swift"] = "swift",
  ["systemverilog"] = "sv",
  ["tads"] = "t",
  ["tcl"] = "tcl",
  ["terminal"] = "terminal",
  ["tex"] = "tex",
  ["toml"] = "toml",
  ["tres"] = "tres",
  ["tscn"] = "tscn",
  ["twig"] = "twig",
  ["txt"] = "txt",
  ["typescript"] = "ts",
  ["typescriptreact"] = "tsx",
  ["vala"] = "vala",
  ["verilog"] = "v",
  ["vhdl"] = "vhd",
  ["vim"] = "vim",
  ["vue"] = "vue",
  ["wasm"] = "wasm",
  ["webp"] = "webp",
  ["webpack"] = "webpack",
  ["xcplayground"] = "xcplayground",
  ["xls"] = "xls",
  ["xlsx"] = "xlsx",
  ["xml"] = "xml",
  ["yaml"] = "yaml",
  ["zig"] = "zig",
  ["zsh"] = "zsh",
}

local default_icon = {
  icon = "",
  color = "#6d8086",
  cterm_color = "66",
  name = "Default",
}

local global_opts = {
  override = {},
  strict = false,
  default = false,
  color_icons = true,
}

local function get_highlight_name(data)
  if not global_opts.color_icons then
    data = default_icon
  end

  return data.name and "DevIcon" .. data.name
end

local nvim_set_hl = vim.api.nvim_set_hl
local function set_up_highlight(icon_data)
  if not global_opts.color_icons then
    icon_data = default_icon
  end

  local hl_group = get_highlight_name(icon_data)
  if hl_group and (icon_data.color or icon_data.cterm_color) then
    nvim_set_hl(0, get_highlight_name(icon_data), {
      fg = icon_data.color,
      ctermfg = tonumber(icon_data.cterm_color),
    })
  end
end

local nvim_get_hl_by_name = vim.api.nvim_get_hl_by_name
local function highlight_exists(group)
  if not group then
    return
  end

  local ok, hl = pcall(nvim_get_hl_by_name, group, true)
  return ok and not (hl or {})[true]
end

local function set_up_highlights(allow_override)
  if not global_opts.color_icons then
    set_up_highlight(default_icon)
    return
  end

  for _, icon_data in pairs(icons) do
    local has_color = icon_data.color or icon_data.cterm_color
    local name_valid = icon_data.name
    local defined_before = highlight_exists(get_highlight_name(icon_data))
    if has_color and name_valid and (allow_override or not defined_before) then
      set_up_highlight(icon_data)
    end
  end
end

local function get_highlight_foreground(icon_data)
  if not global_opts.color_icons then
    icon_data = default_icon
  end

  return string.format("#%06x", nvim_get_hl_by_name(get_highlight_name(icon_data), true).foreground)
end

local function get_highlight_ctermfg(icon_data)
  if not global_opts.color_icons then
    icon_data = default_icon
  end

  return nvim_get_hl_by_name(get_highlight_name(icon_data), false).foreground
end

local loaded = false

local if_nil = vim.F.if_nil
local function setup(opts)
  if loaded then
    return
  end

  loaded = true

  local user_icons = opts or {}

  if user_icons.default then
    global_opts.default = true
  end

  if user_icons.strict then
    global_opts.strict = true
  end

  global_opts.color_icons = if_nil(user_icons.color_icons, global_opts.color_icons)

  if user_icons.override and user_icons.override.default_icon then
    default_icon = user_icons.override.default_icon
  end

  local user_filename_icons = user_icons.override_by_filename
  local user_file_ext_icons = user_icons.override_by_extension

  icons =
    vim.tbl_extend("force", icons, user_icons.override or {}, user_filename_icons or {}, user_file_ext_icons or {})

  if user_filename_icons then
    icons_by_filename = vim.tbl_extend("force", icons_by_filename, user_filename_icons)
  end
  if user_file_ext_icons then
    icons_by_file_extension = vim.tbl_extend("force", icons_by_file_extension, user_file_ext_icons)
  end

  table.insert(icons, default_icon)

  set_up_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Re-apply icon colors after changing colorschemes",
    group = vim.api.nvim_create_augroup("NvimWebDevicons", { clear = true }),
    callback = set_up_highlights,
  })
end

local function get_default_icon()
  return default_icon
end

-- recursively iterate over each segment separated by '.' to parse extension with multiple dots in filename
local function iterate_multi_dotted_extension(name, icon_table)
  if name == nil then
    return nil
  end

  local compound_ext = name:match "%.(.*)"
  local icon = icon_table[compound_ext]
  if icon then
    return icon
  end

  return iterate_multi_dotted_extension(compound_ext, icon_table)
end

local function get_icon_by_extension(name, ext, opts)
  local is_strict = if_nil(opts and opts.strict, global_opts.strict)
  local icon_table = is_strict and icons_by_file_extension or icons

  if ext ~= nil then
    return icon_table[ext]
  end

  return iterate_multi_dotted_extension(name, icon_table)
end

local function get_icon(name, ext, opts)
  if type(name) == "string" then
    name = name:lower()
  end

  if not loaded then
    setup()
  end

  local has_default = if_nil(opts and opts.default, global_opts.default)
  local is_strict = if_nil(opts and opts.strict, global_opts.strict)
  local icon_data
  if is_strict then
    icon_data = icons_by_filename[name] or get_icon_by_extension(name, ext, opts) or (has_default and default_icon)
  else
    icon_data = icons[name] or get_icon_by_extension(name, ext, opts) or (has_default and default_icon)
  end

  if icon_data then
    return icon_data.icon, get_highlight_name(icon_data)
  end
end

local function get_icon_name_by_filetype(ft)
  return filetypes[ft]
end

local function get_icon_by_filetype(ft, opts)
  local name = get_icon_name_by_filetype(ft)
  opts = opts or {}
  opts.strict = false
  return get_icon(name or "", nil, opts)
end

local function get_icon_colors(name, ext, opts)
  if not loaded then
    setup()
  end

  local has_default = if_nil(opts and opts.default, global_opts.default)
  local is_strict = if_nil(opts and opts.strict, global_opts.strict)
  local icon_data
  if is_strict then
    icon_data = icons_by_filename[name] or get_icon_by_extension(name, ext, opts) or (has_default and default_icon)
  else
    icon_data = icons[name] or get_icon_by_extension(name, ext, opts) or (has_default and default_icon)
  end

  if icon_data then
    local color = icon_data.color
    local cterm_color = icon_data.cterm_color
    if icon_data.name and highlight_exists(get_highlight_name(icon_data)) then
      color = get_highlight_foreground(icon_data) or color
      cterm_color = get_highlight_ctermfg(icon_data) or cterm_color
    end
    return icon_data.icon, color, cterm_color
  end
end

local function get_icon_colors_by_filetype(ft, opts)
  local name = get_icon_name_by_filetype(ft)
  return get_icon_colors(name or "", nil, opts)
end

local function get_icon_color(name, ext, opts)
  local data = { get_icon_colors(name, ext, opts) }
  return data[1], data[2]
end

local function get_icon_color_by_filetype(ft, opts)
  local name = get_icon_name_by_filetype(ft)
  opts = opts or {}
  opts.strict = false
  return get_icon_color(name or "", nil, opts)
end

local function get_icon_cterm_color(name, ext, opts)
  local data = { get_icon_colors(name, ext, opts) }
  return data[1], data[3]
end

local function get_icon_cterm_color_by_filetype(ft, opts)
  local name = get_icon_name_by_filetype(ft)
  return get_icon_cterm_color(name or "", nil, opts)
end

local function set_icon(user_icons)
  icons = vim.tbl_extend("force", icons, user_icons or {})
  if not global_opts.color_icons then
    return
  end

  for _, icon_data in pairs(user_icons) do
    set_up_highlight(icon_data)
  end
end

local function set_default_icon(icon, color, cterm_color)
  default_icon.icon = icon
  default_icon.color = color
  default_icon.cterm_color = cterm_color
  set_up_highlight(default_icon)
end

-- Load the icons already, the loaded tables depend on the 'background' setting.
refresh_icons()

-- Change icon set on background change
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    refresh_icons()
    set_up_highlights(true) -- Force update highlights
  end,
})

return {
  get_icon = get_icon,
  get_icon_colors = get_icon_colors,
  get_icon_color = get_icon_color,
  get_icon_cterm_color = get_icon_cterm_color,
  get_icon_name_by_filetype = get_icon_name_by_filetype,
  get_icon_by_filetype = get_icon_by_filetype,
  get_icon_colors_by_filetype = get_icon_colors_by_filetype,
  get_icon_color_by_filetype = get_icon_color_by_filetype,
  get_icon_cterm_color_by_filetype = get_icon_cterm_color_by_filetype,
  set_icon = set_icon,
  set_default_icon = set_default_icon,
  get_default_icon = get_default_icon,
  setup = setup,
  has_loaded = function()
    return loaded
  end,
  get_icons = function()
    return icons
  end,
  set_up_highlights = set_up_highlights,
}
