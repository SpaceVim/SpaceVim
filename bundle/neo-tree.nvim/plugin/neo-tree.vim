if exists('g:loaded_neo_tree')
  finish
endif
let g:loaded_neo_tree = 1

if !exists('g:neo_tree_remove_legacy_commands')
    command! -nargs=? NeoTreeClose         lua require("neo-tree").close_all("<args>")
    command! -nargs=? NeoTreeFloat         lua require("neo-tree").float("<args>")
    command! -nargs=? NeoTreeFocus         lua require("neo-tree").focus("<args>")
    command! -nargs=? NeoTreeShow          lua require("neo-tree").show("<args>", true)
    command! -bang    NeoTreeReveal        lua require("neo-tree").reveal_current_file("filesystem", false, "<bang>" == "!") 
    command!          NeoTreeRevealInSplit lua require("neo-tree").reveal_in_split("filesystem", false)
    command!          NeoTreeShowInSplit   lua require("neo-tree").show_in_split("filesystem", false)

    command! -nargs=? NeoTreeFloatToggle   lua require("neo-tree").float("<args>", true)
    command! -nargs=? NeoTreeFocusToggle   lua require("neo-tree").focus("<args>", true, true)
    command! -nargs=? NeoTreeShowToggle    lua require("neo-tree").show("<args>", true, true, true)
    command! -bang    NeoTreeRevealToggle  lua require("neo-tree").reveal_current_file("filesystem", true, "<bang>" == "!")
    command!    NeoTreeRevealInSplitToggle lua require("neo-tree").reveal_in_split("filesystem", true)
    command!    NeoTreeShowInSplitToggle   lua require("neo-tree").show_in_split("filesystem", true)

    command!          NeoTreePasteConfig   lua require("neo-tree").paste_default_config()
    command! -nargs=? NeoTreeSetLogLevel   lua require("neo-tree").set_log_level("<args>")
    command!          NeoTreeLogs          lua require("neo-tree").show_logs()
endif

command! -nargs=* -complete=custom,v:lua.require'neo-tree.command'.complete_args
            \ Neotree lua require("neo-tree.command")._command(<f-args>)
