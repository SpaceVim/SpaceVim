#!/usr/bin/python3

# Download the latest KaoriYa Vim from the GitHub releases

import argparse
import calendar
import io
import json
import os
import sys
import time
import urllib.request, urllib.error

# Repository Name
repo_name = 'koron/vim-kaoriya'
gh_releases_url = 'https://api.github.com/repos/' + repo_name + '/releases'

# Asset name checker
def does_skip_asset(asset):
    return asset['name'].find('pdb') >= 0

# Arguments properties
arg_desc = 'Download the latest KaoriYa Vim from the GitHub releases'
arg_archs = ['all', 'win32', 'win64']
arg_default_arch = 'all'
arg_allow_prerelease = False


# Parse arguments
def parse_args():
    global parser
    parser = argparse.ArgumentParser(description=arg_desc)
    parser.add_argument('-c', '--check', action='store_true',
            help='only check the information of the latest release')
    parser.add_argument('--noprogress', action='store_true',
            help="Don't show the progress")
    parser.add_argument('-f', '--force', action='store_true',
            help='overwrite the download file')
    parser.add_argument('-n', '--filename', type=str, action='store',
            help='filename to save')
    parser.add_argument('-p', '--prerelease', action='store_true',
            default=arg_allow_prerelease,
            help='Allow downloading prerelease')
    parser.add_argument('-a', '--arch', type=str, action='store',
            choices=arg_archs, default=arg_default_arch,
            help='architecture to download')
    parser.add_argument('--auth', type=str, action='store',
            default=os.getenv('AUTH_TOKEN'),
            metavar="TOKEN", help='GitHub API token (Environment variable AUTH_TOKEN can be also used.)')
    return parser.parse_args()

# Get information of GitHub release
# see: https://developer.github.com/v3/repos/releases/
def get_rel_info(url, auth):
    if auth:
        # Unauthenticated requests are limited up to 60 requests per hour.
        # Authenticated requests are allowed up to 5,000 requests per hour.
        # See: https://developer.github.com/v3/#rate-limiting
        request = urllib.request.Request(url)
        request.add_header("Authorization", "token " + auth)
    else:
        request = url
    try:
        response = urllib.request.urlopen(request)
    except urllib.error.HTTPError as err:
        print('GitHub release not found. (%s)' % err.reason, file=sys.stderr)
        exit(1)
    return json.load(io.StringIO(str(response.read(), 'utf-8')))

# Show progress
def reporthook(count, blocksize, totalsize):
    size = count * blocksize
    if totalsize <= 0:
        print("\r{:,}".format(size))
    else:
        size = min(size, totalsize)
        print("\r{:,} / {:,} ({:.1%})".format(size, totalsize, size / totalsize), end='')

# Download the files
def download(args, rel_info):
    for asset in rel_info['assets']:
        if args.filename:
            name = args.filename
        else:
            name = asset['name']
        if does_skip_asset(asset):
            continue
        if args.arch != 'all' and asset['name'].find(args.arch) < 0:
            continue
        if os.path.isfile(name) and not args.force:
            print('File exists:', name)
            continue
        print('Downloading from:', asset['browser_download_url'])
        print('Downloading to:', name)
        if args.noprogress:
            hook = None
        else:
            hook = reporthook
        urllib.request.urlretrieve(asset['browser_download_url'], name, hook)
        # Set timestamp
        asset_time = time.strptime(asset['updated_at'], '%Y-%m-%dT%H:%M:%SZ')
        os.utime(name, times=(time.time(), calendar.timegm(asset_time)))
        if not args.noprogress:
            print()

def main():
    args = parse_args()
    if args.filename and args.arch == 'all':
        parser.error('-a must be specified when you specify -n.')

    if args.prerelease:
        rels_info = get_rel_info(gh_releases_url, args.auth)
        for rel in rels_info:
            if rel['draft']:
                continue
            gh_release_url = rel['url']
            break
        else:
            print('GitHub release not found.', file=sys.stderr)
            exit(1)
    else:
        gh_release_url = gh_releases_url + '/latest'

    rel_info = get_rel_info(gh_release_url, args.auth)
    print('Last release:', rel_info['name'])
    print('Created at:', rel_info['created_at'])

    if args.check:
        exit(0)

    download(args, rel_info)
    exit(0)


if __name__ == "__main__":
    main()
