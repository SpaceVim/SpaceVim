###JavaUnit.vim

[![Join the chat at https://gitter.im/wsdjeg/JavaUnit.vim](https://badges.gitter.im/wsdjeg/JavaUnit.vim.svg)](https://gitter.im/wsdjeg/JavaUnit.vim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/wsdjeg/JavaUnit.vim.svg?branch=master)](https://travis-ci.org/wsdjeg/JavaUnit.vim)

#### requirement

1. jdk

2. [artur-shaik/javacomplete2](https://github.com/artur-shaik/vim-javacomplete2)

3. [scrooloose/syntastic](https://github.com/scrooloose/syntastic)

> also you can use my fork which provide gradle support, [wsdjeg/syntastic](https://github.com/wsdjeg/syntastic)

4. [Shougo/unite.vim](https://github.com/Shougo/unite.vim)

> if you do not intstall this plugin,JavaUnit will show result in its own buffer instead of unite.

5. [tagbar](https://github.com/majutsushi/tagbar)


#### install

- [neobundle.vim](https://github.com/Shougo/neobundle.vim)

```vim
NeoBundle 'wsdjeg/JavaUnit.vim'
```

- [Vundle.vim](https://github.com/VundleVim/Vundle.vim)

```vim
Plugin 'wsdjeg/JavaUnit.vim'
```

#### Command

JavaUnitExec

test the current methond(no need put the cursor on the methodName)
![2015-11-16 23-40-05](https://cloud.githubusercontent.com/assets/13142418/11186276/e153459c-8cbb-11e5-9724-9589066176d0.png)

JavaUnitExec [args ...]

test specification method

example JavaUnitExec testMethod1 testMethod2 testMethod3 ...
![2015-11-16 23-40-25](https://cloud.githubusercontent.com/assets/13142418/11186274/e1520d9e-8cbb-11e5-90e1-17e6cfbc5a09.png)

JavaUnitTestMain

run the main methon of current class

also you can use `JavaUnitTestAll`,then will run all the testMethod in the current file
![2015-11-16 23-40-43](https://cloud.githubusercontent.com/assets/13142418/11186273/e132f580-8cbb-11e5-94d3-81dfda614abf.png)

support for maven project

JavaUnitTestMaven test current file

![JavaUnitMavenTest](https://cloud.githubusercontent.com/assets/13142418/11186066/ef8f70aa-8cba-11e5-9869-13f39a782ad7.png)

JavaUnitTestMavenAll test this project

![JavaUnitMavenTestAll](https://cloud.githubusercontent.com/assets/13142418/11186033/baf6f64c-8cba-11e5-989c-cd3dacb038b3.png)

#### Mappings

`q` close the JavaUnit buffer.
