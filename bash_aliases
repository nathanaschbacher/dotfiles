alias please='sudo "$BASH" -c "$(history -p !!)"'
alias open='xdg-open'

alias set-git-work='git config --local user.name "Nathan Aschbacher"; git config --local user.email "nathan@auxon.io"; git config --local user.signingkey 1869D2B3AE62721E17EA2D3B4F1D9201D95C299F; git config --local commit.gpgsign true'

alias set-git-home='git config --local user.name "Nathan Aschbacher"; git config --local user.email "nathan.aschbacher@gmail.com"; git config --local user.signingkey 50C99564E9AB7A5FDFB8809C1EFBD77935AC3873; git config --local commit.gpgsign true'

export EDITOR=emacs
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src

export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

source $HOME/Repositories/dotfiles/bash_ps1.sh
