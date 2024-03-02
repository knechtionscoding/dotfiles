export PATH="/home/hknecht/.local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PATH:/Users/hknecht/.asdf/shims:/opt/homebrew/opt/asdf/libexec/bin:/Users/hknecht/.krew/bin:/opt/homebrew/Cellar/pyenv-virtualenv/1.2.1/shims:/Users/hknecht/.pyenv/shims:/usr/local/opt/coreutils/libexec/gnuman:/usr/local/opt/coreutils/libexec/gnubin:/Users/hknecht/.local/bin:/Users/hknecht/.dotfiles/bin:/opt/homebrew/bin:/Users/hknecht/Library/Application:Support/cloud-code/installer/google-cloud-sdk/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/usr/local/MacGPG2/bin:/Users/hknecht/Library/Application:Support/cloud-code/installer/google-cloud-sdk/bin:/Users/hknecht/golang/bin"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
