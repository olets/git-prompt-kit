<img src="./img/git-prompt-kit.png" alt="">

# Git Prompt Kit ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/git-prompt-kit) ![GitHub commits since latest release (by SemVer including pre-releases)](https://img.shields.io/github/commits-since/olets/git-prompt-kit/latest)

**Git Prompt Kit** is a configurable set of components for creating feature rich, high performance Git-aware zsh prompts (aka themes) with minimal coding. It is built on gitstatus, the same accelerated `git status` alternative used by Powerlevel10k.

Try the interactive demo! https://git-prompt-kit.olets.dev/

&nbsp;

> 🎉 The next major version of Git Prompt Kit is in the works, complete with a brand new documentation site. Take a look in the [`v4` branch](https://github.com/olets/git-prompt-kit/tree/v4)

&nbsp;

- [Installation](#installation)
- [Default prompt](#default-prompt)
- [Options](#options)
- [Components](#components)
- [Performance](#performance)
- [Acknowledgments](#acknowledgments)
- [Changelog](#changelog)
- [Contributing](#contributing)
- [License](#license)

&nbsp;

## Installation

Shell plugin manager is the recommended installation method.

### With a shell plugin manager

1. Install `olets/git-prompt-kit` with a zsh plugin manager. Each has their own way of doing things. See your package manager's documentation or the [zsh plugin manager plugin installation procedures gist](https://gist.github.com/olets/06009589d7887617e061481e22cf5a4a).

    After adding the plugin to the manager, restart zsh:

    ```shell
    exec zsh
    ```

### Manual

Either clone this repo and add `source path/to/git-prompt-kit.zsh` to your `.zshrc`, or

1. Download [the latest Git Prompt Kit binary](https://github.com/olets/git-prompt-kit/releases/latest)
1. Put the file `git-prompt-kit` in a directory in your `PATH`

Then restart zsh:

```shell
exec zsh
```

### Prompt manager

You can use Git Prompt Kit to create a custom, high-performance Spaceship Git section or Starship Git module. Starting points for both are in [Recipes.md](Recipes.md).

The Git Prompt Kit Spaceship section has been clocked at 50% faster than Spaceship's own Git section. The Git Prompt Kit Starship module has been clocked at about 10% to 30% faster than Starship's own Git module.

## Examples

To get a feel for the components try the interactive demo: <a href="https://git-prompt-kit.olets.dev/">https://git-prompt-kit.olets.dev/</a>.

See [Recipes.md](Recipes.md) for code how to use Git Prompt Kit components to build a high-performance prompt styled after [git-radar](https://github.com/michaeldfallen/git-radar), [oh-my-git](https://github.com/arialdomartini/oh-my-git), [Pure](https://github.com/sindresorhus/pure), or [Spaceship](https://github.com/denysdovhan/spaceship-prompt).

[Hometown](https://github.com/olets/hometown-prompt) is a theme built entirely of Git Prompt Kit components.

## Options

Set variables in `.zshrc`. For example, to only show the user if _not_ `me`, only show the host if _not_ `my-computer` or `my-other-computer`, and use symbols to distinguish between branches and commits:

```shell
# ~/.zshrc
# --- snip ---
GIT_PROMPT_KIT_HIDDEN_HOSTS=( my-computer my-other-computer )
GIT_PROMPT_KIT_HIDDEN_USERS=( me )
GIT_PROMPT_KIT_SYMBOL_BRANCH="#"
GIT_PROMPT_KIT_SYMBOL_COMMIT="•"
# Load Git Prompt Kit (will differ depending on installation method)
```

To output your configuration, for example for sharing, run

```shell
git-prompt-kit-config
```

(The exporter makes an effort to get quoting right, but if you use a custom configuration with quotation marks it's worth double checking that the exported value is correct.)

### Behavior options

Name | Type | Description | Default
---|---|---|---
`GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND` | number | Hide dimmed symbols for the commits ahead of and commits behind the upstream branch when the count is zero? (HIDE if non-zero, SHOW if zero) | `1`
`GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS` | number | Hide dimmed Git stash, assumed-unchanged, and skip-worktree symbols when the count is zero? (HIDE if non-zero, SHOW if zero) | `1`
`GIT_PROMPT_KIT_HIDE_TOOL_NAMES` | number | Do not show the word "Git" before the Git ref info? (HIDE if non-zero, SHOW if zero) | `1`
`GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS` | number | Show Git status symbols (dimmed) when the count is zero? (SHOW if non-zero, HIDE if zero) | `1`

### Color options

Colors can be

- one of zsh's eight color names (`black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan` and `white`; see http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting)
- an integer 1-255 for an 8-bit color (see https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit)
- or a #-prefixed 3- or 6-character hexadecimal value for 24-bit color (e.g. `#fff`, `#34d5eb`)

Support varies by terminal emulator.

> Tip: To check a color it can be useful to run `print -P %F{<color>}<text>%f`, for example `print -P %F{199}●%f`.

See [Issue #1: README appendix: default colors' swatches](https://github.com/olets/git-prompt-kit/issues/1) for the following table but with swatches. They may appear differently in your terminal.

To visualize the configured colors, run

```shell
git-prompt-kit-colors
```

To print the configured values, run

```shell
git-prompt-kit-config
```

Name | Type | Description | Default
---|---|---|---
`GIT_PROMPT_KIT_COLOR_ACTION` | string | Color of the Git action segment | `199`
`GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED` | string | Color of the Git assumed unchaged files segment | `81`
`GIT_PROMPT_KIT_COLOR_FAILED` | string | Color of the prompt character when the previous command failed | `88`
`GIT_PROMPT_KIT_COLOR_HEAD` | string | Color of the Git HEAD segment when the working tree is dirty | `140`
`GIT_PROMPT_KIT_COLOR_HOST` | string | Color of the host segment | `109`
`GIT_PROMPT_KIT_COLOR_INACTIVE` | string | Color of inactive segments | `247`
`GIT_PROMPT_KIT_COLOR_PUSH_REMOTE` | string | Color of the Git push remote and its commits-ahead files segment | `111`
`GIT_PROMPT_KIT_COLOR_REMOTE` | string | Color of the Git remote and its commits-ahead files segment | `216`
`GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE` | string | Color of the Git skip-worktree files segment | `81`
`GIT_PROMPT_KIT_COLOR_STAGED` | string | Color of Git staged files segment  | `120`
`GIT_PROMPT_KIT_COLOR_STASH` | string | Color of the Git stashes segment | `81`
`GIT_PROMPT_KIT_COLOR_SUCCEEDED` | string | Color of the prompt character when the previous command succeeded | `76`
`GIT_PROMPT_KIT_COLOR_TAG` | string | Color of Git tag segment | `86`
`GIT_PROMPT_KIT_COLOR_UNSTAGED` | string | Color of Git unstaged files segment | `162`
`GIT_PROMPT_KIT_COLOR_USER` | string | Color of the user | `109`
`GIT_PROMPT_KIT_COLOR_CWD` | string | Color of the directory segment | `39`

### Content options

To print the configured values, run

```shell
git-prompt-kit-config
```

Name | Type | Description | Default
---|---|---|---
`GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT` | integer | The maximum number of trailing path components in the `GIT_PROMPT_KIT_CWD`. Additional components will be ellided with `...`. If less than zero, show all | `1`
`GIT_PROMPT_KIT_DEFAULT_PUSH_REMOTE_NAME` | string | The default Git push remote | `upstream`
`GIT_PROMPT_KIT_DEFAULT_REMOTE_NAME` | string | The default Git remote | `origin`
`GIT_PROMPT_KIT_HIDDEN_HOSTS` | array | The hosts that will not be included in the prompt | `()`
`GIT_PROMPT_KIT_HIDDEN_USERS` | array | The users that will not be included in the prompt | `()`
`GIT_PROMPT_KIT_LOCAL` | string | Shown if the checked-out branch has no upstream | `local`
`GIT_PROMPT_KIT_REPO_SUBDIRECTORY_MAX_TRAILING_COUNT` | integer | The maximum number of trailing path components in `GIT_PROMPT_KIT_REPO_SUBDIRECTORY`. Additional components will be ellided with `...`. If less than zero, show all | `1`

### Symbol options

To print the configured values, run

```shell
git-prompt-kit-config
```

The default symbols should work well in any font.

The default Git file status symbols are based on [Git's own short format](https://git-scm.com/docs/git-status#_short_format) (underscore `_` represents empty columns in `git-status --short`'s output). The alternate "verbose" set of default symbols take up more space, but their meaning may be clearer.

Name | Type | Description | Default / verbose
---|---|---|---
`GIT_PROMPT_KIT_VERBOSE_DEFAULT_SYMBOLS` | string | Set to a non-empty string to enable the verbose default symbols | empty string
|||
`GIT_PROMPT_KIT_SYMBOL_AHEAD` | string | Precedes the Git commits-ahead segment | `+` / `ahead `
`GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED` | string | Follows the Git assume-unchanged segment | `⥱ ` / `assumed unchanged`
`GIT_PROMPT_KIT_SYMBOL_BEHIND` | string | Precedes the Git commits-behind segment | `-` / `behind `
`GIT_PROMPT_KIT_SYMBOL_BRANCH` | string | Precedes the Git branch | none / `branch: `
`GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL` | string | Character shown at end of prompt for normal users | `%%` * / `commit: `
`GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT` | string | Character shown at end of prompt for root users | `#` / 
`GIT_PROMPT_KIT_SYMBOL_COMMIT` | string | Precedes the Git commit | none / `commit: `
`GIT_PROMPT_KIT_SYMBOL_CONFLICTED` | string | Follows the Git conflicted files segment | `UU` / ` conflicted`
`GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED` | string | Follows the Git unstaged deleted file segment | `D_` / ` staged deleted`
`GIT_PROMPT_KIT_SYMBOL_DELETED` | string | Follows the Git unstaged deleted file segment | `_D` / ` deleted`
`GIT_PROMPT_KIT_SYMBOL_HOST` | string | Precedes the host | `@` / ` host: `
`GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED` | string | Follows the Git staged modified file segment | `M_` / ` modified staged`
`GIT_PROMPT_KIT_SYMBOL_MODIFIED` | string | Follows the Git unstaged modified file segment | `_M` / ` modified`
`GIT_PROMPT_KIT_SYMBOL_NEW` | string | Follows Git new file segment | `A_` / ` new`
`GIT_PROMPT_KIT_SYMBOL_PUSH_REMOTE` | string | Precedes the Git push remote | `@{push}` / `push remote: `
`GIT_PROMPT_KIT_SYMBOL_REMOTE` | string | Precedes the Git remote | `@{u}` / `remote: `
`GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE` | string | Follows the Git skip-worktree file segment | `⤳` / ` skip worktree`
`GIT_PROMPT_KIT_SYMBOL_STASH` | string | Follows the Git stash segment | `⇲` / ` stashes`
`GIT_PROMPT_KIT_SYMBOL_TAG` | string | Precedes the Git tag | `@` / `tag: `
`GIT_PROMPT_KIT_SYMBOL_UNTRACKED` | string | Follows Git untracked file segment | `??` / ` untracked`

\* `%%` expands as `%` in the zsh prompt.

## Components

To use Git Prompt Kit's components in a custom prompt, load Git Prompt Kit and then refer to any of its components.

For example, to create the minimal prompt `<current working directory> [<Git HEAD> ]% `:

Minimal configuration, using Git Prompt Kit for the Git part only:

```shell
# ~/.zshrc
# --- snip ---
# Load Git Prompt Kit (will differ depending on installation method)
PROMPT='%1d ${GIT_PROMPT_KIT_HEAD:+$GIT_PROMPT_KIT_HEAD }%% '
```

Using Git Prompt Kit for everything

```shell
# ~/.zshrc
# --- snip ---
# Load Git Prompt Kit (will differ depending on installation method)
PROMPT='$GIT_PROMPT_KIT_CWD ${GIT_PROMPT_KIT_HEAD:+$GIT_PROMPT_KIT_HEAD }$GIT_PROMPT_KIT_CHAR '
```

### Atom components

Name | Type | Description
---|---|---
`GIT_PROMPT_KIT_ACTION` | prompt string | Git: current action (e.g. "rebase")
`GIT_PROMPT_KIT_AHEAD` | prompt string | Git: commits ahead of the upstream
`GIT_PROMPT_KIT_ASSUMED_UNCHANGED` | prompt string | Git: assume-unchanged files count
`GIT_PROMPT_KIT_BEHIND` | prompt string | Git: commits behind the upstream
`GIT_PROMPT_KIT_CHAR` | prompt string | Prompt character
`GIT_PROMPT_KIT_CONFLICTED` | prompt string | Git: conflicted files count
`GIT_PROMPT_KIT_DELETED` | prompt string | Git: unstaged deleted files count
`GIT_PROMPT_KIT_DELETED_STAGED` | prompt string | Git: staged deleted files count
`GIT_PROMPT_KIT_HEAD` | prompt string | Git: HEAD (branch or commit)
`GIT_PROMPT_KIT_MODIFIED` | prompt string | Git: unstaged modified files count
`GIT_PROMPT_KIT_MODIFIED_STAGED` | prompt string | Git: staged modified files count
`GIT_PROMPT_KIT_NEW` | prompt string | Git: (staged) new files count
`GIT_PROMPT_KIT_PUSH_AHEAD` | prompt string | Git: commits ahead of the push remote
`GIT_PROMPT_KIT_PUSH_BEHIND` | prompt string | Git: commits behind the push remote
`GIT_PROMPT_KIT_PUSH` | prompt string | Git: push remote if not the default
`GIT_PROMPT_KIT_REMOTE` | prompt string | Git: `GIT_PROMPT_KIT_LOCAL` if no upstream; upstream branch if the name differs from the local branch; upstream remote and branch if the remote is not the default
`GIT_PROMPT_KIT_REPO_ROOT` | prompt string | Git root directory, underlined, with trailing directories.
`GIT_PROMPT_KIT_REPO_SUBDIRECTORY` | prompt string | Subdirectory relative to the Git root
`GIT_PROMPT_KIT_SKIP_WORKTREE` | prompt string | Git: skip-worktree files count
`GIT_PROMPT_KIT_STASHES` | prompt string | Git: stash count
`GIT_PROMPT_KIT_TAG` | prompt string | Git: up to one tag at HEAD
`GIT_PROMPT_KIT_UNTRACKED` | prompt string | Git: untracked (not staged) files count
`GIT_PROMPT_KIT_USERHOST` | prompt string | User (if not configured as hidden) and host (if not configured as hidden)

### Molecule components

Name | Type | Description
---|---|---
`GIT_PROMPT_KIT_CHAR` | prompt string | `GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL` or `GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT`
`GIT_PROMPT_KIT_CWD` | prompt string | If in a Git repo, `GIT_PROMPT_KIT_REPO_ROOT` and `GIT_PROMPT_KIT_REPO_SUBDIRECTORY`. Otherwise current working directory with trailing directories.
`GIT_PROMPT_KIT_REF` | prompt string | `GIT_PROMPT_KIT_HEAD`, `GIT_PROMPT_KIT_AHEAD`, `GIT_PROMPT_KIT_BEHIND`, `GIT_PROMPT_KIT_REMOTE`, `GIT_PROMPT_KIT_PUSH`, `GIT_PROMPT_KIT_PUSH_AHEAD`, `GIT_PROMPT_KIT_PUSH_BEHIND`, and `GIT_PROMPT_KIT_TAG`
`GIT_PROMPT_KIT_STATUS` | prompt string | `GIT_PROMPT_KIT_UNTRACKED`, `GIT_PROMPT_KIT_CONFLICTED`, `GIT_PROMPT_KIT_DELETED`, `GIT_PROMPT_KIT_MODIFIED`, `GIT_PROMPT_KIT_NEW`, `GIT_PROMPT_KIT_DELETED_STAGED`, and `GIT_PROMPT_KIT_MODIFIED_STAGED`
`GIT_PROMPT_KIT_STATUS_EXTENDED` | prompt string | `GIT_PROMPT_KIT_STASHES`, `GIT_PROMPT_KIT_ASSUMED_UNCHANGED`, and `GIT_PROMPT_KIT_SKIP_WORKTREE`

### Other components

Name | Type | Description
---|---|---
`GIT_PROMPT_KIT_DIRTY` | number | Equal to `1` if the Git worktree is dirty

## Performance

Git Prompt Kit adds less than 10ms to the time between prompts, as measured by [`zsh-prompt-benchmark`](https://github.com/romkatv/zsh-prompt-benchmark). It is built on gitstatus, the same accelerated `git status` alternative used by Powerlevel10k. See [gitstatus](https://github.com/romkatv/gitstatus) for details.

## Acknowledgments

Git Prompt Kit is built on Roman Perepelitsa's [gitstatus](https://github.com/romkatv/gitstatus).

Showing "dimmed" components was inspired by Arialdo Martini's [oh-my-git](https://github.com/arialdomartini/oh-my-git), which leaves space for inactive symbols.

Using Git status's short format was inspired by Michael Allen's [git-radar](https://github.com/michaeldfallen/git-radar).

Splash card font is Beon by [Bastien Sozeau](http://sozoo.fr/).

## Changelog

See the [CHANGELOG](CHANGELOG.md) file.

## Contributing

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/git-prompt-kit/issues) to see if your topic has been discussed before or if it is being worked on.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## License

<a href="https://www.github.com/olets/git-prompt-kit">git-prompt-kit</a> by <a href="https://www.github.com/olets">Henry Bley-Vroman</a> is licensed under a license which is the unmodified text of <a href="https://creativecommons.org/licenses/by-nc-sa/4.0">CC BY-NC-SA 4.0</a> and the unmodified text of a <a href="https://firstdonoharm.dev/build?modules=eco,extr,media,mil,sv,usta">Hippocratic License 3</a>. It is not affiliated with Creative Commons or the Organization for Ethical Source.

Human-readable summary of (and not a substitute for) the [LICENSE](LICENSE) file:

You are free to

- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material

Under the following terms

- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
- Non-commercial — You may not use the material for commercial purposes.
- Ethics - You must abide by the ethical standards specified in the Hippocratic License 3 with Ecocide, Extractive Industries, US Tariff Act, Mass Surveillance, Military Activities, and Media modules.
- Preserve terms — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
- No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

## Acknowledgments

- The human-readable license summary is based on https://creativecommons.org/licenses/by-nc-sa/4.0. The ethics point was added.
