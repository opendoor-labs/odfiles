alias srczsh='. ~/.zshrc'

# launch w/o sourcing configs
alias zshn='zsh -f'

alias l='ls -CF'
alias la='ls -AF'
alias ll='ls -AFhl'

alias brewupdate='brew update && brew upgrade && brew cleanup && brew doctor && brew prune'

# repo root
alias cdrr="cd $(git rev-parse --show-toplevel)"
alias rr="git rev-parse --show-toplevel"

# shortened utilities
alias op=open
