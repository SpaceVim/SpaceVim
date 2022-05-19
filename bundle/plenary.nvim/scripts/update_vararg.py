#!/usr/bin/env python3
import os
import subprocess

def generate_file(name, outpath, **kwargs):
    from jinja2 import Environment, FileSystemLoader
    env = Environment(loader=FileSystemLoader('./vararg'))
    template = env.get_template(name)
    path = os.path.join(outpath, name)
    with open(path, 'w') as fp:
        fp.write(template.render(kwargs))
    subprocess.run(["lua-format", "-i", path])

if __name__ == '__main__':
    generate_file('rotate.lua', '../lua/plenary/vararg', amount=16)
