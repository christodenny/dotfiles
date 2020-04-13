#!/bin/bash

echo "Update package cache"
sudo apt update

echo "Downloading programs"
sudo apt install vim tmux htop

echo "Pulling dotfiles"
wget https://raw.githubusercontent.com/christodenny/dotfiles/master/.vimrc -O ~/.vimrc
wget https://raw.githubusercontent.com/christodenny/dotfiles/master/.tmux.conf -O ~/.tmux.conf
