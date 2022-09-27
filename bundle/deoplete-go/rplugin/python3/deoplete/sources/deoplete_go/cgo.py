import os
import re

from clang_index import Clang_Index


class cgo(object):
    def get_inline_source(buffer):
        # TODO(zchee): very slow. about 100ms

        if 'import "C"' not in buffer:
            return (0, "")

        pos_import_c = list(buffer).index('import "C"')
        c_inline = buffer[:pos_import_c]

        if c_inline[len(c_inline) - 1] == "*/":
            comment_start = next(
                i
                for i, v in zip(range(len(c_inline) - 1, 0, -1), reversed(c_inline))
                if v == "/*"
            )
            c_inline = c_inline[comment_start + 1 : len(c_inline) - 1]

        return (len(c_inline), "\n".join(c_inline))

    def get_pkgconfig(packages):
        out = []
        pkgconfig = cgo.find_binary_path("pkg-config")
        if pkgconfig != "":
            for pkg in packages:
                flag = os.popen(pkgconfig + " " + pkg + " --cflags --libs").read()
                out += flag.rstrip().split(" ")
        return out

    def parse_candidates(result):
        completion = {"dup": 1, "word": ""}
        _type = ""
        word = ""
        placeholder = ""
        sep = " "

        for chunk in [x for x in result.string if x.spelling]:
            chunk_spelling = chunk.spelling

            # ignore inline fake main(void), and '_' prefix function
            if chunk_spelling == "main" or chunk_spelling.find("_") == 0:
                return completion

            if chunk.isKindTypedText():
                word += chunk_spelling
                placeholder += chunk_spelling
            elif chunk.isKindResultType():
                _type += chunk_spelling
            else:
                placeholder += chunk_spelling

        completion["word"] = word
        completion["abbr"] = completion["info"] = placeholder + sep + _type

        completion["kind"] = " ".join(
            [
                (
                    Clang_Index.kinds[result.cursorKind]
                    if (result.cursorKind in Clang_Index.kinds)
                    else str(result.cursorKind)
                )
            ]
        )

        return completion

    def complete(index, cache, cgo_options, line_count, source):
        cgo_pattern = r"#cgo (\S+): (.+)"
        flags = set()
        for key, value in re.findall(cgo_pattern, source):
            if key == "pkg-config":
                for flag in cgo.get_pkgconfig(value.split()):
                    flags.add(flag)
            else:
                if "${SRCDIR}" in key:
                    key = key.replace("${SRCDIR}", "./")
                flags.add("%s=%s" % (key, value))

        cgo_flags = ["-std", cgo_options["std"]] + list(flags)

        fname = "cgo_inline.c"
        main = """
    int main(void) {
    }
    """
        template = source + main
        files = [(fname, template)]

        # clang.TranslationUnit
        # PARSE_NONE = 0
        # PARSE_DETAILED_PROCESSING_RECORD = 1
        # PARSE_INCOMPLETE = 2
        # PARSE_PRECOMPILED_PREAMBLE = 4
        # PARSE_CACHE_COMPLETION_RESULTS = 8
        # PARSE_SKIP_FUNCTION_BODIES = 64
        # PARSE_INCLUDE_BRIEF_COMMENTS_IN_CODE_COMPLETION = 128
        options = 15

        # Index.parse(path, args=None, unsaved_files=None, options = 0)
        tu = index.parse(fname, cgo_flags, unsaved_files=files, options=options)

        # TranslationUnit.codeComplete(path, line, column, ...)
        cr = tu.codeComplete(
            fname,
            (line_count + 2),
            1,
            unsaved_files=files,
            include_macros=True,
            include_code_patterns=True,
            include_brief_comments=False,
        )

        if cgo_options["sort_algo"] == "priority":
            results = sorted(cr.results, key=cgo.get_priority)
        elif cgo_options["sort_algo"] == "alphabetical":
            results = sorted(cr.results, key=cgo.get_abbrevation)
        else:
            results = cr.results

        # Go string to C string
        #  The C string is allocated in the C heap using malloc.
        #  It is the caller's responsibility to arrange for it to be
        #  freed, such as by calling C.free (be sure to include stdlib.h
        #  if C.free is needed).
        #  func C.CString(string) *C.char
        #
        # Go []byte slice to C array
        #  The C array is allocated in the C heap using malloc.
        #  It is the caller's responsibility to arrange for it to be
        #  freed, such as by calling C.free (be sure to include stdlib.h
        #  if C.free is needed).
        #  func C.CBytes([]byte) unsafe.Pointer
        #
        # C string to Go string
        #  func C.GoString(*C.char) string
        #
        # C data with explicit length to Go string
        #  func C.GoStringN(*C.char, C.int) string
        #
        # C data with explicit length to Go []byte
        #  func C.GoBytes(unsafe.Pointer, C.int) []byte
        cache[source] = [
            {
                "word": "CString",
                "abbr": "CString(string) *C.char",
                "info": "CString(string) *C.char",
                "kind": "function",
                "dup": 1,
            },
            {
                "word": "CBytes",
                "abbr": "CBytes([]byte) unsafe.Pointer",
                "info": "CBytes([]byte) unsafe.Pointer",
                "kind": "function",
                "dup": 1,
            },
            {
                "word": "GoString",
                "abbr": "GoString(*C.char) string",
                "info": "GoString(*C.char) string",
                "kind": "function",
                "dup": 1,
            },
            {
                "word": "GoStringN",
                "abbr": "GoStringN(*C.char, C.int) string",
                "info": "GoStringN(*C.char, C.int) string",
                "kind": "function",
                "dup": 1,
            },
            {
                "word": "GoBytes",
                "abbr": "GoBytes(unsafe.Pointer, C.int) []byte",
                "info": "GoBytes(unsafe.Pointer, C.int) []byte",
                "kind": "function",
                "dup": 1,
            },
        ]
        cache[source] += list(map(cgo.parse_candidates, results))
        return cache[source]

    def get_priority(x):
        return x.string.priority

    def get_abbr(strings):
        for chunks in strings:
            if chunks.isKindTypedText():
                return chunks.spelling
        return ""

    def get_abbrevation(x):
        return cgo.get_abbr(x.string).lower()

    def find_binary_path(cmd):
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
        return ""
