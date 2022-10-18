# vim-zettelkasten

`vim-zettelkasten` is a [Zettelkasten](https://zettelkasten.de) note taking plugin.

It is based on [zettelkasten.nvim@fe174666](https://github.com/Furkanzmc/zettelkasten.nvim/tree/fe1746666e27c2fcc0e60dc2786cb9983b994759)

Using this plugin, you can:

1. Create new notes with unique IDs (`:help :ZkNew`)

2. List the places where a tag is used with `:tselect tag_name` or use Vim's own tag shortcuts for
   navigation.

3. Use `i_CTRL-X_CTRL-]` to get a list of all the tags in your notes.

4. Get a completion list of note references.

5. Use `K` command to display context for a note ID.

6. Use `gf` to navigate to a reference. As long as your `:help path` option is set correctly, this
   will work.

There's no separate file type for zettelkasten. Markdown file type is used to extend the
functionality to make it easier to take notes.

For the most up to date information, please do `:help zettelkasten.txt`. I won't be updating README
file for every single feature or update. You can also check out the
[wiki](https://github.com/Furkanzmc/zettelkasten.nvim/wiki) for tips and tricks on how to use
zettelkasten.nvim.

# Configuration

See `:help zettelkasten.txt` for more information.

# TODO

Potential ideas to implement in the future:

- [ ] A graph view (Possible with an external CLI program.)
- [X] A sidebar (or preview window) to display the linked notes.
- [ ] Telescope support. It's a popular plugin so it'd be useful but I don't use Telescope so
  contributions for this feature is most welcome!

# Project Goals

I started the project out of a bout of excitement for having discovered the Zettelkasten note
taking system. I've been looking for better ways to take notes and this system seems to fulfill my
needs. Since I love Vim, and Zettelkasten is a text based system (Which is what I love the most
about it), I decided to create a plugin immediately.

My goal is not to turn this into a huge thing with custom pickers, and file types, and a gazillion
mapping and commands. My goal is to make use of the existing Vim options/mappings/features to
extend markdown file type so it's more convenient to navigate, discover, and write.

As you can see from its initial state, the only thing you need to really know about this plugin is
the `:ZkNew` command. Everything else can be discovered as you are flexing your usual Vim muscles
(e. `gf`, `i_CTRL-X_CTRL-]`, `CTRL-]`).

In true Vim philosophy, I also want to make it easier for people to extend this plugin to their own
needs. So, all the Lua API will be nicely designed so you can interface this plugin with others
(e.g `Telescope.nvim`) or create your own workflow easily.

Please also see `:help zettelkasten.nvim-101` and `:help zettelkasten-philosophy`.

# Related Projects

- [zk-nvim](https://github.com/mickael-menu/zk-nvim)
- [zettel.vim](https://github.com/Aarleks/zettel.vim/)
- [telekasten.nvim](https://github.com/renerocksai/telekasten.nvim)
- [marty-oehme/zettelkasten.nvim](https://github.com/marty-oehme/zettelkasten.nvim)
