[日本語はこちら](https://github.com/t9md/vim-choosewin/blob/master/README-JP.md)

# Animated GIF

![gif](https://raw.githubusercontent.com/t9md/t9md/1675510eaa1b789aeffbc49c1ae3b1e8e7dceabe/img/vim-choosewin.gif)

# Navigate to the window you choose

This plugin aims to mimic tmux's `display-pane` feature, which enables you to choose a window interactively.

This plugin should be especially useful when working on high resolution displays since with wide displays you are likely to open multiple windows and moving around windows with vim is cumbersome.

This plugin simplifies window navigation with the following functionality:

  1. Displays window label on statusline or middle of each window (overlay).
  2. Accepts window selection from user.
  3. Navigates to the specified window.

## Example configuration:

```Vim
" invoke with '-'
nmap  -  <Plug>(choosewin)
```

Optional configuration:

```vim
" if you want to use overlay feature
let g:choosewin_overlay_enable = 1
```

More configuration options are explained in the help file. See `:help choosewin`.

## Default keymapings in choosewin mode

| Key    | Action     | Description                   |
| ------ | ---------- | ----------------------------- |
| 0      | tab_first  | Select FIRST    tab           |
| [      | tab_prev   | Select PREVIOUS tab           |
| ]      | tab_next   | Select NEXT     tab           |
| $      | tab_last   | Select LAST     tab           |
| x      | tab_close  | Close current tab             |
| ;      | win_land   | Navigate to current window    |
| -      | previous   | Naviage to previous window    |
| s      | swap       | Swap windows               #1 |
| S      | swap_stay  | Swap windows but stay      #1 |
| `<CR>` | win_land   | Navigate to current window    |
|        | `<NOP>`    | Disable predefined keymap     |

*1 If you select 'swap' again, you will swap with the previous window's buffer ex) using the default keymap, typing double 's'(ss) swaps with the previous window.

## Operational examples

Map `-` to invoke choosewin with the following command:

```Vim
nmap - <Plug>(choosewin)
```

### Move around tabs, and choose windows

First of all, open multiple windows and tabs.  
Invoke choosewin by typing `-` in normal mode.  
Then you can move around tabs by `]` and `[`, or you cand choose the target tab directly by typing the number labeled in the tabline.  
After you chose a target tab, you can choose a target window by typing the letter which is labeled in the statusline and in the middle of each window (if you have enabled the overlay feature).  

### Choose the previous window

Type `-` again to invoke choosewin, then input `-` again to choose the previous window. The previous window you were on before you choose the current window.  

### Swap windows

Type `-` to invoke choosewin, then type `s` to swap windows.  
Then type the label of a window to swap content(=buffer) of that window with your current window.  
After you chose, the current window's buffer is swapped with the buffer shown in the window you chose.  
By combining "swap" and "previous window" features, you can easily swap any window with the previous window like so: `-s-`, invoking choosewin itself(`-`) then entering swapping mode(`s`), then instructing choosewin to swap the target window with the previous(`-`) window. Congratulations!

### NERDTree open file

If working with several windows, it is useful to be able to select a specific window when open a file from inside [NERDTree](https://github.com/scrooloose/nerdtree). As default behavior _NERDTree_ use _Vims_ last window, that is often not the favored one. The [NERDTree_choosewin-plugin](https://github.com/weilbith/nerdtree_choosewin-plugin) provide this feature to select a window. Furthermore if the user has installed this Choosewin plugin as well, it is able to detect this and use it instead of the default behavior.
