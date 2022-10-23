from os.path import join
from jedi.file_io import FolderIO
from test.helpers import get_example_dir


def test_folder_io_walk():
    root_dir = get_example_dir('namespace_package')
    iterator = FolderIO(root_dir).walk()
    root, folder_ios, file_ios = next(iterator)
    assert {f.path for f in folder_ios} == {join(root_dir, 'ns1'), join(root_dir, 'ns2')}
    for f in list(folder_ios):
        if f.path.endswith('ns1'):
            folder_ios.remove(f)

    root, folder_ios, file_ios = next(iterator)
    assert folder_ios
    assert root.path == join(root_dir, 'ns2')
    folder_ios.clear()
    assert next(iterator, None) is None


def test_folder_io_walk2():
    root_dir = get_example_dir('namespace_package')
    iterator = FolderIO(root_dir).walk()
    root, folder_ios, file_ios = next(iterator)
    folder_ios.clear()
    assert next(iterator, None) is None
