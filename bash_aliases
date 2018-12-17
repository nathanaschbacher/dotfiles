
alias please='sudo "$BASH" -c "$(history -p !!)"'
alias open='xdg-open'

export EDITOR=emacs
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src

export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
unset SSH_AGENT_PID
$(gpg-connect-agent --no-autostart killagent /bye > /dev/null 2>&1)
$(gpg-connect-agent --quiet /bye > /dev/null 2>&1)
export GPG_TTY=$(tty)

source $HOME/Repositories/dotfiles/bash_ps1.sh
