# bin

Various setup scripts

- [`setup_brew`](./setup_brew) - install [Homebrew](https://brew.sh) and formulae specified in [`Brewfile`](../../Brewfile)
- [`symlink`](./symlink) - symlink all necessary config files to their respective locations (e.g. `$DOTFILES/zsh/zshrc` -> `$HOME/.zshrc`)
- [`setup_zsh`](./setup_zsh) - adds [`zsh`](http://zsh.sourceforge.net/) to `/etc/shells`, sets it to the default shell, and loads `zsh` to install plugins & finish installation
