""
" @public
" Create an release
"
" Input: >
" {
"  "tag_name": "v1.0.0",
"  "target_commitish": "master",
"  "name": "v1.0.0",
"  "body": "Description of the release",
"  "draft": false,
"  "prerelease": false
" }
" <
" Github API: POST /repos/:owner/:repo/releases
function! github#api#repos#releases#Create(owner,repo,user,password, release) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/releases',
                \ ['-X', 'POST', '-d', json_encode(a:release),
                \ '-u', a:user . ':' . a:password])
endfunction


""
" @public
" Get the latest release
"
" Github API: GET /repos/:owner/:repo/releases/latest
function! github#api#repos#releases#latest(owner, repo)
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/releases/latest', [])
endfunction


""
" @public
" List assets for a release
"
" Github API: GET /repos/:owner/:repo/releases/:id/assets
function! github#api#repos#releases#list_assets(owner, repo, release_id)

    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/releases/' . a:release_id . '/assets', [])

endfunction

" TODO Get a single release
" TODO Get a release by tag name
" TODO Edit a release
" TODO Delete a release
" TODO Upload a release asset
" TODO List releases for a repository
" TODO Get a single release asset
" TODO Edit a release asset
" TODO Delete a release asset


