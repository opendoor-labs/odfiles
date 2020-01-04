# $PATH modification
# zsh conveniently links path array and PATH env var
# to prepend new entry - `path=(<new-addition> $path)`
# to append new entry - `path+=(<new-addition>)`

# make path array unique (a set)
typeset -U path

# python dependency manager
[[ -d "$HOME/.poetry/bin" ]] && path=("$HOME/.poetry/bin" $path)

[[ -d "$HOME/.cargo/bin" ]] && path=("$HOME/.cargo/bin" $path) # rust packages

# `rust-analyzer` language server
# built by $DOTFILES/infra/setup/bin/setup_language_servers
[[ -d "$DOTFILES/target/rust-analyzer/target/release" ]] && {
  path=("$DOTFILES/target/rust-analyzer/target/release" $path)
}

# homebrew
[[ -d "$HOMEBREW_PREFIX" ]] && {
  path=(
    "$HOMEBREW_PREFIX/bin"
    "$HOMEBREW_PREFIX/sbin"
    $path
  )

  # TODO: confirm this is needed
  [[ -d "$HOMEBREW_PREFIX/opt/fzf/bin" ]] && {
    path=("$HOMEBREW_PREFIX/opt/fzf/bin" $path)
  }

  # enable usage of `gmake` as `make` (`gmake` installed via `make` in Brewfile)
  [[ -d "$HOMEBREW_PREFIX/opt/make/libexec/gnubin" ]] && {
    path=("$HOMEBREW_PREFIX/opt/make/libexec/gnubin" $path)
  }
}
