# Gitflow release action

GitHub Action implementing the Gitflow release process. This GitHub Action needs a token with permissions to push to your main and develop branches.
If you have configured Branch protections, you will need a token with permissions to bypass these protections.

## Inputs

## `command`

**Required** Options are `start`, `finish` or `start_finish`.

## `tag`

**Required** Label to use for releasing.

## `main_branch`

**Optional** Branch name storing releases history. Default `master`.

## `develop_branch`

**Optional** Branch name used to integrate feature branches. Default `develop`.

## Outputs

No outputs

## Example usage
```yml
uses: actions/gitflow-release-action@v1
with:
  command: start_finish
  tag: 1.0.0
  main_branch: master
  develop_branch: develop
```
