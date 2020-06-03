#! /usr/bin/env zsh

# add back initizialization of compinit
autoload -U compinit
# ignore insecure directories (side-effect of `brew`'s installation methods)
# ref - https://stackoverflow.com/a/43544733
compinit -u

# case insensitive completion
# ref - https://superuser.com/questions/1092033/how-can-i-make-zsh-tab-completion-fix-capitalization-errors-for-directorys-and
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# `yes` - select first item on initial tab
# `select` - highlight options in tab-complete
zstyle ':completion:*' menu yes select
