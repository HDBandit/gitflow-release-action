#!/bin/sh

command="$1"
tag="$2"
git_user="$3"
git_email="$4"
main_branch="$5"
develop_branch="$6"
allow_empty_releases="$7"
ignore_commits_from_author="$8"
ignore_commits_grep="$9"

check_execution_ok() {
  if [ $? -ne 0 ]
    then
      echo "result=fail" >> $GITHUB_OUTPUT
      exit 1
    fi
}

start_release() {
 git checkout -f "$main_branch"
 check_execution_ok
 git pull
 check_execution_ok
 git checkout -f -t -B "$develop_branch" origin/"$develop_branch"
 check_execution_ok

 echo "Creating branch release ..."
 git checkout -b release/"$tag"
 check_execution_ok
 echo "Branch release created!"
}

finalize_release() {
  git config user.name "$git_user"
  check_execution_ok
  git config user.email "$git_email"
  check_execution_ok
  git checkout "$main_branch"
  check_execution_ok
  git merge --no-ff release/"$tag"
  check_execution_ok
  git tag -a "$tag" -m "Release $tag"
  check_execution_ok
  git checkout "$develop_branch"
  check_execution_ok
  git merge --no-ff release/"$tag"
  check_execution_ok
  git fetch --tags origin
  check_execution_ok
  git merge "$tag"
  check_execution_ok

  echo "Pushing changes to remote ..."
  git push origin "$main_branch"
  check_execution_ok
  git push origin "$develop_branch"
  check_execution_ok
  git push origin --tags
  check_execution_ok
  echo "Changes to remote pushed!"

  echo "Deleting branch release/$tag ..."
  git checkout "$develop_branch"
  check_execution_ok
  git branch -d release/"$tag"
  check_execution_ok
  echo "Branch release/$tag deleted!"

  echo "result=success" >> $GITHUB_OUTPUT
  echo "commits=$commits" >> $GITHUB_OUTPUT
}

echo "Executing gitflow release command=$command, tag=$tag, git_users=$git_user, git_email=$git_email, main_branch=$main_branch, develop_branch=$develop_branch, allow_empty_releases=$allow_empty_releases, ignore_commits_from_author=$ignore_commits_from_author"
echo "Working directory is $(pwd)"

if [ "$command" = start ] || [ "$command" = start_finish ]; then
  start_release
fi

if [ "$command" = finish ] || [ "$command" = start_finish ]; then
  allCommitsMsg=$(git log --oneline --no-merges master...release/$tag)
  commits=$(git log --oneline --no-merges --format='%H' master...release/$tag | wc -l)
  check_execution_ok

  commitsInt=$(($commits + 0))

  echo "All new commits detected"
  echo "$allCommitsMsg"

  if [ "$ignore_commits_from_author" != "include_all_authors" && "$ignore_commits_grep" != "include_all_messages" ]; then
    excludeCommits=$(git log --oneline --author $ignore_commits_from_author --invert-grep --grep="$ignore_commits_grep" --no-merges --format='%H' master...release/$tag | wc -l)
    excludeCommitsInt=$(($excludeCommits + 0))

    commitsToExcludeMsg=$(git log --oneline --author $ignore_commits_from_author --invert-grep --grep="$ignore_commits_grep" --no-merges master...release/$tag)
    echo "Detail commits to exclude by $ignore_commits_from_author"
    echo "$commitsToExcludeMsg"
    echo "$excludeCommitsInt commits excluded (author=$ignore_commits_from_author and invert-grep=$ignore_commits_grep) from the release/$tag"

    commitsInt=$(($commitsInt - $excludeCommits))
  elif [ "$ignore_commits_from_author" != "include_all_authors" && "$ignore_commits_grep" = "include_all_messages" ]; then
    excludeCommits=$(git log --oneline --author $ignore_commits_from_author --no-merges --format='%H' master...release/$tag | wc -l)
    excludeCommitsInt=$(($excludeCommits + 0))

    commitsToExcludeMsg=$(git log --oneline --author $ignore_commits_from_author --no-merges master...release/$tag)
    echo "Detail commits to exclude by $ignore_commits_from_author"
    echo "$commitsToExcludeMsg"
    echo "$excludeCommitsInt commits excluded (author=$ignore_commits_from_author) from the release/$tag"

    commitsInt=$(($commitsInt - $excludeCommits))
  elif [ "$ignore_commits_from_author" = "include_all_authors" && "$ignore_commits_grep" != "include_all_messages" ]; then
      excludeCommits=$(git log --oneline --invert-grep --grep="$ignore_commits_grep" --no-merges --format='%H' master...release/$tag | wc -l)
      excludeCommitsInt=$(($excludeCommits + 0))

      commitsToExcludeMsg=$(git log --oneline --invert-grep --grep="$ignore_commits_grep" --no-merges master...release/$tag)
      echo "Detail commits to exclude by $ignore_commits_grep"
      echo "$commitsToExcludeMsg"
      echo "$excludeCommitsInt commits excluded (invert-grep=$ignore_commits_grep) from the release/$tag"

      commitsInt=$(($commitsInt - $excludeCommits))
  fi

  echo "$commitsInt commits included in the release/$tag"

  if [[ $commitsInt -ge 1 ]]; then
    echo "Release with $commitsInt commits included"
    finalize_release
  elif [ "$allow_empty_releases" = "true" ]; then
    echo "Empty release! But allow_empty_releases=true"
    finalize_release
  else
    echo "result=skipped" >> $GITHUB_OUTPUT
    echo "commits=0" >> $GITHUB_OUTPUT
    echo "Sorry :( , you need to work more! Skipping release due to 0 commits found in release/$tag ahead $main_branch"
  fi
fi