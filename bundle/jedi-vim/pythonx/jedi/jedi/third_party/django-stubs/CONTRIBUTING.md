# How to contribute

## Tutorials

If you want to start working on this project,
you will need to get familiar with these projects:

- [Django docs](https://docs.djangoproject.com/en/dev/)
- [Typing in Python](https://inventwithpython.com/blog/2019/11/24/type-hints-for-busy-python-programmers/)
- [How to write custom mypy plugins](https://mypy.readthedocs.io/en/stable/extending_mypy.html)
- [Typechecking Django and DRF](https://sobolevn.me/2019/08/typechecking-django-and-drf) guide
- [Testing mypy stubs, plugins, and types](https://sobolevn.me/2019/08/testing-mypy-types) guide

It is also recommended to take a look at these resources:

- [Awesome Python Typing](https://github.com/typeddjango/awesome-python-typing)


## Dev documentation

TODO


## Dependencies

We use `pip` to manage the dependencies.

To install them you would need to activate your `virtualenv` and run `install` command:

```bash
pip install -r ./dev-requirements.txt
```


## Tests and linters

We use `mypy`, `pytest`, `flake8`, and `black` for quality control.
Here's [how we run our CI](https://github.com/typeddjango/django-stubs/blob/master/.travis.yml).

### Typechecking

To run typechecking use:

```bash
mypy ./mypy_django_plugin
```

### Testing

There are unit tests and type-related tests.

To run unit tests:

```bash
pytest
```

Type-related tests ensure that different Django versions do work correctly.
To run type-related tests:

```bash
python ./scripts/typecheck_tests.py --django_version=2.2
python ./scripts/typecheck_tests.py --django_version=3.0
```

Currently we only support two Django versions.

### Linting

To run auto-formatting:

```bash
isort -rc .
black django-stubs/
```

To run linting:

```bash
flake8
flake8 --config flake8-pyi.ini
```


## Submitting your code

We use [trunk based](https://trunkbaseddevelopment.com/)
development (we also sometimes call it `wemake-git-flow`).

What the point of this method?

1. We use protected `master` branch,
   so the only way to push your code is via pull request
2. We use issue branches: to implement a new feature or to fix a bug
   create a new branch named `issue-$TASKNUMBER`
3. Then create a pull request to `master` branch
4. We use `git tag`s to make releases, so we can track what has changed
   since the latest release

So, this way we achieve an easy and scalable development process
which frees us from merging hell and long-living branches.

In this method, the latest version of the app is always in the `master` branch.


## Other help

You can contribute by spreading a word about this library.
It would also be a huge contribution to write
a short article on how you are using this project.
You can also share your best practices with us.
