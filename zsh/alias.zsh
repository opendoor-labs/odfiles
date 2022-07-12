#! /usr/bin/env zsh

# <<<< generics >>>>
# these generic aliases allow changing the underlying command without having to
# change your muscle memory
alias e="$EDITOR" # text editor

# <<<<<<<<< fzf >>>>>>>>>
# corresponding functions defined in `../functions/fzf`
alias rgz='fzf_rg_edit'
alias killp='fzf_kill_by_port'
# <<<<<<<<< end of fzf >>>>>>>>>

# <<<<<<<<< exa >>>>>>>>>
# exa - replacement for `ls`
# ref - https://github.com/ogham/exa
command -v exa > /dev/null && {
  alias l='exa'

  # options - https://github.com/ogham/exa#options
  alias la='l --all'
  alias ll='l --long --all'
} || {
  # exa not installed

  # `-F` display characters indicating properties, e.g. `/` for directory
  alias l='ls -F'
  # `-A` list all entries except `.` & `..`
  alias la='ls -AF'
  # `-l` long format (more details)
  # `-h` human readable units (byte, kilobyte, etc.)
  alias ll='ls -AFhl'
}
# <<<<<<<<< end of exa >>>>>>>>>

command -v smat > /dev/null && {
  alias cat=smat
}

# <<<<<<<<< ripgrep >>>>>>>>>
if command -v rg > /dev/null; then
  alias f='rg --smart-case'

  # search for literal strings
  alias ff='f --fixed-strings'

  # search only tests - any filename/directory matching the given patterns
  alias ft="f --glob '*test*' --glob '*spec*'"

  # ignore tests - exclude any filename/directory matching the given patterns
  alias fnt="f --glob '!*test*' --glob '!*spec*'"

  # whole word
  alias fw='f --word-regexp'

  # `-uuu` (`--unrestricted`) ignores .gitignore files, and searches hidden files
  # and directories along with binary files
  alias fu='f -uuu'
  alias fus='f -uuu --case-sensitive'
fi
# <<<<<<<<< end of ripgrep >>>>>>>>>
