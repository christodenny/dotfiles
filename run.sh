#!/bin/bash

echo "Update package cache"
sudo apt update

echo "Downloading programs"
sudo apt -y --force-yes install vim tmux htop git gnome-tweak-tool earlyoom silversearcher-ag </dev/null

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

echo "Setup tmux plugins"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true

echo "Update default editor to vim"
sudo update-alternatives --set editor /usr/bin/vim.basic
