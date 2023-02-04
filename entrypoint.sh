#!/bin/sh

set -e

command=${INPUT_COMMAND}
tag=${INPUT_TAG}
main_branch=${INPUT_MAIN_BRANCH}
develop_branch=${INPUT_DEVELOP_BRANCH}

echo "Executing gitflow release command=$command, tag=$tag, main_branch=$main_branch and develop_branch=$develop_branch"
echo "Working directory is $(pwd)"

if [ "$command" = start ] || [ "$command" = start_finish ]; then
  git checkout -f "$main_branch"
  git pull
  git checkout -f -t -B "$develop_branch origin/$develop_branch"

  echo "Creating branch release ..."
  git checkout -b release/"$tag"
  echo "Branch release created!"
fi

if [ "$command" = finish ] || [ "$command" = start_finish ]; then
  commits=$(git log --no-merges --format='%H' master...release/$tag | wc -l)

  if (( commits > 0 )); then
    git config user.name github-actions
    git config user.email github-actions@github.com
    git checkout "$main_branch"
    git merge --no-ff release/"$tag"
    git tag -a "$tag" -m "Release $tag"
    git checkout "$develop_branch"
    git merge --no-ff release/"$tag"
    git fetch --tags origin
    git merge "$tag"

    echo "Pushing changes to remote ..."
    git push origin "$main_branch"
    git push origin "$develop_branch"
    git push origin --tags
    echo "Changes to remote pushed!"

    echo "Deleting branch release/$tag ..."
    git checkout "$develop_branch"
    git branch -d release/"$tag"
    echo "Branch release/$tag deleted!"
  else
    echo "Sorry :( , you need to work more! Skipping release due to 0 commits found in release/$tag ahead $main_branch"
  fi
fi