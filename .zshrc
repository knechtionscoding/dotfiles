#!/bin/zsh

# Bootstrap PATH before anything else, including /etc/zshrc which may clobber it
case "$(uname -s 2>/dev/null || echo Linux)" in
  Darwin)
    export ASDF_DATA_DIR='/Users/hknecht/.asdf'
    export PATH='/shims:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/libpq/bin:/Users/hknecht/.nvm/versions/node/v20.19.2/bin:/Users/hknecht/.krew/bin:/opt/homebrew/Cellar/pyenv-virtualenv/1.2.4/shims:/Users/hknecht/.pyenv/shims:/opt/homebrew/opt/coreutils/libexec/gnuman:/opt/homebrew/opt/coreutils/libexec/gnubin:/Users/hknecht/.local/bin:/Users/hknecht/.dotfiles/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/pmk/env/global/bin:/usr/local/MacGPG2/bin:/Users/hknecht/golang/bin:/Applications/Docker.app/Contents/Resources/bin/:/Users/hknecht/.vscode/extensions/ms-python.debugpy-2025.14.1-darwin-arm64/bundled/scripts/noConfigScripts'
    export PATH="/usr/local/opt/helm@3/bin:$PATH"
    ;;
  *)
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
    export ASDF_DATA_DIR="$HOME/.asdf"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
    ;;
esac

[ -f /etc/zshrc ] && source /etc/zshrc

# Dotfiles data directory (used by dotfiles-first-run sentinel)
export DOTFILES_DATA="${HOME}/.local/share/dotfiles"
mkdir -p "${DOTFILES_DATA}"

export TELEPORT_AUTH=google
export TELEPORT_PROXY=anomalo.teleport.sh:443
export TELEPORT_USER=hans@anomalo.com

export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export AWS_REGION="us-west-2"
export CLAUDE_CODE_USE_BEDROCK="1"
export ANTHROPIC_DEFAULT_HAIKU_MODEL=arn:aws:bedrock:us-west-2:580663733917:application-inference-profile/wsoiwar1qd41
export ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME="Haiku 4.5 via Bedrock"
export ANTHROPIC_DEFAULT_HAIKU_MODEL_DESCRIPTION="Haiku 4.5 routed through a Bedrock inference profile"
export ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTED_CAPABILITIES="effort,thinking"
export ANTHROPIC_DEFAULT_SONNET_MODEL=arn:aws:bedrock:us-west-2:580663733917:application-inference-profile/chyv1tlre2il
export ANTHROPIC_DEFAULT_SONNET_MODEL_NAME="Sonnet 4.6 via Bedrock"
export ANTHROPIC_DEFAULT_SONNET_MODEL_DESCRIPTION="Sonnet 4.6 routed through a Bedrock inference profile"
export ANTHROPIC_DEFAULT_SONNET_MODEL_SUPPORTED_CAPABILITIES="effort,thinking,adaptive_thinking,interleaved_thinking"
export ANTHROPIC_DEFAULT_OPUS_MODEL=arn:aws:bedrock:us-west-2:580663733917:application-inference-profile/8a560zije806
export ANTHROPIC_DEFAULT_OPUS_MODEL_NAME="Opus 4.6 via Bedrock"
export ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION="Opus 4.6 routed through a Bedrock inference profile"
export ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES="effort,max_effort,thinking,adaptive_thinking,interleaved_thinking"

export ZSH_DISABLE_COMPFIX=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="clean"

plugins=(git kube-aliases dotenv aws terraform)

# Source oh-my-zsh (zsh only)
if [ -n "$ZSH_VERSION" ]; then
    [ -n "$ZSH" ] && source "$ZSH/oh-my-zsh.sh"
fi

[ -f ~/.dotfiles/shell/rc ] && source ~/.dotfiles/shell/rc

# Source fzf zsh integration (bypass type -t bashism by sourcing directly)
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh 2>/dev/null
fi

# krew configuration
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# GPG configuration (only when a TTY is available)
[ -t 0 ] && export GPG_TTY=$(tty)

# History control {{{
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"
HIST_STAMPS="yyyy-mm-dd"

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt APPEND_HISTORY
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
# }}}

# iTerm2 keymaps (Darwin only)
if [ "$(uname -s)" = "Darwin" ]; then
    bindkey -e
    bindkey '^[[1;5C' forward-word
    bindkey '^[[1;5D' backward-word
    bindkey '^[[1~' beginning-of-line
    bindkey '^[[4~' end-of-line
    bindkey '^[[H' beginning-of-line
    bindkey '^[[F' end-of-line
    bindkey '^[[3~' delete-char
    # Option+Backspace: configure iTerm2 to send hex 0x1b 0x18
    # More info: https://stackoverflow.com/a/29403520
fi

# kubectl completion
command -v kubectl &>/dev/null && source <(kubectl completion zsh)

# asdf configuration
if command -v asdf &>/dev/null; then
    export PATH="$HOME/bin:$PATH"
    export ASDF_DATA_DIR="$HOME/.asdf"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi

[ -f ~/.profile ] && source ~/.profile

# Darwin-only toolchain {{{
if [ "$(uname -s)" = "Darwin" ]; then
    # Docker Desktop
    export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

    # nvm via Homebrew
    export NVM_DIR="$HOME/.nvm"
    [ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ] && source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
    [ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ] && source "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"

    export STAN_BACKEND=CMDSTANPY
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi
# }}}

if [ -f "$HOME/.local/bin/env" ]; then
    source "$HOME/.local/bin/env"
fi


auto_activate_venv() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.venv/bin/activate" ]]; then
            [[ "$VIRTUAL_ENV" == "$dir/.venv" ]] && return
            source "$dir/.venv/bin/activate"
            return
        fi
        dir="$(dirname "$dir")"
    done
    [[ -n "$VIRTUAL_ENV" ]] && deactivate
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_activate_venv
auto_activate_venv

export PATH="$HOME/.local/bin:$PATH"
source ~/.safe-chain/scripts/init-posix.sh # Safe-chain bash initialization script
