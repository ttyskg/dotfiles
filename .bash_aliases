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
alias tmux-changekey='tmux set-option -ag prefix C-b'
alias tmux-revertkey='tmux set-option -ag prefix C-s'
alias tmux-sw='tmux split-window -v -p 20;tmux split-window -h -p 66;tmux split-window -h -p 50'


#ssh
alias start-ssh-agent='eval "$(ssh-agent -s)"'


# python
alias python='python3'


# Claude-Science
alias cs='claude-science'
alias css='claude-science serve --port 8765 --no-browser'


# my alias
alias cb='~/bin/clipboard.sh'
alias cbx='~/bin/clipboard_xclip.sh'


# others
alias connect_gdrive='sudo mount -t drvfs G: /mnt/g -o metadata'
