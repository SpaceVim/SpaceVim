import hashlib
import json
import os
import shlex
import string
import subprocess
import threading
import time
import urllib
from past.builtins import basestring  # Works in python 2 and 3
from past.builtins import map, filter  # Python 2 map compatibility

try:
    # Python 2
    # import basestring
    import urllib2
except ImportError:
    print("Using Python3")

    # Python 3 re-organizes urllib
    from urllib.parse import urlencode
    import urllib.request as urllib2
    urllib.urlencode = urlencode

import vim

SHOW_ALL = "[Show all issues]"
SHOW_ASSIGNED_ME = "[Only show assigned to me]"
SHOW_COMMITS = "## [Commits]"
SHOW_FILES_CHANGED = "## [Files Changed]"

# dictionaries for caching
# repo urls on github by filepath
github_repos = {}
# issues by repourl
github_datacache = {}
# api data by repourl + / + endpoint
api_cache = {}
# process handles by file hash
proc_handle = {}
# whether or not a async request is pending by file hash
proc_pending = {}

# reset web cache after this value grows too large
cache_count = 0

# whether or not SSL is known to be enabled
ssl_enabled = False

# keep a list of issues
globissues = {}

# returns the Github url (i.e. jaxbot/vimfiles) for the current file


def getRepoURI():
    global github_repos

    if "gissues" in vim.current.buffer.name:
        parens = getFilenameParens()
        return parens[0] + "/" + parens[1]

    # get the directory the current file is in
    filepath = vim.eval("expand('%:p:h')")

    # Remove trailing ".git" segment from path.
    # While `git remote -v` appears to work from here in general, it fails when
    # invoked for COMMIT_EDITMSG: `fatal: Not a git repository: '.git'`.
    filepath = filepath.split(os.path.sep + ".git")[0]

    # cache the github repo for performance
    if github_repos.get(filepath, None) is not None:
        return github_repos[filepath]

    # Get info for all remotes.
    # Do this first: if it fails, we're not in a Git repo.
    try:
        all_remotes = subprocess.check_output(
            ['git', 'remote', '-v'], cwd=filepath)
    except subprocess.CalledProcessError:
        github_repos[filepath] = ""
        return github_repos[filepath]
    except OSError:
        all_remotes = subprocess.check_output(['git', 'remote', '-v'])

    # Try to get the remote for the current branch/HEAD.
    try:
        remote_ref = subprocess.check_output(
            'git rev-parse --abbrev-ref --verify --symbolic-full-name @{upstream}'.split(" "),
            stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError:
        # Use the first one we find instead
        remote = None
        #print("github-issues: using default remote: %s" % remote)
    else:
        try:
            branch = subprocess.check_output(
                ["git", "symbolic-ref", "--short", "HEAD"])
        except subprocess.CalledProcessError:
            # Branch could not be determined, do not filter by remote.
            remote = None
        else:
            # Remove "/branch" from the end of remote_ref to get the remote.
            remote = remote_ref[:-(len(branch) + 1)]

    # possible URLs
    possible_urls = vim.eval("g:github_issues_urls")

    for line in all_remotes.decode().split("\n"):
        try:
            cur_remote, url = line.split("\t")
        except ValueError:
            continue

        # Filter out non-matching remotes.
        if remote and remote.decode() != cur_remote:
            continue

        # Remove " (fetch)"/" (pull)" and ".git" suffixes.
        url = url.split(" ", 1)[0]
        if url.endswith(".git"):
            url = url[:-4]

        # Skip any unwanted urls.
        for possible_url in possible_urls:
            split_url = url.split(possible_url)
            if len(split_url) > 1:
                github_repos[filepath] = split_url[1]
                #print("github-issues: using repo: %s" % s[1])
                break
        else:
            continue
        break
    else:
        github_repos[filepath] = ""

    return github_repos[filepath]

# returns the repo uri, taking into account forks


def getUpstreamRepoURI():
    repourl = getRepoURI()
    if repourl == "":
        return ""

    upstream_issues = int(vim.eval("g:github_upstream_issues"))
    if upstream_issues == 1:
        # try to get from what repo forked
        repoinfo = ghApi("", repourl)
        if repoinfo and repoinfo["fork"]:
            repourl = repoinfo["source"]["full_name"]

    return repourl


def showCommits(split=False):
    number = vim.eval("b:ghissue_number")
    repourl = vim.eval("b:ghissue_repourl")
    url = ghUrl("/pulls/" + number + "/commits", repourl)
    response = urllib2.urlopen(url, timeout=2)
    commits = json.loads(response.read())
    buffer_name = "commits/" + repourl + "/" + number
    if split:
        newSplit(buffer_name)
    else:
        newTab(buffer_name)
    vim.command("setlocal modifiable")
    current_buffer = vim.current.buffer
    for commit in commits:
        current_buffer.append(
            (commit['sha'] + " " + commit['commit']['message']).split("\n"))
    vim.command("normal ggdd")
    vim.command(
        "nnoremap <buffer> <CR> :call <SID>showIssueLink('','','False')<cr>")
    vim.command("nnoremap <buffer> s :call <SID>showIssueLink('','','True')<cr>")
    vim.command("call <SID>commitHighlighting()")
    vim.command("let b:ghissue_repourl=\"" + repourl + "\"")
    vim.command("setlocal nomodifiable")


def showCommit(sha, split=False):
    repourl = vim.eval("b:ghissue_repourl")
    url = ghUrl("/commits/" + sha, repourl)
    headers = {"Accept": "application/vnd.github.patch"}
    req = urllib2.Request(url, None, headers)
    diff = urllib2.urlopen(req, timeout=2)
    buffer_name = "commit/" + repourl + "/" + sha
    if split:
        newSplit(buffer_name)
    else:
        newTab(buffer_name)
    vim.command("set syn=diff")
    vim.command("setlocal modifiable")
    current_buffer = vim.current.buffer
    current_buffer.append("".join(diff).split("\n"))
    vim.command("normal ggdd")
    vim.command("setlocal nomodifiable")


def showFilesChanged(split=False):
    number = vim.eval("b:ghissue_number")
    repourl = vim.eval("b:ghissue_repourl")
    url = ghUrl("/pulls/" + number, repourl)
    headers = {"Accept": "application/vnd.github.diff"}
    req = urllib2.Request(url, None, headers)
    diff = urllib2.urlopen(req, timeout=2)
    buffer_name = "files_Changed/" + repourl + "/" + number
    if split:
        newSplit(buffer_name)
    else:
        newTab(buffer_name)
    vim.command("set syn=diff")
    vim.command("setlocal modifiable")
    current_buffer = vim.current.buffer
    current_buffer.append("".join(diff).split("\n"))
    vim.command("normal ggdd")
    vim.command("setlocal nomodifiable")


def newTab(name):
    vim.command("noswapfile silent tabe +set\\ buftype=nofile %s" % name)
    mapQuit()


def newSplit(name):
    vim.command(
        "noswapfile silent belowright vsplit +set\\ buftype=nofile %s" %
        name)
    mapQuit()


def mapQuit():
    vim.command("nnoremap <buffer> <silent> q :bdelete<CR>")

# displays the issues in a vim buffer


def showIssueList(labels, ignore_cache=False, only_me=False):
    repourl = getUpstreamRepoURI()

    if repourl == "":
        print("github-issues.vim: Failed to find a suitable Github repository URL, sorry!")
        vim.command("let github_failed = 1")
        return

    issues = getIssueList(repourl, '/issues', labels, ignore_cache, only_me)

    printIssueList(issues, repourl, labels, only_me)


def printIssueList(issues, repourl='search', labels=False, only_me=False):
    global globissues
    globissues = issues

    # Setup split
    if not vim.eval("g:github_same_window") == "1":
        cmd = 'silent '
        if not vim.eval("g:gissues_list_vsplit") == "1":
            spl = 'new +set\ buftype=nofile'
            if vim.eval("g:gissues_split_height") != "0":
                spl = ' ' + vim.eval("g:gissues_split_height") + spl
            cmd = cmd + spl
        else:
            spl = 'vnew +set\ buftype=nofile'
            if vim.eval("g:gissues_vsplit_width") != "0":
                spl = ' ' + vim.eval("g:gissues_vsplit_width") + spl
            cmd = cmd + spl
        if vim.eval("g:gissues_split_expand") == "1":
            cmd = 'botright ' + cmd
        vim.command(cmd)

    if 'labels' not in locals():
        labels = ""

    # Some Vim versions don't allow noswapfile as a verb
    try:
        vim.command("noswapfile edit " + "gissues/" + repourl + "/issues")
    except BaseException:
        vim.command("edit " + "gissues/" + repourl + "/issues")

    vim.command("normal ggdG")

    current_buffer = vim.current.buffer

    cur_milestone = str(vim.eval("g:github_current_milestone"))
    # its an array, so dump these into the current (issues) buffer
    for issue in issues:
        if cur_milestone != "" and (
                not issue["milestone"] or issue["milestone"]["title"] != cur_milestone):
            continue

        issuestr = str(issue["number"]) + " " + issue["title"]
        if 'labels' in issue:
            for label in issue["labels"]:
                issuestr += " [" + label["name"] + "]"

        current_buffer.append(issuestr.encode(vim.eval("&encoding")))

    if len(current_buffer) < 2:
        current_buffer.append("No results found in " + repourl)
    if cur_milestone:
        current_buffer.append("Filtering by milestone: " + cur_milestone)
    if labels:
        current_buffer.append("Filtering by labels: " + labels)
    if cur_milestone or labels or only_me:
        current_buffer.append(SHOW_ALL)
    if not only_me:
        current_buffer.append(SHOW_ASSIGNED_ME)

    highlightColoredLabels(getLabels(), True)

    # append leaves an unwanted beginning line. delete it.
    vim.command("1delete _")


def showSearchList():
    if not vim.eval("g:github_same_window") == "1":
        vim.command("silent new")

    # Some Vim versions don't allow noswapfile as a verb
    try:
        vim.command("noswapfile edit " + "gissues")
    except BaseException:
        vim.command("edit " + "gissues")

    vim.command("normal ggdG")
    params = {"q": vim.eval("g:gh_issues_query")}

    issues = getGHList(1, "custom", 'search/issues', params)
    printIssueList(issues)


def showMilestoneList(labels, ignore_cache=False):
    repourl = getUpstreamRepoURI()

    vim.command("silent new")

    # Some Vim versions don't allow noswapfile as a verb
    try:
        vim.command("noswapfile edit " + "gissues/" + repourl + "/milestones")
    except BaseException:
        vim.command("edit " + "gissues/" + repourl + "/milestones")
    vim.command("normal ggdG")

    current_buffer = vim.current.buffer
    current_buffer.append("[None]")

    milestones = getMilestoneList(repourl, labels, ignore_cache)

    for mstone in milestones:
        mstonestr = mstone["title"]

        current_buffer.append(mstonestr.encode(vim.eval("&encoding")))

    vim.command("1delete _")

# pulls the issue array from the server


def getIssueList(repourl, endpoint, query, ignore_cache=False, only_me=False):
    global github_datacache

    # non-string args correspond to vanilla issues request
    # strings default to label unless they correspond to a state
    params = {}
    if isinstance(query, basestring):
        params = {"labels": query}
    if query in ["open", "closed", "all"]:
        params = {"state": query}
    if only_me:
        params["assignees"] = getCurrentUser()

    return getGHList(ignore_cache, repourl, endpoint, params)


def getCurrentUser():
    return ghApi("", "user", True, False)["login"]

# pulls the milestone list from the server


def getMilestoneList(repourl, query="", ignore_cache=False):
    global github_datacache

    # TODO Add support for 'state', 'sort', 'direction'
    params = {}

    return getGHList(ignore_cache, repourl, "/milestones", params)


def getGHList(ignore_cache, repourl, endpoint, params):
    global cache_count, github_datacache

    # Maybe initialise
    if github_datacache.get(
            repourl, '') == '' or len(
            github_datacache[repourl]) < 1:
        github_datacache[repourl] = {}

    if (ignore_cache or
        github_datacache[repourl].get(endpoint, '') == '' or
        len(github_datacache[repourl].get(endpoint, '')) < 1 or
            time.time() - github_datacache[repourl][endpoint][0]["cachetime"] > 60):

        # load the github API. github_repo looks like
        # "jaxbot/github-issues.vim", for ex.
        try:
            github_datacache[repourl][endpoint] = []
            more_to_load = True

            page = 1

            while more_to_load and page <= int(
                    vim.eval("g:github_issues_max_pages")):
                params['page'] = str(page)

                # TODO This should be in ghUrl() I think
                qs = urllib.urlencode(params)
                if repourl != "custom":
                    url = ghUrl(endpoint + '?' + qs, repourl)
                else:
                    url = ghUrl(endpoint + '?' + qs, repourl, False)

                response = urllib2.urlopen(url, timeout=2)
                issuearray = json.loads(response.read())

                if 'items' in issuearray:
                    issuearray = issuearray["items"]

                # JSON parse the API response, add page to previous pages if
                # any
                github_datacache[repourl][endpoint] += issuearray

                more_to_load = len(issuearray) == 30

                page += 1

        except urllib2.URLError as e:
            github_datacache[repourl][endpoint] = []
            if "code" in e and e.code == 404:
                print(
                    "github-issues.vim: Error: Do you have a github_access_token defined?")

        if len(github_datacache[repourl][endpoint]) > 0:
            github_datacache[repourl][endpoint][0]["cachetime"] = time.time()

    return github_datacache[repourl][endpoint]

# populate the omnicomplete synchronously or asynchronously, depending on mode


def populateOmniComplete():
    if vim.eval("g:gissues_async_omni") == "1":
        if vim.eval("g:gissues_offline_cache") == "1":
            populateOmniCompleteFromDisk()
        else:
            populateOmniCompleteAsync()
    else:
        doPopulateOmniComplete()


def populateOmniCompleteFromDisk():
    url = getUpstreamRepoURI()

    if url == "":
        return

    issues = grabCacheData("/issues")
    for issue in issues:
        addToOmni(str(issue["number"]) + " " + issue["title"], 'Issue')

    labels = grabCacheData("/labels")
    if labels is not None:
        for label in labels:
            addToOmni(unicode(label["name"]), 'Label')

    contributors = grabCacheData("/stats/contributors")
    if contributors is not None:
        for contributor in contributors:
            addToOmni(str(contributor["author"]["login"]), 'user')

    milestones = getMilestoneList(url)
    if milestones is not None:
        for milestone in milestones:
            addToOmni(str(milestone["title"].encode('utf-8')), 'Milestone')


def apiToDiskAsync(endpoint):
    repourl = getUpstreamRepoURI()
    url = ghUrl(endpoint, repourl)
    filepath = getFilePathForURL(url)
    proc_handle[filehash] = subprocess.Popen(
        shlex.split("curl " + url),
        stdout=open(filepath, "w"),
        stderr=open(os.devnull, 'wb')
    )
    proc_pending[filehash] = True


def cacheFromDisk(endpoint):
    repourl = getUpstreamRepoURI()
    url = ghUrl(endpoint, repourl)
    filepath = getFilePathForURL(url)
    try:
        jsonfile = open(filepath)
        data = json.load(jsonfile)
        api_cache[repourl + "/" + endpoint] = data
        return data
    except Exception as e:
        return None


def grabCacheData(endpoint):
    repourl = getUpstreamRepoURI()
    url = ghUrl(endpoint, repourl)
    filepath = getFilePathForURL(url)

    # If something was pending and we have fresh data,
    # replace what is in memory with the disk data
    if proc_pending.get(filepath):
        if proc_handle[filepath].poll() is not None:
            proc_pending[filepath] = False
            return cacheFromDisk(filepath)

    if api_cache.get(repourl + "/" + endpoint):
        return api_cache[repourl + "/" + endpoint]

    apiToDiskAsync(endpoint)
    return cacheFromDisk(endpoint)


def getContributors():
    return ghApi("/stats/contributors")

# adds issues, labels, and contributors to omni dictionary


def doPopulateOmniComplete():
    url = getUpstreamRepoURI()

    if url == "":
        return

    issues = getIssueList(url, "/issues", 0)
    for issue in issues:
        addToOmni(str(issue["number"]) + " " + issue["title"], 'Issue')

    labels = getLabels()
    if labels is not None:
        for label in labels:
            addToOmni(unicode(label["name"]), 'Label')

    contributors = getContributors()
    if contributors is not None:
        for contributor in contributors:
            addToOmni(str(contributor["author"]["login"]), 'user')

    milestones = getMilestoneList(url)
    if milestones is not None:
        for milestone in milestones:
            addToOmni(str(milestone["title"].encode('utf-8')), 'Milestone')

# calls populateOmniComplete asynchronously


def populateOmniCompleteAsync():
    thread = AsyncOmni()
    thread.start()


class AsyncOmni(threading.Thread):
    def run(self):
        # Download and cache the omnicomplete data
        url = getUpstreamRepoURI()

        if url == "":
            return

        issues = getIssueList(url, '/issues', 0)
        labels = getLabels()
        contributors = getContributors()
        milestones = getMilestoneList(url)

# adds <keyword> to omni dictionary. used by populateOmniComplete


def addToOmni(keyword, typ):
    vim.command("call add(b:omni_options, " +
                json.dumps({'word': keyword, 'menu': '[' + typ + ']'}) + ")")


def showIssueLink(number, url="", split="False"):
    if url != "":
        repourl = url
    else:
        repourl = getUpstreamRepoURI()

    # convert string to boolean
    split = split == "True"
    word = vim.eval("expand('<cword>')")

    line = vim.eval("getline(\".\")")
    if line == SHOW_COMMITS:
        showCommits(split)
    elif line == SHOW_FILES_CHANGED:
        showFilesChanged(split)
    elif len(word) == 40:
        showCommit(word, split)

    return

# handle user pressing enter on the gissue list
# possible actions: view issue, filter by label, filter by assignees,
# remove filters


def showIssueBuffer(number, url=False):
    if url:
        repourl = url
    elif 'search/issues' in vim.current.buffer.name:
        line_number = vim.eval("line('.')-1")
        html_url = globissues[int(line_number)]['html_url']
        html_url_split = html_url.split("/")
        repourl = html_url_split[3] + "/" + html_url_split[4]
    else:
        repourl = getUpstreamRepoURI()

    line = vim.eval("getline(\".\")")
    if line == SHOW_ALL:
        showIssueList(0, "True")
        return
    if line == SHOW_ASSIGNED_ME:
        showIssueList(0, "True", "True")
        return

    labels = getLabels()
    if labels is not None:
        for label in labels:
            if str(label["name"]) == number:
                showIssueList(number, "True")
                return

    if number != "new":
        vim.command("normal! 0")
        number = vim.eval("expand('<cword>')")

    if not vim.eval("g:github_same_window") == "1":
        cmd = 'silent '
        if not vim.eval("g:gissues_issue_vsplit") == "1":
            spl = 'new +set\ buftype=nofile'
            if vim.eval("g:gissues_split_height") != "0":
                spl = ' ' + vim.eval("g:gissues_split_height") + spl
            cmd = cmd + spl
        else:
            spl = 'vnew +set\ buftype=nofile'
            if vim.eval("g:gissues_vsplit_width") != "0":
                spl = ' ' + vim.eval("g:gissues_vsplit_width") + spl
            cmd = cmd + spl
        if vim.eval("g:gissues_split_expand") == "1":
            cmd = 'botright ' + cmd
        vim.command(cmd)

    vim.command("edit gissues/" + repourl + "/" + number)

# show an issue buffer in detail


def showIssue(number=False, repourl=False):
    if repourl is False:
        repourl = getUpstreamRepoURI()

    if number is False:
        parens = getFilenameParens()
        number = parens[2]

    b = vim.current.buffer
    vim.command("normal ggdG")

    if number == "new":
        # new issue
        issue = {'title': '',
                 'body': '',
                 'number': 'new',
                 'user': {
                     'login': ''
                 },
                 'assignees': '',
                 'state': 'open',
                 'labels': []
                 }
    else:
        url = ghUrl("/issues/" + number, repourl)
        issue = json.loads(urllib2.urlopen(url, timeout=2).read())
        if "pull_request" in issue:
            pull_request_url = ghUrl("/pulls/" + number, repourl)
            pull_request = json.loads(
                urllib2.urlopen(
                    pull_request_url,
                    timeout=2).read())
        vim.command("let b:ghissue_url=\"" + issue["html_url"] + "\"")
        vim.command("let b:ghissue_number=" + number)
        vim.command("let b:ghissue_repourl=\"" + repourl + "\"")

    encoding = vim.eval("&encoding")

    b.append("## Title: " +
             issue["title"].encode(encoding).decode(encoding) +
             " (" +
             str(issue["number"]) +
             ")")
    if issue["user"]["login"]:
        b.append(
            "## Reported By: " +
            issue["user"]["login"].encode(encoding).decode(encoding))

    b.append("## State: " + issue["state"])
    if issue['assignees']:
        b.append(
            "## Assignees: " +
            ' '.join(
                i["login"].encode(encoding).decode(encoding) for i in issue["assignees"]))
    else:
        b.append("## Assignees: ")

    if number == "new":
        b.append("## Milestone: ")
    elif issue['milestone']:
        b.append("## Milestone: " + str(issue["milestone"]["title"]))

    labelstr = ""
    if issue["labels"]:
        for label in issue["labels"]:
            labelstr += label["name"] + ", "
    b.append("## Labels: " + labelstr[:-2])

    if number != "new" and "pull_request" in issue:
        b.append("## Branch Name: " + str(pull_request["head"]["ref"]))
        b.append(SHOW_COMMITS)
        b.append(SHOW_FILES_CHANGED)

    # This part breaks Python 3
    if issue["body"]:
        lines = issue["body"].encode(encoding).decode(encoding).split("\n")
        b.append(map(lambda line: line.rstrip(), lines))

    if number != "new":
        b.append("## Comments")

        url = ghUrl("/issues/" + number + "/comments", repourl)
        data = urllib2.urlopen(url, timeout=2).read()
        comments = json.loads(data)

        url = ghUrl("/issues/" + number + "/events", repourl)
        data = urllib2.urlopen(url, timeout=2).read()
        events = json.loads(data)

        events = comments + events

        if len(events) > 0:
            for event in events:
                b.append("")
                if "user" in event:
                    user = event["user"]["login"]
                else:
                    user = event["actor"]["login"]

                b.append(user.encode(encoding).decode(
                    encoding) + "(" + event["created_at"] + ")")

                if "body" in event:
                    lines = event["body"].encode(
                        encoding).decode(encoding).split("\n")
                    b.append(map(lambda line: line.rstrip(), lines))
                else:
                    eventstr = event["event"].encode(encoding).decode(encoding)
                    if "commit_id" in event and event["commit_id"]:
                        eventstr += " from " + event["commit_id"]
                    b.append(eventstr)

        else:
            b.append("")
            b.append("No comments.")
            b.append("")

        b.append("## Add a comment")
        b.append("")

    vim.command("nnoremap <buffer> <silent> q :q<CR>")
    vim.command("set ft=gfimarkdown")
    vim.command("normal ggdd")

    highlightColoredLabels(getLabels())

    # mark it as "saved"
    vim.command("setlocal nomodified")

# saves an issue and pushes it to the server


def saveGissue():
    token = vim.eval("g:github_access_token")
    if not token:
        print("github-issues.vim: In order to save an issue or add a comment, you need to define a GitHub token. See: https://github.com/jaxbot/github-issues.vim#configuration")
        return

    parens = getFilenameParens()
    number = parens[2]
    encoding = "utf-8"  # TODO: Get this from vim

    issue = {
        'title': '',
        'body': '',
        'assignees': '',
        'labels': '',
        'milestone': ''
    }

    commentmode = 0

    comment = ""

    for line in vim.current.buffer:
        if commentmode == 1:
            if line == "## Add a comment":
                commentmode = 2
            continue
        if commentmode == 2:
            if line != "":
                commentmode = 3
                comment += line + "\n"
            continue
        if commentmode == 3:
            comment += line + "\n"
            continue

        if line == "## Comments":
            commentmode = 1
            continue
        if len(line.split("## Reported By:")) > 1:
            continue

        title = line.split("## Title:")
        if len(title) > 1:
            issue['title'] = title[1].strip().split(" (" + number + ")")[0]
            continue

        state = line.split("## State:")
        if len(state) > 1:
            if state[1].strip().lower() == "closed":
                issue['state'] = "closed"
            else:
                issue['state'] = "open"
            continue

        milestone = line.split("## Milestone:")
        if len(milestone) > 1:
            milestones = getMilestoneList(parens[0] + "/" + parens[1], "")

            milestone = milestone[1].strip()

            for mstone in milestones:
                if mstone["title"] == milestone:
                    issue['milestone'] = str(mstone["number"])
                    break
            continue

        labels = line.split("## Labels:")
        if len(labels) > 1:
            issue['labels'] = labels[1].lstrip().split(', ')
            continue

        assignees = line.split("## Assignees:")
        if len(assignees) > 1:
            issue['assignees'] = assignees[1].lstrip().split(' ')
            continue

        if line == SHOW_COMMITS or line == SHOW_FILES_CHANGED or "## Branch Name:" in line:
            continue

        if issue['body'] != '':
            issue['body'] += '\n'
        issue['body'] += line

    # remove blank entries
    issue['labels'] = filter(bool, issue['labels'])

    if number == "new":

        if issue['assignees'] == '':
            del issue['assignees']
        if issue['milestone'] == '':
            del issue['milestone']
        if issue['body'] == '':
            del issue['body']

        data = ""
        try:
            repourl = getUpstreamRepoURI()
            url = ghUrl("/issues", repourl)
            data = json.dumps(issue).encode(encoding)
            request = urllib2.Request(url, data)
            data = json.loads(urllib2.urlopen(request, timeout=2).read())
            parens[2] = str(data['number'])
            vim.current.buffer.name = "gissues/" + \
                parens[0] + "/" + parens[1] + "/" + parens[2]
        except urllib2.HTTPError as e:
            if "code" in e and e.code == 410 or e.code == 404:
                print(
                    "github-issues.vim: Error creating issue. Do you have a github_access_token defined?")
            else:
                print("github-issues.vim: Unknown HTTP error:")
                print(e)
                print(data)
                print(url)
                print(issue)
    else:
        repourl = vim.eval("b:ghissue_repourl")
        url = ghUrl("/issues/" + number, repourl)
        data = json.dumps(issue).encode(encoding)
        # TODO: Fix POST data should be bytes.
        request = urllib2.Request(url, data)
        request.get_method = lambda: 'PATCH'
        try:
            urllib2.urlopen(request, timeout=2)
        except urllib2.HTTPError as e:
            if "code" in e and e.code == 410 or e.code == 404:
                print("Could not update the issue as it does not belong to you!")

    if commentmode == 3:
        try:
            url = ghUrl("/issues/" + parens[2] + "/comments", repourl)
            data = json.dumps({'body': comment}).encode(encoding)
            request = urllib2.Request(url, data)
            urllib2.urlopen(request, timeout=2)
        except urllib2.HTTPError as e:
            if "code" in e and e.code == 410 or e.code == 404:
                print(
                    "Could not post comment. Do you have a github_access_token defined?")

    if commentmode == 3 or number == "new":
        showIssue()

    # mark it as "saved"
    vim.command("setlocal nomodified")

# updates an issues data, such as opening/closing


def setIssueData(issue):
    parens = getFilenameParens()
    repourl = getUpstreamRepoURI()
    url = ghUrl("/issues/" + parens[2], repourl)
    request = urllib2.Request(url, json.dumps(issue))
    request.get_method = lambda: 'PATCH'
    urllib2.urlopen(request, timeout=2)

    showIssue()


def getLabels():
    return ghApi("/labels")


def getContributors():
    return ghApi("/stats/contributors")

# adds labels to the match system


def highlightColoredLabels(labels, decorate=False):
    if not labels:
        labels = []

    labels.append({'name': 'closed', 'color': 'ff0000'})
    labels.append({'name': 'open', 'color': '00aa00'})

    for label in labels:
        # Dummy failsafe value
        xtermcolor = "242"

        # If we've loaded xterm colors, calculate one
        if vim.eval("g:gissues_xterm_colors") != "0":
            xtermcolor = rgb_to_xterm(label["color"])[1:]

        vim.command(
            "hi issueColor" +
            label["color"] +
            " ctermbg=" +
            xtermcolor +
            " guifg=#ffffff guibg=#" +
            label["color"])
        name = label["name"]
        if decorate:
            name = "\\\\[" + name + "\\\\]"
        else:
            name = "\\\\<" + name + "\\\\>"
        vim.command(
            "let m = matchadd(\"issueColor" +
            label["color"] +
            "\", \"" +
            name +
            "\")")
    vim.command("hi issueButton guifg=#ffffff guibg=#333333 ctermbg=DarkGray")
    vim.command("let m = matchadd(\"issueButton\", \"\\\\[.*how.*\\\\]\")")

# queries the ghApi for <endpoint>


def ghApi(endpoint, repourl=False, cache=True, repo=True):
    global ssl_enabled
    data = None

    if not repourl:
        repourl = getUpstreamRepoURI()

    if cache and api_cache.get(repourl + "/" + endpoint):
        return api_cache[repourl + "/" + endpoint]

    if not ssl_enabled:
        try:
            import ssl
            ssl_enabled = True
        except BaseException:
            print("SSL appears to be disabled or not installed on this machine. Please reinstall Python and/or Vim.")

    url = ghUrl(endpoint, repourl, repo)
    filepath = getFilePathForURL(url)
    if vim.eval("g:gissues_offline_cache") and cache:
        try:
            jsonfile = open(filepath)
            data = json.load(jsonfile)
            return data
        except Exception as e:
            # fallback to downloading
            pass

    try:
        req = urllib2.urlopen(url, timeout=5)
        request_data = req.read()
        data = json.loads(request_data)

        cache_file = open(filepath, "w")
        cache_file.write(request_data)
        cache_file.close()

        api_cache[repourl + "/" + endpoint] = data

        return data
    except Exception as e:
        if vim.eval("g:gissues_offline_cache") == "1":
            try:
                jsonfile = open(filepath)
                data = json.load(jsonfile)
                print("Github-issues.vim is in OFFLINE mode")
                return data
            except Exception as e:
                pass
        if vim.eval("g:gissues_show_errors") != "0":
            print(
                "github-issues.vim: An error occurred. If this is a private repo, make sure you have a github_access_token defined. Call: " +
                endpoint +
                " on " +
                repourl)
            print(e)
        return None


def getFilePathForURL(url):
    return os.path.expanduser("~/.vim/.gissue-cache/") + \
        hashlib.sha224(url.encode('utf-8')).hexdigest()

# generates a github URL, including access token


def ghUrl(endpoint, repourl=False, repo=True):
    params = ""
    token = vim.eval("g:github_access_token")
    if token:
        if "?" in endpoint:
            params = "&"
        else:
            params = "?"
        params += "access_token=" + token

    if repo:
        repourl = "repos/" + repourl

    if repourl == "custom":
        return vim.eval("g:github_api_url") + endpoint + params
    else:
        return vim.eval("g:github_api_url") + \
            urllib2.quote(repourl) + endpoint + params

# returns an array of parens after gissues in filename


def getFilenameParens():
    return vim.current.buffer.name.replace(
        "\\", "/").split("gissues/")[1].split("/")


def createDirectory(path):
    try:
        os.makedirs(path)
    except OSError:
        if not os.path.isdir(path):
            raise


if vim.eval("g:gissues_offline_cache") == "1":
    createDirectory(os.path.expanduser("~/.vim"))
    createDirectory(os.path.expanduser("~/.vim/.gissue-cache"))
