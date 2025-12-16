#!/bin/zsh

[ -f /etc/zshrc ] && source /etc/zshrc

export TELEPORT_AUTH=google
export TELEPORT_PROXY=anomalo.teleport.sh:443
export TELEPORT_USER=hans@anomalo.com

export ANTHROPIC_MODEL=us.anthropic.claude-sonnet-4-20250514-v1:0
export CLAUDE_CODE_USE_BEDROCK=1
export ZSH_DISABLE_COMPFIX=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
export ZSH_THEME="clean"

# Install kube-aliases plugin
if [ ! -d ~/.oh-my-zsh/custom/plugins/kube-aliases ]; then
    echo "kube-aliases needs to be installed"
    git clone https://github.com/Dbz/kube-aliases.git ~/.oh-my-zsh/custom/plugins/kube-aliases
fi

plugins=(git kube-aliases dotenv aws fzf terraform)

# Normalize the shell name: strip leading path
shell=$(ps -p "$$" -o comm=)
shell=$(basename "$shell")

case "$shell" in
  zsh)
    echo "Running under zsh"
    # make sure $ZSH is set or guard against it
    [ -n "$ZSH" ] && . "$ZSH/oh-my-zsh.sh"
    ;;
  bash)
    echo "Running under bash"
    ;;
  *)
    echo "Unknown or unsupported shell: $shell"
    ;;
esac


[ -f ~/.dotfiles/shell/rc ] && source ~/.dotfiles/shell/rc

# oh-my-zsh configuration {{{

if [ ! -d ~/.oh-my-zsh ]; then
    echo "oh-my-zsh needs to be installed"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
fi

# }}}

# Install fzf
# If Darwin use brew install
# Otherwise use apt
if [ "$(uname -s)" = "Darwin" ]; then
    if command -v brew &>/dev/null; then
        if command -v fzf &>/dev/null; then
            echo "fzf is already installed"
            exit 0
        fi
        brew install fzf
    else
      echo "Install Brew prior to installing fzf"
    fi
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --completion --key-bindings
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

setopt EXTENDED_HISTORY     # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY   # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY        # Share history between all sessions.
setopt HIST_IGNORE_DUPS     # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE    # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS    # Do not write a duplicate event to the history file.
setopt HIST_VERIFY          # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY       # append to history file (Default)
setopt HIST_NO_STORE        # Don't store history commands
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from each command line being added to the history.

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
# if [ "$(uname -s)" = "Darwin" ]; then
#     if type brew &>/dev/null; then
#         FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
#         autoload -Uz compinit
#         compinit -i
#     fi
# fi

# }}}

source <(kubectl completion zsh)

# asdf configuration
# If asdf command exists source asdf versions
if [ -x "$(command -v asdf)" ]; then
    export PATH="$HOME/bin:$PATH"
    export ASDF_DATA_DIR="$HOME/.asdf"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi

# Check if mac
if [ "$(uname -s)" = "Darwin" ]; then
    # Add Docker Desktop for Mac (docker)
    export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"
fi

[ -f ~/.profile ] && source ~/.profile
export NVM_DIR="$HOME/.nvm"
[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ] && \. "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ] && \. "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
# If brew is installed then configure it
[ -f "$(which brew)" ] && eval "$($(which brew) shellenv)"
# If arm then alias brew to use x86_64
if [ "$(uname -m)" = "arm64" ]; then
    alias brew="arch --x86_64 /usr/local/bin/brew"
fi
# if pyenv is installed then configure it
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

export STAN_BACKEND=CMDSTANPY
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
alias brew86="arch --x86_64 /usr/local/bin/brew"


export ASDF_DATA_DIR='/Users/hknecht/.asdf'
export PATH='/shims:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/libpq/bin:/Users/hknecht/.nvm/versions/node/v20.19.2/bin:/Users/hknecht/.krew/bin:/opt/homebrew/Cellar/pyenv-virtualenv/1.2.4/shims:/Users/hknecht/.pyenv/shims:/opt/homebrew/opt/coreutils/libexec/gnuman:/opt/homebrew/opt/coreutils/libexec/gnubin:/Users/hknecht/.local/bin:/Users/hknecht/.dotfiles/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/pmk/env/global/bin:/usr/local/MacGPG2/bin:/Users/hknecht/golang/bin:/Applications/Docker.app/Contents/Resources/bin/:/Users/hknecht/.vscode/extensions/ms-python.debugpy-2025.14.1-darwin-arm64/bundled/scripts/noConfigScripts'
export PATH="/usr/local/opt/helm@3/bin:$PATH"
