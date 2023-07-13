#/bin/bash
REPO="nvim-neo-tree/neo-tree.nvim"
LAST_VERSION=$(curl --silent "https://api.github.com/repos/$REPO/releases/latest" | jq -r .tag_name)
echo "LAST_VERSION=$LAST_VERSION"
MAJOR=$(cut -d. -f1 <<<"$LAST_VERSION")
MINOR=$(cut -d. -f2 <<<"$LAST_VERSION")
echo

RELEASE_BRANCH="${1:-v${MAJOR}.x}"
echo "RELEASE_BRANCH=$RELEASE_BRANCH"
NEXT_VERSION=$MAJOR.$((MINOR+1))
NEW_VERSION="${2:-${NEXT_VERSION}}"
echo "NEW_VERSION=$NEW_VERSION"
echo

read -p "Are you sure you want to publish this release? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

git fetch
git checkout main
git pull
echo "Merging to ${RELEASE_BRANCH}"
git checkout $RELEASE_BRANCH
git pull
if git merge --ff-only origin/main; then
  git push
  git tag -a $NEW_VERSION -m "Release ${NEW_VERSION}"
  git push origin $NEW_VERSION
  echo "Creating Release"
  gh release create $NEW_VERSION --generate-notes
else
  echo "RELEASE FAILED! Could not fast-forward release to $RELEASE_BRANCH"
fi
git checkout main
