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


# Google Drive (WSL)
#
# Drive for Desktop exposes G: as a Dokan volume on the Windows side. drvfs
# can mount it -- measured 2026-09-05: listing, reading, writing, appending
# and deleting all work, and writes reach the cloud -- but WSL never mounts it
# on its own and the mount does not survive a restart.
#
#   gdrive            mount if needed, then cd into My Drive
#   gdrive <subpath>  the same, one level deeper
#   gdrive -u         unmount
#
# Mounting is idempotent, so running it on an already-mounted drive just cds.
#
# Known limits of the volume, all measured: no symlinks, no hard links, and
# names are case-insensitive. chmod is worse than unsupported -- under
# metadata it exits 0 and leaves the mode at 777 -- so nothing here may rely
# on permissions. mtime writes do work, but only once metadata is on.
# Keep git repositories and analysis working directories off it. The first
# read of a file hydrates it from the cloud (~1 s); cached reads are ~20 ms.
GDRIVE_MOUNT=/mnt/g

gdrive() {
    if [ "$1" = "-u" ]; then
        sudo umount "$GDRIVE_MOUNT" && echo "gdrive: unmounted $GDRIVE_MOUNT"
        return
    fi

    if ! mountpoint -q "$GDRIVE_MOUNT"; then
        [ -d "$GDRIVE_MOUNT" ] || sudo mkdir -p "$GDRIVE_MOUNT" || return 1
        # metadata/uid/gid are what we would like. Fall back to a bare mount
        # rather than failing outright if drvfs rejects them on this volume.
        sudo mount -t drvfs G: "$GDRIVE_MOUNT" \
                -o "metadata,uid=$(id -u),gid=$(id -g)" 2> /dev/null \
            || sudo mount -t drvfs G: "$GDRIVE_MOUNT" \
            || { echo "gdrive: mount failed -- is Drive for Desktop running?" >&2
                 return 1; }
    fi

    cd "$GDRIVE_MOUNT/My Drive${1:+/$1}"
}

# Kept for muscle memory: the name this function replaces (alias added 2022-04-25).
alias connect_gdrive='gdrive'
