# this file sets the $PATH environment variable to enable various executables
#
# why set this here and not in `zshenv`? because macOS & certain Linux distros
# run `/etc/profile` after `zshenv` overwriting path modifications
# ref - https://stackoverflow.com/a/34244862
#
# zsh conveniently links `path` array and `PATH` env var
# to prepend new entry - `path=(<new-addition> $path)`
# to append new entry - `path+=<new-addition>` (`()` required to add >1 entry)

typeset -U path # make path array unique (a set)

# homebrew
[[ -d "$HOMEBREW_PREFIX" ]] && path=(
  "$HOMEBREW_PREFIX/bin"
  "$HOMEBREW_PREFIX/sbin"
  $path
)

[[ -d "$GOPATH/bin" ]] && path=("$GOPATH/bin" $path)
