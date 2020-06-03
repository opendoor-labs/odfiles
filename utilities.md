# utilities

Resources for various utilities

- [`bat`](#bat-) - a prettier `cat` with syntax highlighting, line numbers, git highlights and paging
- [`exa`](#exa-) - a prettier `ls` with friendlier defaults
- [`fd`](#fd) - a faster `find` with friendlier defaults
- [`fzf`](./fzf.md) - easily fuzzily filter any list (files, directories, git branches, etc.)
- [`ripgrep`](#ripgrep-) - a faster `grep` with friendlier defaults
- [`z.lua`](https://github.com/skywind3000/z.lua) - quickly `cd` to folders based on frequency and recency of access

Wrote up [an explainer](https://gist.github.com/nathanshelly/4b7020d09d413cab823914b06162145a) that covers some of these plus a few others

## utilities w/o a separate README

### [`bat`](https://github.com/sharkdp/bat) 🦇

A prettier cat with syntax highlighting, line numbers, git highlights and paging.

### [`exa`](https://github.com/ogham/exa) 💎

A prettier ls that comes with friendlier defaults and adds extra contextual information (like git info with `exa --git`).

#### aliases

Defines a few aliases, using `exa` if installed, `ls` otherwise:

- `l` -> `exa` or `ls -CF` (one less letter 😃)
- `la` -> `exa --all` or `ls -AF` (list hidden files)
- `ll` -> `exa --long --all` or `ls -AFhl` (list all files w/ more detail in column view)

### [`fd`](https://github.com/sharkdp/fd)

A simpler, faster `find` (`fd` is to `find` as `ripgrep` is to `grep`). Skips hidden directories, respects `.gitignore` files, colorized terminal output, smart case (case-insensitive by default, case sensitive if pattern includes a capital).

Here is a heads up comparison on an arbitrary query:

```zsh
find . -iname '*TradeInStep*' -not -path '*/node_modules/*'
# or
fd TradeInStep
```

A few other usage examples:

```zsh
# search for files matching pattern (no more `find . -iname '*PATTERN*'`)
fd pattern

# include hidden and ignored files
fd --hidden --no-ignore pattern
```

### [`ripgrep`](https://github.com/BurntSushi/ripgrep) 🔎

A faster and generally more user friendly replacement for `grep`. It searches recursively by default, respects `.gitignore` (and `.ignore`) files, and skips hidden and binary files.

[Here's](https://blog.burntsushi.net/ripgrep/) a writeup of more details on the tool by it's creator including detailed benchmarks.

Here is a heads up comparison on an arbitrary query:

```zsh
# takes ~30 seconds w/o `--exlude-dir` (this exclude also wouldn't cover all
# files ignored by ripgrep, e.g. go build files, python virtualenvironments, etc.)
grep -r TradeInStep . --exclude-dir=node_modules --color -n

rg TradeInStep
```

Here are some usage examples:

```zsh
# recursively search current directory for pattern
rg pattern

# include .gitignored and hidden files
rg -uu pattern

# search for whole word matches in files matching the given glob
rg -w @types/lodash -g 'package.json'
```

#### aliases

`f` is aliased to `rg` in `$DOTFILES/zsh/alias.zsh`. Generic alias so that if the underlying utility changes muscle memory is preserved.

Adds several additional aliases, a few highlights:

- `ff` - search literal strings
- `fnt` - exclude test/spec files from search
- `ft` - search only test/spec files
- `fu` - ignore `.gitignore` & `.ignore` files, include hidden files/directories & binary files
- `fw` - only match whole words
