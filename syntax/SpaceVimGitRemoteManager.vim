scriptencoding utf-8
sy match SPCGitRemoteName '^\s*[▷▼]\s.*'
sy match SPCGitRemoteTitlePrefix '^\[in\]'
sy match SPCGitRemoteTitle '^\[in\].*' contains=SPCGitRemoteTitlePrefix
sy match SPCGitRemoteHelpKey '" \zs[^:]*\ze[:]'
sy match SPCGitRemoteHelpTitle 'Git remote manager quickhelp'
sy match SPCGitRemoteHelp '^".*' contains=SPCGitRemoteHelpTitle,SPCGitRemoteHelpKey

hi def link SPCGitRemoteName Directory
hi def link SPCGitRemoteHelpKey Identifier
hi def link SPCGitRemoteTitlePrefix Identifier
hi def link SPCGitRemoteTitle Title
hi def link SPCGitRemoteHelpTitle Title
hi def link SPCGitRemoteHelp String
"
