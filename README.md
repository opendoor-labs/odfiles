# odotfiles

macOS configuration for Opendoor employees.

## toc

- [why use this?](#why-use-this%3F)
  - [the pitch](#the-pitch)
  - [the anti-pitch](#the-anti-pitch)
  - [.files values](#.files-values)
- [getting started](#getting-started)
  - [next steps](#next-steps)
    - [add your own configuration](#add-your-own-configuration)
    - [add secrets safely](#add-secrets-safely)
    - [explore features/configuration](#explore-featuresconfiguration)

## why use this?

### the pitch

- features
  - [fuzzy searching anything and everything](https://user-images.githubusercontent.com/9750687/77736063-e9826280-6fc8-11ea-9cde-c1d785a15ac5.gif) via [`fzf`](https://github.com/junegunn/fzf) (see additional possibilities [here](./utilities/fzf/README.md))
  - [easy completion/execution of last command matching what you've typed so far](https://user-images.githubusercontent.com/9750687/77734491-0701fd00-6fc6-11ea-88a8-7050762d1302.gif) via [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions/)
  - [syntax highlighting as you type (immediate feedback on invalid commands, flags, paths, etc.)](https://user-images.githubusercontent.com/9750687/77735358-a83d8300-6fc7-11ea-9be4-faab8443fb60.gif) via [`fast-syntax-highlighting`](https://github.com/zdharma/fast-syntax-highlighting)
  - [syntax highlighted `git diff`s](https://user-images.githubusercontent.com/9750687/77733162-a5409380-6fc3-11ea-9f7a-59db41d058df.png) via [`delta`](https://github.com/dandavison/delta)
  - [syntax highlighted `cat`ting of files](https://user-images.githubusercontent.com/9750687/77732987-4da22800-6fc3-11ea-9cc2-79f0643e9645.png) via [`bat`](https://github.com/sharkdp/bat)
  - [highlighted `man` pages](https://user-images.githubusercontent.com/9750687/77732882-116ec780-6fc3-11ea-83e9-0e1743963536.png) via [a few `TERMCAP` vars](https://github.com/nathanshelly/.files/blob/88c87bb5eb9946ede43b2de66a60f8672722b5f3/zsh/zshenv.symlink#L35-L43)
  - [a blazing-fast async prompt](https://github.com/romkatv/powerlevel10k/) with contextual information like `git` changes, executable versions, etc. (extremely customizable via the command `p10k configure`)
  - [useful utilities](./utilities/README.md) like [`fasd`](./utilities/fasd/README.md), [`rg`](./utilities/ripgrep/README.md), [`fzf`](./utilities/fzf/README.md), [`fd`](./utilities/fd/README.md), etc.
- best practices/sane defaults - dotfiles configuration is weird. At times the documentation seems like ancient, undechiperable text. The terminal emulator (e.g. Alacritty or iTerm2), terminal multiplexer if you use one (e.g. `tmux` or `screen`) and shell (`bash`, `zsh`, `fish`, etc.) can interact in unexpected, maddening ways. Sometimes the suggestions you see on Stack Overflow seem like magic incantations. These dotfiles deal with all of that for you so you don't need to worry about it (and if you do run into weirdness help is only an issue away!).
  > disclaimer: I am well aware that these dotfiles can always be improved. The claim of best practices comes primarily from the sheer volume of time poured into them, not any pretension that they are perfect.
- well-supported - no SLA but a promise to address new issues in a timely manner ⏰
- well-documented - READMEs & code comments galore help anytime you want to make direct changes
- focus on speed - this configuration attempts to provide a useful set of features while keeping shell startup/prompt latency as low as possible

### the anti-pitch

- 'mo code, 'mo problems - additional dependencies can cause headaches and add complexity or fragility that outweighs the benefits
- no single dotfiles configuration is best for everyone - these dotfiles were written with my use cases in mind, they will hopefully work for yours (or at least the parts that do can be adopted for your own config) but they won't work for everyone's

### .files values

Aspirational principles:

- reliable - avoid fragile dependencies & configuration. Breaking someone's shell (in subtle or unsubtle ways) is far worse than not having a given feature.
- customizable - support different configurations for different users (without adding too much additional complexity/fragility)
- passively useful - be useful & worthwhile without learning any aliases or keybindings, modifying any settings or reading any documentation
- respectful of defaults - make non-standard modifications (e.g. overwriting commonly used bindings) opt-in/easily configurable wherever possible

## getting started

> If you use docker you can run the following command to test drive this config with minimal effort (see [`docker/dotfiles`](./docker/dotfiles) for more details):
>
> `docker run --interactive --tty nathanshelly/dotfiles:latest`

These dotfiles use 24 bit (true) color. For best results use a terminal emulator that supports this feature (the default macOS emulator, `Terminal`, does **not**). Here are a few possibilities: [`Alacritty`](https://github.com/alacritty/alacritty), [`kitty`](https://sw.kovidgoyal.net/kitty/), [`iTerm2` (macOS-specific)](https://iterm2.com/).

The below commands will run the [`infra/setup/setup_dotfiles`](./infra/setup/setup_dotfiles) setup script.

This script will walk through installing various shell utilities, symlinking various files to their appropriate locations, etc. See [`infra/setup`](./infra/setup/) folder for documentation on the setup process.

```bash
cd $HOME # to clone dotfiles to `$HOME/.odotfiles`
# install git on new computers (no-ops if already installed)
xcode-select --install
# now clone this repo and run setup
git clone https://github.com/opendoor-labs/odotfiles.git .odotfiles
cd .odotfiles
make setup
```

Unless something went wrong (🤞) you're all set up now! 🎉

Check out [next steps](#next-steps) to explore features/configuration possibilities.

### next steps

#### add your own configuration

If you have your own shell configuration (a `.bashrc`, `.bash_profile`, `.zshrc`, etc.) you will likely be able to simply source it and get the best of this config while overriding with your own.

> Note: `zsh` is mostly backwards compatible with `bash`. Enough so that most `bash` configs can be sourced from `zsh` without any issues. If you have a more complex `bash` config there may be compatibility issues.

To do so, simply move or copy the file to `$DOTFILES/zsh/local.zsh`. For example, if you want to preserve configuration from a `.bashrc` you'd run the following:

```bash
# or `mv`
cp $HOME/.bashrc $DOTFILES/zsh/local.zsh
source $HOME/.zshrc
```

Your configuration should now be applied on top of these dotfiles. Please open an issue or reach out in [#odotfiles](https://opendoor.slack.com/app_redirect?channel=odotfiles) if you have trouble!

#### add secrets safely

**DO NOT** check in any tokens or credentials like `NPM_TOKEN`s, database URLs, etc. To avoid this, add such secrets to the gitignored `$DOTFILES/zsh/secrets.zsh` (you'll need to create it the first time you want to add a secret).

> Technically `$DOTFILES/zsh/local.zsh` is gitignored as well but splitting out secrets into a separate file can help avoid accidental leakage.

#### explore features/configuration

Here's a few items you might be interested in trying/learning more about:

- configure high-level features of these dotfiles (changing the theme, setting your editor, disabling the prompt, etc.) via the [settings](./infra/docs/settings.md)
- configure your prompt appearance via `p10k configure` (or disable the prompt altogether via the `prompt` setting from the previous bullet point)
- use [`fzf` keybindings](./utilities/fzf/README.md#keybindings) to speed up so many things from quickly fuzzily selecting files, find zsh history items you half-remember typing weeks ago, checking out the commit from the one keyword you remember typing in the commit message & more
- use [`fasd`](./utilities/fasd/README.md) to quickly jump to or edit frequently/recently visited directories or files from anywhere
