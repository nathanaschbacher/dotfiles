#!/bin/bash

bootstrap_config()
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

    echo "Setting up Bash aliases and prompts."
    echo "    * aliases aliased, promptly... Mmm'kay."
    ln -sf $HOME/Repositories/dotfiles/bash_aliases $HOME/.bash_aliases
}

bootstrap_apps()
{
    echo "Installing software from apt repositories."
    sudo apt-get update
    sudo apt-get -y install build-essential openssh-server git curl htop virtualbox intel-microcode ttf-mscorefonts-installer dmz-cursor-theme emacs
    echo "    * removing emacs24-terminal.desktop because it's annoying."
    sudo rm /usr/share/applications/emacs24-terminal.desktop 

    echo "Installing software from external sources."
    echo "    * slack."
    wget -O /tmp/slack-desktop-2.4.2-amd64.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-2.4.2-amd64.deb"
    sudo dpkg -i /tmp/slack-desktop-2.4.2-amd64.deb
    rm /tmp/slack-desktop-2.4.2-amd64.deb

    echo "    * google chrome."
    wget -O /tmp/google-chrome-stable_current_amd64.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
    rm /tmp/google-chrome-stable_current_amd64.deb

    echo "    * google play music desktop app."
    wget -O /tmp/google-play-music-desktop-player_4.0.5_amd64.deb "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v4.1.1/google-play-music-desktop-player_4.0.5_amd64.deb"
    sudo dpkg -i /tmp/google-play-music-desktop-player_4.0.5_amd64.deb
    rm /tmp/google-play-music-desktop-player_4.0.5_amd64.deb

    echo "    * erlang and elixir."
    echo "deb http://binaries.erlang-solutions.com/debian xenial contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list 
    sudo apt-get update
    sudo apt-get -y install esl-erlang elixir

    echo "    * pony lang."
    echo "deb https://dl.bintray.com/pony-language/ponyc-debian pony-language main" | sudo tee /etc/apt/sources.list.d/ponyc.list
    sudo apt-get update
    sudo apt-get -y --allow-unauthenticated install ponyc-release

    echo "    * rust lang, rust-src, rustfmt, racer."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    $HOME/.cargo/bin/rustup component add rust-src
    $HOME/.cargo/bin/cargo install rustfmt
    $HOME/.cargo/bin/cargo install racer
}

bootstrap_all()
{
    bootstrap_config
    bootstrap_apps
}

if [ "$1" == "config" ]; then
    bootstrap_config
elif [ "$1" == "apps" ]; then
    bootstrap_apps
else
    bootstrap_all
fi
