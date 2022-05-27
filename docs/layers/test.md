---
title: "SpaceVim test layer"
description: "This layer allows to run tests directly in SpaceVim"
---

# [Available Layers](../) >> test

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layers allows to run tests directly in SpaceVim.

## Install

To use this configuration layer, add the following snippet to your custom configuration file.

```toml
[[layers]]
  name = "test"
```

## Configuration

To set or override any configuration ([see supported settings here](https://github.com/janko/vim-test)) you may use the `override_config`:

```toml
[[layers]]
  name = "test"
  [layers.override_config]
    java_runner = "gradletest"
    java_gradletest_executable = "./gradlew test"
```

The example above is equivalent to adding the following in viml:

```viml
let test#java#runner = "gradletest"
let test#java#gradletest#executable = "./gradlew test"
```

In essence, it replaces `_` with `#` and prepends `test#` to the keys inside `override_config`.

To use ultest, set the configuration:

```toml
[[layers]]
  name = "test"
  use_ultest = true
```

## Key bindings

| Key Binding | Description                                                                                                                                                                                                                                                                             |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SPC k n`   | Run nearest test                                                                                                                                                                                                                                                                        |
| `SPC k f`   | Run test file                                                                                                                                                                                                                                                                           |
| `SPC k s`   | Runs the whole test suite (if the current file is a test file, runs that framework's test suite, otherwise determines the test framework from the last run test).                                                                                                                       |
| `SPC k l`   | Runs the last test                                                                                                                                                                                                                                                                      |
| `SPC k v`   | Visits the test file from which you last run your tests (useful when you're trying to make a test pass, and you dive deep into application code and close your test buffer to make more space, and once you've made it pass you want to go back to the test file to write more tests)   |

**Additional bindings with ultest**

| Key Binding | Description                                                    |
| ----------- | ---------------------------------------------------------------|
| `SPC k u`   | Jump to summary                                                |
| `SPC k U`   | Open summary                                                   |
| `SPC k k`   | Stop nearest                                                   |
| `SPC k K`   | Stop                                                           |
| `SPC k a`   | Attach                                                         |
| `SPC k c`   | Clear                                                          |
| `SPC k d`   | Debug nearest                                                  |
| `SPC k D`   | Debug                                                          |
| `SPC k j`   | Jump to next failed test                                       |
| `SPC k k`   | Jump to previous failed test                                   |
| `SPC k o`   | Show output                                                    |
| `SPC k O`   | Jump to output                                                 |
