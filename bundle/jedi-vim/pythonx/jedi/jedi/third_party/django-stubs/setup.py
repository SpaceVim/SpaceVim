import os
from distutils.core import setup
from typing import List

from setuptools import find_packages


def find_stub_files(name: str) -> List[str]:
    result = []
    for root, dirs, files in os.walk(name):
        for file in files:
            if file.endswith('.pyi'):
                if os.path.sep in root:
                    sub_root = root.split(os.path.sep, 1)[-1]
                    file = os.path.join(sub_root, file)
                result.append(file)
    return result


with open('README.md', 'r') as f:
    readme = f.read()

dependencies = [
    'mypy>=0.780,<0.790',
    'typing-extensions',
    'django',
]

setup(
    name="django-stubs",
    version="1.5.0",
    description='Mypy stubs for Django',
    long_description=readme,
    long_description_content_type='text/markdown',
    license='MIT',
    url="https://github.com/typeddjango/django-stubs",
    author="Maksim Kurnikov",
    author_email="maxim.kurnikov@gmail.com",
    py_modules=[],
    python_requires='>=3.6',
    install_requires=dependencies,
    packages=['django-stubs', *find_packages(exclude=['scripts'])],
    package_data={'django-stubs': find_stub_files('django-stubs')},
    classifiers=[
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8'
    ],
    project_urls={
        'Release notes': 'https://github.com/typeddjango/django-stubs/releases',
    },
)
