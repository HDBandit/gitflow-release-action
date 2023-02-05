# Gitflow release action

GitHub Action implementing the Gitflow release process. 

## Prerequisites

If you have configured Branch protections, you will need a token with permissions to bypass these protections.
On the other hand, remember to enable `Read-Write` permissions for GithubActions in your repository.

## Inputs

## `command`

**Required** Options are `start`, `finish` or `start_finish`.

## `tag`

**Required** Label to use for releasing.

## `main_branch`

**Optional** Branch name storing releases history. Default `master`.

## `develop_branch`

**Optional** Branch name used to integrate feature branches. Default `develop`.

## `allow_empty_releases`

**Optional** Allow releases branch with 0 commits ahead your main branch. Default `false`.

## Outputs

## `result`

It returns `success` or `fail`.

## `commits`

It returns the number of commits included in the release in case of ending with a success.

## Example usage
For `start` and `finish` a release in one command
```yml
uses: HDBandit/gitflow-release-action@1.0.1
with:
  command: start_finish
  tag: 1.0.0
  main_branch: master
  develop_branch: develop
  allow_empty_releases: false
```

For `start` a release
```yml
uses: HDBandit/gitflow-release-action@1.0.1
with:
  command: start
  tag: 1.0.0
  main_branch: master
  develop_branch: develop
  allow_empty_releases: false
```

For `finish` a release
```yml
uses: HDBandit/gitflow-release-action@1.0.1
with:
  command: finish
  tag: 1.0.0
  main_branch: master
  develop_branch: develop
  allow_empty_releases: false
```
