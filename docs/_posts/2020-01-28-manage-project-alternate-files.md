---
title: "Manage project alternate files"
categories: [feature, blog]
excerpt: "Manage the alternate file of current project within SpaceVim."
image: https://user-images.githubusercontent.com/13142418/73239989-98c4d800-41d8-11ea-8c5b-383076cfcd6c.png
commentsID: "Manage project alternate files"
comments: true
---

# [Blogs](../blog/) >> Manage project alternate files

{{ page.date | date_to_string }}


<!-- vim-markdown-toc GFM -->

- [Causes and purposes](#causes-and-purposes)
- [Basic usage](#basic-usage)

<!-- vim-markdown-toc -->

## Causes and purposes

At first, when managing the SpaceVim project,
every time you edited a module source file,
you always need to pay attention to the following things:

1. Whether the relevant documents exist, whether they need to be modified, whether there are Chinese and English versions of documents in the project, and whether the contents are consistent.
2. Test whether the file exists and whether it needs to be modified.

In view of the above two points, the following requirements are derived:

1. When editing a source file, quickly jump to the source file where the document is located;
2. When editing Chinese documents, quickly jump to English documents and vice versa;
3. When editing the source file, quickly jump to the test file and vice versa;

At present, this plugin built into SpaceVim basically implements the above functions, in order to quickly jump between related files.


## Basic usage

SpaceVim provides a built-in alternate file manager, the command is `:A`.

![a](https://user-images.githubusercontent.com/13142418/73239989-98c4d800-41d8-11ea-8c5b-383076cfcd6c.png)

To use this feature, you can create a `.project_alt.json` file in the root of your project. for example:

```json
{
  "autoload/SpaceVim/layers/lang/*.vim": {"doc": "docs/layers/lang/{}.md"},
}
```

after adding this configuration, when edit `autoload/SpaceVim/layers/lang/java.vim`,
you can use `:A doc` switch to `docs/layers/lang/java.md`
