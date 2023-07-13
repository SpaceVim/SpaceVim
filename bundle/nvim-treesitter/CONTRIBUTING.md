# Contributing to `nvim-treesitter`

First of all, thank you very much for contributing to `nvim-treesitter`.

If you haven't already, you should really come and reach out to us on our
[Matrix channel], so we can help you with any question you might have!

As you know, `nvim-treesitter` is roughly split in two parts:

- Parser configurations : for various things like `locals`, `highlights`
- What we like to call _modules_ : tiny lua modules that provide a given feature, based on parser configurations

Depending on which part of the plugin you want to contribute to, please read the appropriate section.

## Style Checks and Tests

We haven't implemented any functional tests yet. Feel free to contribute.
However, we check code style with `luacheck` and `stylua`!
Please install luacheck and activate our `pre-push` hook to automatically check style before
every push:

```bash
luarocks install luacheck
cargo install stylua
ln -s ../../scripts/pre-push .git/hooks/pre-push
```

## Adding new modules

If you want to see a new functionality added to `nvim-treesitter` feel free to first open an issue
to that we can track our solution!
Thus far, there is basically two types of modules:

- Little modules (like `incremental selection`) that are built in `nvim-treesitter`, we call them
  `builtin modules`.
- Bigger modules (like `completion-treesitter`, or `nvim-tree-docs`), or modules that integrate
  with other plugins, that we call `remote modules`.

