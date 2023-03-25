# Plantuml Previewer Vim

Vim/NeoVim plugin for preview [PlantUML](http://plantuml.com/)

![image](https://user-images.githubusercontent.com/1709861/40650003-dcd75a76-6364-11e8-8cb1-40d710a0cc0a.png)

## Dependencies

- Java
- Graphviz (https://www.graphviz.org/download/)
  - brew install graphviz
  - apt-get install graphviz
- [open-browser.vim](https://github.com/tyru/open-browser.vim)
- [aklt/plantuml-syntax](https://github.com/aklt/plantuml-syntax) (vim syntax file for plantuml)

## Usage

1. Start editing plantuml file in Vim
2. Run `:PlantumlOpen` to open previewer webpage in browser
3. Saving plantuml file in Vim, then previewer webpage will refresh

### Commands

#### PlantumlOpen

Open previewer webpage in browser, and watch current buffer

#### PlantumlStart

Like `PlantumlOpen`, but won't open in browser

#### PlantumlStop

Stop watch buffer

#### PlantumlSave [filepath] [format]

Export uml diagram to file path  
Available formats

> png, svg, eps, pdf, vdx, xmi,
> scxml, html, txt, utxt, latex

Example:

```
:e diagram.puml

:PlantumlSave
:PlantumlSave diagram.png
:PlantumlSave diagram.svg
```

### Variables

#### `g:plantuml_previewer#plantuml_jar_path`

Custom plantuml.jar file path

If plant uml was installed by homebrew, you can add the following code to your `.vimrc` to use the version installed by homebrew:

```vim
au FileType plantuml let g:plantuml_previewer#plantuml_jar_path = get(
    \  matchlist(system('cat `which plantuml` | grep plantuml.jar'), '\v.*\s[''"]?(\S+plantuml\.jar).*'),
    \  1,
    \  0
    \)
```

#### `g:plantuml_previewer#save_format`

`:PlantumlSave` default format  
Default: 'png'

#### `g:plantuml_previewer#viewer_path`

Custom plantuml viewer path  
The plugin will copy viewer to here if the directory does not exist  
And `tmp.puml` and `tmp.svg` will output to here

#### `g:plantuml_previewer#debug_mode`

Debug mode  
The plugin will print debug message if this is set to `1`  
Default: 0

## Related

- [vim-slumlord](https://github.com/scrooloose/vim-slumlord)
- [previm](https://github.com/kannokanno/previm)
