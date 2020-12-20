# アニメーションGIF

![gif](https://raw.githubusercontent.com/t9md/t9md/1675510eaa1b789aeffbc49c1ae3b1e8e7dceabe/img/vim-choosewin.gif)

# 選択したウィンドウに移動
tmux の `display-pane` 機能を模倣しようと思い、作りました。  
`display-pane` はウィンドウ(tmux用語ではpane)を対話的に数字で選択できる機能です。  

このプラグインは、高解像度の広いディスプレイで作業している時に、特に効果を発揮するでしょう。  
広いディスプレイでは沢山のウィンドウを開きますが、ウインドウを渡り歩く作業は退屈で面倒です。  
このプラグインはウィンドウを渡り歩く作業を少し楽にしてくれるでしょう。  

  1. ウィンドウラベルをステータライン or 各ウィンドウの中央(オーバーレイ)に表示
  2. ウィンドウ番号を読み取る
  3. 選択したウィンドウに移動

## 設定例

```Vim
" invoke with '-'
nmap  -  <Plug>(choosewin)
```

オプション設定

```Vim
" オーバーレイ機能を有効にしたい場合
let g:choosewin_overlay_enable          = 1

" オーバーレイ・フォントをマルチバイト文字を含むバッファでも綺麗に表示する。
let g:choosewin_overlay_clear_multibyte = 1
```

もっと多くの設定項目があります。see `:help choosewin`

## choosewin 呼び出し後のキーマップのデフォルト

| Key    | Action     | Description                   |
| ------ | ---------- | ----------------------------- |
| 0      | tab_first  | choose FIRST    tab           |
| [      | tab_prev   | choose PREVIOUS tab           |
| ]      | tab_next   | choose NEXT     tab           |
| $      | tab_last   | choose LAST     tab           |
| ;      | win_land   | land to current window        |
| -      | previous   | land to previous window       |
| s      | swap       | swap buffer with you chose *1 |
| `<CR>` | win_land   | land to current window        |
|        | `<NOP>`    | disable predefined keymap     |

*1 'swap' を２回連続で呼び出した場合、直前(previous)の window のバッファとスワップします。
例) デフォルトのキーマップでは、'ss' で直前のバッファとスワップします。


## 操作例

以下の様に、`-` を chosewin にマッピングしている想定で説明する.

```Vim
nmap - <Plug>(choosewin)
```

### タブ間の移動、ウィンドウの選択

まず最初に、タブ、ウィンドウを何個も開いてみよう  
`-` とタイプして、choosewin を呼びだそう。  
`[` や `]` でタブ間を移動してみよう、あるいは、タブラインに表示された数字のラベルを入力して、直接タブを選択しよう  
目的のタブを選んだら、今度はウィンドウを選ぼう。ステータスラインに表示されたアルファベット(またはオーバーレイ機能を有効にした場合はウィンドウの真ん中に表示されるラベル)をタイプして、ウィンドウを選ぼう。  

### さっきの(直前の)ウィンドウを選ぶ

もう一度 `-` を入力して choosewin を呼び出し、また `-` とタイプしてみよう。そうすると直前のウィンドウに戻れる。直前のウィンドウとは、前回 choosewin でウィンドウを選んだ時、移動前にいたウィンドウのこと。  

### ウィンドウの交換(swap)

`-` とタイプして、choosewin を呼びだし、`s` を入力して swap モードに入る。  
ターゲットのウィンドウラベルをタイプすると、カレントウィンドウのバッファが、選んだウィンドウのバッファとスワップされる。  
swap と直前のウィンドウ(previous window) を組み合わせることで、簡単に直前のウィンドウのバッファと交換出来る。`-s-` とタイプする。これは choosewin を呼び出し(`-`)、スワップモードに入り(`s`)、ターゲットウィンドウは直前のウィンドウだ(`-`)という指示になる。おめでとう！  
