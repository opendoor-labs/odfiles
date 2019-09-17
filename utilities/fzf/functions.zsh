#! /usr/bin/env zsh

# default fzf functions - `$(brew --prefix)/opt/fzf/shell/key-bindings.zsh`

# <<<< widgets >>>>

# list ignored files
# basically just `fzf-file-widget` with `--no-ignore`
fzf-ignored-file-widget() {
  FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND} --no-ignore" fzf-file-widget
}

# edit selected file
# lightly adapted from `fzf-cd-widget`
fzf-edit-widget() {
  setopt localoptions pipefail 2> /dev/null
  local file="$(
    eval "$FZF_DEFAULT_COMMAND" \
      | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_EDIT_OPTS" $(__fzfcmd) +m
    )"

  if [[ -z "$file" ]]; then
    zle redisplay
    return 0
  fi

  "${EDITOR:-nvim}" "$file"

  local ret=$?
  zle fzf-redraw-prompt
  return $ret
}

# addapted from `fzf-file-widget`
# TODO: clean up opts
__fsel_repo() {
  local cmd="${FZF_CTRL_T_COMMAND}"
  setopt localoptions pipefail 2> /dev/null
  eval "$FZF_CTRL_T_COMMAND . $(rr)" \
    | sed "s~^$(rr)/~~" \
    | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS --preview='bat --style=numbers --color=always $(rr)/{}'" $(__fzfcmd) -m "$@" \
    | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

fzf-repo-file-widget() {
  LBUFFER="${LBUFFER}$(__fsel_repo)"
  local ret=$?
  zle reset-prompt
  return $ret
}

# modified version of default `fzf-history-widget` to allow dynamic editing or
# execution of selected history line
# ref - https://github.com/junegunn/fzf/issues/477#issuecomment-444053054
fzf-modified-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -l 1 | eval "$(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r --expect=ctrl-e $FZF_CTRL_R_OPTS -q ${(q)LBUFFER}") )
  local ret=$?
  if [ -n "$selected" ]; then
    local accept=0
    if [[ $selected[1] = ctrl-e ]]; then
      accept=1
      shift selected
    fi
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
      [[ $accept = 0 ]] && zle accept-line
    fi
  fi
  zle reset-prompt
  return $ret
}

# <<<< run @ shell or aliased >>>>

fzf_kill_by_port() {
  local port="$1"

  [[ -z $port ]] && {
    echo 'No port given, aborting'
    return 1
  }

  # TODO: switch to alternate `&>/dev/null` in future
  # ref - https://askubuntu.com/questions/474556/hiding-output-of-a-command
  lsof -i ":$port" > /dev/null 2>&1 || {
    echo 'Port has no attached processes, aborting'
    return 1
  }

  # `sed '1d'` removes header line
  # `sed -nE ...` filters out only PIDs
  kill -9 $(\
    lsof -i :"$port" \
    | sed '1d' \
    | fzf -m \
    | sed -nE 's/^[[:alnum:]]+[[:space:]]+([[:digit:]]+)[[:space:]]+.*$/\1/p' \
  )

  # avoid race condition between next `lsof` call and processes shutting down
  sleep 0.01

  lsof -i ":$port" > /dev/null 2>&1 && {
    echo "Remaining attached processes:\n"
    lsof -i ":$port"
  }
}

# fuzzy select files containing given term
# TODO: see if search term can be changed interactively
#
# ref - https://bluz71.github.io/2018/11/26/fuzzy-finding-in-bash-with-fzf.html#find-file-and-edit
fzf_rg_edit() {
    if [[ $# == 0 ]]; then
        echo 'Error: search term was not provided.'
        return
    fi
    local match=$(
      rg --color=never --line-number "$1" |
        fzf --no-multi --delimiter : \
            --preview "bat --color=always --line-range {2}: {1}"
      )
    local file=$(echo "$match" | cut -d':' -f1)
    if [[ -n $file ]]; then
        $EDITOR $file +$(echo "$match" | cut -d':' -f2)
    fi
}

# list directories in $PATH, press `enter` on an entry to list contained
# executables.  press `escape` to go back to directory listing, `escape` again
# to exit completely
# ref - https://github.com/SidOfc/dotfiles/blob/d07fa3862ed065c2a5a7f1160ae98416bfe2e1ee/zsh/fp
fzf_find_path() {
  local loc=$(echo $PATH | sed -e $'s/:/\\\n/g' | eval "fzf ${FZF_DEFAULT_OPTS} --header='[find:path]'")

  if [[ -d $loc ]]; then
    echo "$(\
        rg --files $loc |\
        rev |\
        cut -d"/" -f1 |\
        rev\
      )" |\
      eval "fzf ${FZF_DEFAULT_OPTS} ='[find:exe] => ${loc}' >/dev/null"

    fzf_find_path
  fi
}

# fuzzily install brew packages
# ref - https://github.com/SidOfc/dotfiles/blob/d07fa3862ed065c2a5a7f1160ae98416bfe2e1ee/zsh/bip
fzf_brew_install() {
  local inst=$(brew search | eval "fzf ${FZF_DEFAULT_OPTS} -m")

  [[ "$inst" ]] && for prog in $(echo "$inst"); do brew install "$prog"; done
}

# fuzzily upgrade brew packages
# ref - https://github.com/SidOfc/dotfiles/blob/d07fa3862ed065c2a5a7f1160ae98416bfe2e1ee/zsh/bup
fzf_brew_upgrade() {
  local upd=$(brew outdated | eval "fzf ${FZF_DEFAULT_OPTS} -m")

  [[ "$upd" ]] && for prog in $(echo "$upd"); do brew upgrade "$prog"; done
}


# fuzzily uninstall brew packages
# ref - https://github.com/SidOfc/dotfiles/blob/d07fa3862ed065c2a5a7f1160ae98416bfe2e1ee/zsh/bcp
fzf_brew_uninstall() {
  local uninst=$(brew leaves | eval "fzf ${FZF_DEFAULT_OPTS} -m")

  [[ "$uninst" ]] && {
    for prog in $(echo "$uninst"); do brew uninstall "$prog"; done
  }
}

# <<<< fzf ❤️ git >>>>

# useful combinations of git & fzf
# functions defined here bound to keys in $DOTFILES/utilities/fzf/git.zsh
# refs:
#   - https://junegunn.kr/2016/07/fzf-git
#   - https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236

# will return non-zero status if the current directory is not managed by git
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf_gf() {
  is_in_git_repo || return

  local preview
  preview='(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | bat'

  git -c color.status=always status --short |
  fzf -m --ansi --nth 2..,.. --preview "$preview" |
  cut -c4- | sed 's/.* -> //'
}

fzf_gr() {
  is_in_git_repo || return
  local bindings preview
  bindings='ctrl-space:toggle-preview'
  preview='git log --oneline --graph --date=short --color=always'
  preview+=' --pretty="format:%C(auto)%cd %h%d %s"'
  preview+=' $(sed s/^..// <<< {} | cut -d" " -f1) | bat'

  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf --ansi --multi --tac --preview-window right:70% --bind="$bindings" \
    --preview "$preview" |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

fzf_gh() {
  is_in_git_repo || return
  local format bindings preview
  format='%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)'
  bindings='ctrl-s:toggle-sort,ctrl-space:toggle-preview'
  preview='grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | bat'

  git log --date=short --format="$format" --graph --color=always |
  fzf --ansi --no-sort --reverse --multi --bind "$bindings" \
    --header 'Press CTRL-S to toggle sort' \
    --preview "$preview" |
  grep -o "[a-f0-9]\{7,\}"
}