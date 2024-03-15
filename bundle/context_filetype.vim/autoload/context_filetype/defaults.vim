"=============================================================================
" FILE: defaultsvim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let g:context_filetype#defaults#_filetypes = #{
      \   asciidoc: [
      \     #{
      \       start : '^\[source\%(%[^,]*\)\?,\(\h\w*\)\(,.*\)\?\]\s*\n----\s*\n',
      \       end : '^----\s*$',
      \       filetype : '\1',
      \     },
      \     #{
      \       start : '^\[source\%(%[^,]*\)\?,\(\h\w*\)\(,.*\)\?\]\s*\n',
      \       end : '^$',
      \       filetype : '\1',
      \     },
      \   ],
      \   c: [
      \     #{
      \       start: '_*asm_*\s\+\h\w*',
      \       end: '$',
      \       filetype: 'masm',
      \     },
      \     #{
      \       start: '_*asm_*\s*\%(\n\s*\)\?{',
      \       end: '}',
      \       filetype: 'masm',
      \     },
      \     #{
      \       start: '_*asm_*\s*\%(_*volatile_*\s*\)\?(',
      \       end: ');',
      \       filetype: 'gas',
      \     },
      \   ],
      \   cpp: [
      \     #{
      \       start: '_*asm_*\s\+\h\w*',
      \       end: '$',
      \       filetype: 'masm',
      \     },
      \     #{
      \       start: '_*asm_*\s*\%(\n\s*\)\?{',
      \       end: '}',
      \       filetype: 'masm',
      \     },
      \     #{
      \       start: '_*asm_*\s*\%(_*volatile_*\s*\)\?(',
      \       end: ');',
      \       filetype: 'gas',
      \     },
      \   ],
      \   d: [
      \     #{
      \       start: 'asm\s*\%(\n\s*\)\?{',
      \       end: '}',
      \       filetype: 'masm',
      \     },
      \   ],
      \   eruby: [
      \     #{
      \       start: '<%[=#]\?',
      \       end: '%>',
      \       filetype: 'ruby',
      \     },
      \   ],
      \   go: [
      \     #{
      \       start: '^\s*\%(//\s*\)\?#\s*include\s\+',
      \       end: '$',
      \       filetype: 'c',
      \     },
      \   ],
      \   haml: [
      \     #{
      \       start : '^\s*-',
      \       end : '$',
      \       filetype : 'ruby',
      \     },
      \     #{
      \       start : '^\s*\w*=',
      \       end : '$',
      \       filetype : 'ruby',
      \     },
      \     #{
      \       start : '^:javascript$',
      \       end : '^\S',
      \       filetype : 'javascript',
      \     },
      \     #{
      \       start : '^:css$',
      \       end : '^\S',
      \       filetype : 'css',
      \     },
      \   ],
      \   help: [
      \     #{
      \       start: '^>\|\s>$',
      \       end: '^<\|^\S\|^$',
      \       filetype: 'vim',
      \     },
      \   ],
      \   html: [
      \     #{
      \       start: '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>',
      \       end: '</script>',
      \       filetype: 'javascript',
      \     },
      \     #{
      \       start: '<script\%( [^>]*\)\? type="text/coffeescript"\%( [^>]*\)\?>',
      \       end: '</script>',
      \       filetype: 'coffee',
      \     },
      \     #{
      \       start: '<script\%( [^>]*\)\?>',
      \       end: '</script>',
      \       filetype: 'javascript',
      \     },
      \     #{
      \       start: '<style\%( [^>]*\)\?>',
      \       end: '</style>',
      \       filetype: 'css',
      \     },
      \     #{
      \       start: '<[^>]\+ style=\([''"]\)',
      \       end: '\1',
      \       filetype: 'css',
      \     },
      \   ],
      \   int-nyaos: [
      \     #{
      \       start: '\<lua_e\s\+\(["'']\)',
      \       end: '\1\@<!\1\1\@!',
      \       filetype: 'lua',
      \     },
      \   ],
      \   jade: [
      \     #{
      \       start : '^\(\s*\)script\.\s*$',
      \       end : '^\%(\1\s\|\s*$\)\@!',
      \       filetype : 'javascript',
      \     },
      \     #{
      \       start : '^\(\s*\):coffeescript\s*$',
      \       end : '^\%(\1\s\|\s*$\)\@!',
      \       filetype : 'coffee',
      \     },
      \     #{
      \       start : '^\(\s*\):\(\h\w*\)\s*$',
      \       end : '^\%(\1\s\|\s*$\)\@!',
      \       filetype : '\2',
      \     },
      \   ],
      \   javascript: [
      \     #{
      \       synname_pattern: '^jsx',
      \       filetype : 'jsx',
      \     },
      \     #{
      \       start: '^\s*{/\*',
      \       end: '\*/}',
      \       filetype : 'jsx',
      \     },
      \   ],
      \   lua: [
      \     #{
      \       start: 'vim.command\s*(\([''"]\)',
      \       end: '\\\@<!\1',
      \       filetype: 'vim',
      \     },
      \     #{
      \       start: 'vim.eval\s*(\([''"]\)',
      \       end: '\\\@<!\1',
      \       filetype: 'vim',
      \     },
      \   ],
      \   markdown: [
      \     #{
      \       start: '^\s*```\s*\(\h\w*\)',
      \       end: '^\s*```$',
      \       filetype: '\1',
      \     },
      \     #{
      \       start: '\%^-\{3,}.*$',
      \       end: '\_^-\{3,}.*$',
      \       filetype: 'yaml',
      \     },
      \     #{
      \       start: '\\(',
      \       end: '\\)',
      \       filetype: 'tex',
      \     },
      \     #{
      \       start: '\\[',
      \       end: '\\]',
      \       filetype: 'tex',
      \     },
      \   ],
      \   nyaos: [
      \     #{
      \       start: '\<lua_e\s\+\(["'']\)',
      \       end: '\1\@<!\1\1\@!',
      \       filetype: 'lua',
      \     },
      \   ],
      \   pandoc: [
      \     #{
      \       start: '^\s*```\s*\(\h\w*\)',
      \       end: '^\s*```$',
      \       filetype: '\1',
      \     },
      \     #{
      \       start: '\%^-\{3,}.*$',
      \       end: '\_^-\{3,}.*$',
      \       filetype : 'yaml',
      \     },
      \     #{
      \       start : '\\(',
      \       end : '\\)',
      \       filetype : 'tex',
      \     },
      \     #{
      \       start : '\\[',
      \       end : '\\]',
      \       filetype : 'tex',
      \     },
      \   ],
      \   python: [
      \     #{
      \       start: 'vim.command\s*(\([''"]\)',
      \       end: '\\\@<!\1',
      \       filetype: 'vim',
      \     },
      \     #{
      \       start: 'vim.eval\s*(\([''"]\)',
      \       end: '\\\@<!\1',
      \       filetype: 'vim',
      \     },
      \     #{
      \       start: 'vim.call\s*(\([''"]\)',
      \       end: '\\\@<!\1',
      \       filetype: 'vim',
      \     },
      \   ],
      \   review: [
      \     #{
      \       start: '^//list\[[^]]\+\]\[[^]]\+\]\[\([^]]\+\)\]{',
      \       end: '^//}',
      \       filetype : '\1',
      \     },
      \   ],
      \   toml: [
      \     #{
      \       start: '\<hook_\%('
      \               .. 'add\|source\|post_source\|\w*_update\|'
      \               .. '\)\s*=\s*\(' .. "'''" .. '\|"""\)',
      \       end: '\1',
      \       filetype: 'vim',
      \     },
      \     #{
      \       start: '\<lua_\%('
      \              .. 'add\|source\|post_source\|\w*_update'
      \              .. '\)\s*=\s*\(' .. "'''" .. '\|"""\)',
      \       end: '\1',
      \       filetype: 'lua',
      \     },
      \     #{
      \       start: '\<lua_[[:alnum:]_-]*'
      \              .. '\s*=\s*\(' .. "'''" .. '\|"""\)',
      \       end: '\1',
      \       filetype: 'lua',
      \     },
      \     #{
      \       start: '\<[[:alnum:]_-]*'
      \              .. '\s*=\s*\(' .. "'''" .. '\|"""\)',
      \       end: '\1',
      \       filetype: 'vim',
      \     },
      \   ],
      \   typescript: [
      \     #{
      \       synname_pattern: '^jsx',
      \       filetype : 'tsx',
      \     },
      \     #{
      \       start: '^\s*{/\*',
      \       end: '\*/}',
      \       filetype : 'tsx',
      \     },
      \   ],
      \   vim: [
      \     #{
      \       start: '^\s*pe\%[rl\] <<\s*\(\h\w*\)',
      \       end: '^\1',
      \       filetype: 'perl',
      \     },
      \     #{
      \       start: '^\s*py\%[thon\]3\? <<\s*\(\h\w*\)',
      \       end: '^\1',
      \       filetype: 'python',
      \     },
      \     #{
      \       start: '^\s*rub\%[y\] <<\s*\(\h\w*\)',
      \       end: '^\1',
      \       filetype: 'ruby',
      \     },
      \     #{
      \       start: '^\s*lua <<\s*\(\h\w*\)',
      \       end: '^\1',
      \       filetype: 'lua',
      \     },
      \     #{
      \       start: '^\s*lua ',
      \       end: '\n\|\s\+|',
      \       filetype: 'lua',
      \     },
      \   ],
      \   vimperator: [
      \     #{
      \       start: '^\s*\%(javascript\|js\)\s\+<<\s*\(\h\w*\)',
      \       end: '^\1',
      \       filetype: 'javascript',
      \     }
      \   ],
      \   vimshell: [
      \     #{
      \       start: 'vexe \([''"]\)',
      \       end: '\\\@<!\1',
      \       filetype: 'vim',
      \     },
      \     #{
      \       start: ' :\w*',
      \       end: '\n',
      \       filetype: 'vim',
      \     },
      \     #{
      \       start: ' vexe\s\+',
      \       end: '\n',
      \       filetype: 'vim',
      \     },
      \   ],
      \   vue: [
      \     #{
      \       start: '<template\%( [^>]*\)\? \%(lang="\%(\(\h\w*\)\)"\)\%( [^>]*\)\?>',
      \       end: '</template>',
      \       filetype: '\1',
      \     },
      \     #{
      \       start: '<template\%( [^>]*\)\?>',
      \       end: '</template>',
      \       filetype: 'html',
      \     },
      \     #{
      \       start:
      \       '<script\%( [^>]*\)\? \%(ts\|lang="\%(ts\|typescript\)"\)\%( [^>]*\)\?>',
      \       end: '</script>',
      \       filetype: 'typescript',
      \     },
      \     #{
      \       start: '<script\%( [^>]*\)\? \%(lang="\%(\(\h\w*\)\)"\)\%( [^>]*\)\?>',
      \       end: '</script>',
      \       filetype: '\1',
      \     },
      \     #{
      \       start: '<script\%( [^>]*\)\?>',
      \       end: '</script>',
      \       filetype: 'javascript',
      \     },
      \     #{
      \       start: '<style\%( [^>]*\)\? \%(lang="\%(\(\h\w*\)\)"\)\%( [^>]*\)\?>',
      \       end: '</style>',
      \       filetype: '\1',
      \     },
      \     #{
      \       start: '<style\%( [^>]*\)\?>',
      \       end: '</style>',
      \       filetype: 'css',
      \     },
      \     #{
      \       start: '<\(\h\w*\)>',
      \       end: '</\1>',
      \       filetype: 'vue-\1',
      \     },
      \     #{
      \       start: '<\(\h\w*\) \%(lang="\%(\(\h\w*\)\)"\)\%( [^>]*\)\?>',
      \       end: '</\1>',
      \       filetype: '\2',
      \     },
      \   ],
      \   xhtml: [
      \     #{
      \       start: '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>',
      \       end: '</script>',
      \       filetype: 'javascript',
      \     },
      \     #{
      \       start: '<script\%( [^>]*\)\? type="text/coffeescript"\%( [^>]*\)\?>',
      \       end: '</script>',
      \       filetype: 'coffee',
      \     },
      \     #{
      \       start: '<style\%( [^>]*\)\? type="text/css"\%( [^>]*\)\?>',
      \       end: '</style>',
      \       filetype: 'css',
      \     },
      \   ],
      \ }


let g:context_filetype#defaults#_same_filetypes = #{
      \   cpp: 'c',
      \   css: 'scss',
      \   erb: 'ruby,html,xhtml',
      \   html: 'xhtml',
      \   htmldjango: 'html',
      \   less: 'css',
      \   plaintex: 'bib,tex',
      \   scss: 'css',
      \   stylus: 'css',
      \   tex: 'bib,plaintex',
      \   vimconsole: 'vim',
      \   xhtml: 'html,xml',
      \   xml: 'xhtml',
      \ }


let g:context_filetype#defaults#_ignore_patterns = #{
      \   toml: ['^\s*#\s*'],
      \ }


let g:context_filetype#defaults#_comment_patterns = #{
      \   toml: [
      \     #{
      \      start: '^\s*#',
      \      end: '$',
      \     },
      \   ],
      \ }
