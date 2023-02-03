#!/bin/sh

command=${INPUT_COMMAND}
tag=${INPUT_TAG}
message=${INPUT_MESSAGE}
main_branch=${INPUT_MAIN_BRANCH}
develop_branch=${INPUT_DEVELOP_BRANCH}

if [ "$command" = start ] || [ "$command" = start_finish ]; then
  git checkout -f "$main_branch"
  git pull
  git checkout -f -t -B "$develop_branch origin/$develop_branch"

  echo "Creating branch release"
  git checkout -b "release/$tag" "'git rev-list -n 1 --date=relative --before="1 day ago" $develop_branch'"
fi

if [ "$command" = finish ] || [ "$command" = start_finish ]; then
  git config user.name github-actions
  git config user.email github-actions@github.com
  git checkout "$main_branch"
  git merge --no-ff release/"$tag"
  git tag -a "$tag_name" -m "${{ steps.release-info.outputs.TAG_MESSAGE }}"
  git checkout develop
  git merge --no-ff release/${{ steps.last_release.outputs.tag_name }}
  git fetch --tags origin
  git merge ${{ steps.last_release.outputs.tag_name }}

  echo "Pushing changes to remote"
#  git push origin "$main_branch"
#  git push origin "$develop_branch"
#  git push origin --tags

  echo "Deleting branch release/$tag"
#  git checkout "$develop_branch"
#  git branch -d release/"$tag"
fi