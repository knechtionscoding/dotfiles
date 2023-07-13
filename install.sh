#!/usr/bin/env bash

# Install Brew
if ! command -v brew &> /dev/null
then
    echo "brew needs to be installed"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install software from Brew
brew bundle

# Install python version
pyenv install 3.11.3

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ZSH Config
git clone https://github.com/Dbz/kube-aliases.git ~/.oh-my-zsh/custom/plugins/kube-aliases


# Git Stuff
git config --global user.name "Hans Knecht"
git config --global user.email "hans@anomalo.com" 
