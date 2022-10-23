#!/usr/bin/env python

from __future__ import with_statement

from setuptools import setup, find_packages

import parso


__AUTHOR__ = 'David Halter'
__AUTHOR_EMAIL__ = 'davidhalter88@gmail.com'

readme = open('README.rst').read() + '\n\n' + open('CHANGELOG.rst').read()

setup(
    name='parso',
    version=parso.__version__,
    description='A Python Parser',
    author=__AUTHOR__,
    author_email=__AUTHOR_EMAIL__,
    include_package_data=True,
    maintainer=__AUTHOR__,
    maintainer_email=__AUTHOR_EMAIL__,
    url='https://github.com/davidhalter/parso',
    license='MIT',
    keywords='python parser parsing',
    long_description=readme,
    packages=find_packages(exclude=['test']),
    package_data={'parso': ['python/grammar*.txt', 'py.typed', '*.pyi', '**/*.pyi']},
    platforms=['any'],
    python_requires='>=3.6',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Plugins',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Topic :: Software Development :: Libraries :: Python Modules',
        'Topic :: Text Editors :: Integrated Development Environments (IDE)',
        'Topic :: Utilities',
        'Typing :: Typed',
    ],
    extras_require={
        'testing': [
            'pytest<6.0.0',
            'docopt',
        ],
        'qa': [
            'flake8==3.8.3',
            'mypy==0.782',
        ],
    },
)
