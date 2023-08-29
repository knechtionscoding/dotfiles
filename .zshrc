#!/bin/zsh

[ -f /etc/zshrc ] && source /etc/zshrc

export ZSH_DISABLE_COMPFIX=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="clean"

# Install kube-aliases plugin
if [ ! -d ~/.oh-my-zsh/custom/plugins/kube-aliases ]; then
    echo "kube-aliases needs to be installed"
    git clone https://github.com/Dbz/kube-aliases.git ~/.oh-my-zsh/custom/plugins/kube-aliases
fi

plugins=(git kube-aliases dotenv aws)

source $ZSH/oh-my-zsh.sh

[ -f ~/.dotfiles/shell/rc ] && source ~/.dotfiles/shell/rc

# oh-my-zsh configuration {{{

if [ ! -d ~/.oh-my-zsh ]; then
    echo "oh-my-zsh needs to be installed"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
fi

# }}}

# krew configuration
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

if [ ! -f ~/.krew/bin/kubectl-krew ]; then
    echo "krew needs to be installed"
    ~/.dotfiles/bin/install-krew
fi

# Basic settings {{{

# History control
setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS

# iTerm2 keymaps
if [ "$(uname -s)" = "Darwin" ]; then
    bindkey -e
    bindkey '^[[1;5C' forward-word
    bindkey '^[[1;5D' backward-word
    bindkey '^[[1~' beginning-of-line
    bindkey '^[[4~' end-of-line
    bindkey '^[[H' beginning-of-line
    bindkey '^[[F' end-of-line
    bindkey '^[[3~' delete-char
    # Option+Backspace can be configured to delete a word in iTerm2 by sending the
    # following hex sequence: 0x1b 0x18
    # More info: https://stackoverflow.com/a/29403520
fi

# }}}

# Enable additional zsh completions on OS X
if [ "$(uname -s)" = "Darwin" ]; then
    if type brew &>/dev/null; then
        FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
        autoload -Uz compinit
        compinit -i
    fi
fi
