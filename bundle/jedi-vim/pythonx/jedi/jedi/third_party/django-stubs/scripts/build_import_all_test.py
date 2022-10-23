import os
from pathlib import Path
from typing import List

STUBS_ROOT = Path(__file__).parent.parent / 'django-stubs'


def build_package_name(path: str) -> str:
    return '.'.join(['django'] + list(Path(path).relative_to(STUBS_ROOT).with_suffix('').parts))


packages: List[str] = []
for dirpath, dirnames, filenames in os.walk(STUBS_ROOT):
    if not dirnames:
        package = build_package_name(dirpath)
        packages.append(package)

    for filename in filenames:
        if filename != '__init__.pyi':
            package = build_package_name(os.path.join(dirpath, filename))
            packages.append(package)

test_lines: List[str] = []
for package in packages:
    test_lines.append('import ' + package)

test_contents = '\n'.join(sorted(test_lines))
print(test_contents)
