# Alias definitions.

# cd
alias ..='cd ..'

# ls
alias ls='ls --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# git
alias ga='git add'
alias gaa='git add -A'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit --amend --no-edit'
alias gcm='git commit -m'
alias go='git checkout'
alias gs='git status'


# tmux
# revertkey restores the prefix set in .tmux.conf, which is C-a (it used to
# say C-s and so never restored anything). -p is deprecated in favour of -l.
alias tmux-changekey='tmux set-option -g prefix C-b'
alias tmux-revertkey='tmux set-option -g prefix C-a'
alias tmux-sw='tmux split-window -v -l 20%;tmux split-window -h -l 66%;tmux split-window -h -l 50%'


#ssh
alias start-ssh-agent='eval "$(ssh-agent -s)"'


# python
# Debian ships no `python` binary. Alias it only when nothing else provides
# one, so a virtualenv or conda environment with its own `python` is never
# shadowed by an alias.
command -v python > /dev/null 2>&1 || alias python='python3'


# Claude-Science
alias cs='claude-science'
alias css='claude-science serve --port 8765 --no-browser'


# my alias
# These pointed at ~/bin/, which does not exist: setup.sh installs to
# ~/.local/bin, and that is on PATH.
alias cb='clipboard'
alias cbx='clipboard -x'


# others
alias connect_gdrive='sudo mount -t drvfs G: /mnt/g -o metadata'
