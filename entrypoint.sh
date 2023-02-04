#!/bin/sh

command="$1"
tag="$2"
main_branch="$3"
develop_branch="$4"
skip_empty_releases="$5"

echo "Executing gitflow release command=$command, tag=$tag, main_branch=$main_branch, develop_branch=$develop_branch, skip_empty_releases=$skip_empty_releases"
echo "Working directory is $(pwd)"

if [ "$command" = start ] || [ "$command" = start_finish ]; then
  git checkout -f "$main_branch"
  git pull
  git checkout -f -t -B "$develop_branch" origin/"$develop_branch"

  echo "Creating branch release ..."
  git checkout -b release/"$tag"
  echo "Branch release created!"
fi

if [ "$command" = finish ] || [ "$command" = start_finish ]; then
  commits=$(git log --no-merges --format='%H' master...release/$tag | wc -l)
  echo "$commits commits included in the release/$tag"

  if [[ $commits > 0 ] || $skip_empty_releases == "false" ]]; then
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