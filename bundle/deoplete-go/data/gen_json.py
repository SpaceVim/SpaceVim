#!/usr/bin/env python3
import json
import os
import subprocess
import sys
import re

def main():
    base_offset = 41

    go_version_raw = subprocess.Popen("go version",
                                  shell=True,
                                  stdout=subprocess.PIPE
                                  ).stdout.read()

    go_version = str(go_version_raw).split(' ')[2].strip('go')
    go_os = sys.argv[1]
    go_arch = sys.argv[2]

    with open('./stdlib-' + go_version + '_' + go_os + '_' + go_arch + '.txt') as stdlib:
        packages = stdlib.read().splitlines()

    for pkg in packages:
        template_file = './template.go'
        f = open(template_file)
        fs = f.read(-1)

        func = None
        if re.search(r'/', pkg):
            library = str(pkg).split(r'/')[:-1]
            func = str(pkg).split(r'/')[-1]
        else:
            library = pkg
            func = pkg
        source = str(fs).replace('IMPORT', pkg).replace('FUNC', func).encode()

        offset = base_offset + (len(pkg) + len(func))

        process = subprocess.Popen([FindBinaryPath('gocode'),
                                    '-f=json',
                                    'autocomplete',
                                    template_file,
                                    str(offset)],
                                   stdin=subprocess.PIPE,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE,
                                   start_new_session=True)
        process.stdin.write(source)
        stdout_data, stderr_data = process.communicate()
        result = json.loads(stdout_data.decode())

        out_dir = os.path.join(
            './json', go_version, go_os + '_' + go_arch)
        if not os.path.exists(out_dir):
            os.makedirs(out_dir)

        libdir = str(pkg).rsplit('/', 1)[0]
        pkg_dir = os.path.join(out_dir, libdir)
        if not os.path.exists(pkg_dir):
            os.makedirs(pkg_dir)
        out_path = \
            os.path.join(pkg_dir, func + '.json')
        out = open(out_path, 'w')
        out.write(json.dumps(result, sort_keys=True))
        out.close()

        print(pkg)


def FindBinaryPath(cmd):
    def is_exec(fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(cmd)
    if fpath:
        if is_exec(cmd):
            return cmd
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            binary = os.path.join(path, cmd)
            if is_exec(binary):
                return binary
    return print('gocode binary not found')

main()
