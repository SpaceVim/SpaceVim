from __future__ import print_function
import timeit
import importlib
import json
from collections import defaultdict


NUMBER = 100


def benchmark_loads(module, data):
    module.loads(data)


def benchmark_dumps(module, obj):
    module.dumps(obj)


def benchmark_loads_byline(module, lines):
    for line in lines:
        module.loads(line)


def benchmark_dumps_byline(module, lines):
    for obj in lines:
        module.dumps(obj)


def import_modules():
    for name in ['json', 'simplejson', 'ujson', 'rapidjson']:
        try:
            yield importlib.import_module(name)
        except ImportError:
            print('Unable to import {}'.format(name))
            continue


def print_results(results):
    for suite_name, suite_results in results.items():
        print(suite_name)
        print('-' * 20)
        for module_name, result in sorted(suite_results.items(), key=lambda x:x[1]):
            print('{:10} {:.5f} s'.format(module_name, result))
        print()


def run_benchmarks():
    # filesize: 2248 byte
    with open('json/fmt.json') as f:
        fmt_objs_data = f.readlines()
    fmt_objs = [json.loads(line) for line in fmt_objs_data]

    # filesize: 116347 byte
    with open('json/syscall.json') as f:
        syscall_objs_data = f.readlines()
    syscall_objs = [json.loads(line) for line in syscall_objs_data]

    # filesize: 160808 byte
    with open('json/gocode.json') as f:
        gocode_objs_data = f.readlines()
    gocode_objs = [json.loads(line) for line in gocode_objs_data]

    # filesize: 1768818 byte
    with open('json/gocode-twice.json') as f:
        gocode_twice_objs_data = f.readlines()
    gocode_twice_objs = [json.loads(line) for line in gocode_twice_objs_data]

    results = defaultdict(dict)
    modules = import_modules()
    for module in modules:
        module_name = module.__name__
        print('Running {} benchmarks...'.format(module_name))

        results['loads (fmt.json)'][module_name] = timeit.timeit(
            lambda: benchmark_loads_byline(module, fmt_objs_data), number=NUMBER)
        results['dumps (fmt.json)'][module_name] = timeit.timeit(
            lambda: benchmark_dumps_byline(module, fmt_objs), number=NUMBER)

        results['loads (syscall.json)'][module_name] = timeit.timeit(
            lambda: benchmark_loads_byline(module, syscall_objs_data), number=NUMBER)
        results['dumps (syscall.json)'][module_name] = timeit.timeit(
            lambda: benchmark_dumps_byline(module, syscall_objs), number=NUMBER)

        results['loads (gocode.json)'][module_name] = timeit.timeit(
            lambda: benchmark_loads_byline(module, gocode_objs_data), number=NUMBER)
        results['dumps (gocode.json)'][module_name] = timeit.timeit(
            lambda: benchmark_dumps_byline(module, gocode_objs), number=NUMBER)

        results['loads (gocode-twice.json)'][module_name] = timeit.timeit(
            lambda: benchmark_loads_byline(module, gocode_twice_objs_data), number=NUMBER)
        results['dumps (gocode-twice.json)'][module_name] = timeit.timeit(
            lambda: benchmark_dumps_byline(module, gocode_twice_objs), number=NUMBER)

    print('\nResults\n=======')
    print_results(results)

if __name__ == '__main__':
    run_benchmarks()
