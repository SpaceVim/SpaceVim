# jplus.vim

結合時に区切り文字を入力したり、行継続のキーワード(\ 等)などを削除して行結合を行うプラグインです。

## Screencapture

#### 任意の文字を挿入して結合する

![jplus1](https://cloud.githubusercontent.com/assets/214488/3864410/0e52b254-1f5c-11e4-9f89-3c624dc72936.gif)

#### 先頭の \ を取り除いて結合する

![jplus2](https://cloud.githubusercontent.com/assets/214488/3864436/f747a67c-1f5c-11e4-8918-45bfa0a2aced.gif)

## Example

```vim
" J の挙動を jplus.vim で行う
nmap J <Plug>(jplus)
vmap J <Plug>(jplus)

" getchar() を使用して挿入文字を入力します
nmap <Leader>J <Plug>(jplus-getchar)
vmap <Leader>J <Plug>(jplus-getchar)

" input() を使用したい場合はこちらを使用して下さい
" nmap <Leader>J <Plug>(jplus-input)
" vmap <Leader>J <Plug>(jplus-input)

" <Plug>(jplus-getchar) 時に左右に空白文字を入れたい場合
" %d は入力した結合文字に置き換えられる
let g:jplus#config = {
\	"_" : {
\		"delimiter_format" : ' %d '
\	}
\}
```


