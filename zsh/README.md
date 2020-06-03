# [`zsh`](https://www.zsh.org)

A modern, backwards-compatible replacement for `bash` that offers essentially a superset of `bash`'s features.

## why `zsh`

`zsh` offers useful features such as complex scripting features, smart tab-completion, advanced globbing support and plugin support while preserving backwards compatibility. Additionally, in my anecdotal experience, `zsh` has greater support in the open source community.

### alternatives considered

#### [`bash`](https://linux.die.net/man/1/bash)

My reasons to not use `bash` are the inverse of why I use `zsh` (e.g. lack of advanced globbing, lack of useful scripting features, worse (in my experience) plugin support, etc.).

In a sign of `zsh`'s mainstreamness Apple is switching to `zsh` for its default shell in the next macOS version (as of 10/03/2019). That alone is not necessarily a reason to use it (especially since a factor in Apple's decision here is licensing related as opposed to end user satisfaction) but for anyone unsure about switching to `zsh` it may offer some surety of it's maturity/viability.

#### [`fish`](https://fishshell.com)

`fish` seems nice, especially its sane scripting syntax. For me, however, its improvements over `zsh` don't outweigh its lack of backwards compatibility.

#### [`nu`](https://github.com/nushell/nushell)

`nu` seems fascinating. I may even jump to it at some point in the future but it's not mature enough for me at the moment to want to make it my daily driver.

## skimmable list of files

