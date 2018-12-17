#!/bin/bash

bootstrap_configs()
{
    echo "Downloading and installing Mac Subset fonts."
    wget -O /tmp/Mac_Subset.zip "https://www.dropbox.com/sh/6tn3iz544a323el/AADar-A0xFVsscsoFGklrA7Ha?dl=1"
    mkdir -p $HOME/.fonts/mac
    unzip -o -d $HOME/.fonts/mac /tmp/Mac_Subset.zip
    echo "    * rebuilding font cache."
    fc-cache -fv
    rm /tmp/Mac_Subset.zip

    echo "Creating symlinks to custom config files."
    echo "    * emacs init.el and keybindings."
    ln -sf $HOME/Repositories/dotfiles/emacs.d $HOME/.emacs.d

    echo "    * plasma .config/ files for settings and keybindings."
    ln -sf $HOME/Repositories/dotfiles/config/dolphinrc $HOME/.config/dolphinrc
    ln -sf $HOME/Repositories/dotfiles/config/konsolerc $HOME/.config/konsolerc
    ln -sf $HOME/Repositories/dotfiles/config/kxkbrc $HOME/.config/kxkbrc
    ln -sf $HOME/Repositories/dotfiles/config/kglobalshortcutsrc $HOME/.config/kglobalshortcutsrc
    ln -sf $HOME/Repositories/dotfiles/config/kdeglobals $HOME/.config/kdeglobals
    ln -sf $HOME/Repositories/dotfiles/config/kwinrc $HOME/.config/kwinrc
    ln -sf $HOME/Repositories/dotfiles/config/breezerc $HOME/.config/breezerc
    ln -sf $HOME/Repositories/dotfiles/config/kcminputrc $HOME/.config/kcminputrc
    ln -sf $HOME/Repositories/dotfiles/config/plasmarc $HOME/.config/plasmarc
    ln -sf $HOME/Repositories/dotfiles/config/touchpadrc $HOME/.config/touchpadrc
    ln -sf $HOME/Repositories/dotfiles/config/kwinrulesrc $HOME/.config/kwinrulesrc
    ln -sf $HOME/Repositories/dotfiles/config/khotkeysrc $HOME/.config/khotkeysrc

    echo "    * plasma .local/share/ files for settings and keybindings."
    ln -sf $HOME/Repositories/dotfiles/local/share/kxmlgui5/dolphin/dolphinui.rc $HOME/.local/share/kxmlgui5/dolphin/dolphinui.rc
    ln -sf $HOME/Repositories/dotfiles/local/share/kxmlgui5/konsole/konsoleui.rc $HOME/.local/share/kxmlgui5/konsole/konsoleui.rc
    ln -sf $HOME/Repositories/dotfiles/local/share/kxmlgui5/konsole/sessionui.rc $HOME/.local/share/kxmlgui5/konsole/sessionui.rc

    echo "    * plasma ~/.gtkrc-2.0, .config/gtk-3.0 for gtk style & theme settings."
    ln -sf $HOME/Repositories/dotfiles/config/gtkrc-2.0 $HOME/.gtkrc-2.0
    ln -sf $HOME/Repositories/dotfiles/config/gtk-3.0 $HOME/.config/gtk-3.0

    echo "Setting up Bash aliases, prompts, and extra settings."
    ln -sf $HOME/Repositories/dotfiles/bash_aliases $HOME/.bash_aliases
    
    echo "Setting up GnuPG Agent SSH support."
    echo "enable-ssh-support" | tee $HOME/.gnupg/gpg-agent.conf
}

bootstrap_packages()
{
    echo "Installing additional software sources from PPAs."
    sudo apt-add-repository ppa:yubico/stable
    sudo add-apt-repository ppa:kelleyk/emacs
    sudo add-apt-repository ppa:mozillateam/ppa
    echo "deb http://binaries.erlang-solutions.com/debian bionic contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list
    
    echo "Installing software from apt repositories."
    sudo apt-get update
    sudo apt-get -y install apt-transport-https build-essential openssh-server git curl htop intel-microcode ttf-mscorefonts-installer dmz-cursor-theme gpg gpg-agent pcscd scdaemon krita kdenetwork-filesharing kompare konversation pinentry-qt  qemu-system-arm qemu-system-x86 ssss tp-smapi-dkms acpi-call-dkms tlp wget

    echo "Installing yubikey management tools."
    sudo apt install yubikey-manager yubikey-personalization
    
    echo "Installing Emacs 26."
    sudo apt install emacs26
    
    echo "Installing Thunderbird from PPA."
    sudo apt install thunderbird enigmail
    
    echo "Installing Erlang and Elixir."
    sudo apt install esl-erlang elixir
}

bootstrap_apps()
{ 
    echo "Installing desktop applications from external sources."
    echo "    * slack."
    wget -O /tmp/slack-desktop-3.3.3-amd64.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.3-amd64.deb"
    sudo dpkg -i /tmp/slack-desktop-3.3.3-amd64.deb
    rm /tmp/slack-desktop-3.3.3-amd64.deb

    echo "    * google chrome."
    wget -O /tmp/google-chrome-stable_current_amd64.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
    rm /tmp/google-chrome-stable_current_amd64.deb

    echo "    * google play music desktop app."
    wget -O /tmp/google-play-music-desktop-player_4.6.1_amd64.deb "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v4.6.1/google-play-music-desktop-player_4.6.1_amd64.deb"
    sudo dpkg -i /tmp/google-play-music-desktop-player_4.6.1_amd64.deb
    rm /tmp/google-play-music-desktop-player_4.6.1_amd64.deb

    echo "    * rust lang, rust-src, rustfmt, racer."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    $HOME/.cargo/bin/rustup component add rust-src
    $HOME/.cargo/bin/cargo install rustfmt
    $HOME/.cargo/bin/cargo install racer
}

dell_modmap()
{
    echo "Creating symlinks to Dell Keyboard Xmodmap."
    ln -sf $HOME/Repositories/dotfiles/config/Dell-Xmodmap $HOME/.Xmodmap
}

thinkpad_modmap()
{
    echo "Creating symlinks to Thinkpad Keyboard Xmodmap."
    ln -sf $HOME/Repositories/dotfiles/config/Thinkpad-Xmodmap $HOME/.Xmodmap
}

if [ "$1" == "configs" ]; then
    bootstrap_configs
elif [ "$1" == "packages" ]; then
    bootstrap_packages
elif [ "$1" == "apps" ]; then
    bootstrap_apps
elif [ "$1" == "keymap" ]; then
    if [ "$2" == "dell" ]; then
        dell_modmap
    elif [ "$2" == "thinkpad" ]; then
        thinkpad_modmap
    else
        echo "Invalid keymap option."
        exit 2
    fi
else
    echo "Invalid subcommand."
    exit 1
fi
