# bepo.vim

Un plugin [Vim](http://www.vim.org) pour une prise en charge de la disposition de clavier [bépo](http://www.bepo.fr).

## Contenu

Le plugin consiste essentiellement en un nombre minimal de redéfinitions de touches nécessaire pour un usage confortable de Vim.

Les touches de direction, `hjkl` sur un clavier QWERTY, sont en revanche `ctsr` sur un clavier bépo, ce qui explique la nécessité de les redéfinir.
En outre, certaines touches importantes sont peu accessibles en bépo, et elles sont déplacées également.

Enfin, de nombreux plugins redéfinissent les touches de direction et/ou `ctsr`.
Les plugins `netrw` (inclus dans Vim) et [surround](https://github.com/tpope/vim-surround/) sont pris en charge automatiquement.
La configuration requise pour d’autres plugins est reprise dans la documentation.

Pour plus de détails, voir la documentation intégrée en tapant
```
:help bépo
```

## Installation

Ce plugin suit la disposition standard, il est donc compatible avec de nombreux gestionnaires de plugin:

*  [Pathogen](https://github.com/tpope/vim-pathogen)
    -  `git clone https://github.com/michamos/vim-bepo/ ~/.vim/bundle/vim-airline`
    -  exécuter la commande `:Helptags` pour générer les tags de la documentation
*  [Plug](https://github.com/junegunn/vim-plug)
    -  `Plug 'michamos/vim-bepo'`
*  [NeoBundle](https://github.com/Shougo/neobundle.vim)
    -  `NeoBundle 'michamos/vim-bepo'`
*  [Vundle](https://github.com/gmarik/vundle)
    -  `Plugin 'michamos/vim-bepo'`
*  manuellement
    -  copier tous les fichiers dans le dossier `~/.vim`

## Inspiration

Ce plugin est inspiré, mais diffère en partie, de la reconfiguration partielle des touches du [wiki bépo](http://bepo.fr/wiki/Vim#Reconfiguration_partielle_des_touches).
