# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# =====================================================================
# Settings for every shell, interactive or not.
#
# Everything below the interactive guard is skipped by non-interactive
# shells (`ssh host command`, cron, editors and CLI agents), so PATH and
# exported variables have to be set up here to be usable at all.
# =====================================================================

# change file/directory permission to Linux default.
umask 022

path_prepend() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) export PATH="$1:$PATH" ;;
    esac
}

# NodeBrew setting
if [ -d "$HOME/.nodebrew/current/bin" ]; then
    path_prepend "$HOME/.nodebrew/current/bin"
fi

# Bioinformatic tools
if [ -d "$HOME/bin/samtools/bin" ]; then
    path_prepend "$HOME/bin/samtools/bin"
fi
if [ -d "$HOME/bin/sratoolkit.2.10.8-ubuntu64/bin" ]; then
    path_prepend "$HOME/bin/sratoolkit.2.10.8-ubuntu64/bin"
fi

# Add local bin to PATH
path_prepend "$HOME/.local/bin"

# bun setting
export BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL/bin" ]; then
    path_prepend "$BUN_INSTALL/bin"
fi

# pipenv setting
export PIPENV_VENV_IN_PROJECT="enabled"

# X server setting for WSL
if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
    if [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ] && [ -r /etc/resolv.conf ]; then
        WSL_HOST_IP=$(awk '/^nameserver / {print $2; exit}' /etc/resolv.conf)
        if [ -n "$WSL_HOST_IP" ]; then
            export DISPLAY="${WSL_HOST_IP}:0.0"
        fi
        unset WSL_HOST_IP
    fi

    if [ -z "${WAYLAND_DISPLAY:-}" ]; then
        export LIBGL_ALWAYS_INDIRECT=1
    fi
fi

# SSH agent
#
# Starting an agent is a login-shell job: keychain may prompt for the key
# passphrase and the fallback spawns a process. Adopting an agent that is
# already running is not, so that part runs in every shell -- otherwise
# non-login shells (CLI agents, `ssh host command`, editors) get no
# SSH_AUTH_SOCK and any git push fails with "Permission denied (publickey)".
if shopt -q login_shell; then
    if command -v keychain > /dev/null 2>&1; then
        keychain -q --nogui "$HOME/.ssh/id_ed25519"
    elif [ -z "${SSH_AUTH_SOCK:-}" ] || [ ! -S "${SSH_AUTH_SOCK:-}" ]; then
        if [ -f "$HOME/.ssh/ssh-agent" ]; then
            . "$HOME/.ssh/ssh-agent" > /dev/null 2>&1 || true
        fi

        if [ -z "${SSH_AUTH_SOCK:-}" ] || [ ! -S "${SSH_AUTH_SOCK:-}" ]; then
            mkdir -p "$HOME/.ssh"
            ssh-agent -s | sed '/^echo /d' > "$HOME/.ssh/ssh-agent"
            chmod 600 "$HOME/.ssh/ssh-agent"
            . "$HOME/.ssh/ssh-agent" > /dev/null 2>&1
        fi
    fi
fi

# Adopt an agent that is already running. keychain first: ~/.ssh/ssh-agent is
# the older fallback and can point at a socket that no longer exists.
for ssh_agent_env in \
        "$HOME/.keychain/${HOSTNAME:-$(hostname)}-sh" \
        "$HOME/.ssh/ssh-agent"; do
    [ -S "${SSH_AUTH_SOCK:-}" ] && break
    # Drop the rejected pair so a dead file cannot leave its SSH_AGENT_PID
    # attached to the socket of the next one.
    unset SSH_AUTH_SOCK SSH_AGENT_PID
    if [ -f "$ssh_agent_env" ]; then
        . "$ssh_agent_env" > /dev/null 2>&1 || true
    fi
done
unset ssh_agent_env

# Never keep a stale socket: no agent is better than a broken one.
if [ -n "${SSH_AUTH_SOCK:-}" ] && [ ! -S "$SSH_AUTH_SOCK" ]; then
    unset SSH_AUTH_SOCK SSH_AGENT_PID
fi

# Load local machine-specific settings (not tracked in Git)
if [ -f ~/.bashrc.local ] && [ -O ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

# =====================================================================
# Interactive shells only
# =====================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -r ~/.dircolors ]; then
    if command -v dircolors > /dev/null 2>&1; then
        eval "$(dircolors -b ~/.dircolors)"
    elif command -v gdircolors > /dev/null 2>&1; then
        eval "$(gdircolors -b ~/.dircolors)"
    fi
elif command -v dircolors > /dev/null 2>&1; then
    eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ] && [ -O ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Prompt setting
export PROMPT_DIRTRIM=1
# Print "(branch)", or "(short sha)" when HEAD is detached.
# Locate .git in bash first: outside a repository this forks nothing, whereas
# the git calls below would always cost two processes per prompt.
function parse_git_branch {
    local dir="$PWD"
    until [ -e "$dir/.git" ]; do
        [ -n "$dir" ] || return
        dir="${dir%/*}"
    done

    local branch
    branch=$(git branch --show-current 2> /dev/null)
    if [ -z "$branch" ]; then
        branch=$(git rev-parse --short HEAD 2> /dev/null)
    fi
    [ -n "$branch" ] && printf '(%s)' "$branch"
}
PS1="\[\e[01;32m\]\u@\h\[\e[01;00m\]:\[\e[01;32m\]\w \t\[\e[01;35m\]\$(parse_git_branch)\[\e[m\]\$ "

# Show user@host:dir in the terminal / tmux window title
case "$TERM" in
    xterm*|rxvt*|screen*|tmux*)
        PS1="\[\e]0;\u@\h: \w\a\]$PS1"
        ;;
esac
export PS1

# User specific functions
if [[ -t 0 ]]; then
    stty stop undef
    stty start undef
fi

# set Vim-style command-line editing
set -o vi

# CDPATH setting
export CDPATH=$HOME:$HOME/work
