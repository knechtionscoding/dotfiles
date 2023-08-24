#!/usr/bin/env bash

# Install Brew
if ! command -v brew &> /dev/null
then
    echo "brew needs to be installed"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install software from Brew
brew bundle

# Install brew fils only if on mac
if [ "$(uname -s)" = "Darwin" ]; then
    brew bundle --file Brewfile.mac
fi
