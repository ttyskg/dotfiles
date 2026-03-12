# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

alias ls='ls --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

# change file/directory permission to Linux default.
umask 022

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

# my alias
alias ..='cd ..'
alias cb='~/bin/clipboard.sh'
alias cbx='~/bin/clipboard_xclip.sh'
alias ga='git add'
alias gaa='git add -A'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit --amend --no-edit'
alias gcm='git commit -m'
alias go='git checkout'
alias gs='git status'
alias python='python3'
alias tmux-changekey='tmux set-option -ag prefix C-b'
alias tmux-revertkey='tmux set-option -ag prefix C-s'
alias tmux-sw='tmux split-window -v -p 20;tmux split-window -h -p 66;tmux split-window -h -p 50'
alias start-ssh-agent='eval "$(ssh-agent -s)"'
alias connect_gdrive='sudo mount -t drvfs G: /mnt/g -o metadata'

# Prompt setting
export PROMPT_DIRTRIM=1
function parse_git_branch {
    local branch
    branch=$(git branch --show-current 2> /dev/null)
    if [ -z "$branch" ]; then
        branch=$(git rev-parse --short HEAD 2> /dev/null)
    fi
    [ -n "$branch" ] && printf '(%s)' "$branch"
}
export PS1="\[\e[01;32m\]\u@\h\[\e[01;00m\]:\[\e[01;32m\]\w \t\[\e[01;35m\]\$(parse_git_branch)\[\e[m\]\$ "

# User specific functions
if [[ -t 0 ]]; then
    stty stop undef
    stty start undef
fi

# NodeBrew setting
if [ -d "$HOME/.nodebrew/current/bin" ]; then
    export PATH="$HOME/.nodebrew/current/bin:$PATH"
fi

# Bioinformatic tools
if [ -d "$HOME/bin/samtools/bin" ]; then
    export PATH="$HOME/bin/samtools/bin:$PATH"
fi
if [ -d "$HOME/bin/sratoolkit.2.10.8-ubuntu64/bin" ]; then
    export PATH="$HOME/bin/sratoolkit.2.10.8-ubuntu64/bin:$PATH"
fi

# pipenv setting
export PIPENV_VENV_IN_PROJECT="enabled"

# set Vim-style command-line editing
set -o vi

# CDPATH setting
export CDPATH=$HOME:$HOME/work

# For Loading the SSH key
if shopt -q login_shell; then
    export HOST=$(hostname)
    if [ -x /usr/bin/keychain ]; then
        /usr/bin/keychain -q --nogui "$HOME/.ssh/id_ed25519"
        if [ -f "$HOME/.keychain/$HOST-sh" ]; then
            source "$HOME/.keychain/$HOST-sh"
        fi
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

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Load local machine-specific settings (not tracked in Git)
if [ -f ~/.bash_local ] && [ -O ~/.bash_local ]; then
    . ~/.bash_local
fi
