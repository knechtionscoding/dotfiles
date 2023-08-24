#!/usr/bin/env bash

# Install Brew
if ! command -v brew &> /dev/null
then
    echo "brew needs to be installed"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install software from Brew
brew bundle
