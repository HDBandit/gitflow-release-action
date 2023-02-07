# Gitflow release action

GitHub Action implementing the Gitflow release process. 

## Prerequisites

If you have configured Branch protections, you will need a token with permissions to bypass these protections. In this
[article](https://michaelheap.com/ultimate-guide-github-actions-authentication/) is well explained how to authenticate a GithubAction and obtain an installation token.
On the other hand, if you are using a GithubApp as committer (`git_user` and `git_email`), remember the user will be the `app name` and the email `<app_name>@users.noreply.github.com`.
For more details read the official documentation [here](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address)

Finally, remember to enable `Read-Write` permissions for GithubActions in your repository.

## Inputs

## `command`

**Required** Options are `start`, `finish` or `start_finish`.

## `tag`

**Required** Label to use for releasing.

## `git_user`

**Optional** Git committer identity.

## `git_email`

**Optional** Git committer email.

## `main_branch`

**Optional** Branch name storing releases history. Default `master`.

## `develop_branch`

**Optional** Branch name used to integrate feature branches. Default `develop`.

## `allow_empty_releases`

**Optional** Allow releases branch with 0 commits ahead your main branch. Default `false`.

## `ignore_commits_from_author`

**Optional** Ignore commits from a specific author. Default `include_all_authors`.

## Outputs

## `result`

It returns `success`, `fail` or `skipped` (in case there are 0 commits and `allow_empty_releases` is false).

## `commits`

It returns the number of commits included in the release in case of ending with a success.

## Example usage
For `start` and `finish` a release in one command
```yml
uses: HDBandit/gitflow-release-action@1.0.1
with:
  command: start_finish
  tag: 1.0.0
  git_user: github-actions # Optional
  git_email: github-actions@github.com # Optional
  main_branch: master # Optional
  develop_branch: develop # Optional
  allow_empty_releases: false # Optional
  ignore_commits_from_author: johndoe # Optional
```

For `start` a release
```yml
uses: HDBandit/gitflow-release-action@1.0.1
with:
  command: start
  tag: 1.0.0
  git_user: github-actions # Optional
  git_email: github-actions@github.com # Optional
  main_branch: master # Optional
  develop_branch: develop # Optional
  allow_empty_releases: false # Optional
  ignore_commits_from_author: johndoe # Optional
```

For `finish` a release
```yml
uses: HDBandit/gitflow-release-action@1.0.1
with:
  command: finish
  tag: 1.0.0
  git_user: github-actions # Optional
  git_email: github-actions@github.com # Optional
  main_branch: master # Optional
  develop_branch: develop # Optional
  allow_empty_releases: false # Optional
  ignore_commits_from_author: johndoe # Optional
```
