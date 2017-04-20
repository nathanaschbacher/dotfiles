function mmmkey {
    if [ "$1" == "gpg" ]; then
        gpg --gen-key
    elif [ "$1" == "ssh" ]; then
	ssh-keygen -t rsa -b 4096 -C "$2"
    else
        echo "Provide a key type, Mmm'kay. [gpg | ssh \"Your Comment\"]"
    fi
}

alias please='sudo "$BASH" -c "$(history -p !!)"'

source $HOME/Repositories/dotfiles/bash_ps1.sh 