In any case, you can build your own module! To help you started in the process, we have a template
repository designed to build new modules [here](https://github.com/nvim-treesitter/module-template).
Feel free to use it, and contact us over on our
on the "Neovim tree-sitter" [Matrix channel].

## Parser configurations

Contributing to parser configurations is basically modifying one of the `queries/*/*.scm`.
Each of these `scheme` files contains a _tree-sitter query_ for a given purpose.
Before going any further, we highly suggest that you [read more about tree-sitter queries](https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries).

Each query has an appropriate name, which is then used by modules to extract data from the syntax tree.
For now these are the types of queries used by `nvim-treesitter`:

- `highlights.scm`: used for syntax highlighting, using the `highlight` module.
- `locals.scm`: used to extract keyword definitions, scopes, references, etc, using the `locals` module.
- `textobjects.scm`: used to define text objects.
- `folds.scm`: used to define folds.
- `injections.scm`: used to define injections.

For these types there is a _norm_ you will have to follow so that features work fine.
Here are some global advices:

- If your language is listed [here](https://github.com/nvim-treesitter/nvim-treesitter#supported-languages),
  you can install the [playground plugin](https://github.com/nvim-treesitter/playground).
- If your language is listed [here](https://github.com/nvim-treesitter/nvim-treesitter#supported-languages),
  you can debug and experiment with your queries there.
- If not, you should consider installing the [tree-sitter cli](https://github.com/tree-sitter/tree-sitter/tree/master/cli),
  you should then be able to open a local playground using `tree-sitter build-wasm && tree-sitter web-ui` within the
  parsers repo.
- Examples of queries can be found in [queries/](queries/)
- Matches in the bottom will override queries that are above of them.

If your language is an extension of a language (TypeScript is an extension of JavaScript for
example), you can include the queries from your base language by adding the following _as the first
line of your file_.

```query
; inherits: lang1,(optionallang)
```

If you want to inherit a language, but don't want the languages inheriting from yours to inherit it,
you can mark the language as optional (by putting it between parenthesis).

### Highlights

As languages differ quite a lot, here is a set of captures available to you when building a `highlights.scm` query. Note that your colorscheme needs to define (or link) these captures as highlight groups.

#### Misc

```scheme
@comment               ; line and block comments
@comment.documentation ; comments documenting code
@error                 ; syntax/parser errors
@none                  ; completely disable the highlight
@preproc               ; various preprocessor directives & shebangs
@define                ; preprocessor definition directives
@operator              ; symbolic operators (e.g. `+` / `*`)
```

#### Punctuation

```scheme
@punctuation.delimiter ; delimiters (e.g. `;` / `.` / `,`)
@punctuation.bracket   ; brackets (e.g. `()` / `{}` / `[]`)
@punctuation.special   ; special symbols (e.g. `{}` in string interpolation)
```

#### Literals

```scheme
@string               ; string literals
@string.documentation ; string documenting code (e.g. Python docstrings)
@string.regex         ; regular expressions
@string.escape        ; escape sequences
@string.special       ; other special strings (e.g. dates)

@character            ; character literals
@character.special    ; special characters (e.g. wildcards)

@boolean              ; boolean literals
@number               ; numeric literals
@float                ; floating-point number literals
```

#### Functions

```scheme
@function         ; function definitions
@function.builtin ; built-in functions
@function.call    ; function calls
@function.macro   ; preprocessor macros

@method           ; method definitions
@method.call      ; method calls

@constructor      ; constructor calls and definitions
@parameter        ; parameters of a function
```

#### Keywords

```scheme
@keyword             ; various keywords
@keyword.coroutine   ; keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
@keyword.function    ; keywords that define a function (e.g. `func` in Go, `def` in Python)
@keyword.operator    ; operators that are English words (e.g. `and` / `or`)
@keyword.return      ; keywords like `return` and `yield`

@conditional         ; keywords related to conditionals (e.g. `if` / `else`)
@conditional.ternary ; ternary operator (e.g. `?` / `:`)

@repeat              ; keywords related to loops (e.g. `for` / `while`)
@debug               ; keywords related to debugging
@label               ; GOTO and other labels (e.g. `label:` in C)
@include             ; keywords for including modules (e.g. `import` / `from` in Python)
@exception           ; keywords related to exceptions (e.g. `throw` / `catch`)
```

#### Types

```scheme
@type            ; type or class definitions and annotations
@type.builtin    ; built-in types
@type.definition ; type definitions (e.g. `typedef` in C)
@type.qualifier  ; type qualifiers (e.g. `const`)

@storageclass    ; modifiers that affect storage in memory or life-time
@attribute       ; attribute annotations (e.g. Python decorators)
@field           ; object and struct fields
@property        ; similar to `@field`
```

#### Identifiers

```scheme
@variable         ; various variable names
@variable.builtin ; built-in variable names (e.g. `this`)

@constant         ; constant identifiers
@constant.builtin ; built-in constant values
@constant.macro   ; constants defined by the preprocessor

@namespace        ; modules or namespaces
@symbol           ; symbols or atoms
```

#### Text

Mainly for markup languages.

```scheme
@text                  ; non-structured text
@text.strong           ; bold text
@text.emphasis         ; text with emphasis
@text.underline        ; underlined text
@text.strike           ; strikethrough text
@text.title            ; text that is part of a title
@text.quote            ; text quotations
@text.uri              ; URIs (e.g. hyperlinks)
@text.math             ; math environments (e.g. `$ ... $` in LaTeX)
@text.environment      ; text environments of markup languages
@text.environment.name ; text indicating the type of an environment
@text.reference        ; text references, footnotes, citations, etc.

@text.literal          ; literal or verbatim text (e.g., inline code)
@text.literal.block    ; literal or verbatim text as a stand-alone block
                       ; (use priority 90 for blocks with injections)

@text.todo             ; todo notes
@text.note             ; info notes
@text.warning          ; warning notes
@text.danger           ; danger/error notes

@text.diff.add         ; added text (for diff files)
@text.diff.delete      ; deleted text (for diff files)
```

#### Tags

Used for XML-like tags.

```scheme
@tag           ; XML tag names
@tag.attribute ; XML tag attributes
@tag.delimiter ; XML tag delimiters
```

#### Conceal

```scheme
@conceal ; for captures that are only used for concealing
```

`@conceal` must be followed by `(#set! conceal "")`.

#### Spell

```scheme
@spell   ; for defining regions to be spellchecked
@nospell ; for defining regions that should NOT be spellchecked
```

#### Priority

Captures can be assigned a priority to control precedence of highlights via the
`#set! "priority" <number>` directive (see `:h treesitter-highlight-priority`).
The default priority for treesitter highlights is `100`; queries should only
set priorities between `90` and `120`, to avoid conflict with other sources of
highlighting (such as diagnostics or LSP semantic tokens).

### Locals

Note: pay specific attention to the captures here as they are a bit different to
those listed in the upstream [Local Variables
docs](https://tree-sitter.github.io/tree-sitter/syntax-highlighting#local-variables).
Some of these docs didn't exist when `nvim-treesitter` was created and the
upstream captures are more limiting than what we have here.

```scheme
@definition            ; various definitions
@definition.constant   ; constants
@definition.function   ; functions
@definition.method     ; methods
@definition.var        ; variables
@definition.parameter  ; parameters
@definition.macro      ; preprocessor macros
@definition.type       ; types or classes
@definition.field      ; fields or properties
@definition.enum       ; enumerations
@definition.namespace  ; modules or namespaces
@definition.import     ; imported names
@definition.associated ; the associated type of a variable

@scope                 ; scope block
@reference             ; identifier reference
```

#### Definition Scope

You can set the scope of a definition by setting the `scope` property on the definition.

For example, a JavaScript function declaration creates a scope. The function name is captured as the definition.
This means that the function definition would only be available WITHIN the scope of the function, which is not the case.
The definition can be used in the scope the function was defined in.

```javascript
function doSomething() {}

doSomething(); // Should point to the declaration as the definition
```

```query
(function_declaration
  ((identifier) @definition.var)
   (#set! "definition.var.scope" "parent"))
```

Possible scope values are:

- `parent`: The definition is valid in the containing scope and one more scope above that scope
- `global`: The definition is valid in the root scope
- `local`: The definition is valid in the containing scope. This is the default behavior

### Folds

You can define folds for a given language by adding a `folds.scm` query :

```scheme
@fold ; fold this node
```

If the `folds.scm` query is not present, this will fall back to the `@scope` captures in the `locals`
query.

### Injections

Some captures are related to language injection (like markdown code blocks). They are used in `injections.scm`.
You can directly use the name of the language that you want to inject (e.g. `@html` to inject html).

If you want to dynamically detect the language (e.g. for Markdown blocks) use the `@language` to capture
the node describing the language and `@content` to describe the injection region.

```scheme
@{lang}   ; e.g. @html to describe a html region

@language ; dynamic detection of the injection language (i.e. the text of the captured node describes the language)
@content  ; region for the dynamically detected language
@combined ; combine all matches of a pattern as one single block of content
```

### Indents

```scheme
@indent.begin       ; indent children when matching this node
@indent.end         ; marks the end of indented block
@indent.align       ; behaves like python aligned/hanging indent
@indent.dedent      ; dedent children when matching this node
@indent.branch      ; dedent itself when matching this node
@indent.ignore      ; do not indent in this node
@indent.auto        ; behaves like 'autoindent' buffer option
@indent.zero        ; sets this node at position 0 (no indent)
```

[Matrix channel]: https://matrix.to/#/#nvim-treesitter:matrix.org
