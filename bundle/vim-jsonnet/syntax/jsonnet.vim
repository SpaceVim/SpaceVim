" Copyright 2014 Google Inc. All rights reserved.
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

syntax match Number "\<\d*\([Ee][+-]\?\d\+\)\?\>"
syntax match Number "\<\d\+[.]\d*\([Ee][+-]\?\d\+\)\?\>"
syntax match Number "\<[.]\d\+\([Ee][+-]\?\d\+\)\?\>"

" builtins
syn match Constant "std.acos"
syn match Constant "std.asin"
syn match Constant "std.atan"
syn match Constant "std.ceil"
syn match Constant "std.char"
syn match Constant "std.codepoint"
syn match Constant "std.cos"
syn match Constant "std.exp"
syn match Constant "std.exponent"
syn match Constant "std.extVar"
syn match Constant "std.filter"
syn match Constant "std.floor"
syn match Constant "std.force"
syn match Constant "std.length"
syn match Constant "std.log"
syn match Constant "std.makeArray"
syn match Constant "std.mantissa"
syn match Constant "std.md5"
syn match Constant "std.modulo"
syn match Constant "std.native"
syn match Constant "std.objectFieldsEx"
syn match Constant "std.objectHasEx"
syn match Constant "std.pow"
syn match Constant "std.primitiveEquals"
syn match Constant "std.sin"
syn match Constant "std.sqrt"
syn match Constant "std.tan"
syn match Constant "std.thisFile"
syn match Constant "std.type"

" std.jsonnet
syn match Constant "std.abs"
syn match Constant "std.asciiLower"
syn match Constant "std.asciiUpper"
syn match Constant "std.assertEqual"
syn match Constant "std.base64"
syn match Constant "std.base64Decode"
syn match Constant "std.base64DecodeBytes"
syn match Constant "std.count"
syn match Constant "std.endsWith"
syn match Constant "std.equals"
syn match Constant "std.escapeStringBash"
syn match Constant "std.escapeStringDollars"
syn match Constant "std.escapeStringJson"
syn match Constant "std.escapeStringPython"
syn match Constant "std.filterMap"
syn match Constant "std.flattenArrays"
syn match Constant "std.foldl"
syn match Constant "std.foldr"
syn match Constant "std.format"
syn match Constant "std.join"
syn match Constant "std.lines"
syn match Constant "std.manifestIni"
syn match Constant "std.manifestJson"
syn match Constant "std.manifestJsonEx"
syn match Constant "std.manifestPython"
syn match Constant "std.manifestPythonVars"
syn match Constant "std.manifestYamlStream"
syn match Constant "std.map"
syn match Constant "std.mapWithIndex"
syn match Constant "std.max"
syn match Constant "std.mergePatch"
syn match Constant "std.min"
syn match Constant "std.mod"
syn match Constant "std.objectFields"
syn match Constant "std.objectFieldsAll"
syn match Constant "std.objectHas"
syn match Constant "std.objectHasAll"
syn match Constant "std.parseInt"
syn match Constant "std.prune"
syn match Constant "std.range"
syn match Constant "std.resolvePath"
syn match Constant "std.set"
syn match Constant "std.setDiff"
syn match Constant "std.setInter"
syn match Constant "std.setMember"
syn match Constant "std.setUnion"
syn match Constant "std.slice"
syn match Constant "std.sort"
syn match Constant "std.split"
syn match Constant "std.splitLimit"
syn match Constant "std.startsWith"
syn match Constant "std.stringChars"
syn match Constant "std.strReplace"
syn match Constant "std.substr"
syn match Constant "std.toString"
syn match Constant "std.uniq"


syn match Type "\$"

syn region String start='L\="' skip='\\\\\|\\"' end='"'
syn region String start='L\=\'' skip='\\\\\|\\\'' end='\''
syn region String start='|||\s*\n\+\z(\s*\)' end='^\z1\@!\s*|||'

" Highlight python style string formatting.
syn match Special "%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=String
syn match Special "%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=String

syn region Comment start="/[*]" end="[*]/"
syn match Comment "//.*$"
syn match Comment "#.*$"

syn match Keyword "\<[a-zA-Z_][a-z0-9A-Z_]*\s*\(([^)]*)\)\?\s*+\?::\?:\?"

syn region Object start="{" end="}" fold transparent

syntax keyword Include import importstr
syntax keyword Type function self super
syntax keyword Statement assert if then else for in
syntax keyword Special local tailstrict
syntax keyword Constant true false null
syntax keyword Underlined error


