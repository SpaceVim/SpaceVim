## About
Defx-sftp is a defx source for sftp.

## Features
- View and operate remote files via SFTP.
- Exchange files between remote and local.

## Requirements
For basic requirements, please follow the [instruction of defx.nvim](https://github.com/Shougo/defx.nvim#requirements).\
Additionally, defx-sftp requires [paramiko](http://www.paramiko.org/).\
You can install it with pip:

    pip3 install --user paramiko

## Usage
For now, defx-sftp only supports RSA authentication.
Private key path can be specified with `g:defx_sftp#key_path` (default is ~/.ssh/id_rsa).

Remote files can be accessed like this.
``` vim
Defx sftp://[user@]hostname[:port][/path]
```

Columns for sftp files is supported (`sftp_mark`, `sftp_time`, `sftp_time`).\
If you want to show the same columns as defx's one, you can configure like this and open with `Defx sftp://user@hostname -buffer-name=sftp`.
```vim
call defx#custom#option('sftp', {
      \ 'columns': 'sftp_mark:indent:icon:filename:type:sftp_time:sftp_size',
      \ })
```
