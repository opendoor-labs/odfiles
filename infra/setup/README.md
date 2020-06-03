# setup

## list of files

- [`bin`](./bin) - executable setup scripts
- [`check_dotfiles_variable.sh`](./check_dotfiles_variable.sh) - verify that `$DOTFILES` environment variable is set, otherwise attempts to set it via user input (quits calling script (when sourced) if cancelled)
- [`setup_dotfiles`](./setup_dotfiles) - top-level setup script which calls each broken out script in [`./bin`](./bin)