- [`alias.zsh`](#aliaszsh) - define generic aliases
- [`completion.zsh`](#completionzsh) - initialize completion
- [`dynamic_env_vars.zsh`](./dynamic_env_vars.zsh) - set environment variables whose value requires dynamism (dependencies)
- [`functions.zsh`](#functionszsh) - autoload all functions (executable files) defined in `$DOTFILES/functions`
- [`fzf.zsh`](#fzfzsh) - configure `fzf`
- [`fzf_git.zsh`](#fzf_gitzsh) - set up `git`-related `fzf` bindings (e.g. `M-r` for branches, `M-t` for commits, etc.)
- [`git_aliases.zsh`](#git_aliaseszsh) - variety of useful aliases for `git` commands
- [`keymap.zsh`](#keymapzsh) - enable `vim` mode for [`zsh` line editor (`zle`)](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html) and define related keymappings
- [`local.zsh`](#localzsh) - local (computer-specific) overrides (gitignored & sourced only if it exists)
- [`manydots.zsh`](#manydotszsh) - add a `zle` widget to facilitate specifying relative directories multiple levels above the current directory (transforms `...` -> `../..`)
- [`plugins.zsh`](#pluginszsh) - enable and configure plugins. Managed by [`zinit`](https://github.com/zdharma/zinit).
- [`prompt.zsh`](#promptzsh) - configure prompt appearance (currently [`powerlevel10k`](https://github.com/romkatv/powerlevel10k))
- [`secrets.zsh`](#secretszsh) - store secrets such as API tokens (gitignored & sourced only if it exists)
- [`zshenv`](#zshenv) - define environment variables, loaded before any other file in this folder (this file defines `$DOTFILES`)
- [`zshrc`](#zshrc) - source every `*.zsh` throughout this repo (`$DOTFILES/**/*.zsh`) to set up config

## each file in more detail

### [`alias.zsh`](./alias.zsh)

Define generic aliases.

Notable aliases:

- `e` - `$EDITOR`, provides a generic command to edit a file regardless of the backing program
- `f` - `rg` if installed, `grep -R` otherwise. Similar to `e`, provides a generic command regardless of backing program.

### [`completion.zsh`](./completion.zsh)

Initialize completion. Uses a cache with a refresh every 20 hours to speed up shell load.

### [`dynamic_env_vars.zsh`](./dynamic_env_vars.zsh)

Currently only sets `$EDITOR` to `nvim`.

### [`functions.zsh`](./functions.zsh)

Autoload all functions (executable files) defined under `$DOTFILES/functions`.

### [`keymap.zsh`](./keymap.zsh)

Turn on `vim` mode for [`zle`](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html) and define related keymappings.

This is disabled by default & can be turned on by setting `vi-mode` to `true` in [`$DOTFILES/.files-settings.json`](../.files-settings.json).

Add keymappings to support text objects supported by `vim`. Each of the following can be used with `i` or `a` (e.g. `i<character>` or `a<character>`): `'`, `"`, \`, `{`, `(`, `[`, `<`.

Add keymappings to recreate behavior of [`vim-surround`](https://github.com/tpope/vim-surround) (that link provides usage examples).

Additional notable keymappings:

- insert mode
  - `jk` to escape insert mode
- normal mode
  - start/end of line movement
    - `'` moves to end of line (same behavior as `$`)
    - `"` moves to start of line (same behavior as `0`)
  - `v` to edit the current command in `$EDITOR`. Quitting the opened editor dumps the edited command to the command line for execution.

### [`fzf.zsh`](./fzf.zsh)

Enables completions/[keybindings](../fzf.md#keybindings) along with configuring commands/options.

### [`fzf_git.zsh`](./fzf_git.zsh)

Enables [`git`-related bindings](../fzf_git.md#git-bindings) (e.g. `M-r` for branches, `M-t` for commits, etc.).

### [`git_aliases.zsh`](./git_aliases.zsh)

Defines various useful `git` aliases. Most of these aliases avoid using pagers when possible.

This can be disabled by setting `git-aliases` to `false` in [`$DOTFILES/.files-settings.json`](../.files-settings.json).

A few of my most used:

- `gb` -> `git branch`
- `gcm` -> `git commit -m`
- `gco` -> `git checkout`
  - `gcom` -> `git checkout master`
- `gl` -> `git log`
- `gpl` -> `git pull`
- `gps` -> `git push`
- `gs` -> `git status --short --branch` - default to less verbose status
- `gr` -> `git rebase --interactive`
  - `gra` -> `git rebase --abort`
  - `grc` -> `git rebase --continue`
  - `grm` -> `git rebase --interactive master`
  - `gu` -> `git reset HEAD~` - undo last commit, retains all changes from the commits unstaged

### [`local.zsh`](./local.zsh)

Apply local (computer-specific) config (not secrets, for better hygiene those should be in `$DOTFILES/secrets.zsh`).

This file is not checked in to version control (ignored in `$DOTFILES/.gitignore`) and sourced only if it exists.

### [`manydots.zsh`](./manydots.zsh)

Add a `zle` widget to facilitate specifying relative directories multiple levels above the current directory.

Each `.` typed past `..` increases the level. For example, `cd ...` becomes `cd ../..`. Typing `.` again gives you `cd ../../..`.

### [`plugins.zsh`](./plugins.zsh)

Enable and configure plugins.

Managed by [`zinit`](https://github.com/zdharma/zinit).

### [`prompt.zsh`](./prompt.zsh)

Configure prompt appearance.

Currently using [`powerlevel10k`](https://github.com/romkatv/powerlevel10k). `powerlevel10k` is the [fastest prompt](https://github.com/romkatv/powerlevel10k#is-it-really-fast) I've found that provides the contextual information I want (`git` status, insert/normal mode indicator, last command status code, etc.). It accomplishes this through two primary mechanisms: asynchronous loading and a faster, custom-built [`git status`](https://github.com/romkatv/gitstatus). The asynchronous nature allows input nearly instanteously as contextual information loads in the background. The [faster `git status`](https://github.com/romkatv/gitstatus#why-fast) dramatically speeds up output of `git` contextual information.

Appearance:

![prompt](https://user-images.githubusercontent.com/9750687/74062058-49ce2e00-49a2-11ea-96a7-808db84e7844.png 'prompt')

### [`secrets.zsh`](./secrets.zsh)

Store secrets such as API tokens.

This file is not checked in to version control (ignored in `$DOTFILES/.gitignore`) and sourced only if it exists.

### [`zshenv`](./zshenv)

Define environment variables, loaded before any other file in this folder.

A few notable environment variables:

- `$DOTFILES` - specifies path to the root of this repo, used throughout `zsh` configuration
- `$HOMEBREW_PREFIX` - should be equivalent to `brew --prefix`. Hardcoded (dynamic between OSes) to the current stable location to avoid overhead of `brew --prefix` (~25 ms)

This file symlinked to `$HOME/.zshenv` by [`$DOTFILES/infra/setup/bin/symlink`](../infra/setup/bin/symlink)

### [`zshrc`](./zshrc)

Source every `*.zsh` in `$DOTFILES` (NOT just `.zsh` files in this folder) and autoload any functions in `functions` folders throughout this repo. Here is the loading order:

1. [`secrets.zsh`](./secrets.zsh) - only if this file exists
1. [`completion.zsh`](./completion.zsh)
1. [`keymap.zsh`](./keymap.zsh)
1. [`manydots.zsh`](./manydots.zsh)
1. [`dynamic_env_vars.zsh`](./dynamic_env_vars.zsh)
1. [`functions.zsh`](./functions.zsh)
1. [`alias.zsh`](./alias.zsh)
1. [`git_aliases.zsh`](./git_aliases.zsh)
1. [`fzf.zsh`](./fzf.zsh)
1. [`fzf_git.zsh`](./fzf_git.zsh)
1. [`plugins.zsh`](./plugins.zsh)
1. [`prompt.zsh`](./prompt.zsh)
1. [`local.zsh`](./local.zsh)

`zshrc` itself is loaded after `zshenv` based on `zsh`'s [startup file loading order](http://zsh.sourceforge.net/Intro/intro_3.html).

This file symlinked to `$HOME/.zshrc` by [`$DOTFILES/infra/setup/bin/symlink`](../infra/setup/bin/symlink)
