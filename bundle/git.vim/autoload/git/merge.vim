let s:JOB = SpaceVim#api#import('job')

function! git#merge#run(args)
    if len(a:args) == 0
        finish
    else
        let cmd = ['git', 'merge'] + a:args
    endif
    call git#logger#info('git-merge cmd:' . string(cmd))
    let s:conflict_files = []
    call s:JOB.start(cmd,
                \ {
                \ 'on_stderr' : function('s:on_stderr'),
                \ 'on_stdout' : function('s:on_stdout'),
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

endfunction

function! s:on_exit(id, data, event) abort
    call git#logger#info('git-merge exit data:' . string(a:data))
    if a:data ==# 0
        echo 'merged done!'
    else
        call s:list_conflict_files()
        echo 'merged failed!'
    endif
endfunction

function! s:on_stdout(id, data, event) abort
    for data in a:data
        call git#logger#info('git-merge stdout:' . data)
        if data =~# '^CONFLICT'
            " CONFLICT (content): Merge conflict in test.txt
            let file = data[38:]
            call add(s:conflict_files, file)
        endif
    endfor
endfunction

function! s:on_stderr(id, data, event) abort
    for data in a:data
        call git#logger#info('git-merge stderr:' . data)
    endfor
    " stderr should not be added to commit buffer
    " let s:lines += a:data
endfunction

function! s:list_conflict_files() abort
    if !empty(s:conflict_files)
        let rst = []
        for file in s:conflict_files
            call add(rst, {
                        \ 'filename' : fnamemodify(file, ':p'),
                        \ })
        endfor
        call setqflist([], 'r', {'title': ' ' . len(rst) . ' items',
                    \ 'items' : rst
                    \ })
        botright copen
    endif
endfunction

" usage: git merge [<options>] [<commit>...]
" or: git merge --abort
" or: git merge --continue
"
" -n                    do not show a diffstat at the end of the merge
" --stat                show a diffstat at the end of the merge
" --summary             (synonym to --stat)
" --log[=<n>]           add (at most <n>) entries from shortlog to merge commit message
" --squash              create a single commit instead of doing a merge
" --commit              perform a commit if the merge succeeds (default)
" -e, --edit            edit message before committing
" --cleanup <mode>      how to strip spaces and #comments from message
" --ff                  allow fast-forward (default)
" --ff-only             abort if fast-forward is not possible
" --rerere-autoupdate   update the index with reused conflict resolution if possible
" --verify-signatures   verify that the named commit has a valid GPG signature
" -s, --strategy <strategy>
" merge strategy to use
" -X, --strategy-option <option=value>
" option for selected merge strategy
" -m, --message <message>
" merge commit message (for a non-fast-forward merge)
" -F, --file <path>     read message from file
" -v, --verbose         be more verbose
" -q, --quiet           be more quiet
" --abort               abort the current in-progress merge
" --quit                --abort but leave index and working tree alone
" --continue            continue the current in-progress merge
" --allow-unrelated-histories
" allow merging unrelated histories
" --progress            force progress reporting
" -S, --gpg-sign[=<key-id>]
" GPG sign commit
" --overwrite-ignore    update ignored files (default)
" --signoff             add Signed-off-by:
" --no-verify           bypass pre-merge-commit and commit-msg hooks


function! s:args_with_two() abort
    return join([
                \ '--stat',
                \ '--edit',
                \ '--ff',
                \ '--ff-only',
                \ '--abort',
                \ ], "\n")
endfunction

function! s:args_with_one() abort
    return join([
                \ '-m',
                \ '-e',
                \ ], "\n")

endfunction

function! git#merge#complete(ArgLead, CmdLine, CursorPos)
    if a:ArgLead =~# '^--'
        return s:args_with_two()
    elseif a:ArgLead =~# '^-'
        return s:args_with_one()
    endif

    return join(s:unmerged_branchs(), "\n")

endfunction

function! s:unmerged_branchs() abort
    return map(systemlist('git branch --no-merged'), 'trim(v:val)')
endfunction

