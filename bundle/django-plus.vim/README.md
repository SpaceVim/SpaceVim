<p align="center"><img align="center" alt="django-plus.vim" src="doc/django-plus.png?raw=true"></p>

---

Improvements to the handling of Django related files in Vim, some of which are
based on Steve Losh's `htmldjango` scripts.


## Why?

Django support in Vim sucks.

| What Sucks?                                                      | Sucks?  |
|:-----------------------------------------------------------------|:-------:|
| Hard-coded `htmldjango` filetype for any `.html` file            | **Yes** |
| HTML indentation                                                 | **Yes** |
| `QuerySet` completions                                           | **Yes** |
| `settings.py` variable completions                               | **Yes** |
| Template tag and filter completions                              | **Yes** |
| Template file completion for `{% include %}` and `{% extends %}` | **Yes** |
| Template file completion for rendering functions                 | **Yes** |

To help you understand the difference this plugin makes, I used science:

![science](doc/science.png?raw=true)

As you can see, one line goes up.  However, the other line doesn't go up that
much.  It doesn't get any clearer than that.


## Improvements

A summary of improvements to Django development in Vim.

### General

* Django is detected by searching parent directories for clues that indicate
  the current file is within a Django project.
* `b:is_django` is set in any file that's within a Django project.  This could
  be useful for your personal scripts.
* `b:is_django_settings` is set if the file is `settings.py` or if the file is
  in the same directory as `settings.py`.  (`b:is_django` will still be set)
* Optionally append `.django` to the `filetype` for files found within a Django
  project.
* If a Django project's `manage.py` script is found, completions will include
  your settings and templatetags found in `INSTALLED_APPS`.
* `g:django_filetypes` takes a list of glob patterns to *append* the `django`
  filetype to matching files.  e.g. `*.xml` will have the filetype
  `xml.django` if the file is found in a Django project.


### Python

* Completions for Django settings when `b:is_django_settings` is present.
* Completions for `settings.` when `b:is_django` is present in a `.py` file.
* Completions for template files when using `render()`, `get_template()`,
  `render_to_string()`, `render_to_response()`, or `template_name =`.
* QuerySets could be lurking anywhere.  That's why QuerySet completions will be
  included for basically anything after a period.
* If you are using `Ultisnips`, Django snippets are enabled and
  `UltiSnips#FileTypeChanged()` is called to ensure that `:UltiSnipsEdit` opens
  `django.snippets` by default instead of `python.snippets`.


### HTML

* The filetype is set to `htmldjango` when editing HTML files.
* Basic completions for template tags and filters.
* Completions for template files when using `{% extends %}` or `{% include %}`.
* Django tags are indented correctly, including custom tags.
* `matchit` configuration for Django tags, including custom tags.
  Additionally, the cursor is placed at the beginning of the tag name.
* Tag and variable blocks are highlighted within script tags, style tags, and
  HTML attributes.
* If you are using Ultisnips, HTML snippets are enabled and
  `UltiSnips#FileTypeChanged()` is called to ensure that `:UltiSnipsEdit` opens
  `htmldjango.snippets` by default instead of `html.snippets`.

[deoplete]: https://github.com/Shougo/deoplete.nvim
