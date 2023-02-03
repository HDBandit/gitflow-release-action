# Gitflow release action

This action prints "Hello World" or "Hello" + the name of a person to greet to the log.

## Inputs

## `command`

**Required** The name of the person to greet. Default `"World"`.

## `tag`

**Required** The name of the person to greet. Default `"World"`.

## `message`

**Required** The name of the person to greet. Default `"World"`.

## `main_branch`

**Required** The name of the person to greet. Default `"World"`.

## `develop_branch`

**Required** The name of the person to greet. Default `"World"`.

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
