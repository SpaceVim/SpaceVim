
### [Project on Vim.org](http://www.vim.org/scripts/script.php?script_id=4177)

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mbbill/undotree?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### Screenshot

![](https://sites.google.com/site/mbbill/undotree_new.png)

### Description

The plug-in visualizes undo history and makes it easier to browse and switch between different undo branches. You might wonder what is undo "branches"? It's vim feature that allows you to go back to a state when it is overwritten by a latest edit. For most editors, if you make a change A, then B, then go back to A and make change C, normally you won't be able to go back to B because undo history is linear. That's not the case for Vim because it internally keeps all the edit history like a tree structure, and this plug-in exposes the tree to you so that you not only can switch back and forth but also can switch between branches.


Some people have questions about file contents being changed when switching between undo history states. Don't worry, *undotree* will **NEVER** save your data or write to disk. All it does is to change the current buffer little bit, just like those auto-completion plug-ins do. It just adds or removes something in the buffer temporarily, and if you don't like you can always go back to the last state easily. Let's say, you made some change but didn't save, then you use *undotree* and go back to an arbitrary version, your unsaved change doesn't get lost - it stores in the latest undo history node. Clicking that node on *undotree* will bring you back instantly. Play with undo/redo on other editors is always dangerous because when you step back and accidentally typed something, boom! You lose your edits. But don't worry, that won't happen in Vim. Then you might ask what if I make some changes without saving and switch back to an old version and then **exit**? Well, imaging what would happen if you don't have *undotree*? You lose your latest edits and the file on disk is your last saved version. This behaviour **remains the same** with *undotree*. So, if you saved, you won't lose anything.


We all know that usually undo/redo is only for the current edit session. It's stored in memory and once the process exits, the undo history is lost. Although *undotree* makes switching between history states easier, it doesn't do more than that. Sometimes it would be much safer or more convenient to keep the undo history across edit sessions. In this case you might need to enable a Vim feature called *persistent undo*. Let me explain how persistent undo works: instead of keeping undo history in *RAM*, persistent undo keeps undo history in file. Let's say you make a change A, then B, then go back to A and make change C, then you *save* the file. Now Vim save the file with content state C, and in the mean time it saves **the entire** undo history to a file including state A, B and C. Next time when you open the file, Vim will also restore undo history. So you can still go back to B. The history file is incremental, and every change will be recorded permanently, kind of like Git. You might think that's too much, well, *undotree* does provide a way to clean them up. If you need to enable *persistent undo*, type ```:h persistent-undo``` or follow the instructions below.


Undotree is written in **pure Vim script** and doesn't rely on any third party tools. It's lightweight, simple and fast. It only does what it supposed to do, and it only runs when you need it.


### Download and Install

Use whatever plug-in manager to pull the master branch.


### Usage
 1. Use `:UndotreeToggle` to toggle the undo-tree panel. You may want to map this command to whatever hotkey by adding the following line to your vimrc, take F5 for example.

    nnoremap    &lt;F5&gt;    :UndotreeToggle&lt;cr&gt;

 1. Markers
    * Every change has a sequence number and it is displayed before timestamps.
    * The current state is marked as `> number <`.
    * The next state which will be restored by `:redo` or `<ctrl-r>` is marked as `{ number }`.
    * The `[ number ]` marks the most recent change.
    * The undo history is sorted by timestamps.
    * Saved changes are marked as `s` and the big `S` indicates the most recent saved change.
 1. Press `?` in undotree window for quick help.
 1. Persistent undo
    * Usually I would like to store the undo files in a seperate place like below.

```
if has("persistent_undo")
    set undodir=$HOME."/.undodir"
    set undofile
endif
```

### Configuration
[Here](https://github.com/mbbill/undotree/blob/master/plugin/undotree.vim#L15) is a list of options.

### Debug
 1. Create a file under $HOME with the name `undotree_debug.log`
    * `$touch ~/undotree_debug.log`
 1. Run vim, and the log will automatically be appended to the file, and you may watch it using `tail`:
    * `$tail -F ~/undotree_debug.log`
 1. If you want to disable debug, just delete that file.

### License
**BSD**

### Author
Ming Bai  &lt;mbbill AT gmail DOT COM&gt;
