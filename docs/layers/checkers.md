# [Layers](https://spacevim.org/layers) > checkers

This layer provides syntax checking feature.

## Install

checkers layer is loaded by default.

## options

Name | default value | description
---- | ------------- | -----------
g:spacevim_enable_neomake | 1 | Use neomake as default checking tools, to use syntastic, set this option to 0.
g:spacevim_lint_on_the_fly | 0 | Syntax checking on the fly feature, disabled by default.

## Mappings

Key | mode | description
--- | ---- | -----------
`SPC e n` | Normal | jump to the position of next error
`SPC e N` | Normal | jump to the position of previous error
`SPC e p` | Normal | jump to the position of previous error
`SPC e l` | Normal | toggle showing the error list

