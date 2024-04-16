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

plugins=(git kube-aliases dotenv aws fzf)

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

# GPG configuration {{{
export GPG_TTY=$(tty)
# }}}

# Basic settings {{{

# History control
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"

setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.

HIST_STAMPS="yyyy-mm-dd"

# }}}

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

# }}}

source <(kubectl completion zsh)

# asdf configuration
# If asdf command exists source asdf versions
if [ -x "$(command -v asdf)" ]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
