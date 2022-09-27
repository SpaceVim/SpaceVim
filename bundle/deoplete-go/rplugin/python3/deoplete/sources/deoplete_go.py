import os
import re
import platform
import subprocess

from collections import OrderedDict

from deoplete.base.source import Base
from deoplete.util import charpos2bytepos, expand, getlines, load_external_module

load_external_module(__file__, "sources/deoplete_go")
from cgo import cgo
from stdlib import stdlib

try:
    load_external_module(__file__, "")
    from ujson import loads
except ImportError:
    from json import loads

# from https://github.com/golang/go/blob/go1.13beta1/src/go/build/syslist.go
known_goos = (
    "aix",
    "android",
    "appengine",
    "darwin",
    "dragonfly",
    "freebsd",
    "hurd",
    "illumos",
    "js",
    "linux",
    "nacl",
    "netbsd",
    "openbsd",
    "plan9",
    "solaris",
    "windows",
    "zos",
)


class Source(Base):
    def __init__(self, vim):
        super(Source, self).__init__(vim)

        self.name = "go"
        self.mark = "[Go]"
        self.filetypes = ["go"]
        self.input_pattern = r"(?:\b[^\W\d]\w*|[\]\)])\.(?:[^\W\d]\w*)?"
        self.rank = 500

    def on_init(self, context):
        vars = context["vars"]

        self.gocode_binary = ""
        if "deoplete#sources#go#gocode_binary" in vars:
            self.gocode_binary = expand(vars["deoplete#sources#go#gocode_binary"])

        self.package_dot = False
        if "deoplete#sources#go#package_dot" in vars:
            self.package_dot = vars["deoplete#sources#go#package_dot"]

        self.sort_class = []
        if "deoplete#sources#go#sort_class" in vars:
            self.sort_class = vars["deoplete#sources#go#sort_class"]

        self.pointer = False
        if "deoplete#sources#go#pointer" in vars:
            self.pointer = vars["deoplete#sources#go#pointer"]

        self.auto_goos = False
        if "deoplete#sources#go#auto_goos" in vars:
            self.auto_goos = vars["deoplete#sources#go#auto_goos"]

        self.goos = ""
        if "deoplete#sources#go#goos" in vars:
            self.goos = vars["deoplete#sources#go#goos"]

        self.goarch = ""
        if "deoplete#sources#go#goarch" in vars:
            self.goarch = vars["deoplete#sources#go#goarch"]

        self.sock = ""
        if "deoplete#sources#go#sock" in vars:
            self.sock = vars["deoplete#sources#go#sock"]

        self.cgo = False
        if "deoplete#sources#go#cgo" in vars:
            self.cgo = vars["deoplete#sources#go#cgo"]

        self.cgo_only = False
        if "deoplete#sources#go#cgo_only" in vars:
            self.cgo_only = vars["deoplete#sources#go#cgo_only"]

        self.source_importer = False
        if "deoplete#sources#go#source_importer" in vars:
            self.source_importer = vars["deoplete#sources#go#source_importer"]

        self.builtin_objects = False
        if "deoplete#sources#go#builtin_objects" in vars:
            self.builtin_objects = vars["deoplete#sources#go#builtin_objects"]

        self.unimported_packages = False
        if "deoplete#sources#go#unimported_packages" in vars:
            self.unimported_packages = vars["deoplete#sources#go#unimported_packages"]

        self.fallback_to_source = False
        if "deoplete#sources#go#fallback_to_source" in vars:
            self.fallback_to_source = vars["deoplete#sources#go#fallback_to_source"]

        self.loaded_gocode_binary = False
        self.complete_pos = re.compile(r'\w*$|(?<=")[./\-\w]*$')

        if self.pointer:
            self.complete_pos = re.compile(self.complete_pos.pattern + r"|\*$")
            self.input_pattern += r"|\*"

        if self.cgo:
            load_external_module(__file__, "clang")
            import clang.cindex as clang

            self.libclang_path = vars.get("deoplete#sources#go#cgo#libclang_path", "")
            if self.libclang_path == "":
                return

            self.cgo_options = {
                "std": vars.get("deoplete#sources#go#cgo#std", "c11"),
                "sort_algo": vars.get("deoplete#sources#cgo#sort_algo", None),
            }

            if (
                not clang.Config.loaded
                and clang.Config.library_path != self.libclang_path
            ):
                clang.Config.set_library_file(self.libclang_path)
                clang.Config.set_compatibility_check(False)

            # Set 'C.' complete pattern
            self.cgo_complete_pattern = re.compile(r"[^\W\d]*C\.")
            # Create clang.cindex.Index database
            self.index = clang.Index.create(0)
            # initialize in-memory cache
            self.cgo_cache, self.cgo_inline_source = dict(), None

    def get_complete_position(self, context):
        m = self.complete_pos.search(context["input"])
        return m.start() if m else -1

    def gather_candidates(self, context):
        # If enabled self.cgo, and matched self.cgo_complete_pattern pattern
        if self.cgo and self.cgo_complete_pattern.search(context["input"]):
            return self.cgo_completion(getlines(self.vim))

        if self.cgo_only:
            return []

        bufname = self.vim.current.buffer.name
        if not os.path.isfile(bufname):
            bufname = self.vim.call("tempname")
        result = self.get_complete_result(context, getlines(self.vim), bufname)

        try:
            if result[1][0]["class"] == "PANIC":
                self.print_error("gocode panicked")
                return []

            if self.sort_class:
                class_dict = OrderedDict((x, []) for x in self.sort_class)

            out = []
            sep = " "

            for complete in result[1]:
                word = complete["name"]
                info = complete["type"]
                _class = complete["class"]
                abbr = str(word + sep + info).replace(" func", "", 1)
                kind = _class

                if _class == "package" and self.package_dot:
                    word += "."
                if (
                    self.pointer
                    and str(context["input"][context["complete_position"] :]) == "*"
                ):
                    word = "*" + word

                candidates = dict(word=word, abbr=abbr, kind=kind, info=info, dup=1)

                if not self.sort_class or _class == "import":
                    out.append(candidates)
                elif _class in class_dict.keys():
                    class_dict[_class].append(candidates)

            if self.sort_class:
                for v in class_dict.values():
                    out += v

            return out
        except Exception:
            return []

    def cgo_completion(self, buffer):
        # No include header
        if cgo.get_inline_source(buffer)[0] == 0:
            return

        count, inline_source = cgo.get_inline_source(buffer)

        # exists 'self.cgo_inline_source', same inline sources and
        # already cached cgo complete candidates
        if (
            self.cgo_inline_source is not None
            and self.cgo_inline_source == inline_source
            and self.cgo_cache[self.cgo_inline_source]
        ):
            # Use in-memory(self.cgo_headers) cacahe
            return self.cgo_cache[self.cgo_inline_source]
        else:
            self.cgo_inline_source = inline_source
            # return candidates use libclang-python3
            return cgo.complete(
                self.index,
                self.cgo_cache,
                self.cgo_options,
                count,
                self.cgo_inline_source,
            )

    def get_complete_result(self, context, buffer, bufname):
        offset = self.get_cursor_offset(context)

        env = os.environ.copy()
        env["GOPATH"] = self.vim.eval("$GOPATH")

        if self.auto_goos:
            name = os.path.basename(os.path.splitext(bufname)[0])
            if "_" in name:
                for part in name.rsplit("_", 2):
                    if part in known_goos:
                        env["GOOS"] = part
                        break
            if "GOOS" not in env:
                for line in buffer:
                    if line.startswith("package "):
                        break
                    elif not line.startswith("// +build"):
                        continue
                    directives = [x.split(",", 1)[0] for x in line[9:].strip().split()]
                    if platform.system().lower() not in directives:
                        for plat in directives:
                            if plat in known_goos:
                                env["GOOS"] = plat
                                break
        elif self.goos != "":
            env["GOOS"] = self.goos

        if "GOOS" in env and env["GOOS"] != platform.system().lower():
            env["CGO_ENABLED"] = "0"

        if self.goarch != "":
            env["GOARCH"] = self.goarch

        gocode = self.find_gocode_binary()
        if not gocode:
            return []
        args = [gocode, "-f=json"]
        if self.source_importer:
            args.append("-source")
        if self.builtin_objects:
            args.append("-builtin")
        if self.unimported_packages:
            args.append("-unimported-packages")
        if self.fallback_to_source:
            args.append("-fallback-to-source")
        # basically, '-sock' option for mdempsky/gocode.
        # probably meaningless in nsf/gocode that already run the rpc server
        if self.sock != "" and self.sock in ["unix", "tcp", "none"]:
            args.append("-sock={}".format(self.sock))

        args += ["autocomplete", bufname, str(offset)]

        process = subprocess.Popen(
            args,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            start_new_session=True,
            env=env,
        )
        stdout_data, stderr_data = process.communicate("\n".join(buffer).encode())

        result = []
        try:
            result = loads(stdout_data.decode())
        except Exception as e:
            self.print_error("gocode decode error")
            self.print_error(stdout_data.decode())
            self.print_error(stderr_data.decode())
        return result

    def get_cursor_offset(self, context):
        line = self.vim.current.window.cursor[0]
        column = context["complete_position"]
        count = self.vim.call("line2byte", line)
        if self.vim.current.buffer.options["fileformat"] == "dos":
            # Note: line2byte() counts "\r\n" in DOS format.  It must be "\n"
            # in gocode.
            count -= line - 1
        return count + charpos2bytepos("utf-8", context["input"][:column], column) - 1

    def parse_import_package(self, buffer):
        start = 0
        packages = []

        for line, b in enumerate(buffer):

            if re.match(r"^\s*import \w*|^\s*import \(", b):
                start = line
                continue
            elif re.match(r"\)", b):
                break
            elif line > start:
                package_name = re.sub(r'\t|"', "", b)
                if str(package_name).find(r"/", 0) > 0:
                    full_package_name = str(package_name).split("/", -1)
                    package_name = full_package_name[len(full_package_name) - 1]
                    library = (
                        "/".join(full_package_name[: len(full_package_name) - 1]),
                    )

                    packages.append(dict(library=library, package=package_name))
                else:
                    packages.append(dict(library="none", package=package_name))
        return packages

    def find_gocode_binary(self):
        if self.gocode_binary != "" and self.loaded_gocode_binary:
            return self.gocode_binary

        self.loaded_gocode_binary = os.path.isfile(self.gocode_binary)
        if self.loaded_gocode_binary:
            return self.gocode_binary
        elif platform.system().lower() == "windows":
            return self.find_binary_path("gocode.exe")
        else:
            return self.find_binary_path("gocode")

    def find_binary_path(self, path):
        def is_exec(bin_path):
            return os.path.isfile(bin_path) and os.access(bin_path, os.X_OK)

        dirpath, binary = os.path.split(path)
        if dirpath:
            if is_exec(path):
                return path
        else:
            for p in os.environ["PATH"].split(os.pathsep):
                p = p.strip('"')
                binary = os.path.join(p, path)
                if is_exec(binary):
                    return binary
        return self.print_error(path + " binary not found")
