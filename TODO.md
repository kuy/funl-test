TODO
====

## Memo

- `funl feed`で定義済みのシェル関数をクリアしてから再定義できるようにする
- zshとかのフックで自動的にfeedできないか調べる

## Issues

- Actual test suit doesn't test 'funl' shell function
  - run on zsh and bash
- Test case for 'utils' script

## Limitations

- Doesn't support result which contains new lines

## Must

- [upgrade] Prepare '--edge' option to grab latest master
- [version] Improve `funl --version` result
  - tag with revision
- [proc] Validate on register hooks to prevent invalid command names
  - Empty string, symbols, spaces
- [proc] Ignore placeholders if not defined
  - Provide option to this
- [config] Duplicated definition
  - Which definition is used? first or last?
- Move all tasks to GitHub issues
  - and setup milestones

## Idea/Wish

- Testing basic functions with real peco/percol
- [select] Support multiple selection
  - Add support command to process multiple selection
    - For example, convert "one item per one item" format to "comma separated" or "space separated"
- [hook/unhook] Should these commands return 1 instead of 0 when error occurred?
- `git diff {branch} {branch} Gemfile`
  - Select different branch for each placeholder
  - Provide option to this problem
- Project specific configuration
  - Nearest .funlrc file is used, and fallback to global config
- [select] Option to auto-select if only one option is available
- Utility command to define static 'src'
  - `funl gen "apple" "banana" "cherry"` => `echo -e "apple\\nbanana\\ncherry"`
- Syntax for inserting value without peco's interaction
  - git push origin {{current-branch}}
- Context for placeholders
  - Different behaviour between `kill {ps}` and `pkill {ps}`
    - In `kill` command, {ps} will insert process ID
    - In `pkill` command, {ps} will insert process name
- Plugin mechanism for 'src' and 'post'
  - Install and select plugins using `funl`
- [hook] Raise warning if given command does not exist
- [hook] Add '-f' option to ignore warning
- Compare execution time of `funl git` and normal `git`
- Execute command in parallel using peco's multiple selection
- Enable in-place selector like `funl unhook {hooks}`

## Continue

- Improve help content of individual commands
