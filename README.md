# Hans' Dotfiles

## Install Instructions

### Install Chrome

1. `Install Chrome`

### Configure SSH for Github

1. `ssh-keygen -q -t ed25519 -C "hans.knechtions@gmail.com" -N '' -f ~/.ssh/id_rsa`
1. `cat ~/.ssh/id_rsa_pub | pbcopy`
1. Put into github as an ssh key

### Install Software

1. `./install.sh`

### Configure GPG for Github

1. `gpg --full-generate-key`
    - (1) RSA and RSA
    - 0 = key does not expire
1. `gpg --list-secret-keys --keyid-format=long`
1. `gpg --armor --export <key-id> | pbcopy`
1. Put key into github
1. `git config --global user.signingkey <key-id>`
1. `git config --global commit.gpgsign true`
1. `echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf`