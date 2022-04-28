function! github#api#repos#Response() abort
    let l:keys = ['owner', 'git_url', 'collaborators_url', 'fork', 'notifications_url', 'languages_url', 'size', 'name', 'clone_url',
                \'created_at', 'tags_url', 'pushed_at', 'language', 'ssh_url', 'git_tags_url', 'has_pages', 'open_issues_count',
                \'mirror_url', 'description', 'events_url', 'has_wiki', 'deployments_url', 'has_issues', 'milestones_url',
                \'compare_url', 'releases_url', 'updated_at', 'forks', 'blobs_url', 'subscription_url', 'trees_url',
                \'watchers', 'keys_url', 'full_name', 'contents_url', 'issue_comment_url', 'teams_url', 'assignees_url',
                \'default_branch', 'url', 'has_downloads', 'comments_url', 'labels_url', 'commits_url', 'open_issues',
                \'archive_url', 'git_commits_url', 'merges_url', 'issues_url', 'issue_events_url', 'watchers_count',
                \'downloads_url', 'html_url', 'id', 'hooks_url', 'subscribers_url', 'svn_url', 'branches_url', 'pulls_url',
                \'private', 'forks_count', 'homepage', 'stargazers_count', 'forks_url', 'contributors_url', 'statuses_url',
                \'stargazers_url', 'git_refs_url']
    return l:keys
endfunction

""
" Get a single repository
" @public
" GET /repos/:owner/:repo
function! github#api#repos#get_repo(owner, repo) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo, [])
endfunction
