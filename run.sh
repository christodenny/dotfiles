#!/bin/bash

echo "Update package cache"
sudo apt update

echo "Downloading programs"
sudo apt install vim tmux htop git gnome-tweak-tool earlyoom
sudo snap install go --classic

sudo systemctl enable earlyoom
sudo systemctl start earlyoom

echo "Pulling dotfiles"
wget https://raw.githubusercontent.com/christodenny/dotfiles/master/.vimrc -O ~/.vimrc
wget https://raw.githubusercontent.com/christodenny/dotfiles/master/.tmux.conf -O ~/.tmux.conf

if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "Generating ssh keys"
    ssh-keygen -t rsa -b 4096 -C "chris.denny@utexas.edu"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
fi

echo "Update default editor to vim"
sudo update-alternatives --config editor
